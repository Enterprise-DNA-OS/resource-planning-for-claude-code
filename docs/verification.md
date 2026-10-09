# Verification

9 October 2026. npm install and npm test passed on Linux with Node 22 and PGlite. All 31 CLI commands are exercised. There are 32 slash recipes, including /customise and /new-view.

The suite checks migration and seed idempotence, work calendars, daily conflicts, tentative allocations, staffing matches, cancellation and request reopening, absence cancellation, actual-hour limits, retention reviews, append-only activity, dry runs, atomic import rollback, changed and duplicate source records, three allocation modes, private export content, document rendering and CLI JSON/error behavior.

Windows and Postgres verification will be recorded after the private repository CI finishes. No vendor account or customer CSV was used. The import fixture is fictional.
