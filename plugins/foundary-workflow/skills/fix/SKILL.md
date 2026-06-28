---
name: fix
description: Creates a focused Fix Strategy for broken behaviour, failing tests, regressions, runtime errors, or incorrect output. Use when the user wants to diagnose and correct a specific failure without broad cleanup or refactoring.
compatibility: 'Requires: git and filesystem access. May run targeted tests or reproduction commands when safe.'
---

# Fix

Create a focused bug-fix strategy. This skill shapes the fix before implementation.

## Required outcomes

- Describe the symptom and original failure mode.
- Reproduce the failure or clearly state why reproduction is unavailable.
- Identify likely cause with evidence, not just plausibility.
- Define the smallest fix boundary that addresses the root cause.
- Decide whether existing red, new regression coverage, or another verification posture is appropriate.
- Produce a Fix Strategy that separates fixing from refactoring, hardening, migration, and cleanup.

## Core rules

- Reproduce or clearly describe the failure before changing code where possible.
- Separate symptom, likely cause, and fix boundary.
- Prefer the smallest fix that addresses the root cause.
- Avoid surrounding rewrites unless necessary for the fix.
- Add or update regression coverage when valuable.
- Before recommending regression coverage, read and apply `../test-rubric/SKILL.md`.
- Verify the fix against the original failure mode.
- Do not weaken tests unless the test is proven wrong and the corrected test still protects meaningful behaviour.
- Recommend `scope-guard` after changes when drift risk is meaningful.

## Allowed

- Read relevant source, tests, docs, logs, strategies, and git history.
- Run targeted reproduction commands or failing tests when safe.
- Inspect recent changes that may explain the regression.
- Recommend focused regression coverage.
- Produce strategy text in chat.
- Ask before saving a strategy.

## Forbidden

- Do not edit files while producing the strategy unless the user separately invokes implementation.
- Do not treat a plausible guess as the likely cause without evidence.
- Do not expand into refactoring, hardening, migration, dependency updates, or cleanup.
- Do not make tests pass by deleting or weakening meaningful assertions.
- Do not broaden the fix beyond the original failure mode without explicit approval.

## Workflow

Follow:

```text
observe -> reproduce -> isolate -> minimal fix -> regression decision -> verify
```

1. Observe the reported failure, failing test, runtime error, regression, or incorrect output.
2. Identify the symptom and original failure mode.
3. Reproduce with the narrowest useful command, or document why reproduction is unavailable.
4. Isolate likely cause using evidence from code, tests, logs, history, or runtime behaviour.
5. Define the minimal fix boundary and affected files or likely locations.
6. Read and apply `../test-rubric/SKILL.md`, then decide whether regression coverage is valuable and at which boundary.
7. Choose a verification posture:
   - `existing red`: existing failing test, command, reproduction, runtime error, or reported behaviour demonstrates the problem.
   - `new regression`: add focused coverage for a valuable failure mode.
   - `no new test`: allowed only for trivial, low-risk, or better-verified fixes.
8. Recommend the next step: plan, implement directly, ask user, or investigate further.

## Readiness gate

A Fix Strategy is ready for implementation only when:

- the symptom and original failure mode are explicit
- reproduction exists, or reproduction absence is justified and the failure is otherwise unambiguous
- likely cause has concrete evidence
- fix boundary is narrow
- verification checks the original failure mode

Recommend planning before implementation when the fix crosses multiple subsystems, requires sequencing, needs compatibility decisions, or cannot be safely localized.

## Stop immediately when

- reproduction is unavailable and the failure is ambiguous
- likely cause cannot be supported by evidence
- the fix would require broad rewrites or unrelated cleanup
- the only apparent path is weakening a meaningful test
- the reported issue turns out to be hardening, migration, or feature work
- implementation would require guessing about expected behaviour

## Persistence

Chat output is the default. Ask before saving a strategy, and use the location the user requests.

## Output format

Use this structure:

```md
# Fix Strategy

## Change Intent
- Bug/failure being fixed:

## Symptom / Observed Failure
- Original failure mode:
- User-visible or test-visible symptom:

## Reproduction
- Command, error, or reproduction steps:
- If unavailable, why:

## Likely Cause
- Cause:
- Evidence:
- Confidence:

## Fix Boundary
- Smallest in-scope fix:
- Files or likely locations:

## Evidence / Protection
- Existing red signal:
- Regression coverage decision:

## Proposed Steps

## Verification Posture
- Posture:
- Must verify original failure mode by:

## Handoff Recommendation
- Ready for next step: yes | no
- Recommended next step: plan | implement directly | ask user | investigate further
- Reason:

## Out Of Scope
```

Keep the strategy focused on the original failure mode.
