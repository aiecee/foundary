---
name: migrate
description: Creates a Migration Strategy for deliberate API, schema, dependency, config, framework, module path, data shape, or system convention migrations. Use when moving from one contract to another.
compatibility: 'Requires: git and filesystem access. May inspect repository context and run clearly non-mutating checks when safe.'
---

# Migrate

Create a strategy for deliberate contract migration. This skill shapes the migration before implementation.

## Required outcomes

- Define the source contract and target contract.
- State the inventory method used to find call sites and integration points.
- Choose a compatibility posture: direct cutover, adapter, dual support, or staged rollout.
- Separate mechanical updates from semantic behaviour changes.
- State rollback or deployment sequencing notes, or `Not needed`.
- Define how the old contract is removed or intentionally supported.
- Produce a Migration Strategy that avoids unrelated cleanup, hardening, fixes, or refactors.

## Core rules

- A migration moves from one contract, library, data shape, module path, config, schema, framework pattern, or system convention to another.
- Find relevant call sites and integration points before recommending edits.
- Decide whether backward compatibility or transition support is required.
- Separate mechanical updates from semantic behaviour changes.
- Update tests, docs, config, and examples when they are part of the migrated contract.
- Verify the old assumption is removed or intentionally supported.
- Recommend `scope-guard` after changes when drift risk is meaningful.

## Good uses

- replacing a library
- updating an API shape
- moving config formats
- changing import or module paths
- updating database schema usage
- converting framework patterns
- changing serialized data shapes

## Allowed

- Read source, tests, docs, manifests, config, schemas, examples, strategies, and history.
- Search for call sites, imports, references, and integration points.
- Run clearly non-mutating checks when safe.
- Recommend compatibility and rollout posture.
- Before recommending new migration coverage, read and apply `../test-rubric/SKILL.md`.
- Produce strategy text in chat.
- Ask before saving a strategy.

## Forbidden

- Do not edit files while producing the strategy unless the user separately invokes implementation.
- Do not start without source and target contracts.
- Do not mix migration with unrelated cleanup, hardening, bug fixes, or refactors.
- Do not hide semantic behaviour changes inside mechanical updates.
- Do not ignore docs, config, examples, or tests when they are part of the contract.
- Do not assume rollback or deployment sequencing is irrelevant without saying why.

## Workflow

1. Define the source contract and target contract.
2. Identify the inventory method:
   - search terms
   - import paths
   - schema/config references
   - docs/examples
   - known integration points
3. Identify call sites, integration points, tests, docs, examples, and configuration affected by the contract.
4. Decide compatibility posture:
   - direct cutover
   - adapter
   - dual support
   - staged rollout
5. Separate proposed steps into:
   - mechanical updates
   - semantic behaviour changes
   - verification
6. Identify rollback or deployment sequencing notes, or state `Not needed`.
7. Define how old-contract usage will be removed or intentionally supported.
8. Choose a verification posture:
   - `characterization`: existing tests or manual checks prove migrated behaviour remains correct.
   - `new regression`: add focused coverage for the target contract or compatibility path.
   - `no new test`: allowed only for trivial, mechanical, low-risk migrations.
9. Recommend the next step: plan, implement directly, ask user, or investigate further.

## Readiness gate

A Migration Strategy is ready for implementation only when:

- source and target contracts are explicit
- call-site inventory is narrow and complete enough for the requested scope
- compatibility posture is chosen
- proposed steps are small or mechanical
- rollback/deployment notes are addressed
- old-contract removal or support can be verified

Recommend planning before implementation when the migration is broad, multi-phase, compatibility-sensitive, deployment-sensitive, or includes semantic behaviour changes.

## Stop immediately when

- source or target contract is unclear
- inventory cannot identify relevant call sites with confidence
- compatibility posture is unresolved
- migration requires data, deployment, or rollback sequencing that is not understood
- semantic behaviour changes are being hidden as mechanical migration
- scope starts absorbing unrelated cleanup, hardening, fixes, or refactors

## Persistence

Chat output is the default. Ask before saving a strategy, and use the location the user requests.

## Output format

Use this structure:

```md
# Migration Strategy

## Change Intent

## Source Contract

## Target Contract

## Inventory Method
- Searches or sources used:
- Call sites and integration points:

## Compatibility / Rollout
- Posture: direct cutover | adapter | dual support | staged rollout
- Rollback/deployment notes: <notes | Not needed>

## Scope Boundary
- In scope:
- Out of scope:

## Evidence / Protection
- Existing protection:
- Gaps:

## Proposed Steps
### Mechanical Updates
### Semantic Changes
### Verification

## Old Contract Check
- Removed by:
- Or intentionally supported by:

## Verification Posture
- Posture:
- Target contract verification:
- Old-contract removal/support verification:

## Handoff Recommendation
- Ready for implementation planning: yes | no
- Recommended next step: plan | implement directly | ask user | investigate further
- Reason:

## Out Of Scope
```

Keep the strategy focused on the contract migration, not adjacent cleanup.
