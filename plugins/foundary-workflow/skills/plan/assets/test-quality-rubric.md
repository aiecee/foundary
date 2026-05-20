# Test Quality Rubric

Use this rubric when planning Red Light scenarios. A good test is not a test that merely covers code; it is a test that would fail if a meaningful requirement, regression guard, risk, or runtime contract were broken.

## Valuable Test Categories

Every planned test must fit at least one category.

### Business requirement

Protects a user-visible outcome, business rule, permission rule, workflow step, calculation, policy, or domain invariant.

### Regression / known bug

Protects behaviour that previously failed, was recently fixed, or is likely to regress because the same code path is changing.

### Risk / edge case

Protects high-risk behaviour such as empty input, invalid input, boundary values, authorization failures, concurrency, recovery, migration, or compatibility.

### Runtime contract

Protects data shape or protocol only when it crosses a runtime/public boundary, such as an API response, serialized payload, database record, webhook body, config file, CLI output, or public SDK contract.

## Weak Tests To Avoid

Do not plan tests that mainly:

- prove an interface, type, or struct has fields already enforced by the type checker
- mirror implementation structure without protecting behaviour
- assert private helper calls instead of observable outcomes
- assert `wasCalledWith` unless the outward command, event, or integration call is the behaviour
- snapshot broad output when the stable contract is smaller and can be asserted directly
- pass because mocks reproduce the implementation rather than because real behaviour works

## Mocks

Prefer real collaborators, in-memory stores, local fakes, fixtures, or a higher-level test before adding mocks.

Mocks are acceptable when they isolate a true boundary:

- network services
- payment, email, auth, analytics, or other external providers
- filesystem, clock, randomness, queues, or process boundaries when real use is risky or slow
- expensive services where a local fake would add more complexity than value

Every mock must have a reason. If a test needs many mocks, prefer an integration or e2e test unless the task explicitly justifies the isolation.

## Shape-only Tests

Do not test static interface, type, or struct shape by mirroring its fields in assertions. Static shape belongs to the compiler or type checker.

Shape assertions are useful only when the shape is a runtime contract. When asserting shape, state the boundary and the consumer that depends on it.

## Red Light acceptance

Before including a Red Light scenario, confirm:

- Requirement protected: the requirement, regression, risk, or runtime contract is named.
- Failure mode caught: the test would fail for a realistic broken behaviour.
- Test category: one of business requirement, regression / known bug, risk / edge case, or runtime contract is identified.
- Test level rationale: unit, integration, e2e, or manual verification is justified by the behaviour being protected.
- Mocks used: each mock has a reason and sits at an appropriate boundary.
- Runtime contract rationale: any data-shape assertion names the runtime/public boundary.
- Rewrite durability: the test would remain valuable if the implementation were rewritten.
