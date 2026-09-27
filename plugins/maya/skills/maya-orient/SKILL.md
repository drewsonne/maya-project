---
name: maya-orient
description: Load the current state of the Maya dates project (drewsonne/maya-*) — repo map, work in flight, blockers, and a few sized next actions. Use when picking the project back up or asking where things stand.
---

# Orient on the Maya dates project

Orient runs in a fresh sub-agent context and returns only its report: the invoking context receives the report and nothing else orient read. Read-only, except for the ADR 0019 board reconciliation in step 5. This skill builds a picture of where the project stands. It does not start work, write code, or create issues.

## 1. Check prerequisites

Run `gh auth status`. If `gh` is missing or unauthenticated, say so and stop — everything below depends on it. If the `project` scope is absent, note that the board section will be skipped and carry on.

## 2. Discover the repos

```
gh repo list drewsonne --limit 200 \
  --json name,description,primaryLanguage,pushedAt,isArchived \
  --jq '[.[] | select(.name | startswith("maya")) | select(.isArchived == false)]'
```

Identify the hub repo — the one containing `docs/STATE.md`. Check; do not guess.

## 3. Read the hub

- `docs/STATE.md` — the narrative of where things are.
- `docs/product/prd.md` — only the purpose line under its title, for the first line of the report. Do not read the rest.
- `docs/decisions/` — list the newest 5 filenames. Read one only if it bears on an open thread.
- `docs/roadmap.md`, if present.

## 4. Pull live work state

- Open issues per repo: `gh issue list --repo drewsonne/<name> --state open --json number,title,labels,updatedAt`
- Hierarchy, per ADR 0009: epics on the hub (`gh issue list --repo <hub> --label epic`), each with its story/task rollup — report in-flight work grouped by epic where the hierarchy exists.
- Board, if the scope allows: `gh project list --owner drewsonne`, then `gh project item-list <n> --owner drewsonne --format json`
- Waiting on the Maintainer: open PRs assigned to the Maintainer across the maya repos, `gh search prs --owner drewsonne --assignee <login> --state open --json repository,number,title,url --jq '[.[] | select(.repository.name | startswith("maya"))]'`, where `<login>` is the owner of the hub repo. `gh search` sends one GraphQL introspection call before its REST search; if the GraphQL budget is spent, run the same search on REST alone: `gh api -X GET search/issues -f q='is:pr is:open user:drewsonne assignee:<login>' --jq '[.items[] | select(.repository_url | test("/maya[^/]*$")) | {number, title, html_url}]'`.
- Recent activity: `git log --oneline -10` for a local clone, otherwise `gh api repos/drewsonne/<name>/commits --jq '.[0:10] | .[] | .commit.message'`
- Pull requests outside a wave (defined in maya-review): `gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' -f per_page=100 --jq '[.items[] | select(.repository_url | test("/maya[^/]*$")) | select(.repository_url | endswith("/maya-project") | not) | select((((.body // "") | test("Closes drewsonne/maya-project#[0-9]+")) and (.user.login == "drewsonne")) | not) | {repo: (.repository_url | split("/") | .[-1]), number, author: .user.login, assignees: [.assignees[].login], title}]'`

## 5. Reconcile the board (ADR 0019)

Reconciliation runs in its own fresh context and returns the list of
corrections, which orient includes in its report. That context compares
the Maya Dates board (drewsonne project 2) against actual issue and PR
state: closed items not at Done, open PRs missing from the board,
statuses behind reality. It corrects each through
`scripts/board-status.sh` and reports what was corrected. A drift it
cannot explain is a finding, not a silent fix. The board never commands
— reconciliation flows reality → board only.

## 6. Report

Under ~250 words. The first line quotes the purpose line of `docs/product/prd.md` verbatim — the one-line statement under its title — or states that the PRD has no purpose line. Then four sections:

**Repo map** — one line each: name, what it does, language, last touched.

**In flight** — open PRs, branches ahead of main, anything at Status=In progress, and the list of board corrections returned by step 5. If nothing is in flight, say so plainly.

**Blocked or waiting** — issues labelled `blocked`, STATE.md items waiting on something external, and every PR from the step 4 assignee query, each reported as waiting on the Maintainer. Each pull request outside a wave that is not reviewed (as maya-review defines it: assigned to the Maintainer, with its most recent "Review verdict:" comment naming its current head SHA) is reported as "not yet reviewed", using the commands maya-review gives for the head SHA and the verdict lines; past five such pull requests, give their count and name the repos.

**Three things you could do next** — each with a size (XS/S/M/L), the repo it lives in, and one sentence on why it is worth doing now. Order by leverage, not by age. Include at least one XS or S option. When at least one pull request outside a wave is not yet reviewed, one of the three is a maya-review sweep of them, size S for up to five pull requests and M for more.

**Retro due.** When a retro is due, one of the three next actions is "Run a retro (`maya-retro`)", sized S, in the hub repo. A retro is due when either holds: three or more waves have been collected since the last retro; or fourteen or more days have passed since the last retro and at least one wave was collected in that time. The last retro is the newest `docs/retros/YYYY-MM-DD.md` on `main`; with none, the period starts 2026-09-13, the PRD interview. A wave counts as collected on the date its report in `docs/waves/` was first committed to `main`. The command below, run from the root of a hub clone, prints the figures and exits 0 exactly when a retro is due; if it prints nothing on stdout (outside a hub clone, or the fetch failed), say the check was skipped. The fetch only updates remote-tracking refs, so orient stays read-only. Orient reports that a retro is due; it never runs one.

```
git remote get-url origin | grep -qE '[:/]drewsonne/maya-project(\.git)?$' && git fetch -q origin main && { last=$(git ls-tree --name-only origin/main docs/retros/ | sed 's#^docs/retros/##' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' | sort | tail -1 | cut -c1-10); last=${last:-2026-09-13}; waves=0; for w in $(git ls-tree --name-only origin/main docs/waves/); do d=$(git log origin/main --diff-filter=A --format=%cs -- "$w" | tail -1); [[ "$d" > "$last" ]] && waves=$((waves+1)); done; days=$(( ( $(date -u +%s) - $(date -u -j -f %Y-%m-%d "$last" +%s 2>/dev/null || date -u -d "$last" +%s) ) / 86400 )); echo "last=$last waves=$waves days=$days"; [ "$waves" -ge 3 ] || { [ "$days" -ge 14 ] && [ "$waves" -ge 1 ]; }; }
```

The report follows the Writing for the Maintainer rule below.

**Writing for the Maintainer.** Write text the Maintainer reads (a report, a verdict comment, a wave report, a pull request description, `docs/STATE.md`) in plain language:
- Put what the Maintainer needs to know or do first.
- Use short sentences, one idea each, and everyday words.
- Say what each issue or PR is, not only its number: "fixtures #16 (rollover vectors)", not "#16".
- The first time an ADR, gate or label appears, explain it in a few words: "ADR 0017 (when agents may merge)", not "ADR 0017" or "G2".
- Use a list or a table for three or more items.
- Leave out process detail the Maintainer does not need in order to act.

## Rules

- Report findings; do not infer progress from absence of evidence. "No commits in six weeks" is a fact. "The project has stalled" is a judgement — leave it out.
- If STATE.md is older than the newest commit, say the state file is stale and offer to regenerate it. Do not regenerate unprompted. A regenerated STATE.md follows the Writing for the Maintainer rule in section 6.
- Do not list every open issue. Past ~8, give the count and surface only what bears on the next actions.
- Do not open the calculator's source to explain what it does. Repo descriptions and STATE.md are enough for orientation.
- `correctness` work — wrong calendar maths — outranks features and chores when ordering next actions.
