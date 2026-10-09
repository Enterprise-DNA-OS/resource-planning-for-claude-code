# Cancel an assignment and keep its history

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- cancel-booking --booking="<id>" --reason="<reason>" --actor="<operator>"
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions.  Read existing bookings, time off and history before the change. Replace the example dates and hours with the actual instruction. A daily booking has no time-of-day slots. Confirm who agreed the allocation in the note.

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
