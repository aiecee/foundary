## Task <number>: <behaviour-focused name>

### Objective

[What behaviour this task delivers]

### Dependencies

- [Prerequisite task numbers, or "none"]

### Executor Decision Budget

The build agent may decide:
- local variable names
- small helper extraction inside task scope
- minor test fixture setup

The build agent must not decide:
- task boundaries
- architecture changes
- extra behaviours
- new dependencies
- public API redesigns
- unrelated cleanup

### Pre-Read

Files the build agent must inspect before editing:
- path/to/file
- path/to/test

### In Scope

- [Allowed implementation scope]

### Out of Scope

- [Forbidden adjacent work]

### Files

#### Create

- path/to/file
  - Purpose: [why this file exists]

#### Modify

- path/to/file
  - Change: [specific intended modification]
  - Preserve: [existing behaviour/API to keep]

#### Delete

- none

### Constraints

- [Task-specific constraints inherited from spec]

### Red Light

**Test Level:** unit | integration | e2e

**Test command before implementation:**

```
[command]
```

### Scenarios

- Given [context]
  When [action]
  Then [expected outcome]

### Expected Failure Before Green

- [Specific failing assertion, missing behaviour, or expected error]

### Verification Target

[What specifically proves this task is complete]

### Green Light

Implement only:

1. In `path/to/file`, [specific change].
2. In `path/to/file`, [specific change].

Do not:
- change unrelated APIs
- refactor surrounding modules
- rename unrelated symbols
- reformat unrelated files

### Refactor

Allowed refactors only:
- helper extraction introduced by this task
- duplication removal introduced by this task
- naming cleanup for code introduced by this task
- branching simplification introduced by this task

Forbidden refactors:
- moving modules
- changing public APIs
- broad cleanup
- unrelated formatting

### Task Verification

Run:

```
[task-specific command]
```

### Pass Condition

- [What must pass]
- [What behaviour must be observable]
- [What must remain unchanged]

### Stop Condition

Stop after this task when:
- done criteria are met
- verification passes
- no remaining work exists inside this task scope

Do not begin the next task unless explicitly instructed.

### Done Criteria

- [ ] Behaviour implemented
- [ ] Tests pass
- [ ] Scope remained bounded
- [ ] Verification completed
