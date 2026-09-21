# Critique of ADR 0001

- Target: 0001-four-layer-architecture.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The layering rule (inward-only dependencies) is sound; the attackable part of the decision as made is that it commits each layer to being a separate published package — 'Layer 1 loses exports, so maya-dates takes a major version bump; Layer 2 is a new package that does not exist yet' — when the ADR's own stated benefit (a machine-checkable boundary via dependency-cruiser or import/no-restricted-paths, enforced in CI) is fully achievable with directory-level enforcement inside one package. The 2.0.0 breaking release to the project's only published library with external consumers, plus a brand-new repo/package/CI/versioning surface, is spent to move roughly seven classes out of src/operations/. Worse, the boundary is cut in the one place that splits the domain's hardest arithmetic across it: by ruling calendar conversion 'representation', layer 1 keeps fromMayanDayNumber and the correlation-constant conversions — winal-base-18 mixed-radix positional arithmetic — while layer 2 gets addition, subtraction and distance numbers, which are the same winal-base-18 carry/borrow arithmetic. The very class of bug this citation-backed project exists to catch (base-18/base-20 radix errors) now lives on both sides of a package boundary. And every cross-layer fix becomes a serialised land-publish-bump-verify chain across repos (0002 concedes this), against a project whose own Context documents that the previous multi-package structure decayed into three years of version skew, a 0-byte published entry point, and dead CI precisely because this solo maintainer's attention is intermittent. Four packages is more of the structure that already failed here, prescribed as the cure.

## Failure scenario

A radix or correlation bug is found via the fixture suite in arithmetic shared between conversion (layer 1) and distance-number math (layer 2). Fixing it takes two PRs in two repos, two releases, a downstream bump, and per-0002 a serialised sequence of waves — against a pipeline whose explicitly stated bottleneck is review throughput (0009: eleven PRs once sat unmerged for eight months). First noticed during the 0004 extraction itself or the first post-split arithmetic fix, when maya-plan must schedule what is logically one change as multiple dependent waves and the Maintainer must review and release it twice. Meanwhile external consumers of @drewsonne/maya-dates break on 2.0.0 for an internal restructuring that gave them nothing.

## Who bears the cost

The solo Maintainer, whose review-and-release attention is the project's scarcest resource and who now services four versioned artifacts; external consumers of @drewsonne/maya-dates broken at 2.0.0; the agent pipeline, whose cross-layer work serialises into wave chains instead of parallelising.

## Overlooked alternative

Enforcing the representation/operations boundary intra-package: src/representation/ and src/operations/ inside @drewsonne/maya-dates, policed by exactly the tooling the ADR names (dependency-cruiser boundaries work within a repo), with the operations barrel unexported or exported under a subpath. This gets the machine-checkable boundary, independent testability, and the naming discipline, with no 2.0.0 break and no fourth package. The Context argues carefully about where conversion belongs but never engages with whether a layer boundary requires a package boundary at all — that equivalence is assumed in 0001 and then inherited by 0002 and 0004.

## Verdict reasoning

The inward-dependency rule and the conversion-is-representation call survive attack, and fixture-gating (0004/0006) genuinely mitigates the migration risk. But the layer-equals-package commitment buys its enforcement benefit at the price of a breaking release, a fourth maintained artifact, and the shared mixed-radix arithmetic straddling a package boundary — and the intra-package alternative was never weighed. 0004 is still 'proposed', so revisiting the packaging (not the layering) is cheap right now and expensive later.
