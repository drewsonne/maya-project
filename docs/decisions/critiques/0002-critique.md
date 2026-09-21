# Critique of ADR 0002

- Target: 0002-separate-repositories.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision rests its entire weight on one population — the drive-by open-source contributor — for which the project has zero evidence, while accepting costs the same Context proves are real and recurring. The contributor who 'wants to fix Tzolk'in arithmetic' is hypothetical; the ^1.0.20-vs-1.3.12 skew, the mutually invisible backlogs, and 'three CI configurations, two no longer run' all actually happened, under exactly this structure, to this author. Worse, the decision directly amplifies what ADR 0009 later names as the project's binding constraint: review throughput ('eleven agent-authored PRs once sat unmerged for eight months'). Separate repos multiply PRs per logical outcome and serialise every cross-layer change into publish-bump-verify chains — and the decision was taken at the precise moment the entire work programme is cross-layer, since ADRs 0001/0004/0005 mandate moving operations out of maya-dates (major bump), creating a new layer-2 package, and rewiring parser and app. Finally, the mitigation regime (Renovate auto-merge, scheduled latest-upstream CI, reusable workflow, contract tests, per-README consumer lists, one cross-repo board) is standing infrastructure that a solo Maintainer must keep alive, and the project's demonstrated track record on keeping CI alive is the Context's own evidence against itself.

## Failure scenario

First noticed when ADR 0004's operations extraction runs: one logical change (move LongcountAddition, CalendarRoundIterator, the wildcard expanders) becomes three-plus serialised waves — land and major-bump maya-dates, publish, stand up maya-date-operations, publish, bump parser, bump app — each wave blocked on a release of the previous, each producing its own PR into a review queue the project already knows is its bottleneck. The slower failure: the scheduled latest-published CI jobs and contract tests rot exactly as the previous three CI configs did; skew then re-accumulates silently, and the next ^1.0.20-against-1.3.12 is discovered years later, again.

## Who bears the cost

The Maintainer, twice over: as the sole reviewer of a multiplied PR stream, and as the sole operator of the four-repo mitigation infrastructure (Renovate configs, scheduled jobs, contract tests, reusable workflow) whose decay mode is silence. Secondarily the agent pipeline's throughput — maya-fleet waves scoped per-repository make every cross-layer story slower by construction.

## Overlooked alternative

Phased consolidation. The Context frames the choice as permanent-either-way and rejects the monorepo outright (it superseded a monorepo draft), but never engages sequencing: do the layered extraction inside one temporary workspace, where a single PR can move code across a layer boundary with tests green on both sides, then split into separate repos once the boundaries from 0001 are stable and the cross-layer churn is over. It also under-engages the middle option of a monorepo that publishes independent npm packages (workspaces plus changesets, per-package labels and filtered CI) — which preserves package identity and most contributor legibility while keeping cross-layer changes atomic; the 'must install an application they have no interest in' claim overstates modern filtered-install workflows.

## Verdict reasoning

Not a superseding candidate: migration would forfeit the genuinely-cited no-migration benefits, the fixtures dataset (0006) needs its own repo regardless, and the mitigations do convert skew from silence into failing builds if they stay alive. But the decision optimises for an evidenced-nowhere contributor while amplifying the project's self-declared binding constraint during a maximally cross-layer restructuring, and its Context never engaged the phased alternative. The Maintainer should weigh it — especially if the 0004/0005 extraction proves as painful as the serialisation predicts.
