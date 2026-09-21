# Critique of ADR 0015

- Target: 0015-roles-not-people.md
- Date: 2026-09-21
- Verdict: **stands**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

Two attacks, honestly graded as modest. First, the ADR grants itself an exception to the project's brightest line — ADRs are 'numbered, never rewritten — superseded by a later ADR' (README, 0007) — by declaring that name-to-role substitution 'does not count as rewriting an accepted ADR'. In a pipeline where agents execute edits and treat ADRs as authoritative constraints, a self-declared category of permissible mechanical edits to accepted ADRs is precedent: the next 'mechanical' pass (terminology harmonisation, package renames) can cite it, and the immutability guarantee becomes a judgment call about what counts as mechanical. Second, the role framing claims a transferability the project does not have: the PRD is derived from interviewing one specific person, and all three guard gates (0017) are that person's judgment. 'The Maintainer' reads as if any holder of the role could exercise them, but a successor interviewed by maya-spec would produce a different product — the authority is biographical in fact, and the BDFL model of naming the person is a legitimate governance choice the Context dismisses as reading 'poorly' rather than engaging with.

## Failure scenario

An agent executing the #24 substitution over-applies 'mechanical': it rewrites historical context in an accepted ADR ('Drew decided X in 2019' becomes 'the Maintainer decided'), losing the fact that a specific person made a dated choice, or trips the carve-out edge cases around citations of the person's published work. Because the change is pre-blessed as not-a-rewrite, review skims it, and the corruption is noticed only later — if ever — when someone needs the historical record the ADR chain was supposed to preserve.

## Who bears the cost

The integrity of the ADR chain as an immutable historical record, and any future reader (human or agent) relying on accepted ADRs never having been edited; marginally, a future second contributor who inherits documents implying the Maintainer role is transferable when the product truth behind it is one person's answers.

## Overlooked alternative

Doing nothing until a second contributor actually exists (the trigger the Context invokes is hypothetical on a solo project), or a one-line glossary mapping the name to the role — either preserves ADR immutability without an in-place rewrite of accepted documents.

## Verdict reasoning

My best attack is comparatively weak and I will not inflate it. The substitution genuinely changes no decision, the carve-outs (git authorship, owner paths, citations) are explicit, the split-role case is correctly deferred to a new decision, and the cost of the change is near zero while the benefit — pipeline documents that read as process in a public repo whose skills other people can install — is real. The immutability-exception precedent is worth the Maintainer keeping in mind the next time someone proposes a 'mechanical' edit, but it does not unseat this decision.
