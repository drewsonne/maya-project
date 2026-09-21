# Critique of ADR 0009

- Target: 0009-epics-and-stories-on-the-hub-with-just-in-time-tasks.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The horizon rule (tasks capped at wave-in-flight-plus-one) is justified by exactly one binding constraint: review throughput, evidenced by eleven PRs sitting unmerged for eight months. But ADR 0017 — accepted the SAME DAY — removed the Maintainer from the review path for clean PRs and states in its own Consequences that 'review throughput stops being the ceiling on clean work.' ADR 0009's own escape clause ('if review throughput changes materially, the horizon constant is the first thing to revisit — by a superseding decision, not by drift') therefore fired on the day of acceptance, and no superseding decision exists. What remains is a throttle without its justifying constraint: under an authorized story, waves can now merge back-to-back autonomously, so the plus-one horizon converts planning into the serialized bottleneck of every session. Separately, the decision's integrity joint is a bare string convention: a satellite PR must write 'Closes drewsonne/maya-date-fixtures#N' — a repo name ADR 0010 made stale within days — and close syntax is not among 0017's five clean-merge conditions, so a PR with a bare or stale close reference merges autonomously while its hub task stays open. Finally, making each task an issue that is 'a maya-plan work package, verbatim' duplicates an artifact that already lives in docs/plan, in direct tension with the ADR's own premise that 'a stored task inventory is a liability.'

## Failure scenario

During a 'continue authorized work' session, wave N's clean PRs auto-merge in minutes; maya-plan then refuses to have decomposed beyond N+1, so agents idle while the next wave is decomposed and re-validated — the pipeline stalls on its planning cadence, noticed the first time a multi-wave story runs under 0017 autonomy. Independently: an agent PR (or one built from pre-0010 prompt text) writes 'Closes #N' or the stale fixtures-repo form, passes all five clean-merge conditions, auto-merges, and the hub task stays open — the exact silent failure the ADR itself warns about. The board is not lying (the issue genuinely is open), so kickoff reconciliation reports nothing; it surfaces only when story closure fails despite all code being merged, or when fleet preflight finds a 'stuck' wave.

## Who bears the cost

The Maintainer's session throughput (agents idle behind planning churn) and story-closure integrity — orphaned open tasks make the hierarchy's roll-up, the one thing the tracker exists to provide, unreliable; downstream, maya-fleet preflight and epic-closure at gate G1 inherit the confusion.

## Overlooked alternative

Not making tasks issues at all: packages already live verbatim in docs/plan, so the tracker could stop at stories — satellite PRs cite a package ID and check acceptance boxes on the story, eliminating both the verbatim duplication (which the ADR's own 'task inventory is a liability' premise argues against) and the string-fragile cross-repo close as the sole task→PR linkage. The Context weighs only where task issues live, never whether they should exist.

## Verdict reasoning

The three-level hierarchy and just-in-time principle survive — staleness of pre-written decomposition is a second, still-valid justification independent of review throughput. But the horizon CONSTANT's own revisit trigger was pulled by ADR 0017 on the day of acceptance and never actioned, and the unguarded close-syntax joint is a live silent-failure path under autonomy. No urgency: the fix is a small superseding ADR (retune the constant, add close-reference verification to the clean-merge checklist), not a new model.
