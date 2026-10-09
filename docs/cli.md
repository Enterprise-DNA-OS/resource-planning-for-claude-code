# Planning commands

Node 20 or later. Run npm run migrate and npm run seed for the fictional demo. For real records, use a fresh DATA_DIR and migrate without seed. Read README.md first. Every command accepts --json. Mutations require --actor and accept --dry-run, which rolls the database transaction back. No mutation sends or calls a vendor.

Names are case-insensitive. An exact name wins if unique, then substring matching and id prefixes apply. Multiple matches exit 1 and print candidates. Flags use --key=value. Dates use YYYY-MM-DD. Hours are decimal hours per working day unless stated otherwise. Start and end dates are inclusive. All examples below are examples, not instructions to write those dates.

## people

Read resource calendars and skills

```bash
npm run plan -- people
```

## projects

Review project owners, budgets and hours

```bash
npm run plan -- projects
```

## bookings

Read confirmed, tentative and cancelled assignments

```bash
npm run plan -- bookings
```

## capacity

Prepare the next four weeks of capacity

```bash
npm run plan -- capacity
```

## overbooked

Find days with more commitments than available hours

```bash
npm run plan -- overbooked
```

## bench

Find weeks with no confirmed work

```bash
npm run plan -- bench
```

## time-off

Read planned time away

```bash
npm run plan -- time-off
```

## requests

Review open and filled staffing requests

```bash
npm run plan -- requests
```

## candidates

Find people who fit a staffing request

```bash
npm run plan -- candidates --request="<request id>"
```

## actuals

Review recorded effort

```bash
npm run plan -- actuals
```

## variance

Compare planned and actual project hours

```bash
npm run plan -- variance
```

## attention

Find overload, stale staffing requests and overdue reviews

```bash
npm run plan -- attention
```

## compliance

Check retention reviews and internal capacity rules

```bash
npm run plan -- compliance
```

## project

Read a project and its assignments

```bash
npm run plan -- project --project="<project name or id>"
```

## history

Read the recorded changes to one item

```bash
npm run plan -- history --kind=projects --id="<project id>"
```

## weekly-review

Write the Monday resourcing meeting

```bash
npm run plan -- weekly-review
```

## add-person

Record a person and their working calendar

```bash
npm run plan -- add-person --name="<name>" --role="<business role>" --skills=data,reporting --hours=8 --days=1,2,3,4,5 --purpose="<retention purpose>" --review=2027-04-01 --actor="<operator>"
```

## add-project

Open a project with an owner and hours budget

```bash
npm run plan -- add-project --name="<name>" --client="<client>" --owner="<owner>" --budget-hours=160 --actor="<operator>"
```

## book

Record an agreed assignment after checking capacity

```bash
npm run plan -- book --person="<person>" --project="<project>" --start=2026-10-12 --end=2026-10-16 --hours=4 --status=confirmed --note="<agreement>" --actor="<operator>"
```

## cancel-booking

Cancel an assignment and keep its history

```bash
npm run plan -- cancel-booking --booking="<id>" --reason="<reason>" --actor="<operator>"
```

## add-time-off

Record confirmed time away or a public holiday

```bash
npm run plan -- add-time-off --person="<person>" --start=2026-10-12 --end=2026-10-12 --hours=8 --note="<brief reason>" --actor="<operator>"
```

## cancel-time-off

Cancel time away and restore capacity

```bash
npm run plan -- cancel-time-off --absence="<id>" --reason="<reason>" --actor="<operator>"
```

## request-capacity

Request a role and skill for a date range

```bash
npm run plan -- request-capacity --project="<project>" --role=Analyst --skill=reporting --start=2026-10-12 --end=2026-10-16 --hours=4 --owner="<owner>" --actor="<operator>"
```

## fill-request

Assign a suitable person to a staffing request

```bash
npm run plan -- fill-request --request="<id>" --person="<person>" --note="<owner confirmation>" --actor="<operator>"
```

## log-time

Record verified hours worked

```bash
npm run plan -- log-time --person="<person>" --project="<project>" --date=2026-10-08 --hours=4 --note="<work performed>" --actor="<operator>"
```

## log

Record a planning note

```bash
npm run plan -- log --kind=projects --id="<id>" --note="<note>" --actor="<operator>"
```

## review-data

Record a retention purpose and next review date

```bash
npm run plan -- review-data --person="<person>" --purpose="<purpose>" --review=2027-04-01 --actor="<operator>"
```

## import

Bring across Hub Planner account exports

```bash
npm run plan -- import hub-planner --dir=imports/hub-planner --actor="<operator>" --dry-run
```

## export

Save a complete private record snapshot

```bash
npm run plan -- export
```

## draft-capacity

Draft the capacity meeting without sending

```bash
npm run plan -- draft-capacity
```

## Calculation rules

A person's calendar holds constant daily hours and ISO weekday numbers (Monday 1 to Sunday 7). Direct bookings use that calendar. Staffing requests cover every weekday Monday to Friday in their date range. Matching requires the named role, skill and sufficient capacity on every requested day. Weekend-working calendars are excluded from staffing matching; use direct bookings for those schedules. A partial first or last week only contains days in the next 28 calendar days. Free hours subtract confirmed work. Tentative work stays separate. Minimum free hours exposes daily peaks hidden by weekly totals.

Time off sums across overlapping entries and is capped at the person's daily capacity. Cancel and replace a mistaken absence. Existing work stays visible after time off is added, so the next attention check shows conflicts. New confirmed work cannot exceed daily capacity. Imported source overload remains visible for reconciliation. New tentative bookings do not reserve capacity. Cancelling an assignment reopens a linked staffing request.

Variance compares recorded actual hours through today with confirmed planned hours through today, including today's full allocation. It does not claim all timesheets have been submitted. Budget remaining subtracts all recorded actuals. Missing budgets remain empty. Actuals reject future dates and daily totals above 24 hours. They do not calculate pay, overtime or leave entitlements.

Calendars are constant over history in this base. A change needs an effective-dated calendar migration through /customise and reconciliation. Holidays must be entered as time off for each person. There is no automatic public-holiday feed or time-of-day overlap detection.

Export creates a new JSON file in exports/ with all seven record collections. It is not a vendor import file or an automatic restore. Use a tested database backup process for production recovery. Draft-capacity creates a private meeting pack in drafts/ and never sends it.
