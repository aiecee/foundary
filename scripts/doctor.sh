#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH=""
CHECK_INSTALLED=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_PATH="${2:-}"
      shift 2
      ;;
    --check-installed)
      CHECK_INSTALLED=1
      shift
      ;;
    *)
      echo "Usage: $0 [--project <path>] [--check-installed]"
      exit 1
      ;;
  esac
done

pass_count=0
warn_count=0
fail_count=0

report() {
  local level="$1"
  local message="$2"
  echo "$level: $message"
  case "$level" in
    PASS) pass_count=$((pass_count + 1)) ;;
    WARN) warn_count=$((warn_count + 1)) ;;
    FAIL) fail_count=$((fail_count + 1)) ;;
  esac
}

check_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    report PASS "File exists: $path"
  else
    report FAIL "File missing: $path"
  fi
}

check_link() {
  local path="$1"
  local expected="$2"
  if [[ ! -L "$path" ]]; then
    report FAIL "Symlink missing: $path"
    return
  fi

  local current
  current="$(readlink "$path")"
  if [[ "$current" == "$expected" ]]; then
    report PASS "Symlink OK: $path -> $expected"
  else
    report FAIL "Symlink mismatch: $path -> $current (expected $expected)"
  fi
}

check_installed_link() {
  local path="$1"
  local expected="$2"
  local label="$3"

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    report WARN "$label not installed: $path"
    return
  fi

  if [[ ! -L "$path" ]]; then
    report FAIL "$label exists but is not a symlink: $path"
    return
  fi

  local current
  current="$(readlink "$path")"
  if [[ "$current" == "$expected" ]]; then
    report PASS "$label installed link OK: $path -> $expected"
  else
    report FAIL "$label installed link mismatch: $path -> $current (expected $expected)"
  fi
}

check_file "$REPO_ROOT/core/AGENTS.md"
check_file "$REPO_ROOT/core/skills/spec/SKILL.md"
check_file "$REPO_ROOT/core/skills/plan/SKILL.md"
check_file "$REPO_ROOT/core/skills/build/SKILL.md"
check_file "$REPO_ROOT/core/skills/commit/SKILL.md"
check_file "$REPO_ROOT/integrations/codex/plugins/foundary/.codex-plugin/plugin.json"

check_file "$REPO_ROOT/scripts/install/claude.sh"
check_file "$REPO_ROOT/scripts/install/codex.sh"
check_file "$REPO_ROOT/scripts/install/cursor.sh"
check_file "$REPO_ROOT/scripts/install/cline.sh"
check_file "$REPO_ROOT/scripts/install/all.sh"
check_file "$REPO_ROOT/scripts/install/uninstall.sh"

check_link "$REPO_ROOT/integrations/codex/AGENTS.md" "../../core/AGENTS.md"
check_link "$REPO_ROOT/integrations/claude/CLAUDE.md" "../../core/AGENTS.md"
check_link "$REPO_ROOT/integrations/cursor/AGENTS.md" "../../core/AGENTS.md"
check_link "$REPO_ROOT/integrations/cline/AGENTS.md" "../../core/AGENTS.md"

check_link "$REPO_ROOT/integrations/codex/plugins/foundary/skills/spec" "../../../../../core/skills/spec"
check_link "$REPO_ROOT/integrations/codex/plugins/foundary/skills/plan" "../../../../../core/skills/plan"
check_link "$REPO_ROOT/integrations/codex/plugins/foundary/skills/build" "../../../../../core/skills/build"
check_link "$REPO_ROOT/integrations/codex/plugins/foundary/skills/commit" "../../../../../core/skills/commit"
check_link "$REPO_ROOT/integrations/claude/skills/spec" "../../../core/skills/spec"
check_link "$REPO_ROOT/integrations/claude/skills/plan" "../../../core/skills/plan"
check_link "$REPO_ROOT/integrations/claude/skills/build" "../../../core/skills/build"
check_link "$REPO_ROOT/integrations/claude/skills/commit" "../../../core/skills/commit"

if [[ "$CHECK_INSTALLED" -eq 1 ]]; then
  CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
  CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

  check_installed_link "$CLAUDE_HOME/CLAUDE.md" "$REPO_ROOT/integrations/claude/CLAUDE.md" "Claude"
  check_installed_link "$CODEX_HOME/AGENTS.md" "$REPO_ROOT/integrations/codex/AGENTS.md" "Codex AGENTS"
  check_installed_link "$CODEX_HOME/plugins/foundary" "$REPO_ROOT/integrations/codex/plugins/foundary" "Codex plugin"

  if [[ -n "$PROJECT_PATH" ]]; then
    local_project="$(cd "$PROJECT_PATH" && pwd)"
    if [[ -L "$local_project/AGENTS.md" ]]; then
      project_agents_target="$(readlink "$local_project/AGENTS.md")"
      if [[ "$project_agents_target" == "$REPO_ROOT/integrations/cursor/AGENTS.md" || "$project_agents_target" == "$REPO_ROOT/integrations/cline/AGENTS.md" ]]; then
        report PASS "Project AGENTS installed link OK: $local_project/AGENTS.md -> $project_agents_target"
      else
        report FAIL "Project AGENTS installed link mismatch: $local_project/AGENTS.md -> $project_agents_target"
      fi
    elif [[ -e "$local_project/AGENTS.md" ]]; then
      report FAIL "Project AGENTS exists but is not a symlink: $local_project/AGENTS.md"
    else
      report WARN "Project AGENTS not installed: $local_project/AGENTS.md"
    fi
    check_installed_link "$local_project/.cursor/rules/foundary.mdc" "$REPO_ROOT/integrations/cursor/rules/foundary.mdc" "Cursor project rule"
    check_installed_link "$local_project/.clinerules/foundary.md" "$REPO_ROOT/integrations/cline/rules/foundary.md" "Cline project rule"
  fi
fi

echo "Summary: PASS=$pass_count WARN=$warn_count FAIL=$fail_count"
if [[ "$fail_count" -gt 0 ]]; then
  exit 1
fi
