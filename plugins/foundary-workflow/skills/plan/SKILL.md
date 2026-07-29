---
name: plan
description: Turn a goal, strategy, or rough change request into a concise, decision-complete behaviour-first implementation plan with clear scope, test intent, and verification.
compatibility: 'Requires: git and filesystem access. May inspect repository context and read test-rubric when tests are relevant.'
---

# Plan

Create a concise implementation plan that helps a human or agent implement a change safely without losing material decision context.

This skill is for planning only. Do not edit files, stage changes, commit, or perform implementation work unless the user separately asks for execution.

## Principles

- Ground the plan in the repository before proposing work.
- Inspect the smallest useful context.
- Keep the plan as small as the change allows; remove repetition, not material decision evidence.
- Prefer behaviour-first steps over architecture-first steps.
- Use existing repo patterns.
- Avoid speculative abstractions.
- Avoid broad refactors unless explicitly requested.
- When given a `fix`, `refactor`, `harden`, `migrate`, or `design` strategy, preserve its intent, scope boundary, and verification posture.
- When a material decision exists, read and apply `../decision-rubric/SKILL.md`.
- Do not re-litigate a strategy unless repository reality contradicts it.
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
- Ambiguous or architectural work with meaningful trade-offs -> `design`

If architectural trade-offs are unresolved, route to `design` before producing an implementation plan. Ask the user only when `design` cannot resolve the decision without product, naming, UX, public-contract, rollout, or compatibility input.

Continue with `plan` when the goal or strategy is clear enough to break into implementation steps.

## Workflow

1. Understand the goal.
2. Inspect the smallest useful repo context:
   - relevant source files
   - nearby tests
   - repo instructions
   - project scripts or commands when needed
3. Identify the intended behaviour change or preserved behaviour.
4. Read and apply `../decision-rubric/SKILL.md` when the strategy or repository context contains a material decision.
5. Define in-scope and out-of-scope work.
6. Choose the simplest viable approach without silently resolving new material decisions.
7. Split the work into small behaviour-focused steps.
8. Decide whether tests are needed.
9. If tests are needed, read and apply `../test-rubric/SKILL.md`.
10. Define verification commands or manual checks.
11. List stop conditions where implementation should pause instead of guessing.

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

For risky, cross-boundary, or unclear changes, keep implementation steps short while expanding the decision context needed before implementation.

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

## Adopted Decisions (when applicable)

- Decision:
- Evidence / rationale summary:
- Implementation constraints:
- Decision status: resolved | non-blocking unknown

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
- A new material product, contract, compatibility, rollout, or architecture decision appears that is not covered by the supplied strategy.
- The supplied strategy is missing evidence needed to preserve a material decision.
```

## Quality Bar

A good plan is:

* short enough to execute
* grounded in the repo
* clear about scope
* clear about tests
* clear about verification
* honest about uncertainty
* decision-complete when material choices exist
* free of invented architecture
* free of unrelated cleanup
