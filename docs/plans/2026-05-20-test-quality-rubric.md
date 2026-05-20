# Test quality rubric implementation plan

**Date:** 2026-05-20
**Spec:** docs/plans/2026-05-20-test-quality-rubric-design.md

## Goal

Add a plan-owned test quality rubric and wire Foundary workflow skills so generated tests protect real requirements, regressions, risks, or runtime contracts instead of mock-heavy or shape-only implementation details.

## Success Criteria Summary

- `plan` owns a canonical test quality rubric asset at `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`.
- `plan` must read the rubric before creating Red Light scenarios.
- Every Red Light scenario must declare the requirement, bug/regression, risk, or runtime contract it protects.
- Every Red Light scenario must explain why its chosen level is appropriate: unit, integration, e2e, or manual verification.
- Every mock must have a specific reason and should usually sit at an external boundary.
- Shape-only tests for interfaces, types, and structs are forbidden unless the shape is a runtime/public contract.
- `build` must stop when a planned or generated Red test violates the rubric instead of inventing a weak test.
- `review` should flag low-value tests as a validation issue, not only missing tests.

## Constraints Carried Forward

- Follow the existing repo asset pattern: assets live beside the skill that owns them.
- Keep the rubric owned by `plan`; do not introduce a standalone skill for this initial change.
- Keep `build` as an executor and guardrail, not a redesign or test-authoring workflow.
- Keep `spec` lightweight; it should feed better testing context into `plan`, not duplicate the full rubric.
- Avoid broad workflow rewrites outside the testing quality path.
- This repository has no executable app test suite or package manifest; use command-level documentation verification.

## Non-Goals

- Creating a standalone test review skill.
- Rewriting all workflow skills around a new testing model.
- Adding executable test infrastructure to this repository.
- Requiring tests for every change regardless of risk.
- Banning all mocks.
- Banning all data-shape assertions.

## Approach

Implement this as four documentation-contract slices. First add the rubric asset in `plan/assets`; then teach `plan` and its templates to apply it; then improve `spec` so better testing intent reaches `plan`; finally add `build` and `review` guardrails. Verification uses `rg` checks against the skill docs and templates because the repository contains skill documentation rather than runtime code.

## Sequencing Rationale

The rubric asset comes first because later tasks reference it. `plan` wiring follows because that is where Red Light tests are authored. `spec` input improvements follow once the plan contract exists. `build` and `review` guardrails come last because they enforce the standard after it has been defined.

## Coverage Traceability

| Success Criterion | Covered By Task(s) | Red Light Scenario(s) |
|---|---|---|
| `plan` owns a canonical test quality rubric asset at `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`. | Task 1 | Red command fails until the rubric asset exists and contains the core sections. |
| `plan` must read the rubric before creating Red Light scenarios. | Task 2 | Red command fails until `plan/SKILL.md` references `assets/test-quality-rubric.md` before Red Light generation. |
| Every Red Light scenario must declare the requirement, bug/regression, risk, or runtime contract it protects. | Task 1, Task 2 | Red command fails until the rubric and task template include test category, requirement protected, and failure mode fields. |
| Every Red Light scenario must explain why its chosen level is appropriate: unit, integration, e2e, or manual verification. | Task 1, Task 2 | Red command fails until the rubric and task template include test level rationale. |
| Every mock must have a specific reason and should usually sit at an external boundary. | Task 1, Task 2, Task 4 | Red command fails until the rubric, task template, and build/review guardrails mention mock rationale and mock-heavy tests. |
| Shape-only tests for interfaces, types, and structs are forbidden unless the shape is a runtime/public contract. | Task 1, Task 2, Task 4 | Red command fails until the rubric, task template, and guardrails mention shape-only tests and runtime contracts. |
| `build` must stop when a planned or generated Red test violates the rubric instead of inventing a weak test. | Task 4 | Red command fails until `build/SKILL.md` adds explicit stop conditions for rubric violations. |
| `review` should flag low-value tests as a validation issue, not only missing tests. | Task 4 | Red command fails until `review/SKILL.md` explicitly checks for low-value tests. |

## Global Verification

- `rg -n "test-quality-rubric|Requirement protected|Failure mode caught|Mocks used|shape-only|low-value tests" plugins/foundary-workflow plugins/foundary-git docs/plans`
- `rg -n "TBD until plan creates" docs/plans/2026-05-20-test-quality-rubric-design.md` should return no matches after the backlink update.
- Manual verification: read the changed skill docs and confirm no task asks `build` to redesign the plan or invent new test requirements.

## Task 1: Define the plan-owned test quality rubric

### Objective

Create the canonical plan-owned rubric that defines what makes a valuable test and what kinds of tests Foundary should avoid.

### Dependencies

- none

### Executor Decision Budget

The build agent may decide:
- exact wording inside the rubric when preserving the design intent
- heading order inside the rubric
- concise examples that clarify the rules

The build agent must not decide:
- to move the rubric outside `plan/assets`
- to introduce a standalone skill
- to weaken the mocking or shape-only test constraints
- to add unrelated test philosophy beyond the spec

### Pre-Read

Files the build agent must inspect before editing:
- `docs/plans/2026-05-20-test-quality-rubric-design.md`
- `plugins/foundary-workflow/skills/plan/SKILL.md`
- `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md`

### In Scope

- Add `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`.
- Define valuable test categories:
  - business requirement
  - regression / known bug
  - risk / edge case
  - runtime contract
- Define rules for minimal mocking and acceptable mock boundaries.
- Define rules forbidding shape-only tests unless the shape is a runtime/public contract.
- Define a Red Light acceptance checklist.

### Out of Scope

- Editing `plan/SKILL.md`.
- Editing `build`, `spec`, or `review`.
- Adding executable test infrastructure.

### Files

#### Create

- `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`
  - Purpose: Canonical rubric for deciding whether a planned test is valuable.

#### Modify

- none

#### Delete

- none

### Constraints

- Keep the asset concise and directly usable by `plan`.
- Do not ban all mocks.
- Do not ban all data-shape assertions.
- Preserve the distinction between static type/interface shape and runtime/public contract shape.

### Red Light

**Test Level:** documentation verification

**Test command before implementation:**

```bash
set -e
file=plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md
test -f "$file"
rg -n "Business requirement" "$file"
rg -n "Regression" "$file"
rg -n "Risk / edge case" "$file"
rg -n "Runtime contract" "$file"
rg -n "Mocks" "$file"
rg -n "Shape-only" "$file"
rg -n "Red Light acceptance" "$file"
```

### Scenarios

- Given `plan` needs a reusable definition of test value
  When the rubric asset is missing
  Then there is no canonical place to distinguish meaningful tests from ornamental tests

### Expected Failure Before Green

- `test -f` fails because `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md` does not exist.

### Verification Target

The rubric exists under `plan/assets` and defines test categories, mock limits, shape-only test limits, and a Red Light acceptance checklist.

### Green Light

Implement only:

1. In `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`, add the test quality rubric.

Do not:
- edit skill execution rules
- edit plan templates
- add a new skill
- modify plugin manifests

### Refactor

Allowed refactors only:
- tighten repeated wording inside the new rubric
- reorder rubric sections for readability
- remove unclear examples introduced by this task

Forbidden refactors:
- moving existing assets
- changing existing skill behaviour
- broad documentation cleanup

### Task Verification

Run:

```bash
set -e
file=plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md
test -f "$file"
rg -n "Business requirement" "$file"
rg -n "Regression" "$file"
rg -n "Risk / edge case" "$file"
rg -n "Runtime contract" "$file"
rg -n "Mocks" "$file"
rg -n "Shape-only" "$file"
rg -n "Red Light acceptance" "$file"
```

### Pass Condition

- The command passes.
- The rubric clearly states that a valuable test must protect a requirement, regression, risk, or runtime contract.
- The rubric explains mock rationale and shape-only test limits.

### Stop Condition

Stop after this task when:
- the rubric asset exists
- verification passes
- no other files were changed for this task

Do not begin the next task unless explicitly instructed.

### Done Criteria

- [ ] Behaviour implemented
- [ ] Tests pass
- [ ] Scope remained bounded
- [ ] Verification completed

## Task 2: Wire plan generation to the rubric

### Objective

Make `plan` read and apply the rubric before creating Red Light scenarios, and update plan templates so Red Light scenarios carry test quality intent.

### Dependencies

- Task 1

### Executor Decision Budget

The build agent may decide:
- exact heading names for template fields if they preserve the meaning
- whether to add quality information to the coverage table or as a separate nearby section
- compact wording for low-risk documentation tasks

The build agent must not decide:
- to remove existing traceability requirements
- to make quality fields optional without a stated low-risk reason
- to make `build` responsible for inventing missing test intent
- to add new workflow phases

### Pre-Read

Files the build agent must inspect before editing:
- `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`
- `plugins/foundary-workflow/skills/plan/SKILL.md`
- `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md`
- `plugins/foundary-workflow/skills/plan/assets/plan-header-template.md`
- `plugins/foundary-workflow/skills/plan/assets/implementation-plan-template.md`

### In Scope

- Update `plan/SKILL.md` to read `assets/test-quality-rubric.md` before generating Red Light scenarios.
- Require each Red Light scenario to include:
  - requirement protected
  - failure mode caught
  - test category
  - test level rationale
  - mocks used and reason for each
  - runtime contract rationale when asserting shape
- Update plan templates so generated plans expose these fields.
- Keep success criteria traceability intact.

### Out of Scope

- Editing the rubric content beyond tiny consistency fixes.
- Editing `spec`, `build`, or `review`.
- Changing plugin metadata.

### Files

#### Create

- none

#### Modify

- `plugins/foundary-workflow/skills/plan/SKILL.md`
  - Change: Require reading and applying `assets/test-quality-rubric.md` during planning.
  - Preserve: existing repository grounding, behaviour-first slicing, Red/Green/Refactor, and traceability rules.
- `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md`
  - Change: Add Red Light test intent fields and mock/runtime-contract rationale.
  - Preserve: existing Red Light, Green Light, Refactor, verification, and stop-condition structure.
- `plugins/foundary-workflow/skills/plan/assets/plan-header-template.md`
  - Change: Add test quality evidence to traceability or a nearby table.
  - Preserve: success criteria coverage table.
- `plugins/foundary-workflow/skills/plan/assets/implementation-plan-template.md`
  - Change: Reflect test quality evidence in the compact canonical plan interface.
  - Preserve: existing summary, task, and traceability sections.

#### Delete

- none

### Constraints

- The plan output must remain directly consumable by `build`.
- Do not require executor inference for whether a test is meaningful.
- Do not encourage unit tests when integration/e2e/manual verification is the better level.

### Red Light

**Test Level:** documentation verification

**Test command before implementation:**

```bash
set -e
files="plugins/foundary-workflow/skills/plan/SKILL.md plugins/foundary-workflow/skills/plan/assets/task-structure-template.md plugins/foundary-workflow/skills/plan/assets/plan-header-template.md plugins/foundary-workflow/skills/plan/assets/implementation-plan-template.md"
rg -n "test-quality-rubric" $files
rg -n "Requirement protected" $files
rg -n "Failure mode caught" $files
rg -n "Test category" $files
rg -n "Test level rationale" $files
rg -n "Mocks used" $files
rg -n "Runtime contract rationale" $files
```

### Scenarios

- Given a future plan includes a Red Light scenario
  When the plan is generated
  Then the scenario records what business rule, regression, risk, or runtime contract the test protects
- Given a future Red Light scenario uses mocks
  When the plan is generated
  Then each mock has a reason or the test is rewritten at a more appropriate level
- Given a future Red Light scenario asserts data shape
  When the plan is generated
  Then it explains the runtime/public contract or avoids the shape-only assertion

### Expected Failure Before Green

- The `rg` command returns no complete match set because the current plan skill and templates do not mention the rubric or Red Light test intent fields.

### Verification Target

`plan` is explicitly required to apply the rubric before Red Light generation, and every plan template can carry the required test quality metadata.

### Green Light

Implement only:

1. In `plugins/foundary-workflow/skills/plan/SKILL.md`, add rubric reading and Red Light quality-gate requirements in the planning workflow.
2. In `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md`, add the Red Light test intent fields.
3. In `plugins/foundary-workflow/skills/plan/assets/plan-header-template.md`, add test quality evidence to traceability.
4. In `plugins/foundary-workflow/skills/plan/assets/implementation-plan-template.md`, add compact test quality evidence fields.

Do not:
- rewrite unrelated planning rules
- weaken scope control
- introduce standalone test-review workflow
- add new dependencies

### Refactor

Allowed refactors only:
- remove duplicated wording introduced across plan files
- tighten field labels so they are easy for `build` to consume
- align terminology with the rubric

Forbidden refactors:
- moving plan assets
- changing unrelated template sections
- broad reformatting

### Task Verification

Run:

```bash
set -e
files="plugins/foundary-workflow/skills/plan/SKILL.md plugins/foundary-workflow/skills/plan/assets/task-structure-template.md plugins/foundary-workflow/skills/plan/assets/plan-header-template.md plugins/foundary-workflow/skills/plan/assets/implementation-plan-template.md"
rg -n "test-quality-rubric" $files
rg -n "Requirement protected" $files
rg -n "Failure mode caught" $files
rg -n "Test category" $files
rg -n "Test level rationale" $files
rg -n "Mocks used" $files
rg -n "Runtime contract rationale" $files
```

### Pass Condition

- The command passes with matches in `plan/SKILL.md` and the plan templates.
- Existing traceability requirements are still present.
- The template fields make weak tests visible before `build` runs.

### Stop Condition

Stop after this task when:
- plan skill and templates reference the rubric and required fields
- verification passes
- no changes outside plan-owned files were made

Do not begin the next task unless explicitly instructed.

### Done Criteria

- [ ] Behaviour implemented
- [ ] Tests pass
- [ ] Scope remained bounded
- [ ] Verification completed

## Task 3: Feed better testing intent from spec

### Objective

Update `spec` so design docs capture the business rules, known regressions, high-risk behaviour, runtime contracts, and non-test targets that `plan` needs to create valuable Red Light scenarios.

### Dependencies

- Task 2

### Executor Decision Budget

The build agent may decide:
- exact wording in the `Testing` template section
- whether a short instruction belongs in `spec/SKILL.md` as well as the template

The build agent must not decide:
- to duplicate the entire plan rubric in `spec`
- to make `spec` responsible for Red Light task structure
- to add new canonical spec sections unless necessary

### Pre-Read

Files the build agent must inspect before editing:
- `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`
- `plugins/foundary-workflow/skills/spec/SKILL.md`
- `plugins/foundary-workflow/skills/spec/assets/design-doc-template.md`

### In Scope

- Strengthen `spec/assets/design-doc-template.md` Testing guidance to ask for:
  - business rules / user outcomes to protect
  - known bugs or regressions
  - high-risk edge cases
  - runtime/public contracts
  - things not worth testing because type checking or implementation detail already covers them
- Add a short `spec/SKILL.md` instruction if needed so agents do not leave Testing vague.

### Out of Scope

- Moving test quality ownership out of `plan`.
- Adding Red Light task fields to spec.
- Editing build or review.

### Files

#### Create

- none

#### Modify

- `plugins/foundary-workflow/skills/spec/assets/design-doc-template.md`
  - Change: Replace the generic Testing placeholder with richer testing intent prompts.
  - Preserve: existing canonical section name `Testing`.
- `plugins/foundary-workflow/skills/spec/SKILL.md`
  - Change: Add lightweight guidance to make Testing useful for downstream plan generation.
  - Preserve: spec remains design-focused, not implementation planning.

#### Delete

- none

### Constraints

- Keep `spec` lightweight.
- Do not require bug history when none is available.
- Do not make every design doc verbose.

### Red Light

**Test Level:** documentation verification

**Test command before implementation:**

```bash
set -e
files="plugins/foundary-workflow/skills/spec/SKILL.md plugins/foundary-workflow/skills/spec/assets/design-doc-template.md"
rg -n "business rules" $files
rg -n "known bugs" $files
rg -n "regressions" $files
rg -n "high-risk" $files
rg -n "runtime/public contracts" $files
rg -n "not worth testing" $files
rg -n "type checking" $files
```

### Scenarios

- Given a future design spec has a Testing section
  When it is written
  Then it captures the business and bug-gap context needed for `plan`
- Given a future idea only changes static types
  When the Testing section is written
  Then it can state that shape-only tests are not valuable unless a runtime contract exists

### Expected Failure Before Green

- The `rg` command returns no complete match set because current spec guidance only says what to test, key scenarios, test data, or mocks.

### Verification Target

The spec template and skill guidance feed useful test intent into `plan` without duplicating the full rubric.

### Green Light

Implement only:

1. In `plugins/foundary-workflow/skills/spec/assets/design-doc-template.md`, expand the Testing placeholder.
2. In `plugins/foundary-workflow/skills/spec/SKILL.md`, add a short instruction that Testing should identify business rules, regressions, risks, contracts, and non-test targets when relevant.

Do not:
- add a standalone test-quality section
- rewrite the spec workflow
- duplicate the full plan rubric

### Refactor

Allowed refactors only:
- shorten verbose prompt text introduced by this task
- align terms with the plan rubric

Forbidden refactors:
- renaming canonical spec sections
- moving templates
- changing output path rules

### Task Verification

Run:

```bash
set -e
files="plugins/foundary-workflow/skills/spec/SKILL.md plugins/foundary-workflow/skills/spec/assets/design-doc-template.md"
rg -n "business rules" $files
rg -n "known bugs" $files
rg -n "regressions" $files
rg -n "high-risk" $files
rg -n "runtime/public contracts" $files
rg -n "not worth testing" $files
rg -n "type checking" $files
```

### Pass Condition

- The command passes.
- `spec` remains design-focused.
- Testing guidance is specific enough for `plan` to avoid inventing test intent.

### Stop Condition

Stop after this task when:
- spec guidance is updated
- verification passes
- no unrelated spec sections changed

Do not begin the next task unless explicitly instructed.

### Done Criteria

- [ ] Behaviour implemented
- [ ] Tests pass
- [ ] Scope remained bounded
- [ ] Verification completed

## Task 4: Add build and review guardrails for low-value tests

### Objective

Make `build` stop on planned/generated tests that violate the rubric, and make `review` flag low-value tests as validation issues.

### Dependencies

- Task 1
- Task 2

### Executor Decision Budget

The build agent may decide:
- whether `review` references the plan rubric directly or carries a short local summary
- exact wording for guardrail bullets
- where to place guardrails inside existing validation sections

The build agent must not decide:
- to make `build` redesign task scope
- to make `review` require tests for every change
- to ban all mocks or all data-shape assertions
- to edit unrelated git skills

### Pre-Read

Files the build agent must inspect before editing:
- `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`
- `plugins/foundary-workflow/skills/build/SKILL.md`
- `plugins/foundary-git/skills/review/SKILL.md`

### In Scope

- Update `build/SKILL.md` Red Light requirements and stop conditions so `build` stops when tests are:
  - ornamental
  - mock-heavy without external-boundary rationale
  - shape-only without runtime/public contract rationale
  - private implementation-detail assertions
  - missing a real failure mode
- Update `review/SKILL.md` validation guidance to flag low-value tests, not only missing tests.

### Out of Scope

- Editing `plan` after Task 2 except tiny wording alignment if necessary.
- Adding a standalone review skill.
- Requiring tests for low-risk documentation-only changes.

### Files

#### Create

- none

#### Modify

- `plugins/foundary-workflow/skills/build/SKILL.md`
  - Change: Add Red Light quality guardrails and stop conditions tied to the plan rubric.
  - Preserve: build treats the plan as source of truth and does not redesign scope.
- `plugins/foundary-git/skills/review/SKILL.md`
  - Change: Add review checks for low-value, mock-heavy, shape-only, and implementation-detail tests.
  - Preserve: review does not require tests for every change.

#### Delete

- none

### Constraints

- `build` should ask for plan/spec refinement when test intent is missing.
- `review` should distinguish missing critical validation from acceptable low-risk absence.
- Guardrails must not create an absolute ban on mocks or runtime contract assertions.

### Red Light

**Test Level:** documentation verification

**Test command before implementation:**

```bash
set -e
files="plugins/foundary-workflow/skills/build/SKILL.md plugins/foundary-git/skills/review/SKILL.md"
rg -n "low-value tests" $files
rg -n "mock-heavy" $files
rg -n "shape-only" $files
rg -n "runtime/public contract" $files
rg -n "ornamental" $files
rg -n "failure mode" $files
rg -n "implementation-detail" $files
```

### Scenarios

- Given a plan asks `build` to create a test with no failure mode
  When `build` validates Red Light work
  Then it stops and asks for plan/spec refinement
- Given a diff includes tests that mostly assert mocks or private implementation details
  When `review` checks validation
  Then it flags low-value tests as a validation concern
- Given a runtime API payload shape is a public contract
  When a test asserts that shape
  Then the guidance allows it when the runtime/public contract rationale is clear

### Expected Failure Before Green

- The `rg` command returns no complete match set because current build/review guidance does not mention low-value, mock-heavy, or shape-only tests.

### Verification Target

`build` and `review` can catch rubric violations without taking ownership of test design.

### Green Light

Implement only:

1. In `plugins/foundary-workflow/skills/build/SKILL.md`, add Red Light guardrails and stop conditions for rubric violations.
2. In `plugins/foundary-git/skills/review/SKILL.md`, add validation checks for low-value tests.

Do not:
- rewrite build execution order
- make review mutating
- require tests for all changes
- edit unrelated git skills

### Refactor

Allowed refactors only:
- tighten guardrail wording
- remove duplicate validation bullets introduced by this task

Forbidden refactors:
- changing review verdict categories
- changing build feedback loop structure
- broad style cleanup

### Task Verification

Run:

```bash
set -e
files="plugins/foundary-workflow/skills/build/SKILL.md plugins/foundary-git/skills/review/SKILL.md"
rg -n "low-value tests" $files
rg -n "mock-heavy" $files
rg -n "shape-only" $files
rg -n "runtime/public contract" $files
rg -n "ornamental" $files
rg -n "failure mode" $files
rg -n "implementation-detail" $files
```

### Pass Condition

- The command passes.
- `build` still executes the plan rather than redesigning it.
- `review` still avoids requiring tests for every change.

### Stop Condition

Stop after this task when:
- build and review guardrails are updated
- verification passes
- no unrelated skills changed

Do not begin the next task unless explicitly instructed.

### Done Criteria

- [ ] Behaviour implemented
- [ ] Tests pass
- [ ] Scope remained bounded
- [ ] Verification completed
