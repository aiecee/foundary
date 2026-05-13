#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 --project <path> [--clients claude,codex,cursor,cline] [--global-cline]"
}

PROJECT_PATH=""
CLIENTS="claude,codex,cursor,cline"
GLOBAL_CLINE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_PATH="${2:-}"
      shift 2
      ;;
    --clients)
      CLIENTS="${2:-}"
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

IFS=',' read -r -a client_list <<< "$CLIENTS"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for client in "${client_list[@]}"; do
  case "$client" in
    claude) "$SCRIPT_DIR/claude.sh" ;;
    codex) "$SCRIPT_DIR/codex.sh" ;;
    cursor)
      [[ -n "$PROJECT_PATH" ]] || { echo "ERROR: --project is required for cursor"; exit 1; }
      "$SCRIPT_DIR/cursor.sh" "$PROJECT_PATH"
      ;;
    cline)
      [[ -n "$PROJECT_PATH" ]] || { echo "ERROR: --project is required for cline"; exit 1; }
      if [[ "$GLOBAL_CLINE" -eq 1 ]]; then
        "$SCRIPT_DIR/cline.sh" "$PROJECT_PATH" --global
      else
        "$SCRIPT_DIR/cline.sh" "$PROJECT_PATH"
      fi
      ;;
    *)
      echo "ERROR: Unsupported client: $client"
      exit 1
      ;;
  esac
done

echo "All requested installs completed."
