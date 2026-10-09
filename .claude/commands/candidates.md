# Find people who fit a staffing request

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- candidates --request="<request id>"
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. Show minimum daily headroom and tentative commitments. Requests cover every Monday to Friday in the range. A candidate is a planning option, not an agreement to do the work.

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
