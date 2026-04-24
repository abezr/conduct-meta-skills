# Conduct Meta Skills

Reusable repository skills for multi-agent coding workflows, skill creation, and quality gates.

## Included skills

```text
.agents/
  skills/
    create-skill-meta/
    conduct/
    quality-check/
```

## Purpose

This repository packages three complementary skills:

- `create-skill-meta`: creates reliable executable skills using SOP/TWI principles, trigger engineering, dry-runs, and fitness-function discovery.
- `conduct`: orchestrates multi-agent coding workflows across Claude Code, OpenAI Codex, and optionally GitHub Copilot, with context transfer, budget guards, routing, and stop-loss rules.
- `quality-check`: validates skills and conducted tasks using Markdown-first quality gates, trigger evals, near-miss cases, baseline comparison, drift audit, and fitness functions.

## Quick start

Copy `.agents/skills/` into a repository that should use these skills.

Then run, from that repository root:

```bash
bash .agents/skills/quality-check/scripts/quality_check.sh self-check
bash .agents/skills/conduct/scripts/conduct.sh self-check
```

## Fitness functions

Quality is Markdown-first.

Define project-specific fitness functions before adding optional scripts:

```text
.agents/skills/quality-check/references/fitness_functions_discovery.md
.agents/skills/quality-check/templates/FITNESS_FUNCTIONS.md
```

Scripts are optional adapters. Prefer project-native commands such as:

- Go: `go test ./...`
- Node: `npm test`, `npm run build`
- .NET: `dotnet test`, `dotnet build`
- Java: `mvn test`, `gradle test`
- Rust: `cargo test`, `cargo clippy`

## GitHub upload

If you have GitHub CLI configured:

```bash
gh repo create abezr/conduct-meta-skills --public --source . --remote origin --push
```

Use `--private` instead of `--public` if preferred.
