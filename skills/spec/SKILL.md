---
name: spec
description: Turns ideas into design docs through an adaptive workflow—ground in repo context, clarify goals and constraints, compare 2-3 approaches with a recommendation, and write to docs/plans/ once the design is settled. Use when the user wants to shape an idea into a design spec.
compatibility: 'Requires: git, filesystem access.'
---

# Spec

Turns an idea into a design doc using an adaptive workflow with hard quality outcomes. Optimize for decision quality and momentum, not ritual.

## Required outcomes

Always ensure the work reaches these outcomes:
- understand relevant project context
- clarify goals, constraints, success criteria, and important non-functional requirements
- compare 2-3 plausible approaches and their trade-offs
- provide a clear recommendation
- produce a design doc useful for downstream planning

## Workflow guidance

### 1. Ground in repo context

- Inspect enough project context before drafting the design so the spec matches the existing repo.
- Prioritize files directly relevant to the idea instead of following a fixed checklist when unnecessary.
- Summarize key findings briefly before moving into solutioning.

### 2. Clarify what matters

- Clarify purpose, scope, constraints, success criteria, and relevant non-functional requirements.
- Ask focused questions in small batches when useful; prefer structured or multiple-choice prompts when practical.
- Continue only until uncertainty is low enough to produce a high-quality design.

### 3. Compare approaches

- Present 2-3 concrete approaches.
- Summarize trade-offs (complexity, risk, maintainability, implementation speed, fit with current architecture).
- End with a recommendation and why it best fits the repo and goals.

### 4. Present the design

- Present a coherent design that covers the sections that materially improve downstream planning.
- Default to a full-pass design review.
- Use staged or section-by-section review only when the work is highly uncertain, contentious, or when the user asks for iterative approval.
- Scale each section by complexity; keep simple sections short and expand complex sections as needed.

### 5. Write design doc

- Path: `docs/plans/YYYY-MM-DD-<topic>-design.md` (topic = short slug, e.g. `wishlist`, `checkout-refactor`).
- Create `docs/plans/` if it does not exist.
- Use `assets/design-doc-template.md` as the base structure, but treat it as flexible:
  - include sections that add value
  - omit sections that are irrelevant
  - expand sections that need depth
- Fill `Implementation plan` with `TBD until planify creates it` unless a known plan path already exists.
- Do not write the doc to disk until the design is settled.

## Scope boundaries

- This skill is for design-spec development.
- Do not merge design work with implementation planning (`planify`) or implementation/verification behavior (`buildify` / verification workflows).
- Do not skip trade-off thinking, even when the task is small.
