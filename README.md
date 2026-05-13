# Foundary

Foundary is a portable workflow toolkit for deterministic software delivery using a strict staged pipeline:

`spec -> plan -> build -> commit`

## Architecture

Foundary uses a `core`-first repository design:

- Canonical global behavior: `core/AGENTS.md`
- Canonical workflow skills: `core/skills/{spec,plan,build,commit}`
- Integrations are thin adapters under `integrations/`
- Symlink-first where supported
- No generation/sync/build system required for repository wiring

## Repository layout

```text
foundary/
├── core/
├── integrations/
├── scripts/
│   ├── install/
│   └── doctor.sh
└── docs/
```

## Install

- Codex: `./scripts/install/codex.sh`
- Claude: `./scripts/install/claude.sh`
- Cursor (project-scoped): `./scripts/install/cursor.sh <project-path>`
- Cline (project default): `./scripts/install/cline.sh <project-path>`
- Cline with global rule too: `./scripts/install/cline.sh <project-path> --global`
- Convenience wrapper: `./scripts/install/all.sh --project <project-path>`

## Uninstall

- `./scripts/install/uninstall.sh`
- Scoped uninstall example: `./scripts/install/uninstall.sh --clients codex,claude`
- Project uninstall example: `./scripts/install/uninstall.sh --clients cursor,cline --project <project-path>`

## Validation

- Repository structure checks: `./scripts/doctor.sh`
- Include installed-link checks: `./scripts/doctor.sh --check-installed`
- Include project installed-link checks: `./scripts/doctor.sh --check-installed --project <project-path>`

## Notes

- Historical contract docs are archived in `docs/archive/`.
- Canonical content lives in `core/`; integrations are adapter views only.
