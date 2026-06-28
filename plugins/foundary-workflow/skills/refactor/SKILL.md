---
name: refactor
description: Creates a bounded Refactor Strategy for behaviour-preserving code restructuring. Use when the user wants to improve structure, readability, naming, boundaries, or internal organisation without changing intended behaviour.
compatibility: 'Requires: git and filesystem access. May inspect repository context and run clearly non-mutating checks when safe.'
---

# Refactor

Create a controlled strategy for behaviour-preserving code restructuring. This skill shapes the change before implementation.

## Required outcomes

- Classify whether the request is truly a refactor.
- Name the behaviour, public contracts, runtime contracts, observable outputs, and callers that must remain unchanged.
- Identify existing protection and protection gaps.
- Define a narrow scope boundary and explicit out-of-scope changes.
- Produce a Refactor Strategy with enough evidence for implementation or decomposition.

## Core rules

- A refactor changes internal structure without changing intended behaviour.
- Do not treat feature work, bug fixing, migration, hardening, generic cleanup, dependency updates, or broad formatting as refactoring.
- Define the behaviour that must remain unchanged before proposing edits.
- Identify what would count as an accidental behaviour change.
- Prefer small, reversible transformations.
- Avoid opportunistic architecture redesign.
- Avoid broad formatting churn unless formatting is the explicit requested change.
- Recommend `test-review` first when existing behavioural protection is uncertain.
- Recommend `scope-guard` after changes when drift risk is meaningful.

## Valid refactors

- rename code symbols without changing public contracts
- extract, inline, move, or split implementation code
- reduce duplication without changing behaviour
- clarify module boundaries while preserving imports or approved public surfaces
- simplify control flow while preserving outputs, side effects, and errors

## Non-refactors

- changing API shape, data shape, persistence, validation, errors, permissions, or user-visible behaviour
- replacing dependencies or framework conventions
- adding resilience or defensive checks
- fixing a known broken behaviour
- broad cleanup or formatting mixed with semantic work

## Allowed

- Read relevant source, tests, docs, strategies, and history.
- Run clearly non-mutating characterization checks when safe.
- Recommend focused characterization coverage when behaviour protection is weak.
- Before recommending new characterization or regression coverage, use the `test-rubric` skill.
- Produce strategy text in chat.
- Ask before saving a strategy.

## Forbidden

- Do not edit files while producing the strategy unless the user separately invokes implementation.
- Do not invent preserved behaviour, callers, or contracts.
- Do not bury feature work, hardening, migration, bug fixes, or cleanup inside a refactor.
- Do not recommend broad rewrites when small transformations would work.
- Do not treat absence of tests as proof that behaviour is safe to change.

## Workflow

1. Ground the request in the narrowest relevant repository context.
2. Apply the classification gate:
   - intended runtime behaviour unchanged
   - public contract unchanged
   - observable outputs unchanged
   - side effects and error behaviour unchanged unless explicitly out of scope
3. If the request is not a refactor, say so and recommend the better Foundary skill.
4. Name the unchanged behaviour, contracts, callers, and accidental-change signals.
5. Identify protection evidence and protection gaps.
6. Propose small transformation steps with explicit boundaries.
7. Choose a verification posture:
   - `characterization`: existing passing tests or manual checks protect behaviour.
   - `new regression`: add focused coverage before refactoring when valuable.
   - `no new test`: allowed only for trivial, low-risk, or better-verified restructuring.
8. Recommend whether implementation is ready, needs decomposition, or should get `test-review` first.

## Readiness gate

A Refactor Strategy is ready for implementation only when:

- preserved behaviour and public/runtime contracts are explicit
- proposed steps are small and reversible
- verification posture is credible for the risk
- no feature, fix, hardening, migration, dependency, or cleanup work is mixed in

Ask for decomposition before implementation when the refactor spans multiple boundaries, requires ordering decisions, changes public surfaces, or needs stronger decomposition.

## Stop immediately when

- preserved behaviour cannot be named
- protection is too weak to judge safety and the user has not accepted that risk
- the request includes behaviour changes
- the scope would require architecture redesign
- implementation would require guessing about contracts, callers, or verification

## Persistence

Ask before saving a strategy. If the user wants it saved, use:

`docs/plans/YYYY-MM-DD-<topic>-refactor-strategy.md`

Chat output is always acceptable.

## Output format

Use this structure:

```md
# Refactor Strategy

## Change Intent
- Classification:
- Valid refactor because:

## Behaviour To Preserve
- Runtime behaviour:
- Public/runtime contracts:
- Callers and observable outputs:
- Accidental behaviour change would look like:

## Scope Boundary
- In scope:
- Out of scope:

## Evidence / Protection
- Existing protection:
- Protection gaps:

## Proposed Steps
- Small reversible transformations only.

## Verification Posture
- Posture:
- Commands/checks or manual characterization:
- Why this is enough:

## Handoff Recommendation
- implement | decompose | test-review:
- Reason:

## Out Of Scope
```

Keep the strategy concise enough to guide implementation without becoming a full task breakdown.
