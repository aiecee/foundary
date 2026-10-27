---
name: spike
description: Runs a timeboxed, throwaway experiment to answer one technical question that reading code cannot settle, such as feasibility, library or API behaviour, integration fit, or performance. Produces a Spike Report; the spike code is never merged. Use when a design or plan decision is blocked by an unknown that only running code can resolve.
compatibility: 'Requires: git and filesystem access. Writes only to an isolated scratch location or throwaway worktree/branch.'
---

# Spike

Answer one blocking question with the smallest experiment that produces evidence. Use this when the next useful step is learning by running code, not by reading it.

The output is knowledge, not code. The Spike Report should help the user decide whether to stop, ask a question, create a design strategy, or make a compact implementation plan.

## Core rules

- One question per spike, stated before any code is written.
- Define what answer would count as yes, no, and inconclusive before starting.
- Agree a timebox up front and stop when it is reached, even if the answer is partial.
- Work only in an isolated location: a scratch directory, throwaway worktree, or throwaway branch.
- Spike code is disposable. It is never merged, staged on the working branch, or reused by `plan` or `implement`.
- Prefer the thinnest experiment that answers the question; quality, tests, and structure do not matter unless they are the thing being tested.
- Prefer evidence over assumptions; separate observed results from inference.
- Read and apply ../workflow-rubric/SKILL.md when the result will feed a material decision.
- Do not produce a design strategy or implementation plan.
- Do not silently fix discovered issues.

## Use When

- A `design` option depends on whether something works at all.
- Library, SDK, or external API behaviour is undocumented, ambiguous, or contradicted by docs.
- An integration between two systems needs to be proven end to end.
- Performance, size, or limits must be measured rather than estimated.
- Two approaches are viable and the deciding fact can only be observed by running them.

## Do Not Use When

- The question can be answered by reading code, docs, history, or config -> use `investigate`.
- The approach is known to work and only needs choosing -> use `design`.
- The change is already clear enough to plan -> use `plan`.
- Broken behaviour, failing test, regression, or runtime error -> use `fix`.
- The user wants the feature built, not the question answered -> use `plan` then `implement`.

## Allowed

- Read relevant source, tests, docs, manifests, and config.
- Create, edit, and delete files inside the isolated spike location.
- Install dependencies inside the isolated spike location only, after confirming with the user.
- Run local experiments, scripts, benchmarks, and throwaway tests.
- Call external sandbox, test, or local services when the user has confirmed they are safe to use.
- Produce findings, measurements, risks, and next-step recommendations.

## Forbidden

- Do not edit, stage, commit, or format files on the user's working branch.
- Do not change shared dependencies, lockfiles, config, or CI outside the spike location.
- Do not mutate production or shared databases, caches, queues, cloud resources, tickets, docs, or PRs.
- Do not use real credentials, live keys, or production data.
- Do not merge, push, or open a PR for spike code.
- Do not extend the spike into the real feature.
- Do not run commands with unclear side effects.

If an action might mutate shared state and this cannot be confidently ruled out, do not run it.

## Workflow

1. Restate the spike question, the yes/no/inconclusive criteria, and the timebox. Ask the user to confirm when any of these are unclear.
2. Check that the question cannot be answered by reading; if it can, recommend `investigate` and stop.
3. Choose and confirm the isolated location before writing code.
4. Build the thinnest experiment that exercises the question.
5. Run it and record results as observed, inferred, unknown, or speculative.
6. Stop when the question is answered, the timebox is reached, or a stop condition is hit.
7. Write the Spike Report.
8. Ask whether to delete or keep the spike location; never fold it into the working branch.

## Evidence quality

- Record exact versions, commands, inputs, and environment where they affect the result.
- Quote short output excerpts or measurements instead of dumping raw logs.
- State confidence and what the experiment did not exercise.
- Surface contradictions with docs or expectations instead of smoothing them over.

## Stop immediately when

- the question changes or splits into several questions
- the timebox is reached
- the experiment would need shared, production, or credentialed access
- the work starts turning into the real feature
- an action would touch the working branch or shared state
- additional experimentation has diminishing returns

## Spike Boundary

Include this section when it helps bound the work:

```md
## Spike Boundary
- Question:
- Yes / no / inconclusive criteria:
- Timebox:
- Isolated location:
- Systems or services touched:
- Runtime assumptions:
- Not exercised:
```

## Persistence

Chat output is the default. Ask before saving the Spike Report, and use the location the user requests.

## Output format

Use this structure:

```md
# Spike: <question>

## Answer
- Result: yes | no | inconclusive
- Confidence:

## What Was Tried

## Evidence

## Limits / Not Exercised

## Risks / Unknowns

## Implications for Design or Plan

## Next Step

## Spike Disposal
- Location:
- Status: deleted | kept for reference (not for reuse)
```

Recommended next steps should be one of: no action needed, ask user, spike further, investigate further, create design strategy, create implementation plan, or verify manually.

Keep the report concise by removing repetition and irrelevant detail, not by omitting evidence needed to make a material decision.
