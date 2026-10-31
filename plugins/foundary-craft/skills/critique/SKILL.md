---
name: critique
description: Assesses existing code against the Foundary Craft structural and expression standards, reporting only significant, evidence-backed weaknesses with their impact and the smallest proportionate improvement. Use when the user asks for a code-quality critique, design review, or readability assessment of existing code, files, modules, or a diff. Reports only; does not change code unless asked.
---

# Critique

Assess existing code against the Foundary Craft standards and report genuine
weaknesses, without inventing problems or prescribing needless refactoring.

Read the canonical standards at ../standards/SKILL.md before assessing. Judge
against the governing principle, the structural standards ST1–ST6, and the
expression standards EX1–EX7, citing them by ID. Do not restate, extend, or
reinterpret them here; if this skill and the reference disagree, the reference
wins.

This skill critiques. It does not implement changes, plan work, or start a
development workflow. It works on its own and is language- and
paradigm-agnostic.

## Inputs

- **Subject:** the code to assess: files, modules, functions, or a diff.
- **Context:** surrounding code, callers, and how this repository usually
  structures and expresses similar behaviour.
- **Optional focus:** particular standards, risks, or areas the user cares
  about.

If the subject is unclear, ask what to assess. For a diff, assess the changed
code in the context it lands in.

## Assessment procedure

1. **Read the code in context.** Understand what it does, who calls it, what
   contracts and trust boundaries it sits behind, and the repository's
   conventions for similar code. Inspect only what the assessment needs.
2. **Look for evidence, not surface signs.** Ask where the code is actually
   hard to understand, hard to change safely, or likely to fail. Length,
   concise expressions, contained mutation, and similar-but-not-identical
   implementations are not problems in themselves; each needs a concrete
   consequence to become a finding.
3. **Use smells and refactorings as investigative aids.** A Fowler code smell
   (source F) is a prompt to look closer, not a verdict, and a catalogue
   refactoring is a candidate, not a command. Extracting, inlining, moving,
   or leaving the code alone can each be the right outcome; decide by the
   relevant standard's "Decide by" questions.
4. **Respect conventions.** Follow the language's idioms and the repository's
   established patterns (ST6, EX7). Raise an established convention only when
   it causes a demonstrable quality problem here, not because another style is
   preferred.
5. **Classify and calibrate.** For each candidate finding, decide whether it
   is a correctness risk, a maintainability concern, or a preference, and how
   confident the evidence makes you. Drop candidates that do not survive this.

## Finding format

For each genuine finding, give:

- **Where:** file and location.
- **What:** the specific problem, observed in this code.
- **Why it matters:** the concrete consequence, citing the standard ID.
- **Recommendation:** the smallest proportionate improvement; "leave as is"
  with a note is acceptable when the cost of change outweighs the benefit.
- **Kind:** correctness risk, maintainability concern, or preference.
- **Confidence:** stated when the evidence is incomplete, for example when
  behaviour depends on callers or runtime conditions not inspected.

Order findings by impact: correctness risks first, then maintainability
concerns. List preferences separately and briefly, or omit them; never
present a preference as a defect.

## Output

- A one- or two-sentence overall assessment.
- Findings in the format above.
- Out-of-scope or unverified concerns, one line each, if any.

No substantive findings is a valid result. Say so plainly and stop; do not
manufacture advice to fill the report. Keep the report proportional to what
was found.

## Rules

- Do not modify code, stage, or commit unless the user expressly asks.
- Do not apply numeric thresholds for function, file, or module size, nesting
  depth, or parameter count.
- Do not recommend refactorings automatically because a smell is present.
- Do not prescribe language-specific syntax, formatting, or a paradigm.
- Do not invent intent, callers, contracts, or risk; state what was not
  inspected.
- Do not recommend new layers, abstractions, or helpers unless a standard
  shows they solve a present problem.
- Do not require or produce code examples unless the user asks.
