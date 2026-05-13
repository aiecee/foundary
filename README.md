# Foundary

Foundary is a portable workflow toolkit for deterministic software delivery using a strict staged pipeline:

`spec -> plan -> build -> commit`

The repository is structured so canonical workflow content lives in one place and client integrations are thin adapter views over that content.

## Architecture

Foundary uses a `core`-first repository design:

- Canonical global behavior lives in `core/AGENTS.md`.
- Canonical workflow skills live in `core/skills/{spec,plan,build,commit}`.
- `integrations/` exposes client-native layouts that point back to `core/`.
- `scripts/install/` wires external client locations to integration entrypoints.
- No generation, sync, or build step is required to keep integrations in sync.

The intended install chain is:

```text
installed location -> integrations/* -> core/*
```

## Repository layout

```text
foundary/
├── README.md
├── core/
│   ├── AGENTS.md
│   └── skills/
│       ├── spec/
│       ├── plan/
│       ├── build/
│       └── commit/
├── integrations/
│   ├── claude/
│   ├── codex/
│   ├── cursor/
│   └── cline/
├── scripts/
│   ├── install/
│   │   ├── all.sh
│   │   ├── claude.sh
│   │   ├── codex.sh
│   │   ├── cursor.sh
│   │   ├── cline.sh
│   │   └── uninstall.sh
│   └── doctor.sh
└── docs/
    └── archive/
```

## Integrations

- `claude`: `CLAUDE.md` and `skills/*` symlink back to canonical content in `core/`.
- `codex`: `AGENTS.md` symlinks to `core/AGENTS.md`, and the local plugin package lives in `integrations/codex/plugins/foundary/`.
- `cursor`: `AGENTS.md` symlinks to `core/AGENTS.md`, with a thin rule wrapper in `integrations/cursor/rules/foundary.mdc`.
- `cline`: `AGENTS.md` symlinks to `core/AGENTS.md`, with a thin rule wrapper in `integrations/cline/rules/foundary.md`.

## Install

These scripts only create directories and symlinks. They do not generate files or copy canonical workflow content.

- Codex: `./scripts/install/codex.sh`
  Creates `~/.codex` as needed, links `~/.codex/AGENTS.md`, and links `~/.codex/plugins/foundary` to the integration-scoped plugin package.
- Claude: `./scripts/install/claude.sh`
  Creates `~/.claude` and `~/.claude/skills`, then links `CLAUDE.md` and all four skills from `integrations/claude/`.
- Cursor: `./scripts/install/cursor.sh <project-path>`
  Project-scoped install that links `<project>/AGENTS.md` and `<project>/.cursor/rules/foundary.mdc`.
- Cline: `./scripts/install/cline.sh <project-path>`
  Project-scoped install that links `<project>/AGENTS.md` and `<project>/.clinerules/foundary.md`.
- Cline with global rule too: `./scripts/install/cline.sh <project-path> --global`
  Adds a global Cline rule link in addition to the project-scoped links.
- Convenience wrapper: `./scripts/install/all.sh --project <project-path>`
  Installs all clients by default. `--project` is required only when the selected clients include `cursor` or `cline`.

Installer behavior:

- Installers are idempotent when the target already points at Foundary.
- Existing user-owned regular files are preserved and not overwritten.
- Existing symlinks may be re-pointed only when the installer is managing that target.

### Project `AGENTS.md` ownership

Both `cursor` and `cline` install to `<project>/AGENTS.md`. If you install both into the same project, the most recently run installer determines which integration-specific `AGENTS.md` that project path points to. This is expected because both integration entrypoints ultimately point back to the same canonical `core/AGENTS.md`.

## Uninstall

- Remove all supported installs: `./scripts/install/uninstall.sh`
- Scoped uninstall example: `./scripts/install/uninstall.sh --clients codex,claude`
- Project uninstall example: `./scripts/install/uninstall.sh --clients cursor,cline --project <project-path>`
- Project uninstall plus global Cline cleanup: `./scripts/install/uninstall.sh --clients cline --project <project-path> --global-cline`

Uninstall only removes Foundary-managed symlinks and preserves user-owned files or non-Foundary links.

## Validation

- Repository structure checks: `./scripts/doctor.sh`
- Include installed-link checks for Claude/Codex globals: `./scripts/doctor.sh --check-installed`
- Include project install checks too: `./scripts/doctor.sh --check-installed --project <project-path>`

`scripts/doctor.sh` validates:

- canonical files in `core/`
- integration-layer symlink wiring
- Codex plugin metadata presence
- optional installed targets when `--check-installed` is requested

## Notes

- Historical contract docs are retained in `docs/archive/` for reference only.
- Canonical content lives in `core/`; `integrations/` is an adapter layer, not a second content system.
