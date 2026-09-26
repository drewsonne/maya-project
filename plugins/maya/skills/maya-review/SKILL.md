---
name: maya-review
description: Review a pull request on the Maya date project against its acceptance criteria, layer rules and fixture integrity before merge. Use on agent-authored and hand-written PRs alike, especially any touching calendar arithmetic.
---

# Review a pull request

The purpose is to make a merge decision defensible without reading every line. Eleven agent-authored pull requests once sat unmerged on this project for eight months because nobody could face reviewing them — the cost of review, not the cost of writing code, is what actually limits throughput here.

So this review is mechanical first and judgement second. The mechanical checks either pass or the PR is not ready, and no amount of reading compensates for one of them failing.

## One pull request per context

A reviewing context reviews exactly one pull request and then ends (ADR 0021). The reviewer carries no prior review's context: it is a fresh agent, not one that has reviewed another PR in the wave and not the author (ADR 0020). Its inputs are the diff, the package block from the hub issue the PR closes (the `Closes drewsonne/maya-project#N` in its description), and the ADR clauses that block's `binds:` field quotes. No other pull request's diff, verdict or findings is read in — a review conditioned on three earlier reviews is a weaker review of the fourth. If you are collecting a wave, dispatch one such agent per PR and consume its verdict; never review the second PR in the context that reviewed the first.

## Mechanical checks

Run all of these before forming any opinion about the code.

1. **Fixture integrity.** No change to fixture files or expected values unless the PR's stated purpose is adding fixtures. A PR that changes an expected value while also changing implementation is rejected on sight, regardless of whether tests pass. Do not evaluate the reasoning offered for it.
2. **Scope.** Changed paths against the package's declared scope. Anything outside it is a finding.
3. **Contract.** Nothing listed in the package's contract has changed. Check exported signatures specifically, not just files.
4. **Layer direction.** No new import from a lower layer to a higher one. Presentation → parsing → operations → representation, inward only.
5. **Suite.** Full suite green on the branch, not just the tests the PR added. Check that a new test actually fails without the implementation — a test that passes either way is decoration.
6. **Acceptance criteria.** Walk each one by name and state met, not met, or unverifiable. An unverifiable criterion is a planning defect to record, not something to wave through.

Report these as a list with verdicts. If any fails, say which and stop — do not continue into code review to soften the result.

## Adversarial pass (ADR 0020)

Runs alongside judgement, in a **fresh agent that reads the diff cold**
— never the author, never an agent carrying the author's context.

- **Bad faith.** Assume the diff games its criteria. Check each new
  test fails without the implementation; look for weakened assertions,
  letter-not-spirit compliance, and changes hidden in mechanical noise.
- **Citation audit** (any PR touching attested vectors): re-fetch each
  claimed source and try to refute the value and the citation. A
  citation to an unfetchable source is itself a finding.
- **Tiered intensity**: for calendar arithmetic or attested fixtures,
  findings survive only a three-refuter majority panel; elsewhere a
  single adversary suffices.

Adversarial findings are **advisory**: attach them to the PR and the
queue, but they do not change the verdict or block a clean merge
(Maintainer's choice, ADR 0020). Never soften or omit one because it
cannot block.

## Judgement

Only once the mechanical checks pass.

- **Is the arithmetic verifiable by inspection?** Prefer direct division to progressive subtraction. If you cannot confirm a calculation by reading it, say so — that is a finding even when the tests pass, because the next person will not be able to either.
- **Does anything here encode a decision nobody made?** A default value, a rounding convention, a chosen correlation constant, a Haab coefficient convention. These arrive silently in implementation and are the most expensive thing to discover later. Route each to `maya-record`.
- **Is the change the smallest one that satisfies the criteria?** Extra refactoring bundled in is not a bonus; it is unreviewable surface. Ask for it to be split.
- **Would an epigrapher notice this?** Not a blocker — plenty of necessary work is invisible to users. But if a PR is large and the answer is no, say so plainly.

## Output

One verdict, chosen explicitly: **merge**, **merge after named changes**, or **reject and re-plan**.

Then at most five findings, most serious first, each naming the file and line. Do not pad the list to look thorough — a review with one real finding and a merge verdict is a good review.

## Rules

- **Author ≠ reviewer, always** (ADR 0020): whoever authored the change — agent or session — never runs its review. If you authored it, dispatch a fresh agent to review and relay its verdict.
- Merge only the clean case, and only under an active G2 authorization (ADR 0017): verdict **merge**, zero findings, full suite green, scope clean, no fixture edits. Everything else: state the verdict and queue it for the Maintainer. Never soften a finding to reach the clean case, and never merge a release PR — shipping is G3, always the Maintainer's.
- Never approve a PR whose package block cannot be found. Unattributed work has no criteria to check against.
- Do not comment on formatting, naming preference or style that a linter should own. If a linter should own it and does not, that is one finding: add the linter.
- A PR that is correct but unreviewable is not ready. Say that, rather than merging it because the tests are green.
- If reviewing reveals the plan was wrong rather than the code, say so and route it back to `maya-plan`. Do not fix a planning error by negotiating with the implementation.
