#!/usr/bin/env bash
set -u
cmd="${1:-}"
state=".conduct"
ledger="$state/ledger.jsonl"
ensure_state() {
  mkdir -p "$state"
  touch "$ledger"
  if [ ! -f "$state/limits.json" ] && [ -f ".agents/skills/conduct/templates/limits.example.json" ]; then
    cp ".agents/skills/conduct/templates/limits.example.json" "$state/limits.json"
  fi
}
now() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
record() { ensure_state; printf '{"timestamp":"%s",%s}\n' "$(now)" "$1" >> "$ledger"; }
case "$cmd" in
  self-check)
    ensure_state
    echo "OK: conduct runtime is available"
    echo "State: $state"
    ;;
  init-task)
    project="${2:-}"; task="${3:-}"
    [ -n "$project" ] && [ -n "$task" ] || { echo "Usage: conduct.sh init-task <project> <task>" >&2; exit 2; }
    ensure_state
    dir="$state/projects/$project/sessions/$task"
    mkdir -p "$dir" "$state/projects/$project"
    for f in TASK.md ROUTING_DECISION.md PLAN.md FINAL.md REVIEW.md FAILURE_BRIEF.md QUALITY_REPORT.md SKILL_CANDIDATE.md; do
      [ -f "$dir/$f" ] || cp ".agents/skills/conduct/templates/$f" "$dir/$f"
    done
    for f in PROJECT_CONTEXT.md TODO.md DECISIONS.md LESSONS.md HANDOFF.md; do
      [ -f "$state/projects/$project/$f" ] || printf '# %s\n' "$f" > "$state/projects/$project/$f"
    done
    record '"event":"init-task","project":"'"$project"'","task":"'"$task"'","status":"ok"'
    echo "OK: initialized $dir"
    ;;
  route-recommend)
    task_class="${2:-}"; est_tokens="${3:-0}"; est_sessions="${4:-1}"; est_premium="${5:-1}"; steering="${6:-medium}"; risk="${7:-normal}"
    route="claude_codex_token_window"; why="task likely needs tighter steering or is too small for Copilot amortization"
    if { [ "$task_class" = "app_or_feature" ] || [ "$task_class" = "broad_refactor" ] || [ "$task_class" = "backlog_nice_to_have" ]; } && { [ "$est_tokens" -ge 180000 ] || [ "$est_sessions" -ge 3 ]; } && [ "$steering" = "low" ]; then
      if [ "$risk" = "high" ] || [ "$risk" = "critical" ]; then
        route="mixed_plan_copilot_review"; why="large coherent task, but risk requires plan-first and strong review"
      else
        route="copilot_large_session"; why="large coherent task with low steering; premium-call amortization may beat multi-session token burn"
      fi
    elif [ "$task_class" = "ambiguous_design" ]; then
      route="readonly_plan_only"; why="ambiguous task should be clarified before expensive execution"
    fi
    record '"event":"route-recommend","selected_route":"'"$route"'","task_class":"'"$task_class"'","estimated_tokens":'"$est_tokens"',"estimated_sessions":'"$est_sessions"',"estimated_premium_calls":'"$est_premium"',"risk":"'"$risk"'"'
    echo "$route"
    echo "Why: $why"
    ;;
  budget-check)
    provider="${2:-}"; role="${3:-}"; est_tokens="${4:-0}"; premium_calls="${5:-0}"; steering_comments="${6:-0}"; risk="${7:-normal}"
    ensure_state
    status="ok"
    if [ "$provider" = "github_copilot" ] && [ "$risk" != "low" ]; then
      echo "WARN: verify official Copilot premium-request balance before heavy actions"
    fi
    record '"event":"budget-check","provider":"'"$provider"'","role":"'"$role"'","status":"'"$status"'","estimated_tokens":'"$est_tokens"',"premium_calls":'"$premium_calls"',"steering_comments":'"$steering_comments"''
    echo "OK: budget check recorded"
    ;;
  quality-gate)
    project="${2:-}"; task="${3:-}"
    dir="$state/projects/$project/sessions/$task"
    missing=0
    for f in TASK.md ROUTING_DECISION.md FINAL.md QUALITY_REPORT.md; do
      if [ ! -f "$dir/$f" ]; then echo "FAIL: missing $dir/$f"; missing=1; fi
    done
    [ "$missing" -eq 0 ] || exit 2
    [ -f "$dir/REVIEW.md" ] || echo "WARN: REVIEW.md missing; acceptable only if explicitly waived"
    [ -f "$dir/PLAN.md" ] || echo "WARN: PLAN.md missing; acceptable only for small/low-risk task"
    record '"event":"quality-gate","project":"'"$project"'","task":"'"$task"'","status":"ok"'
    echo "OK: conducted task quality gate completed"
    ;;
  compact)
    project="${2:-}"
    ensure_state; mkdir -p "$state/projects/$project"
    printf '\n## Compact checkpoint %s\n- Update context from latest session reports.\n' "$(now)" >> "$state/projects/$project/HANDOFF.md"
    record '"event":"compact","project":"'"$project"'","status":"ok"'
    echo "OK: checkpoint added"
    ;;
  preserve-skill)
    project="${2:-}"; task="${3:-}"
    dir="$state/projects/$project/sessions/$task"
    mkdir -p "$dir"
    [ -f "$dir/SKILL_CANDIDATE.md" ] || cp ".agents/skills/conduct/templates/SKILL_CANDIDATE.md" "$dir/SKILL_CANDIDATE.md"
    record '"event":"preserve-skill","project":"'"$project"'","task":"'"$task"'","status":"candidate-created"'
    echo "OK: skill candidate ready at $dir/SKILL_CANDIDATE.md"
    ;;
  *)
    echo "Usage: conduct.sh {self-check|init-task|route-recommend|budget-check|quality-gate|compact|preserve-skill}" >&2
    exit 2
    ;;
esac
