# Test Quality Rubric

Use this rubric before planning, creating, modifying, reviewing, or recommending tests.

A good test proves behavior at the smallest stable boundary that catches a realistic failure. It is valuable because it would fail if a meaningful requirement, regression guard, risk, or runtime contract were broken.

## Boundary Selection

- For pure business rules and decision logic, prefer pure tests with plain data inputs and outputs.
- Use component, UI, HTTP, database, integration, or end-to-end tests when framework wiring, integration contracts, persistence, runtime boundaries, or user interaction is the behavior under test.
- Prefer real collaborators, in-memory stores, local fakes, fixtures, or a higher-level test before adding mocks.
- Mock only external, slow, nondeterministic, expensive, or out-of-process dependencies unless the test boundary explicitly requires otherwise.
- If a test needs many mocks, pause and reconsider whether a smaller pure boundary, a local fake, or a broader integration boundary would prove the behavior with less coupling.
- Do not extract helpers only for tests unless the helper represents a real domain, policy, parsing, validation, transformation, or decision boundary.

## Valuable Test Categories

Every meaningful test should fit at least one category:

- Business requirement: protects a user-visible outcome, workflow step, business rule, permission rule, calculation, policy, or domain invariant.
- Regression / known bug: protects behavior that previously failed, was recently fixed, or is likely to regress because the same code path is changing.
- Risk / edge case: protects high-risk behavior such as empty input, invalid input, boundary values, authorization failures, concurrency, recovery, migration, or compatibility.
- Runtime contract: protects data shape or protocol that crosses a runtime or public boundary, such as an API response, serialized payload, database record, webhook body, config file, CLI output, or public SDK contract.

## Required Evidence

Every meaningful test recommendation should be able to state:

- Requirement protected: the behavior, regression, risk, or runtime contract under test.
- Failure mode caught: the realistic broken behavior that would fail the test.
- Test category: business requirement, regression / known bug, risk / edge case, or runtime contract.
- Boundary rationale: why this test level is the smallest stable boundary that proves the requirement.
- Mocks and fakes: which are used, why they are necessary, and what real boundary they isolate.
- Runtime contract rationale: when asserting data shape, the public/runtime boundary and consumer that depend on it.
- Rewrite durability: why the test would remain valuable if the implementation were rewritten.

## Weak Test Signals

Reconsider the test when it mainly:

- proves a static interface, type, or struct has fields already enforced by tooling
- mirrors private implementation structure instead of observable behavior
- asserts helper calls, call order, or mock choreography without an external contract
- uses many mocks to recreate the implementation path
- snapshots broad output when a smaller stable contract can be asserted directly
- duplicates implementation logic so code and test can be wrong in the same way
- fails because private code changed rather than because the protected behavior broke

## Mocks And Fakes

Mocks are reasonable when they isolate a true boundary:

- network services
- payment, email, auth, analytics, or other external providers
- filesystem, clock, randomness, queues, process boundaries, or expensive services when real use is risky or slow
- compatibility shims or required integration calls when the call itself is the runtime contract

Every mock must have a reason. A mock-heavy test should explain why isolation is better than a real collaborator, in-memory store, local fake, fixture, integration test, or end-to-end test.

If the only clear protection is mock choreography, classify or treat the test as low value unless the call itself is the runtime/public contract.

## Shape And Runtime Contracts

Do not test static interface, type, or struct shape by mirroring fields in assertions. Static shape belongs to the compiler or type checker.

Shape assertions are useful only when the shape crosses a runtime/public boundary. In that case, state the boundary and the consumer that depends on it.

## Utility Classifications

Use these classifications when reviewing existing or proposed tests:

- HIGH VALUE: protects meaningful behavior, a regression, a risk, or a runtime/public contract and would fail if that behavior broke.
- USEFUL BUT WEAK: protects something real, but assertion level, mocking, fixture design, brittleness, or boundary choice limits confidence.
- LOW VALUE: mostly checks implementation shape, mock choreography, static structure, or incidental output without clear behavioral protection.
- NOT WORTH KEEPING AS WRITTEN: maintenance cost is higher than the behavioral protection it provides.
- NEEDS CONTEXT: usefulness cannot be judged without missing requirement, bug, runtime-boundary, public-contract, or project-convention context.

If no clear requirement, failure mode, or runtime contract can be named, classify the test as LOW VALUE or NOT WORTH KEEPING AS WRITTEN.

## Recommendation Guidance

For LOW VALUE or NOT WORTH KEEPING AS WRITTEN tests, recommend one of:

- keep as-is
- keep but strengthen
- replace with a behavior-level test
- delete if not required by project convention
- move to a lower-priority follow-up

Choose keep as-is only when the test is cheap, harmless, and aligned with project convention despite limited behavioral protection.
