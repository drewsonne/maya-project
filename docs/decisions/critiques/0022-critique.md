# Critique of ADR 0022 — devil's advocate (ADR 0020, stage 5)

Date: 2026-09-27. A fresh agent read the draft cold and checked it
against the open pull requests and each repo's CI workflows. The
disposition of each point is at the end.

## 1. What breaks if the decision is wrong

The only Dependabot PR the rule would merge today is the most dangerous
one. maya-date-fixtures #14 bumps js-yaml from 4 to 5, a major version,
and `scripts/validate.js` uses js-yaml to read every fixture file. So
the new library is checked by itself. If version 5 reads a value
differently and the schema still accepts it, the reference data changes
silently.

"Full suite" was undefined. On #14, `validate` passes and `claude-review`
fails. maya-date-parser's CI runs only on `push`, on Node 8, 10 and 12,
so its PRs are red. maya-calculator has no workflow. The fixtures `main`
branch has no branch protection.

The file check could be defeated. A `package.json` change can alter
`scripts` (for example `postinstall`), a workflow edit can change what
the suite runs, and an author check on the PR alone misses commits
pushed onto a Dependabot branch by someone else.

## 2. Who is harmed if it is right

Downstream npm users, since maya-dates marks production bumps `fix:` and
release-please then proposes a release. The draft's count of open
Dependabot PRs was seven; it is six. The parser PRs are security updates,
which ignore ADR 0014's monthly schedule.

## 3. Strongest counter-argument

ADR 0017's G2 gate exists because a green suite is not proof of
correctness, and that matters most for majors and in the fixtures repo.
Allow minor and patch on green, and queue every major.

## Disposition

- **Scope (queue majors and the fixtures repo): not adopted.** The
  Maintainer was shown this point with the js-yaml example and chose to
  keep majors and every repo in scope. The risk is written into the
  Consequences instead.
- **"Full suite" undefined: adopted.** Every check must pass, and one
  must run the suite on `pull_request`. On 2026-09-27 this queues #14
  (its `claude-review` fails) and every parser PR.
- **File check defeatable: adopted.** Only version strings in dependency
  sections, lockfiles, and `uses:` pins; every commit authored by
  `dependabot[bot]`.
- **Count and security updates: adopted.** Context corrected.
- **npm release: answered.** Merging only makes release-please open a
  release PR, whose merge stays with the Maintainer (G3). Stated in the
  Consequences.
- **Modernise parser and calculator CI: noted** in the Consequences as a
  separate story.
- **Branch protection on fixtures `main`:** not addressed by this ADR.
