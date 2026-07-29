---
name: harden
description: Creates a Hardening Strategy for making existing behaviour safer or more robust without changing the intended happy path. Use when the user wants validation, typing, error handling, edge cases, permissions, external input, or async safety.
compatibility: 'Requires: git and filesystem access. May inspect repository context and run clearly non-mutating checks when safe.'
---

# Harden

Create a strategy for making existing behaviour safer or more robust without changing the intended happy path. This skill shapes the change before implementation.

## Required outcomes

- Define the risk or failure mode being hardened.
- State the unchanged happy path: accepted inputs, outputs, side effects, and user-visible success behaviour.
- Name the newly rejected, handled, guarded, or surfaced cases.
- Choose the safety action: reject, sanitize, default, retry, surface error, or no-op.
- Identify compatibility concerns when callers may rely on currently unsafe behaviour.
- Define verification for both the normal path and hardened path.

## Core rules

- Hardening makes existing behaviour safer without changing the intended happy path.
- Do not turn hardening into feature work, migration, refactoring, or generic cleanup.
- Make the guarded cases explicit before proposing edits.
- Avoid redesigning the surrounding architecture.
- Add focused tests around the risk or failure mode when valuable.
- Verify both the normal path and the hardened path.
- When safety actions or compatibility consequences have meaningful alternatives, read and apply `../decision-rubric/SKILL.md`.
- Recommend `scope-guard` after changes when drift risk is meaningful.

## Good uses

- null or undefined handling
- bad input validation
- safer async error handling
- stronger type narrowing
- defensive checks around external data
- clearer failure states
- permission or authorization edge cases
- resilience around unreliable dependencies

This is not a generic cleanup skill.

## Allowed

- Read relevant source, tests, docs, strategies, and history.
- Inspect callers and runtime contracts for compatibility concerns.
- Run clearly non-mutating checks when safe.
- Recommend focused normal-path and hardened-path coverage.
- Before recommending new normal-path or hardened-path coverage, read and apply `../test-rubric/SKILL.md`.
- Produce strategy text in chat.
- Ask before saving a strategy.

## Forbidden

- Do not edit files while producing the strategy unless the user separately invokes implementation.
- Do not introduce new product behaviour or broad validation redesign.
- Do not change accepted happy-path inputs, outputs, side effects, or success behaviour.
- Do not hide compatibility risks for callers that may rely on existing behaviour.
- Do not use hardening as a wrapper for cleanup, refactoring, or migration.

## Workflow

1. Identify the risk, edge case, trust boundary, or failure mode.
2. Name the unchanged happy path:
   - accepted inputs
   - expected outputs
   - side effects
   - user-visible success behaviour
3. Define the newly rejected, handled, guarded, or surfaced cases.
4. Choose the safety action:
   - reject
   - sanitize
   - default
   - retry
   - surface error
   - no-op
5. Identify affected contracts, callers, and compatibility concerns.
6. Read and apply `../decision-rubric/SKILL.md` when the hardening decision is material.
7. Propose the smallest safety improvement that handles the risk.
8. Choose a verification posture:
   - `characterization`: existing checks protect the unchanged normal path.
   - `new regression`: add focused coverage for the risky or guarded path.
   - `no new test`: allowed only for trivial, low-risk, or better-verified hardening.
9. Recommend the next step: plan, implement directly, ask user, or investigate further.

## Readiness gate

A Hardening Strategy is ready for implementation only when:

- the risk is specific
- the happy path is explicitly unchanged
- guarded cases and safety action are clear
- compatibility concerns are checked or explicitly absent
- any material safety decision includes alternatives, accepted trade-offs, assumptions, and impact
- verification covers both normal and hardened paths

Recommend planning before implementation when hardening affects public contracts, multiple callers, permissions, data integrity, deployment sequencing, or compatibility-sensitive behaviour.

## Stop immediately when

- the happy path would change
- guarded cases cannot be named
- callers may rely on existing behaviour and compatibility is unresolved
- the change is actually a feature, fix, migration, refactor, or cleanup
- the safety action is unclear
- implementation would require guessing about expected behaviour

## Persistence

Chat output is the default. Ask before saving a strategy, and use the location the user requests.

## Output format

Use this structure:

```md
# Hardening Strategy

## Change Intent

## Risk / Failure Mode
- Risk:
- Why harden now:

## Intended Behaviour
- Accepted inputs:
- Outputs:
- Side effects:
- User-visible success behaviour:

## Guarded Cases
- Newly rejected/handled/guarded/surfaced cases:
- Safety action: reject | sanitize | default | retry | surface error | no-op

## Compatibility
- Caller expectations:
- Compatibility risk:

## Decision Notes (when material)
- Alternatives considered:
- Trade-offs accepted:
- Assumptions / unknowns:
- Impact / reversibility:
- Decision status: resolved | non-blocking unknown | blocking user decision

## Scope Boundary

## Evidence / Protection
- Normal-path protection:
- Hardened-path protection:

## Proposed Steps

## Verification Posture
- Normal path:
- Hardened path:

## Handoff Recommendation
- Ready for next step: yes | no
- Recommended next step: plan | implement directly | ask user | investigate further
- Reason:

## Out Of Scope
```

Keep the strategy focused on safety and robustness, not cleanup.
