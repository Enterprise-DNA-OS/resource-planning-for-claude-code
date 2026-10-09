# Resource Planning for Claude Code

Know who can take the work, which days no longer fit and which projects are using more hours than planned. An MIT-licensed resource planning database and command set. Works with Claude Code, Codex, OpenCode or Cursor.

| Do it yourself | We customise it | We run it for you |
|---|---|---|
| Free. Try the demo and import Hub Planner account records. | Your fields, calendars, rules, history, web front end or different stack. | Installed, connected and operated through Omni by Enterprise DNA. One setup fee, then a retainer. |
| [Quick start](#quick-start) | [Get your version built](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=hub-planner&utm_medium=customise) | [Book a call](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=hub-planner&utm_medium=managed) |

## The Monday capacity meeting

Five rituals: review available hours, reconcile time off, allocate named people, fill staffing gaps and compare actual effort with the plan. The fictional Harbour Consulting demo includes competing commitments, a part-time analyst on leave, tentative work, an overdue staffing request and a retention review.

## Quick start

Node 20 or later on Windows or Linux:

```bash
git clone https://github.com/Enterprise-DNA-OS/resource-planning-for-claude-code.git
cd resource-planning-for-claude-code
npm install
npm run demo
npm test
npm run view
npm run docs
npm run plan -- candidates --request=50000000
```

The embedded PGlite database runs in .data/db. DATABASE_URL selects Postgres 15 or later with verified TLS. Local mode supports one process. For real records, select a fresh DATA_DIR and migrate without seeding. Keep fictional demo records separate. Shared use requires authenticated operators, restricted database roles and protected backups. The actor label records attribution, not identity verification.

31 CLI commands including help and 32 slash recipes. [CLI reference](docs/cli.md).

## Hours that mean what they say

Direct bookings follow each person's configured workdays. Time off reduces capacity while leaving existing commitments visible. Confirmed and tentative allocations stay separate. The capacity report shows weekly totals and the worst individual day's headroom. New confirmed bookings that exceed daily availability are refused. Cancelling a filled request's booking reopens the staffing request.

Staffing requests cover Monday to Friday in the requested range. A candidate must cover every requested day, match the role and skill, and have enough confirmed headroom. The report also shows tentative commitments. A shortlist is not an agreement to do the work. Dates are inclusive and daily hours are uniform across a person's configured workdays. This base does not schedule time-of-day slots, calculate pay or track leave entitlements.

## Ten questions beyond a fixed report

Hub Planner offers reporting and capacity tools. These are questions the shipped queries answer, not unsupported claims that the incumbent cannot answer them.

1. Which days are overloaded even when the weekly total looks manageable? `overbooked`
2. Who fits the required skill and every weekday of an open staffing request? `candidates --request=50000000`
3. Whose confirmed work clashes with recorded time off? `overbooked`
4. Where do tentative assignments consume the apparent spare capacity? `capacity`
5. Which people have whole weeks without confirmed work? `bench`
6. Which staffing requests are already past their start date? `requests`
7. Which requests have been untouched for a week? `attention`
8. Which projects have recorded more hours than planned through today? `variance`
9. Who has an overdue review of why we retain their personal records? `compliance`
10. What was changed on an assignment, by whom and with what explanation? `history --kind=bookings --id=<id>`

## Your first hour: ten things to ask for

1. Put our business name, logo and colours on the project plan.
2. Show which days are overloaded.
3. Separate tentative work from committed work.
4. Find someone who can take the reporting request.
5. Record the time away the team has agreed.
6. Draft our Monday capacity meeting.
7. Check our export before importing it.
8. Reconcile a part-time person's hours with the source.
9. Add our delivery location through /customise.
10. Add a client capacity report through /new-view.

## Paperwork and reports

brand.json controls business name, logo and colours. npm run docs produces project resource plans and staffing request briefs. npm run view produces the capacity meeting and staffing reports. They are read-only HTML snapshots, suitable for printing to PDF. Drafts stay in drafts/. Reports and exports contain private business records.

[Record checks](docs/compliance.md) cover retention-review prompts, missing project owners, daily overload and overdue staffing requests. [Why no front end](docs/why-no-front-end.md) explains how interactive timelines, mobile access and live shared scheduling fit a customised version.

## Move from Hub Planner

Hub Planner now appears as Resource Flow on Milient's website. [The replacement guide](docs/replace-hub-planner.md) covers its CSV exports, explicit calendar mapping, supported allocation types, a dry run, repeat imports and reconciliation. The importer takes resource, project and all-day booking records in one command after their headings and calendars are mapped. It preserves original fields, refuses unknown states and leaves changed source records for review. Time entries, time off, holidays, rates, attachments and approval history need separate migration. Nothing calls or changes Hub Planner.

## Verification

npm test uses a temporary database and exercises every CLI command. It checks daily capacity, partial calendars, staffing, cancellation, actual-hour validation, attributed history, import rollback, duplicate and changed source records, all three allocation modes, exports, documents and reports. CI runs on Windows and Linux and against disposable Postgres. [Results](docs/verification.md).

MIT licence. Not affiliated with Hub Planner, Milient or Anthropic. Hosting and coding-agent use carry their own costs. [Sources and target selection](docs/research.md). [Book 30 minutes with Sam](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=hub-planner&utm_medium=readme).
