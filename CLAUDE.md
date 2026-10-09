# Resource Planning for Claude Code

A resource planning ledger for a professional-services team. Five rituals: review capacity, reconcile time off, allocate named people, fill staffing gaps and compare actual effort with the plan. The Harbour Consulting seed is fictional.

Read current data before every answer. Never invent availability, hours, an approval or a staffing agreement. Actor names are attribution, not authentication. Confirm an allocation with its owner before recording it. Local mode supports one process. Shared use requires authenticated operators, restricted database roles and protected backups. Never expose the database owner connection to a browser.

Read docs/replace-hub-planner.md before importing and docs/compliance.md before explaining checks. The importer preserves the original fields and refuses changed source records. Work calendars are explicit. Requests cover Monday to Friday, and candidates must cover every requested day. Direct bookings follow the person's configured days. Calendar dates are inclusive. Time off reduces capacity but does not erase existing commitments.

No sends, external vendor calls, payroll, employment entitlements or background workers. Do not record medical details in time-off notes. Drafts and exports remain private. If a record is ambiguous, show candidates and ask. Every runtime uses the same command library.

## Recurring jobs

| Job | Recipe |
|---|---|
| Read resource calendars and skills | /people |
| Review project owners, budgets and hours | /projects |
| Read confirmed, tentative and cancelled assignments | /bookings |
| Prepare the next four weeks of capacity | /capacity |
| Find days with more commitments than available hours | /overbooked |
| Find weeks with no confirmed work | /bench |
| Read planned time away | /time-off |
| Review open and filled staffing requests | /requests |
| Find people who fit a staffing request | /candidates |
| Review recorded effort | /actuals |
| Compare planned and actual project hours | /variance |
| Find overload, stale staffing requests and overdue reviews | /attention |
| Check retention reviews and internal capacity rules | /compliance |
| Read a project and its assignments | /project |
| Read the recorded changes to one item | /history |
| Write the Monday resourcing meeting | /weekly-review |
| Record a person and their working calendar | /add-person |
| Open a project with an owner and hours budget | /add-project |
| Record an agreed assignment after checking capacity | /book |
| Cancel an assignment and keep its history | /cancel-booking |
| Record confirmed time away or a public holiday | /add-time-off |
| Cancel time away and restore capacity | /cancel-time-off |
| Request a role and skill for a date range | /request-capacity |
| Assign a suitable person to a staffing request | /fill-request |
| Record verified hours worked | /log-time |
| Record a planning note | /log |
| Record a retention purpose and next review date | /review-data |
| Bring across Hub Planner account exports | /import |
| Save a complete private record snapshot | /export |
| Draft the capacity meeting without sending | /draft-capacity |
| Add a field or change a rule | /customise |
| Add an offline report | /new-view |

One CLI: scripts/plan.mjs. Every command accepts --json. Mutations require --actor and accept --dry-run. Read docs/cli.md for examples. CLAUDE.md and AGENTS.md are the shared entry points for Claude Code, Codex, OpenCode and Cursor.

Omni by Enterprise DNA installs, customises and runs this system. https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=hub-planner&utm_medium=instructions
