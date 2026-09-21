# Critique of ADR 0016

- Target: 0016-every-adr-links-its-implementing-story.md
- Date: 2026-09-21
- Verdict: **stands**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

CI enforces a proxy, not the rule. The machine-checkable part — an 'Implementation:' line exists in the header — is the trivially fakeable part; the substantive rule ('work implementing a decision does not begin until its story and task exist') is enforced by nothing except agent discipline, which is precisely what failed in the incident that motivated the ADR. The six bootstrap ADRs would have passed this CI unchanged had someone stamped a story number and still implemented directly on main first. Worse, the 'none — in force on acceptance' escape is self-certified and unverifiable: CI cannot distinguish genuine pure policy from a dodge, and many process ADRs are borderline (0017 itself changed maya-review and maya-fleet wording — is that 'work'?). When maya-record runs under an agent in a long session, stamping 'none' is the path of least resistance, recreating the invisible-work gap with a green checkmark lending it false authority. The Consequences section's claim that 'the tracker and the decision log can no longer drift apart silently' is therefore overreach: they can drift exactly as before, just behind a satisfied lint.

## Failure scenario

A future session records a process ADR, judges it 'pure policy', stamps 'none — in force on acceptance', and then edits two skills and a workflow file in the same sitting to make the policy real — ad hoc, on main, no story. CI is green throughout. The gap is noticed weeks later when maya-orient or a Maintainer audit finds skill behaviour that matches no tracked story — the identical discovery mode as the original 0009–0015 incident, now delayed by the false assurance that the link is 'machine-checked'.

## Who bears the cost

The Maintainer's audit time and, more subtly, their trust calibration: a green check that verifies paperwork rather than work invites reviewing-by-exception (ADR 0017) to skip exactly the class of drift this ADR claims to have closed. The tracker's usefulness as the single work surface (0009) degrades silently.

## Overlooked alternative

Enforcing at the other end, where the original failure actually occurred: a gate requiring every non-trivial hub commit or PR to reference a task issue — the satellite repos already carry this discipline via the mandatory 'Closes drewsonne/maya-project#N' form, and the hub's own commits were the unguarded path. That would catch invisible work directly rather than checking that a header line was filled in. The Context does not consider commit-side enforcement at all.

## Verdict reasoning

The attack exposes a real limit — the enforcement is partly theatre and the 'none' escape is honour-system — but it is a limit, not a defect that argues for undoing the decision. The rule costs one issue and one trivial CI check, is consistent with 0011's stories-are-cheap philosophy, and the navigable decision-to-story link has genuine value in a pipeline where agents orient from the tracker. Removing it would help nothing, and the stronger commit-side gate is complementary: it can be added by a later ADR without superseding this one. The honest fix is to read 'machine-checked' as 'lint-checked' and not lean on it.
