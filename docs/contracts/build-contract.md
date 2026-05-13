# Build Contract

## Purpose
Define required runtime behavior for Foundary `build` execution against a valid `plan`.

## Required Behaviors
Build must:
- execute tasks sequentially
- preserve task scope boundaries
- stop on ambiguity
- run Red before Green
- run verification after Green and after Refactor

## Forbidden Behaviors
- opportunistic refactors outside task scope
- architecture redesign during task execution
- task reordering without explicit user instruction
- speculative improvements not described by the current task

## Execution Guarantees
- One task is active at a time.
- Task feedback loop completes before next task starts.
- Relevant tests are rerun after Green and after Refactor.
- Broader checks run only when required by the plan.

## Failure Handling
Build must stop and request clarification when:
- instructions conflict
- task structure is incomplete
- repository reality conflicts materially with the plan
- progress would require guessing or scope expansion

