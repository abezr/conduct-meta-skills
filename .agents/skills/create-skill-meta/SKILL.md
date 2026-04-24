---
name: create-skill-meta
description: Use this skill when the user asks to create, write, design, review, or improve an AI skill, or when a failed agent run should be preserved as a reusable skill, checklist, script, or AGENTS.md update.
---

# Create Skill Meta-Skill

Use this skill to design reliable AI skills as executable operating procedures, not generic documentation.

This combines:
- SOP/TWI reliability: point-of-use checklists, step → key point → why, self-checks, dry-runs.
- Harness-style architecture: audit before creating, agent/skill/orchestrator separation, trigger engineering, evals, drift repair.
- Quality-first lifecycle: every new or changed skill must pass `quality-check`.

## Activation

Activate when the user asks to create, write, design, review, improve, package, or preserve a skill.

Strong phrases:
- `create a skill`
- `write a skill`
- `design a skill`
- `make a skill`
- `turn this into a skill`
- `package this as a skill`
- `review this skill`
- `improve this skill`
- `preserve this lesson as a skill`

## Procedure

### Step 1. Audit before creating

Action:
- Check `.agents/skills/`, `.claude/skills/`, `.claude/agents/`, `AGENTS.md`, `CLAUDE.md`, and `.conduct/`.

Key point:
- Prefer updating the existing system over adding duplicate skills.

Why:
- Skill sprawl causes over-triggering, contradictions, and context waste.

Checklist:
- Existing skills identified.
- Existing agents identified.
- Project instruction files identified.
- Overlap and drift documented.

### Step 2. Choose the right artifact

Action:
- Decide whether to create a skill, agent role, orchestrator workflow, project instruction, or validation script.

Key point:
- Agent = who. Skill = how. Orchestrator = when/order.

Why:
- Mixing these into one document makes execution brittle.

### Step 3. Design the trigger

Action:
- Write a strong frontmatter `description` and explicit Activation section.

Key point:
- Include both should-trigger and should-not-trigger boundaries.

Why:
- The description is the main routing surface.

### Step 4. Write executable procedure

Action:
- For every critical step, use action → key point → why.

Key point:
- Put checklists where the risk occurs.

Why:
- Skills use progressive disclosure; the model may not read distant general notes.

### Step 5. Add runtime and self-check

Action:
- List dependencies and define a self-check command.

Key point:
- Anything deterministic should become a script.

Why:
- Runtime-incompatible skills are silently bypassed or improvised around.

### Step 6. Quality-check the skill

Action:
- Initialize and run the `quality-check` skill.

Automation:
```bash
bash .agents/skills/quality-check/scripts/quality_check.sh init .agents/skills/<skill-name>
bash .agents/skills/quality-check/scripts/quality_check.sh lint .agents/skills/<skill-name>
```

Checklist:
- Static structure passes.
- Trigger evals exist.
- Near-miss evals exist.
- Baseline comparison exists for important skills.
- Dry-run gaps are fixed or tracked.

## Definition of done

A skill is ready only if:
- trigger and near-miss boundaries are clear;
- point-of-use checklists exist;
- critical steps use action → key point → why;
- deterministic checks are scripted when possible;
- runtime requirements and self-check exist;
- trigger and near-miss evals exist;
- with-skill vs without-skill comparison exists for important skills;
- dry-run was performed or explicitly deferred;
- known failure modes are documented near the relevant step.

## References

- [SOP/TWI reliability pattern](./references/meta_skill_sop_toyota_twi.md)
- [Quality lifecycle](../quality-check/references/quality_lifecycle.md)
- [Trigger evaluation protocol](../quality-check/references/trigger_eval_protocol.md)
- [Baseline comparison protocol](../quality-check/references/baseline_comparison_protocol.md)


## Fitness Functions Discovery

Before finalizing any new skill, define how its success will be checked.

Action:
- Discover and document project-specific fitness functions before writing the final procedure.

Key point:
- Define checks in Markdown first. Scripts are optional adapters, not the default source of truth.

Why:
- A skill should fit Go, Node, .NET, Java, Python, infrastructure, and documentation-only projects without forcing an unrelated runtime.

Checklist:
- Identify producer/consumer boundaries.
- Identify native project commands.
- Identify manual cross-boundary checks.
- Classify each check by strength: manual checklist, structured review, native command, custom script, CI.
- Put each check at the point of use.
- Add a `## Fitness Functions` section or link `references/fitness_functions.md`.

Reference:
- [Fitness Functions Discovery and Definition](./references/fitness_functions_discovery.md)
