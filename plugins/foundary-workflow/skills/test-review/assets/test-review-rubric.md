# Test Review Rubric

Use this rubric when reviewing existing or changed tests. A good test is not valuable because it exists; it is valuable because it would fail if a meaningful requirement, regression guard, risk, or runtime contract were broken.

The review should judge tests against the behaviour they protect, not against raw coverage volume or implementation shape.

Do not treat a test as useful unless the protected behaviour and realistic failure mode can be named.

## Utility classifications

Classify reviewed tests by usefulness:

- HIGH VALUE: Protects a meaningful behaviour, regression, risk, or runtime/public contract and would fail if that behaviour broke.
- USEFUL BUT WEAK: Protects something real, but assertion level, mocking, fixture design, or brittleness limits confidence.
- LOW VALUE: Mostly checks implementation shape, mock choreography, static structure, or incidental output without clear behavioural protection.
- NOT WORTH KEEPING AS WRITTEN: Maintenance cost is higher than the behavioural protection it provides.
- NEEDS CONTEXT: Usefulness cannot be judged without missing requirement, bug, or runtime-boundary context.

If no clear requirement, failure mode, or runtime contract can be named, classify the test as LOW VALUE or NOT WORTH KEEPING AS WRITTEN.

Use NEEDS CONTEXT only when a specific missing piece of context could materially change the judgement, such as a production incident, compatibility promise, public API contract, or project convention.

## Fail-usefully gate

Before accepting a test as useful, answer:

1. What behaviour, requirement, regression, risk, or runtime contract does this test protect?
2. What realistic breakage would make it fail?
3. Would it fail for the right reason, or only because implementation details changed?
4. Could the implementation be broken while this test still passes?
5. Is the test cheaper to maintain than the risk it protects?

When the answer is unclear, prefer a LOW VALUE, NOT WORTH KEEPING AS WRITTEN, or NEEDS CONTEXT classification over generic praise.

## Valuable tests

A valuable test clearly protects at least one of these:

- a user-visible workflow, business rule, permission rule, calculation, policy, or domain invariant
- a known bug, recent regression, or failure mode likely to return
- a risky edge case such as empty input, invalid input, boundary values, authorization failure, concurrency, recovery, migration, or compatibility
- a runtime or public contract such as an API response, serialized payload, database record, webhook body, config file, CLI output, or SDK boundary

Prefer tests that would stay useful if the implementation were rewritten while the behaviour stayed the same.

## Weak tests

Flag a test as weak when it mainly:

- proves a static interface, type, or struct has fields already enforced by tooling
- mirrors private implementation structure instead of observable behaviour
- asserts helper calls rather than the resulting output, state, event, command, or integration effect
- checks that mocks were called in the same way the implementation is written
- snapshots broad output when a smaller stable contract could be asserted directly
- duplicates the implementation logic so both the code and test can be wrong in the same way

Weak tests are not automatically useless, but they need a clear requirement or failure mode to justify their maintenance cost.

When weak tests protect something real, classify them as USEFUL BUT WEAK and name the remaining weakness. When they do not protect a clear requirement, failure mode, or runtime contract, classify them as LOW VALUE or NOT WORTH KEEPING AS WRITTEN.

## Over-mocked tests

Flag over-mocked tests when mocks replace the behaviour the test claims to protect.

Mocks are reasonable at true boundaries:

- network services
- payment, email, auth, analytics, or other external providers
- filesystem, clock, randomness, queues, process boundaries, or expensive services when real use is risky or slow

A mock-heavy test should explain why isolation is better than a real collaborator, in-memory store, local fake, fixture, integration test, or e2e test. If mocks reproduce internal implementation steps, the test may pass while real behaviour is broken.

If the only clear protection is mock choreography, classify the test as LOW VALUE unless the call itself is the runtime contract.

## Shape-only tests

Flag shape-only tests when they assert static structure without a runtime consumer or public boundary.

Shape assertions are useful when the shape crosses a runtime boundary. In that case, the test should make the boundary clear, for example an API payload, persisted record, webhook contract, config file, CLI output, or public SDK response.

Without a runtime consumer or public boundary, classify shape-only tests as LOW VALUE or NOT WORTH KEEPING AS WRITTEN.

## Brittle snapshots or assertions

Flag brittle tests when minor safe refactors, formatting changes, generated IDs, ordering, timestamps, localization, or incidental markup can fail the test without breaking the requirement.

Snapshots can be valid when the snapshot is the most concise way to protect a stable public contract. Prefer focused assertions when only a small part of the output matters.

Classify broad or incidental snapshots as USEFUL BUT WEAK only when they still protect a real contract. Otherwise classify them as LOW VALUE.

## Implementation-detail assertions

Flag tests that bind to private helpers, internal state, class names, call order, or intermediate transformations when the externally observable behaviour is what matters.

Implementation-detail assertions are acceptable only when the implementation detail is itself the contract, such as a required integration call, emitted event, performance-sensitive batching rule, migration step, or compatibility shim.

When an implementation-detail assertion would fail mainly because private code changed, not because user-visible or boundary behaviour broke, classify it as LOW VALUE.

## Missing meaningful coverage

Report a missing meaningful test when a real requirement, bug history, risk, or runtime contract lacks protection.

Good missing-coverage findings name:

- the behaviour at risk
- the realistic failure mode that could escape
- the level that would best catch it, such as unit, integration, e2e, contract, or manual verification
- any boundary where a mock or fake would be justified

Do not demand tests for every line or every low-risk change. It is acceptable to note low-risk absence when behaviour is already covered elsewhere, the change is mechanical, or manual verification is more appropriate than an automated test.

## Recommendations

For LOW VALUE or NOT WORTH KEEPING AS WRITTEN tests, recommend one of:

- keep as-is
- keep but strengthen
- replace with a behaviour-level test
- delete if not required by project convention
- move to a lower-priority follow-up

Choose keep as-is only when the test is cheap, harmless, and aligned with project convention despite limited behavioural protection.
