# Check retention reviews and internal capacity rules

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- compliance
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. Read docs/compliance.md. Explain each rule and its limits. The result is a list of review prompts, not a compliance certificate.

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
