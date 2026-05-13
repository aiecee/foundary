---
name: plan
description: Turns approved Foundary specs into strict, execution-ready implementation plans with behaviour-first vertical slices, Red/Green/Refactor task flow, explicit scope boundaries, and coverage traceability. Use when the user needs a plan that build can execute with minimal reasoning.
compatibility: 'Requires: git, filesystem access, ability to run project test/lint/build commands.'
---

# Plan

Turns an approved Foundary spec into a deterministic, scoped, execution-ready implementation plan that downstream `build` can follow linearly with minimal inference.

Preserved strengths from earlier planning iterations:
- repository grounding
- behaviour-first vertical slicing
- Red / Green / Refactor
- Given / When / Then scenarios
- verification-first planning

Strengthened requirements:
- strict scope control
- explicit execution contract per task
- low-cost model reliability
- traceability from spec -> tasks -> tests -> verification
- explicit uncertainty labeling

## Input contract

Primary input:
- an approved Foundary spec document (prefer docs under `docs/plans/`)

Fallback input (only if no Foundary spec exists):
- external requirements or design docs

When using fallback input:
- normalize it into the expected Foundary planning structure
- explicitly flag missing sections
- do not invent missing detail
- label uncertainty clearly

## Required source sections from spec

Extract and preserve:
- Goal
- Success criteria
- Constraints
- Non-goals / Out of scope
- Architecture / implementation approach
- Testing expectations
- Relevant repository context (if present)
- Implementation plan placeholder/path

If any required section is missing:
- mark it as `Missing from source spec`
- continue only with grounded information
- avoid presenting assumptions as facts

## Workflow

1. **Ground in repository context before planning.**
   - Inspect:
     - `README.md` or `README.*`
     - `AGENT.md`, `AGENTS.md`, `CLAUDE.md`, or similar operator guidance
     - `docs/`
     - `docs/plans/`
     - project manifests (`package.json`, `pyproject.toml`, or equivalent)
     - relevant source directories
     - relevant test directories
     - `git log -10 --oneline`
   - Use findings to choose concrete files, commands, and verification steps.
   - If a path or command is uncertain, output:
     - `Proposed path: path/to/file`
     - `Reason: why this is uncertain`

2. **Parse and scope from the spec.**
   - List all success criteria from the source spec.
   - Identify constraints and non-goals that must bound implementation.
   - Derive behaviour slices; avoid architecture-first decomposition.

3. **Split work into behaviour-first vertical tasks.**
   - Each task must be independently executable and verifiable.
   - Avoid giant foundation tasks and generic setup-only work.
   - Allow only the minimal enabling infrastructure needed for the next behaviour slice.

4. **Build execution contract using templates.**
   - Read `assets/plan-header-template.md` and fill all sections.
   - Read `assets/task-structure-template.md` for every task.
   - Every task must explicitly define:
     - pre-read files
     - files to create/modify/delete
     - Red-light test level, command, scenarios, expected failure
     - Green-light exact implementation boundaries
     - Refactor limits
     - task verification command
     - pass condition
     - stop condition
   - Plans must not require executor inference for files, commands, completion criteria, or scope boundaries.

5. **Run mandatory coverage traceability check before output.**
   - Map each success criterion to at least one task.
   - Map each success criterion to at least one Red-light scenario.
   - Flag uncovered criteria and resolve gaps before finalizing.
   - Include the coverage traceability table in the plan header.

6. **Output and implementation-plan backlink.**
   - Write one combined file to `docs/plans/YYYY-MM-DD-<topic>.md`.
   - If the source spec contains an implementation-plan field/path:
     - update it only when environment/workflow allows.
     - otherwise provide the exact value for manual update.

## Execution reliability rules

Generated plans must be:
- deterministic
- scoped
- behaviour-focused
- directly consumable by `build`
- explicit enough for low-cost execution models

Strongly discourage:
- opportunistic refactors
- unrelated cleanup
- speculative improvements
- architecture rewrites
- "while I'm here" changes

Use canonical `plan` terminology in generated output.
