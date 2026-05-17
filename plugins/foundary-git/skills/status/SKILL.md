---
name: status
description: Summarizes the current git repository state and recommends the safest next git action by checking branch, sync status, staged changes, unstaged changes, untracked files, conflicts, and recent commits. Use when the user asks what state the repo is in, what to do next, whether the tree is clean, or before performing risky git operations.
compatibility: 'Requires: git, filesystem access, and ability to inspect repository state.'
---

# Status

Summarizes the current git state and recommends the safest next git action. Optimize for orientation, risk awareness, and avoiding accidental worktree changes.

This skill reports state only. It does not stage, unstage, commit, merge, reset, checkout, stash, delete, or modify files.

## Required outcomes

Always ensure the work reaches these outcomes:

- identify the current branch and repository state
- identify whether the branch is ahead, behind, diverged, or up to date with its upstream when available
- summarize staged, unstaged, untracked, deleted, renamed, and conflicted files
- identify whether the worktree is clean
- call out risky states before further git operations
- recommend the safest next git action without performing it

## Inputs

- **Scope**: current repo, current worktree, current branch, or specific path.
- **Remote context**: upstream branch, base branch, or target branch when relevant.
- **Depth**: quick summary or fuller diagnostic status.
- **Intent context**: commit preparation, merge preparation, branch cleanup, PR preparation, or general orientation.

## Workflow

### 1. Confirm repository context

Check that the current directory is inside a git repository.

Identify:

- repository root
- current branch or detached HEAD state
- current commit
- configured upstream branch when available
- default or likely base branch when relevant

If the directory is not a git repository, say so and stop.

### 2. Inspect worktree state

Inspect the current worktree and index.

Report:

- staged files
- unstaged files
- untracked files
- deleted files
- renamed files
- conflicted files
- ignored files only when relevant to the user's question

Use concise grouping. Do not dump full diffs unless the user asks.

### 3. Inspect branch sync state

When an upstream is configured, identify whether the current branch is:

- up to date
- ahead
- behind
- diverged

When no upstream is configured, say so.

When a target or base branch is relevant, compare against that base and report:

- commits ahead
- commits behind
- whether a merge or rebase may be needed before sharing work

Do not fetch from remotes unless the user asks or the operation is clearly expected. If remote freshness is uncertain, say the result is based on local remote-tracking refs.

### 4. Identify risk flags

Call out states that need care before further git operations:

- unresolved merge conflicts
- detached HEAD
- dirty worktree before merge, rebase, checkout, or pull
- staged and unstaged changes mixed together
- untracked files that look important
- branch has no upstream
- branch has diverged from upstream
- local branch is behind its base
- possible in-progress merge, rebase, cherry-pick, bisect, or revert
- large number of changed files
- generated or lockfile-heavy changes

Keep these as state risks, not code-review findings.

### 5. Recommend the safest next action

Recommend one next action based on the observed state and user intent.

Examples:

- clean worktree: say there is nothing pending
- staged coherent change: say it appears ready for commit
- mixed staged and unstaged work: recommend reviewing the staged set before committing
- unrelated unstaged changes: recommend splitting or staging a smaller slice
- branch behind upstream: recommend updating from upstream before continuing
- conflicts present: recommend resolving conflicts before any other git operation
- detached HEAD: recommend creating or switching to a branch before committing
- no upstream: recommend setting an upstream before pushing if the branch should be shared

Do not perform the action.

### 6. Report clearly

Use a compact status report.

Include:

- branch
- upstream or base status
- worktree summary
- risk flags
- recommended next action

Prefer this shape:

```text
Branch: <branch>
Sync: <upstream/base status>
Worktree: <clean / staged / unstaged / mixed / conflicts>
Risks: <none / concise list>
Next: <single recommended action>
```

## Rules

- Do not modify the working tree.
- Do not stage, unstage, commit, merge, reset, checkout, stash, delete, or rewrite files.
- Do not fetch from remotes unless the user asks.
- Do not claim remote freshness unless a fetch was actually performed or the user provided that context.
- When reporting upstream or remote state without fetching, say the result is based on local remote-tracking refs.
- Do not dump full diffs unless the user asks.
- Recommend one safest next action; do not perform it.
- If the directory is not a git repository, say so and stop.
