---
name: investigate
description: Read-only repository investigation for understanding existing functionality, behaviour, architecture, bugs, dependencies, and reuse opportunities. May use read-only MCP/tools/plugins, but must never modify code, files, state, or external systems.
compatibility: 'Requires: git, filesystem access. May use read-only MCP/tools/plugins when available.'
---

# Investigate

Produce a concise, evidence-backed investigation brief. Use this when the next useful step is understanding, not changing.

The brief should help the user decide whether to stop, ask a question, create a strategy, or make a compact implementation plan.

## Core rules

- Strictly read-only.
- Never modify repository state or external state.
- Prefer evidence over assumptions.
- Separate observed facts from inference.
- Keep the investigation narrow enough to answer the question.
- Do not produce an implementation plan.
- Do not silently fix discovered issues.

## Allowed

- Read files, docs, tests, manifests, config, CI/workflows, and logs.
- Search code and inspect git history.
- Run clearly non-mutating commands.
- Use read-only MCP/tools/plugins.
- Inspect read-only external metadata when relevant.
- Produce findings, risks, recommendations, and next-step options.

## Forbidden

- Do not edit, create, delete, move, format, generate, stage, commit, push, stash, reset, or amend files or git state.
- Do not install, remove, or update dependencies.
- Do not run migrations, generators, fixers, formatters, or write-mode tools.
- Do not mutate databases, caches, queues, cloud resources, tickets, docs, PRs, or other external systems.
- Do not run commands with unclear side effects.

If an action might mutate state and this cannot be confidently ruled out, do not run it.

## Investigation focus

Choose the narrowest useful focus:

- `architecture`: structure, boundaries, dependencies, ownership, interfaces.
- `bug`: failure path, reproduction evidence, recent changes, likely cause.
- `reuse`: existing helpers, similar flows, duplicated logic, patterns to extend.
- `dependency`: manifests, imports, coupling, ownership, upgrade risk.
- `data-flow`: inputs, transformations, storage, serialization, APIs, events.
- `historical`: git history, blame, previous implementations, change patterns.
- `security`: auth, authorization, secrets, trust boundaries, validation.
- `performance`: hot paths, repeated work, caching, network, queries, allocations.
- `test-gap`: missing coverage, weak assertions, flaky tests, integration gaps.

## Workflow

1. Restate the investigation question.
2. Inspect only the smallest useful context.
3. Record findings as observed, inferred, unknown, or speculative.
4. Surface contradictions instead of smoothing them over.
5. Recommend the next step based on evidence.

## Evidence quality

- Use file references, command names, commit ids, or source names when useful.
- State confidence when evidence is partial.
- Summarize patterns instead of dumping every occurrence.
- Keep raw command output out of the brief unless a short excerpt is essential.

## Stop immediately when

- a mutating action would be required
- command side effects are unclear
- required access is unavailable
- evidence is insufficient for a safe conclusion
- additional investigation has diminishing returns

## Output format

Use this structure:

```md
# Investigation: <topic>

## Summary

## Findings

## Evidence

## Risks / Unknowns

## Recommendation

## Next Step
```

Recommended next steps should be one of: no action needed, ask user, investigate further, create a strategy, create an implementation plan, implement directly, add tests, add instrumentation, or verify manually.
