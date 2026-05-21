# Plan Test Quality Adapter

Use the shared Test Quality Rubric before planning Red Light scenarios.

## Red Light Acceptance

Before including a Red Light scenario, confirm and record:

- Requirement protected: the requirement, regression, risk, or runtime contract is named.
- Failure mode caught: the test would fail for a realistic broken behavior.
- Test category: business requirement, regression / known bug, risk / edge case, or runtime contract.
- Test level rationale: unit, integration, end-to-end, or manual verification is justified by the behavior being protected.
- Mocks used: each mock or fake has a reason and sits at an appropriate boundary.
- Runtime contract rationale: any data-shape assertion names the runtime/public boundary and consumer.
- Rewrite durability: the test would remain valuable if the implementation were rewritten.
