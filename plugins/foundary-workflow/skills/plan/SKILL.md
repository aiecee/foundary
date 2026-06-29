---
name: plan
description: Turns approved Foundary specs or code-change strategies into strict, execution-ready implementation plans with behaviour-first vertical slices, verification posture decisions, optional Red/Green/Refactor task flow, explicit scope boundaries, and coverage traceability. Use when the user needs a plan that build can execute with minimal reasoning.
compatibility: 'Requires: git, filesystem access, ability to run project test/lint/build commands.'
---

# Plan

Turns an approved Foundary spec or code-change strategy into a deterministic, scoped, execution-ready implementation plan that downstream `build` can follow linearly with minimal inference.

Preserved strengths from earlier planning iterations:
- repository grounding
- behaviour-first vertical slicing
- Red / Green / Refactor when a new automated test is justified
- Given / When / Then scenarios
- verification-first planning

Strengthened requirements:
- strict scope control
- explicit execution contract per task
- low-cost model reliability
- traceability from spec -> tasks -> verification posture -> verification
- test quality evidence for every planned new automated test
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
   - Read `../../assets/test-quality-rubric.md` before choosing verification posture or new automated test boundaries.
   - Read `assets/test-quality-rubric.md` before creating Red-light scenarios.
   - Read `assets/implementation-plan-template.md` as the canonical plan interface.
   - Use `assets/task-structure-template.md` for per-task verification posture and Red/Green/Refactor detail where needed.
   - Before creating Red-light scenarios, classify each task with a verification posture:
     - `new automated test`
     - `existing coverage / characterization`
     - `manual verification`
     - `no new test`
   - Only create Red-light scenarios when the posture is `new automated test`.
   - For `existing coverage / characterization`, `manual verification`, or `no new test`, record the rationale and verification target instead of inventing a test.
   - Every task must explicitly define:
     - pre-read files
     - files to create/modify/delete
     - verification posture
     - decision rationale
     - boundary selected: pure input/output | module/service | integration/API/database/component | e2e/manual | none
     - requirement, risk, or contract protected
     - realistic failure mode
     - why not a different boundary
     - Red-light test command, scenarios, and expected failure only when posture is `new automated test`
     - test quality evidence for new automated tests: requirement protected, failure mode caught, boundary rationale, mocks/fakes used, runtime contract rationale when asserting shape, and rewrite durability
     - Green-light exact implementation boundaries
     - Refactor limits
     - task verification command
     - pass condition
     - stop condition
   - Plans must not require executor inference for files, commands, completion criteria, or scope boundaries.

5. **Apply the test-selection gate before planning a new automated test.**
   - A task may plan a new automated test only when the plan can answer:
     - What behaviour, requirement, regression, risk, or runtime/public contract does this test protect?
     - What realistic breakage would make it fail?
     - Would it fail for the right reason, or only because implementation details changed?
     - Could the implementation be broken while this test still passes?
     - Is the test cheaper to maintain than the risk it protects?
     - Is this the smallest stable boundary that proves the behaviour?
     - Would this test remain valuable if the implementation were rewritten?
   - If these cannot be answered from repository, spec, or strategy evidence, do not invent a new automated test. Choose `existing coverage / characterization`, `manual verification`, or `no new test` and record the rationale.
   - Choose the smallest stable boundary using this ladder:
     - pure input/output test for business rules, policies, parsing, validation, transformation, filtering, mapping, scoring, and decision logic
     - module/service test with real collaborators or local fakes when behaviour depends on small internal collaboration but not framework/runtime wiring
     - integration/API/database/component test when the behaviour is persistence, HTTP contract, framework wiring, rendering, routing, serialization, or cross-module integration
     - e2e/manual verification when confidence depends on real user flow, deployment, visual interaction, auth, third-party behaviour, or environment-specific runtime behaviour
   - If a planned unit test needs heavy mocking, stop and choose a smaller pure boundary, a local fake or in-memory boundary, a broader integration boundary, manual verification, or no new test.
   - Reject new automated tests for README wording, docs phrasing, comments, labels, or copy unless the exact output is a public/runtime contract.
   - Reject tests for static types, private implementation details, helper calls, call order, mock choreography, broad snapshots, regex phrase checks, refactors already covered by characterization, trivial wiring, file movement, or generated boilerplate unless the plan names a meaningful runtime/public contract or failure mode.
   - Docs may be tested when they are genuinely runtime/public contracts, such as generated CLI help, public SDK docs, migration output, schema docs, install commands, or published examples consumed by users or automation.

6. **Run mandatory coverage traceability check before output.**
   - Map each success criterion or strategy intent to at least one task.
   - Map each success criterion or strategy intent to at least one documented verification posture and verification target.
   - Confirm each planned new automated test satisfies the shared Test Quality Rubric and `assets/test-quality-rubric.md`.
   - Confirm each `no new test` posture has a concrete rationale and does not hide risky work.
   - Flag uncovered criteria and resolve gaps before finalizing.
   - Include the coverage traceability table in the plan header.

7. **Output and implementation-plan backlink.**
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
