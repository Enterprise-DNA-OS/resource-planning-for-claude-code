# Record verified hours worked

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- log-time --person="<person>" --project="<project>" --date=2026-10-08 --hours=4 --note="<work performed>" --actor="<operator>"
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. 

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
