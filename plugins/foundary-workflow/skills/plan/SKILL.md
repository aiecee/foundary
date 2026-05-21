---
name: plan
description: Turns approved Foundary specs or code-change strategies into strict, execution-ready implementation plans with behaviour-first vertical slices, Red/Green/Refactor task flow, explicit scope boundaries, and coverage traceability. Use when the user needs a plan that build can execute with minimal reasoning.
compatibility: 'Requires: git, filesystem access, ability to run project test/lint/build commands.'
---

# Plan

Turns an approved Foundary spec or code-change strategy into a deterministic, scoped, execution-ready implementation plan that downstream `build` can follow linearly with minimal inference.

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
- test quality evidence for every Red-light scenario
- explicit uncertainty labeling

## Input contract

Primary input:
- an approved Foundary spec document (prefer docs under `docs/plans/`)
- an approved code-change strategy from `refactor`, `fix`, `harden`, or `migrate`

Fallback input (only if no Foundary spec or code-change strategy exists):
- external requirements or design docs

When using fallback input:
- normalize it into the expected Foundary planning structure
- explicitly flag missing sections
- do not invent missing detail
- label uncertainty clearly

When using strategy input:
- preserve the strategy's change intent, scope boundary, out-of-scope items, and verification posture
- convert only grounded strategy details into executable plan tasks
- do not invent missing contracts, call sites, compatibility requirements, or validation commands
- if the strategy is too partial to become execution-ready, stop and ask for the missing decision

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

## Required source sections from strategy

Extract and preserve:
- Change Intent
- Scope Boundary
- Evidence / Protection
- Proposed Steps
- Verification Posture
- Handoff Recommendation
- Out Of Scope

Also preserve strategy-specific sections when present:
- Behaviour To Preserve
- Observed Failure
- Likely Cause
- Risk / Failure Mode
- Intended Behaviour
- Guarded Cases
- Source Contract
- Target Contract
- Compatibility / Rollout

If a required strategy section is missing:
- mark it as `Missing from source strategy`
- continue only when the remaining strategy is still execution-ready
- ask for clarification when implementation would require guessing

## Workflow

1. **Ground in repository context before planning.**
   - Inspect:
     - `README.md` or `README.*`
     - `AGENT.md`, `AGENTS.md`, or similar operator guidance
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

2. **Parse and scope from the source.**
   - For specs, list all success criteria from the source spec.
   - For strategies, treat the change intent, scope boundary, verification posture, and out-of-scope items as the source of truth.
   - Identify constraints and non-goals that must bound implementation.
   - Derive behaviour slices; avoid architecture-first decomposition.

3. **Split work into behaviour-first vertical tasks.**
   - Each task must be independently executable and verifiable.
   - Avoid giant foundation tasks and generic setup-only work.
   - Allow only the minimal enabling infrastructure needed for the next behaviour slice.

4. **Build execution contract using templates.**
   - Read `assets/test-quality-rubric.md` before creating Red-light scenarios.
   - Read `assets/implementation-plan-template.md` as the canonical plan interface.
   - Use `assets/task-structure-template.md` for per-task Red/Green/Refactor detail where needed.
   - Every task must explicitly define:
     - pre-read files
     - files to create/modify/delete
     - Red-light test level, command, scenarios, expected failure
     - Red-light test quality evidence: Requirement protected, Failure mode caught, Test category, Test level rationale, Mocks used, Runtime contract rationale when asserting shape
     - Green-light exact implementation boundaries
     - Refactor limits
     - task verification command
     - pass condition
     - stop condition
   - Plans must not require executor inference for files, commands, completion criteria, or scope boundaries.

5. **Run mandatory coverage traceability check before output.**
   - Map each success criterion or strategy intent to at least one task.
   - Map each success criterion or strategy intent to at least one Red-light scenario or documented verification posture.
   - Confirm each Red-light scenario satisfies `assets/test-quality-rubric.md`.
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
