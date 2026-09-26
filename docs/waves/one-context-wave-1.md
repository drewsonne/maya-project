# One-context plan — wave 1 (the skills)

- Plan: `docs/plan/2026-09-26-one-context-per-unit.md` (ADR 0021, story #43)
- Date dispatched: 2026-09-26, four agents in parallel, one worktree each
- Date collected: 2026-09-26 — **complete**; all four packages on `main` at plugin 1.9.5
- Preflight: all nine checks passed (main green at 46fcb59; fixture
  command exit 0; no open PRs; tasks #44–#47 sub-issues of open story #43)

| package | PR | fixtures | criteria met | scope | outcome | review verdict | notes |
|---|---|---|---|---|---|---|---|
| wave-1-implement-one-context | #52 | fixture command 0; validate green | 8/8, enacting sentence quoted | clean | ok | merge, 2 advisory | version 1.9.2 |
| wave-1-plan-self-sufficient-block | #49 | fixture command 0; validate green | 6/6 | clean | ok | merge after named changes (merge order only), 1 advisory | version 1.9.3 |
| wave-1-fleet-review-fan-out | #50 | fixture command 0; validate green | 8/8 | clean | ok | merge, 3 advisory | version 1.9.4 |
| wave-1-session-skills-goal-lines | #51 | fixture command 0; validate green | 10/10 | clean | ok | merge after named changes (mark ready), 1 planning defect + 2 advisory | version 1.9.5 |

Every review ran in a fresh agent reading the diff cold, one PR per
context (the rule this wave introduces, applied to itself). Verdicts are
attached to each PR as a comment.

## Findings count

9 total: 0 fixture disagreements, 0 scope deviations, 1 planning defect,
8 advisory. None blocking. Under ADR 0017 the non-zero count queues the
wave for the Maintainer; nothing was auto-merged.

## Planning defects (route to maya-plan)

- #47 criterion 6 required `- Binds:` "directly after `- Implementation:`"
  in maya-record's template, which lacked that line; the agent added it
  (correctly, per ADR 0016) outside the letter of the criteria.
- #45: the default ADR set hard-coded in maya-plan's Inputs has no rule
  for updating it as ADRs gain `Binds:` lines.
- #46: fleet's opening "Three phases" is now one short of the four the
  new one-wave sentence names.
- Wave labels `wave-N` collide across plans (the fixtures plan also has a
  `wave-1`); package ids are unique, labels are not.

## Process findings

- **The coordinator broke the rule it was implementing.** This session
  wrote the ADR, planned, filed, dispatched and collected in one context —
  the last such walk, but a walk. With the wave-1 skills merged, the next
  story runs as separate contexts.
- **`scripts/board-status.sh` is expensive.** Each call runs three
  `gh project` queries including `item-list --limit 500`; four agents plus
  the coordinator exhausted the GraphQL budget (shared 5,000/hr) within
  the wave. Board moves for #44–#47 and PRs #49–#52 were deferred to the
  reset. Fix candidates: one item-list per wave with IDs cached, or a
  REST path. Story-worthy.
- **The agents' `gh` token lacked the `project` scope** (keyring token:
  `gist, read:org, repo`), so even without the rate limit their board
  moves would have failed. The fleet hard rule that agents move the board
  themselves assumes a scope they do not have; the coordinator should
  move the board on the agent's behalf, or the rule should say so.
- **Merging is a Maintainer action in this environment**: the harness's
  permission classifier blocked `gh pr merge` from the session. Consistent
  with ADR 0017 for non-clean PRs; a clean PR would have hit the same
  wall. Worth deciding whether auto-merge is ever expected to work here.

## How it merged

The Maintainer squash-merged #52, then #51. Because the three remaining
branches had been stacked (#51 on #50 on #49) to keep the version line
conflict-free under merge commits, the #51 squash (8d76119) carried #49
and #50 onto `main` as well, closing #45–#47 from its body. #49 and #50
were closed as superseded with an empty content diff against `main`.
Lesson: stacking only works with merge commits; under squash the top of
the stack is the whole wave. State the merge method in the plan.

## Merge order as planned

1. #52 → 1.9.2
2. #49 → 1.9.3 (resolve `plugin.json` to 1.9.3 if updating the branch)
3. #50 → 1.9.4
4. #51 → 1.9.5

Then wave 2 (#48: README and 1.10.0) dispatches from a fresh context.

## Board state

Tasks #44–#47 closed; story #43 stays open for wave 2. Board moves
(tasks and PRs #49–#52 to Done) deferred to the GraphQL reset; the
coordinator runs them.
