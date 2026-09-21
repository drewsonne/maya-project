# Critique of ADR 0019

- Target: 0019-the-board-contract.md
- Date: 2026-09-21
- Verdict: **stands**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The board is sold (via ADR 0018) as 'how a human audits what agents did without reading transcripts' — but 0019 makes it a mirror written exclusively by the agents being audited, of issue state also written by those agents. Reconciliation compares board to issue state, not issue state to reality, so the audit chain bottoms out in agent self-report: an agent that mis-executes but dutifully updates issues produces a board that reconciles perfectly. Worse, the truth guarantee is kickoff-only, while 0017's trigger model means autonomy runs DURING sessions — the Maintainer glances at the board precisely in the window when its accuracy depends on every skill remembering a board-status.sh side effect, which 0018 already concedes will sometimes be missed ('a missing transition is a defect'). The decision also assigns the reconciliation-and-repair duty to maya-orient, breaking that skill's project-wide charter as the one skill that 'reads everything and writes nothing.' And 'everything is on the board' collides with ADR 0011's deliberately unbounded story backlog plus all Dependabot PRs: kickoff reconciliation is an O(all items) gh-CLI walk on a personal account, so the opening ritual that underwrites the board's trustworthiness gets slower and more rate-limited as the backlog grows — the guarantee erodes exactly as the project succeeds.

## Failure scenario

Mid-autonomous-session, a dispatched agent's board-status.sh call fails (rate limit, transient error) after 'gh pr create'; the Maintainer glances at the board — the promised audit surface — sees the task still In progress, and concludes the wave is stalled or intervenes on good work. The truth surfaces only at the NEXT session's kickoff. Slower burn: at a few hundred backlog stories plus Dependabot items, orient's reconciliation walk takes minutes and starts tripping GitHub secondary rate limits; reconciliation quietly gets scoped down, and 'trust it because every session opens by making it true' becomes aspirational without anyone deciding that.

## Who bears the cost

The Maintainer — misplaced mid-session trust and growing kickoff latency — plus maya-orient's read-only contract, which every 'safe to run anytime' assumption elsewhere leans on.

## Overlooked alternative

A computed view instead of a maintained mirror: invert board-status.sh into an on-demand report generator (read issues and PRs, print the pipeline state), leaning on GitHub's built-in auto-add and closed-to-Done automations for the board itself. A derived view has no drift to reconcile and removes the entire 'missing transition' defect class along with the write duty in every skill. The 0018/0019 Context frames the question as how a mirror's truthfulness is MAINTAINED and never engages with not maintaining state at all.

## Verdict reasoning

The core choices survive the attack. Mirror-only is unambiguously right — a commanding board would hand agents an unauthenticated control channel, violating 0017's label-gated authorization. The computed-view alternative founders on Projects v2 reality: Status and the roadmap layout cannot be derived natively from labels, and the Maintainer's stated want is the GitHub board UI, not a terminal report — a value judgment properly taken at G1. The audit-independence gap is real but the board was never the correctness layer; fixtures, CI and wave reports are. The residual weaknesses — mid-session staleness, orient's charter breach, reconciliation cost at scale — are containment problems worth a line in a future ADR, not grounds to supersede this one.
