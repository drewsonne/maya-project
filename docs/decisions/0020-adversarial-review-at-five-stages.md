# 0020. Adversarial review runs at five stages, advisory to the gates

- Status: accepted
- Date: 2026-09-20
- Implementation: #39
- Depends on: 0017

## Context

The pipeline verifies mechanically — fixtures, CI, scope diffs — but
almost nothing verifies adversarially: plans, criteria, citations and
reviews were each checked by a single cooperative reader, often the
session that authored them (wave 1's review was a disclosed
self-review). The failure modes this leaves open are the expensive
ones: criteria satisfied by letter not spirit, tests that pass either
way, and — worst for a correctness dataset — plausible fabricated
citations. Agents are cheap; the Maintainer's attention is not, so
adversaries must also not flood the queue with unverified noise.

## Decision

Five adversarial stages, each owned by the skill whose artifact it
attacks:

1. **Plan red-team** (`maya-plan`, before issues are filed): an agent
   attempts to satisfy each package's criteria while violating its
   goal; every exploit found becomes a criteria fix.
2. **Bad-faith PR pass** (`maya-review`): a fresh agent with no author
   context reads the diff assuming it games its criteria — including
   checking that each new test fails without the implementation.
3. **Citation audit** (`maya-review`, any PR touching attested
   vectors): the adversary re-fetches each claimed source and tries to
   refute both the value and the citation.
4. **Wave gap analysis** (`maya-fleet`, collect): a completeness critic
   asks what the wave did not cover — whether the packages, all green,
   actually add up to the story's outcome.
5. **Devil's advocate** (`maya-record`): every ADR draft reaches the
   Maintainer with its strongest counter-argument attached.

Two structural rules. **Author ≠ reviewer, always**: whoever authored a
change — agent or session — never runs its review; review reads the
diff cold. **Tiered intensity**: changes to calendar arithmetic or
attested fixtures get findings verified by a three-refuter majority
panel before surfacing; everything else gets a single adversary.

**Findings are advisory** (the Maintainer's explicit choice): they
attach to the PR or wave report and appear in the queue, but do not
block auto-merge — ADR 0017's clean-merge definition is unchanged.

## Consequences

Gaming is hunted at authoring time, plans stop rewarding
letter-compliance, and fabricated citations meet an auditor that
actually opens sources. Findings reach the Maintainer pre-refuted, so
adversaries add signal, not noise. The advisory choice means a gamed
PR whose mechanical checks pass can still merge with an open
adversarial finding attached — caught post-merge, not before; wave
telemetry (ADR 0012) is the watch on whether that trade holds, and a
superseding decision flips findings to blocking if it does not.
