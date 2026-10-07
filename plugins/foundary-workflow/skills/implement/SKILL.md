---
name: implement
description: Implements an approved plan or strategy (fix, refactor, harden, migrate, design) exactly as written, step by step, stopping instead of guessing, then runs scope-guard. Use when the user asks to implement, execute, or carry out a plan or strategy.
compatibility: 'Requires: git and filesystem access. Runs focused checks named by the plan or strategy.'
---

# Implement

Execute a supplied plan or strategy. The input is the contract; do not re-plan, re-design, or improve it.

## Rules

- Read and apply ../workflow-rubric/SKILL.md for the task contract, validation ladder, and handoffs.
- Edit only what the plan's Scope In or the strategy's boundary covers.
- Follow plan Steps in order. For a strategy, take the smallest change that satisfies its boundary and verification posture; do not add steps it does not imply.
- Keep Adopted Decisions as written. Do not re-litigate them.
- Run the focused check for each step before moving on. Widen validation only as the plan or rubric allows.
- No unrelated cleanup, formatting, renames, or refactors, even if useful. Note them for later instead.
- Do not stage, commit, or push unless the user asks.

## Stop and report when

- a Stop Condition from the plan or strategy fires;
- a new product, contract, compatibility, rollout, or architecture decision appears;
- repository reality contradicts the plan or strategy;
- a step cannot be done without touching out-of-scope files;
- a check fails and the fix is not obvious from the step.

Report what was done so far, what blocked, and the decision needed. Do not guess past it.

## Finish

1. Run the plan's final verification.
2. Run ../scope-guard/SKILL.md against the plan or strategy and the working tree diff.
3. Report:

```md
## Implemented
- Step N: done | skipped (why) | blocked (why)

## Checks
- command -> result

## Deviations
- [any departure from the plan or strategy, or "none"]

## Scope Guard
- Outcome and any flagged files

## Follow-ups
- [noted out-of-scope work, or "none"]
```
