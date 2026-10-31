---
name: expression
description: Guides how behaviour is expressed inside cohesive code — functions, names, control flow, mutation, error handling, and comments — without prescribing syntax or forcing stylistic uniformity. Use when writing or changing code and deciding whether to split a function, how to name something, how to shape conditionals, how to handle state or failures, or whether a comment is needed, or when the user asks how to make code read more clearly.
---

# Expression

Make practical, context-sensitive decisions about how behaviour is expressed
inside cohesive code, using the Foundary Craft expression standards.

Read the canonical standards at ../standards/SKILL.md before deciding. Apply
the governing principle and expression standards EX1–EX7 by ID. Do not restate
or reinterpret them here; if this skill and the reference disagree, the
reference wins.

This skill is language- and paradigm-agnostic and works on its own. It is not
a development methodology, a formatter, or a style guide.

## Inputs

- **Subject:** the code being written or changed, or the existing code in
  question.
- **Context:** the surrounding code and how this project already expresses
  similar behaviour.
- **Optional constraints:** project conventions, contracts, or boundaries the
  user wants kept.

If the required behaviour is unclear, ask before changing how it is expressed.

## Decision procedure

1. **Read the actual code and its context.** Understand what it does, its
   callers' expectations, and the conventions around it (EX7).
2. **Name the expression questions actually raised.** Typical ones:
   - Is there a natural responsibility boundary to split on, or a cohesive
     sequence to keep? (EX1)
   - Do names reveal intent and match domain terms? (EX2)
   - Is the main path buried in nesting or hard-to-read conditions? (EX3)
   - Are ownership and significant side effects clear? (EX4)
   - Does each failure get recovered meaningfully or propagated with
     context, without swallowing or redundant checks? (EX5)
   - Is each comment needed, and is anything non-obvious left unexplained?
     (EX6)

   Skip questions the code does not raise. Do not rewrite code that already
   reads clearly.
3. **Decide each question from evidence.** Answer the standard's "Decide by"
   questions against this code: its callers, its contracts, its trust
   boundaries, its readers. These are judgement calls, not mechanical
   transformations. Use the tensions list in the reference when standards pull
   apart.
4. **Preserve structure.** Keep the structural decisions already made, by the
   project or by `structure`. Do not add layers, helpers, wrappers, or
   indirection to satisfy an expression standard. If a better expression truly
   needs a structural change, decide it under the structural standards
   instead.
5. **Choose the clearer form.** When options are equally clear, prefer the
   smaller change and the project's existing idiom.

## Rules

- Do not apply function length limits or other numeric thresholds.
- Do not demand immutability, a paradigm, or particular syntax.
- Do not impose formatting rules; leave formatting to the project's tools.
- Do not add defensive checks, fallbacks, or comments by default.
- Do not change behaviour while improving expression unless the user asked;
  swallowed errors or hidden fallbacks found along the way are reported, and
  fixed only when in scope.
- Do not rework code outside the requested change. Report broader concerns
  separately as follow-up.
- Do not require or produce code examples to explain a decision unless the
  user asks.

## Output

When applying decisions while changing code, make the change and briefly note
any expression decision a reviewer might question.

When advising, give for each expression question raised:

- **Decision:** what to keep, rename, split, flatten, propagate, or remove.
- **Reason:** the evidence from this code, citing the standard ID.
- **Trade-off:** what is accepted, only when it matters.

Then list any out-of-scope concerns as follow-up, one line each. Keep the
output proportional: a single naming question gets a one-line answer.
