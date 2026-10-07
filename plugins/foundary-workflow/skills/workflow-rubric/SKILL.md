---
name: workflow-rubric
description: Shared Foundary workflow guidance for task contracts, bounded investigation, milestone handoffs, validation sequencing, and durable task context.
---

# Workflow Rubric

This is a shared reference rubric for the Foundary workflow skills. Apply it
from investigate, design, plan, implement, scope-guard, or test-rubric; it does not replace
those skills or provide an independent implementation strategy.

## When to apply

Use this rubric for material, interactive, cross-package, CMS, browser, or
architectural work. Keep trivial, styling-only, copy-only, and low-risk work
compact.

## Task Contract

Establish only the fields relevant to the work:

- **Goal:** intended behaviour or outcome
- **Canonical surface:** route, page, package, API, or other boundary being changed
- **Source of truth:** authoritative code, data, schema, or contract
- **Runtime assumptions:** current server, browser, environment, or deployment state when relevant
- **Scope:** explicit in-scope and out-of-scope work
- **Acceptance checks:** observable evidence that the goal is met
- **Stop conditions:** facts that require a new decision before implementation continues

For interactive work, verify the canonical page, route, URL, and existing
runtime before exploring alternatives.

## Bounded investigation

Before widening an investigation, define what evidence will make it complete.
Stop when the source of truth, ownership boundary, relevant files, verification
path, and material unknowns are clear enough for the next decision.

Record a compact handoff map:

- relevant files or integration points;
- adopted decisions or observed constraints;
- checks already run;
- open questions;
- what was deliberately not investigated.

Do not continue scanning for completeness after the investigation boundary is
answered.

## Milestones and handoffs

Keep one task focused on one coherent behaviour or contract change. Keep
tightly coupled schema, query, transformer, and generated-type changes together.

Use a handoff after a stable milestone, coherent commit, or context compaction.
Carry forward only:

- completed work;
- relevant files;
- adopted decisions;
- checks already run;
- unresolved questions;
- next step.

Revalidate runtime and environment assumptions at the handoff. Do not treat
current URLs, running servers, branches, temporary experiment values, or
one-off investigation notes as durable decisions.

## Validation ladder

Use the narrowest useful validation and widen it only when risk justifies it:

1. focused test or check while developing;
2. package-level validation after the behaviour is stable;
3. broader build, lint, type, or integration validation only for cross-cutting,
   high-risk, final, or explicitly requested work.

Do not repeat broad validation to compensate for unclear scope or an
unverified implementation assumption.

## Review checklist

Before moving to the next phase, check:

- Is the task contract explicit enough for the current decision?
- Did exploration stop at a useful boundary?
- Is the next milestone or handoff clear?
- Are runtime assumptions current?
- Is validation proportional to the changed boundary?
- Did any new product, contract, compatibility, rollout, or architecture
  decision appear without being approved?
