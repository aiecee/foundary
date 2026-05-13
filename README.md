# Foundary

Foundary is a Codex workflow toolkit for deterministic software delivery with a strict staged pipeline:

`spec -> plan -> build -> commit`

It is designed to reduce execution ambiguity, preserve scope boundaries, and produce artifacts that are easy for humans to review.

## Philosophy

Foundary follows four operating principles:

- Deterministic execution over autonomy.
- Scoped implementation over opportunistic expansion.
- Human review as a required control point.
- Spec-first development to align intent before implementation.

## Workflow

### 1) `spec`
Produces a repository-grounded design spec with canonical sections and clear assumptions.

### 2) `plan`
Turns an approved spec into an execution-ready implementation plan with strict Red/Green/Refactor task structure.

### 3) `build`
Executes plan tasks sequentially, enforces task boundaries, and verifies outcomes after Green and Refactor.

### 4) `commit`
Creates Conventional Commits scoped to coherent implementation units.

### Example flow

1. Capture idea and run `spec` to create a design document.
2. Run `plan` against the approved design to produce executable tasks.
3. Run `build` to implement tasks in order.
4. Run `commit` to create scoped, review-friendly commits.

## Installation

Foundary separates global integration assets from repository assets:

- Global behavior: `~/.codex/AGENTS.md`
- Repository behavior: repo-local assets and skills

Installer scripts:

- `bootstrap/codex/install.sh`
- `bootstrap/codex/uninstall.sh`
- `bootstrap/codex/doctor.sh`

### Install

```bash
./bootstrap/codex/install.sh
```

### Validate install

```bash
./bootstrap/codex/doctor.sh
```

### Uninstall

```bash
./bootstrap/codex/uninstall.sh
```

### Update

Updates are intentionally modeled as:

1. `./bootstrap/codex/uninstall.sh`
2. `./bootstrap/codex/install.sh`

No dedicated update script is required.

## Skill reference

### `spec`
- Inputs: idea/problem statement, repository context
- Outputs: design spec with canonical sections, implementation-plan placeholder
- Workflow position: stage 1

### `plan`
- Inputs: approved spec, repository context, available verification commands
- Outputs: ordered behavior-first tasks, coverage traceability, execution contract
- Workflow position: stage 2

### `build`
- Inputs: execution-ready plan, repository context, project commands
- Outputs: implementation changes, verification summaries, feedback checkpoints
- Workflow position: stage 3

### `commit`
- Inputs: staged/selected diff, commit type
- Outputs: scoped Conventional Commit
- Workflow position: stage 4

## Contracts

Workflow interfaces are explicitly documented in:

- `docs/contracts/spec-contract.md`
- `docs/contracts/plan-contract.md`
- `docs/contracts/build-contract.md`

These contracts align stage outputs and reduce downstream inference.

## Repository structure

```text
foundary/
├── docs/
│   └── contracts/
├── install/
│   └── codex/
├── integrations/
│   └── codex/
├── plugins/
│   └── foundary/
└── skills/
    ├── spec/
    ├── plan/
    ├── build/
    └── commit/
```
