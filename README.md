# Foundary

Foundary is a Codex plugin marketplace for deterministic software delivery with a strict workflow pipeline, workflow-owned quality checks, and dedicated git support:

`investigate -> spec -> plan -> build` + `test-review` + git support skills (`status`, `review`, `resolve`, `split`, `commit`)

The repository is intentionally Codex-only. It exposes two local plugins through the repo marketplace:

- `foundary-workflow`: `investigate`, `spec`, `plan`, `build`, and `test-review` skills.
- `foundary-git`: `status`, `review`, `resolve`, `split`, and `commit` skills.

## Architecture

Foundary follows the Codex plugin structure:

- `.agents/plugins/marketplace.json` defines the repo marketplace.
- `plugins/foundary-workflow` contains investigation, planning, build execution, and workflow-owned test quality review skills.
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
    │       ├── build/
    │       └── test-review/
    │           └── assets/
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

- `foundary-workflow` guides investigation, design specs, implementation plans, plan execution, and read-only test quality review.
- `foundary-git` supports repository status checks, diff review, conflict resolution, change splitting, and scoped Conventional Commits.

## Current skills

- `foundary-workflow`: `investigate`, `spec`, `plan`, `build`, `test-review`
- `foundary-git`: `status`, `review`, `resolve`, `split`, `commit`

Workflow-owned test quality checks live in `foundary-workflow`. Git skills stay focused on repository state, diff readiness, conflict resolution, splitting, and commits.
