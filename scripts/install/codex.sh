#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SRC="$REPO_ROOT/integrations/codex/plugins/foundary"
PLUGIN_DST="$CODEX_HOME/plugins/foundary"
AGENTS_SRC="$REPO_ROOT/integrations/codex/AGENTS.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"
PLUGIN_META="$PLUGIN_SRC/.codex-plugin/plugin.json"

is_symlink_to() {
  local path="$1"
  local target="$2"
  [[ -L "$path" ]] || return 1
  [[ "$(readlink "$path")" == "$target" ]]
}

safe_link() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [[ -e "$dst" || -L "$dst" ]]; then
    if is_symlink_to "$dst" "$src"; then
      echo "INFO: $label already linked: $dst -> $src"
      return 0
    fi

    if [[ -L "$dst" ]]; then
      ln -sfn "$src" "$dst"
      echo "OK: Re-linked $label: $dst -> $src"
      return 0
    fi

    echo "WARN: $label exists and is not Foundary-managed: $dst"
    echo "WARN: Skipping to avoid overwriting user-owned file"
    return 0
  fi

  ln -s "$src" "$dst"
  echo "OK: Linked $label: $dst -> $src"
}

if [[ ! -f "$PLUGIN_META" ]]; then
  echo "ERROR: Plugin metadata missing: $PLUGIN_META"
  exit 1
fi

mkdir -p "$CODEX_HOME" "$CODEX_HOME/plugins"
safe_link "$AGENTS_SRC" "$AGENTS_DST" "AGENTS.md"
safe_link "$PLUGIN_SRC" "$PLUGIN_DST" "plugin"

echo "Codex install completed."
