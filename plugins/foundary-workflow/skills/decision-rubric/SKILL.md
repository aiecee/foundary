---
name: decision-rubric
description: Use when creating or reviewing Foundary design strategies, focused change strategies, or implementation plans with material decisions. Defines how to stay concise while preserving the evidence needed to choose safely.
---

# Decision Rubric

Use this rubric to remove repetition without removing decision evidence.

## Material-decision gate

Apply decision-complete detail when any of these are true:

- multiple viable approaches exist
- a public/runtime contract or user-visible behaviour may change
- multiple modules or systems are affected
- compatibility, rollout, backout, or reversibility matters
- the choice is expensive or difficult to reverse
- material uncertainty changes the recommendation

If none apply, keep the output brief and state why no material decision exists.

## Required decision evidence

For each material decision, preserve only the fields that matter:

- **Decision:** what must be chosen or approved
- **Recommendation:** the preferred option
- **Evidence:** repository facts, tests, history, or constraints supporting it
- **Alternatives:** viable options considered, or why only one is sensible
- **Trade-offs:** benefits gained and costs or risks accepted
- **Assumptions / unknowns:** confirmed facts versus inference
- **Impact:** affected boundaries, compatibility, rollout, and reversibility when relevant
- **Status:** resolved, non-blocking unknown, or blocking user decision

Existing sections such as Options, Recommendation, Compatibility, or Open Decisions may satisfy these fields. Do not repeat the same rationale in a second section.

For the shared task contract, milestone, handoff, and durable-context rules,
read and apply the workflow rubric at ../workflow-rubric/SKILL.md.

## Adaptive output rules

- Keep simple work at its current compact size.
- Expand only the sections needed to make a material decision safe.
- Prefer concrete evidence and named files over generic explanation.
- Use `Not applicable` only when omitting a field would otherwise be ambiguous.
- Never invent requirements, alternatives, evidence, or certainty.
- If a material decision remains blocked, stop and identify the missing input.

## Strategy-to-plan handoff

- The strategy owns the full decision rationale.
- The plan carries a compact summary of adopted decisions, relevant task
  contract fields, and implementation constraints, not the full strategy
  repetition.
- Runtime assumptions are revalidated at the handoff; they are not treated as
  durable decisions.
- A plan must not silently resolve a new material decision discovered during repository grounding.

## Review checklist

Before output, check:

- Can the user choose or approve the material decision without asking why?
- Is each recommendation tied to evidence?
- Are accepted trade-offs and important unknowns visible?
- Did the output stay short by removing repetition rather than decision support?
- Did downstream planning preserve the decision without copying the whole strategy?
