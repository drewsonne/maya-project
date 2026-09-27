# Skill follow-ups, wave 2: reviewing PRs that no wave started

- Wave id: skill-followups-wave-2
- Date: 2026-09-27
- Plan: `docs/plan/2026-09-27-skill-followups-and-prs-outside-waves.md`, wave 2
- Story: [#61](https://github.com/drewsonne/maya-project/issues/61), PRs no wave started get reviewed and assigned

## For the Maintainer

- **Your action:** take [PR #72](https://github.com/drewsonne/maya-project/pull/72) out of draft and merge it (plugin 1.10.5), then run `/plugin update maya@maya-project`. It's yours because it ships a plugin version and its review left two notes.
- **To prove the story works:** after merging, ask a session to "run the review sweep". Every open PR outside a wave should then carry a review verdict comment and be assigned to you.
- Story [#61](https://github.com/drewsonne/maya-project/issues/61) stays open until that sweep has run.

## Collect table

| package | PR | outcome | fixtures | criteria met | notes |
|---|---|---|---|---|---|
| review-prs-outside-a-wave ([#63](https://github.com/drewsonne/maya-project/issues/63)) | [#72](https://github.com/drewsonne/maya-project/pull/72) | ok | structure check passes; CI green | 10 of 10 | verdict **merge**, 2 advisory findings; queued for the Maintainer (plugin release, findings) |

Findings: 2 (advisory, in fixed plan text; logged on [#61](https://github.com/drewsonne/maya-project/issues/61)). Stop reports: 0. Fixture edits: 0.

## What the wave did not cover (gap check, advisory)

1. **Nothing runs the sweep yet.** The task only wrote the skill text. The sweep runs when the Maintainer asks for one in a session. Story [#61](https://github.com/drewsonne/maya-project/issues/61)'s last check needs one real run.
2. **The first sweep will merge nothing.** All ten open PRs outside a wave would go to the Maintainer:
   - The parser repo (maya-calculator-parser, formerly maya-date-parser) has no named test job, so its Dependabot PRs always fail check (c).
   - [maya-date-fixtures#14](https://github.com/drewsonne/maya-date-fixtures/pull/14) has a failing `claude-review` check.
3. **Two review follow-ups are open:**
   - The sweep doesn't re-check the changed-file list before merging (maya-review:104).
   - The version pattern has no end anchor (maya-review:98).
4. **A gap between scopes, accepted by the plan:** a satellite PR from an abandoned wave still has a `Closes` line, so neither wave collection nor the sweep sees it.
5. **Clash with proposed [ADR 0023](https://github.com/drewsonne/maya-project/pull/71).** The sweep waits to be asked. If "agents act by default" is accepted, the sweep should run on its own at session start or during orient.

**Seeds for the next plan:** fix findings 3 and 5; give the parser repo a named test job (with modernised CI, per ADR 0022's consequences).

## Board state

Not moved; the token has no `project` scope.

## Wave status

Collected, not complete: [#72](https://github.com/drewsonne/maya-project/pull/72) is still open.
