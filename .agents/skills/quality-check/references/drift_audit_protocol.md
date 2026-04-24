# Drift Audit Protocol

Detect when skills, agents, and project instructions no longer agree.

Audit sources:

- `.agents/skills/*/SKILL.md`
- `.claude/skills/*/SKILL.md`
- `.claude/agents/*.md`
- `AGENTS.md`
- `CLAUDE.md`
- `.conduct/projects/*/LESSONS.md`
- `.conduct/projects/*/DECISIONS.md`

Drift signals:

- two skills claim the same trigger;
- AGENTS.md contradicts a skill;
- a skill references missing scripts;
- runtime requirements do not match the repo;
- lessons from failures were not propagated;
- changed project conventions did not update relevant skills.
