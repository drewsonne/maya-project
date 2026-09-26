---
name: maya-implement
description: Craft rules for writing code in the Maya date project — fixtures first, layer discipline, test and commit conventions. Use when implementing a work package or making any change to calendar logic, and hand it to every dispatched agent.
---

# Implement a change

How work gets done here. Every agent dispatched by `maya-fleet` receives this, and so does any change made by hand. Without it each contributor invents its own conventions and the codebase drifts in six directions at once.

## One package per context

A context does exactly one package. It ends when its draft pull request is open or its stop report is filed, and it never starts a second package: not the next one in the wave, not a follow-up it noticed on the way, not a sibling that looks quick. Once the pull request is open or the report is filed, the context is finished; anything else it has seen goes into the pull request description or the stop report for whoever comes next (ADR 0021).

A dispatched agent receives only its package block, the maya-implement skill text, its path scope, the command that runs the fixtures, and the instruction to open a draft pull request and stop. Everything else the package needs is written into the package block — the story, the PRD outcome, the binding ADR clauses — so the agent never goes looking for the planner's context; there is none to find. If the block does not carry something the work needs, that is a stop condition, not an invitation to reconstruct it.

## Order of work

Never write implementation first.

1. **Read the package block** — goal, scope, contract, criteria, fixtures. If any acceptance criterion is ambiguous, stop and report it. Do not interpret an ambiguous criterion; an agent that guesses produces something that passes its own reading and fails the real one.
2. **Run the existing suite.** If it is already failing, stop and report that. Never start work on a red baseline — you will not be able to tell what you broke.
3. **Write or confirm the failing test first**, from the fixtures named in the package. Watch it fail for the right reason. A test that passes before you have implemented anything is testing nothing.
4. **Open the draft pull request at the first commit.** Commit the failing test (or, in a package with nothing to test, the first change), push the branch, and open a draft pull request against `main` whose description begins with every acceptance criterion as an unchecked `- [ ]` item, followed by `Closes drewsonne/maya-project#<task>`. Each item is ticked `- [x]` in the commit that satisfies it — update the description as that commit is pushed, not at the end — so the criteria are recited into the working context on every push and the reviewer reads what was claimed against what landed.
5. **Implement the smallest change that makes it pass.**
6. **Run the full suite**, not just your test.
7. **Re-read the acceptance criteria** and check each one explicitly, by name. Every item in the pull request checklist is either ticked by a commit that satisfies it or named in the stop report.

## Absolute rules

- **Never modify a fixture file, an expected value, or a spec's assertion to make a test pass.** If a fixture disagrees with your implementation, the fixture wins and your work is blocked — report the disagreement, do not resolve it. On a calendar tool, an expected date edited to get green is a bug shipped with a passing test attached to it, which is worse than no test at all.
- **Never modify anything listed in your package's contract.** Exported signatures, other layers, other packages.
- **Modify only paths matching your declared scope.** If the change genuinely requires touching something outside it, stop and report; do not widen your own scope.
- **Dependencies point inward only**: presentation → parsing → operations → representation. Never add an import from a lower layer to a higher one. If you need something from above, the design is wrong — report it.
- **Touch only contract-listed dependencies** (ADR 0014). Adding, removing or bumping any package dependency — dev or runtime — that your package block's contract does not name is a blocked finding, not a judgement call. Caret ranges in `package.json`, committed lockfile, `npm ci` in CI.

## Calendar logic in particular

This is where the project's value and its risk both sit.

- Any change to Long Count, Calendar Round, Tzolk'in, Haab, day-number or correlation-constant arithmetic requires fixture coverage first. If none exists, stop: the package should have depended on a fixture package.
- Prefer direct arithmetic to progressive subtraction. `Math.floor(n / 20) % 18` is verifiable by inspection; `(total - this.total()) / 20 % 18` is not, and the second form is a known source of error in this codebase.
- Winal is base-18. Every other position is base-20. Write it explicitly rather than relying on a shared constant that hides the exception.
- Never silently normalise out-of-range input inside a function that is documented as strict, or raise inside one documented as lenient. If the intended behaviour is unclear, it is an open question for `maya-record`, not a judgement call.

## Conventions

The tooling lines below apply only to repos that use them: confirm against the target repo's `package.json` before relying on one, and if the runner, assertion library or coverage tool named here is not in that file, use what is — a hub repo of skills and ADRs has no mocha to run.

- TypeScript packages: specs live beside their source as `*.spec.ts`, or under `src/__tests__/`. Run with `mocha -r ts-node/register 'src/**/*.spec.ts'`. Assertions use chai. Coverage via `nyc`.
- The legacy app uses jest until it is migrated.
- Value objects in the representation layer are immutable. Declare fields `readonly`; do not add setters.
- Import from package roots, never deep paths (`@drewsonne/maya-dates`, not `@drewsonne/maya-dates/lib/lc/long-count`).
- Public API changes are semver events. Removing or changing an export is a major bump and needs an ADR, not a commit message.
- Code comments and commit messages are English, whatever the documentation policy says about prose.

## Commits and pull requests

- Conventional prefixes: `feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `chore:`.
- One logical change per commit. A commit that both moves code and changes behaviour cannot be reviewed or reverted — split it.
- Reference the package id and issue number in the body. Issues live on the hub (ADR 0009): from a satellite repo, close the task with the full cross-repo form `Closes drewsonne/maya-project#N` — a bare `Closes #N` there closes nothing.
- Open a **draft** pull request. Never merge, never push to `main`.
- The PR description states: the package id, which acceptance criteria are met, which fixtures now pass, and anything you were blocked on. Do not describe the diff — it is visible. The acceptance-criteria checklist opened in step 4 is how "which criteria are met" is stated; keep it current rather than restating it in prose.

## Stop report

A stop report is the artifact a context leaves when it cannot finish. Its shape is fixed; it has exactly these fields, in this order, and no others:

```
package:       <package id>
step reached:  <the numbered step of "Order of work" the context was on when it stopped>
attempted:     <what was tried at that step, concretely: the command, the edit, the test>
failed:        <what broke, quoting the output, the disagreeing fixture, or the ambiguous criterion>
branch:        <the branch name, and whether it is pushed and whether a draft PR is open>
question:      <the one decision someone else must make before the work can resume>
```

A fresh context must be able to resume from it without the author's context: the report names the step to pick up at, the branch to check out, and the question to get answered, and it quotes rather than summarises whatever failed, because the reader has not seen the transcript and never will. A report that says "tests failed" or "criterion unclear" without the output or the criterion is not resumable and has to be redone. File it on the draft pull request if one is open, otherwise as a comment on the task issue, and end the context there — the report is the context's last act, not a note before continuing.

## When to stop

Stop and file a stop report, rather than pressing on, if: the baseline suite is red, a fixture disagrees with your implementation, an acceptance criterion is ambiguous, the change needs to escape its scope or contract, or the work reveals a decision nobody has made. The stop report (shape above) is the required output of every one of those conditions — a context that meets one and stops without filing it has not stopped, it has vanished. Each of those is a finding worth more than a completed package built on a guess.
