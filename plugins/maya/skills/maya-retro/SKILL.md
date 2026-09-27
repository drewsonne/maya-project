---
name: maya-retro
description: Run a periodic retro of the Maya dates project live with the Maintainer. Scores how well the process ran and how far the product moved, compares both with the last retro, asks only product, strategy and vision questions, and files stories that fix process problems. Use when maya-orient says a retro is due, or the Maintainer asks for one.
---

# Run a retro

A retro looks back over a period of work and asks two things: how well the process ran, and how far the product moved. It compares both with the last retro, asks the Maintainer only product, strategy and vision questions, and files stories that fix process problems. ADR 0012 makes every wave commit a report so that tuning can cite wave reports instead of memory; this skill is the reader of those reports.

## When it runs

The retro runs only when the Maintainer invokes it, in a live session. There are no scheduled or unattended retros. `maya-orient` says when one is due and never runs one.

Run the retro due check first, from the root of a hub clone:

```
git remote get-url origin | grep -qE '[:/]drewsonne/maya-project(\.git)?$' && git fetch -q origin main && { last=$(git ls-tree --name-only origin/main docs/retros/ | sed 's#^docs/retros/##' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' | sort | tail -1 | cut -c1-10); last=${last:-2026-09-13}; waves=0; for w in $(git ls-tree --name-only origin/main docs/waves/); do d=$(git log origin/main --diff-filter=A --format=%cs -- "$w" | tail -1); [[ "$d" > "$last" ]] && waves=$((waves+1)); done; days=$(( ( $(date -u +%s) - $(date -u -j -f %Y-%m-%d "$last" +%s 2>/dev/null || date -u -d "$last" +%s) ) / 86400 )); echo "last=$last waves=$waves days=$days"; [ "$waves" -ge 3 ] || { [ "$days" -ge 14 ] && [ "$waves" -ge 1 ]; }; }
```

It prints the last retro's date, the waves collected since then and the days since then, and exits 0 when a retro is due; if it prints nothing, the check was skipped. The line it printed goes in the report's "For the Maintainer" section. A retro that was not shown due still runs if the Maintainer asked for it, but it authorizes nothing.

## One retro per context

A context runs one retro and then ends (ADR 0021: a context does one unit of work). Gathering and challenging are each done by a fresh agent that the retro dispatches. The retro context consumes their tables and never reads raw evidence itself.

## 1. Gather

Dispatch a fresh agent to read the period's evidence, from the last retro's date to today. It returns the figures for the two scorecard tables, each with the wave report, pull request, commit or fixture file it came from, and nothing else. Nothing new is logged: evidence comes only from what already exists.

Its sources:

- **Wave reports**: the files in `docs/waves/` committed in the period, with their outcomes (`ok | blocked | failed`), review verdicts, and stop reports under `notes`.
- **Pull requests** on every non-archived `drewsonne/maya*` repo opened, merged or open in the period, with their review verdict comments.
- **The hub's git history.**
- **The fixture dataset** in `drewsonne/maya-date-fixtures`. Every file under `fixtures/` is a YAML list of records, each with a `provenance:` of `attested`, `derived` or `unverified`.

How the product figures are read:

- **Areas map to fixture files**: winal rollover `positional-rollover.yaml`, proleptic Gregorian `proleptic-western.yaml`, Haab convention `haab-seating.yaml`, Calendar Round ambiguity `calendar-round-ambiguity.yaml`, correlation constants `correlation-constants.yaml`, distance numbers `distance-numbers.yaml`, rejection cases `rejection.yaml`. Any other file is reported under its own name.
- **Pass rate**: a surface with no CI job running the fixture suite against it is "not wired". On 2026-09-27 neither the libraries nor the app has one; hub task #8 builds the library harness.
- **PRD outcomes** are the hub's epics (label `epic`). Work counts for an outcome when a pull request merged in the period closes a task under one of its stories.
- **Epigrapher-visible changes** use the epigrapher test from `maya-spec`: a change counts when it can be justified in one sentence to a working epigrapher checking their own arithmetic. List each with that sentence.
- **Open correctness bugs** are open issues labelled `correctness` or `bug` on any maya repo, with the oldest one's age. A repo with neither label is reported as "no bug label", not as 0.

## 2. Score

Set each figure against the previous retro's report as better, worse or unchanged. A measure is **working** when it held or improved against the previous retro, and **not working** when it worsened or a problem occurred twice in the period. A single bad event is noted, not acted on. The first retro has no previous figures, so it reports levels only and says so.

### Process scorecard

| measure | what it tells us | good direction |
|---|---|---|
| Review queue: PRs waiting on the Maintainer, and the oldest one's age | Whether the old failure (eleven PRs unmerged for eight months) is returning | fewer, younger |
| Draft to merge: median days from a PR opening to its merge | How fast finished work lands | shorter |
| First-pass rate: share of packages ending `ok`; verdicts split merge / merge after named changes / reject and re-plan | Whether packages were planned and built well first time | higher |
| Stop reports: count, grouped by cause (ambiguous criterion, fixture disagreement, scope, undecided question) | Planning defects | fewer; no repeated cause |
| Repeat findings: the same kind of review finding on three or more PRs, or in two retros running | Where a skill's wording is not landing | none |
| Guardrail breaches: fixture edits, scope violations, an author reviewing their own work | Whether the hard rules hold | zero; any breach is serious |
| Process share: share of merged PRs on the hub (process) against merged PRs on every other maya repo (product), Dependabot excluded | How much effort goes to running the machine | not scored; shown as a trend and asked about |

### Product scorecard

| measure | what it tells us |
|---|---|
| Sourced vectors, by provenance (attested, derived, unverified) and by area (winal rollover, proleptic Gregorian, Haab convention, Calendar Round ambiguity, correlation constants, distance numbers, rejection cases) | How complete the yardstick is; an area with no attested vector is a blind spot |
| Pass rate against each surface: libraries, app | The success test itself; an app not yet running the suite is shown as "not wired", never omitted |
| PRD outcomes touched: which had merged work in the period, which had none | Whether effort is spread across what the product promises |
| Epigrapher-visible changes: merged work that passes the epigrapher test from `maya-spec` | Whether the product changed from the user's side |
| Open correctness bugs: count and age | Wrong arithmetic, which outranks everything |

## 3. Challenge

Dispatch a fresh devil's-advocate agent (ADR 0020, adversarial review), never one that gathered or scored. It attacks every "worked" and "did not work" claim against the evidence. A claim that does not survive is dropped or marked disputed.

## 4. Ask

Show both scorecards to the Maintainer in plain language, then interview them one question at a time. Every question passes the interview filter:

A question is asked only when its answer could change what the product is, who it is for, or which product outcome the project pursues next, and only the Maintainer can give it; a question about how, when, in what order, which package or which tool is decided by the retro or turned into a process story.

Ask these, in order:

1. Direction: "Here is what moved and what did not. Is this the direction you want for the next period?"
2. Balance: "X% of the effort went to process. Is that the right balance for now?"
3. The user: "Is the epigrapher checking their own working still who this is for? Have you seen or heard anything that changes that?"
4. The test: "Is 'the app passes every sourced vector' still the right success test?"
5. Next outcome: "These PRD outcomes had no work this period. Which matters most next?"

Then ask at most two more questions drawn from this retro's findings, each passing the filter above (for example "Haab convention has no attested vectors. Does it matter to the user yet?").

Question 2 (balance) is asked at every retro, before any story is filed. Record the answers in the retro report in the Maintainer's words. "No change" is an answer and is recorded. A skipped question is marked unanswered and may be asked again next retro.

Because the Maintainer is present, answers are not filed as `question` issues. This is the one exception to story #66 (questions for the Maintainer are asked as issues), stated in ADR 0024. The interview is the only moment the retro asks the Maintainer anything; showing the list of authorized stories is a statement, not a question.

## 5. Act

Do these in order:

1. File the process stories, as set out in "Authorizing process stories (ADR 0024)" below.
2. Show the Maintainer every story authorized, in plain words, and remove the label from any they strike.
3. File follow-up stories: an answer that changes the PRD becomes a story for `maya-spec`, and one that settles a decision becomes a story for `maya-record`. The retro never runs those skills.
4. Write and commit the retro report, with links to every story filed.

Every story the retro files is on the hub, labelled `story` and `retro`. It cites its evidence: the scorecard figure, and the wave report, pull request or retro report it came from. It is a sub-issue of epic #15 (the product ships through an autonomous, measured delivery pipeline) unless its outcome belongs to another open epic, and it is placed on the board in Backlog. File, attach and place each story with these commands, where `<epic>` is 15 unless another open epic owns the outcome:

```
gh issue create --repo drewsonne/maya-project --title "<title>" --body-file <body-file> --label story --label retro
gh api -X POST repos/drewsonne/maya-project/issues/<epic>/sub_issues -F sub_issue_id=$(gh api repos/drewsonne/maya-project/issues/<n> --jq .id)
scripts/board-status.sh <n> Backlog
```

The filing command passes only the `story` and `retro` labels. Any other label is added afterwards, and only as "Authorizing process stories (ADR 0024)" allows.

A story the retro files and does not authorize ends its body with the line `Filed by retro YYYY-MM-DD; not authorized.`, with the retro's date.

## The retro report

Write the report to `docs/retros/YYYY-MM-DD.md`, named by the retro's date. Its sections are these, in this order, each a `##` heading in the report:

1. **For the Maintainer**: whether the retro was due (the line the retro due check printed), what changed since the last retro, and what, if anything, the Maintainer needs to do.
2. **Process scorecard**: each figure with better, worse or unchanged against the last retro.
3. **Product scorecard**: likewise.
4. **Claims and challenges**: each claim and whether it survived the challenge.
5. **Interview**: each question and the answer as given; skipped ones marked unanswered.
6. **Actions**: process stories filed, each linked and marked authorized or not; follow-up stories for `maya-spec` and `maya-record`.

Commit it to the hub on a branch `retro-YYYY-MM-DD`, by a pull request whose description opens with a "For the Maintainer" section. Assign that pull request to the Maintainer (`gh pr edit <n> --repo drewsonne/maya-project --add-assignee <login>`, where `<login>` is the owner of the hub repo) and never merge it. The next retro reads the newest report for its comparison figures.

**Writing for the Maintainer.** Write text the Maintainer reads (a report, a verdict comment, a wave report, a pull request description, `docs/STATE.md`) in plain language:
- Put what the Maintainer needs to know or do first.
- Use short sentences, one idea each, and everyday words.
- Say what each issue or PR is, not only its number: "fixtures #16 (rollover vectors)", not "#16".
- The first time an ADR, gate or label appears, explain it in a few words: "ADR 0017 (when agents may merge)", not "ADR 0017" or "G2".
- Use a list or a table for three or more items.
- Leave out process detail the Maintainer does not need in order to act.

## Authorizing process stories (ADR 0024)

**Until ADR 0024 is accepted, a retro authorizes nothing.** ADR 0024 (a retro may authorize process fixes) lets a retro label a process story `authorized` only once it is accepted. Run the ADR 0024 acceptance check before authorizing any story. While it does not exit 0, file every process story with `story` and `retro` and without `authorized`, end its body with the line `Filed by retro YYYY-MM-DD; not authorized.`, and say in the Actions section that ADR 0024 is not yet accepted, so nothing was authorized.

```
f=$(gh api 'repos/drewsonne/maya-project/contents/docs/decisions?ref=main' --jq '[.[].name | select(startswith("0024-"))][0] // empty') && test -n "$f" && gh api -H 'Accept: application/vnd.github.raw' "repos/drewsonne/maya-project/contents/docs/decisions/$f?ref=main" | grep -qx -- '- Status: accepted'
```

Once that check exits 0, a retro may label a process story it files `authorized` as well as `retro`, but only within the limits and the guard below. The story then flows through `maya-plan`, `maya-fleet` and `maya-review` like any other authorized story.

**Limits.**

- **Only new stories.** A retro never adds `authorized` to an existing story and never widens an authorized one.
- **Only when due.** A retro authorizes only when the retro due check exited 0 at the start of this retro.
- **Only after the balance answer.** Stories are filed after the interview. If the Maintainer skips the balance question, answers that too much effort is going to process, or the answer leaves it in doubt, the retro authorizes none.
- **One authorizing retro per period.** A retro authorizes nothing if a retro already filed a story after the last retro's date (a hub issue labelled `retro` whose body has a `Filed by retro` or `Authorized by retro` line): `gh issue list --repo drewsonne/maya-project --label retro --state all --search 'created:>YYYY-MM-DD "by retro" in:body' --json number --jq length` must print 0, with the last retro's date, when checked before this retro files any story.
- **Cap.** At most three authorized stories per retro.
- **Pattern only.** Each is for a measure that worsened against the previous retro, or a problem of the same kind that occurred at least twice in the period, with that evidence cited in the story.
- **Shown before the session ends.** The retro lists, in plain words, every story it authorized before the session ends; this is a statement, not a question. One the Maintainer strikes loses the label, and its marker line is replaced with `Filed by retro YYYY-MM-DD; not authorized.`
- **The guard is checked three times.** A fresh challenge agent checks each story's guard classification before it is authorized; `maya-plan` re-checks each package; `maya-review` re-checks each pull request. A package or pull request that crosses the guard is stopped and queued for the Maintainer.

**The ADR 0024 guard.** A retro never authorizes a story that touches any of these, in either direction, loosening or tightening:
1. a gate: G1 (decide), G2 (authorize), G3 (ship), or the list of moments at which the Maintainer is asked;
2. an agent permission;
3. what an agent may merge, or what counts as a clean review verdict;
4. authorization: who or what may apply or remove the `authorized` label, and when;
5. review integrity or fixture integrity, including author ≠ reviewer, adversarial review (ADR 0020) and the rule that no agent edits a fixture or expected value;
6. a product or domain convention, for example the correlation constant or Haab numbering;
7. citation rules;
8. the retro's own powers: its guard, its cap, its limits, or anything in `maya-retro` about authorizing.
Nor does a retro authorize a story that changes product scope, or that needs any ADR other than a process ADR. A process ADR changes only how agents work and touches nothing in items 1 to 8 (ADR 0023); if ADR 0023 was rejected, no ADR counts as a process ADR. A story that crosses the guard is still filed, without `authorized`. Doubt means without.

Order: draft the stories and classify each against the guard; dispatch a fresh challenge agent with the drafts, your classifications and the guard, and have it classify each as crossing the guard or not crossing it; file every draft with `story` and `retro`; then, only for a story that both you and the challenge agent classed as not crossing the guard, and that is within the limits above, append the marker line to its body and run the authorizing command. A story either classed as crossing, or where the two disagree, is not authorized.

```
Authorized by retro YYYY-MM-DD under ADR 0024.
```

```
(f=$(gh api 'repos/drewsonne/maya-project/contents/docs/decisions?ref=main' --jq '[.[].name | select(startswith("0024-"))][0] // empty') && test -n "$f" && gh api -H 'Accept: application/vnd.github.raw' "repos/drewsonne/maya-project/contents/docs/decisions/$f?ref=main" | grep -qx -- '- Status: accepted') && gh issue view <n> --repo drewsonne/maya-project --json labels,body --jq '([.labels[].name] | index("retro")) != null and (.body | test("(^|\n)Authorized by retro [0-9]{4}-[0-9]{2}-[0-9]{2} under ADR 0024\\.\\s*$"))' | grep -qx true && gh issue edit <n> --repo drewsonne/maya-project --add-label authorized
```

The Maintainer revokes a story at any time by removing its `authorized` label. If the `retro` label is missing on the hub, create it with `gh label create retro --repo drewsonne/maya-project --description "Story filed by a maya-retro retro (ADR 0024)"`.

## Rules

- Ask only questions that pass the interview filter, and only in the interview.
- Never ask the Maintainer to approve, rank, size or schedule a story; showing the authorized stories is a statement, and the Maintainer strikes one by saying so.
- Every claim cites its evidence.
- Never run `maya-spec`, `maya-record`, `maya-plan` or `maya-fleet`.
- Never add `authorized` except by the command in "Authorizing process stories".
- Never merge the retro report's pull request; assign it to the Maintainer.
