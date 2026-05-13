#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

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

mkdir -p "$CLAUDE_HOME" "$CLAUDE_HOME/skills"

safe_link "$REPO_ROOT/integrations/claude/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md" "CLAUDE.md"
safe_link "$REPO_ROOT/integrations/claude/skills/spec" "$CLAUDE_HOME/skills/spec" "skill spec"
safe_link "$REPO_ROOT/integrations/claude/skills/plan" "$CLAUDE_HOME/skills/plan" "skill plan"
safe_link "$REPO_ROOT/integrations/claude/skills/build" "$CLAUDE_HOME/skills/build" "skill build"
safe_link "$REPO_ROOT/integrations/claude/skills/commit" "$CLAUDE_HOME/skills/commit" "skill commit"

echo "Claude install completed."
