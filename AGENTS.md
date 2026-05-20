# Purpose
This file sets default operating rules only. Repo-specific instructions belong in repo-level `AGENTS.md` files.

# Default Working Behaviour
- Do not jump straight to implementation by default.
- Understand the task first.
- Inspect only relevant context.
- Prefer the smallest safe next step.
- Work in phases: understand, plan, implement, verify.

# Scope Control
- Stay inside the requested task.
- Do not fix unrelated issues.
- Do not perform opportunistic refactors.
- Do not silently widen scope.
- Do not introduce speculative abstractions unless required.
- Report broader follow-up work separately instead of including it implicitly.

# Assumptions and ambiguity
- Prefer clarifying questions over broad assumptions.
- Ask before implementation when ambiguity is high-impact.
- Stop and ask when requirements are ambiguous.
- Stop and ask when multiple architectural approaches are viable.
- Stop and ask when naming or structure is unclear.
- Stop and ask when behavior choices would materially change implementation.
- Stop and ask when the task may widen scope.
- Stop and ask before destructive, expensive, or hard-to-reverse changes.
- Make only small local assumptions when they are low risk, reversible, and consistent with existing patterns.
- When assumptions are made, state them explicitly and keep them minimal.

# Token and context discipline
- Minimize context usage.
- Use only the minimum necessary context.
- Prefer targeted reads over broad repository scans.
- Avoid broad repo scans unless targeted search did not resolve the question.
- Prefer search-first workflows (for example `rg`) before opening files.
- Do not paste large command outputs into the conversation.
- Summarize large findings instead of dumping raw output.
- Use bounded inspection for noisy output, for example:
  - `tail -n 100 <file>`
  - `head -n 100 <file>`
  - `sed -n '1,160p' <file>`
  - `git diff --stat`
  - `git diff -- <path>`
- For long-running or noisy commands, redirect output to a temp log and inspect only relevant sections.

```bash
<test-command> > /tmp/test.log 2>&1
tail -n 120 /tmp/test.log
```

# Command-running discipline
- Prefer narrow checks over expensive global checks.
- Prefer package-level or task-level verification when possible.
- Use existing scripts instead of inventing commands.
- Avoid destructive commands unless explicitly requested.
- Do not rerun expensive checks repeatedly after small edits.
- Recommend broader validation commands to the user when appropriate instead of always running them automatically.
- Reserve broad validation for:
  1. Explicit user request.
  2. Finalization.
  3. High-risk changes.
  4. Insufficient localized verification.

# File editing discipline
- Make small, focused edits.
- Preserve existing style where possible.
- Avoid unrelated formatting changes.
- Avoid moving files unless required by the task.
- Avoid rewriting working code without a clear reason.

# Planning discipline
- Create a short, concrete plan before non-trivial work.
- Keep plans testable and executable.
- Update plans when implementation reality differs from assumptions.

# Verification discipline
- Use minimal meaningful verification during implementation.
- Run the narrowest useful checks by default.
- Report verification clearly, including what changed, checks run, outcomes, and known blockers or gaps.

# Failure handling
- Do not blindly retry failing commands.
- Inspect the smallest useful portion of output first.
- Explain likely causes and the next action.
- Stop and report when key assumptions are invalidated.

# Repo-specific boundary
Repo-level `AGENTS.md` files should define repository-specific details, including:
- Commands and scripts.
- Architecture and project structure.
- Package manager and dependency conventions.
- Test strategy and validation depth.
- Deployment and environment rules.
- Domain-specific constraints.

Keep this global file intentionally portable.
