---
name: build
description: Executes an approved implementation plan or scoped code-change strategy with deterministic scope control, contextual verification, and feedback checkpoints. Use when the user has a plan or strategy and wants implementation performed safely.
compatibility: 'Requires: filesystem access and ability to run project test/lint/build commands.'
---

# Build

## Overview

Load an implementation-ready plan (typically `docs/plans/YYYY-MM-DD-<topic>.md`) or an approved code-change strategy, validate that the source and current work are executable, then execute in order.

For full implementation plans, use:

Red light -> Green light -> Refactor -> Verification -> Feedback.

For approved strategies, use the strategy's verification posture instead of mandatory new Red-first tests.

Treat the plan or strategy as the source of truth for task order and scope. Do not redesign the source during execution.

## Principles

- Validate for execution, not critique.
- Treat the plan or strategy as the source of truth.
- Stay inside the current task's declared scope.
- Execute one task at a time.
- Keep task checks green after implementation and any refactor.
- Use minimal meaningful verification to control token and runtime cost.
- Preserve deterministic behavior; stop instead of guessing.
- Do not widen scope opportunistically.

## Precedence

1. Higher-priority system, developer, and repo instructions override this skill.
2. The implementation plan or approved strategy overrides default execution choices where explicit.
3. If instructions conflict or execution would require guessing, stop and ask.

## Workflow

### 1) Ground execution in the repo

Before source validation or implementation, inspect enough repository context to ground execution:

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

If repository reality conflicts with the plan or strategy in a way that requires guessing, stop and ask.

### 2) Load and validate the execution source

1. Load the plan or strategy from the user-provided path, prompt, or the expected `docs/plans/...` location.
2. Validate that the source is execution-ready before implementation starts.

A plan is execution-ready when:

- tasks are ordered
- each task has a behavior-focused name
- each task lists concrete files or clearly identified likely locations
- each task includes explicit Red light, Green light, and Refactor sections
- verification requirements are explicit when broader checks are required

An approved strategy is execution-ready when:

- the change intent is clear
- the scope boundary and out-of-scope items are explicit
- proposed steps are small enough to execute directly
- relevant files or likely locations can be identified without guessing
- the verification posture is explicit
- the strategy does not require sequencing, compatibility, or architecture decisions that belong in `plan`

Allowed strategy verification postures:

- `existing red`: existing failing test, command, reproduction, runtime error, or reported behaviour demonstrates the issue.
- `characterization`: existing passing tests or manual checks protect behaviour that must remain unchanged.
- `new regression`: add focused coverage when valuable.
- `no new test`: allowed only for trivial, low-risk, or better-verified changes.

3. If the current task or strategy is structurally incomplete, contradictory, too broad, lacks scope boundaries, requires decomposition, or would require guessing, stop and recommend `plan` or clarification.
4. If ready, create a task list once with one entry per plan task or strategy step. Do not recreate it later.
5. Read `assets/validation-result-template.md` and report validation using the template exactly as-is.

### 3) Execute current task

For each task in order:

1. Mark task as in-progress.
2. For a full implementation plan, execute Red light first.

Red light requirements:

- Write only the failing tests for the current task behavior.
- Run the tests and confirm they fail.
- Failure must be behavior-meaningful, not setup failure.
- The test must preserve the planned failure mode and test-quality evidence from the current task.
- Stop and ask whether to update the plan or spec if the planned or generated test is ornamental, mock-heavy without external-boundary rationale, shape-only without runtime/public contract rationale, focused on implementation-detail assertions, or missing a real failure mode.
- Setup failures (compile/import/config/mock issues) must be fixed before proceeding.
- If Red-first is impractical for a behavior, stop and ask how to proceed (mock/stub, documented exception, or manual verification).

For an approved strategy, follow the declared verification posture:

- `existing red`: run or cite the existing failing signal before implementation, then verify it passes after the fix.
- `characterization`: run or cite the characterization check before implementation when practical, then verify it still passes after the change.
- `new regression`: write only the focused regression coverage required by the strategy, confirm the intended signal, then implement.
- `no new test`: document why no new test is appropriate and run the smallest meaningful non-test verification.

If the strategy's verification posture is missing or not credible for the risk, stop and ask whether to update the strategy or produce a full plan.

3. Execute one implementation pass.

Implementation requirements:

- Implement the minimum in-scope changes needed to satisfy the plan or strategy.
- Rerun relevant task checks and confirm pass.

4. Execute one Refactor pass.

Refactor requirements:

- Only behavior-preserving cleanup within task scope.
- Rerun relevant task checks and confirm pass.
- Perform an additional refactor pass only when a concrete behavior-preserving issue remains and scope still permits it.

5. Run verification.

Verification policy:

- Always run the minimal task-level checks required by the plan or strategy.
- Run broader checks (lint/full suite/typecheck/build/manual flow) only when explicitly defined by the plan or strategy.
- Do not add broad checks by default.

6. Reconcile implementation against the task's scope and file list. If needed changes are out of scope, stop and ask.
7. Read and use these templates exactly as-is:

- `assets/task-completion-template.md`
- `assets/verification-summary-template.md`
- `assets/feedback-checkpoint-template.md`

8. Ask for feedback and apply only in-scope feedback.

Feedback scope:

- In scope: implementation details, test clarity, code quality inside current task.
- Out of scope: new requirements, design shifts, task reordering, plan or strategy rewrites.

If feedback implies plan, strategy, or design changes, stop and ask whether to pause execution and update the source first.

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
- For full plans, do not run Green before Red.
- For strategies, do not implement before satisfying the declared verification posture.
- Do not expand scope beyond the current task.
- Default to one implementation pass and one Refactor pass.
- Rerun relevant task checks after implementation and after Refactor.
- Complete feedback loop before starting the next task.
- Do not absorb useful adjacent cleanup unless explicitly planned.

## Stop immediately when

- blocker prevents safe progress
- instructions are unclear
- implementation would require guessing
- current task is not execution-ready
- verification fails repeatedly without clear cause
- current Red test or strategy verification posture would create low-value tests instead of protecting meaningful behaviour
- repo reality conflicts materially with the plan or strategy
- scope would need to expand beyond the current task

In these cases: stop execution, describe the issue, and ask for clarification.

## Return to validation when

- the plan or strategy is updated
- current task changes materially
- new constraints affect executability

Reload and revalidate before continuing execution.
