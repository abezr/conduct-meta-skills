# Quality Lifecycle

## Lifecycle

1. Audit existing system.
2. Design or modify skill.
3. Run static lint.
4. Run trigger eval.
5. Run near-miss eval.
6. Run with-skill vs without-skill comparison for important skills.
7. Dry-run with an uninformed executor.
8. Patch gaps.
9. Record change history.
10. Re-check drift after future changes.

## Audit existing system

Before creating a skill, inspect:

- `.agents/skills/`
- `.claude/skills/`
- `.claude/agents/`
- `AGENTS.md`
- `CLAUDE.md`
- `.conduct/`
