#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <project-path>"
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

PROJECT_PATH="$1"
if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "ERROR: Project path does not exist: $PROJECT_PATH"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT_ABS="$(cd "$PROJECT_PATH" && pwd)"

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

mkdir -p "$PROJECT_ABS/.cursor/rules"
safe_link "$REPO_ROOT/integrations/cursor/AGENTS.md" "$PROJECT_ABS/AGENTS.md" "AGENTS.md"
safe_link "$REPO_ROOT/integrations/cursor/rules/foundary.mdc" "$PROJECT_ABS/.cursor/rules/foundary.mdc" "Cursor rule"

echo "Cursor install completed for project: $PROJECT_ABS"
