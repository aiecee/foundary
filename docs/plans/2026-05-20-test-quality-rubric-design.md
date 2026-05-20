# Test quality rubric integration

**Date:** 2026-05-20
**Implementation plan:** docs/plans/2026-05-20-test-quality-rubric.md

## Goal

Make Foundary generate and enforce tests that protect business requirements, known regressions, or real behavioural risks, while reducing mock-heavy tests and tests that only mirror data structures.

## Summary

The current workflow already requires traceability from success criteria to Red Light scenarios, but it does not define what makes a test valuable. This design adds a plan-owned test quality rubric and lightweight enforcement points so `spec -> plan -> build -> review` produces tests with clear intent instead of tests for the sake of tests.

## Success criteria

- `plan` owns a canonical test quality rubric asset at `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`.
- `plan` must read the rubric before creating Red Light scenarios.
- Every Red Light scenario must declare the requirement, bug/regression, risk, or runtime contract it protects.
- Every Red Light scenario must explain why its chosen level is appropriate: unit, integration, e2e, or manual verification.
- Every mock must have a specific reason and should usually sit at an external boundary.
- Shape-only tests for interfaces, types, and structs are forbidden unless the shape is a runtime/public contract.
- `build` must stop when a planned or generated Red test violates the rubric instead of inventing a weak test.
- `review` should flag low-value tests as a validation issue, not only missing tests.

## Constraints

- Follow the existing repo asset pattern: assets live beside the skill that owns them.
- Keep the rubric owned by `plan`; do not introduce a standalone skill for this initial change.
- Keep `build` as an executor and guardrail, not a redesign or test-authoring workflow.
- Keep `spec` lightweight; it should feed better testing context into `plan`, not duplicate the full rubric.
- Avoid broad workflow rewrites outside the testing quality path.

## Non-functional requirements

- The rubric must be concise enough for agents to apply consistently during planning.
- The added fields must improve test intent without making every task noisy.
- The workflow should prefer meaningful verification over maximum unit test count.
- The rules should reduce brittle tests and false confidence.

## Repository context

- `plugins/foundary-workflow/skills/plan/SKILL.md` currently requires success criteria to map to Red Light scenarios, but does not require test value or failure-mode justification.
- `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md` already has a Red Light section with test level, command, scenario, expected failure, and verification target. This is the main template to tighten.
- `plugins/foundary-workflow/skills/build/SKILL.md` already requires Red-first tests and behaviour-meaningful failures, but it treats the plan as source of truth.
- `plugins/foundary-workflow/skills/spec/assets/design-doc-template.md` currently asks what to test, but not which business rules, regressions, or risks should drive testing.
- `plugins/foundary-git/skills/review/SKILL.md` checks for missing tests and validation, but not explicitly for low-value, mock-heavy, or shape-only tests.

## Options considered

### Option 1: Plan-owned rubric asset

Create `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md` and require `plan` to apply it when generating Red Light scenarios. `build` and `review` reference the plan-owned rubric as guardrails.

Pros:
- Fits the existing asset pattern.
- Places test quality where tests are selected and shaped.
- Keeps one canonical definition of a valuable test.
- Prevents weak tests before implementation starts.

Cons:
- `build` and `review` must reference an asset owned by `plan`.
- The rubric must stay compact or it may slow planning down.

### Option 2: Standalone test-quality skill

Create a new skill dedicated to reviewing or designing tests.

Pros:
- Useful later for independent test audits.
- Gives test quality a clear named workflow.

Cons:
- Does not prevent weak tests unless users or agents remember to invoke it.
- Adds workflow surface area before the core problem is solved.
- Risks duplicating logic already needed inside `plan`.

### Option 3: Inline rules in every skill

Copy test quality rules into `spec`, `plan`, `build`, and `review`.

Pros:
- No cross-skill asset references.
- Each skill has local instructions.

Cons:
- High drift risk.
- Harder to tune the test quality standard.
- Repeats the same philosophy in multiple places.

## Recommendation

Use Option 1: add a plan-owned rubric asset and wire the existing workflow around it.

The main issue is that weak tests are born during planning. `plan` should define and apply the quality standard; `build` should enforce it during Red Light execution; `review` should catch violations after changes exist; `spec` should provide better testing inputs without becoming the owner of the rubric.

## Architecture

The workflow remains `spec -> plan -> build`, with `review` available as a git backstop.

- `spec` captures business rules, known regressions, high-risk behaviour, runtime contracts, and non-testable implementation details.
- `plan` reads `assets/test-quality-rubric.md`, converts spec testing expectations into Red Light scenarios, and rejects tests that cannot justify their value.
- `build` executes the plan and stops if the planned/generated Red test is ornamental, mock-heavy without reason, shape-only without runtime contract, or implementation-detail focused.
- `review` checks changed tests for the same quality risks when assessing commit readiness.

## Components

- `plugins/foundary-workflow/skills/plan/assets/test-quality-rubric.md`
  - Defines valuable test categories, mocking limits, data-shape testing limits, and Red test acceptance checks.
- `plugins/foundary-workflow/skills/plan/SKILL.md`
  - Requires reading and applying the rubric while creating Red Light scenarios.
- `plugins/foundary-workflow/skills/plan/assets/task-structure-template.md`
  - Adds test intent fields to Red Light.
- `plugins/foundary-workflow/skills/build/SKILL.md`
  - Adds stop conditions for rubric violations during Red Light execution.
- `plugins/foundary-workflow/skills/spec/assets/design-doc-template.md`
  - Strengthens the Testing section so planning has business and bug-gap context.
- `plugins/foundary-git/skills/review/SKILL.md`
  - Adds review guidance for low-value tests.

## Data flow

1. The design spec identifies behaviours worth protecting: business requirements, bug/regression gaps, risk/edge cases, and runtime contracts.
2. The implementation plan maps those behaviours to tasks and Red Light scenarios.
3. Each Red Light scenario records:
   - requirement protected
   - failure mode caught
   - test category
   - test level rationale
   - mocks used and reason for each
   - runtime contract rationale when asserting data shape
4. Build writes and runs only tests that satisfy those fields.
5. Review checks whether added or changed tests still protect meaningful behaviour.

## Error handling

- If `plan` cannot classify a proposed test as a business requirement, regression, risk/edge case, or runtime contract, it should remove or rewrite the test.
- If `plan` cannot justify mocks, it should choose a more real collaborator, in-memory fake, test harness, or higher-level test.
- If `build` finds a Red Light instruction that violates the rubric, it should stop and ask whether to update the plan or spec.
- If `review` finds tests that only mirror mocks, private implementation details, or static data structures, it should flag them as validation concerns.

## Testing

This change is itself workflow documentation. Verification should focus on generated plan quality rather than executable tests.

Manual verification examples:
- Given a feature with a business rule, when `plan` generates tasks, then each Red Light scenario names the protected requirement and failure mode.
- Given a proposal to mock internal domain collaborators, when `plan` applies the rubric, then it either chooses a more realistic test level or records a clear external-boundary reason.
- Given a type/interface-only change, when `plan` proposes testing, then it does not create a shape-only test unless the shape crosses a runtime/public contract.
- Given changed tests in a diff, when `review` runs, then it can flag low-value tests even if tests are present.

## Out of scope

- Creating a standalone test review skill.
- Rewriting all workflow skills around a new testing model.
- Adding executable test infrastructure to this repository.
- Requiring tests for every change regardless of risk.
- Banning all mocks.
- Banning all data-shape assertions.

## Assumptions

- The main source of low-value tests is `plan` producing weak Red Light instructions.
- Most useful enforcement can happen through skill instructions and templates.
- A standalone test-quality skill may be valuable later, but it is premature for this problem.
- The rubric will be most effective if it is concise and directly tied to the task template.

## Dependencies

- Existing Foundary workflow skill layout.
- Existing `plan/assets` template pattern.
- Existing `build` Red/Green/Refactor execution model.
- Existing `review` validation guidance.

## Open questions

- Should `review` reference the `plan` rubric directly, or should it carry a short local summary to avoid cross-plugin coupling?
- Should the task template require all Red Light metadata every time, or allow a compact form for simple low-risk changes?
- Should manual verification be listed as a test level in the rubric alongside unit, integration, and e2e?
