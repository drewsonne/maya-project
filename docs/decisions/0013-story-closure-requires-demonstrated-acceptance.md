# 0013. A story closes only on demonstrated acceptance, stated in a closing comment

- Status: accepted
- Date: 2026-09-20
- Implementation: #23

## Context

Tasks close mechanically — a merged PR fires `Closes
drewsonne/maya-project#N`. Stories had no closure rule: the first story
closed on judgement, undocumented. That leaves the middle tier of the
ADR 0009 hierarchy less auditable than the bottom one, and lets "all its
tasks are closed" quietly stand in for "the outcome is real", which are
not the same claim.

## Decision

A story closes only when both hold: every task beneath it is closed, and
its acceptance criteria are demonstrated against `main` (or the published
artifact, once a release stage exists). Whoever closes it states the
demonstration in a closing comment — what was checked and where. An epic
closes only when its stories are closed and its PRD outcome is restated
as achieved in a closing comment by the Maintainer.

## Consequences

Closing a story costs one comment. Story state becomes trustworthy
enough for `maya-orient` and the epic rollups to report without
re-verification. A story whose criteria cannot be demonstrated stays
open — which is a finding about the criteria, routed to `maya-record`,
not a reason to close it anyway.
