# 0019. The board contract: mirror-only, typed fields, full scope, reconciled at kickoff

- Status: accepted
- Date: 2026-09-20
- Implementation: #37
- Depends on: 0018

## Context

ADR 0018 made the board mirror issue state and gave the skills the
transition duty. Four questions remained open and were put to the
Maintainer: whether the board may command as well as display, what
metadata it carries, what appears on it, and how its truthfulness is
maintained across sessions.

## Decision

- **Mirror only.** The board never commands. Humans command through
  labels (`authorized`), issues and sessions; agents never read the
  board to decide what to do, only write it to show what they did.
  Information flows one way: reality → board.
- **Typed fields**, mirrored from issue metadata when an item is placed:
  **Wave** (wave-1…wave-4, from labels), **Size** (XS/S/M/L, from
  labels), **Kind** (epic/story/task/pr). Labels remain the source of
  truth; fields exist for grouping and views.
- **Everything is on the board**: all hub issues, and every open
  satellite pull request — agent waves, the Maintainer's own PRs and
  Dependabot alike — as Kind `pr` items at **In review**, moving to
  **Done** when closed. `scripts/board-status.sh` accepts an optional
  `owner/repo` and handles PRs.
- **Reconciled at kickoff.** `maya-orient` compares board state to
  actual issue and PR state at session start, corrects drift through
  the helper, and reports what it corrected. A drift it cannot explain
  is a finding, not a silent fix.
- **Two views.** **Board** (board layout, grouped by Status) is the
  state of work in flight. **Roadmap** (GitHub's roadmap layout) is
  future work, plotted on the optional **Start**/**Target** date fields.
  Those dates belong to epics and stories and are set only by the
  Maintainer; tasks never carry dates — `maya-plan`'s no-due-dates rule
  stands at the package level, and an unscheduled story simply has no
  bar yet.

## Consequences

The Maintainer sees the whole pipeline — stories, tasks, wave PRs and
dependency queues — in one place, and can trust it because every
session opens by making it true. The board stays safe to glance at and
useless to sabotage: moving a card changes nothing real. Adding
Dependabot PRs means the board also shows the maintenance queue, at
the cost of some noise the `Kind` filter removes.
