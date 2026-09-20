# 0016. Every accepted ADR links its implementing story, and CI enforces it

- Status: accepted
- Date: 2026-09-20
- Implementation: #31

## Context

The six decisions accepted earlier today (0009–0013, 0015) were
implemented directly on `main`, outside the epic → story → task flow the
project had just built — bootstrap work, done at the Maintainer's
direction, but invisible to the tracker until backfilled (#19–#30). The
model had no rule connecting a decision to the work that realises it, so
nothing noticed the gap.

## Decision

Every ADR carries an `Implementation:` line in its header block: the
implementing story's number, or `none — in force on acceptance` for pure
policy that requires no work. `maya-record` files that story (under the
relevant epic) in the same sitting as the ADR — recording a decision and
tracking its execution are one act, not two. Work implementing a
decision does not begin until its story and task exist, bootstrap
included. CI fails any accepted ADR missing the line.

## Consequences

The tracker and the decision log can no longer drift apart silently: an
accepted ADR either points at its story or states that none is needed,
and the claim is machine-checked. Recording a decision costs one issue
more than before. Proposed ADRs may defer the line until acceptance —
acceptance is when the commitment to execute becomes real.
