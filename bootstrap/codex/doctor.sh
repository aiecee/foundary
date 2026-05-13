#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PLUGIN_SRC="$REPO_ROOT/plugins/foundary"
PLUGIN_DST="$CODEX_HOME/plugins/foundary"
AGENTS_SRC="$REPO_ROOT/integrations/codex/AGENTS.md"
AGENTS_DST="$CODEX_HOME/AGENTS.md"
PLUGIN_META="$PLUGIN_SRC/.codex-plugin/plugin.json"
SKILLS_DIR="$REPO_ROOT/skills"

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

check_link() {
  local path="$1"
  local expected="$2"
  local label="$3"

  if [[ ! -L "$path" ]]; then
    if [[ -e "$path" ]]; then
      report WARN "$label exists but is not a symlink: $path"
    else
      report FAIL "$label symlink missing: $path"
    fi
    return
  fi

  local current
  current="$(readlink "$path")"
  if [[ "$current" == "$expected" ]]; then
    report PASS "$label symlink is correct: $path -> $expected"
  else
    report WARN "$label symlink points elsewhere: $path -> $current"
  fi
}

if [[ -d "$CODEX_HOME" ]]; then
  report PASS "Codex home exists: $CODEX_HOME"
else
  report FAIL "Codex home missing: $CODEX_HOME"
fi

if [[ -d "$CODEX_HOME/plugins" ]]; then
  report PASS "Codex plugins directory exists: $CODEX_HOME/plugins"
else
  report FAIL "Codex plugins directory missing: $CODEX_HOME/plugins"
fi

check_link "$PLUGIN_DST" "$PLUGIN_SRC" "Plugin"
check_link "$AGENTS_DST" "$AGENTS_SRC" "AGENTS.md"

if [[ -d "$PLUGIN_SRC" ]]; then
  report PASS "Plugin source exists: $PLUGIN_SRC"
else
  report FAIL "Plugin source missing: $PLUGIN_SRC"
fi

if [[ -f "$AGENTS_SRC" ]]; then
  report PASS "AGENTS source exists: $AGENTS_SRC"
else
  report FAIL "AGENTS source missing: $AGENTS_SRC"
fi

if [[ -r "$PLUGIN_META" ]]; then
  report PASS "Plugin metadata is readable: $PLUGIN_META"
else
  report FAIL "Plugin metadata unreadable or missing: $PLUGIN_META"
fi

if [[ -d "$SKILLS_DIR" ]] && compgen -G "$SKILLS_DIR/*/SKILL.md" >/dev/null; then
  report PASS "Skills directory is discoverable: $SKILLS_DIR"
else
  report FAIL "Skills directory missing or no SKILL.md files found: $SKILLS_DIR"
fi

echo "Summary: PASS=$pass_count WARN=$warn_count FAIL=$fail_count"
if [[ "$fail_count" -gt 0 ]]; then
  exit 1
fi
