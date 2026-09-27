---
name: maya-review
description: Review a pull request on the Maya date project against its acceptance criteria, layer rules and fixture integrity before merge. Use on agent-authored and hand-written PRs alike, especially any touching calendar arithmetic. Also runs a sweep of open pull requests outside a wave, merging only the Dependabot ones ADR 0022 allows and queuing the rest for the Maintainer.
---

# Review a pull request

The purpose is to make a merge decision defensible without reading every line. Eleven agent-authored pull requests once sat unmerged on this project for eight months because nobody could face reviewing them — the cost of review, not the cost of writing code, is what actually limits throughput here.

So this review is mechanical first and judgement second. The mechanical checks either pass or the PR is not ready, and no amount of reading compensates for one of them failing.

## One pull request per context

A reviewing context reviews exactly one pull request and then ends (ADR 0021). The reviewer carries no prior review's context: it is a fresh agent, not one that has reviewed another PR in the wave and not the author (ADR 0020). Its inputs are the diff, the package block from the hub issue the PR closes (the `Closes drewsonne/maya-project#N` in its description), and the ADR clauses that block's `binds:` field quotes. No other pull request's diff, verdict or findings is read in — a review conditioned on three earlier reviews is a weaker review of the fourth. If you are collecting a wave, dispatch one such agent per PR and consume its verdict; never review the second PR in the context that reviewed the first. For a pull request outside a wave, the inputs are those set out in "Pull requests outside a wave".

## Mechanical checks

Run all of these before forming any opinion about the code.

1. **Fixture integrity.** No change to fixture files or expected values unless the PR's stated purpose is adding fixtures. A PR that changes an expected value while also changing implementation is rejected on sight, regardless of whether tests pass. Do not evaluate the reasoning offered for it.
2. **Scope.** Changed paths against the package's declared scope. Anything outside it is a finding.
3. **Contract.** Nothing listed in the package's contract has changed. Check exported signatures specifically, not just files.
4. **Layer direction.** No new import from a lower layer to a higher one. Presentation → parsing → operations → representation, inward only.
5. **Suite.** Full suite green on the branch, not just the tests the PR added. Check that a new test actually fails without the implementation — a test that passes either way is decoration.
6. **Acceptance criteria.** Walk each one by name and state met, not met, or unverifiable. An unverifiable criterion is a planning defect to record, not something to wave through.

Report these as a list with verdicts. If any fails, say which and stop — do not continue into code review to soften the result.

## Adversarial pass (ADR 0020)

Runs alongside judgement, in a **fresh agent that reads the diff cold**
— never the author, never an agent carrying the author's context.

- **Bad faith.** Assume the diff games its criteria. Check each new
  test fails without the implementation; look for weakened assertions,
  letter-not-spirit compliance, and changes hidden in mechanical noise.
- **Citation audit** (any PR touching attested vectors): re-fetch each
  claimed source and try to refute the value and the citation. A
  citation to an unfetchable source is itself a finding.
- **Tiered intensity**: for calendar arithmetic or attested fixtures,
  findings survive only a three-refuter majority panel; elsewhere a
  single adversary suffices.

Adversarial findings are **advisory**: attach them to the PR and the
queue, but they do not change the verdict or block a clean merge
(Maintainer's choice, ADR 0020). Never soften or omit one because it
cannot block.

## Judgement

Only once the mechanical checks pass.

- **Is the arithmetic verifiable by inspection?** Prefer direct division to progressive subtraction. If you cannot confirm a calculation by reading it, say so — that is a finding even when the tests pass, because the next person will not be able to either.
- **Does anything here encode a decision nobody made?** A default value, a rounding convention, a chosen correlation constant, a Haab coefficient convention. These arrive silently in implementation and are the most expensive thing to discover later. Route each to `maya-record`.
- **Is the change the smallest one that satisfies the criteria?** Extra refactoring bundled in is not a bonus; it is unreviewable surface. Ask for it to be split.
- **Would an epigrapher notice this?** Not a blocker — plenty of necessary work is invisible to users. But if a PR is large and the answer is no, say so plainly.

## Output

One verdict, chosen explicitly: **merge**, **merge after named changes**, or **reject and re-plan**.

Then at most five findings, most serious first, each naming the file and line. Do not pad the list to look thorough — a review with one real finding and a merge verdict is a good review.

The verdict and findings follow the Writing for the Maintainer rule below wherever the Maintainer reads them: in the review output, in any verdict comment on the pull request, and in the comment that queues a pull request for the Maintainer.

**Writing for the Maintainer.** Write text the Maintainer reads (a report, a verdict comment, a wave report, a pull request description, `docs/STATE.md`) in plain language:
- Put what the Maintainer needs to know or do first.
- Use short sentences, one idea each, and everyday words.
- Say what each issue or PR is, not only its number: "fixtures #16 (rollover vectors)", not "#16".
- The first time an ADR, gate or label appears, explain it in a few words: "ADR 0017 (when agents may merge)", not "ADR 0017" or "G2".
- Use a list or a table for three or more items.
- Leave out process detail the Maintainer does not need in order to act.

## Pull requests outside a wave

A *pull request outside a wave* is an open pull request on a non-archived `drewsonne/maya-*` repo other than the hub (`drewsonne/maya-project`) that is not both authored by the owner of the hub repo (the account dispatched agents open pull requests as) and described with `Closes drewsonne/maya-project#<number>`. No wave collects these, so a *sweep* reviews them. List them with the command below. The search returns at most 100 pull requests per page: when `gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' --jq .total_count` prints more than 100, run the command again with `-f page=2`, then `-f page=3`, until every page is read.

`gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' -f per_page=100 --jq '[.items[] | select(.repository_url | test("/maya[^/]*$")) | select(.repository_url | endswith("/maya-project") | not) | select((((.body // "") | test("Closes drewsonne/maya-project#[0-9]+")) and (.user.login == "drewsonne")) | not) | {repo: (.repository_url | split("/") | .[-1]), number, author: .user.login, assignees: [.assignees[].login], title}]'`

**The sweep is one coordinating context.** It lists the pull requests outside a wave, skips those already reviewed, dispatches one fresh review agent per remaining pull request running this skill, consumes each verdict, posts it as a comment, merges or queues each pull request as set out below, reports, and ends. It runs only when a message from the Maintainer in the current session asked for it. It never reads a diff and never reviews a pull request itself, and no review agent receives another pull request's diff, verdict or findings. A sweep never sends a pull request back to an agent.

**Already reviewed.** A pull request outside a wave is *reviewed* when it is assigned to the Maintainer and the most recent comment beginning `Review verdict:` posted by the owner of the hub repo names its current head SHA. The head SHA is `gh api repos/<owner/repo>/pulls/<n> --jq .head.sha`; the verdict lines, oldest first, are `gh api --paginate repos/<owner/repo>/issues/<n>/comments --jq '.[] | select(.user.login == "drewsonne") | select(.body | startswith("Review verdict:")) | .body | split("\n")[0]'`, and the last line printed is the most recent. The sweep reviews every other one, including one already assigned to the Maintainer without such a comment. The sweep posts a verdict comment on every pull request it reviews, whether it then merges or queues it. The first line of every verdict comment the sweep posts is exactly one of these, in plain text with no bold, with the head SHA that was reviewed:

- `Review verdict: merge (head <sha>)`
- `Review verdict: merge after named changes (head <sha>)`
- `Review verdict: reject and re-plan (head <sha>)`

**Kinds.** Classify each pull request by the `author` field of the listing. `dependabot[bot]` is a Dependabot pull request. `github-actions[bot]` with a head branch starting `release-please--` (`gh api repos/<owner/repo>/pulls/<n> --jq .head.ref`) is a release pull request. Anything else is another pull request. (`gh pr view` shows these authors as `app/dependabot` and `app/github-actions`.)

**What the review agent receives.** The pull request's diff, its description, its kind, and that kind's checks below, in place of a package block. Mechanical checks 1 (fixture integrity) and 4 (layer direction) still apply; checks 2, 3, 5 and 6 are replaced by the kind's checks. The suite result is the pull request's CI checks on its current head (`gh pr checks <n> --repo <owner/repo>`): the review agent never installs or runs the branch locally. No checks reported, or any skipped or failing check, is a finding, except where the Dependabot checks below say otherwise.

- **Release pull request.** Checks: the CI checks pass, and the changelog lists only commits already on the default branch. The verdict comment names the version it would release and lists the changelog's changes in plain words. The verdict is **merge** when both checks pass, otherwise **merge after named changes**. Shipping is the Maintainer's (ADR 0017, G3), so a release pull request is always queued.
- **Dependabot pull request.** The review agent runs checks (a) to (d) below and reports each one as `pass` or `fail`, quoting the output of a failed one. In them, `<owner/repo>` and `<n>` are the pull request's repo and number, `<sha>` is its current head SHA (`gh api repos/<owner/repo>/pulls/<n> --jq .head.sha`), `<base>` is its base SHA (`gh api repos/<owner/repo>/pulls/<n> --jq .base.sha`), and "fetched raw" means `gh api -H 'Accept: application/vnd.github.raw' "repos/<owner/repo>/contents/<path>?ref=<ref>"`.
  - (a) Authors and branch. `gh api repos/<owner/repo>/pulls/<n> --jq '[.head.repo.full_name, .base.repo.full_name, .head.ref, .base.ref] | @tsv'` shows the same repo twice, a head branch starting `dependabot/`, and a base branch equal to `gh api repos/<owner/repo> --jq .default_branch`; and `gh api --paginate repos/<owner/repo>/pulls/<n>/commits --jq '.[] | [.author.login, .committer.login, .commit.verification.verified] | @tsv'` prints, on every line, author `dependabot[bot]`, committer `web-flow` or `dependabot[bot]`, and `true`.
  - (b) Checks. `gh api --paginate "repos/<owner/repo>/commits/<sha>/check-runs?per_page=100" --jq '.check_runs[] | [.name, .status, .conclusion] | @tsv'` prints at least one line, and every line shows status `completed` and conclusion `success` or `skipped` (a skipped check did not run); `gh api --paginate "repos/<owner/repo>/actions/runs?head_sha=<sha>&per_page=100" --jq '.workflow_runs[] | [.name, .status, .conclusion] | @tsv'` shows every run `completed` with conclusion `success` or `skipped`; and `gh api repos/<owner/repo>/commits/<sha>/status --jq '[.total_count, .state] | @tsv'` prints a total of `0` or the state `success`.
  - (c) Suite on `pull_request`. The suite jobs are: for `maya-dates`, `build (20.x)`, `build (22.x)` and `build (24.x)` in the workflow `.github/workflows/nodejs.yml`; for `maya-date-fixtures`, `validate` in the workflow `.github/workflows/validate.yml`. Every other repo has no suite job listed here, so (c) fails for it. For each run printed by `gh api "repos/<owner/repo>/actions/runs?head_sha=<sha>&event=pull_request" --jq '.workflow_runs[] | [.id, (.path | sub("@.*$"; ""))] | @tsv'` whose path is the named workflow, `gh api --paginate repos/<owner/repo>/actions/runs/<id>/jobs --jq '.jobs[] | [.name, .conclusion] | @tsv'` lists its jobs; every suite job named for the repo appears there with conclusion `success`.
  - (d) Changed lines. `gh api --paginate repos/<owner/repo>/pulls/<n>/files --jq '.[] | [.filename, .status] | @tsv'` lists only files with status `modified`, and every file listed is one of these three, checked as stated:
    - A file named `package.json`, in any directory. Fetched raw at `<base>` into `b.json` and at `<sha>` into `h.json`: `jq -S 'del(.dependencies, .devDependencies, .peerDependencies)'` prints the same for both; `jq -n --slurpfile b b.json --slurpfile h h.json '[("dependencies","devDependencies","peerDependencies") as $k | ($h[0][$k] // {} | keys) == ($b[0][$k] // {} | keys)] | all'` prints `true`; and `jq -n --slurpfile b b.json --slurpfile h h.json '[("dependencies","devDependencies","peerDependencies") as $k | ($h[0][$k] // {}) | to_entries[] | select(.value != (($b[0][$k] // {})[.key])) | .value | select(test("^[~^]?[0-9]+\\.[0-9]+\\.[0-9]+") | not)] | length'` prints `0`.
    - A file named `package-lock.json` or `npm-shrinkwrap.json`, in any directory. Fetched raw at `<sha>`, `jq '[.. | objects | .resolved? // empty | select(startswith("https://registry.npmjs.org/") | not)] | length'` prints `0`.
    - A file under `.github/workflows/` whose name ends `.yml` or `.yaml`. Its `patch` field in the files listing is present, every line of that patch that begins `+` or `-` matches `grep -E '^[+-][[:space:]]*(-[[:space:]]+)?uses:[[:space:]]*[^@[:space:]]+@[^[:space:]]+([[:space:]]+#.*)?$'`, the patch has as many removed lines as added lines, and the text between `uses:` and `@` on each removed line is the same as on the added line at the same position among the added lines.
  - The verdict comment lists (a) to (d), each with its result and the output of every command it ran, and names a major version bump as major. The verdict is **merge** exactly when (a), (b), (c) and (d) pass, mechanical checks 1 and 4 pass, and there is no other finding; otherwise it is **merge after named changes**, naming each failed check and finding.
- **Another pull request.** It has no package block, so its verdict is **reject and re-plan**. The verdict comment says in plain words what the pull request does, whether it merges cleanly onto the default branch today (`gh api repos/<owner/repo>/pulls/<n> --jq .mergeable`), and whether its CI checks pass, and asks the Maintainer to adopt it into a story or close it.

**Dependabot merges (ADR 0022).** A Dependabot pull request belongs to no authorized story, and ADR 0022 lets an agent merge it anyway when every one of its conditions holds. After posting the verdict comment, the sweep merges a Dependabot pull request only when the verdict is **merge** and the review agent reported (a), (b), (c) and (d) as `pass`, and only after the sweep has itself run the commands of (a), (b) and (c), and the `package.json` and lockfile commands of (d), against the head SHA named in the verdict comment and seen each pass. It merges with `gh api -X PUT repos/<owner/repo>/pulls/<n>/merge -f sha=<sha> -f merge_method=squash`, where `<sha>` is that head SHA. If any check is not `pass`, or that command fails, the sweep queues the pull request for the Maintainer instead. A sweep merges only when a message from the Maintainer in the current session asked for the sweep (ADR 0017: "autonomy executes during sessions, kicked off by the Maintainer"); a context started by a schedule, a routine or a hook queues every pull request.

**No agent merges any other pull request outside a wave.** Every pull request outside a wave that is not merged under "Dependabot merges (ADR 0022)" is queued for the Maintainer, whatever its verdict: it belongs to no authorized story (ADR 0017, G2: autonomous work happens only on a story carrying the `authorized` label). An agent never merges, approves or enables auto-merge on a pull request outside a wave by any command, API call or bot comment (for example `gh pr merge`, `gh pr review --approve`, `gh pr merge --auto`, or an `@dependabot merge` comment), whether a sweep or a single review invoked it; the one merge it may make is the `PUT` in "Dependabot merges (ADR 0022)", and only from a sweep.

**Report.** The sweep's report to the Maintainer follows the Writing for the Maintainer rule. It is a table with one row per pull request reviewed: the repo, number and what the pull request is; its kind; the verdict; `merged` or `queued`; and what the Maintainer is asked to do (`nothing` for a merged one).

## Rules

- **Author ≠ reviewer, always** (ADR 0020): whoever authored the change — agent or session — never runs its review. If you authored it, dispatch a fresh agent to review and relay its verdict.
- Merge only the clean case, and only under an active G2 authorization (ADR 0017): verdict **merge**, zero findings, full suite green, scope clean, no fixture edits. Everything else: state the verdict and queue it for the Maintainer: assign the pull request to the Maintainer (`gh pr edit <n> --repo <owner/repo> --add-assignee <login>`, where `<login>` is the owner of the hub repo) and post the review verdict and findings as a comment on it. Never soften a finding to reach the clean case, and never merge a release PR — shipping is G3, always the Maintainer's. An active G2 authorization covers only a pull request whose description closes a task under that authorized story. The one exception to needing it is a Dependabot pull request outside a wave that passes every check in "Pull requests outside a wave", which a sweep may merge (ADR 0022).
- Assign a PR only when no agent action remains on it: a PR whose named changes an agent still has to apply stays unassigned until they are applied and re-checked, and a PR sent back to an agent is unassigned (`gh pr edit <n> --repo <owner/repo> --remove-assignee <login>`) until it returns. A PR with verdict **merge after named changes** is queued for the Maintainer at once, with the changes named in the verdict comment, unless the context that invoked this review sends it back to an agent to apply them. A PR whose author is not an agent this project dispatches (Dependabot, release-please, Copilot, a person) is never sent back to an agent.
- Never approve a PR whose package block cannot be found. Unattributed work has no criteria to check against. A pull request outside a wave is the one exception: the checks for its kind in "Pull requests outside a wave" stand in for the block, an agent never approves one, and only a Dependabot pull request that passes every one of its checks is merged by an agent.
- Do not comment on formatting, naming preference or style that a linter should own. If a linter should own it and does not, that is one finding: add the linter.
- A PR that is correct but unreviewable is not ready. Say that, rather than merging it because the tests are green.
- If reviewing reveals the plan was wrong rather than the code, say so and route it back to `maya-plan`. Do not fix a planning error by negotiating with the implementation.
