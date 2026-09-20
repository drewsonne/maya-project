---
name: maya-fleet
description: Gate, dispatch and collect a wave of parallel agents against a maya-plan wave. Use only when a plan exists and the fixture suite passes; it refuses to run otherwise.
---

# Dispatch a wave

Three phases: preflight, dispatch, collect. Preflight is not advisory — if it fails, report which check failed and stop. Do not offer to proceed anyway.

The reason the gate is strict: eleven agent-authored pull requests once sat unmerged on this project for eight months. Agent capacity was never the constraint. Review throughput is. A wave is only worth dispatching if its output can be trusted without reading every line, and that is what the fixture suite buys.

## Phase 1 — preflight

Every check must pass.

1. `gh auth status` succeeds.
2. The named wave exists in `docs/plan/` and every package in it carries scope, contract, criteria and fixtures.
3. No two packages in the wave share a path glob.
4. Every `depends_on` points at a package in an earlier, completed wave.
5. `main` is green: the full suite passes on a clean checkout.
6. The fixture suite exists, covers every behaviour the wave touches, and passes.
7. Open pull requests on the target repo are either resolved or explicitly deferred with a note in the plan. A stale backlog means every agent branch conflicts.
8. Every package's task issue is a sub-issue of an open story on the hub (ADR 0009). An orphan task is a planning defect — route it back to `maya-plan`.
9. If the wave was planned before this session, re-validate each package against current `main` (scope paths still exist, contract still true, fixtures still cover it). A stale package is re-planned, not dispatched.

Report the checks as a pass/fail list. On any failure, name the failed check and the smallest action that clears it, then stop.

On full pass: move the wave's task issues to **Ready** on the board (`scripts/board-status.sh <n> Ready`, ADR 0018).

## Phase 2 — dispatch

This is what the Workflow tool is for: one agent per package, the wave in parallel. Dispatch requires an active G2 authorization (ADR 0017): the wave's story carries the `authorized` label, applied by the Maintainer. The label covers every wave of that story, sequentially; its absence means stop and ask. Never infer authorization from a different story or an earlier session.

Each agent receives only: its package block, its path scope, the command that runs the fixtures, and the instruction to open a draft pull request and stop.

At dispatch, move each package's task — and the story, with its first task — to **In progress** on the board (ADR 0018).

One wave at a time. Never dispatch the next wave from inside a run.

## Hard rules for agents

Put these in every agent prompt, verbatim:

- Modify only files matching your scope. A change outside it fails the package.
- **Never modify a fixture file, a spec file, or an expected value to make a test pass.** If a fixture disagrees with your implementation, the fixture wins and your package is blocked — report it, do not resolve it. On a calendar tool an agent that edits an expected date to get green has produced something worse than nothing.
- Do not change anything listed in your package's contract.
- Open a draft pull request. Never merge, never push to main.
- If your acceptance criteria are ambiguous, stop and report the ambiguity. Do not interpret.
- Reference your task in the PR description with the full cross-repo form (`Closes drewsonne/maya-project#N`). On a satellite repo a bare `Closes #N` closes nothing (ADR 0009).
- Immediately after opening your draft PR, move your task to In review and add the PR itself to the board: run the hub repo's `scripts/board-status.sh <your task number> "In review"` and `scripts/board-status.sh <your PR number> "In review" <owner/repo of your PR>` (ADR 0018/0019).

## Phase 3 — collect

One table, not one report per package:

| package | PR | fixtures | criteria met | notes |
|---|---|---|---|---|

For each: run the fixture suite against the branch, check each acceptance criterion, and diff the changed paths against the declared scope. Flag any package that touched a fixture file — treat it as failed regardless of whether tests pass.

If more than a third of the wave fails, stop. Do not dispatch the next wave and do not retry in place; the plan was wrong, so return to `maya-plan`.

Run the wave gap analysis (ADR 0020): a fresh completeness critic asks what the wave did **not** cover — whether the packages, all green, actually add up to the story's outcome, and which cases fell between scopes. Its findings are advisory, go in the wave report, and seed the next wave's planning.

Board state is part of collection (ADR 0018): merged-and-closed tasks move to **Done**, a closed story moves to **Done**, and any package still open stays at In review — the wave report notes board state. Then commit the collect table to `docs/waves/<wave-id>.md` on the hub before calling the wave collected (ADR 0012) — wave id, date, one row per package, review verdicts, findings count. A wave without a report is not complete. Hand-executed waves get the same report.

Merging (ADR 0017): a PR whose `maya-review` verdict is **merge** with zero findings, full suite green, scope clean and no fixture edits is merged autonomously under the story's authorization. Any weaker result — findings, an unverifiable criterion, a scope deviation — queues for the Maintainer with the verdict attached; never merge it, and never soften a verdict to make it mergeable. Never mark a wave complete while a pull request is open. Then close a story only when every task beneath it is closed **and** its acceptance is demonstrated against `main`, stating the demonstration in a closing comment (ADR 0013). A story whose criteria cannot be demonstrated stays open — that is a finding for `maya-record`. Ship actions — release-PR merges, deploys, plugin releases — are the Maintainer's (G3), always.

## Rules

- One wave per invocation.
- Never widen a package's scope to unblock an agent mid-run. Stop the run and re-plan.
- Report what happened, including the boring outcome. "Four of six passed, two blocked on a fixture disagreement" is the useful result, and the fixture disagreements are findings worth recording with `maya-record`.
