# Spec Contract

## Purpose
Define the required structure and output guarantees for Foundary `spec` stage artifacts so downstream `plan` execution does not rely on section inference.

## Required Sections
Every Foundary spec must include these section names exactly:
- `Goal`
- `Success criteria`
- `Constraints`
- `Out of scope`
- `Architecture`
- `Testing`
- `Repository context`
- `Implementation plan`

## Optional Sections
- `Rollout`
- `Dependencies`
- `Open questions`

## Output Guarantees
- Deterministic section structure using canonical section names.
- `Implementation plan` field includes a placeholder or concrete plan path.
- Explicit assumptions are listed and clearly marked.
- Repository grounding summary explains key files and constraints that influenced design choices.

## Handoff to Plan
- `Success criteria` must be actionable and testable.
- `Constraints` and `Out of scope` must bound implementation behavior.
- `Architecture` must provide enough implementation direction for task decomposition.
- `Testing` must include expected verification intent for plan-level scenario mapping.

