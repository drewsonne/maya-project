# maya-retro, wave 1: the retro skill

- Wave id: maya-retro-wave-1
- Date: 2026-09-27
- Plan: `docs/plan/2026-09-27-maya-retro.md` ([PR #79](https://github.com/drewsonne/maya-project/pull/79)), wave 1
- Story: [#76](https://github.com/drewsonne/maya-project/issues/76), the Maintainer can run a periodic retro that scores process and product and fixes process problems
- Design: `docs/plan/2026-09-27-maya-retro-design.md` ([PR #74](https://github.com/drewsonne/maya-project/pull/74)); decision: ADR 0024 (a retro may authorize process fixes)

## For the Maintainer

- **Your action:** take [PR #80](https://github.com/drewsonne/maya-project/pull/80) (the `maya-retro` skill, plugin 1.11.1) out of draft and merge it. It changes an authorization rule, so no agent merges it. It is safe to merge now: the retro can authorize nothing until ADR 0024's status line on `main` reads `accepted`.
- **Before you mark ADR 0024 (and 0023) accepted:** let [story #81](https://github.com/drewsonne/maya-project/issues/81) (the authorizing command fails closed and cannot exceed its limits) land first. The review found the retro's limit of three stories fails open under zsh, and a few smaller holes. You merged the ADR 0023 and 0024 pull requests; their files still say `proposed`, which is what keeps the retro safe meanwhile.
- **Then run the first retro** (`/maya:maya-retro`). One is already due: 7 wave reports since 2026-09-13. Expect most product figures to read "not wired", because nothing yet runs the fixture suite against the libraries or the app (task #8).
- Also merge the design ([PR #74](https://github.com/drewsonne/maya-project/pull/74)) and plan ([PR #79](https://github.com/drewsonne/maya-project/pull/79)) to keep them on `main`.

## Collect table

| package | PR | outcome | fixtures | criteria met | notes |
|---|---|---|---|---|---|
| wave-1-maya-retro-skill ([#78](https://github.com/drewsonne/maya-project/issues/78)) | [#80](https://github.com/drewsonne/maya-project/pull/80) | ok | fixture command exits 0; `validate` green at 39aa1cd | 20 of 20 | first review **merge after named changes** (plan text let a body line authorize without the label; re-planned, fixed in a58012b); `main` merged in after #72 (39aa1cd); second review **merge**, 0 blocking findings; queued for the Maintainer |

Findings: 3 in the first review (all traced to the plan's fixed texts, all fixed), 0 in the second. Stop reports: 1 (an implementer could not read task #78's body: the tool permission layer denied it; cleared when the Maintainer allowed `gh issue view`). Fixture edits: 0. Scope violations: 0.

## Adversarial findings (advisory)

From the second review's cold adversary, all carried into [story #81](https://github.com/drewsonne/maya-project/issues/81):

1. The limit of three authorized stories fails open under zsh when the count lookup fails.
2. The five conditions for a retro story do not prove a retro filed it, or that its body is unchanged since.
3. The ADR 0024 acceptance check ignores ADR 0023's status and a later "superseded" line.
4. `maya-review` spots retro stories only through the full `Closes drewsonne/maya-project#<k>` form.
5. Authorizing a retro story directly (removing `retro`) erases the record that a retro filed it.

## What the wave did not cover (gap check, advisory)

A fresh agent checked whether the wave adds up to story #76.

1. The adversarial findings above block accepting ADR 0024, not merging #80.
2. The order of ADRs 0023 and 0024 is undefined while 0023 is proposed; if 0023 were accepted alone, the retro interview would not be on its list of moments you are asked. Added to story #81.
3. Wave reports are not in one shape: `wave-1.md` has no `outcome` column, `adr-critiques.md` has no collect table but counts as a wave, stop reports are not sorted by cause, and self-review is recorded nowhere. The first retro can run, but some process figures will be inferred and must say so.
4. The product scorecard is mostly empty today: no surface runs the fixture suite yet, and the hub has no `bug` or `correctness` label to count open correctness bugs.
5. Nothing vets the retro's own questions against the interview filter. Added to story #81.
6. The "Retro due" check miscounts (non-report files, unmerged retro reports). Added to story #81.
7. Story #76 closes only after a live retro: ADR 0024 accepted, a report with all six sections merged, and your confirmation that no question was about implementation or project management.

**Seeds for the next plan:** story #81 (harden the authorizing command and due check) first; then a wave-report template with required outcome, verdict, stop-cause and self-review columns; then your decision on ADRs 0023 and 0024; then the first live retro.

## Board state

Task [#78](https://github.com/drewsonne/maya-project/issues/78) and [PR #80](https://github.com/drewsonne/maya-project/pull/80) at In review; story [#76](https://github.com/drewsonne/maya-project/issues/76) at In progress; story [#81](https://github.com/drewsonne/maya-project/issues/81) at Backlog.

## Wave status

Collected, not complete: [PR #80](https://github.com/drewsonne/maya-project/pull/80) is open and waiting on the Maintainer.
