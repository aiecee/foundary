# Coding Conventions

These conventions describe the preferred expression and organisation of code.

Apply them across languages using the language's natural constructs. Respect established formatting tools and syntax requirements, but do not assume existing AI-generated code represents a deliberate style choice.

Conventions are defaults, not reasons to make otherwise clear code worse.

## Visual organisation

Use whitespace to communicate the logical structure of code.

- Separate distinct stages of an operation with blank lines.
- Keep statements that form one logical step together.
- Leave a blank line after a completed conditional, loop, or other control-flow block when further statements follow.
- Apply the same visual separation in indentation-based languages.
- Do not insert blank lines between syntactically connected branches such as `if`/`else` or `try`/`catch`.
- Avoid unnecessary vertical whitespace between statements that belong together.
- Prefer concise single-line guards with immediate returns when the language and formatter support them idiomatically.

The objective is to make the structure of an algorithm apparent when scanning the code.

## File organisation

Organise declarations predictably.

Where the language supports this arrangement, prefer:

1. Imports and dependencies.
2. Related type and interface declarations.
3. Constants.
4. Private implementation functions.
5. Public operations and exports.

Adapt this ordering where language semantics, visibility rules, or established project conventions require something different.

- Group related type declarations rather than scattering them throughout implementation code.
- Avoid function-scoped type declarations unless their scope provides a meaningful benefit.
- Keep private helpers near the behaviour they support.
- Keep implementation details private unless they belong to the public contract.
- Keep constants close to their responsibility.
- Extract shared constants into a cohesive module when genuine sharing justifies it.
- Avoid generic dumping grounds for types, utilities, and constants.

## Naming

Prefer concise, meaningful, domain-oriented names.

- Use consistent terminology for the same domain concept throughout the codebase.
- Let modules, namespaces, and containing types provide context.
- Avoid repeating context already supplied by the owner.
- Add qualifiers only when they distinguish meaningful concepts or remove ambiguity.
- Prefer conventional language-specific abbreviations when their meaning is obvious.
- Use prefixes such as `is`, `has`, `can`, and `should` for boolean predicates where appropriate.
- Name functions according to their actual behaviour.
- Name files and modules according to the responsibility they own.
- Use conventional suffixes such as `Service`, `Manager`, `Factory`, or `Helper` when they accurately communicate responsibility.
- Avoid suffixes that merely describe an implementation mechanism.

When different representations share a domain concept, prefer distinguishing them through their containing modules or import aliases rather than routinely adding representation suffixes.

Names should help a developer recognise the correct destination while navigating.

## Functions and control flow

Structure functions to make their purpose and execution understandable.

- Prefer early returns over unnecessary nesting.
- Keep nesting shallow where practical.
- Prefer a switch, match, or equivalent construct when selecting among several cases of the same value.
- Use ordinary conditionals for independent conditions and guards.
- Avoid nested function definitions unless a closure or local function genuinely improves the implementation.
- Extract substantial, meaningful stages into private functions.
- Avoid trivial forwarding functions and meaningless decomposition.
- Prefer named intermediate values when they reveal meaningful stages of an algorithm.
- Keep high-level functions readable as a sequence of operations.

Function length is a signal to examine readability, not a rule that determines correctness.

## Data and mutation

Prefer immutability where practical.

- Use immutable bindings by default when supported.
- Introduce mutable bindings when reassignment genuinely improves the implementation.
- Avoid mutating caller-owned data unexpectedly.
- Prefer declarative transformations when they communicate the algorithm clearly.
- Use explicit iteration when it is clearer or required by established constraints.
- Avoid mutable intermediate collections when straightforward transformations express the same work.
- Keep significant state mutations visible and owned by an identifiable component.

Do not introduce elaborate immutable transformations merely to avoid a simple, clearly contained mutation.

## Parameters and return values

Make function dependencies understandable from their signatures.

- Prefer explicit parameters for the individual values an operation needs.
- Pass an existing domain object when the operation genuinely works with that object as a concept.
- Do not pass a large object merely to access a few unrelated fields.
- Avoid introducing single-use parameter-bag types solely to shorten signatures.
- Prefer named return values when consumers may access or destructure independent pieces of the result.
- Use positional returns and tuples when their ordering is an intentional, idiomatic part of the contract.

Use the language's natural mechanisms for these choices.

## Types and representations

- Prefer simple representations unless stronger types provide meaningful guarantees.
- Represent genuinely distinct valid states explicitly where the language supports it naturally.
- Avoid decorative wrapper types and unnecessary aliases.
- Avoid type hierarchies that exist only to satisfy a naming or architectural convention.
- Use language-native type features where they simplify a real contract.
- Do not introduce types solely because an intermediate expression has a shape.

Language-specific conventions take precedence when the language has a clearly established idiom.

For example, TypeScript may favour interfaces for ordinary object contracts and type aliases for unions or mapped compositions. That preference should not be imposed on other languages.

## Constants

Prefer named constants for meaningful values.

- Give constants names that communicate their purpose.
- Leave universally obvious literals inline when naming them adds no meaning.
- Keep constants local to their responsibility.
- Make a value configurable when a real requirement calls for variation, not merely because it might change one day.

## Comments

Comments explain why, not what.

Use comments for:

- Non-obvious reasoning.
- Important constraints.
- Deliberate trade-offs.
- Surprising behaviour that cannot be clarified through code alone.
- Required public contract documentation.

Do not narrate self-explanatory statements.

Prefer improving naming or structure when that makes an explanatory comment unnecessary.

