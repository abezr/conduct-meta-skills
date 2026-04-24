---
name: quality-check
description: Use this skill to evaluate, lint, or regression-test AI skills, agent teams, conduct workflows, or prompt-based operating procedures before publishing, after modifying, after failed runs, or when checking trigger behavior, baseline improvement, drift, or readiness.
---

# Quality Check

Use this skill to make quality evaluation a first-class part of skill and agent workflow development.

This combines:
- SOP/TWI structural checks.
- Harness-style trigger testing, near-miss cases, with-skill vs without-skill evals, and drift checks.
- Operational checks from `conduct`: route, budget, review, validation, handoff, and learning preservation.

## Activation

Activate when asked to:
- check quality;
- validate a skill;
- test trigger behavior;
- compare with-skill vs without-skill output;
- run a dry-run;
- audit skill/agent drift;
- verify a conducted task is complete.

## Runtime requirements

Requires:
- Bash.
- Repository-local `.agents/skills/` or another skill path.
- Write access to `references/evals/` for eval templates.

## Self-check

```bash
bash .agents/skills/quality-check/scripts/quality_check.sh self-check
```

Expected:

```text
OK: quality-check runtime is available
```


## Markdown-first quality model

Quality checks are defined in Markdown first.

Scripts are optional convenience adapters, not mandatory infrastructure.

Use scripts only when:
- the target project already has the required runtime;
- the check is deterministic enough to automate;
- automation reduces repeated human or agent effort;
- the script can be maintained by the project team.

For projects without Python, use the project's native verification surface instead:
- Go: `go test ./...`, `go vet ./...`
- Node: `npm test`, `npm run build`, `npm run lint`
- .NET: `dotnet test`, `dotnet build`
- Java: `mvn test`, `gradle test`
- Rust: `cargo test`, `cargo clippy`
- Docs/infrastructure: manual review checklist, link check, policy check, CI-native tooling

## Fitness Functions

Before judging a skill or conducted task, define its fitness functions.

Action:
- Create or update `references/fitness_functions.md` for the target skill or workflow.

Key point:
- Prefer cross-boundary checks over existence checks.

Why:
- Many defects happen at integration seams while local files still look correct.

Reference:
- [Fitness Functions Discovery and Definition](./references/fitness_functions_discovery.md)

## Procedure

### Step 1. Identify target

Action:
- Determine whether the target is a skill, agent team, orchestrator workflow, conducted task, or project instruction set.

Key point:
- Do not use one generic checklist for all target types.

Why:
- A skill can be structurally valid while its trigger is poor.

### Step 2. Static structure check

Action:
- Check required files and sections.

Automation:
```bash
bash .agents/skills/quality-check/scripts/quality_check.sh lint .agents/skills/<skill-name>
```

Checklist:
- `SKILL.md` exists.
- Frontmatter has `name` and `description`.
- Activation/Trigger section exists.
- Runtime/self-check exists when tools/scripts are used.
- Procedure/workflow exists.
- Quality Check or Definition of done exists.

### Step 3. Trigger evaluation

Action:
- Create should-trigger, should-not-trigger, and near-miss cases.

Automation:
```bash
bash .agents/skills/quality-check/scripts/quality_check.sh init .agents/skills/<skill-name>
bash .agents/skills/quality-check/scripts/quality_check.sh check-evals .agents/skills/<skill-name>
```

Checklist:
- At least 5 should-trigger cases.
- At least 5 should-not-trigger cases.
- At least 3 near-miss cases.

### Step 4. Baseline comparison

Action:
- Compare the same task without the skill and with the skill.

Key point:
- A skill is only useful if it improves outcome enough to justify context and maintenance cost.

Checklist:
- Baseline output captured.
- With-skill output captured.
- Acceptance criteria explicit.
- Correctness, completeness, validation, tool usage, clarification behavior, and edge cases scored.

### Step 5. Dry-run with uninformed executor

Action:
- Agent B executes the skill without hidden context.

Key point:
- Experts unconsciously fill gaps; fresh executors reveal missing instructions.

### Step 6. Drift audit

Action:
- Re-run checks after changes to skills, agents, AGENTS.md/CLAUDE.md, or repo conventions.

Automation:
```bash
bash .agents/skills/quality-check/scripts/quality_check.sh audit .
```

### Step 7. Produce report

Action:
- Write `QUALITY_REPORT.md` with pass/fail, blockers, important findings, optional findings, and next action.

## Conduct task quality gate

A conducted task passes only if:
- routing decision exists;
- budget check passed or conservative mode was used;
- plan exists for large/high-risk task;
- implementation final report exists;
- read-only review exists or was explicitly waived;
- validation/deployment logs are captured;
- context files were updated;
- repeated failures produced `SKILL_CANDIDATE.md`;
- no unresolved blocker remains.

## Definition of done

Quality check passes when:
- no structural blocker remains;
- trigger and near-miss cases are documented;
- baseline comparison exists for important skills;
- runtime self-check is runnable;
- dry-run gaps are fixed or tracked;
- drift risks are documented;
- report states pass/fail and next action.

## References

- [Quality lifecycle](./references/quality_lifecycle.md)
- [Trigger evaluation protocol](./references/trigger_eval_protocol.md)
- [Baseline comparison protocol](./references/baseline_comparison_protocol.md)
- [Drift audit protocol](./references/drift_audit_protocol.md)
- [Conduct quality gate](./references/conduct_quality_gate.md)
