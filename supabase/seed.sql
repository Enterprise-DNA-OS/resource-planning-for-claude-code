insert into people(id,name,role,skills,daily_hours,retention_purpose,review_on) values
 ('10000000-0000-4000-8000-000000000001','Mere Wilson','Analyst','{data,workshops}',8,'Delivery planning',current_date+180),
 ('10000000-0000-4000-8000-000000000002','Aroha Singh','Analyst','{data,reporting}',6,'Delivery planning',current_date+180),
 ('10000000-0000-4000-8000-000000000003','Tom Fraser','Engineer','{integration,data}',8,'Delivery planning',current_date-14),
 ('10000000-0000-4000-8000-000000000004','Casey Morgan','Analyst','{data,reporting}',8,'Delivery planning',current_date+180)
 on conflict do nothing;
insert into projects(id,name,client,owner,budget_hours) values
 ('20000000-0000-4000-8000-000000000001','Harbour data review','Harbour Foods','Mere',160),
 ('20000000-0000-4000-8000-000000000002','Estuary reporting','Estuary Logistics','Tom',80),
 ('20000000-0000-4000-8000-000000000003','Kauri integration','Kauri Consulting','',120) on conflict do nothing;
insert into bookings(id,person_id,project_id,start_on,end_on,daily_hours,status,note) values
 ('30000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001',current_date-7,current_date+14,6,'confirmed','Client workshop preparation'),
 ('30000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000002',current_date,current_date+7,4,'confirmed','Competing commitment'),
 ('30000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001',current_date,current_date+14,3,'confirmed','Part-time analyst'),
 ('30000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000003',current_date,current_date+14,6,'tentative','Not yet committed') on conflict do nothing;
insert into absences(id,person_id,start_on,end_on,daily_hours,note) values
 ('40000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000002',current_date,current_date+7,6,'Approved time away') on conflict do nothing;
insert into requests(id,project_id,role,skill,start_on,end_on,daily_hours,owner,created_at,updated_at) values
 ('50000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000002','Analyst','reporting',current_date-3,current_date+10,4,'Tom',now()-interval '14 days',now()-interval '14 days') on conflict do nothing;
insert into actuals(id,person_id,project_id,worked_on,hours,note) values
 ('60000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001',current_date-1,7,'Workshop and preparation') on conflict do nothing;
