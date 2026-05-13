#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SRC="$REPO_ROOT/plugins/foundary"
PLUGIN_DST="$CODEX_HOME/plugins/foundary"
AGENTS_SRC="$REPO_ROOT/integrations/codex/AGENTS.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"

is_symlink_to() {
  local path="$1"
  local target="$2"
  [[ -L "$path" ]] || return 1
  local current
  current="$(readlink "$path")"
  [[ "$current" == "$target" ]]
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
      echo "WARN: Re-linking $label from existing symlink: $dst"
      ln -sfn "$src" "$dst"
      echo "OK: Linked $label: $dst -> $src"
      return 0
    fi

    echo "WARN: $label target exists and is not Foundary-managed: $dst"
    echo "WARN: Skipping to avoid overwriting user-owned file. Remove or back up manually, then rerun."
    return 0
  fi

  ln -sfn "$src" "$dst"
  echo "OK: Linked $label: $dst -> $src"
}

mkdir -p "$CODEX_HOME" "$CODEX_HOME/plugins"

if [[ ! -d "$PLUGIN_SRC" ]]; then
  echo "ERROR: Plugin source missing: $PLUGIN_SRC"
  exit 1
fi

if [[ ! -f "$AGENTS_SRC" ]]; then
  echo "ERROR: AGENTS source missing: $AGENTS_SRC"
  exit 1
fi

safe_link "$PLUGIN_SRC" "$PLUGIN_DST" "plugin"
safe_link "$AGENTS_SRC" "$AGENTS_DST" "AGENTS.md"

echo "Install completed."
