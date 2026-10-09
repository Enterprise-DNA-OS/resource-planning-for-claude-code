# Add a read-only planning view

Read CLAUDE.md and views.json. Ask which decision the report must support. Inspect records through the CLI, then add a read-only query to views.json with a clear title and period. Use security-invoker views in a new migration if needed. Run npm run view and inspect the generated HTML. Reconcile the totals with the CLI. Keep confidential fields out unless the operator needs them. This is an offline report, not an interactive scheduling app.
