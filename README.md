# Foundary

Foundary is a Codex plugin marketplace for strategy-first software delivery with workflow-owned guardrails and dedicated git support:

`investigate` + `design` + focused strategies (`fix`, `refactor`, `harden`, `migrate`) + `plan` + `scope-guard` + `test-rubric` + git support skills (`status`, `review`, `resolve`, `split`, `commit`)

The repository is Codex-first, Cursor-compatible, and Claude-compatible. It exposes two local plugins through the repo marketplace:

- `foundary-workflow`: investigation, design, strategy, planning, scope guard, and test rubric skills.
- `foundary-git`: `status`, `review`, `resolve`, `split`, and `commit` skills.

## Architecture

Foundary follows the Codex plugin structure and includes Cursor and Claude plugin manifests:

- `AGENTS.md` is the portable global Codex defaults file. It is stored in the repo for versioning and should be symlinked into the global Codex config directory.
- `.agents/plugins/marketplace.json` defines the repo marketplace.
- `.cursor-plugin/marketplace.json` defines the Cursor marketplace.
- `.claude-plugin/marketplace.json` defines the Claude Code marketplace.
- `plugins/foundary-workflow` contains investigation, design, focused strategies, concise decision-complete planning, scope guard, and workflow-owned quality rubrics.
- `plugins/foundary-git` contains git analysis and commit workflow skills.
- Each plugin owns its `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json`, and `skills/` directory.

## Repository layout

```text
foundary/
├── AGENTS.md
├── README.md
├── .agents/
│   └── plugins/
│       └── marketplace.json
├── .cursor-plugin/
│   └── marketplace.json
├── .claude-plugin/
│   └── marketplace.json
└── plugins/
    ├── foundary-workflow/
    │   ├── .codex-plugin/
    │   │   └── plugin.json
    │   ├── .cursor-plugin/
    │   │   └── plugin.json
    │   ├── .claude-plugin/
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
    │       └── test-rubric/
    └── foundary-git/
        ├── .codex-plugin/
        │   └── plugin.json
        ├── .cursor-plugin/
        │   └── plugin.json
        ├── .claude-plugin/
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

### Cursor plugin marketplace

Start the Cursor Agent CLI from this repository, then run these as Agent chat slash commands:

```text
/plugin marketplace add /Users/frontendengineer/projects/foundary
/plugin install foundary-workflow@foundary
/plugin install foundary-git@foundary
```

These are typed inside the Agent CLI session, not run as shell commands. Cursor reads `.cursor-plugin/marketplace.json` and installs the local plugins from `./plugins/foundary-workflow` and `./plugins/foundary-git`.

### Claude Code plugin marketplace

Start Claude Code from this repository, then run these as Claude Code chat slash commands:

```text
/plugin marketplace add /Users/frontendengineer/projects/foundary
/plugin install foundary-workflow@foundary
/plugin install foundary-git@foundary
/reload-plugins
```

These are typed inside the Claude Code session, not run as shell commands. Claude Code reads `.claude-plugin/marketplace.json` and installs the local plugins from `./plugins/foundary-workflow` and `./plugins/foundary-git`.

You can also install from the shell:

```bash
claude plugin marketplace add /Users/frontendengineer/projects/foundary
claude plugin install foundary-workflow@foundary
claude plugin install foundary-git@foundary
```

## Plugins

- `foundary-workflow` guides investigation, design decisions, focused change strategies, concise decision-complete implementation plans, scope checks, and workflow-quality rubrics.
- `foundary-git` supports repository status checks, diff review, conflict resolution, change splitting, and scoped Conventional Commits.

## Core v2 skills

- `foundary-workflow`: `investigate`, `design`, `fix`, `refactor`, `harden`, `migrate`, `plan`, `scope-guard`, `decision-rubric`, `test-rubric`
- `foundary-git`: `status`, `review`, `resolve`, `split`, `commit`

Workflow-owned test-quality guidance lives in `test-rubric`. Git skills stay focused on repository state, diff readiness, conflict resolution, splitting, and commits.
