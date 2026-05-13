#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SRC="$REPO_ROOT/plugins/foundary"
PLUGIN_DST="$CODEX_HOME/plugins/foundary"
AGENTS_SRC="$REPO_ROOT/integrations/codex/AGENTS.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"

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

remove_if_managed "$PLUGIN_DST" "$PLUGIN_SRC" "plugin"
remove_if_managed "$AGENTS_DST" "$AGENTS_SRC" "AGENTS.md"

echo "Uninstall completed."
