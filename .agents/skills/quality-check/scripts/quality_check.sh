#!/usr/bin/env bash
set -u
cmd="${1:-}"
case "$cmd" in
  self-check)
    echo "OK: quality-check runtime is available"
    ;;
  audit)
    root="${2:-.}"
    echo "# Skill/Agent System Audit"
    for p in ".agents/skills" ".claude/skills" ".claude/agents" "AGENTS.md" "CLAUDE.md" ".conduct"; do
      if [ -e "$root/$p" ]; then echo "- $p: present"; else echo "- $p: missing"; fi
    done
    ;;
  init)
    skill_path="${2:-}"
    [ -n "$skill_path" ] || { echo "Usage: quality_check.sh init <skill-path>" >&2; exit 2; }
    eval_dir="$skill_path/references/evals"
    mkdir -p "$eval_dir"
    for f in should_trigger.md should_not_trigger.md near_miss.md baseline_comparison.md dry_run_report.md QUALITY_REPORT.md FITNESS_FUNCTIONS.md; do
      [ -f "$eval_dir/$f" ] || cp ".agents/skills/quality-check/templates/$f" "$eval_dir/$f" 2>/dev/null || printf '# %s\n' "$f" > "$eval_dir/$f"
    done
    echo "OK: initialized eval templates at $eval_dir"
    ;;
  lint)
    skill_path="${2:-}"
    file="$skill_path/SKILL.md"
    [ -f "$file" ] || { echo "FAIL: missing $file"; exit 2; }
    grep -q '^---' "$file" || echo "WARN: missing frontmatter"
    grep -qi '^## Activation\|^## Trigger' "$file" || echo "FAIL: missing Activation/Trigger section"
    grep -qi '^## Procedure' "$file" || echo "FAIL: missing Procedure section"
    grep -qi '^## Quality Check\|^## Definition of done' "$file" || echo "WARN: missing Quality Check / Definition of done"
    echo "OK: static skill lint completed"
    ;;
  check-evals)
    skill_path="${2:-}"
    eval_dir="$skill_path/references/evals"
    [ -d "$eval_dir" ] || { echo "FAIL: missing $eval_dir"; exit 2; }
    for f in should_trigger.md should_not_trigger.md near_miss.md baseline_comparison.md; do
      [ -f "$eval_dir/$f" ] || { echo "FAIL: missing $eval_dir/$f"; exit 2; }
    done
    echo "OK: eval files are present"
    ;;
  *)
    echo "Usage: quality_check.sh {self-check|audit|init|lint|check-evals}" >&2
    exit 2
    ;;
esac
