# Skill follow-ups, wave 1: one plain sentence on what a PR changes

- Wave id: skill-followups-wave-1
- Date: 2026-09-27
- Plan: `docs/plan/2026-09-27-skill-followups-and-prs-outside-waves.md`, wave 1
- Story: [#58](https://github.com/drewsonne/maya-project/issues/58), text written for the Maintainer is in plain language

## For the Maintainer

- **Your action:** take [PR #68](https://github.com/drewsonne/maya-project/pull/68) out of draft and merge it, then run `/plugin update maya@maya-project` (plugin 1.10.4).
- The wave had one task and it passed review with no findings.
- Story [#58](https://github.com/drewsonne/maya-project/issues/58) stays open. It still needs the link rule, a review check, and your confirmation that agent output reads more easily.

## Collect table

| package | PR | outcome | fixtures | criteria met | notes |
|---|---|---|---|---|---|
| implement-one-line-summary ([#62](https://github.com/drewsonne/maya-project/issues/62)) | [#68](https://github.com/drewsonne/maya-project/pull/68) | ok | structure check passes; CI green | 5 of 5 | verdict **merge**, 0 findings; queued for the Maintainer (agents can't take PRs out of draft or merge) |

Findings: 0. Stop reports: 0. Fixture edits: 0.

## What the wave did not cover (gap check, advisory)

A fresh agent checked whether the wave adds up to its story.

1. No other skill contradicts the new rule. The old "do not describe the diff" line was only in maya-implement.
2. Nothing checks the new sentence. maya-review doesn't look at a PR's "For the Maintainer" section, so a PR that breaks the rule would still pass review.
3. The link rule has no task yet. The Maintainer asked that every PR and issue mentioned be a clickable link (see the last comments on [#58](https://github.com/drewsonne/maya-project/issues/58)). The "Writing for the Maintainer" block is fixed text in four skills, so all four change together.
4. [#68](https://github.com/drewsonne/maya-project/pull/68)'s own description used bare numbers. The coordinator fixed it, and that's point 3 again in practice.
5. Story [#58](https://github.com/drewsonne/maya-project/issues/58) can't close yet. Its second check is the next orient report and wave report, plus the Maintainer's confirmation.

**Seeds for the next plan:** one task adding the link rule to the four skills; one task making maya-review check the "For the Maintainer" section. Both change plugin.json, so they need separate waves or one combined task.

## Board state

Not moved. The token has no `project` scope. [#62](https://github.com/drewsonne/maya-project/issues/62) and [#68](https://github.com/drewsonne/maya-project/pull/68) belong at In review until merge.

## Wave status

Collected, not complete: [#68](https://github.com/drewsonne/maya-project/pull/68) is still open. Wave 2 (task [#63](https://github.com/drewsonne/maya-project/issues/63), the sweep of PRs outside a wave) needs #68 merged first, and story [#61](https://github.com/drewsonne/maya-project/issues/61) needs the `authorized` label.
