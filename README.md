# Foundary

Foundary is a Codex plugin marketplace for deterministic software delivery using a strict staged pipeline:

`spec -> plan -> build -> commit`

The repository is intentionally Codex-only. It exposes two local plugins through the repo marketplace:

- `foundary-workflow`: `spec`, `plan`, and `build` skills.
- `foundary-git`: the `commit` skill.

## Architecture

Foundary follows the Codex plugin structure:

- `.agents/plugins/marketplace.json` defines the repo marketplace.
- `plugins/foundary-workflow` contains workflow planning and build skills.
- `plugins/foundary-git` contains git and commit workflow skills.
- Each plugin owns its `.codex-plugin/plugin.json` manifest and `skills/` directory.

## Repository layout

```text
foundary/
├── README.md
├── .agents/
│   └── plugins/
│       └── marketplace.json
└── plugins/
    ├── foundary-workflow/
    │   ├── .codex-plugin/
    │   │   └── plugin.json
    │   └── skills/
    │       ├── spec/
    │       ├── plan/
    │       └── build/
    └── foundary-git/
        ├── .codex-plugin/
        │   └── plugin.json
        └── skills/
            └── commit/
```

## Install

Use the Codex CLI to add this repo marketplace:

```bash
codex plugin marketplace add .
```

Run that command from the repository root. Codex reads `.agents/plugins/marketplace.json` and installs the local plugins from `./plugins/foundary-workflow` and `./plugins/foundary-git`.

## Plugins

- `foundary-workflow` guides design specs, implementation plans, and plan execution.
- `foundary-git` helps inspect diffs and create scoped Conventional Commits.
