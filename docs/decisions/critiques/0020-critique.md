# Critique of ADR 0020

- Target: 0020-adversarial-review-at-five-stages.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The five stages and author-never-reviews are sound; the attackable choice is making findings advisory, and specifically the justification offered for it. The ADR knowingly accepts that 'a gamed PR whose mechanical checks pass can still merge with an open adversarial finding attached' and names wave telemetry (ADR 0012) as the watch on whether that trade holds. But the watch instrument cannot see the failure it is watching for: ADR 0012's wave report carries a findings *count* and per-package rows — it cannot distinguish a wave with five trivial advisory notes from a wave where one CONFIRMED gamed-test finding rode an auto-merge into main. The tripwire that is supposed to flip findings to blocking has no resolution at the severity level where the trade actually breaks. And the hole sits exactly where the pipeline is weakest: fixture-editing PRs never auto-merge under ADR 0017 ('no fixture edits' is in the clean definition), so advisory-vs-blocking is immaterial precisely where 0020's tiered intensity is highest; where it IS material is code PRs in thin-coverage satellites — the calculator's 333-line suite that ADR 0017 itself flags as knowingly weak — where a test that passes either way plus a green suite is cheap to produce. Separately, stage 3's design assumes the adversary can 're-fetch each claimed source': the load-bearing sources in Maya calendrics (Thompson 1950, the GMT correlation literature, codex facsimiles, Martin & Skidmore) are largely print and unfetchable by an agent, so the audit either stays silent — and silence will be read as verification — or the three-refuter majority panel converges on 'cannot refute' for exactly the most plausible fabrication class: a fake citation to a real but offline book. The panel raises precision but structurally lowers recall on the failure mode the ADR calls the worst one.

## Failure scenario

During an authorized story, a dispatched agent games a package's criteria in maya-calculator with a test that passes without the implementation. Mechanical review is clean, the thin suite is green, no fixtures were touched: ADR 0017 auto-merges. The bad-faith pass's finding attaches, advisory, to a merged PR. The next wave is re-validated against main — which now contains the gamed change — so planning adapts to the exploit rather than surfacing it, and the stage-4 gap analysis runs at collect, after the merge. First noticed whenever the Maintainer next reads the advisory queue, which review-by-exception has specifically trained them to visit only when something blocks — or later still, when a downstream conversion is wrong. The citation-audit variant is quieter: an unfetchable-source audit reports nothing, the vector stays attested, and the false assurance is discovered only if a human ever opens the physical source.

## Who bears the cost

Downstream consumers of the library and dataset if a gamed change propagates wrong conversions; the Maintainer, whose advisory queue silently accumulates the exact reading burden the gates were meant to remove; and the credibility of auto-merge itself — one post-merge catch of a gamed PR and the Maintainer rationally stops trusting the clean case, un-earning everything ADR 0017 bought.

## Overlooked alternative

A per-finding demotion tier between advisory and blocking, which the decision's own machinery already makes cheap: the three-refuter panel produces a verified/unverified distinction, and ADR 0017 already has a queue path. A CONFIRMED finding from the bad-faith pass or citation audit could demote just that PR from auto-merge to queued — holding one PR, blocking nothing wave-wide, changing 0017's clean definition by one clause. The ADR frames the choice as binary advisory-vs-blocking and never engages this middle option; also unengaged is any human sampling floor for offline sources (e.g., the Maintainer spot-checks a random attested vector per wave against the physical literature), which is the only real check on unfetchable citations.

## Verdict reasoning

The architecture stands — five stages, cold reads, tiered intensity are right for this pipeline, and the Maintainer made the advisory choice explicitly with a supersession path pre-planned. But the safety argument leans on a telemetry instrument that lacks the resolution to trigger that supersession, and stage 3's fetchability assumption converts the highest-stakes audit into potential false assurance. Two concrete amendments (severity in wave reports; CONFIRMED-finding demotion or an offline-source sampling rule) would close most of the hole without revisiting the core decision — which is why this is worth-revisiting, not a superseding-candidate.
