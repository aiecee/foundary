#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [--clients claude,codex,cursor,cline] [--project <path>] [--global-cline]"
}

CLIENTS="claude,codex,cursor,cline"
PROJECT_PATH=""
GLOBAL_CLINE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clients)
      CLIENTS="${2:-}"
      shift 2
      ;;
    --project)
      PROJECT_PATH="${2:-}"
      shift 2
      ;;
    --global-cline)
      GLOBAL_CLINE=1
      shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

remove_if_managed() {
  local path="$1"
  local expected_target="$2"
  local label="$3"

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    echo "INFO: $label not present: $path"
    return 0
  fi

  if [[ -L "$path" ]]; then
    local current_target
    current_target="$(readlink "$path")"
    if [[ "$current_target" == "$expected_target" ]]; then
      rm "$path"
      echo "OK: Removed Foundary-managed $label: $path"
      return 0
    fi
    echo "WARN: Preserving non-Foundary symlink for $label: $path -> $current_target"
    return 0
  fi

  echo "WARN: Preserving non-symlink $label at $path"
}

uninstall_claude() {
  local claude_home="${CLAUDE_HOME:-$HOME/.claude}"
  remove_if_managed "$claude_home/CLAUDE.md" "$REPO_ROOT/integrations/claude/CLAUDE.md" "Claude global"
  remove_if_managed "$claude_home/skills/spec" "$REPO_ROOT/integrations/claude/skills/spec" "Claude skill spec"
  remove_if_managed "$claude_home/skills/plan" "$REPO_ROOT/integrations/claude/skills/plan" "Claude skill plan"
  remove_if_managed "$claude_home/skills/build" "$REPO_ROOT/integrations/claude/skills/build" "Claude skill build"
  remove_if_managed "$claude_home/skills/commit" "$REPO_ROOT/integrations/claude/skills/commit" "Claude skill commit"
}

uninstall_codex() {
  local codex_home="${CODEX_HOME:-$HOME/.codex}"
  remove_if_managed "$codex_home/AGENTS.md" "$REPO_ROOT/integrations/codex/AGENTS.md" "Codex AGENTS"
  remove_if_managed "$codex_home/plugins/foundary" "$REPO_ROOT/integrations/codex/plugins/foundary" "Codex plugin"
}

uninstall_cursor() {
  [[ -n "$PROJECT_PATH" ]] || { echo "WARN: Skipping cursor uninstall (no --project provided)"; return; }
  local p
  p="$(cd "$PROJECT_PATH" && pwd)"
  remove_if_managed "$p/AGENTS.md" "$REPO_ROOT/integrations/cursor/AGENTS.md" "Cursor AGENTS"
  remove_if_managed "$p/.cursor/rules/foundary.mdc" "$REPO_ROOT/integrations/cursor/rules/foundary.mdc" "Cursor rule"
}

uninstall_cline() {
  [[ -n "$PROJECT_PATH" ]] || { echo "WARN: Skipping cline project uninstall (no --project provided)"; }
  if [[ -n "$PROJECT_PATH" ]]; then
    local p
    p="$(cd "$PROJECT_PATH" && pwd)"
    remove_if_managed "$p/AGENTS.md" "$REPO_ROOT/integrations/cline/AGENTS.md" "Cline AGENTS"
    remove_if_managed "$p/.clinerules/foundary.md" "$REPO_ROOT/integrations/cline/rules/foundary.md" "Cline rule"
  fi

  if [[ "$GLOBAL_CLINE" -eq 1 ]]; then
    local cline_home="${CLINE_HOME:-$HOME/.cline}"
    remove_if_managed "$cline_home/rules/foundary.md" "$REPO_ROOT/integrations/cline/rules/foundary.md" "Global Cline rule"
  fi
}

IFS=',' read -r -a client_list <<< "$CLIENTS"
for client in "${client_list[@]}"; do
  case "$client" in
    claude) uninstall_claude ;;
    codex) uninstall_codex ;;
    cursor) uninstall_cursor ;;
    cline) uninstall_cline ;;
    *) echo "ERROR: Unsupported client: $client"; exit 1 ;;
  esac
done

echo "Uninstall completed."
