---
name: design
description: Creates a compact Design Strategy for ambiguous or architectural work before implementation planning. Use when multiple approaches, ownership boundaries, public contracts, data shapes, user-visible behaviour, or trade-offs need deciding.
compatibility: 'Requires: git and filesystem access. May inspect repository context and read test-rubric when testing implications matter.'
---

# Design

Create a compact design strategy for work that needs a decision before implementation planning.

This skill shapes the change before planning or implementation. It does not edit files, stage changes, commit, or create a design document unless the user asks.

## Required outcomes

- Clarify the goal and success criteria.
- Identify affected behaviour, ownership, boundaries, contracts, and constraints.
- Compare viable approaches when meaningful alternatives exist.
- Recommend one approach with trade-offs.
- Define scope and out-of-scope work.
- Identify testing, verification, and rollout implications.
- Produce a Design Strategy that is ready for planning, or clearly state the decision still needed.

## Core rules

- Use this when implementation planning would require guessing about architecture, ownership, contracts, or product behaviour.
- Keep the strategy as small as the decision allows.
- Prefer existing repo patterns over new abstractions.
- Prefer the simplest approach that satisfies the goal.
- Do not turn design into implementation planning.
- Do not produce a large spec by default.
- Do not invent requirements, ownership, contracts, or rollout needs.
- If only one sensible approach exists, say so and keep the strategy short.
- If the work is already clear enough to break into implementation steps, recommend `plan`.
- If testing implications matter, read and apply `../test-rubric/SKILL.md`.

## Use When

- Multiple implementation approaches are plausible.
- Architecture, ownership, or module boundaries are unclear.
- Public API, data model, persistence, events, config, or runtime contracts may change.
- User-visible behaviour needs shaping before implementation.
- The work affects cross-module or cross-system behaviour.
- Trade-offs around complexity, risk, rollout, performance, maintainability, or compatibility matter.
- A normal implementation plan would require guessing.

## Do Not Use When

- Broken behaviour, failing test, regression, runtime error, or incorrect output -> use `fix`.
- Behaviour-preserving restructure -> use `refactor`.
- Safer validation, error handling, permissions, external input, or edge cases -> use `harden`.
- Moving from one contract, convention, dependency, schema, config, or API to another -> use `migrate`.
- The change is already clear enough to plan directly -> use `plan`.

## Allowed

- Read relevant source, tests, docs, strategies, manifests, config, and history.
- Search for existing patterns, ownership, contracts, and similar implementations.
- Run clearly non-mutating inspection commands when safe.
- Compare approaches and recommend one.
- Produce strategy text in chat.
- Ask before saving a strategy.

## Forbidden

- Do not edit files while producing the strategy unless the user separately asks for implementation.
- Do not create large design docs by default.
- Do not invent product requirements.
- Do not invent public contracts or rollout requirements.
- Do not bury fixes, refactors, hardening, migrations, or broad cleanup inside design.
- Do not choose a high-risk architecture when a smaller existing pattern would satisfy the goal.
- Do not proceed to planning when a material decision is unresolved.

## Workflow

1. Understand the goal and desired outcome.
2. Inspect the smallest useful repository context:
   - relevant source files
   - similar implementations
   - public/runtime contracts
   - tests
   - docs or strategies
   - repo instructions
3. Identify constraints:
   - product or behaviour constraints
   - technical constraints
   - compatibility constraints
   - non-functional constraints when relevant
4. Identify affected boundaries:
   - modules
   - APIs
   - data shapes
   - persistence
   - UI or user flows
   - external services
   - configuration or runtime contracts
5. Compare 2-3 viable approaches when alternatives genuinely exist.
6. If only one sensible approach exists, state why and avoid fake alternatives.
7. Recommend the smallest approach that satisfies the goal.
8. Define scope and out-of-scope work.
9. Identify testing, verification, and rollout implications.
10. Decide whether the strategy is ready for planning.

## Readiness gate

A Design Strategy is ready for planning only when:

- the recommended approach is clear
- affected boundaries are named
- important trade-offs have been considered
- scope and out-of-scope work are explicit
- testing and verification implications are understood enough to plan
- unresolved decisions are either minor or clearly listed
- implementation can be planned without inventing architecture or behaviour

Recommend investigation before planning when the relevant repo context is too weak.

Ask the user before planning when the decision depends on product preference, naming, UX behaviour, public contract shape, rollout risk, or compatibility trade-offs.

## Stop immediately when

- the goal is unclear
- affected ownership or boundaries cannot be determined
- the design depends on missing product behaviour
- multiple approaches are viable but the choice depends on user preference
- the design would require broad architecture redesign beyond the request
- compatibility or rollout risk is material but cannot be assessed
- implementation planning would require guessing

## Persistence

Chat output is the default. Ask before saving a strategy, and use the location the user requests.

## Output format

Use this structure:

# Design Strategy

## Change Intent
- Goal:
- Success criteria:

## Repository Context
- Relevant files/patterns:
- Existing constraints:
- Similar implementations:

## Affected Boundaries
- Modules:
- Public/runtime contracts:
- Data or persistence:
- User-visible behaviour:
- External services/config:

## Options

### Option 1: <name>
- Summary:
- Pros:
- Cons:
- Risk:

### Option 2: <name>
- Summary:
- Pros:
- Cons:
- Risk:

### Option 3: <name, optional>
- Summary:
- Pros:
- Cons:
- Risk:

## Recommendation
- Recommended approach:
- Why this fits best:
- Trade-offs accepted:

## Scope Boundary
- In scope:
- Out of scope:

## Testing / Verification Notes
- Behaviour to prove:
- Likely test level:
- Verification commands or manual checks:
- Gaps:

## Rollout / Compatibility
- Compatibility concerns:
- Rollout notes:
- Backout considerations:

## Open Decisions
- Decision:
- Why it matters:

## Handoff Recommendation
- Ready for next step: yes | no
- Recommended next step: plan | ask user | investigate further
- Reason:

Keep the strategy concise enough to guide planning without becoming a full specification.
