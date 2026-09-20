# 0017. The pipeline runs autonomously between three human guard gates

- Status: accepted
- Date: 2026-09-20
- Implementation: #33

## Context

The Maintainer sat at seven touchpoints: spec rounds, ADR acceptance,
every fleet dispatch, every PR merge, epic closure, story closure and
every Dependabot PR. The pipeline was built so agent output can be
trusted without reading every line — unfakeable fixtures, mechanical
review, CI gates — yet the touchpoints treated every action as equally
in need of a human. A guard gate belongs where a mistake is
irreversible, externally visible, or a value judgment; everywhere
mechanically checkable, a gate is friction that caps throughput at the
Maintainer's attention. Merge and ship are separable — release-please
means merging work only queues a release PR, so the external boundary
has its own gate regardless of who merges code.

## Decision

Three guard gates, human by definition:

- **G1 — Decide.** Spec rounds, ADR acceptance, epic closure. The
  Maintainer is the source of product truth.
- **G2 — Authorize.** Autonomous work happens only on a story carrying
  the `authorized` label, applied by the Maintainer. Authorization
  covers planning the story and dispatching its waves sequentially
  (one at a time, preflight-gated) until the story is done or blocked.
  Removing the label revokes it.
- **G3 — Ship.** Anything crossing the repo boundary — release-PR
  merges, deploys, plugin releases — is the Maintainer's until the
  release ADR (story #16) says otherwise.

Between the gates, autonomous: wave dispatch within an authorized
story; merging a PR whose review verdict is **merge** with zero
findings, full suite green, scope clean and no fixture edits — any
weaker result queues for the Maintainer with the verdict attached;
story closure with a demonstration comment; wave reports; Dependabot
merges, majors included, when the target repo's full suite runs and
passes — a repo whose suite is absent, skipped or red queues instead.

Trigger model: autonomy executes during sessions, kicked off by the
Maintainer ("continue authorized work"); no scheduled or background
execution. Escalation is always to the Maintainer, never around them.

## Consequences

The Maintainer reviews by exception: only PRs with findings, blocked
packages and gate decisions arrive. Review throughput stops being the
ceiling on clean work. The `authorized` label is the audit trail of
what was permitted. Dependabot majors merging on green is knowingly
weaker in thin-coverage repos (the calculator's 333-line suite); wave
telemetry (ADR 0012) is the review mechanism if that proves wrong.
maya-review's "never merge" softens to "merge only the clean case
under an active authorization"; maya-fleet's per-run go-ahead is
replaced by the label check in preflight.
