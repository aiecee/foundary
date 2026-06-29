# Plan Verification Quality Adapter

Use the shared Test Quality Rubric before choosing a verification posture or planning Red Light scenarios.

## Verification Posture Acceptance

Every task must choose one posture:

- `new automated test`
- `existing coverage / characterization`
- `manual verification`
- `no new test`

Choose `new automated test` only when repository, spec, or strategy evidence can name the protected requirement, realistic failure mode, smallest stable boundary, insufficiency of existing verification, maintenance value, and rewrite durability.

Use `existing coverage / characterization`, `manual verification`, or `no new test` when new automated coverage would be low value, redundant, implementation-detail focused, or more expensive to maintain than the risk it protects.

## New Automated Test Acceptance

Before including a Red Light scenario, confirm and record:

- Requirement protected: the requirement, regression, risk, or runtime contract is named.
- Failure mode caught: the test would fail for a realistic broken behavior.
- Boundary rationale: the selected boundary is the smallest stable boundary that proves the behavior.
- Mocks used: each mock or fake has a reason and sits at an appropriate boundary.
- Runtime contract rationale: any data-shape assertion names the runtime/public boundary and consumer.
- Rewrite durability: the test would remain valuable if the implementation were rewritten.

Reject new automated tests for README wording, docs phrasing, labels, comments, regex phrase checks, static type shape, private helper calls, call order, mock choreography, broad snapshots, trivial wiring, or generated boilerplate unless a concrete runtime/public contract and realistic failure mode are named.
