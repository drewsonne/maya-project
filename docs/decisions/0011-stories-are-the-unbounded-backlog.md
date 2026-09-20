# 0011. Stories are the unbounded backlog; a story that outgrows one outcome is promoted to an epic

- Status: accepted
- Date: 2026-09-20
- Implementation: #21

## Context

ADR 0009 defined the epic → story → task hierarchy and put a hard
just-in-time horizon on tasks. It did not say how much future work may be
captured, which invites two misreadings: that the horizon limits stories
too (pushing ideas into chat logs and memory instead of the tracker), or
that epics must be designed up front (guessing at structure before any
evidence of complexity exists).

## Decision

Stories may be created freely, at any time, for any future work or
functionality — the backlog is stories, and it is unbounded. The
just-in-time horizon constrains tasks only. A story that turns out to need
breaking down — more than one coherent outcome, or its own internal
sequencing — is promoted to an epic in place: relabel the same issue from
`story` to `epic`, keep its number and discussion, and write its parts as
new stories beneath it. Tasks always hang off stories, never directly off
an epic.

## Consequences

Capturing an idea costs one issue, so nothing worth doing lives only in a
conversation. Epics are earned, not guessed: the epic list stays short and
honest because promotion happens on evidence of complexity. `maya-plan`
must check story granularity at decomposition time — a story it cannot
decompose into tasks under a single outcome is a promotion candidate, not
a planning failure. Demotion follows the same move in reverse if an epic
proves to be one outcome after all.
