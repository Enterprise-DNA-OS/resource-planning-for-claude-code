create function touch_updated() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
create table people (
 id uuid primary key default gen_random_uuid(), source_id text unique, name text not null check(length(trim(name))>0),
 role text not null, skills text[] not null default '{}', daily_hours numeric(6,2) not null check(daily_hours>0 and daily_hours<=24),
 work_days int[] not null default '{1,2,3,4,5}' check(cardinality(work_days)>0 and work_days <@ array[1,2,3,4,5,6,7]),
 active boolean not null default true, retention_purpose text not null default '', review_on date,
 source_data jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table projects (
 id uuid primary key default gen_random_uuid(), source_id text unique, name text not null check(length(trim(name))>0), client text not null default '',
 owner text not null default '', budget_hours numeric(12,2) check(budget_hours>=0), status text not null default 'active' check(status in ('active','tentative','closed')),
 source_data jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table bookings (
 id uuid primary key default gen_random_uuid(), source_id text unique, person_id uuid not null references people, project_id uuid not null references projects,
 start_on date not null, end_on date not null, daily_hours numeric(8,4) not null check(daily_hours>0 and daily_hours<=24),
 status text not null default 'confirmed' check(status in ('confirmed','tentative','cancelled')), note text not null default '',
 source_data jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 check(end_on>=start_on and end_on-start_on<=730)
);
create index bookings_dates on bookings(person_id,start_on,end_on);
create table absences (
 id uuid primary key default gen_random_uuid(), person_id uuid not null references people, start_on date not null, end_on date not null,
 daily_hours numeric(6,2) not null check(daily_hours>0 and daily_hours<=24), note text not null default '',
 status text not null default 'active' check(status in ('active','cancelled')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(end_on>=start_on and end_on-start_on<=730)
);
create table requests (
 id uuid primary key default gen_random_uuid(), project_id uuid not null references projects, role text not null, skill text not null default '',
 start_on date not null, end_on date not null, daily_hours numeric(6,2) not null check(daily_hours>0 and daily_hours<=24), owner text not null,
 status text not null default 'open' check(status in ('open','filled')), booking_id uuid references bookings,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(end_on>=start_on and end_on-start_on<=730)
);
create table actuals (
 id uuid primary key default gen_random_uuid(), source_id text unique, person_id uuid not null references people, project_id uuid not null references projects,
 worked_on date not null, hours numeric(6,2) not null check(hours>0 and hours<=24), note text not null,
 source_data jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table activity (
 id uuid primary key default gen_random_uuid(), entity_id uuid not null, actor text not null check(length(trim(actor))>0), action text not null, detail jsonb not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create function immutable_activity() returns trigger language plpgsql as $$ begin raise exception 'Activity is append-only'; end $$;
create trigger activity_immutable before update or delete on activity for each row execute function immutable_activity();
do $$ declare t text; begin foreach t in array array['people','projects','bookings','absences','requests','actuals'] loop
 execute format('create trigger touch before update on %I for each row execute function touch_updated()',t);
 end loop;
 foreach t in array array['people','projects','bookings','absences','requests','actuals','activity'] loop
 execute format('alter table %I enable row level security',t); execute format('revoke all on %I from public',t);
 end loop; end $$;
-- Inclusive calendar dates, only the person's configured work days contribute hours.
create view booking_days with (security_invoker=true) as
 select b.id booking_id,b.person_id,b.project_id,d::date work_date,b.daily_hours,b.status
 from bookings b join people p on p.id=b.person_id
 cross join lateral generate_series(b.start_on::timestamp,b.end_on::timestamp,interval '1 day') d
 where extract(isodow from d)::int=any(p.work_days) and b.status<>'cancelled';
create function capacity_between(first_day date,last_day date) returns table (
 person_id uuid, name text, role text, work_date date, capacity_hours numeric, confirmed_hours numeric, tentative_hours numeric, free_hours numeric
) language sql stable security invoker as $$
 with days as (
 select p.id,p.name,p.role,d::date work_date,
 greatest(0,p.daily_hours-coalesce((select sum(a.daily_hours) from absences a where a.person_id=p.id and a.status='active' and d::date between a.start_on and a.end_on),0)) capacity_hours
 from people p cross join lateral generate_series(first_day::timestamp,last_day::timestamp,interval '1 day') d
 where p.active and extract(isodow from d)::int=any(p.work_days)
 ), totals as (
 select x.*,coalesce(sum(b.daily_hours) filter(where b.status='confirmed'),0) confirmed_hours,
 coalesce(sum(b.daily_hours) filter(where b.status='tentative'),0) tentative_hours
 from days x left join bookings b on b.person_id=x.id and x.work_date between b.start_on and b.end_on and b.status<>'cancelled'
 group by x.id,x.name,x.role,x.work_date,x.capacity_hours
 ) select id,name,role,work_date,capacity_hours,confirmed_hours,tentative_hours,capacity_hours-confirmed_hours from totals
$$;
create view capacity_next_month with(security_invoker=true) as select * from capacity_between(current_date,current_date+27);
create view resource_week with(security_invoker=true) as
 select person_id,name,role,date_trunc('week',work_date)::date week,sum(capacity_hours) capacity_hours,sum(confirmed_hours) confirmed_hours,
 sum(tentative_hours) tentative_hours,sum(free_hours) free_hours,min(free_hours) worst_day_free_hours
 from capacity_next_month group by person_id,name,role,date_trunc('week',work_date);
create view request_queue with(security_invoker=true) as
 select q.id,p.name project,q.role,q.skill,q.start_on,q.end_on,q.daily_hours,q.owner,q.status,q.booking_id,
 (current_date-q.start_on) days_past_start from requests q join projects p on p.id=q.project_id;
create view project_totals with(security_invoker=true) as
 select p.id,p.name,p.client,p.owner,p.status,p.budget_hours,
 coalesce((select sum(d.daily_hours) from booking_days d where d.project_id=p.id and d.status='confirmed'),0) planned_hours,
 coalesce((select sum(d.daily_hours) from booking_days d where d.project_id=p.id and d.status='confirmed' and d.work_date<=current_date),0) planned_to_date,
 coalesce((select sum(a.hours) from actuals a where a.project_id=p.id and a.worked_on<=current_date),0) actual_to_date,
 p.budget_hours-coalesce((select sum(a.hours) from actuals a where a.project_id=p.id),0) budget_remaining
 from projects p;
create view record_checks with(security_invoker=true) as
 select 'IPP9-review' rule,id entity_id,name subject,'Review purpose and retention date' finding from people
 where retention_purpose='' or review_on is null or review_on<=current_date
 union all select 'INTERNAL-owner',id,name,'Project has no responsible owner' from projects where status<>'closed' and owner=''
 union all select 'INTERNAL-capacity',person_id,name,'Confirmed work exceeds available hours on '||work_date::text from capacity_next_month where free_hours<0
 union all select 'INTERNAL-stale-request',id,project,'Staffing request has passed its start date' from request_queue where status='open' and start_on<current_date;
revoke all on booking_days,capacity_next_month,resource_week,request_queue,project_totals,record_checks from public;
