---
name: test-rubric
description: Use when planning, adding, or reviewing tests. Defines how to choose the smallest useful tests, place them at the right level, and prove behaviour without testing implementation details.
---

# Test Rubric

Tests exist to prove behaviour the system promises. Prefer the smallest test that gives real confidence.

## Planning Tests

Before proposing tests:

1. Read the code being changed.
2. Read nearby tests and copy their style.
3. Identify the public behaviour or contract.
4. Identify where that behaviour is owned.
5. Decide whether this change needs a test.
6. Prefer extending an existing test file over creating a new one.
7. Keep the test count as small as possible.

## Test Placement

Place the test at the lowest boundary that proves the behaviour without mocking away the thing being tested.

Choose the level by ownership:

- Pure transformation or branching logic -> unit test the function/module that owns it.
- Component rendering or interaction -> component test the component that owns the behaviour.
- Hook/state coordination -> hook or component test at the smallest consumer boundary.
- API handler behaviour -> handler/request-level test, not full app E2E.
- Database query/repository logic -> repository/query test with the repo's existing DB test pattern.
- Cross-module wiring -> integration test at the boundary where the modules connect.
- Critical user journey -> E2E only when the value is in the full journey.

Avoid testing too high:

- Do not add E2E coverage for logic that can be proven in a unit/component test.
- Do not add page-level tests for behaviour owned by a child component.
- Do not add app-level tests for handler/query logic.
- Do not add broad integration tests because setup is convenient.
- Do not test through three layers just to reach one branch.

Move up the stack only when:

- the bug was caused by integration between layers.
- the public contract exists only at the higher boundary.
- lower-level tests would require mocking most of the behaviour.
- the repo already treats this behaviour as integration/E2E-owned.
- the regression escaped because no higher-level coverage existed.

## Good Tests

Good tests:

- fail before the fix.
- prove user-visible or caller-visible behaviour.
- cover the changed contract, branch, or regression.
- follow nearby test style.
- use existing helpers.
- keep assertions simpler than the implementation.
- make the reason for the test obvious.
- can be explained as Given / When / Then without mentioning private implementation details.

## Bad Tests

Avoid tests that:

- only check "does not throw" or "renders".
- assert private implementation details.
- mock the thing being tested.
- recreate the implementation logic in the expectation.
- add fixtures, factories, or helpers for one case.
- snapshot small logic changes.
- test framework/library behaviour.
- test private functions introduced only to make testing easier.

## Regression Tests

For bug fixes:

1. Reproduce the bug with the smallest failing case.
2. Put the test at the layer that owns the broken behaviour.
3. Assert the corrected behaviour, not the internal fix.
4. Cover sibling callers only when the bug lives in shared logic.
5. Avoid adding a broad integration test if a focused regression test proves the fix.

## Mocks

Mocks are a cost.

Use mocks only when:

- crossing a network, process, time, randomness, or filesystem boundary.
- the repo already mocks that dependency at this layer.
- the real dependency is slow, flaky, destructive, or unavailable.
- the test would otherwise be unreadable.

Never mock the behaviour being tested. If the test only proves the mock was called, it is probably too close to the implementation.

## Test Count

Use the fewest tests that prove the behaviour.

- Trivial one-line changes may need no test.
- Non-trivial branches need at least one meaningful check.
- Bug fixes should usually add one regression test.
- Shared logic deserves coverage at its public boundary.
- Multiple tests are justified when they prove meaningfully different behaviours.
- Do not create one test per function by default.

## No-Test Cases

It is acceptable to add no test when:

- the change is trivial.
- behaviour is already covered.
- the change only affects copy, styling, or wiring with no practical test value.
- adding the test would require disproportionate setup.
- the repo has no useful test pattern for this kind of change.

If skipping tests, state why.

## Review Checklist

Before finishing, check:

- Would this test fail before the code change?
- Does it prove behaviour a user or caller relies on?
- Is this the lowest useful test level?
- Is the assertion simpler than the implementation?
- Did I avoid new test-only abstractions?
- Did I follow nearby test style?
- Can any test be deleted, merged, or moved lower?

## Plan Output

When planning tests, include:

- behaviour to prove.
- owner of that behaviour.
- chosen test level.
- why this is the lowest useful level.
- existing test file to extend, if known.
- Given: the starting state, inputs, or preconditions.
- When: the action, event, or call under test.
- Then: the observable result that proves the behaviour.
- command to run.
- any meaningful gap left untested.
