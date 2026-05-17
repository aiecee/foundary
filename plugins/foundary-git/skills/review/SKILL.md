---
name: review
description: Reviews staged, unstaged, working tree, or branch diffs for commit readiness by checking accidental changes, risk, missing validation, debug code, secrets, generated files, and unclear intent. Use when the user asks to review git changes, check a diff before committing, inspect a branch before merge, or verify whether changes are safe to commit.
compatibility: 'Requires: git, filesystem access, and ability to inspect diffs and repository context.'
---

# Review

Reviews git changes for readiness before they are committed, merged, or otherwise shared. Optimize for catching avoidable mistakes, unclear intent, risky edits, and missing validation.

This skill inspects and reports. It does not stage files, create commits, merge branches, rewrite history, or modify the working tree.

## Required outcomes

Always ensure the work reaches these outcomes:

- inspect the relevant git change set before giving a verdict
- identify accidental, unrelated, local-only, or suspicious changes
- assess whether the diff has a clear purpose
- flag risky behavior, security, data, dependency, or configuration changes
- check whether generated files, lockfiles, tests, and documentation changes appear intentional
- identify likely missing validation or follow-up checks
- produce a concise readiness verdict with concrete next actions

## Inputs

- **Change source**: staged diff, unstaged diff, working tree diff, branch diff, or merge result.
- **Base reference**: branch, commit, or merge-base used for branch diffs.
- **Review depth**: quick hygiene check, normal readiness review, or deeper risk review.
- **Intent context**: user goal, ticket, spec, plan, commit purpose, or PR purpose.
- **Validation context**: tests already run, checks already passed, known failures, or checks the user wants ignored.

## Workflow

### 1. Load the review context

Inspect the current git state before reviewing.

Check:

- current branch
- staged changes
- unstaged changes
- untracked files
- branch ahead/behind state when relevant
- diff source requested by the user
- base reference for branch or merge reviews

Prefer the smallest relevant diff:

- use staged diff when the user asks to review what is about to be committed
- use working tree diff when the user asks to review local changes
- use branch diff when the user asks to review a branch
- use the merge result when the user asks to review after resolving or performing a merge

If the requested review source is unclear, ask whether to review staged changes, unstaged changes, all working tree changes, or the branch diff.

For branch reviews, report based on local refs unless the user asks to fetch. If remote freshness is uncertain, say so.

### 2. Understand the intended change

Infer the apparent purpose of the diff from:

- changed files
- code paths touched
- tests or fixtures added
- docs or config changed
- user-provided context
- branch name or nearby plan/spec files when relevant

State the inferred intent briefly.

If the intent is unclear, say so. Do not invent a purpose just to make the diff look coherent.

### 3. Check for accidental or unrelated changes

Look for:

- unrelated files mixed into the diff
- editor swap files
- build output
- generated artifacts without matching source changes
- logs
- temporary files
- environment files
- local machine paths
- commented-out debugging
- stray console logging or print statements
- formatting-only churn mixed into behavior changes
- dependency or lockfile changes that do not match the apparent intent

Flag these as concrete findings with file paths where possible.

Inspect relevant untracked files before judging whether they are safe, intentional, or unrelated. Do not treat untracked files as reviewed based on filename alone.

### 4. Check correctness and behavior risk

Review the changed code for likely issues, including:

- broken control flow
- missing error handling
- changed defaults
- changed public API or command behavior
- backwards-incompatible behavior
- edge cases introduced by the change
- inconsistent validation
- incomplete call-site updates
- mismatch between implementation and tests
- config changes that affect runtime behavior
- migration, schema, or data shape changes that need rollout care

Do not overreach. Prefer “possible risk” when the issue is plausible but not proven.

### 5. Check security, privacy, and data risk

Pay extra attention to:

- secrets or credentials
- tokens, API keys, passwords, certificates, or private URLs
- authentication and authorization changes
- permission checks
- user input handling
- shell command construction
- file path handling
- SQL, GraphQL, or query construction
- logging of sensitive values
- personal data exposure
- dependency changes that widen attack surface

If a potential secret is found, tell the user not to commit it and recommend rotating it if it may already have been exposed.

### 6. Check tests and validation

Assess whether the changed behavior has appropriate validation.

Look for:

- new or updated tests for behavior changes
- updated fixtures or snapshots
- typecheck or lint implications
- migration or compatibility checks
- docs updates for user-facing behavior
- missing tests around important edge cases

If tests are absent, distinguish between:

- acceptable low-risk change
- should have a test before commit
- cannot judge without running a specific check

Do not claim tests passed unless evidence is available.

Do not treat missing tests as blocking by default. Make missing validation blocking only when the change risk, behavior surface, or repo conventions justify it.

### 7. Check commit readiness

Decide whether the reviewed diff appears ready.

Use one of these verdicts:

- **Ready**: coherent, low-risk, and no blocking issues found.
- **Ready with notes**: safe enough, but has minor follow-ups or suggested checks.
- **Needs changes**: concrete issue should be fixed before commit or merge.
- **Needs clarification**: intent, scope, or validation is unclear.
- **Blocked**: unresolved conflicts, likely secret, broken state, or missing critical context.

### 8. Report findings

Keep the report direct and actionable.

Include:

- inferred intent
- readiness verdict
- blocking issues, if any
- non-blocking notes, if any
- suggested validation commands, if clear from the repo
- files or areas worth rechecking manually

Prioritize real issues over exhaustive commentary. If there are no meaningful findings, say so clearly.

## Rules

- Do not modify the working tree.
- Do not stage, unstage, commit, merge, reset, checkout, stash, delete, or rewrite files.
- Do not claim validation passed unless it was actually run or the user provided that result.
- Do not invent intent, test coverage, risk level, or file purpose.
- Do not bury blocking issues under style comments.
- Do not nitpick formatting unless it affects readability, behavior, generated output, or repo conventions.
- Do not require tests for every change; match validation expectations to risk.
- Do not mark untracked files safe without inspecting their contents when they are relevant to the reviewed change.
- Do not fetch from remotes unless the user asks.
- Treat secrets, credentials, unresolved conflicts, and unrelated local-only files as blocking by default.
- Treat generated files as suspicious unless they are clearly paired with source changes.
- Treat dependency and lockfile changes as higher risk unless they are clearly intentional.
- If the diff is too large for a useful review, say so and recommend narrowing the review source.
- If the worktree is clean, say there is nothing to review.
