---
name: structure
description: Decides where behaviour and responsibility belong — within functions, modules, data models, and dependency boundaries — so code stays cohesive without unnecessary architecture. Use when writing or changing code and deciding whether to split or keep together, share or duplicate, introduce an abstraction, model data with a type, or add or remove a dependency boundary, or when the user asks where some code should live.
---

# Structure

Make practical, context-sensitive decisions about where behaviour and
responsibility belong, using the Foundary Craft structural standards.

Read the canonical standards at ../standards/SKILL.md before deciding. Apply
the governing principle and structural standards ST1–ST6 by ID. Do not restate
or reinterpret them here; if this skill and the reference disagree, the
reference wins.

This skill is language- and paradigm-agnostic and works on its own. It is not
a development methodology and does not prescribe a layout.

## Inputs

- **Subject:** the behaviour being added or changed, or the existing code in
  question.
- **Context:** the surrounding code and how this project already structures
  similar behaviour.
- **Optional constraints:** known boundaries, ownership, or conventions the
  user wants kept.

If the required behaviour is unclear, ask before deciding structure.

## Decision procedure

1. **Understand the behaviour and its context.** Read the code the decision
   touches and its nearest neighbours. Identify how the project already does
   similar things (ST6). Inspect only what the decision needs.
2. **Name the structural questions actually raised.** Typical ones:
   - Where should this behaviour live? Keep it with what it changes with, or
     separate it? (ST1)
   - Does this need an interface, wrapper, factory, or generalisation? (ST2)
   - Should these similar pieces share code, or stay independent? (ST3)
   - Should this value or group of values get its own representation? (ST4)
   - Which dependencies should be explicit, hidden, or removed? (ST5)

   Skip questions the change does not raise. Do not invent structural work.
3. **Decide each question from evidence.** Answer the standard's
   "Decide by" questions against the actual code and requirement: present
   change pressure, real variations, real invariants, real boundaries. Use the
   tensions list in the reference when standards pull apart.
4. **Prefer the smallest structure that holds.** When options are equally
   clear, choose the one with fewer moving parts and less indirection. Moving
   in either direction is valid: inlining, merging, or removing a layer is as
   much a structural decision as extracting one.
5. **Check project fit.** Express the decision in the language's idioms and
   the project's existing conventions. Depart only for a named, concrete
   problem (ST6).

## Rules

- Do not apply numeric thresholds for lines, parameters, file size, or module
  size. Size prompts a look; it does not decide.
- Do not introduce patterns, layers, or directory structures by default.
- Do not justify structure by imagined future requirements.
- Do not restructure code outside the requested change. Report broader
  structural concerns separately as follow-up.
- Do not require or produce code examples to explain a decision unless the
  user asks.
- When the evidence is genuinely balanced, say so, recommend the option that
  is easier to reverse, and state the trade-off.

## Output

When applying decisions while changing code, make the change and briefly note
any structural decision a reviewer might question.

When advising, give for each structural question raised:

- **Decision:** where the behaviour, data, or dependency should go, or what
  should be kept, merged, extracted, or removed.
- **Reason:** the evidence from this code, citing the standard ID.
- **Trade-off:** what is accepted, only when it matters.

Then list any out-of-scope structural concerns as follow-up, one line each.
Keep the output proportional: a simple placement question gets a one-line
answer.
