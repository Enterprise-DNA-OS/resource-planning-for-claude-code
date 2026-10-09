import fs from 'node:fs';
import path from 'node:path';
import {parseCsv,pick} from './csv.mjs';
import {required,number,date,workDays,insert,audit} from '../plan.mjs';

// Account exports vary by configuration. Mapping names a source heading for a canonical field.
// Calendars and business roles are explicit, never guessed from Hub Planner permission roles.
export async function importHubPlanner(db,o,actor){
 const dir=path.resolve(required(o,'dir'));
 const calendars=JSON.parse(fs.readFileSync(path.join(dir,'calendars.json'),'utf8'));
 const mapping=o.mapping?JSON.parse(fs.readFileSync(o.mapping,'utf8')):{};
 const stats={inserted:0,unchanged:0,entities:{}};
 const field=(row,kind,key,...aliases)=>{const custom=mapping[kind]?.[key];return custom?pick(row,custom):pick(row,key,...aliases);};
 const need=(v,k)=>{if(!String(v).trim())throw Error(`Import requires ${k}`);return String(v).trim();};
 const rows=(kind,optional=false)=>{const file=path.join(dir,`${kind}.csv`);if(optional&&!fs.existsSync(file))return[];const data=parseCsv(fs.readFileSync(file,'utf8'));const ids=new Set();for(const row of data){const id=need(field(row,kind,'id','_id',`${kind==='resources'?'Resource':kind==='projects'?'Project':'Booking'} ID`),'unique source id');if(ids.has(id))throw Error(`Duplicate source id in ${kind}: ${id}`);ids.add(id);}return data;};
 const save=async(t,id,data,source)=>{const raw=JSON.stringify(source);const old=(await db.query(`select * from ${t} where source_id=$1`,[id]))[0];if(old){const [{same}]=await db.query(`select source_data=$2::jsonb same from ${t} where id=$1`,[old.id,raw]);if(!same)throw Error(`Changed source ${t}/${id}: reconcile before re-import; existing records are protected`);stats.unchanged++;return old;}const record=await insert(db,t,{...data,source_id:id,source_data:raw});await audit(db,record.id,actor,'import-hub-planner',{source_id:id,collection:t});stats.inserted++;return record;};
 const resourceRows=rows('resources'),projectRows=rows('projects'),bookingRows=rows('bookings');
 const people=new Map(),projects=new Map();
 for(const row of resourceRows){const id=field(row,'resources','id','_id','Resource ID');const c=calendars[id];if(!c)throw Error(`Calendar and business role required for resource ${id}`);const name=field(row,'resources','name','Resource Name')||[field(row,'resources','firstName','First Name'),field(row,'resources','lastName','Last Name')].filter(Boolean).join(' ');
 const status=need(field(row,'resources','status','Status'),'resource status');if(!['STATUS_ACTIVE','STATUS_ARCHIVED','STATUS_NON_BOOKABLE','STATUS_PARKED'].includes(status))throw Error(`Unknown resource status ${status}`);
 const p=await save('people',id,{name:need(name,'resource name'),role:need(c.role,'business role'),skills:(c.skills||[]).map(s=>s.toLowerCase()),daily_hours:number(c.hours,'calendar hours',0.01,24),work_days:workDays(need(c.days,'calendar work days')),active:status==='STATUS_ACTIVE',retention_purpose:c.purpose||'',review_on:c.review?date(c.review):null},{row,calendar:c});people.set(id,p);}
 for(const row of projectRows){const id=field(row,'projects','id','_id','Project ID');const status=need(field(row,'projects','status','Status'),'project status');const statuses={STATUS_ACTIVE:'active',STATUS_ARCHIVED:'closed',STATUS_PENDING:'tentative',STATUS_PLANNED:'tentative',STATUS_FLOATING:'tentative'};if(!statuses[status])throw Error(`Unknown project status ${status}`);const budget=field(row,'projects','budget_hours','Budget Hours');const p=await save('projects',id,{name:need(field(row,'projects','name','Project Name'),'project name'),client:field(row,'projects','client','Client'),owner:field(row,'projects','owner','Owner'),budget_hours:budget?number(budget,'budget hours'):null,status:statuses[status]},row);projects.set(id,p);}
 for(const row of bookingRows){const id=field(row,'bookings','id','_id','Booking ID'),p=people.get(field(row,'bookings','resource','Resource ID')),j=projects.get(field(row,'bookings','project','Project ID'));if(!p||!j)throw Error(`Unresolved resource or project in booking ${id}`);
 const allDay=field(row,'bookings','allDay','All Day');if(!['true','1','yes'].includes(allDay.toLowerCase()))throw Error(`Booking ${id}: only explicitly all-day bookings supported; map hourly bookings separately`);
 const repeat=field(row,'bookings','repeat');if(repeat&& !['false','0','no'].includes(repeat.toLowerCase()))throw Error(`Booking ${id}: expand recurring bookings before import`);
 const a=need(field(row,'bookings','start','Start Date'),'booking start'),b=need(field(row,'bookings','end','End Date'),'booking end');const start=date(a.slice(0,10)),end=date(b.slice(0,10));if(end<start||(Date.parse(end)-Date.parse(start))/86400000>730)throw Error('Invalid booking date range');
 const state=field(row,'bookings','state','State'),value=number(field(row,'bookings','stateValue','State Value'),'booking allocation',0.0001,1e7);
 let days=0;for(let d=Date.parse(start);d<=Date.parse(end);d+=86400000){if(p.work_days.includes(new Date(d).getUTCDay()||7))days++;}if(!days)throw Error(`Booking ${id} has no configured working days`);
 let hours;if(state==='STATE_DAY_MINUTE')hours=value/60;else if(state==='STATE_PERCENTAGE')hours=Number(p.daily_hours)*value/100;else if(state==='STATE_TOTAL_MINUTE')hours=value/60/days;else throw Error(`Unsupported booking state ${state}`);
 hours=number(Number(hours.toFixed(4)),'daily allocation',0.0001,24);
 const type=need(field(row,'bookings','type','Type'),'booking type'),types={SCHEDULED:'confirmed',APPROVED:'confirmed',WAITING_FOR_APPROVAL:'tentative',REJECTED:'cancelled'};if(!types[type])throw Error(`Unknown booking type ${type}`);
 await save('bookings',id,{person_id:p.id,project_id:j.id,start_on:start,end_on:end,daily_hours:hours,status:types[type],note:field(row,'bookings','note','Note')},row);
 }
 stats.entities={resources:resourceRows.length,projects:projectRows.length,bookings:bookingRows.length};
 // Imported over-allocation is source evidence, not a reason to discard the history.
 stats.overbooked_days=(await db.query('select count(*)::int n from capacity_next_month where free_hours<0'))[0].n;
 stats.note='Reconcile calendars, time off and totals before operational use. Timesheets, holidays, rates and approvals are not imported.';
 return stats;
}
