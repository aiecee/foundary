---
name: craft
description: Apply Foundary's engineering conventions and principles when writing, modifying, or refactoring code. Prioritises discoverability, readability, cohesion, deliberate abstractions, and context-sensitive engineering decisions.
---

# Craft

Write code that is straightforward to understand, navigate, and maintain.

Code should reveal its responsibilities, expose intentional APIs, and allow a developer to follow a clear path from high-level behaviour to implementation detail.

Optimise for finding the correct path through the code, not for minimising files, functions, or navigation steps.

## References

Read and apply:

- `references/conventions.md` — established preferences for how code is written and organised.
- `references/principles.md` — engineering judgement for architecture, responsibilities, state, errors, and implementation decisions.

Conventions describe the preferred expression of code. Principles determine which implementation is appropriate.

Apply both, resolving conflicts through the actual requirements, language, and project constraints.

## Operating rules

### Understand the context

Before changing code:

- Understand the behaviour being implemented or modified.
- Inspect the relevant modules, entry points, and immediate dependencies.
- Identify established domain vocabulary and meaningful public contracts.
- Distinguish deliberate project conventions from incidental or problematic existing code.
- Identify concrete constraints that influence the implementation.

Inspect enough to make an informed decision without unnecessarily exploring the entire repository.

### Choose the design

- Prefer the simplest solution that meets the actual requirements.
- Follow the language's natural idioms.
- Use established project conventions when they remain appropriate.
- Do not introduce abstractions, layers, types, configuration, or dependencies for hypothetical future needs.
- Choose architecture according to responsibilities, lifecycle, data flow, concurrency, and failure requirements.
- Use straightforward algorithms until known requirements or measured behaviour justify additional complexity.

Do not impose a preferred architectural pattern on an unsuitable problem.

### Express the implementation

- Make high-level operations read as clear sequences of meaningful work.
- Keep related behaviour together.
- Extract substantial stages into focused private functions where this improves understanding.
- Prefer concise, contextual names and consistent domain terminology.
- Keep dependencies, state ownership, and side effects understandable.
- Expose only the operations consumers genuinely need.
- Apply the coding conventions without introducing unnecessary implementation complexity.

### Work with existing code

Existing code is context, not unquestionable authority.

When the existing design is appropriate, preserve its conventions.

When the design obstructs the requested work, evaluate whether refactoring is justified by the project's constraints, risk, and expected benefit.

If refactoring is needed before implementing new behaviour:

1. Identify the structural problem.
2. Propose or perform the refactor within the authorised scope.
3. Verify that existing behaviour remains intact.
4. Implement the new behaviour against the improved structure.

Do not silently broaden an approved scope. Where a separate refactor requires authorisation, report it rather than incorporating it implicitly.

### Review the result

Before considering the implementation complete, assess:

- Can a developer predict where the functionality lives?
- Is the intended public API obvious?
- Does the high-level execution flow read clearly?
- Are names meaningful within their context?
- Are dependencies and state ownership explicit?
- Does every abstraction solve a real problem?
- Are errors visible and handled by appropriate owners?
- Is unnecessary complexity present?
- Does the code follow the applicable conventions?

Correct issues introduced by the implementation within its authorised scope.

## Boundaries

- Craft governs code quality, not the development workflow.
- Approved plans, contracts, and scope restrictions remain authoritative.
- Do not perform unrelated cleanup or architectural redesign.
- Do not introduce a dependency injection framework, class hierarchy, rules engine, or other architectural mechanism by default.
- Do not enforce arbitrary limits on function length, file size, nesting depth, or parameter count.
- Do not sacrifice clarity to satisfy a superficial metric.
- Do not automatically create additional types, helpers, or modules.
- Do not use patterns merely because they are conventionally considered best practice.
- Do not turn an engineering preference into a universal architectural requirement.

## Output

When implementing code, produce the code rather than a separate analysis of every principle applied.

Explain only meaningful design decisions, trade-offs, deviations, or limitations that a reviewer would need to understand.

Keep explanations proportionate to the work.

