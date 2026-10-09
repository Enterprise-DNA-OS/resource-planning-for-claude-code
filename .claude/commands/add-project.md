# Open a project with an owner and hours budget

Read CLAUDE.md. Fetch current records before answering. Run:

```bash
npm run plan -- add-project --name="<name>" --client="<client>" --owner="<owner>" --budget-hours=160 --actor="<operator>"
```

All examples with angle brackets require a real value. Add --json for structured output. Names match without case sensitivity, or use an unambiguous id prefix. If matching is ambiguous, show candidates and ask the operator to choose. Never invent facts, hours or decisions. 

Mutations require --actor and support --dry-run. Actor is attribution, not a verified identity. Drafts stay local. Nothing sends.
