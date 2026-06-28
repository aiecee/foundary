# Foundary

Foundary is a Codex plugin marketplace for strategy-first software delivery with workflow-owned guardrails and dedicated git support:

`investigate` + `design` + focused strategies (`fix`, `refactor`, `harden`, `migrate`) + `plan` + `scope-guard` + `test-rubric` + git support skills (`status`, `review`, `resolve`, `split`, `commit`)

The repository is intentionally Codex-only. It exposes two local plugins through the repo marketplace:

- `foundary-workflow`: investigation, design, strategy, planning, scope guard, and test rubric skills.
- `foundary-git`: `status`, `review`, `resolve`, `split`, and `commit` skills.

## Architecture

Foundary follows the Codex plugin structure:

- `AGENTS.md` is the portable global Codex defaults file. It is stored in the repo for versioning and should be symlinked into the global Codex config directory.
- `.agents/plugins/marketplace.json` defines the repo marketplace.
- `plugins/foundary-workflow` contains investigation, design, strategy, compact planning, scope guard, and workflow-owned test quality guidance skills.
- `plugins/foundary-git` contains git analysis and commit workflow skills.
- Each plugin owns its `.codex-plugin/plugin.json` manifest and `skills/` directory.

## Repository layout

```text
foundary/
├── AGENTS.md
├── README.md
├── .agents/
│   └── plugins/
│       └── marketplace.json
└── plugins/
    ├── foundary-workflow/
    │   ├── .codex-plugin/
    │   │   └── plugin.json
    │   └── skills/
    │       ├── fix/
    │       ├── refactor/
    │       ├── harden/
    │       ├── migrate/
    │       ├── design/
    │       ├── investigate/
    │       ├── plan/
    │       ├── scope-guard/
    │       ├── test-rubric/
    │       └── test-review/
    └── foundary-git/
        ├── .codex-plugin/
        │   └── plugin.json
        └── skills/
            ├── status/
            ├── review/
            ├── resolve/
            ├── split/
            └── commit/
```

## Install

### Global Codex defaults

The root `AGENTS.md` is intended to be the global Codex defaults file. Symlink it into the global Codex config directory so updates in this repository are picked up by Codex without copying the file.

From the repository root:

```bash
GLOBAL_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$GLOBAL_CODEX_DIR"

if [ -e "$GLOBAL_CODEX_DIR/AGENTS.md" ] || [ -L "$GLOBAL_CODEX_DIR/AGENTS.md" ]; then
  mv "$GLOBAL_CODEX_DIR/AGENTS.md" "$GLOBAL_CODEX_DIR/AGENTS.md.backup.$(date +%Y%m%d%H%M%S)"
fi

ln -s "$(pwd)/AGENTS.md" "$GLOBAL_CODEX_DIR/AGENTS.md"
```

Verify the symlink:

```bash
ls -l "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
```

### Plugin marketplace

Use the Codex CLI to add this repo marketplace:

```bash
codex plugin marketplace add .
```

Run that command from the repository root. Codex reads `.agents/plugins/marketplace.json` and installs the local plugins from `./plugins/foundary-workflow` and `./plugins/foundary-git`.

## Plugins

- `foundary-workflow` guides investigation, design decisions, focused change strategies, compact implementation plans, scope checks, and test-quality decisions.
- `foundary-git` supports repository status checks, diff review, conflict resolution, change splitting, and scoped Conventional Commits.

## Core v2 skills

- `foundary-workflow`: `investigate`, `design`, `fix`, `refactor`, `harden`, `migrate`, `plan`, `scope-guard`, `test-rubric`
- `foundary-git`: `status`, `review`, `resolve`, `split`, `commit`

The legacy read-only `test-review` skill may still exist in the workflow plugin, but it is not a core v2 handoff target. Workflow-owned test-quality guidance lives in `test-rubric`. Git skills stay focused on repository state, diff readiness, conflict resolution, splitting, and commits.
