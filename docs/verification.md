# Verification

9 October 2026. npm install and npm test passed on Linux with Node 22 and PGlite. All 31 CLI commands are exercised. There are 32 slash recipes, including /customise and /new-view.

The suite checks migration and seed idempotence, work calendars, daily conflicts, tentative allocations, staffing matches, cancellation and request reopening, absence cancellation, actual-hour limits, retention reviews, append-only activity, dry runs, atomic import rollback, changed and duplicate source records, three allocation modes, private export content, document rendering and CLI JSON/error behavior.

[GitHub Actions run 37875702563](https://github.com/Enterprise-DNA-OS/resource-planning-for-claude-code/actions/runs/37875702563) passed on Windows and Linux with Node 20 and 22, plus Postgres 17. npm run demo passed on all four platform and Node combinations. No vendor account or customer CSV was used. The import fixture is fictional.
