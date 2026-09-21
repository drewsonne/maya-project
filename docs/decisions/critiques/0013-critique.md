# Critique of ADR 0013

- Target: 0013-story-closure-requires-demonstrated-acceptance.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The demonstration mechanism is prose self-attestation by the closer — and under ADR 0017 (accepted the same day) story closure is an autonomous action, so the closing comment is normally written by the same agent pipeline that produced the work. This is the only point in the pipeline where a self-report is promoted directly to trusted state: fixtures are 'unfakeable', PR merges require mechanical verdicts, ADR 0020 makes author-never-reviews structural and enumerates five adversarial stages — and story closure is not one of them (the wave gap analysis runs at collect, attacks wave coverage not the closure claim, and its findings are advisory and never block). A fluent-but-hollow 'demonstrated against main: criteria met' comment is precisely the failure mode — letter-compliance by a cooperative author — that 0020 says the pipeline was redesigned to hunt. Meanwhile 0009 requires story acceptance criteria to be machine-checkable, so an executable demonstration (a rerunnable command or CI-run link per criterion) was available and strictly stronger; the ADR chose the weakest evidentiary form for the tier whose whole purpose is to be trusted without re-verification.

## Failure scenario

An authorized story's last wave merges clean; the closing agent mistakes a green unit run for the acceptance demonstration (or checks two of three criteria), writes a plausible closing comment, and closes the story — all within 0017's autonomy. maya-orient and the epic rollup report the story done without re-verification, by 0013's own design. At G1 the Maintainer restates the PRD outcome as achieved on the strength of story states. The gap surfaces weeks later — e.g. a criterion like 'the published fixture package validates on install' was never actually run against the published artifact — after the epic is closed and the audit trail affirmatively says it was verified, which is worse than the pre-0013 state of an honest 'closed on judgement, undocumented'.

## Who bears the cost

The Maintainer's trust model first — 0013 exists precisely so story state can be reported without re-verification, and one hollow comment silently poisons that for the whole tier. Ultimately external researchers, for whom this project is a citation-backed correctness dataset whose closed stories are implicit correctness claims.

## Overlooked alternative

Executable demonstration: since criteria are machine-checkable per 0009, the closing comment could be required to cite a rerunnable command or CI-run link per criterion (with 'what was checked and where' meaning evidence locations, not narrative), and/or agent-authored closures could pass through a sixth adversarial stage consistent with 0020's author-not-reviewer rule. The Context weighs neither; it frames the only alternatives as 'no rule' versus 'a comment'.

## Verdict reasoning

The rule itself — no closure without demonstration against main — clearly stands and fixes a real audit gap. The weakness is the mechanism's interaction with 0017 autonomy: closer-authored prose is the one non-mechanical, non-adversarial link in a pipeline built on distrusting exactly that. Volume is low (one story closed to date) and the fix is a small amendment, not a replacement, so no urgency — but the Maintainer should tighten it before autonomous closures become routine, since every hollow closure created meanwhile is retroactively expensive to distrust.
