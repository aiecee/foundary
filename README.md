# Foundary

Foundary is a Codex plugin marketplace for deterministic software delivery with a strict workflow pipeline and dedicated git support:

`spec -> plan -> build` + git support skills (`status`, `review`, `resolve`, `split`, `commit`)

The repository is intentionally Codex-only. It exposes two local plugins through the repo marketplace:

- `foundary-workflow`: `spec`, `plan`, `investigate`, and `build` skills.
- `foundary-git`: `status`, `review`, `resolve`, `split`, and `commit` skills.

## Architecture

Foundary follows the Codex plugin structure:

- `.agents/plugins/marketplace.json` defines the repo marketplace.
- `plugins/foundary-workflow` contains investigation and workflow delivery skills.
- `plugins/foundary-git` contains git analysis and commit workflow skills.
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
    │       ├── investigate/
    │       ├── spec/
    │       ├── plan/
    │       └── build/
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

Use the Codex CLI to add this repo marketplace:

```bash
codex plugin marketplace add .
```

Run that command from the repository root. Codex reads `.agents/plugins/marketplace.json` and installs the local plugins from `./plugins/foundary-workflow` and `./plugins/foundary-git`.

## Plugins

- `foundary-workflow` guides investigation, design specs, implementation plans, and plan execution.
- `foundary-git` supports repository status checks, diff review, conflict resolution, change splitting, and scoped Conventional Commits.

## Current skills

- `foundary-workflow`: `investigate`, `spec`, `plan`, `build`
- `foundary-git`: `status`, `review`, `resolve`, `split`, `commit`
