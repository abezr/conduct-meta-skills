---
name: conduct
description: Use this skill to orchestrate multi-agent coding workflows with a controller session, implementer sessions, read-only review sessions, context transfer, budget guards, Copilot premium-request routing, quality gates, and post-run knowledge preservation.
---

# Conduct

Use this skill when coordinating multi-agent coding sessions across a project.

Supported providers:
- Claude Code as controller or implementer.
- OpenAI Codex as implementer, reviewer, or context keeper.
- GitHub Copilot as optional IDE, PR-review, Spark, cloud-agent, or third-party-agent adapter.

## Activation

Activate when the user asks to conduct/orchestrate agents, coordinate Claude/Codex/Copilot, run background coding workflows, preserve context, avoid wasting tokens/premium requests, route long tasks, or quality-check a conducted task.

## Runtime requirements

Requires Bash, `.conduct/`, provider CLIs configured externally if used, and `.conduct/limits.json`.

## Self-check

```bash
bash .agents/skills/conduct/scripts/conduct.sh self-check
bash .agents/skills/quality-check/scripts/quality_check.sh self-check
```

## Procedure

### Step 1. Normalize the task

Action:
- Convert request into project key, task id, outcome, constraints, and risk.

Key point:
- Separate desired outcome from first implementation idea.

Why:
- Agents waste context when optimizing for the first visible solution.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh init-task <project-key> <task-id>
```

### Step 2. Audit existing system

Action:
- Inspect skills, agents, AGENTS.md/CLAUDE.md, and `.conduct/`.

Automation:
```bash
bash .agents/skills/quality-check/scripts/quality_check.sh audit .
```

### Step 3. Route by economics and control

Action:
- Choose Copilot, Claude, Codex, or mixed route.

Key point:
- Copilot can be economical for one coherent large session; Claude/Codex are often better for tight steering, ambiguity, and small tasks.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh route-recommend app_or_feature 250000 4 1 low normal
```

### Step 4. Check budget

Action:
- Check local ledger and official provider usage when available.

Key point:
- Local ledger is a guardrail, not a billing source of truth.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh budget-check github_copilot cloud_agent 0 1 0 normal
```

### Step 5. Plan before risky action

Action:
- Ask implementer for a plan before changes on large/high-risk tasks.

Checklist:
- Acceptance criteria.
- Likely files.
- Validation commands.
- Rollback notes.
- Reviewer adapter.

### Step 6. Act with bounded implementer

Action:
- Run one bounded implementation session with clear scope, stop conditions, and final report.

Checklist:
- `TASK.md`, `ROUTING_DECISION.md`, `PLAN.md` available.
- Retry limit set.
- `FINAL.md` required.
- `DIFF_SUMMARY.md` if files changed.
- `FAILURE_BRIEF.md` if unfinished.

### Step 7. Review read-only

Action:
- Review diff, logs, and final report with a read-only reviewer.

Key point:
- Reviewer must not modify files unless promoted.

### Step 8. Quality gate before done

Action:
- Apply conducted-task quality gate.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh quality-gate <project-key> <task-id>
```

### Step 9. Compact context

Action:
- Update durable context files.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh compact <project-key>
```

### Step 10. Preserve new skill after struggle

Action:
- Create `SKILL_CANDIDATE.md` and invoke `create-skill-meta`.

Automation:
```bash
bash .agents/skills/conduct/scripts/conduct.sh preserve-skill <project-key> <task-id>
```


### Fitness-function routing rule

Action:
- Before choosing Copilot, Claude, or Codex, identify the cheapest reliable fitness functions for the task.

Key point:
- Do not route based only on implementation cost; route based on implementation plus verification cost.

Why:
- A cheap autonomous implementation becomes expensive if its result requires broad manual repair.

Checklist:
- Native project commands are known.
- Cross-boundary manual checks are known.
- Expensive checks are reserved for high-risk tasks.
- Copilot large-session tasks have post-run review fitness functions.
- Claude/Codex token-window tasks have incremental fitness functions.

## Copilot routing summary

Prefer Copilot large-session mode when task is one coherent app/feature/refactor, expected Claude/Codex token burn is high, steering can be batched upfront, one autonomous branch/PR is acceptable, post-run review is acceptable, and premium-call budget is healthier than token/window budget.

Prefer Claude/Codex when task needs tight interactive steering, is small/localized, requires restricted local access, spans multiple repos, needs controller wake-up behavior, or would require many Copilot steering comments.

## Quality Check

Use `quality-check` for system audit, conducted-task done gate, skill preservation quality, and drift audit after updating skills/agents/instructions.

## Definition of done

A conducted task is done when goal, routing, budget, plan if needed, implementation report, review, validation/deployment logs, quality gate, context updates, and skill preservation are complete.

## References

- [Routing policy](./references/routing_policy.md)
- [Copilot session economics](./references/copilot_session_economics.md)
- [Budget and limits policy](./references/budget_and_limits_policy.md)
- [Context transfer protocol](./references/context_transfer_protocol.md)
- [Skill preservation protocol](./references/skill_preservation_protocol.md)
- [Conduct quality gate](../quality-check/references/conduct_quality_gate.md)

## Fitness functions reference

- [Fitness Functions Discovery and Definition](../quality-check/references/fitness_functions_discovery.md)
