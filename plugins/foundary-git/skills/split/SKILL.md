---
name: split
description: Splits mixed local git changes into a small coherent commit series by inspecting staged, unstaged, working tree, or branch diffs, grouping related files and hunks, and staging only the next safe commit slice when staging is possible. Use when the user asks to split changes, prepare separate commits, organize a messy diff, or when a change set contains unrelated concerns.
compatibility: 'Requires: git, filesystem access, and ability to inspect and stage git changes.'
---

# Split

Splits mixed git changes into coherent commit-sized units before commit creation. Optimize for clean history, safe staging, and preserving the user's work exactly.

This skill prepares commit-sized slices. It does not create commit messages or run `git commit`.

## Required outcomes

Always ensure the work reaches these outcomes:

- inspect the relevant git change set before proposing a split
- identify whether the changes represent one coherent unit or multiple units
- group related files and hunks by intent, not by path alone
- propose a small, ordered commit series when multiple groups exist
- stage only the selected next commit slice when the source is stageable local changes
- avoid staging unrelated or obvious local-only files
- leave the working tree in a clear state for the user's next git action

## Inputs

- **Change source**: staged diff, unstaged diff, working tree diff, or branch diff.
- **Split target**: full commit series, next commit only, or a specific subset of files.
- **Base reference**: branch, commit, or merge-base used for branch diffs.
- **Commit ordering preference**: foundational changes first, behavior changes first, tests with implementation, or user-specified order.
- **Optional context**: ticket reference, feature name, planned commit shape, or files that must stay together.

## Workflow

### 1. Load the change context

Inspect the current git state before making recommendations.

Check:

- current branch
- staged changes
- unstaged changes
- untracked files
- deleted files
- branch diff when the user asks to split a branch

Prefer the smallest relevant diff:

- use staged changes when the user asks to split staged work
- use working tree changes when the user asks to split local changes
- use branch diff when the user asks to split a branch into commits

If the requested change source is unclear, ask whether to split staged changes, unstaged changes, all working tree changes, or the branch diff.

For branch diff requests, default to analysis and proposal only. Do not imply that staging a slice from already-committed branch history is possible without history rewrite operations.

### 2. Classify the change set

Determine whether the diff contains:

- one coherent change
- multiple related commits in a natural series
- unrelated work that should be separated
- formatting-only changes mixed with behavior changes
- tests mixed with implementation
- documentation mixed with code
- generated or lockfile changes paired with source changes

Do not treat every file as a separate commit. Group by intent.

This is a commit-shape classification, not a full quality, security, or correctness review. Only assess those concerns when they affect whether changes can be safely grouped or staged.

### 3. Identify safe commit groups

Create proposed groups based on coherent intent.

Prefer groups such as:

- schema, type, or interface changes needed before implementation
- implementation changes
- tests for the implementation
- documentation updates
- dependency or lockfile updates
- mechanical formatting changes
- cleanup or refactor-only changes
- generated artifacts that correspond to a source change

Keep tests with implementation when they prove the same behavior and the combined diff remains easy to understand.

Split tests from implementation when:

- the implementation is already large
- the tests validate multiple separate behaviors
- the test changes are mechanical or fixture-heavy
- the user explicitly wants red/green style commits

Keep generated files with their source changes when they are required for the repo to build or run correctly. Otherwise, call out generated changes separately and avoid staging them without a clear reason.

### 4. Present the proposed split

Before staging, summarize the proposed commit series.

For each proposed group, include:

- short working label
- purpose
- files or hunks included
- files or hunks deliberately excluded
- reason the group is coherent
- suggested order

Do not draft final commit messages. Use working labels only.

If the split is obvious and low-risk, proceed after a brief explanation. If the split is ambiguous, ask the user to choose between the viable options.

### 5. Stage the next commit slice

Before staging, inspect the current index.

If the index already contains unrelated staged changes, do not mix new changes into it silently. Ask whether to preserve the index as-is, include those changes in the selected slice, or unstage before continuing.

If the change source is a branch diff of already-committed history, do not stage. Provide the proposed split order only, and ask for explicit confirmation before any history-rewrite workflow.

For stageable local sources (staged, unstaged, or working tree changes), stage only the files or hunks that belong in the selected next commit slice.

Use file-level staging when the whole file belongs to the group.

Use patch or hunk staging when a file contains changes for multiple commit groups.

Inspect untracked files before staging them. Do not stage untracked files based on filename alone.

Do not stage:

- unrelated local work
- editor swap files
- build output
- logs
- temporary files
- environment files
- generated files whose source change is not included
- lockfile changes unrelated to the selected dependency change

If hunk-level staging is required and cannot be done safely, stop and explain the ambiguity rather than staging too much.

### 6. Verify the staged slice

After staging, inspect the staged diff again.

Confirm:

- the staged diff forms one coherent unit
- no unrelated files were included
- source and generated files are paired when they must be committed together
- tests are included or intentionally left for a later slice
- remaining unstaged changes are intentionally left for later commits
- the staged change is ready for the user's next git action

This is a staging-scope check, not a full code review.

### 7. Report the resulting state

Once the staged slice is clean:

- summarize what is staged
- summarize what remains unstaged
- state whether the staged slice appears ready to commit
- call out when the staged slice is risky, broad, generated-heavy, security-sensitive, or hard to reason about
- do not create the commit yourself

## Rules

- Do not create commits.
- Do not write final commit messages; use only short working labels for proposed groups.
- Do not stage everything by default.
- Do not use `git add .` unless every changed and untracked file has been inspected and belongs in the selected commit slice.
- Do not silently mix unrelated pre-existing staged changes into a new slice; ask the user how to handle the existing index first.
- Do not discard, reset, checkout, delete, overwrite, or stash user changes unless the user explicitly asks.
- Do not claim that branch history can be split by staging; when splitting already-committed branch history, provide proposals and require explicit user confirmation before any rewrite workflow.
- Do not split purely by directory or file type when the logical intent crosses boundaries.
- Do not separate tests from implementation by default when they prove the same behavior.
- Do not stage untracked files without inspecting their content.
- Do not include generated files unless their source change is included in the same group or the user explicitly confirms they belong.
- Do not include obvious local-only files such as editor swap files, build output, logs, temporary files, or environment files.
- If hunk-level staging is required and cannot be done safely, stop and explain the ambiguity rather than staging too much.
- If the diff contains unresolved conflicts, stop and recommend resolving conflicts before splitting.
- If the worktree is clean, say there is nothing to split.
- If all changes form one coherent unit, say no split is needed and leave the worktree unchanged unless the user explicitly asked to prepare or stage the next commit.
