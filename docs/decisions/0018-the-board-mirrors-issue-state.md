# 0018. The project board mirrors issue state, moved by the skills as work moves

- Status: accepted
- Date: 2026-09-20
- Implementation: #35

## Context

The "Maya Dates" project board (Projects v2, `drewsonne` project 2 — a
dedicated project created at the Maintainer's instruction, distinct from
the legacy "Refactor" board) is
where the Maintainer watches work move — it is the pipeline's visible
state machine, and with autonomy between the guard gates (ADR 0017) it
is also how a human audits what agents did without reading transcripts.
Issues were being created and closed via the API without touching the
board, so the board silently diverged from reality. State management
this central cannot be a courtesy step someone remembers.

## Decision

Every hub issue is on the board, and status transitions are part of the
work itself, performed by whichever skill or agent causes the state
change, via the versioned helper `scripts/board-status.sh <issue>
<status>` (it resolves all board IDs at runtime and adds missing items).

Status semantics:

- **Backlog** — exists; not in the active horizon. Set at creation by
  `maya-plan` / `maya-record` / whoever files the issue.
- **Ready** — a task of an authorized story whose wave has passed
  preflight. Set by `maya-fleet` preflight.
- **In progress** — an agent is working it. Set by `maya-fleet` at
  dispatch (stories move here with their first task).
- **In review** — its draft PR is open. Set by the dispatched agent
  immediately after `gh pr create`.
- **Done** — the issue is closed. Set at close (fleet collect, story
  closure, or the board's built-in closed→Done automation).

The Maintainer enables the board's built-in auto-add and closed→Done
workflows in the project settings (UI-only) as a safety net; the skills
do not rely on them.

## Consequences

The board answers "what is happening right now" without asking an
agent. A missing transition is a defect, reviewable like any other
(wave reports note board state). The helper couples the pipeline to one
board — if a second board ever exists, the script grows a parameter by
a superseding decision. API-created issues cost one extra command.
