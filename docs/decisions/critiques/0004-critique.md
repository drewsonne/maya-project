# Critique of ADR 0004

- Target: 0004-operations-leave-maya-dates.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision's central justification is false on its own terms, and its real cost falls exactly where this project has historically failed. The ADR claims the split makes the 0001 layer rule enforceable 'because there is finally a boundary to enforce' — but 0001 itself names the tools (`import/no-restricted-paths`, dependency-cruiser) and both enforce directory boundaries inside a single package perfectly well. A subpath export (`@drewsonne/maya-dates/operations`) plus the in-repo lint rule would deliver everything the split is credited with — enforceable boundary, a proper home for the multi-line evaluation model, the 'operations not calculator' naming — with zero new repos and no 2.0.0 export break. Meanwhile the cut is placed at the least natural seam in the codebase: 0001 keeps conversion in layer 1 because 'a date that cannot convert itself is not independently useful', but `fromMayanDayNumber` and `LongcountAddition` are the same mixed-radix arithmetic (winal base-18); representation bugs and operation bugs will co-occur, and after the split every such fix is a land→publish→bump→publish cascade across a chain the project's own evidence (^1.0.20 pinned against 1.3.12 for three years; two of three CI configs dead; 15 stale Dependabot PRs) shows this maintainer's ecosystem does not reliably sustain. 0002's contributor argument doesn't rescue it either: a drive-by contributor fixing Tzolk'in or Long Count arithmetic now needs two repos where they needed one. The ADR also admits the boundary is unsettled at its own edge — `LongcountOperation` extends `IPart`/`CommentWrapper`, one side representation, the other not, 'unresolved and needs settling during the move' — which is a tell that the seam is being cut through load-bearing coupling rather than along it.

## Failure scenario

The first cross-boundary bug fix after the split — most likely 0005's flagged lenient-input question, where layer 1 may need a lenient construction path while wildcard expansion and normalisation sit in layer 2. A one-conceptual-change fix becomes three coordinated releases (maya-dates 2.x, maya-date-operations, parser bump), and under 0002 'waves are scoped to a single repository', so the agent pipeline must serialise it as a sequence of separately planned, separately dispatched, separately reviewed waves. It is first noticed mid-0005, during differential testing against the fixtures, when the divergence findings start requiring synchronized multi-repo changes and wave throughput collapses to release-latency. Secondary break: external maya-dates 1.x consumers importing `LongcountAddition` break on 2.0.0 with only a migration note.

## Who bears the cost

The solo Maintainer (a fifth repo's CI, Dependabot, releases, contract tests, fixture bumps — per 0002 and 0014 all mandatory per-repo overhead); the agent pipeline's throughput on any cross-layer change; external consumers of maya-dates 1.x; drive-by contributors to the arithmetic, who now span two repos.

## Overlooked alternative

An enforced in-package boundary: keep operations in maya-dates as a subpath export (`@drewsonne/maya-dates/operations` — or a workspace-published second package from the same repo), with the dependency-cruiser/eslint rule from 0001 making the layer boundary machine-checked in CI. This gets the enforceability, the naming discipline, and a home for `LinkedListElement` evaluation without the release cascade or the 2.0.0 export break. The Context never weighs it; it treats 'boundary' and 'separate repository' as the same thing.

## Verdict reasoning

Still status: proposed, so the cheaper mechanism is live. The fixture gate is genuinely excellent and should survive any variant, and 0001's layer model is right — but the specific claim that enforceability requires a separate package is wrong, and the cascade cost lands on the project's demonstrated weakest muscle. Not a superseding-candidate outright because 0001/0002 are already accepted with layer 2 as a separate repo, and the agent pipeline was explicitly built to absorb per-repo overhead; the Maintainer may rationally still choose the split — but only after actually engaging the subpath alternative, which no ADR in the set does.
