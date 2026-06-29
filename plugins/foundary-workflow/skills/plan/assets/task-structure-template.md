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

### Verification Plan

Apply `assets/test-quality-rubric.md` before filling this section.
Apply the shared Test Quality Rubric before choosing a verification posture or planning any new automated test.

**Verification posture:** new automated test | existing coverage / characterization | manual verification | no new test

**Decision rationale:** [Why this posture is the right proof for the task; `no new test` must be justified, not defaulted]

**Boundary selected:** pure input/output | module/service | integration/API/database/component | e2e/manual | none

**Requirement/risk/contract protected:** [Business requirement, regression, risk, runtime/public contract, or `none` with rationale]

**Realistic failure mode:** [Broken behaviour this verification would catch, or why no realistic automated failure mode is worth new coverage]

**Why not a different boundary:** [Why smaller/broader/manual/no-new-test posture is not the better fit]

**Existing verification considered:** [Existing tests/checks/manual signals and why they are sufficient or insufficient]

**Mocks/fakes:** none | [mock/fake name and reason each is necessary; heavy mocks require external-boundary rationale]

**Runtime contract rationale:** none | [runtime/public boundary and consumer when asserting data shape]

#### New Automated Test Details

Complete this subsection only when verification posture is `new automated test`.

**Test command before implementation:**

```
[command]
```

**Scenarios:**

- Given [context]
  When [action]
  Then [expected outcome]

**Expected failure before green:**

- [Specific failing assertion, missing behaviour, or expected error]

**Maintenance rationale:**

- [Why the test is cheaper to maintain than the risk it protects and would remain valuable after rewrite]

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

Run or perform:

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
- [ ] Declared verification passes
- [ ] Scope remained bounded
- [ ] Verification completed
