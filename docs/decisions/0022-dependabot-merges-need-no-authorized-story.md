# 0022. Dependabot merges on a green suite need no authorized story

- Status: accepted
- Date: 2026-09-27
- Implementation: #61
- Binds: maya-review, maya-fleet

## Context

ADR 0017 sets three human gates. Its G2 gate says: "Autonomous work
happens only on a story carrying the `authorized` label, applied by the
Maintainer." The same ADR also lists, among the things agents do on their
own: "Dependabot merges, majors included, when the target repo's full
suite runs and passes — a repo whose suite is absent, skipped or red
queues instead."

A Dependabot pull request belongs to no story, so the two clauses
disagree about whether an agent may merge one. The plan for reviewing
pull requests outside a wave (story #61) found the conflict and chose the
safe reading until the Maintainer decided: no agent merges one. Six
Dependabot pull requests were open across the Maya repos on 2026-09-27.
Under that reading every one of them waits on the Maintainer, which is
the touchpoint ADR 0017 set out to remove.

ADR 0014 sets Dependabot's normal schedule: monthly, minor and patch
updates grouped into one pull request, and majors as individual pull
requests. Security updates arrive outside that schedule.

## Decision

An agent may merge a Dependabot pull request, majors included and in
every Maya repo, without any story carrying the `authorized` label, when
all of these hold:

- every commit on the pull request's branch is authored by
  `dependabot[bot]`;
- every check that runs on the pull request completes and passes, and at
  least one of them runs the repo's test suite on the `pull_request`
  event;
- the diff changes only version strings under `dependencies`,
  `devDependencies` or `peerDependencies` in `package.json`, lockfiles,
  and `uses:` version pins in `.github/workflows/`.

Anything else is queued for the Maintainer: a repo whose suite is absent,
skipped, red or not run on pull requests, a failing check of any kind, or
a diff outside those lines. The merge happens only inside a session the
Maintainer started (ADR 0017: "autonomy executes during sessions, kicked
off by the Maintainer"). Every other pull request outside a wave still
needs the Maintainer to merge it.

## Consequences

Routine dependency updates stop waiting on the Maintainer, and the
Maintainer sees only the ones that fail. The G2 gate now has one stated
exception, limited to one bot and to version lines.

A green suite is weakest evidence where the updated library is the one
the suite depends on. A major update to a library that
maya-date-fixtures uses to read its own fixture files (js-yaml, in PR
#14 on 2026-09-27) can merge on green, even though the new version is
then checking itself. If it reads a value differently and the schema
still accepts it, the reference data every implementation is tested
against changes with no human review. The Maintainer weighed this when
deciding, and kept majors and the fixtures repo in scope. The same risk
applies to majors in a repo with thin tests, as ADR 0017 already says.
Wave telemetry (ADR 0012) and the correctness suite's own differential
runs are how a bad merge is caught.

Two repos can merge nothing yet. maya-date-parser's CI runs only on
`push`, on Node 8, 10 and 12, so its Dependabot pull requests are never
green on `pull_request`. maya-calculator has no GitHub workflow. Both
queue every update until their CI is modernised, which is a separate
story.

A merge in maya-dates can make release-please open a release pull
request. Merging that release pull request stays with the Maintainer
(ADR 0017, G3), so no dependency update reaches npm without them.

The sweep in story #61 must check the commit authors, the checks and the
changed lines before it merges, and it must post its verdict comment
either way, so each merge is on record. Task #63 as filed says no agent
merges any pull request outside a wave, so it must be re-planned to
allow this one case before it is dispatched.
