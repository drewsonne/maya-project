# Plan: skill follow-ups, and pull requests outside a wave

Date: 2026-09-27, re-planned the same day for ADR 0022. **2 packages, 2 waves,
plus one story captured without a task.** Target repo: `drewsonne/maya-project`
(the plugin lives on the hub, ADR 0010). Epic #15.

## What this plan covers

| # | Story | What changes | Package | Wave |
|---|---|---|---|---|
| 1 | #58 (plain language) | maya-implement stops forbidding a one-line plain summary of the PR | `implement-one-line-summary` | 1 |
| 2 | #55 (assign what waits on the Maintainer) | maya-review gets maya-fleet's "assign only when no agent action remains" rule | folded into `review-prs-outside-a-wave` | 2 |
| 3 | #61 (PRs outside a wave) | maya-review defines a sweep of PRs no wave dispatched, merging only the Dependabot PRs ADR 0022 allows; maya-fleet preflight and maya-orient point at it | `review-prs-outside-a-wave` | 2 |
| 4 | #66 (new: questions for the Maintainer are issues) | plan, fleet, review, implement and record file each question for the Maintainer as a `question` issue; orient reports them | story only; task filed as wave 3 once wave 1 is collected | 3 (not filed) |

**Why item 2 is folded into item 3.** Both edit maya-review, and the #55 gap
bites exactly where the sweep runs: a standalone maya-review, with no fleet
coordinator around it. Writing the rule once, in the package that also
defines standalone sweeps, avoids two agents editing the same Rules list.
The #55 story's own acceptance does not require this rule (see the last
comment on #55), so #55 can close independently; a comment on #55 points at
the task that enacts it.

**Why two waves, one package each.** CI fails any commit touching
`plugins/maya/` without a `plugin.json` version change, so every skill
package edits `plugin.json`. Two such packages in one wave share that path,
and the second to merge then conflicts on the version line and needs a
rebase commit, which itself fails the version check unless squashed. With
only two small packages, sequencing costs less than that: wave 1 sets
1.10.4, wave 2 sets 1.10.5 and depends on wave 1 for the version line only.
No two packages in a wave share a path glob. Checked.

**Horizon.** Both waves are filed: wave 1 is the next wave in flight, wave 2
the one planned wave. Tasks #8 and #9 (fixtures plan, stories #12/#13) are
another story's horizon and are unaffected.

**Authorization.** Stories #58 and #61 carry `authorized` (ADR 0017's G2, the
label that lets agents work a story), so waves 1 and 2 can be dispatched in
turn. Story #66 does not yet; its task needs the Maintainer to apply
`authorized` before it is dispatched.

## Tracing story 3 to the decisions

- **ADR 0017 (when agents may merge)** lists "Dependabot merges, majors
  included, when the target repo's full suite runs and passes" among the
  autonomous actions, but its G2 gate says "Autonomous work happens only on
  a story carrying the `authorized` label", and a Dependabot PR belongs to
  no story. **ADR 0022 (Dependabot merges need no authorized story)**
  settles this: an agent may merge a Dependabot PR without an authorized
  story when every commit is by `dependabot[bot]`, every check passes with
  one running the suite on `pull_request`, and the diff changes only
  version strings, lockfiles and `uses:` pins. The sweep checks each
  condition with a command, merges only when all pass, and queues
  everything else. ADR 0022 is accepted by the Maintainer; its pull request
  (hub #65) must be merged before wave 2 is dispatched.
- **ADR 0017 G3 (shipping is the Maintainer's)**: release PRs are always
  queued, never merged by an agent.
- **ADR 0014 (dependency policy, from closed story #18)**: Dependabot is the
  sanctioned route for bumps (monthly, minor+patch grouped, majors
  separate). The agent-dependency rule binds implementing agents, not
  Dependabot; the sweep's Dependabot checks come from ADR 0022 (read from
  the GitHub API, never a local install).
- **ADR 0018/0019 (the board)**: every open satellite PR belongs on the board
  at In review. maya-orient's reconciliation already enforces that, so the
  sweep adds nothing to the board contract.
- **ADR 0020 and 0021**: one PR per fresh reviewing context, author ≠
  reviewer. The sweep is a coordinating unit like a wave's collect phase:
  it lists, dispatches one review agent per PR, consumes verdicts, queues,
  reports, and ends. It never reads a diff itself.
- **Which skill owns the sweep: maya-review.** Its description already says
  it reviews "agent-authored and hand-written PRs alike". maya-fleet is
  wave-scoped and refuses to run without a plan; maya-orient is read-only.
  maya-fleet's preflight check 7 ("resolved or explicitly deferred") and
  maya-orient's report point at the sweep instead of duplicating it.

**Not planned, and why:** hub PRs opened by skill contexts (plans, ADRs,
wave reports) are outside the sweep; they already open with a "For the
Maintainer" section, and assigning them is a separate small story if
wanted. Harmonising Dependabot grouping (the parser's #42–#46 arrived as
individual PRs) is config work, not skill work; the sweep reports it.
Closing stale PRs is always the Maintainer's call.

## Decided: Dependabot merges (ADR 0022)

This plan first asked the Maintainer whether ADR 0017's Dependabot clause
applies without an authorized story. The Maintainer answered yes, with
conditions, in ADR 0022. Task #63 was re-planned to follow it:

- The sweep merges a Dependabot PR only when every ADR 0022 condition
  passes as a command: commit authors, every check passing, a named suite
  job passing on a `pull_request` run, and changed lines limited to
  version strings, lockfiles and `uses:` pins. The sweep re-runs the checks
  itself before it merges, and merges with the head SHA pinned.
- The verdict comment is posted either way, quoting every check's output.
- No agent merges any other PR outside a wave, and a sweep merges only when
  the Maintainer asked for it in the current session.
- Where the commands are stricter than ADR 0022, the PR is queued. The
  stricter points are listed in the task.

On 2026-09-27 this would merge nothing yet: fixtures #14 fails its
`claude-review` check, and the parser repos have no `pull_request` CI.

## Story #66: questions for the Maintainer (captured, no task yet)

The Maintainer said questions for them get buried in documents with nowhere
to answer; the "Question for the Maintainer" section this plan used to
carry is an example. They approved a rule: every question for the
Maintainer is a hub issue labelled `question`, assigned to them, written to
the Writing for the Maintainer rule with the options spelled out, answered
by comment, recorded where it belongs, and closed with a link.

**A new story, not part of #55.** Story #55 makes assignment the signal
for pull requests waiting on the Maintainer, and it can close on its own
acceptance once the next wave's queued PRs are assigned. The question rule
is a different outcome (a place to answer, and agents that read the answer
from it). Putting it under #55 would hold #55 open for two more waves. It is
new story #66 under epic #15. Its body carries the rule as fixed text, the
skills it goes in and the acceptance.

**Skills.** maya-plan, maya-fleet, maya-review, maya-implement and
maya-record get the same fixed paragraph; maya-plan and maya-record also get
the Writing for the Maintainer rule, which they lack today. maya-orient
files nothing, so it gets a listing command and a reporting sentence
instead. maya-record's "Open questions go in `docs/STATE.md`" is narrowed to
questions not for the Maintainer. Not maya-spec (it interviews the
Maintainer live) and not maya-fixtures (its open questions are research).

**Why no task yet, and not folded into #62.** Every skill package changes
the version in `plugin.json`, so two skill packages cannot share a wave.
Waves 1 (#62) and 2 (#63) already fill the horizon (ADR 0009: the wave in
flight plus one planned wave). Folding the rule into #62 was considered and
rejected: a package has one story, and #62 serves #58 while the rule
serves #66; it would grow #62 from two files to seven and from XS to the
top of S, delaying a small ready fix; and #66 is not yet `authorized`, so
#62 could not be dispatched until it was. The task for #66 is filed as
wave 3 when wave 1 is collected (wave 2 then becomes the wave in flight).
It depends on wave 2, because both edit maya-review, maya-fleet and
maya-orient, and it sets plugin 1.10.6.

## Shared text

**Fixture command** (a process package has no calendar fixtures, so this
structural gate is the whole suite):
`for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- '---' && sed -n 2p "$f" | grep -q '^name:' && sed -n 3p "$f" | grep -q '^description:' || exit 1; done && jq -e '.name and .version and .description' plugins/maya/.claude-plugin/plugin.json`

## Wave 1

### implement-one-line-summary (task #62)

Work package for story drewsonne/maya-project#58, epic #15. Repo: `drewsonne/maya-project`, default branch `main`. The plugin is `plugins/maya/`; CI is `.github/workflows/validate.yml` and must pass on the branch.

**Why.** maya-implement asks every PR description to open with a "For the Maintainer" section that says, among other things, what the PR changes. Its Conventions section still says, in one bullet (line 62 on `main` at b3b31e6): "Do not describe the diff — it is visible." An agent reading both cannot obey both. The fix allows exactly one plain sentence on what the PR changes, and keeps the ban on restating the diff.

**Contract.** Only the files in scope change. No new file is created. SKILL.md frontmatter keeps `---`, `name:`, `description:`, `---` as its first four lines. Every existing rule keeps its meaning: rewording is allowed, weakening or deleting a rule is not. In particular the checklist rule (opened at the first commit, ticked as criteria are met), the `Closes drewsonne/maya-project#N` line, and the Writing for the Maintainer block are unchanged. Skill text names the role, never a person (ADR 0015). The reviewer states which sentence enacts each criterion.

**Fixed text 1.** The Conventions bullet that begins "The PR description states:" becomes exactly this, word for word:

- The PR description states: the package id, which acceptance criteria are met, which fixtures now pass, and anything you were blocked on. Do not restate the diff: no file-by-file or change-by-change account, because the reviewer reads the diff itself. The one description of the change is the single plain sentence on what the PR changes in the "For the Maintainer" section (step 4), which names the effect for the Maintainer, not files or individual edits. The acceptance-criteria checklist opened in step 4 is how "which criteria are met" is stated; keep it current rather than restating it in prose.

**Fixed text 2.** In "Order of work" step 4, the sentence that begins `The "For the Maintainer" section sits above the checklist` (it currently ends `"nothing yet, still in progress").`) is replaced by exactly this, word for word; the rest of step 4 is unchanged:

The "For the Maintainer" section sits above the checklist and follows the Writing for the Maintainer rule under "Commits and pull requests". It has two to four sentences: exactly one plain sentence says what the PR changes, naming the effect for the Maintainer rather than files or individual edits, and the rest say exactly what the Maintainer is asked to do (for example "take out of draft and merge", "decide X", or "nothing yet, still in progress"). The pull request that commits a wave report follows maya-fleet Phase 3 for this section instead.

**Fixture command** (a process package has no calendar fixtures, so this structural gate is the whole suite):
`for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- '---' && sed -n 2p "$f" | grep -q '^name:' && sed -n 3p "$f" | grep -q '^description:' || exit 1; done && jq -e '.name and .version and .description' plugins/maya/.claude-plugin/plugin.json`

**Working.** Create branch `implement-one-line-summary` from `main` in a fresh worktree. Open a draft PR against `main` whose description opens with a "For the Maintainer" section, then the acceptance criteria as a `- [ ]` checklist, and contains `Closes drewsonne/maya-project#62`. Make exactly one commit; CI's version check compares only `HEAD^..HEAD`. Never merge, never push to `main`. Stop and file a stop report (`package`, `step reached`, `attempted`, `failed`, `branch`, `question`) if a criterion is ambiguous, the contract would have to be broken, or CI cannot be made green.

```
id:           implement-one-line-summary
goal:         A PR description may say in one plain sentence what the PR changes, and still never restates the diff.
story:        #58
outcome:      The Maintainer can read and act on agent output (story #58); a PR description the Maintainer cannot place ("what is this?") stalls the merge queue, which maya-review names as this project's real limit
binds:        - ADR 0021 "a pull request description carries the acceptance criteria as a checklist from its first commit, ticked as each is met"
              - ADR 0015 "Skills, ADRs, plans and the README use the role name"
layer:        0 process
scope:        plugins/maya/skills/maya-implement/SKILL.md
              plugins/maya/.claude-plugin/plugin.json
contract:     see Contract above
criteria:     1. `grep -c 'Do not describe the diff' plugins/maya/skills/maya-implement/SKILL.md` prints 0.
              2. Fixed text 1 appears word for word, once, as the Conventions bullet it replaces.
              3. Fixed text 2 appears word for word, once, in "Order of work" step 4, replacing the sentence named there.
              4. `git diff --stat origin/main...HEAD` lists exactly the two scope files.
              5. plugin.json version is 1.10.4.
fixtures:     the fixture command above
depends_on:   none
size:         XS
```

## Wave 2

Re-validate against `main` before dispatch: `main` must carry plugin 1.10.4
(wave 1 merged) and ADR 0022 (hub #65 merged), and the maya-review Rules
and maya-fleet check 7 wording quoted in the block must still be current.

### review-prs-outside-a-wave (task #63)

Work package for story drewsonne/maya-project#61, epic #15. Repo: `drewsonne/maya-project`, default branch `main`. The plugin is `plugins/maya/`; CI is `.github/workflows/validate.yml` and must pass on the branch.

**Why.** The skills review only pull requests that a maya-fleet wave dispatched. Every other PR on the Maya repos has no reviewer and sits. On 2026-09-27 ten were open: a release PR (maya-dates #212), six Dependabot bumps (maya-date-fixtures #14, maya-calculator-parser #42–#46), and three older PRs (maya-calculator-parser #15 from 2025-07, #29 and #30 from 2026-01). This package makes maya-review own a *sweep* of those PRs, and points maya-fleet and maya-orient at it. The sweep merges the Dependabot PRs that ADR 0022 (Dependabot merges need no authorized story, accepted 2026-09-27) allows, after checking each of its conditions with a command, and queues every other PR for the Maintainer. It also carries a follow-up from story #55: a standalone maya-review that returns **merge after named changes** must not assign the PR to the Maintainer while an agent is still going to apply the changes.

**Decisions this package follows, quoted.**
- ADR 0017, G2: "Autonomous work happens only on a story carrying the `authorized` label, applied by the Maintainer." A PR outside a wave belongs to no story.
- ADR 0022 makes one exception to G2: "An agent may merge a Dependabot pull request, majors included and in every Maya repo, without any story carrying the `authorized` label, when all of these hold: every commit on the pull request's branch is authored by `dependabot[bot]`; every check that runs on the pull request completes and passes, and at least one of them runs the repo's test suite on the `pull_request` event; the diff changes only version strings under `dependencies`, `devDependencies` or `peerDependencies` in `package.json`, lockfiles, and `uses:` version pins in `.github/workflows/`. Anything else is queued for the Maintainer [...]. The merge happens only inside a session the Maintainer started (ADR 0017: "autonomy executes during sessions, kicked off by the Maintainer"). Every other pull request outside a wave still needs the Maintainer to merge it." ADR 0022 also says: "it must post its verdict comment either way, so each merge is on record."
- ADR 0017, G3: "Anything crossing the repo boundary — release-PR merges, deploys, plugin releases — is the Maintainer's."

This package checks every ADR 0022 condition with a command and allows nothing ADR 0022 does not. Where a command is stricter than ADR 0022, the PR is queued, never merged. The stricter points are: every commit must also be committed by `web-flow` or `dependabot[bot]` and carry a verified signature; the branch must be a `dependabot/` branch in the same repo, based on the default branch; the suite counts only as the jobs named for each repo; only `package-lock.json` and `npm-shrinkwrap.json` count as lockfiles; a lockfile may resolve packages only from `https://registry.npmjs.org/`; and a changed version string must start with a version number.

**Contract.** Only the files in scope change. No new file is created. SKILL.md frontmatter keeps `---`, `name:`, `description:`, `---` as its first four lines. Every existing rule keeps its meaning: rewording is allowed, weakening or deleting a rule is not; the fixed texts below only add to or narrow existing rules. maya-review's six mechanical checks, adversarial pass, three verdicts and existing Rules bullets are retained; maya-fleet's nine preflight checks keep their numbers and existing text; maya-orient stays read-only apart from its board reconciliation. The only text that lets an agent merge a pull request outside a wave is the paragraph headed "Dependabot merges (ADR 0022)" in fixed text D; add no other. Skill text names the role, never a person (ADR 0015). The reviewer checks each criterion with `grep -F` or by reading the named position.

**Fixed text A** (the listing command; word for word in fixed text D and in maya-orient):
`gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' -f per_page=100 --jq '[.items[] | select(.repository_url | test("/maya[^/]*$")) | select(.repository_url | endswith("/maya-project") | not) | select((((.body // "") | test("Closes drewsonne/maya-project#[0-9]+")) and (.user.login == "drewsonne")) | not) | {repo: (.repository_url | split("/") | .[-1]), number, author: .user.login, assignees: [.assignees[].login], title}]'`

**Fixed text B** (a new maya-review Rules bullet, directly after the bullet that begins "Merge only the clean case"; its first sentence is word for word the sentence already in maya-fleet Phase 3):
Assign a PR only when no agent action remains on it: a PR whose named changes an agent still has to apply stays unassigned until they are applied and re-checked, and a PR sent back to an agent is unassigned (`gh pr edit <n> --repo <owner/repo> --remove-assignee <login>`) until it returns. A PR with verdict **merge after named changes** is queued for the Maintainer at once, with the changes named in the verdict comment, unless the context that invoked this review sends it back to an agent to apply them. A PR whose author is not an agent this project dispatches (Dependabot, release-please, Copilot, a person) is never sent back to an agent.

**Fixed text C** (appended, as new sentences, to the end of existing maya-review Rules bullets; the bullet's existing text is unchanged):
- At the end of the bullet that begins "Merge only the clean case": `An active G2 authorization covers only a pull request whose description closes a task under that authorized story. The one exception to needing it is a Dependabot pull request outside a wave that passes every check in "Pull requests outside a wave", which a sweep may merge (ADR 0022).`
- At the end of the bullet that begins "Never approve a PR whose package block cannot be found": `A pull request outside a wave is the one exception: the checks for its kind in "Pull requests outside a wave" stand in for the block, an agent never approves one, and only a Dependabot pull request that passes every one of its checks is merged by an agent.`
- At the end of the first paragraph of the section "One pull request per context": `For a pull request outside a wave, the inputs are those set out in "Pull requests outside a wave".`

**Fixed text D** (a new maya-review section, placed directly before `## Rules`, word for word, with fixed text A where marked):

## Pull requests outside a wave

A *pull request outside a wave* is an open pull request on a non-archived `drewsonne/maya-*` repo other than the hub (`drewsonne/maya-project`) that is not both authored by the owner of the hub repo (the account dispatched agents open pull requests as) and described with `Closes drewsonne/maya-project#<number>`. No wave collects these, so a *sweep* reviews them. List them with the command below. The search returns at most 100 pull requests per page: when `gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' --jq .total_count` prints more than 100, run the command again with `-f page=2`, then `-f page=3`, until every page is read.

[fixed text A]

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

**Fixed text E** (appended to the end of maya-fleet preflight check 7; the check's existing text is unchanged):
`An open pull request outside a wave (as defined in maya-review) still counts as open: a reviewed one passes this check only if the plan's deferral note names it, and an unreviewed one is neither resolved nor deferred; the smallest action that clears it is a maya-review sweep in a fresh context.`

**Fixed text F** (maya-orient; the existing text of each place is unchanged):
- A new bullet at the end of step 4: `- Pull requests outside a wave (defined in maya-review): ` followed by fixed text A.
- Appended to the end of the "Blocked or waiting" paragraph: `Each pull request outside a wave that is not reviewed (as maya-review defines it: assigned to the Maintainer, with its most recent "Review verdict:" comment naming its current head SHA) is reported as "not yet reviewed", using the commands maya-review gives for the head SHA and the verdict lines; past five such pull requests, give their count and name the repos.`
- Appended to the end of the "Three things you could do next" paragraph: `When at least one pull request outside a wave is not yet reviewed, one of the three is a maya-review sweep of them, size S for up to five pull requests and M for more.`

**Fixed text G** (appended to the end of the `description:` line in maya-review's frontmatter, after a space; the line's existing text is unchanged):
`Also runs a sweep of open pull requests outside a wave, merging only the Dependabot ones ADR 0022 allows and queuing the rest for the Maintainer.`

**Fixture command** (a process package has no calendar fixtures, so this structural gate is the whole suite):
`for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- '---' && sed -n 2p "$f" | grep -q '^name:' && sed -n 3p "$f" | grep -q '^description:' || exit 1; done && jq -e '.name and .version and .description' plugins/maya/.claude-plugin/plugin.json`

**Working.** Before starting, confirm `origin/main` carries plugin version 1.10.4 (wave 1 merged) and the file `docs/decisions/0022-dependabot-merges-need-no-authorized-story.md`; if either is missing, stop. Create branch `review-prs-outside-a-wave` from `main` in a fresh worktree. Open a draft PR against `main` whose description opens with a "For the Maintainer" section, then the acceptance criteria as a `- [ ]` checklist, and contains `Closes drewsonne/maya-project#63`. Make exactly one commit; CI's version check compares only `HEAD^..HEAD`. Never merge, never push to `main`. Do not run a sweep; this package only writes skill text. Stop and file a stop report (`package`, `step reached`, `attempted`, `failed`, `branch`, `question`) if a criterion is ambiguous, the contract would have to be broken, or CI cannot be made green.

```
id:           review-prs-outside-a-wave
goal:         Every open pull request on a satellite Maya repo whose description closes no hub task is reviewed in its own fresh context and gets a verdict comment; an agent merges only a Dependabot pull request that passes every ADR 0022 check, and queues every other one for the Maintainer.
story:        #61
outcome:      Review throughput, not agent capacity, limits this project (maya-review's premise); PRs outside a wave currently have no reviewer at all, so they wait indefinitely
binds:        - ADR 0021 "one pull request per reviewing context"
              - ADR 0017 "Autonomous work happens only on a story carrying the `authorized` label, applied by the Maintainer"
              - ADR 0022 "An agent may merge a Dependabot pull request, majors included and in every Maya repo, without any story carrying the `authorized` label, when all of these hold"
layer:        0 process
scope:        plugins/maya/skills/maya-review/SKILL.md
              plugins/maya/skills/maya-fleet/SKILL.md
              plugins/maya/skills/maya-orient/SKILL.md
              plugins/maya/.claude-plugin/plugin.json
contract:     see Contract above
criteria:     1. Fixed text D appears word for word in maya-review as the section directly before `## Rules`, with fixed text A in the marked place.
              2. Fixed text B appears word for word in maya-review as a Rules bullet directly after the bullet that begins "Merge only the clean case".
              3. Each of the three sentences in fixed text C appears word for word at the end of the place it names, and the text before it in that place is unchanged.
              4. Fixed text E appears word for word at the end of maya-fleet preflight check 7, and the check still begins "7. Open pull requests on the target repo are either resolved or explicitly deferred with a note in the plan."
              5. The three parts of fixed text F appear word for word in maya-orient at the places named.
              6. `grep -F` for fixed text A finds it once in maya-review and once in maya-orient.
              7. `grep -cF 'No agent merges any other pull request outside a wave.' plugins/maya/skills/maya-review/SKILL.md` prints 1.
              8. Among the lines the diff adds, `merge_method` and `pulls/<n>/merge` appear only in the "Dependabot merges (ADR 0022)" paragraph, and `gh pr merge` appears only in the sentence of fixed text D that forbids it.
              9. Fixed text G appears word for word at the end of maya-review's `description:` line, which is still line 3.
              10. `git diff --stat origin/main...HEAD` lists only the four scope files, and plugin.json version is 1.10.5.
fixtures:     the fixture command above
depends_on:   [implement-one-line-summary] (plugin.json version line only)
size:         S
```

## Red-team (ADR 0020)

Two fresh agents, run before any issue was filed.

**Exploit pass** (satisfy the criteria while violating the goal). Package 1
was sound apart from two points; package 2 had fifteen findings. What
changed:

| Finding | Change |
|---|---|
| A standalone maya-review could still merge a Dependabot PR under an unrelated story's `authorized` label, with the sweep checks "replacing" the package block | Fixed text C narrows "Merge only the clean case" to PRs closing a task under the authorized story, and D forbids `gh pr merge` / `--approve` on any PR outside a wave, sweep or not |
| Sweep, fleet and orient each used a different test for "already reviewed"; "comment after latest commit" breaks on force-pushed bot branches; a bolded verdict would miss the marker | One definition in D (assigned + latest `Review verdict:` comment naming the current head SHA), cited by fleet (E) and orient (F); marker line is plain text with the SHA |
| `gh pr view` shows bot authors as `app/dependabot`, so release and Dependabot PRs would be misclassified | D classifies from the listing's `author` field and says so |
| No inputs or checks for a PR without a package block; "runs the suite" could mean `npm ci` of an unreviewed dependency | D sets the review agent's inputs, which mechanical checks apply, and uses CI checks on the head only, never a local install |
| "Manifests and lockfiles" undefined | D lists the file names |
| Fleet check 7 could read a swept PR as deferred | E says a reviewed PR still counts as open unless the plan's deferral note names it |
| A sweep could send a Copilot PR back to an agent and leave it unassigned | D: a sweep never sends a PR back; B names Copilot as not dispatched |
| Listing did not exclude archived repos | `archived:false` added; paging note added |
| Goal claimed "every PR no wave dispatched" but the sweep only sees PRs with no Closes line | Goal narrowed to match; abandoned-wave PRs listed as not planned |
| Many criteria needed judgement | Every added sentence is now fixed text; criteria check them word for word |
| `git diff main` moves when main moves | `git diff --stat origin/main...HEAD` |
| Package 1: one long sentence could still list every edit; wave-report PRs list several PRs | Fixed text says the sentence names the effect, not files; wave-report PRs follow maya-fleet Phase 3 |

**Block-alone attempt** (package 2 from its block only, in a scratch
checkout). It produced a passing diff. Its gaps were: no command for
"merges cleanly" or "CI passes", no size for a sweep, head branch not in the
listing, review-agent inputs unstated, and conflicts with "Never approve a
PR whose package block cannot be found" and with "One pull request per
context". All are now closed in the block (the commands, the size, the
head-branch command, and fixed texts C and D).

**Not planned, from the red-team:** a satellite PR from an abandoned wave
still carries a Closes line, so neither collection nor the sweep sees it.
That is a separate small story if it happens.

## Red-team of the re-plan (ADR 0020, 2026-09-27)

Two fresh agents ran on the re-planned task #63 and the draft of story #66
before either was filed or updated.

**Exploit pass.** What it found, and what changed:

| Finding | Change |
|---|---|
| A person can push a commit with Dependabot's author email; the author check alone passes it | (a) also requires committer `web-flow` or `dependabot[bot]`, a verified signature, a `dependabot/` branch in the same repo, based on the default branch |
| "The workflow contains `npm test`" is not proof the suite ran (a skipped job, a step allowed to fail, a comment) | (c) names the suite jobs per repo (maya-dates `build (20.x)`, `build (22.x)`, `build (24.x)`, fixtures `validate`) and requires each to succeed in a `pull_request` run; other repos fail (c) and queue |
| The sweep merged on the review agent's word, and checks ran at review time only | The sweep re-runs (a), (b), (c) and the file checks of (d) itself, then merges with the head SHA pinned; the verdict comment quotes every command's output |
| Queued workflow runs have no check runs yet; no paging | (b) also requires every workflow run on the head to be completed; `--paginate` added |
| The listing hid `total_count` | A separate count command and paging rule |
| Any PR could add a `Closes` line to leave the sweep | A PR is in a wave only if it has the line **and** is authored by the hub owner (the account agents open PRs as) |
| Anyone could post a fake "Review verdict:" comment | Only verdict comments by the hub owner count; commands given |
| Other merge routes (API approve, auto-merge, `@dependabot merge`) not banned | The ban now covers merging, approving or enabling auto-merge by any command, API call or bot comment |
| "merge" verdict needed more than (a)–(d) | Merge exactly when (a)–(d) and mechanical checks 1 and 4 pass with no other finding |
| "A session the Maintainer started" was not checkable | Merges only when a message from the Maintainer in the current session asked for the sweep; schedules, routines and hooks queue |
| `uses:` names compared as sorted lists let two steps swap actions | Compared line by line in order |
| Story: orient must not file issues | Orient gets its own fixed text (list and report), not the filing paragraph |
| Story: a "yes" comment could stand in for the `authorized` label | "An answer never replaces a gate" added |
| Story: every stop-report question would go to the Maintainer | Limited to questions *for the Maintainer* |
| Story: what counts as an answer, answers given live, duplicates, closing, label check | Only the Maintainer's comment that picks an option or states a decision; live answers are posted as a quoting comment; search before filing; first context to record closes; closed without an answer means withdrawn; 404 check for the label |
| Story: acceptance had unchecked parts | Fixed text for maya-record and maya-orient, a `grep -c` check, and a demonstration on a real answered question |

Not adopted: pinning `uses:` refs against "imposter" commits (ADR 0022
allows any pin; the other checks already require a verified Dependabot
commit), and a command for the release changelog check (a release PR is
always queued, so it cannot cause a merge).

**Block-alone attempt** (task #63 from its block only, in a scratch
checkout). It produced a diff passing every criterion. Its gaps were: the
paging rule could not be followed; orient had no commands for "reviewed";
the "Merge only the clean case" bullet's first clause read as contradicting
the Dependabot exception; orient's length limits clashed with listing every
PR; check-run paging; `@ref` suffixes on workflow paths; and nothing said
the sweep exists outside the skill body. All are closed: the count command,
the commands in "Already reviewed" (which orient's text now points to), a
rewritten fixed text C that names the exception as an exception, "past five,
give their count", `--paginate`, `sub("@.*$"; "")`, and fixed text G, which
adds the sweep to maya-review's description.
