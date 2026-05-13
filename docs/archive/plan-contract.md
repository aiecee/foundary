# Plan Contract

## Purpose
Define the execution-ready structure for Foundary `plan` outputs so `build` can execute tasks linearly with minimal inference.

## Task Requirements
Each plan task must define:
- objective
- scope boundaries
- pre-read files
- `Red`
- `Green`
- `Refactor`
- verification commands
- stop condition
- done criteria

## Coverage Guarantees
- Every `Success criteria` item from the source spec maps to at least one plan task.
- Every `Success criteria` item maps to at least one verification scenario.
- Plans include an explicit traceability mapping from success criteria to tasks and tests.

## Execution Guarantees
- Tasks are ordered and independently executable.
- Task boundaries are explicit enough to prevent speculative expansion.
- Required files, commands, and pass/fail signals are stated concretely.
- Ambiguity is labeled instead of inferred.

## Handoff to Build
- Plan must be deterministic and directly consumable.
- Red/Green/Refactor flow is explicit per task.
- Verification scope is explicit per task and for any broader checks.

