# Fitness Functions Discovery and Definition

## Purpose

Use this reference whenever creating or improving a skill.

A skill should not only describe how to work. It should define how to know that the work was good.

A fitness function is a project-specific, repeatable check that tells whether the skill is improving the system. It can be manual, semi-automated, or fully automated.

## Markdown-first rule

Fitness functions are defined in Markdown first.

Scripts are optional adapters.

This keeps the skill usable in projects written in any stack:

- Go
- Node.js
- .NET
- Java
- Python
- mobile
- infrastructure
- documentation-only repositories

Do not require Python, JavaScript, Bash, or any runtime unless the target project already has it or the user explicitly accepts adding it.

## What counts as a fitness function

A fitness function can be:

- a checklist item;
- a review assertion;
- a cross-file consistency check;
- a command already native to the project;
- a CI check;
- a typecheck/build/test/lint command;
- a manual inspection protocol;
- a schema/API contract comparison;
- an architectural invariant;
- a budget or context-transfer invariant.

## Discovery phase

### Step 1. Identify system boundaries

Action:
- List the producer/consumer boundaries touched by the skill.

Key point:
- Focus on integration seams, not only local correctness.

Why:
- Many failures happen when two individually correct pieces do not agree.

Examples:
- API response ↔ frontend hook/type.
- Route file path ↔ href/router.push.
- State transition map ↔ actual status updates.
- DB schema ↔ API DTO ↔ UI type.
- CLI output ↔ parser.
- Config file ↔ runtime environment.
- Prompt contract ↔ agent final report.

### Step 2. Identify native verification commands

Action:
- Prefer commands already present in the repo.

Key point:
- Do not introduce Python just to run quality checks in a non-Python project.

Why:
- A skill should fit the project runtime instead of forcing a new one.

Examples:
- Node: `npm test`, `npm run build`, `npm run lint`, `pnpm typecheck`.
- .NET: `dotnet test`, `dotnet build`, `dotnet format --verify-no-changes`.
- Go: `go test ./...`, `go vet ./...`.
- Java: `mvn test`, `gradle test`.
- Rust: `cargo test`, `cargo clippy`.
- Docs: markdown lint, link check, manual review checklist.

### Step 3. Identify non-command checks

Action:
- Define manual or review-based checks when automation is not reliable.

Key point:
- Some of the best checks are cross-comparisons that a reviewer or QA agent performs by reading both sides.

Why:
- Build success often misses runtime contract mismatches.

Examples:
- Compare API response shape with client expectation.
- Compare documented workflow with actual scripts.
- Compare route links with file-system routes.
- Compare generated output with acceptance criteria.
- Compare agent handoff with current TODO and decisions.

### Step 4. Classify checks by strength

Use this classification:

```text
Level 0: intuition only
Level 1: manual checklist
Level 2: structured review assertion
Level 3: native project command
Level 4: custom deterministic script
Level 5: CI-enforced invariant
```

Prefer the highest level that is cheap and natural for the project.

### Step 5. Put checks at the point of use

Action:
- Attach each fitness function to the step where failure would happen.

Key point:
- Do not place all checks only at the end.

Why:
- Late QA allows defects to accumulate and makes root cause harder to find.

## Definition phase

For each fitness function, define:

```markdown
## Fitness function: <name>

Purpose:
- <what failure this catches>

Applies when:
- <when to run it>

Type:
- [ ] manual checklist
- [ ] structured review
- [ ] native project command
- [ ] custom script
- [ ] CI check

Native command or procedure:
```bash
<command, if any>
```

Expected result:
- <observable pass condition>

Failure means:
- <what is likely wrong>

Owner:
- <controller / implementer / reviewer / context keeper / QA>

Cost:
- low / medium / high

Run frequency:
- before action / after module / before final answer / before merge / nightly / on demand
```

## Cross-boundary fitness functions

When a skill touches multiple components, include at least one cross-boundary fitness function.

Examples:

### API ↔ client contract

Pass condition:
- The API response shape matches the client type and unwrap logic.

### Routing coherence

Pass condition:
- Every internal link or router navigation maps to an existing route.

### State-machine coherence

Pass condition:
- Every status update is allowed by the transition map, and every required transition is reachable.

### Data naming coherence

Pass condition:
- DB fields, API DTO fields, and UI fields consistently handle naming conventions and nullability.

### Agent handoff coherence

Pass condition:
- `HANDOFF.md`, `TODO.md`, `DECISIONS.md`, and latest `FINAL.md` agree on the next action.

## Fitness function discovery checklist

Before finishing a new skill, answer:

- What can go wrong even if each local step is correct?
- Which files or modules must be read together?
- Which existing commands already verify part of the result?
- Which checks should be manual because automation would be brittle?
- Which check should be promoted to a script later?
- Which check belongs in CI?
- Which check is cheap enough to run every time?
- Which check is expensive and should be reserved for high-risk tasks?
- Which check prevents the most expensive rework?

## Output requirement for new skills

Every new or updated skill should include either:

1. A `## Fitness Functions` section in `SKILL.md`, or
2. A linked `references/fitness_functions.md`, or
3. A clear explanation why no fitness function is useful for this skill.

## Anti-patterns

Bad:
- Require Python checks for a .NET or Go project without need.
- Define only end-of-process QA.
- Check only that files exist, not that boundaries agree.
- Use vague checks like “verify quality.”
- Add scripts before defining the invariant in English.

Good:
- Define the invariant in Markdown.
- Use project-native commands.
- Add scripts only when they reduce repeated human or agent effort.
- Keep manual cross-boundary review for checks that need judgment.
