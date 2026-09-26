---
name: maya-plan
description: Decompose the Maya dates product spec into dependency-ordered work packages sized for independent parallel agent execution, then write them to docs/plan/ and GitHub Issues. Use after specs or ADRs settle and before dispatching any agents.
---

# Plan work packages

A work package is one agent, one branch, one pull request, one non-overlapping file scope. Planning output that cannot be executed in parallel is not a plan, it is a list.

Replaces any general issue-triage approach. The Maintainer already writes well-structured issues with acceptance criteria; the job here is decomposition and conflict avoidance, not issue hygiene.

## Inputs

Read before planning: `docs/product/prd.md`; `docs/decisions/` — the ADRs whose `Binds:` line names the level, layer or skill the story touches, not every accepted ADR (until an ADR carries a `Binds:` line, the default set is 0001, 0009, 0011, 0014, 0017, 0018, 0020 and 0021 plus any ADR whose title names the layer or repository the story touches); `docs/plan/` (existing waves); and the open issues on the target repo. Plan only what the spec or an ADR justifies.

## Package shape

Every package carries all of these. A package missing any field is not ready to dispatch. In particular, a package missing `story:`, `outcome:` or `binds:` is not ready to dispatch: those three are what make the block sufficient on its own (ADR 0021), and an agent that must climb the tree to learn why it is working is an agent that will guess.

```
id:           wave-N-short-slug
goal:         one sentence, an outcome
story:        hub issue number of the story this package serves (#N)
outcome:      the PRD section it serves and one sentence saying how
binds:        - ADR NNNN "the clause, quoted"
              - up to three clauses, each an ADR number plus the quoted clause
layer:        1 representation | 2 operations | 3 parsing | 4 presentation
scope:        explicit path globs the agent may modify
contract:     what it must NOT change (exported signatures, fixture files, other layers)
criteria:     - machine-checkable assertion
              - machine-checkable assertion
fixtures:     which fixture files must pass, and the command that runs them
depends_on:   [package ids]
size:         XS | S | M | L
```

An acceptance criterion a human has to eyeball is not a criterion. "Long Count parsing is more robust" fails. "`parse('9.16.4.10.8')` returns a LongCount; `parse('9.16.4.10')` throws naming the missing position" passes.

## Waves

Group packages into waves. Within a wave, **no two packages may share a path glob** — check this explicitly and state that you checked. Across waves, `depends_on` must point only backwards.

At most six packages per wave. An `L` package is a planning failure: split it before the plan is finished.

## Interface-first rule

If package B needs a type or function signature that package A introduces, A lands that signature in an earlier wave — a stub with the right shape is enough. Two agents must never negotiate an interface between themselves; they will produce two incompatible ones and both will pass their own tests.

## Two refusals

**Calendar arithmetic without fixtures.** If a package would change Long Count, Calendar Round, day-number or correlation-constant logic and no fixture covers that behaviour, do not plan it. Emit a fixture package into an earlier wave and make the change depend on it. Say plainly that you did this.

**Cross-layer imports.** Per ADR 0001, dependencies point inward only: presentation → parsing → operations → representation. A package that would introduce an import from a lower layer to a higher one is rejected, not planned around.

## Hierarchy and horizon (ADR 0009)

Packages are **tasks** in a three-level hierarchy that lives entirely on the
hub repo: **epic** (label `epic`, type Feature, traces to a PRD outcome) →
**story** (label `story`, type Feature, sub-issue of its epic, outcome-phrased
with machine-checkable criteria, never decomposed in its own body) → **task**
(type Task, sub-issue of its story, the package block verbatim).

Decompose just-in-time: at most the wave in flight **plus one planned wave**
may hold open task issues. Refuse to decompose further ahead, however much the
spec would support — regenerating decomposition later is cheap, and a task
inventory goes stale. A queued wave is re-validated against current `main`
before dispatch; a stale package is re-planned, not dispatched.

If a package's story or epic does not exist yet, create it first and attach
the task beneath it. A task without a story is not ready to file.

Stories are the backlog and are unbounded (ADR 0011): capture future work as
a story at any time, without waiting for a wave — only tasks are held to the
horizon. A story that needs breaking into more than one coherent outcome is
promoted in place: relabel the same issue `epic`, keep its number, and write
its parts as new stories beneath it. Tasks always hang off stories, never
directly off an epic.

## Red-team before filing (ADR 0020)

Before any issue is created, hand the drafted packages to a fresh
adversarial agent with one brief: satisfy each package's criteria while
violating its goal. Every exploit it finds — a criterion met by letter
not spirit, an ambiguity it could resolve in its own favour, a scope
gap between packages — is fixed in the criteria before filing.

Then the red-team attempts one package from its block alone, in a fresh
context that is given the block and nothing else — no PRD, no ADR, no
plan file, no issue tree. It must report anything it had to look up
outside the block as a gap. Every gap is closed in the block before
filing: the missing fact is written into the block, not linked from it,
and a block with an open gap is not filed. Report what the red-team
found and what changed.

## Output

- `docs/plan/<slug>.md` — the waves, packages in full, and the conflict check.
- One GitHub issue per package **on the hub repo**, type Task, created as a sub-issue of its story (ADR 0009), body containing the package block verbatim, labelled `wave-N`, `layer-N` and its size.
- Every issue created lands on the "Maya Dates" board at **Backlog** via `scripts/board-status.sh <n> Backlog` (ADR 0018) — this is part of creating the issue, not a follow-up. Requires the `project` scope; if absent, create the issues anyway and say to run `gh auth refresh -s project`.

## Rules

- Never invent work. Every package traces to a spec requirement or an ADR.
- Search existing issues before creating any (`gh issue list --search`). Update a match rather than opening a duplicate.
- No due dates, no milestones, no estimates in hours. Sizes are for sequencing and for matching a package to available energy, nothing else.
- State the total package count and wave count up front. If the plan exceeds about fifteen packages, stop and propose a narrower first slice instead.

## The planning context ends here

Filing the issues is the last act of this context (ADR 0021: the context
that plans never dispatches). After filing, report the package count and
the wave count, and end. Do not dispatch, and do not implement a package
yourself — not even a small one to get the wave started. Dispatch is a
separate `maya-fleet` invocation in a fresh context, working from the
filed issues alone; a planning context that finds itself about to start
one stops and reports it, as an agent stops on an ambiguous criterion.
