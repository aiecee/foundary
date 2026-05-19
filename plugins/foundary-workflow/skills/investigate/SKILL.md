---
name: investigate
description: Read-only repository investigation for understanding existing functionality, behaviour, architecture, bugs, dependencies, and reuse opportunities. May use read-only MCP/tools/plugins, but must never modify code, files, state, or external systems.
compatibility: 'Requires: git, filesystem access. May use read-only MCP/tools/plugins when available.'
---

# Investigate

Perform read-only investigation and repository reconnaissance.

The goal is to understand what exists, how it works, and what evidence supports that understanding without making any changes.

## Core rules

- This skill is strictly read-only.
- Never modify repository state.
- Never modify external state.
- Prefer evidence over assumptions.
- Separate observed facts from inference.
- If an action might have side effects, do not run it.
- Do not confuse activity with insight.

## Allowed

You may:

- read files
- search code
- inspect git history
- inspect tests/docs/configuration
- inspect dependency manifests
- inspect CI/workflows
- run clearly non-mutating commands
- use read-only MCP/tools/plugins
- inspect read-only external metadata
- produce findings and recommendations

## Forbidden

You must not:

- edit files
- create files
- delete files
- move files
- stage, commit, push, or amend git history
- install, remove, or update dependencies
- run migrations
- run generators, fixers, or formatters in write mode
- mutate databases, caches, queues, cloud resources, tickets, docs, PRs, or external systems
- use MCP/tools/plugins in write mode
- run commands with unclear side effects
- silently fix discovered issues
- rewrite commands into mutating equivalents
- "improve" the repository during investigation

If an action might mutate state and this cannot be confidently ruled out, do not perform it.

## Investigation modes

Choose the mode that best fits the investigation goal.

### architecture

Understand system structure, boundaries, ownership, layering, dependencies, and component interaction.

Prioritize:
- source structure
- dependency flow
- architecture docs
- interfaces
- boundaries
- module relationships

### bug

Investigate failures, regressions, flaky behaviour, or unexpected output.

Prioritize:
- tests
- logs
- recent commits
- blame/history
- failure paths
- reproduction evidence

### reuse

Determine whether existing functionality, abstractions, or patterns can be reused or extended.

Prioritize:
- existing implementations
- shared utilities
- similar flows
- duplicated logic
- abstraction boundaries

### dependency

Understand dependency usage, coupling, upgrade risk, or ownership.

Prioritize:
- manifests
- lockfiles
- imports
- package usage
- transitive dependencies

### data-flow

Trace how data moves through the system.

Prioritize:
- request flow
- transformations
- storage boundaries
- events
- serialization
- APIs

### historical

Understand why something changed or how it evolved.

Prioritize:
- git history
- blame
- commit patterns
- previous implementations
- related discussions/docs

### security

Investigate authentication, authorization, secrets, trust boundaries, or risky behaviour.

Prioritize:
- auth flows
- permission checks
- secret handling
- external access
- validation/sanitization

### performance

Investigate bottlenecks, excessive work, scaling issues, or expensive paths.

Prioritize:
- hot paths
- repeated work
- caching
- network boundaries
- allocations
- query patterns

### test-gap

Understand missing, weak, or inconsistent testing coverage.

Prioritize:
- uncovered behaviour
- missing edge cases
- flaky tests
- integration gaps
- inconsistent assertions

## Operating principles

- Prefer evidence over assumptions.
- Separate observed facts from inference.
- Stay focused on the investigation question.
- Prefer narrow, evidence-driven exploration.
- Avoid broad repository crawling unless necessary.
- Inspect only the context required to answer well.
- Focus on understanding existing systems before proposing changes.
- Do not redesign systems unless explicitly asked.
- Do not produce implementation plans.
- When evidence is weak or incomplete, say so clearly.

## Command safety policy

Treat commands as one of:

- Safe read-only
- Unknown safety
- Mutating

Only execute clearly safe read-only commands.

If command behaviour or script side effects are unclear:
- do not run the command
- explain why
- request explicit user confirmation if necessary

## Evidence classification

Every meaningful conclusion should include:
- evidence source
- confidence
- reasoning path when useful

Classify findings as:

### Observed

Directly verified from source material.

### Inferred

Likely based on strong patterns or surrounding evidence.

### Unknown

Insufficient evidence to conclude safely.

### Speculative

Weak-confidence possibility requiring further verification.

## Contradiction handling

Do not silently resolve conflicting evidence.

Surface contradictions explicitly.

Examples:
- implementation conflicts with docs
- tests conflict with behaviour
- config conflicts with runtime usage
- multiple patterns coexist inconsistently

When contradictions exist:
- identify the conflicting evidence
- explain the likely reason if possible
- reduce confidence appropriately

## Investigation process

### 1. Understand the question

Clarify what needs to be:
- understood
- verified
- located
- explained
- traced
- validated

Choose the most appropriate investigation mode.

### 2. Inspect relevant context

Inspect only the smallest useful set of:
- source files
- tests
- docs
- configuration
- dependency manifests
- CI/workflows
- logs/output
- git history

### 3. Build evidence

Identify:
- existing behaviour
- architecture patterns
- reusable functionality
- risks
- gaps
- contradictions
- unknowns

### 4. Produce findings

Focus on:
- high-signal conclusions
- concise evidence-backed summaries
- relevant file references
- actionable understanding

## Output quality rules

Outputs must be concise, high-signal, and easily consumable by both humans and AI systems.

Prefer:
- short evidence-backed findings
- focused file references
- clear confidence levels
- compact summaries
- direct recommendations

Avoid:
- verbose reasoning narration
- exhaustive file dumps
- repeated observations
- unnecessary architectural speculation
- low-signal command output
- explaining every investigation step

Summarize patterns instead of listing every occurrence unless detail is required.

Use bullets and short sections over long prose.

## Default output structure

```md
# Investigation: <topic>

## Summary

## Key findings

## Relevant files

## Risks / unknowns

## Recommendation

## Confidence
```

Expand beyond this structure only when necessary.

## Recommended next actions

When appropriate, recommend one of:

- no action needed
- investigate further
- create spec
- create bug report
- add instrumentation
- add tests
- verify manually

## Stop immediately when

- a mutating action would be required
- command side effects are unclear
- evidence is insufficient for a safe conclusion
- required access is unavailable
- additional investigation yields diminishing returns
- confidence cannot improve without new evidence

