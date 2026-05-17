---
name: resolve
description: Resolves existing git conflict markers by inspecting the current conflict state, reading conflicted files, choosing safe resolutions, and editing files to remove normal or diff3 conflict markers. Use only when the repository is already in a conflicted merge, rebase, cherry-pick, revert, stash apply, or similar conflict state.
compatibility: 'Requires: git, filesystem access, and ability to inspect git conflict state and edit conflicted files.'
---

# Resolve

Resolves existing git conflict markers in the working tree. Optimize for preserving both sides' intent, making minimal safe edits, and leaving the repository ready for user verification.

This skill does not start merges, continue merges, abort merges, stage files, commit changes, rebase branches, pull from remotes, or rewrite history.

## Required outcomes

Always ensure the work reaches these outcomes:

- confirm the repository is currently in a conflict state before editing
- identify conflicted files using git conflict state, not guesswork
- inspect each conflicted file before changing it
- handle both normal two-sided conflict markers and diff3 / three-way conflict markers
- understand the intent of each conflict side where possible
- use the diff3 base section to reason about intent when present
- resolve conflict markers with minimal, coherent edits
- preserve unrelated code and formatting
- leave resolved files unstaged for user verification
- report what was resolved and what still needs manual attention

## Inputs

- **Conflict source**: merge, rebase, cherry-pick, revert, stash apply, or unknown conflict state.
- **Conflict scope**: all conflicted files or a specified subset.
- **Resolution preference**: preserve current side, incoming side, combine both, or decide case-by-case.
- **Conflict marker style**: normal two-sided markers, diff3 / three-way markers, or mixed.
- **Context**: target branch, source branch, PR, ticket, spec, plan, or intended behavior.
- **Validation context**: tests already run, known failures, or checks the user wants after resolution.

## Workflow

### 1. Confirm conflict state

Use git inspection commands to confirm the repository is in a conflict state.

Check:

- current branch or detached HEAD state
- whether a merge, rebase, cherry-pick, revert, or bisect operation appears in progress
- conflicted paths reported by git
- unresolved index entries
- working tree status

Allowed examples:

```bash
git status --short
git status
git diff --name-only --diff-filter=U
git ls-files -u
```

If no conflict state exists, stop and say there are no git conflicts to resolve.

### 2. Identify conflicted files

Identify conflicted files from git metadata first.

Then inspect each conflicted file for conflict markers.

If the user explicitly names files with conflict markers, those files may be resolved even when git does not report an active conflict operation.

Handle normal two-sided conflict markers:

```text
<<<<<<< HEAD
current side
=======
incoming side
>>>>>>> branch-name
```

Handle diff3 / three-way conflict markers:

```text
<<<<<<< HEAD
current side
||||||| base
common ancestor side
=======
incoming side
>>>>>>> branch-name
```

When normal conflict markers are present:

* treat the `<<<<<<<` section as the current side
* treat the `=======` section as the incoming side
* compare both sides against the surrounding code
* choose, combine, or rewrite the block based on intent
* remove all conflict markers in the final resolved file

When diff3 / three-way conflict markers are present:

* treat the `<<<<<<<` section as the current side
* treat the `|||||||` section as the base/common ancestor side
* treat the `=======` section as the incoming side
* use the base section to understand what each side changed
* prefer the side that preserves the intended final behavior
* combine both sides when each side made compatible changes
* rewrite the block when neither side alone is correct
* remove the base section and all conflict markers in the final resolved file

Do not scan the whole repository as the primary source of truth. Git conflict metadata is the source of truth for which files are unresolved.

### 3. Understand each conflict

For each conflicted file, inspect enough context to understand:

* current side
* incoming side
* base/common ancestor side when diff3 markers are present
* nearby code before and after the conflict
* related imports, types, tests, or call sites when needed
* user-provided resolution preference

Prefer minimal context. Do not perform a broad code review unless needed to resolve the conflict safely.

### 4. Choose a resolution strategy

Choose the safest strategy for each conflict:

* keep current side when incoming changes are irrelevant or already represented
* keep incoming side when current changes are obsolete or incompatible
* combine both sides when both introduce necessary behavior
* rewrite the block when neither side alone is correct
* stop for manual input when intent is ambiguous or resolution could change behavior incorrectly

Do not blindly prefer current or incoming. Use side preference only when the user explicitly asked for it or when the context makes it clearly safe.

### 5. Edit conflicted files

Edit only conflicted files unless a directly related nearby edit is required to make the resolved file syntactically coherent.

When editing:

* remove all normal conflict markers
* remove all diff3 / three-way conflict markers
* never leave the diff3 base section in the resolved file
* preserve both sides' intended behavior when appropriate
* keep formatting consistent with surrounding code
* avoid broad refactors
* avoid unrelated cleanup
* avoid changing generated files unless the conflict is in the generated file and the user expects it to be resolved manually

Do not stage files after editing.

### 6. Verify conflict markers are gone

After editing, check the resolved files again.

Verify:

* no normal conflict markers remain in edited files
* no diff3 base markers remain in edited files
* no `<<<<<<<`, `|||||||`, `=======`, or `>>>>>>>` markers remain in resolved files
* the file still appears syntactically coherent from local inspection
* no unrelated files were modified
* git still reports any unresolved files clearly
* any user-named files resolved outside active git conflict metadata no longer contain conflict markers

Allowed examples:

```bash
git diff --check
git diff --name-only --diff-filter=U
git status --short
```

Do not mark conflicts resolved with `git add`.

### 7. Report the resulting state

Report:

* conflict operation detected, if known
* files resolved
* files left unresolved
* marker styles handled: normal, diff3, or mixed
* any ambiguous decisions made
* any manual checks needed
* whether conflict markers remain
* that files were left unstaged

If validation commands are obvious from the repo, suggest them, but do not claim they passed unless actually run.

## Rules

* Use this skill only when git reports an active conflict state or conflict markers are present in files the user explicitly wants resolved.
* Handle both normal two-sided conflict markers and diff3 / three-way conflict markers.
* Use git commands for inspection, not for starting, continuing, aborting, or completing conflict operations.
* Do not start a merge.
* Do not continue a merge.
* Do not abort a merge.
* Do not run `git merge`, `git pull`, `git rebase`, `git cherry-pick`, `git revert`, or `git stash`.
* Do not run `git merge --continue`, `git rebase --continue`, `git cherry-pick --continue`, or equivalent continuation commands.
* Do not stage, unstage, commit, reset, checkout, delete, stash, or rewrite files outside direct conflict resolution edits.
* Do not use `git checkout --ours`, `git checkout --theirs`, or equivalent whole-side replacement commands unless the user explicitly asks for that exact strategy.
* Do not choose one side wholesale when both sides contain meaningful changes.
* Do not resolve generated files by hand unless there is no better source-based resolution path or the user explicitly asks.
* Do not perform unrelated formatting, cleanup, refactoring, or dependency changes.
* Never leave `<<<<<<<`, `|||||||`, `=======`, or `>>>>>>>` markers in resolved files.
* Never leave the diff3 base section in the resolved file.
* Use the diff3 base section only to understand how current and incoming changed from the common ancestor.
* If a conflict is ambiguous, stop and ask for the desired behavior instead of guessing.
* If no conflicts are present, say there is nothing to resolve.
