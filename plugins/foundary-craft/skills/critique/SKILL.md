---
name: critique
description: Review existing code against Foundary Craft conventions and engineering principles. Identify evidence-backed issues in readability, discoverability, cohesion, complexity, correctness, and maintainability without manufacturing problems or modifying code.
---

# Critique

Evaluate code according to Foundary's engineering conventions and principles.

Identify genuine weaknesses, explain their consequences, and recommend proportionate improvements.

Do not treat stylistic differences as architectural defects.

## References

Read and apply:

- `../craft/references/conventions.md`
- `../craft/references/principles.md`

Use the conventions to assess code expression and the principles to evaluate engineering decisions.

## Assessment

### Understand the code

Inspect the relevant implementation and enough surrounding context to understand:

- Its responsibility.
- Its public API and consumers.
- Its dependencies and state ownership.
- Its execution and failure behaviour.
- Its relationship to neighbouring modules.
- Relevant project conventions and constraints.

Do not infer a design problem from an isolated code fragment without examining the necessary context.

### Evaluate navigability

Assess whether:

- Responsibility ownership is predictable.
- Public entry points are discoverable.
- Related behaviour is organised coherently.
- Module and symbol names communicate their purpose.
- Domain vocabulary is consistent.
- Navigation follows an understandable path.
- Unnecessary layers or indirection obstruct comprehension.

Do not treat multiple files or navigation steps as problems by themselves.

### Evaluate expression

Assess whether:

- High-level functions communicate their overall purpose clearly.
- Substantial stages are decomposed meaningfully.
- Whitespace and declaration order support readability.
- Control flow is straightforward.
- Names are appropriately concise and contextual.
- Mutation and side effects are understandable.
- Types and intermediate values provide meaningful clarity.
- Comments explain reasoning rather than narrating code.

Distinguish deviations from conventions from genuine maintainability problems.

### Evaluate design

Assess whether:

- Abstractions solve actual problems.
- Shared behaviour has a genuinely shared meaning.
- Data models represent meaningful constraints.
- Dependencies and state have clear owners.
- External libraries and custom implementations are justified.
- Errors are propagated, handled, or recovered appropriately.
- Algorithms suit known requirements.
- Complexity provides a concrete benefit.

Evaluate decisions against the actual use case rather than a preferred architectural pattern.

### Consider project context

Account for:

- Language idioms.
- Existing project conventions.
- Project maturity and purpose.
- Delivery constraints.
- Refactoring cost and regression risk.
- Known performance and consistency requirements.

A reasonable compromise under real constraints is not automatically a defect.

## Finding classification

Classify observations as:

**Correctness risk**

A defect or credible failure mode that may produce incorrect behaviour, violate a contract, or conceal an operational problem.

**Maintainability concern**

A concrete problem that makes code meaningfully harder to understand, navigate, modify, or extend.

**Convention deviation**

A departure from Foundary's established coding conventions without sufficient evidence of a broader quality problem.

**Contextual trade-off**

A reasonable alternative design with meaningful advantages and disadvantages. Report only when the trade-off helps the user understand a significant decision.

Do not elevate personal preferences into correctness claims.

## Recommendations

For each substantive finding:

- Identify the affected code.
- Describe the observed problem.
- Explain its consequence.
- Recommend a proportionate improvement.
- State uncertainty where relevant.

Prefer addressing the underlying cause over applying superficial changes.

Recommendations may involve extracting, inlining, combining, moving, renaming, or leaving code unchanged.

Do not recommend refactoring solely because a function is long, a file is large, or a familiar code smell is present.

Do not propose new abstractions unless they solve a demonstrated problem.

## Output

Start with a brief overall assessment.

For each substantive finding, provide:

- **Location:** File, function, or relevant code region.
- **Finding:** The specific issue.
- **Impact:** Why it matters.
- **Recommendation:** The smallest appropriate improvement, considering the project's constraints.
- **Classification:** Correctness risk, maintainability concern, convention deviation, or contextual trade-off.

Prioritise correctness and maintainability findings.

Group minor convention deviations when appropriate.

Report uncertainty rather than inventing evidence.

If no meaningful issues are found, say so.

## Boundaries

- Critique is read-only unless the user separately requests implementation.
- Do not modify, stage, commit, or push code.
- Do not introduce a development workflow or implementation plan automatically.
- Do not require a fixed number of findings.
- Do not manufacture problems to justify a review.
- Do not prescribe an architectural pattern without contextual justification.
- Do not require arbitrary function, file, module, or parameter limits.
- Do not treat established conventions as unquestionable when they are demonstrably harmful.
- Do not produce unrelated recommendations.

