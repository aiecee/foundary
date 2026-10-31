---
name: standards
description: Canonical, source-backed Foundary Craft code-quality standards reference. Use when a Foundary Craft skill needs the rule, rationale, decision criteria, exceptions, and sources behind a code-quality judgement, or when the user asks what Foundary Craft considers good structure.
---

# Foundary Craft Standards

This is the single canonical reference for Foundary Craft code-quality
standards. Craft skills apply these standards; they do not restate or
override them.

Foundary Craft defines language- and paradigm-agnostic standards for code
quality. It is not a development methodology: it has no phases, does not
prescribe a code layout, and does not require code examples.

## Governing principle

Prefer the simplest cohesive implementation that clearly expresses the
required behaviour.

- Simplicity is not measured by the number of lines, functions, classes, or
  files. Fewer pieces that are hard to understand are not simpler; more pieces
  that each read clearly are not more complex.
- Every structural element should earn its place by making the code easier to
  understand, change, or keep correct today.
- Respect project conventions unless they cause a concrete design or
  maintainability problem. Name that problem when departing from them.

## Quality benchmark

The benchmark is the Google Engineering Practices review standard [G]: a
change is acceptable when it improves the overall health of the code, even if
it is not perfect. Its design and complexity questions frame every standard
here:

- Does the code belong where it is, and does it integrate well with the rest
  of the system?
- Can a reader understand it quickly?
- Is it over-engineered: more generic or more layered than the current
  requirement needs?

## Sources

Sources are used selectively. They inform the standards; they do not each
carry equal prescriptive weight. Where they disagree, the explicit standard
decides.

| Key | Source | What Foundary Craft takes from it |
|-----|--------|------------------------------------|
| G | [Google Engineering Practices — What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html) | Quality benchmark: design fit, complexity, over-engineering, code health over perfection |
| C | [CUPID — Dan North](https://cupid.dev/) | Domain-based structure, idiomatic code, composability, predictability |
| R | [The Grug Brained Developer](https://grugbrain.dev/) | Complexity as the main risk, late factoring once natural cut points appear, scepticism of early abstraction |
| O | John Ousterhout, *A Philosophy of Software Design* | Deep modules, information hiding, pass-through methods and layers, pulling complexity downwards, deciding together versus apart |
| F | [Martin Fowler — Refactoring Catalog](https://refactoring.com/catalog/) | Named, reversible moves in both directions (extract/inline, move, split/combine, hide/remove delegate) |
| B | [Kent Beck's rules of simple design (Fowler)](https://martinfowler.com/bliki/BeckDesignRules.html) | Reveals intention, no duplication of knowledge, fewest elements, in priority order |

## How each standard is written

Every standard has a stable ID and the same fields:

- **Rule:** what to do.
- **Why:** the problem it prevents.
- **Decide by:** the questions that settle a concrete case.
- **Exceptions and trade-offs:** when the rule yields, and what is accepted.
- **Sources:** the keys above that support it.

No standard sets numeric thresholds (lines, parameters, file or module size,
nesting depth). Size is a prompt to look, never a verdict.

## Structural standards

Structural standards decide where behaviour and responsibility belong: within
functions, modules, data models, and dependency boundaries.

### ST1 Cohesion and locality

- **Rule:** Keep related behaviour together. Separate it only when independent
  change, a dependency boundary, or actual complexity makes the code easier to
  understand or maintain.
- **Why:** Code that changes together but lives apart forces readers to
  reassemble one idea from many places, and changes miss a piece. Arbitrary
  splitting by file, module, or technical layer adds navigation and interfaces
  without reducing what a reader must hold in mind.
- **Decide by:**
  - Do these parts change for the same reason and at the same time? Keep them
    together.
  - Can one be understood without reading the other? If not, splitting them
    only hides the dependency.
  - Is there a real seam: a different owner, change rate, runtime, or external
    dependency? That justifies a separation.
  - Does the split follow the domain, or only a technical category such as
    "helpers", "utils", "types", or "services"? Prefer the domain.
  - Is a unit hard to follow because it mixes distinct concerns, not merely
    because it is long? Then separate the concerns.
- **Exceptions and trade-offs:** Technical layering is justified when the
  layers isolate a real boundary such as I/O, a framework, or a persistence
  mechanism, or when the project's established architecture requires it.
  Keeping code together accepts larger units in exchange for fewer
  cross-references.
- **Sources:** G, C, O, R, F.

### ST2 Justified abstraction

- **Rule:** Every abstraction must solve an existing problem. Introduce an
  interface, wrapper, factory, or generalisation only when it establishes a
  meaningful boundary or hides real complexity, not to prepare for imagined
  use cases.
- **Why:** An abstraction is a cost every reader pays. A shallow abstraction,
  whose interface is about as complex as what it hides, adds indirection
  without reducing knowledge needed. Speculative generality usually guesses
  the future wrong and makes the actual future change harder.
- **Decide by:**
  - What concrete problem does it solve today: hiding a complex mechanism,
    isolating an external system, or supporting variations that exist now?
  - Is it deep: does its interface stay much simpler than its implementation?
  - Would a caller lose anything if it were inlined?
  - Is the second variation real and present, or anticipated?
- **Exceptions and trade-offs:** A boundary to an external, slow, or
  nondeterministic system is often justified with one implementation because
  the boundary itself is the value. Somewhat general-purpose interfaces are
  preferred when they are no harder to use than special-purpose ones. When in
  doubt, wait: extracting later is cheaper than removing a wrong abstraction.
- **Sources:** G, O, R, B, F.

### ST3 Sharing and duplication

- **Rule:** Extract common behaviour only when its meaning and contract are
  strictly the same. Two similar cases should remain independent rather than
  acquire flags or configuration solely to force reuse.
- **Why:** The duplication worth removing is duplicated knowledge: one rule,
  stated twice, that must change together. Code that merely looks alike but
  represents different decisions will diverge; sharing it couples unrelated
  changes and grows flags, modes, and special cases.
- **Decide by:**
  - If one copy changed, must the other change for the same reason? Then it
    is the same knowledge; share it.
  - Can the shared unit be named for one meaning without "and", "or", or a
    mode parameter?
  - Would reuse require a boolean or configuration parameter that selects
    behaviour? Prefer separate units.
  - Has the shared behaviour stabilised, or is the pattern still emerging?
- **Exceptions and trade-offs:** Duplicated business rules, validation, or
  invariants should usually be shared even when only two copies exist, because
  divergence is a defect. Keeping look-alike code independent accepts some
  repetition in exchange for independent change.
- **Sources:** B, R, F, O.

### ST4 Data modelling

- **Rule:** Express genuine constraints in suitable representations. Avoid
  primitive obsession where it causes real ambiguity, but equally avoid
  decorative wrapper types, elaborate hierarchies, and speculative models.
- **Why:** A representation that matches the domain makes invalid states hard
  to construct and makes intent visible at every use. A representation that
  adds ceremony without a constraint only adds conversion and naming
  overhead.
- **Decide by:**
  - Is there a real invariant, unit, format, or identity a bare primitive
    leaves implicit, and has that caused or plausibly will cause confusion or
    defects?
  - Are values that always travel together, and mean something together,
    passed separately?
  - Does a hierarchy or variant represent cases that exist and behave
    differently, or only categories that might one day differ?
  - Does the model mirror the domain's language, or a storage or transport
    shape that leaked inward?
- **Exceptions and trade-offs:** A primitive is fine when its meaning is
  obvious from context and unconstrained. Language or project idioms (plain
  records, tagged unions, structs, maps) take precedence over a particular
  modelling style. Stronger types accept construction and conversion cost in
  exchange for fewer invalid states.
- **Sources:** C, O, F, G.

### ST5 Dependencies and encapsulation

- **Rule:** Make dependencies explicit and keep boundaries focused. Hide
  complexity where doing so is useful; avoid pass-through layers and
  ceremonial dependency injection.
- **Why:** Hidden dependencies (globals, ambient state, implicit ordering)
  make behaviour surprising and hard to change safely. Boundaries that leak
  internal decisions spread knowledge across modules. Layers that only forward
  calls add a place to read without removing anything to understand.
- **Decide by:**
  - Can a reader see from a unit's interface what it needs and what it
    affects?
  - Does knowledge of a decision (format, protocol, policy) live in one place,
    or does it leak through the interface to callers?
  - Does each layer offer a different abstraction from the one below it, or
    does it pass calls through unchanged?
  - Is injection solving a present need such as substituting an external
    system, or is it wiring for its own sake?
- **Exceptions and trade-offs:** Frameworks and runtimes legitimately supply
  some dependencies implicitly; follow their idioms. Passing a dependency
  directly is preferred over a container unless the project already relies on
  one. Explicitness accepts longer signatures in exchange for predictable
  behaviour.
- **Sources:** O, C, F, G.

### ST6 Project fit

- **Rule:** Respect the language's idioms, the programming paradigm, and the
  existing project architecture. Do not mandate object orientation, a
  particular directory structure, or a particular module size.
- **Why:** Consistency with surroundings lowers the cost of reading and
  changing code. Importing an alien style creates two ways of doing the same
  thing.
- **Decide by:**
  - How does this codebase already express similar behaviour?
  - Is the idiomatic construct for this language and paradigm being used?
  - Does the existing convention cause a concrete design or maintainability
    problem here? If not, follow it.
- **Exceptions and trade-offs:** Depart from a convention only when it causes
  a concrete problem, and name that problem. Keep the departure local; do not
  convert the surrounding code as a side effect.
- **Sources:** C, G.

### Resolving structural tensions

Sources pull in different directions. Resolve conflicts through the standards,
not by averaging the sources.

- **No duplication versus independence (B versus R):** ST3 decides. Remove
  duplicated knowledge; keep look-alike code with different meaning apart.
- **Deep modules versus small units (O versus F):** ST1 and ST2 decide. Extract when it separates a distinct
  concern or names a real idea; inline when a unit only forwards or splits one
  idea across places. The refactoring catalogue offers both directions; choose
  by effect on understanding, not by size.
- **General-purpose versus speculative (O versus R and G):** ST2 decides.
  Generalise an interface when it is no harder to use and serves present
  callers; do not add parameters, hooks, or variants for imagined ones.
- **Rich models versus plain data (F and O versus C and idiom):** ST4 and ST6
  decide. Model real constraints, in the form the language and project
  already use.
- **Fewest elements versus intention (B):** Intention wins. Remove an element
  only when doing so does not obscure what the code means.

## Extending this reference

Add further standard families, such as expression standards from
`expression`, as new top-level sections in this file with their own ID
prefix, using the same fields. Add new sources to the Sources table rather
than citing them inline only. If a new standard tensions with an existing one,
add the resolution to that family's tensions list instead of duplicating or
softening the existing rule. Skills reference standards by ID and must not
copy their text.
