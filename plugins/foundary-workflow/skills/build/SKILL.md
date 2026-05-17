---
name: build
description: Executes an implementation plan task-by-task with strict Red/Green/Refactor discipline, verification, and feedback checkpoints. Use when the user has a plan file and wants implementation performed deterministically.
compatibility: 'Requires: filesystem access and ability to run project test/lint/build commands.'
---

# Build

## Overview

Load an implementation-ready plan (typically `docs/plans/YYYY-MM-DD-<topic>.md`), validate that the plan and current task are executable, then execute tasks in order using:

Red light -> Green light -> Refactor -> Verification -> Feedback.

Treat the plan as the source of truth for task order and scope. Do not redesign the plan during execution.

## Principles

- Validate for execution, not critique.
- Treat the plan as the source of truth.
- Stay inside the current task's declared scope.
- Execute one task at a time.
- Keep task tests green after Green and Refactor.
- Use minimal meaningful verification to control token and runtime cost.
- Preserve deterministic behavior; stop instead of guessing.
- Do not widen scope opportunistically.

## Precedence

1. Higher-priority system, developer, and repo instructions override this skill.
2. The implementation plan overrides default execution choices where explicit.
3. If instructions conflict or execution would require guessing, stop and ask.

## Workflow

### 1) Ground execution in the repo

Before plan validation or implementation, inspect enough repository context to ground execution:

- `README.md` or `README.*`
- `AGENTS.md` or equivalent operator guidance
- `docs/`
- `docs/plans/`
- project manifests (for available scripts/commands)
- relevant source directories
- relevant test directories
- recent git history (e.g., `git log -10 --oneline`)

Establish:

- repo root
- likely implementation file locations
- likely test locations
- available verification commands
- repo conventions that affect execution

If repository reality conflicts with the plan in a way that requires guessing, stop and ask.

### 2) Load and validate the plan

1. Load the plan from the user-provided path or the expected `docs/plans/...` location.
2. Validate that the plan is execution-ready before implementation starts.

A plan is execution-ready when:

- tasks are ordered
- each task has a behavior-focused name
- each task lists concrete files or clearly identified likely locations
- each task includes explicit Red light, Green light, and Refactor sections
- verification requirements are explicit when broader checks are required

3. If the current task is structurally incomplete, contradictory, or would require guessing, stop and ask.
4. If ready, create a task list once with one entry per plan task. Do not recreate it later.
5. Read `assets/validation-result-template.md` and report validation using the template exactly as-is.

### 3) Execute current task

For each task in order:

1. Mark task as in-progress.
2. Execute Red light first.

Red light requirements:

- Write only the failing tests for the current task behavior.
- Run the tests and confirm they fail.
- Failure must be behavior-meaningful, not setup failure.
- Setup failures (compile/import/config/mock issues) must be fixed before proceeding.
- If Red-first is impractical for a behavior, stop and ask how to proceed (mock/stub, documented exception, or manual verification).

3. Execute one Green light pass.

Green light requirements:

- Implement the minimum in-scope changes needed to pass Red tests.
- Rerun relevant task tests and confirm pass.

4. Execute one Refactor pass.

Refactor requirements:

- Only behavior-preserving cleanup within task scope.
- Rerun relevant task tests and confirm pass.
- Perform an additional refactor pass only when a concrete behavior-preserving issue remains and scope still permits it.

5. Run verification.

Verification policy:

- Always run the minimal task-level checks required by Red/Green/Refactor.
- Run broader checks (lint/full suite/typecheck/build/manual flow) only when explicitly defined by the plan.
- Do not add broad checks by default.

6. Reconcile implementation against the task's scope and file list. If needed changes are out of scope, stop and ask.
7. Read and use these templates exactly as-is:

- `assets/task-completion-template.md`
- `assets/verification-summary-template.md`
- `assets/feedback-checkpoint-template.md`

8. Ask for feedback and apply only in-scope feedback.

Feedback scope:

- In scope: implementation details, test clarity, code quality inside current task.
- Out of scope: new requirements, design shifts, task reordering, plan rewrites.

If feedback implies plan/design changes, stop and ask whether to pause execution and update plan/design first.

9. Mark task completed.
10. Report and wait before starting next task.

### 4) Finish

When all tasks are complete, provide a brief summary of:

- completed tasks
- primary deliverables
- final verification outcomes

Then stop.

## Rules

- Do not skip or reorder tasks unless explicitly instructed by the user.
- Do not run Green before Red.
- Do not expand scope beyond the current task.
- Default to one Green pass and one Refactor pass.
- Rerun relevant task tests after Green and after Refactor.
- Complete feedback loop before starting the next task.
- Do not absorb useful adjacent cleanup unless explicitly planned.

## Stop immediately when

- blocker prevents safe progress
- instructions are unclear
- implementation would require guessing
- current task is not execution-ready
- verification fails repeatedly without clear cause
- repo reality conflicts materially with the plan
- scope would need to expand beyond the current task

In these cases: stop execution, describe the issue, and ask for clarification.

## Return to validation when

- the plan is updated
- current task changes materially
- new constraints affect executability

Reload and revalidate before continuing execution.
