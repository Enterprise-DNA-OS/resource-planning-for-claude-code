# Record a person and their working calendar

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- add-person --name="<name>" --role="<business role>" --skills=data,reporting --hours=8 --days=1,2,3,4,5 --purpose="<retention purpose>" --review=2027-04-01 --actor="<operator>"
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. 

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
