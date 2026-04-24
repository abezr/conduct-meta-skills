# Conduct + Create Skill Meta + Quality Check Bundle

Unpack this archive directly into the root of your repository.

It adds:

```text
.agents/
  skills/
    create-skill-meta/
    conduct/
    quality-check/
```

## Best-of-both approach

From SOP/TWI:
- point-of-use checklists;
- step → key point → why;
- runtime self-checks;
- dry-run with an uninformed executor;
- failure → reusable skill/checklist/script.

From harness-style skill architecture:
- audit before creating;
- agent = who, skill = how, orchestrator = when/order;
- trigger engineering;
- should-trigger and should-not-trigger evals;
- near-miss cases;
- with-skill vs without-skill baseline comparison;
- drift audit after changes.

From conduct:
- multi-provider orchestration;
- Claude/Codex/Copilot routing;
- Copilot premium-request economics;
- local budget ledger;
- context transfer;
- quality gate before done.

## Quick start

```bash
bash .agents/skills/quality-check/scripts/quality_check.sh self-check
bash .agents/skills/conduct/scripts/conduct.sh self-check
bash .agents/skills/quality-check/scripts/quality_check.sh audit .
bash .agents/skills/quality-check/scripts/quality_check.sh init .agents/skills/conduct
bash .agents/skills/quality-check/scripts/quality_check.sh lint .agents/skills/conduct
bash .agents/skills/conduct/scripts/conduct.sh init-task demo task-001
bash .agents/skills/conduct/scripts/conduct.sh quality-gate demo task-001
```

The local ledger is a guardrail, not a provider billing source of truth.

## Fitness functions update

Quality is Markdown-first.

The bundle defines fitness functions as project-specific invariants and checks before adding optional scripts. This makes the skills usable in projects that do not use Python.

Key files:

```text
.agents/skills/quality-check/references/fitness_functions_discovery.md
.agents/skills/quality-check/templates/FITNESS_FUNCTIONS.md
.agents/skills/create-skill-meta/references/fitness_functions_discovery.md
```

Use scripts only as optional adapters for deterministic checks or when the project already supports that runtime.
