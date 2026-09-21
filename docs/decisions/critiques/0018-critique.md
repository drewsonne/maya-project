# Critique of ADR 0018

- Target: 0018-the-board-mirrors-issue-state.md
- Date: 2026-09-21
- Verdict: **stands**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision distributes maintenance of a single shared invariant — 'the board matches reality' — across every skill and every dispatched agent, when the failure it responds to (issues created and closed via the API without touching the board) is a textbook derived-state problem whose standard cure is one writer, not N. Every agent now carries board plumbing: remember to call board-status.sh after gh pr create, have a token with Projects v2 GraphQL scope, handle the call flaking mid-wave. The ADR itself concedes the model leaks by declaring 'a missing transition is a defect' — i.e. it predicts its own continuous defect stream — and ADR 0019, filed the same day, had to bolt on kickoff reconciliation, which is an admission that distributed writers drift. The sharper version of the attack: 0019 declares 'labels remain the source of truth; fields exist for grouping and views' for Wave/Size/Kind. Applying that same principle to Status — skills write labels (which they already do: authorized, wave labels), one GitHub Actions workflow triggered on issue/PR/label events is the sole board writer — would give near-real-time mirroring with no per-agent duty and no drift class at all. The Context never engages this; it jumps straight from 'courtesy step someone remembers' to 'every skill does it'.

## Failure scenario

Mid-wave, a dispatched agent opens its draft PR but the board-status.sh call is skipped or fails (missing project scope on the agent's token, GraphQL rate limit, or plain omission by a fresh agent that didn't internalize the rule). The Maintainer glances at the board during the autonomous run — the exact audit use-case 0018 exists for, 'how a human audits what agents did without reading transcripts' — and sees the task still In progress with no review pending, so the one window in which the board must be trustworthy is the window in which it lies. The drift is caught, but only at the next session's maya-orient reconciliation, after the moment it mattered has passed. Repeated incidents teach the Maintainer to distrust the glance and go read transcripts anyway, which is the board failing at its stated purpose.

## Who bears the cost

The Maintainer's trust in the board during live autonomous runs — the single scenario the ADR was written for — plus every skill and agent prompt, which now carries board-transition boilerplate and a runtime dependency on one repo-local script and its token scopes; wave reports absorb the resulting 'board state' defect noise.

## Overlooked alternative

A label-driven single-writer sync: pipeline states that GitHub does not natively represent (Ready = preflight passed, In progress = dispatched) become labels set by maya-fleet — consistent with 0019's own labels-are-truth rule — and one event-triggered Actions workflow is the only thing that ever writes the board, computing status from labels, issue open/closed, and PR state. This removes the entire missing-transition defect class rather than detecting instances of it.

## Verdict reasoning

My best attack loses on this project's actual constraints. The single-writer sync is more infrastructure for a solo maintainer to build and debug (an Actions workflow speaking Projects v2 GraphQL, plus new label conventions) than a shell helper agents invoke, and it still needs the skills to emit signals — it relocates the duty rather than removing it. Meanwhile the decision as made is deliberately belt-and-braces: built-in auto-add and closed→Done automations backstop the most consequential transition (Done), and 0019's kickoff reconciliation bounds any drift to at most one session, with unexplained drift escalated as a finding. Since autonomy only runs in Maintainer-kicked-off sessions, worst-case staleness is short-lived and self-healing. The distributed-writer weakness is real but contained; the decision survives.
