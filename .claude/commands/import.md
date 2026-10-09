# Bring across Hub Planner account exports

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- import hub-planner --dir=imports/hub-planner --actor="<operator>" --dry-run
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. Read docs/replace-hub-planner.md first. Check the source counts, headings and calendars. Run the test import first. Resolve every error before running the same command without --dry-run. Reconcile booked hours, dates, calendars and time off. Do not infer source approval identities.

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
