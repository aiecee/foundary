#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <project-path> [--global]"
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

PROJECT_PATH="$1"
shift
GLOBAL_MODE=0
if [[ ${1:-} == "--global" ]]; then
  GLOBAL_MODE=1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

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

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "ERROR: Project path does not exist: $PROJECT_PATH"
  exit 1
fi

PROJECT_ABS="$(cd "$PROJECT_PATH" && pwd)"
mkdir -p "$PROJECT_ABS/.clinerules"
safe_link "$REPO_ROOT/integrations/cline/AGENTS.md" "$PROJECT_ABS/AGENTS.md" "AGENTS.md"
safe_link "$REPO_ROOT/integrations/cline/rules/foundary.md" "$PROJECT_ABS/.clinerules/foundary.md" "Cline rule"

if [[ "$GLOBAL_MODE" -eq 1 ]]; then
  CLINE_HOME="${CLINE_HOME:-$HOME/.cline}"
  mkdir -p "$CLINE_HOME/rules"
  safe_link "$REPO_ROOT/integrations/cline/rules/foundary.md" "$CLINE_HOME/rules/foundary.md" "Global Cline rule"
fi

echo "Cline install completed for project: $PROJECT_ABS"
