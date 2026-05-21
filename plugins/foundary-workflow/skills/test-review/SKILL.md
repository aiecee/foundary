---
name: test-review
description: Read-only workflow review of existing or changed tests for behaviour value, real coverage gaps, mocking quality, brittle assertions, and weak data-shape checks.
compatibility: 'Requires: git and filesystem access. May run clearly non-mutating test or inspection commands when safe.'
---

# Test Review

Review existing or changed tests to decide whether they protect meaningful behaviour. This skill is for test quality judgement, not git readiness and not automatic test rewriting.

## Core rules

- This skill is read-only by default.
- Never edit tests, implementation files, docs, fixtures, snapshots, or configuration.
- Never stage, commit, push, amend, or otherwise perform git operations.
- Never mutate external systems.
- Prefer evidence over assumptions.
- Judge tests by the requirement, regression, risk, or runtime contract they protect.
- Do not treat a test as useful unless the protected behaviour and realistic failure mode can be named.
- Do not require tests for every change.
- Do not treat every mock, snapshot, or data-shape assertion as invalid.

If the user asks for fixes, recommend follow-up changes or a `plan`/`build` workflow instead of editing directly.

## Required rubrics

Before reviewing tests, read:

- `../../assets/test-quality-rubric.md`
- `assets/test-review-rubric.md`

Use the rubrics to classify:

- test utility: HIGH VALUE, USEFUL BUT WEAK, LOW VALUE, NOT WORTH KEEPING AS WRITTEN, or NEEDS CONTEXT
- missing meaningful test
- low-value test
- over-mocked test
- shape-only test without runtime contract
- brittle snapshot or assertion
- implementation-detail assertion
- unclear requirement or failure mode

## Allowed

You may:

- read tests, fixtures, snapshots, and related source files
- inspect specs, plans, docs, bug notes, or local issue context when available
- inspect git history or diffs to understand changed tests
- inspect project manifests and validation commands
- run clearly non-mutating commands, such as targeted tests, type checks, grep-style searches, or dry-run inspection commands
- produce findings, risk notes, and recommended follow-up actions

## Forbidden

You must not:

- create, edit, delete, move, or format files
- update snapshots
- generate or rewrite tests
- stage, commit, push, amend, split, stash, or reset git changes
- run migrations, generators, package installers, fixers, update commands, or test commands that mutate persistent state
- use write-mode MCP tools, plugins, or external integrations
- silently fix discovered test problems

If a command might mutate state and this cannot be confidently ruled out, do not run it.

## Review scope

Determine the narrowest useful scope from the user request:

- changed tests in the working tree, staged diff, branch diff, or PR context
- a specific test file or directory
- tests for a specific feature, bug, module, endpoint, workflow, or component
- a repo-level sample only when the user explicitly asks for a broad audit

If the scope is unclear, ask whether to review changed tests, a specific path, or a broader test area.

## Context to inspect

Inspect enough related context to judge whether tests protect real behaviour:

- the test files and assertions under review
- related implementation files
- specs, plans, acceptance criteria, or design docs
- known bug or regression context when locally available
- fixtures, factories, fakes, mocks, snapshots, and helpers used by the tests
- validation commands and test runner configuration when needed

Prefer focused inspection. Avoid broad repository crawling unless the review scope requires it.

## Workflow

1. Read `../../assets/test-quality-rubric.md` and `assets/test-review-rubric.md`.
2. Establish review scope from the user request.
3. Identify test files, helpers, mocks, fixtures, and snapshots in scope.
4. Inspect related implementation and requirement context.
5. Optionally run safe, targeted validation commands when they clarify the review.
6. Classify findings using the required finding types.
7. Report findings first, ordered by severity.
8. Recommend follow-up actions without editing files.

## Finding quality

Every finding should include:

- the test file and line when available
- the utility classification
- the finding type, such as missing meaningful test or over-mocked test
- the behaviour, requirement, risk, regression, or runtime contract involved
- the realistic breakage that should make the test fail
- why the current test would fail to catch a realistic broken behaviour
- whether the implementation could be broken while the test still passes
- a concise recommendation for improving the test
- confidence when evidence is partial

Avoid findings that only say coverage is low. Explain the behaviour or failure mode that matters.

## Usefulness gate

Before praising or accepting a test, answer:

1. What behaviour, requirement, regression, risk, or runtime contract does this test protect?
2. What realistic breakage would make it fail?
3. Would it fail for the right reason, or only because implementation details changed?
4. Could the implementation be broken while this test still passes?
5. Is the test cheaper to maintain than the risk it protects?

If these cannot be answered from available evidence, classify the test as LOW VALUE or NEEDS CONTEXT rather than useful.

## Output format

Lead with findings. Use this shape:

```text
Findings
- [severity] file:line - finding type
  Utility: HIGH VALUE | USEFUL BUT WEAK | LOW VALUE | NOT WORTH KEEPING AS WRITTEN | NEEDS CONTEXT
  Behaviour/risk:
  Realistic failure mode:
  Evidence:
  Recommendation:

Useful tests observed
- file:line
  Utility:
  Behaviour/contract protected:
  Why useful:
  What would break it:
  Remaining weakness:

Not worth testing / acceptable absence
- reason, when useful

Open questions
- unclear requirement, missing bug context, or command safety issue

Review outcome
- ACCEPT TESTS | ACCEPT WITH RISKS | REWORK TESTS | NO MEANINGFUL TEST REVIEW POSSIBLE
```

If there are no actionable findings, say that clearly and mention remaining test gaps or residual risk.

End each review with exactly one review outcome:

- ACCEPT TESTS: Tests provide meaningful protection for the reviewed scope.
- ACCEPT WITH RISKS: Tests are useful enough to keep, but important gaps or weaknesses remain.
- REWORK TESTS: Tests exist but do not provide enough meaningful behavioural protection.
- NO MEANINGFUL TEST REVIEW POSSIBLE: Required context is missing.

This is a test-usefulness judgement, not a git readiness decision.

For LOW VALUE or NOT WORTH KEEPING AS WRITTEN tests, recommend one of:

- keep as-is
- keep but strengthen
- replace with a behaviour-level test
- delete if not required by project convention
- move to a lower-priority follow-up

When recommending replacement or strengthening, apply `../../assets/test-quality-rubric.md`.

## Severity guidance

- High: A risky behaviour, known regression, security/permission rule, data integrity path, or runtime contract can break without a meaningful test failure.
- Medium: Tests exist but are low-value, over-mocked, brittle, shape-only without runtime contract, or tied to implementation details enough to miss realistic breakage.
- Low: Test clarity, naming, helper structure, or focused assertion improvements that would reduce maintenance cost without changing coverage meaning.

## Relationship to other skills

- Use `plan` when the user wants to design new test intent for future implementation.
- Use `build` when the user has an approved plan and wants implementation.
- Use `investigate` when the user only wants broad read-only repository understanding.
- Keep `foundary-git` skills focused on repository status, diff review, conflict resolution, splitting, and committing.
