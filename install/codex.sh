#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SRC="$REPO_ROOT/plugins/foundary"
PLUGIN_DST="$CODEX_HOME/plugins/foundary"
AGENTS_SRC="$REPO_ROOT/integrations/codex/AGENTS.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"

mkdir -p "$CODEX_HOME/plugins"

ln -sfn "$PLUGIN_SRC" "$PLUGIN_DST"
ln -sfn "$AGENTS_SRC" "$AGENTS_DST"

echo "Linked plugin: $PLUGIN_DST -> $PLUGIN_SRC"
echo "Linked AGENTS.md: $AGENTS_DST -> $AGENTS_SRC"
