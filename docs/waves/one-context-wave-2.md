# One-context plan — wave 2 (the release)

- Plan: `docs/plan/2026-09-26-one-context-per-unit.md` (ADR 0021, story #43)
- Date dispatched: 2026-09-26, one agent, fresh context, own worktree
- Date collected: 2026-09-26 — **complete**; #53 merged as edbc69a, plugin 1.10.0 on `main`
- Preflight: main green (8d76119, plugin 1.9.5); fixture command exit 0;
  no open PRs; all four wave-1 dependencies merged; task #48 sub-issue of
  open story #43

| package | PR | fixtures | criteria met | scope | outcome | review verdict | notes |
|---|---|---|---|---|---|---|---|
| wave-2-readme-sources-release | #53 | fixture command 0; validate green (push + PR) | 8/8, verified mechanically | clean | ok | merge after named changes → merge on re-check; 1 advisory | version 1.10.0; two named changes applied by the author, squashed by the coordinator |

Review ran in a fresh agent, one PR per context; it re-checked the delta
after the author applied its named changes. Verdict attached to the PR
as comment and review.

## Findings count

4 total: 0 fixture disagreements, 0 scope deviations, 2 named changes
(a README row misdescribing maya-orient's writes; a garbled sentence),
2 advisory (README overstates the CI version gate; summary presented a
proposed ADR as settled — fixed). None blocking after the changes.

## Process findings

- **The review round-trip worked across contexts.** Author (ended) was
  resumed with the two named changes only, applied them, ended again;
  the reviewer re-checked the delta cold. No coordinator reading of the
  diff was needed.
- **The version-bump CI step punishes fix commits.** A follow-up commit
  on a plugin PR fails the branch-push run unless it also bumps, so the
  reviewer required a squash. Either the plan states "one commit per
  plugin package" or `validate.yml` should diff against the merge base
  on push events too. Story-worthy; ties to the wave-1 lesson.
- Board moves still deferred to the GraphQL reset.

## Story closure

Story #43 closed 2026-09-26 with a demonstration comment: acceptance demonstrated
against `main`: the four skill criteria (implement, plan, fleet+review,
orient/spec/record) landed in 8d76119 and 6b34e98, the README and
release in #53; validate workflow green. The closing comment on #43
states this per ADR 0013.
