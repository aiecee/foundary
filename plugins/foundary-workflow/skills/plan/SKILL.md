---
name: plan
description: Turn a goal, strategy, or rough change request into a compact behaviour-first implementation plan with clear scope, test intent, and verification.
compatibility: 'Requires: git and filesystem access. May inspect repository context and read test-rubric when tests are relevant.'
---

# Plan

Create a compact implementation plan that helps a human or agent implement a change safely.

This skill is for planning only. Do not edit files, stage changes, commit, or perform implementation work unless the user separately asks for execution.

## Principles

- Ground the plan in the repository before proposing work.
- Inspect the smallest useful context.
- Keep the plan as small as the change allows.
- Prefer behaviour-first steps over architecture-first steps.
- Use existing repo patterns.
- Avoid speculative abstractions.
- Avoid broad refactors unless explicitly requested.
- Call out uncertainty instead of inventing detail.
- Do not create a plan document unless the user asks.
- Stop and ask when product, behaviour, naming, or architecture decisions are unresolved.

## Routing

Before planning, decide whether another strategy should shape the work first.

Use another strategy first when:

- Broken behaviour, failing test, regression, runtime error, or incorrect output -> `fix`
- Behaviour-preserving restructure -> `refactor`
- Safer validation, error handling, permissions, external input, or edge cases -> `harden`
- Moving from one contract, convention, dependency, schema, config, or API to another -> `migrate`

If the request needs an architectural decision with meaningful trade-offs, pause and ask for that decision before producing an implementation plan.

Continue with `plan` when the goal or strategy is clear enough to break into implementation steps.

## Workflow

1. Understand the goal.
2. Inspect the smallest useful repo context:
   - relevant source files
   - nearby tests
   - repo instructions
   - project scripts or commands when needed
3. Identify the intended behaviour change or preserved behaviour.
4. Define in-scope and out-of-scope work.
5. Choose the simplest viable approach.
6. Split the work into small behaviour-focused steps.
7. Decide whether tests are needed.
8. If tests are needed, read and apply `../test-rubric/SKILL.md`.
9. Define verification commands or manual checks.
10. List stop conditions where implementation should pause instead of guessing.

## Test Planning

Only include tests when they provide useful confidence.

When tests are needed, include:

- behaviour to prove
- owner of that behaviour
- chosen test level
- why this is the lowest useful level
- existing test file to extend, if known
- Given / When / Then scenario
- command to run
- meaningful gap left untested, if any

Do not add tests by default for trivial, already-covered, styling-only, copy-only, or low-risk changes.

## Output Size

For tiny changes, use 3-5 bullets.

For normal changes, use the full output shape.

For risky, cross-boundary, or unclear changes, keep the plan short and call out the decision needed before implementation.

## Output Shape

```md
## Goal

[What will change and why.]

## Scope

In:
- ...

Out:
- ...

## Context

[Relevant files, existing patterns, constraints, assumptions, or unknowns.]

## Approach

[Recommended implementation path and why.]

## Steps

1. [Small behaviour-focused step.]
2. [Small behaviour-focused step.]
3. [Verification step.]

## Testing

- Behaviour to prove:
- Owner of behaviour:
- Test level:
- Why this is the lowest useful level:
- Existing test file to extend:
- Given:
- When:
- Then:
- Command:
- Untested gap, if any:

## Verification

- [Commands or manual checks.]

## Stop Conditions

- [When to pause instead of guessing.]
```

## Quality Bar

A good plan is:

* short enough to execute
* grounded in the repo
* clear about scope
* clear about tests
* clear about verification
* honest about uncertainty
* free of invented architecture
* free of unrelated cleanup

