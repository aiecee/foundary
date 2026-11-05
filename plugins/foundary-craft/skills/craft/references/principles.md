# Engineering Principles

These principles guide engineering decisions when multiple valid implementations are possible.

The objective is not to enforce a preferred architecture. It is to produce code whose structure, responsibilities, and complexity are justified by the problem being solved.

## Governing principle

Prefer the simplest correct implementation that expresses the required behaviour clearly and provides an obvious path through the code.

Simplicity is not measured by the number of files, functions, interfaces, or lines of code.

Every architectural decision should be justified by actual requirements, responsibilities, constraints, or a demonstrated improvement in understanding.

## 1. Discoverability and ownership

Optimise for finding the correct path through a codebase quickly.

- Make the owner of a responsibility predictable.
- Give functionality a clear and recognisable entry point.
- Organise modules according to their responsibilities.
- Keep behaviour near the concepts it supports.
- Use consistent domain terminology.
- Ensure related concepts can be located without understanding unrelated implementation details.

Do not optimise for the fewest navigation steps. Moving through several well-organised modules is preferable to searching through a poorly structured one.

Start with straightforward module organisation. Split responsibilities into cohesive submodules when their complexity, independence, or readability warrants it.

Avoid splitting code solely to reduce file size.

## 2. Deliberate public APIs

A module should expose the operations its consumers need, not its complete implementation.

- Keep internal helpers private.
- Prefer focused, discoverable operations over generic command dispatchers.
- Let the module provide context for operation names.
- Hide implementation choices that consumers do not need to make.
- Expose meaningful choices when consumers genuinely require control.
- Avoid forwarding layers that do not provide a useful boundary.

Design internal and external APIs according to their different consumers.

An internal application component may hide implementation selection. A reusable library may need to expose several explicit operations.

Neither approach is universally preferable.

## 3. Cohesion and decomposition

Follow the principle of doing one thing and doing it well.

A responsibility should be cohesive, but a cohesive responsibility may still contain substantial stages that deserve separation.

- Keep related behaviour together.
- Separate calculations from side effects where doing so improves clarity.
- Prefer high-level functions that read as a sequence of meaningful operations.
- Extract substantial stages into focused private functions.
- Keep single-use helpers local when their purpose is implementation clarity.
- Extract shared functionality into separate modules when actual reuse or responsibility boundaries justify it.
- Avoid scattering related logic across unnecessary layers.

Function extraction and module extraction are separate decisions.

A private helper need not be reusable to justify its existence. A separate shared module should have a stronger reason to exist.

Avoid arbitrary numerical limits. Evaluate whether the implementation is understandable and its responsibilities are well expressed.

## 4. Abstractions and variation

Introduce abstractions to solve existing problems, not hypothetical future ones.

Good reasons include:

- Multiple real implementations of the same responsibility.
- A meaningful external dependency boundary.
- A need to substitute an implementation.
- Complexity that can be hidden behind a substantially clearer contract.
- Behaviour that is genuinely shared.

Prefer a common abstraction when several implementations fulfil the same coherent contract.

Do not force similar-looking behaviour into one abstraction if its meaning, invariants, or responsibilities differ.

Avoid:

- Speculative interfaces and extension points.
- Class hierarchies without meaningful differences in behaviour.
- Wrappers that merely reproduce another API.
- Flags and modes introduced solely to combine unrelated cases.
- General-purpose frameworks for a single straightforward use case.

Use the language's natural constructs to express abstraction.

An abstraction is useful when it reduces the knowledge its consumers need, not merely when it adds an interface.

## 5. Choosing an implementation strategy

Select the representation of behaviour according to its actual characteristics.

### Conditional logic

Use straightforward conditionals, guards, and switches when they express the behaviour clearly.

### Data-driven rules

Represent behaviour as rules when the variations naturally share a consistent structure and can be described as data.

Do not build a general-purpose rules engine merely because conditions exist.

### Separate implementations

Separate distinct behaviours when they have substantial independent logic that does not fit a cohesive rule representation.

Use simple dispatch and language-native interfaces where sufficient.

### Stateful versus event-based systems

Choose state management according to the system's execution and consistency requirements.

Sequential operations may be naturally implemented through state-owning components.

Independent, asynchronously arriving events may justify recorded events, projections, or event sourcing.

Neither approach is a default architecture.

Assess ordering, concurrency, history, durability, and consumer requirements before selecting one.

## 6. Data modelling

Represent the domain accurately without unnecessary ceremony.

- Prefer representations that make invalid state combinations difficult or impossible to construct.
- Use unions, enums, algebraic data types, or equivalent language-native constructs where appropriate.
- Prefer primitives for ordinary values unless a domain-specific type provides meaningful behaviour or correctness guarantees.
- Avoid decorative wrappers and aliases.
- Do not copy persistence or transport representations into the domain merely because they already exist.
- Prefer named results when multiple independent values are returned.
- Pass cohesive domain objects when operations work with them as concepts.
- Otherwise, prefer explicit values.

Model known constraints, not hypothetical complexity.

Do not introduce an elaborate type system when the language cannot express the intended guarantees naturally.

## 7. Dependencies and lifecycle

Make dependency construction and ownership understandable.

- Prefer explicit dependency injection where practical.
- Use factories to construct components that require dependencies or have meaningful lifecycles.
- Pass dependencies directly rather than introducing unnecessary parameter-bag types.
- Avoid hidden construction of databases, providers, loggers, and other substantial dependencies.
- Allow multiple independent component instances where the requirements call for them.
- Use service locators when they solve a concrete architectural problem, rather than prohibiting them categorically.
- Avoid dependency injection frameworks unless they provide a genuine benefit.

A shared instance does not have to be a globally accessible instance.

Choose dependency lifetimes deliberately.

## 8. State ownership and persistence

Keep state with the component responsible for its behaviour when that provides clear ownership.

- Components should manage the state transitions they own.
- Inject persistence mechanisms rather than making persistence technology part of the domain's public API.
- Do not make unrelated consumers shuttle internal state between operations.
- Avoid uncontrolled shared mutation.
- Use immutable calculations where practical, without prohibiting legitimate internal state.

Choose persistence and consistency policies according to the operation.

When a component applies state in memory before persistence:

- Do not persist a change that could not be applied.
- Retry transient persistence failures within defined limits where appropriate.
- Expose unrecoverable persistence failures.
- Stop dependent processing when continued operation would violate consistency guarantees.
- Do not invent speculative recovery that could compound the failure.

Other systems may require transactional, event-based, or externally owned state. Choose according to their guarantees.

Use database transactions when related database changes must succeed atomically.

Do not introduce distributed coordination mechanisms unless the actual boundaries require them.

## 9. Errors and failure boundaries

Distinguish expected outcomes, operational failures, and broken internal invariants.

### Expected outcomes

An unsuccessful but valid domain operation is not necessarily an error.

Intentional cancellation is expected control flow, even when the language represents it using an exception or error value.

Do not retry intentional cancellation or report it as an operational error.

### Operational failures

Handle failures near their source when the component has a meaningful way to recover.

- Retry transient failures within sensible, bounded limits.
- Respect retry information supplied by external systems.
- Propagate failures when meaningful local recovery is unavailable.
- Preserve the original cause when adding context.
- Never silently convert a failure into a successful-looking default.

Catching an error and returning an arbitrary fallback is error masking, not error handling.

### Broken invariants

Fail immediately when an internal guarantee is violated.

Do not turn programming defects or impossible states into routine recoverable outcomes.

Stop the affected operation rather than proceeding with invalid assumptions.

### Ownership

The component that understands a failure should own its recovery policy.

Transport providers handle transient transport failures.

Domain components validate their own domain rules and decide how to respond to domain-invalid outcomes.

### Error representations

Prefer cohesive, classified error contracts over unnecessary error subclass hierarchies.

Use meaningful reasons or codes where callers need to distinguish failures.

Use the language's natural mechanisms for representing and propagating errors.

### Logging

Log failures at the boundary that meaningfully handles them.

Intermediate layers may attach context but should not repeatedly log the same propagated failure.

Avoid duplicate diagnostics that obscure the original failure.

## 10. Validation and defensive programming

Validate at genuine trust boundaries.

- Validate external input, remote responses, and untrusted persisted data.
- Enforce meaningful internal invariants.
- Trust established internal contracts once validation has succeeded.
- Avoid repeating defensive checks throughout the call chain.
- Do not conceal unexpected states by inventing fallback behaviour.

Defensive code should protect a real boundary or invariant, not compensate for uncertainty about the system's own contracts.

## 11. Algorithms and performance

Start with a straightforward, correct algorithm.

- Prefer declarative transformations when they clearly express the operation.
- Name intermediate stages when they clarify a larger transformation.
- Use explicit iteration when it better serves clarity or known constraints.
- Avoid specialised algorithms for hypothetical scale.
- Measure performance before introducing complex optimisations when practical.
- Account for known data sizes, latency requirements, and resource constraints from the outset.

Meeting a known performance requirement is not premature optimisation.

Do not sacrifice readability for performance improvements that have no demonstrated value.

## 12. External dependencies

Choose between existing libraries and local implementations based on fit.

- Prefer established libraries when they solve a substantial, well-understood problem appropriately.
- Use straightforward local solutions for simple requirements.
- Implement custom behaviour when available dependencies cannot adequately satisfy the requirements.
- Consider the maintenance and conceptual cost of an external dependency, not merely the lines of code saved.
- Abstract dependencies where substitution, isolation, or control provides a concrete benefit.

Do not wrap every dependency automatically.

Mock or substitute implementations where appropriate, not wherever it happens to be technically possible.

## 13. Refactoring and project constraints

Existing code should inform decisions without preventing improvements.

- Preserve appropriate established conventions.
- Identify concrete problems before departing from existing architecture.
- Consider a preliminary refactor when the current structure obstructs new work.
- Keep behaviour-preserving refactoring separate from feature implementation.
- Verify existing behaviour before introducing new behaviour.
- Accept substantial refactors when their value justifies their scope and risk.
- Consider delivery constraints, maturity, regression risk, and project purpose.
- Avoid opportunistic rewrites that do not serve the authorised task.

An experimental project may benefit from wider architectural exploration.

A time-constrained production change may reasonably favour consistency and focused delivery.

Neither decision should become a universal rule.

When restructuring requires scope expansion, obtain approval rather than silently broadening the change.

## 14. Engineering consistency

Follow the language's idioms and the codebase's established conventions when appropriate.

When multiple paradigms are suitable:

- Prefer consistency with the surrounding code.
- In a new codebase without an established convention, favour cohesive module-based organisation where the language supports it naturally.
- Do not force object-oriented, functional, or procedural patterns universally.
- Use language-specific features when they improve correctness or clarity.
- Do not import architectural ceremony from another language without a concrete benefit.

A familiar pattern is not automatically the right pattern.

## Resolving trade-offs

When principles pull in different directions, prioritise:

1. Correctness and explicit requirements.
2. Understandable behaviour and failure semantics.
3. Discoverability and cohesion.
4. Simplicity and maintainability.
5. Compatibility with language and project conventions.
6. Performance, flexibility, and extensibility justified by actual constraints.

These considerations are not independent or absolute.

State the significant trade-off when a decision is not obvious. Do not manufacture architectural analysis for straightforward changes.

## Supporting references

These sources inform the general engineering principles. The explicit conventions remain Foundary's preferences, not claims that every source prescribes them.

- [Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/looking-for.html) — design quality, readability, complexity, and code health.
- [CUPID](https://cupid.dev/) — composability, idiomatic code, predictability, and domain alignment.
- [The Grug Brained Developer](https://grugbrain.dev/) — complexity, premature abstraction, and practical simplicity.
- [Martin Fowler's Refactoring Catalog](https://refactoring.com/catalog/) — behaviour-preserving changes to code structure.
- [Suckless philosophy](https://suckless.org/philosophy/) — focused responsibilities and simplicity.
- John Ousterhout, *A Philosophy of Software Design* — information hiding, module depth, and managing complexity.

Use these as background rather than additional mandatory rules. The principles above are authoritative for Foundary Craft.

