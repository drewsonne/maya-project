# Design: `maya-retro`, a periodic look at what is working

Date: 2026-09-27. Status: approved by the Maintainer on 2026-09-27, after
agreeing it section by section in one session.
Nothing here is in force until ADR 0024 (below) is accepted and the
story that implements it is done.

## For the Maintainer

This adds a ninth skill, `maya-retro`. Every so often, `maya-orient` says
a retro is due. When you run it, it scores two things with equal weight
— how well the process ran and how far the product moved — compares
both with the last retro, has a fresh agent challenge its conclusions,
then asks you only product, strategy and vision questions. It fixes
process problems itself by filing stories it may authorize, within a
guard you set once through ADR 0024.

Your action: merge to keep the design on `main`. The decision itself is
ADR 0024 (PR #77); the work is story #76.

## What the Maintainer asked for

Said on 2026-09-27:

- A way for the skills to understand what worked and what did not, and
  to revise the work periodically.
- Questions to the Maintainer are fine, but only about **product,
  strategy and vision** — never implementation or project management.

Chosen in the same session, one question at a time:

| question | answer |
|---|---|
| What is "worked" measured against? | Process and product, weighted equally: two scorecards |
| How far may the retro go on a process problem without the Maintainer? | File the fix as a story **and pre-authorize it** |
| How are product questions asked? | Live, when the Maintainer runs the retro |
| Shape | A new skill; `maya-orient` only says when one is due |

## What exists already

- **ADR 0012** makes every wave commit a report as "process telemetry" so
  that tuning can "cite wave reports instead of memory". Nothing reads
  those reports yet. The retro is their reader.
- **PRD §6** gives a binary product test: the app reproduces every
  citation-backed fixture vector with zero failures.
- **ADR 0017** sets the gates; G2 says the `authorized` label is "applied
  by the Maintainer".
- **ADR 0023 (proposed, PR #71)** makes the moments the Maintainer is
  asked a closed whitelist of hard gates; G2 there is "applying
  `authorized` to a new story", and G1 includes "the product's purpose
  or spec".
- **Story #66** files questions for the Maintainer as `question` issues.
- **ADR 0020** requires adversarial review; **ADR 0021** one unit of work
  per context.

gstack's `/retro` was looked at and is not called: it measures commit
streaks and output rates for one developer. The only idea taken from it
is comparing each retro with the saved previous one.

## 1. When it runs

`maya-orient` adds **"Retro due"** as one of its three next actions,
sized S, when either holds:

- three or more waves have been collected since the last retro, or
- fourteen or more days have passed since the last retro and at least
  one wave was collected in that time.

"The last retro" is the newest file in `docs/retros/`; with none, the
period starts at the PRD interview, 2026-09-13. Orient reports that a
retro is due; it never runs one. The retro runs only when the Maintainer
invokes it, in a live session.

## 2. Steps

One retro per context (ADR 0021).

1. **Gather.** A fresh agent reads the period's evidence — wave reports,
   pull requests and their review verdicts, stop reports, hub git
   history, the fixture suite's results — and returns the tables below
   and nothing else.
2. **Score.** Build the process and product scorecards; set each figure
   against the previous retro's as better, worse or unchanged.
3. **Challenge.** A fresh devil's-advocate agent (ADR 0020) attacks every
   "worked" and "did not work" claim. A claim that does not survive is
   dropped or marked disputed.
4. **Ask.** Show both scorecards in plain language; interview the
   Maintainer (section 5).
5. **Act.** Commit the retro report (section 6); file process stories
   (section 7); file follow-up stories for `maya-spec` (PRD changes) and
   `maya-record` (decisions). The retro does not run those skills.

## 3. Process scorecard

From existing evidence only; nothing new is logged.

| measure | what it tells us | good direction |
|---|---|---|
| Review queue: PRs waiting on the Maintainer, and the oldest one's age | Whether the old failure (eleven PRs unmerged for eight months) is returning | fewer, younger |
| Draft to merge: median days from a PR opening to its merge | How fast finished work lands | shorter |
| First-pass rate: share of packages ending `ok`; verdicts split merge / merge after named changes / reject and re-plan | Whether packages were planned and built well first time | higher |
| Stop reports: count, grouped by cause (ambiguous criterion, fixture disagreement, scope, undecided question) | Planning defects | fewer; no repeated cause |
| Repeat findings: the same kind of review finding on three or more PRs, or in two retros running | Where a skill's wording is not landing | none |
| Guardrail breaches: fixture edits, scope violations, an author reviewing their own work | Whether the hard rules hold | zero; any breach is serious |
| Process share: share of hub commits and PRs that are process (ADRs, skills, plans, board) against product (fixtures, libraries, app) | How much effort goes to running the machine | not scored; shown as a trend and asked about |

A measure is **working** when it held or improved against the previous
retro; **not working** when it worsened or a problem occurred twice. A
single bad event is noted, not acted on. The first retro has no previous
figures and reports levels only.

## 4. Product scorecard

Distance to the PRD §6 success test.

| measure | what it tells us |
|---|---|
| Sourced vectors, by provenance (attested, derived, unverified) and by area (winal rollover, proleptic Gregorian, Haab convention, Calendar Round ambiguity, correlation constants, distance numbers, rejection cases) | How complete the yardstick is; an area with no attested vector is a blind spot |
| Pass rate against each surface: libraries, app | The success test itself; an app not yet running the suite is shown as "not wired", never omitted |
| PRD outcomes touched: which had merged work in the period, which had none | Whether effort is spread across what the product promises |
| Epigrapher-visible changes: merged work that passes the epigrapher test from `maya-spec` | Whether the product changed from the user's side |
| Open correctness bugs: count and age | Wrong arithmetic, which outranks everything |

Each is compared with the previous retro, as in section 3.

## 5. The interview

**The filter.** A question is asked only if its answer could change what
the product is, who it is for, or what the project does next, and only
the Maintainer can give it. A question about how, when, which package or
which tool fails the filter: the retro decides it or turns it into a
process story.

**The questions,** one at a time, about five per retro:

1. Direction — "Here is what moved and what did not. Is this the
   direction you want for the next period?"
2. Balance — "X% of the effort went to process. Is that the right balance
   for now?"
3. The user — "Is the epigrapher checking their own working still who
   this is for? Have you seen or heard anything that changes that?"
4. The test — "Is 'the app passes every sourced vector' still the right
   success test?" Asked especially when the test is near or has stalled.
5. Next outcome — "These PRD outcomes had no work this period. Which
   matters most next?"

Plus at most two questions from this retro's own findings (for example,
"Haab convention has no attested vectors. Does it matter to the user
yet?").

**Answers** are recorded in the retro report in the Maintainer's words.
"No change" is an answer and is recorded, so the next retro sees the
direction held. An answer that changes the PRD becomes a story for
`maya-spec`; one that settles a decision becomes a story for
`maya-record`. A skipped question is marked unanswered and may be asked
again next time. Because the Maintainer is present, answers are not
filed as `question` issues; this is an exception to story #66, stated in
ADR 0024.

## 6. The retro report

`docs/retros/<YYYY-MM-DD>.md`, committed to the hub by pull request like
a wave report, in this order:

1. **For the Maintainer** — what changed since last time and what, if
   anything, the Maintainer needs to do (the Writing for the Maintainer
   rule).
2. **Process scorecard** — each figure with better / worse / unchanged.
3. **Product scorecard** — likewise.
4. **Claims and challenges** — each claim and whether it survived.
5. **Interview** — each question and the answer as given; skipped ones
   marked unanswered.
6. **Actions** — process stories filed (linked), follow-ups for
   `maya-spec` and `maya-record`.

The next retro reads the previous report for its comparison figures; the
reports are the retros' history.

## 7. ADR 0024: a retro may authorize process fixes

ADR 0024 as drafted (PR #77) governs where it differs from this section:
its critique added limits — only new stories, only when a retro was due,
none if the Maintainer says process share is too high, a list shown before
the session ends, and the guard re-checked by `maya-plan` and `maya-review`.

Drafted through `maya-record` with its devil's-advocate critique; it
changes the gates, so only the Maintainer accepts it. It amends ADR 0023
if 0023 is accepted, otherwise ADR 0017.

- **The interview is a whitelisted moment.** The retro interview joins
  G1: the Maintainer is asked product, strategy and vision questions at
  a retro they run.
- **Pre-authorization.** A process story filed by a retro the Maintainer
  ran live is labelled `retro` and `authorized` when filed. It then
  flows through `maya-plan` and `maya-fleet` like any authorized story.
  The Maintainer revokes one by removing the label, as today. Accepting
  this ADR is the Maintainer's explicit, standing input for these
  stories; they are not asked about each one.
- **The guard.** A retro never authorizes a story that:
  - loosens a safeguard — the fixture rule, citation rules, author ≠
    reviewer, adversarial review, the merge conditions;
  - touches the gates, the whitelist, agent permissions, or the retro's
    own powers;
  - needs a new or changed ADR other than a process ADR that ADR 0023
    lets an agent accept;
  - changes product scope.

  Such a story is still filed, without `authorized`.
- **Cap.** At most three authorized process stories per retro, and only
  for a pattern (a measure not working, section 3) with its evidence
  cited in the story.
- **Unchanged.** Merges follow the existing clean-merge rule; releases
  follow G3 as ADR 0017 and 0023 set them.

## 8. Other changes that go with it

- `plugins/maya/skills/maya-retro/SKILL.md` — the new skill, carrying the
  Writing for the Maintainer rule word for word as the other skills do.
- `maya-orient` — the "Retro due" rule in its next-actions section.
- `plugins/maya/skills/README.md` — the ninth skill in the table and the
  chain diagram.
- `plugins/maya/.claude-plugin/plugin.json` — a version bump (CI requires
  one with any skill change).
- `docs/retros/` — created with a one-line README.

## Acceptance (demonstrated against `main`, ADR 0013)

- `plugins/maya/skills/maya-retro/SKILL.md` exists and names: the two
  scorecards with every measure in sections 3 and 4; the five steps; the
  interview filter as fixed text; the report sections in order; the cap
  of three authorized stories; the guard list.
- `maya-orient` contains the "Retro due" rule with both thresholds.
- ADR 0024 is accepted and `docs/decisions/` carries its critique.
- The first retro runs live with the Maintainer and commits
  `docs/retros/<date>.md` with all six sections; every question it asked
  passes the filter, and the Maintainer confirms none was about
  implementation or project management.
- Any process story the first retro authorized carries both `retro` and
  `authorized`, cites its evidence, and falls outside the guard list.

## Not in this design

- **Quoted evidence for `maya-review` findings** (a finding is reported
  only with the line that motivates it quoted). Filed as its own story;
  also a natural thing for the first retro to rediscover.
- **Blocking out-of-scope edits at write time** (a per-worktree hook
  checking an agent's path globs). Its own design later.
- Scheduled or unattended retros. ADR 0017's trigger model allows no
  background execution, and the Maintainer chose live.

## Risks

- **The fixer feeds itself.** A machine that authorizes its own process
  stories could raise the share of effort going to process. The cap, the pattern-only rule and the
  balance question each push back; the balance question puts it in front
  of the Maintainer every time.
- **Self-praise.** The retro judges the process that runs it. The
  devil's-advocate step and the rule that a claim needs evidence are the
  check.
- **Thin evidence early.** With few waves, most measures have one or two
  data points. The first retros report levels and say so, rather than
  claim trends.
