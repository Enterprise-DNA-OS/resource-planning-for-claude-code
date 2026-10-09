# Bring Hub Planner records across

Checked 9 October 2026. Hub Planner is now presented as Resource Flow on Milient's website. Its [account export instructions](https://help.hubplanner.com/kb/hub-planner-trial/) describe an account owner exporting resources, projects, time entries and bookings as separate CSV files through Settings, Manage Projects, Add New Projects | Bookings, Add Multiple Bookings, then Reference Files. The [scheduler help](https://help.hubplanner.com/kb/scheduler-customization-hints-tips-settings/) also documents CSV and spreadsheet downloads. Use the account entity exports, not a grouped summary report.

## One import command

Keep the source files private. Save the resource, project and booking files as resources.csv, projects.csv and bookings.csv in imports/hub-planner. Inspect their headings. Supply calendars.json, keyed by each source resource ID, with hours, days, business role, skills, purpose and review date. examples/hub-planner contains a fictional fixture showing the shape. It is not a vendor-exported customer file. Use examples/mapping.json when your export uses different column labels.

The calendar file is deliberate: an access role such as ROLE_OWNER is not a staffing role, and the account exports alone do not establish everyone's daily availability. Reconcile working days, part-time hours, holidays and time off with the source before using the plan.

Use a fresh DATA_DIR, migrate without seed, then:

```bash
npm run plan -- import hub-planner --dir=imports/hub-planner --actor="Morgan" --dry-run
npm run plan -- import hub-planner --dir=imports/hub-planner --actor="Morgan"
```

Add --mapping=examples/mapping.json to either command when needed. The first is a complete transactional rehearsal. A bad later row rolls back earlier inserts. Duplicate source IDs and unknown references fail. Repeating identical files is a no-op. Changed source rows fail and require reconciliation rather than overwriting local planning decisions. Source IDs and all original columns remain in source_data. One directory is for one Hub Planner account.

## What maps

| Export | Destination |
|---|---|
| Resource ID, first and last name, source status | Person with explicit calendar and business role from calendars.json |
| Project ID, name, source status, optional client, owner and hours budget | Project register |
| Booking ID, resource ID, project ID, start, end, allDay, state, stateValue, type and note | Assignment with original fields preserved |

Heading aliases also accept the vendor's documented property names, including _id. Mapping keys are listed in examples/mapping.json. Booking allocation semantics follow the [vendor booking model](https://github.com/hubplanner/API/blob/master/Sections/bookings.md): daily minutes convert to hours, percentages use the explicit person's daily hours, and total minutes spread over configured working days. Hours round to four decimal places. Reconcile the tiny rounding difference for total-hour allocations. Inclusive dates and configured workdays are the local calculation convention; compare source totals before relying on them.

Scheduled and approved types become confirmed allocations. Pending types become tentative. Rejected types are preserved as cancelled. Source approval types are context, not recreated approval identities or legal evidence. Active resources are bookable; other supported source statuses remain inactive. Unknown states and missing IDs fail. Hourly bookings and recurring rules are rejected: map or expand them separately before import. The free import handles explicit all-day allocations only.

## What needs separate migration

Time entries, time off, public-holiday calendars, custom availability, booking rates, historical rate changes, attachments, access permissions, approval history, invoices and integrations are not imported by this command. Keep those exports and reconcile them separately. Custom columns are retained as original data, not turned into active business rules. The free base records actual hours and time off locally once reconciled. Enterprise DNA scopes broader migration and connections as part of the customised version.

## Trial before switching

Compare source IDs and counts, names, dates, statuses and booked-hour totals. Check one part-time person, one percentage booking, one total-hours booking and one leave overlap. Produce a project resource plan and compare it with the source. Run both processes for an agreed trial. Switch-in-a-day is a supported record-import trial, not a promise to reproduce every Hub Planner feature or migrate every account in a day.
