# Critique of ADR 0006

- Target: 0006-fixtures-as-a-published-dataset.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision fuses two things that pull in opposite directions: a high-churn internal test dependency and a stable citable reference, and it commits to the heavyweight mechanism (npm publish + four-consumer bump per change) for both. The ADR calls the friction 'the right friction', but it was accepted on 2026-09-13, before ADR 0017 (2026-09-20) made every release a Maintainer-only G3 gate and excluded any PR with fixture edits from autonomous merge. Under the combined regime, landing a single attested vector now requires two synchronous Maintainer touches — merge the fixture PR (never auto-merged), then merge the release PR (G3) — before Renovate can bump the four consumers and maya-fleet's preflight can even see the new vector. The fixtures-first rule in maya-implement makes this chain a hard prerequisite of every calendar-arithmetic fix. So the mechanism concentrates load on exactly the bottleneck 0017 was written to relieve: the Maintainer's synchronous attention. Meanwhile the citable-dataset benefit that justifies the ceremony accrues to a speculative audience — no epigrapher has yet asked for machine-readable YAML vectors — while the throughput cost is paid on every vector, now.

## Failure scenario

First arithmetic bug found after the dataset's v1 ships: differential testing (the open risk 0005/0006 cite) shows the calculator's embedded implementation and maya-dates disagree on a Calendar Round. Fixtures-first demands the deciding attested vector land in maya-date-fixtures before any fix code. That vector must pass the ADR 0020 three-refuter citation panel, be merged by the Maintainer, be released by the Maintainer at G3, and propagate through four Renovate bumps — and until it propagates, maya-fleet cannot dispatch the fix wave. A one-vector, one-line fix becomes a multi-day, five-repo release train, first noticed the first time a wave sits blocked waiting for a fixture release. If the Maintainer responds by batching vectors or letting agents work from unpublished branches, the single-source-of-truth guarantee quietly erodes — the exact drift the ADR exists to prevent.

## Who bears the cost

The solo Maintainer, who becomes a synchronous dependency of every fixture addition (two gate touches per vector batch), and the latency of every arithmetic bug fix in the agent pipeline. Secondarily, dataset quality: friction on adding vectors is friction on the project's most valuable output.

## Overlooked alternative

A middle path between 'copy into each repo' and 'publish as a package': consumers fetch the fixtures repo by pinned git tag or SHA in CI (or an npm git-dependency), keeping one authoritative source and full provenance discipline, while npm publication and archival (e.g. a Zenodo DOI) are reserved for deliberate citable milestones. Alternatively, a pre-release dist-tag channel ('next') that consumers' scheduled latest-version CI job tracks, so a vector is visible to the fleet before the Maintainer blesses a citable release. The Context considers only the two extremes.

## Verdict reasoning

The core decision — one language-agnostic, provenance-carrying repository — survives any attack; the divergent-copies argument is decisive and evidenced by this project's own history. What deserves weighing is the release mechanics, because ADRs 0017 and 0020, accepted a week later, changed the cost structure the ADR reasoned under: every vector now takes two synchronous Maintainer gates before the pipeline can use it. A lightweight propagation channel for vectors, distinct from citable releases, would preserve every property the ADR values. No urgency — the friction only starts biting after the first post-release bug-fix cycle.
