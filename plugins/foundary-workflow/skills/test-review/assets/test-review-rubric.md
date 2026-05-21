# Test Review Adapter

Use the shared Test Quality Rubric before reviewing existing or changed tests.

## Review Questions

Before accepting a test as useful, answer:

1. What behavior, requirement, regression, risk, or runtime contract does this test protect?
2. What realistic breakage would make it fail?
3. Would it fail for the right reason, or only because implementation details changed?
4. Could the implementation be broken while this test still passes?
5. Is the test cheaper to maintain than the risk it protects?

When the answer is unclear, prefer LOW VALUE, NOT WORTH KEEPING AS WRITTEN, or NEEDS CONTEXT over generic praise.

## Finding Requirements

Every finding should include:

- test file and line when available
- utility classification from the shared rubric
- finding type, such as missing meaningful test, over-mocked test, shape-only test, brittle assertion, or implementation-detail assertion
- behavior, requirement, risk, regression, or runtime contract involved
- realistic breakage that should make the test fail
- evidence for why the current test would miss or catch that breakage
- concise recommendation for improving the test

## Severity Guidance

- High: risky behavior, a known regression, security/permission rule, data integrity path, or runtime contract can break without a meaningful test failure.
- Medium: tests exist but are low-value, over-mocked, brittle, shape-only without runtime contract, or tied to implementation details enough to miss realistic breakage.
- Low: test clarity, naming, helper structure, or focused assertion improvements would reduce maintenance cost without changing coverage meaning.
