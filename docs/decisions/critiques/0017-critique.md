# Critique of ADR 0017

- Target: 0017-autonomy-between-three-guard-gates.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The three-gate structure is sound, but the decision spends its riskiest autonomy grant on its lowest-throughput item. The ADR's justification — 'a gate is friction that caps throughput at the Maintainer's attention' — is true for wave PRs, where volume is real and fixtures make output unfakeable. It is false for Dependabot: ADR 0014 sets a monthly cadence across four quiet repos, so queuing majors would cost the Maintainer perhaps a handful of clicks a month. Yet 0017 auto-merges majors on green, and 0014's own framing calls a dependency 'the one place a small diff imports someone else's code into the trust boundary'. A green suite is exactly the wrong evidence for a dependency bump: it verifies behavior the suite covers and verifies nothing about trust — no fixture, no acceptance criterion, no scope contract targets the imported code, so 'mechanically checkable' does not apply. The npm ecosystem demonstrated the concrete threat in September 2025 with the Shai-Hulud self-propagating worm: compromised package versions whose install hooks exfiltrate credentials. This pipeline's agents run npm ci in sessions holding GitHub credentials, so an auto-merged compromised major executes inside the trust boundary long before G3's release gate is relevant — G3 gates shipping to users, not code execution on the Maintainer's machine and agent sessions. There is also an audit-trail inconsistency: the ADR names the authorized label as 'the audit trail of what was permitted', but Dependabot merges happen on no story and carry no label, so the highest-risk autonomous action is the one outside the audit mechanism. Finally, ADR 0020 hollows out 'zero findings' from the other side: adversarial findings are explicitly advisory and do not count against the clean-merge definition, so a PR flagged by the bad-faith pass as gaming its criteria still auto-merges — though that trade is 0020's owned choice, with telemetry as the named watch.

## Failure scenario

A major bump of a runtime dependency in maya-calculator (the 333-line suite the ADR itself names) arrives as an individual Dependabot PR; the suite runs green because it exercises none of the changed surface; a 'continue authorized work' session merges it to main autonomously. Benign case: a behavioral regression in date handling surfaces weeks later at G3 as one changelog line in a batched release PR — the review burden 0017 removed reappears at the release boundary with far worse context — or after release, in front of the exact correctness-focused audience the project exists to serve. Malicious case: a Shai-Hulud-class compromised version executes an install script in the next agent session, harvesting the gh/npm credentials that control all five repos including the citable dataset; first noticed only when a security advisory lands post-merge or the credentials are abused — potentially weeks, since merge required no human eyes at all.

## Who bears the cost

The Maintainer (credential compromise and cleanup across five repos in the malicious case; batch re-review at G3 in the benign case); the dataset's external trust, which is the project's stated reason to exist, if compromised credentials touch maya-date-fixtures; downstream consumers of maya-dates if a regression ships.

## Overlooked alternative

A risk-tiered dependency clause the Context never engages with: auto-merge grouped minor/patch on green, queue majors for the Maintainer — near-zero throughput cost at monthly cadence. Likewise a cooling-off rule (merge only versions older than N days), which specifically defeats worm-style compromise windows. The Context treats Dependabot autonomy purely as a test-coverage question ('knowingly weaker in thin-coverage repos') and never as the trust-boundary question its own companion ADR 0014 articulates; it also never brings dep merges under the G2 label audit trail.

## Verdict reasoning

The core decision survives: three gates placed at irreversibility, external visibility and value judgment is right for this pipeline, fixture-gated wave auto-merge is well defended, and the session-only trigger model bounds the blast radius. But the Dependabot-major clause buys almost no throughput (monthly cadence, four quiet repos) while accepting the project's worst tail risk on evidence — a green suite — that verifies nothing relevant, and it sits outside the ADR's own audit mechanism. A one-line amendment (majors queue; minor/patch auto-merge) removes the weakness without touching the architecture; wave telemetry is the wrong watch for this failure mode because a supply-chain compromise does not show up as a review-findings trend.
