# Critique of ADR 0005

- Target: 0005-app-consumes-the-stack.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The safety mechanism the deletion is gated on cannot see the risk the ADR itself names as open. The gate is 'differential testing against the fixture suite' — but per 0006 the fixtures are attested, citation-backed vectors from the literature, which by construction cover only well-formed dates. The app's distinctive behavior is precisely the ill-formed input space: is_valid()/normalise() accepting out-of-range Long Count positions, PatternMatcher's regex tolerance, multi-line younger_sibling chaining semantics. No published source attests that 0.0.0.25.0 normalises to 0.0.1.7.0, so no fixture will ever exercise it, so the differential gate passes green while the divergence that matters most goes undetected. Worse, the ADR's own fallback — 'the app normalises before constructing' — would put date arithmetic back into the presentation layer, violating the very layer discipline (0001) the deletion exists to enforce. And sequencing compounds it: per 0001, layer 2 does not exist, layer 3 exports 0 bytes, and layer 1 needs a major version bump. The decision deletes the project's only working, academic-facing artifact's engine and makes it the last consumer of three unfinished packages — the app's usability becomes hostage to the entire stack landing, on a solo-Maintainer project where the app already went untouched for three years.

## Failure scenario

Wave order: differential test runs fixture inputs through both implementations, all agree, deletion is declared safe and js/model.js is removed. Months later the rebuilt app ships on the stack. An epigrapher pastes a date from an inscription with an out-of-range winal or a partial Calendar Round that the 2019 app silently normalised; maya-dates raises, the app shows an error or a blank result. First noticed not in CI (the app has 333 lines of tests, none covering leniency) but by an end user post-deploy — the exact population the project exists to serve. Alternatively, and earlier: planning the app wave discovers it cannot proceed at all until layers 2 and 3 ship, and the app sits engine-less on a branch while four repos coordinate.

## Who bears the cost

The academic end user of maya-calculator, who loses lenient input handling that was a deliberate feature, not an accident; secondarily the Maintainer, whose only deployed artifact's release cadence becomes coupled to a four-repo dependency chain.

## Overlooked alternative

Staged retirement instead of deletion: the app consumes layer 1 first while keeping PatternMatcher and its normalisation shim until layer 3 actually exports something, with the embedded implementation kept temporarily as a parallel-run oracle whose divergences are logged in production-realistic use — and, separately, a differential input corpus generated beyond the fixtures (random and adversarial inputs, not just attested ones), since the fixture suite is structurally the wrong instrument for settling the leniency question the ADR defers to it.

## Verdict reasoning

Consolidating onto the 3,488-line-tested library is clearly right — duplicated calendar arithmetic is this project's central sin and the ADR's diagnosis of the app's decay is devastating and accurate. But the ADR is still 'proposed', and before acceptance two things deserve amendment: the differential gate must run inputs beyond the attested fixtures or it cannot settle the leniency risk the ADR itself flags, and the leniency decision should be made before deletion, not after, because its fallback options either regress the user or violate 0001.
