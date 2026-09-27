# Plan: skill follow-ups, and pull requests outside a wave

Date: 2026-09-27. **2 packages, 2 waves.** Target repo: `drewsonne/maya-project`
(the plugin lives on the hub, ADR 0010). Epic #15.

## What this plan covers

| # | Story | What changes | Package | Wave |
|---|---|---|---|---|
| 1 | #58 (plain language) | maya-implement stops forbidding a one-line plain summary of the PR | `implement-one-line-summary` | 1 |
| 2 | #55 (assign what waits on the Maintainer) | maya-review gets maya-fleet's "assign only when no agent action remains" rule | folded into `review-prs-outside-a-wave` | 2 |
| 3 | #61 (new: PRs outside a wave) | maya-review defines a sweep of PRs no wave dispatched; maya-fleet preflight and maya-orient point at it | `review-prs-outside-a-wave` | 2 |

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

**Authorization.** Story #58 carries `authorized` (ADR 0017's G2, the label
that lets agents work a story), so wave 1 can be dispatched. The new story
does not; wave 2 needs the Maintainer to apply `authorized` to it.

## Tracing story 3 to the decisions

- **ADR 0017 (when agents may merge)** already lists "Dependabot merges,
  majors included, when the target repo's full suite runs and passes — a
  repo whose suite is absent, skipped or red queues instead" among the
  autonomous actions. But its G2 gate says "Autonomous work happens only on
  a story carrying the `authorized` label", and a Dependabot PR belongs to
  no story. Whether a Dependabot merge needs a story's authorization is a
  question for the Maintainer (below). **This plan does not depend on the
  answer:** the sweep queues every PR it reviews, and adds no merge path.
  A later package can add one once the Maintainer decides.
- **ADR 0017 G3 (shipping is the Maintainer's)**: release PRs are always
  queued, never merged by an agent.
- **ADR 0014 (dependency policy, from closed story #18)**: Dependabot is the
  sanctioned route for bumps (monthly, minor+patch grouped, majors
  separate). The agent-dependency rule binds implementing agents, not
  Dependabot; the sweep's Dependabot checks come from ADR 0017's suite
  condition (read from CI, never a local install) plus a scope check
  (only named manifest, lockfile and workflow files).
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

## Question for the Maintainer

ADR 0017 already says agents may merge Dependabot PRs, majors included,
when the repo's full test suite runs and passes. Does that apply on its own,
or only while some story carries your `authorized` label? Until you answer,
the sweep reviews Dependabot PRs and assigns them to you with a verdict; it
merges nothing.

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
(wave 1 merged), and the maya-review Rules and maya-fleet check 7 wording
quoted in the block must still be current.

### review-prs-outside-a-wave (task #63)

Work package for story drewsonne/maya-project#61, epic #15. Repo: `drewsonne/maya-project`, default branch `main`. The plugin is `plugins/maya/`; CI is `.github/workflows/validate.yml` and must pass on the branch.

**Why.** The skills review only pull requests that a maya-fleet wave dispatched. Every other PR on the Maya repos has no reviewer and sits. On 2026-09-27 ten were open: a release PR (maya-dates #212), six Dependabot bumps (maya-date-fixtures #14, maya-calculator-parser #42–#46), and three older PRs (maya-calculator-parser #15 from 2025-07, #29 and #30 from 2026-01). This package makes maya-review own a *sweep* of those PRs, and points maya-fleet and maya-orient at it. It also carries a follow-up from story #55: a standalone maya-review that returns **merge after named changes** must not assign the PR to the Maintainer while an agent is still going to apply the changes.

**Decisions this package follows, quoted.** ADR 0017, G2: "Autonomous work happens only on a story carrying the `authorized` label, applied by the Maintainer." A PR outside a wave belongs to no story, and the Maintainer has not yet decided whether ADR 0017's Dependabot clause lets an agent merge one anyway, so no agent merges one. ADR 0017, G3: "Anything crossing the repo boundary — release-PR merges, deploys, plugin releases — is the Maintainer's." ADR 0017: "Dependabot merges, majors included, when the target repo's full suite runs and passes — a repo whose suite is absent, skipped or red queues instead"; the sweep uses this as a review check, not as merge permission.

**Contract.** Only the files in scope change. No new file is created. SKILL.md frontmatter keeps `---`, `name:`, `description:`, `---` as its first four lines. Every existing rule keeps its meaning: rewording is allowed, weakening or deleting a rule is not; the fixed texts below only add to or narrow existing rules. maya-review's six mechanical checks, adversarial pass, three verdicts and existing Rules bullets are retained; maya-fleet's nine preflight checks keep their numbers and existing text; maya-orient stays read-only apart from its board reconciliation. Do not add any sentence that lets an agent merge a PR outside a wave. Skill text names the role, never a person (ADR 0015). The reviewer checks each criterion with `grep -F` or by reading the named position.

**Fixed text A** (the listing command; word for word in fixed text D and in maya-orient):
`gh api -X GET search/issues -f q='is:pr is:open archived:false user:drewsonne' -f per_page=100 --jq '[.items[] | select(.repository_url | test("/maya[^/]*$")) | select(.repository_url | endswith("/maya-project") | not) | select((.body // "") | test("Closes drewsonne/maya-project#[0-9]+") | not) | {repo: (.repository_url | split("/") | .[-1]), number, author: .user.login, assignees: [.assignees[].login], title}]'`

**Fixed text B** (a new maya-review Rules bullet, directly after the bullet that begins "Merge only the clean case"; its first sentence is word for word the sentence already in maya-fleet Phase 3):
Assign a PR only when no agent action remains on it: a PR whose named changes an agent still has to apply stays unassigned until they are applied and re-checked, and a PR sent back to an agent is unassigned (`gh pr edit <n> --repo <owner/repo> --remove-assignee <login>`) until it returns. A PR with verdict **merge after named changes** is queued for the Maintainer at once, with the changes named in the verdict comment, unless the context that invoked this review sends it back to an agent to apply them. A PR whose author is not an agent this project dispatches (Dependabot, release-please, Copilot, a person) is never sent back to an agent.

**Fixed text C** (appended, as new sentences, to the end of existing maya-review Rules bullets; the bullet's existing text is unchanged):
- At the end of the bullet that begins "Merge only the clean case": `An active G2 authorization covers only a pull request whose description closes a task under that authorized story; an agent never merges a pull request outside a wave (see "Pull requests outside a wave").`
- At the end of the bullet that begins "Never approve a PR whose package block cannot be found": `A pull request outside a wave is the one exception: the checks for its kind in "Pull requests outside a wave" stand in for the block, and it is still never merged by an agent.`
- At the end of the first paragraph of the section "One pull request per context": `For a pull request outside a wave, the inputs are those set out in "Pull requests outside a wave".`

**Fixed text D** (a new maya-review section, placed directly before `## Rules`, word for word, with fixed text A where marked):

## Pull requests outside a wave

A *pull request outside a wave* is an open pull request on a non-archived `drewsonne/maya-*` repo other than the hub (`drewsonne/maya-project`) whose description does not contain `Closes drewsonne/maya-project#<number>`. No wave collects these, so a *sweep* reviews them. List them with the command below; if its `total_count` is over 100, fetch the next page with `-f page=2`.

[fixed text A]

**The sweep is one coordinating context.** It lists the pull requests outside a wave, skips those already reviewed, dispatches one fresh review agent per remaining pull request running this skill, consumes each verdict, queues each pull request for the Maintainer, reports, and ends. It never reads a diff and never reviews a pull request itself, and no review agent receives another pull request's diff, verdict or findings. A sweep never sends a pull request back to an agent.

**Already reviewed.** A pull request outside a wave is *reviewed* when it is assigned to the Maintainer and its most recent comment beginning `Review verdict:` names its current head SHA. The sweep reviews every other one, including one already assigned to the Maintainer without such a comment. The first line of every verdict comment the sweep posts is exactly one of these, in plain text with no bold, with the head SHA that was reviewed:

- `Review verdict: merge (head <sha>)`
- `Review verdict: merge after named changes (head <sha>)`
- `Review verdict: reject and re-plan (head <sha>)`

**Kinds.** Classify each pull request by the `author` field of the listing. `dependabot[bot]` is a Dependabot pull request. `github-actions[bot]` with a head branch starting `release-please--` (`gh api repos/<owner/repo>/pulls/<n> --jq .head.ref`) is a release pull request. Anything else is another pull request. (`gh pr view` shows these authors as `app/dependabot` and `app/github-actions`.)

**What the review agent receives.** The pull request's diff, its description, its kind, and that kind's checks below, in place of a package block. Mechanical checks 1 (fixture integrity) and 4 (layer direction) still apply; checks 2, 3, 5 and 6 are replaced by the kind's checks. The suite result is the pull request's CI checks on its current head (`gh pr checks <n> --repo <owner/repo>`): the review agent never installs or runs the branch locally. No checks reported, or any skipped or failing check, is a finding.

- **Release pull request.** Checks: the CI checks pass, and the changelog lists only commits already on the default branch. The verdict comment names the version it would release and lists the changelog's changes in plain words. The verdict is **merge** when both checks pass, otherwise **merge after named changes**. Shipping is the Maintainer's (ADR 0017, G3), so a release pull request is always queued.
- **Dependabot pull request.** Checks: (a) the changed paths are only `package.json`, `package-lock.json`, `npm-shrinkwrap.json`, `yarn.lock` or `pnpm-lock.yaml` at any depth, or, for a github-actions bump, only `.github/workflows/*.yml` or `*.yaml`; any other path, or a `package.json` change outside its dependency blocks, is a finding; (b) the CI checks pass, because a repo whose suite is absent, skipped or red queues (ADR 0017); (c) a major version bump is named as major in the verdict comment. The verdict is **merge** only when (a) and (b) raise no finding.
- **Another pull request.** It has no package block, so its verdict is **reject and re-plan**. The verdict comment says in plain words what the pull request does, whether it merges cleanly onto the default branch today (`gh api repos/<owner/repo>/pulls/<n> --jq .mergeable`), and whether its CI checks pass, and asks the Maintainer to adopt it into a story or close it.

**No agent merges a pull request outside a wave.** It belongs to no authorized story (ADR 0017, G2: autonomous work happens only on a story carrying the `authorized` label), so the sweep queues every pull request it reviews for the Maintainer, whatever the verdict. The checks above inform the verdict only: an agent never runs `gh pr merge` or `gh pr review --approve` on a pull request outside a wave, whether a sweep or a single review invoked it.

**Report.** The sweep's report to the Maintainer follows the Writing for the Maintainer rule. It is a table with one row per pull request reviewed: the repo, number and what the pull request is; its kind; the verdict; and what the Maintainer is asked to do.

**Fixed text E** (appended to the end of maya-fleet preflight check 7; the check's existing text is unchanged):
`An open pull request outside a wave (as defined in maya-review) still counts as open: a reviewed one passes this check only if the plan's deferral note names it, and an unreviewed one is neither resolved nor deferred; the smallest action that clears it is a maya-review sweep in a fresh context.`

**Fixed text F** (maya-orient; the existing text of each place is unchanged):
- A new bullet at the end of step 4: `- Pull requests outside a wave (defined in maya-review): ` followed by fixed text A.
- Appended to the end of the "Blocked or waiting" paragraph: `Each pull request outside a wave that is not reviewed (as maya-review defines it: assigned to the Maintainer, with its most recent "Review verdict:" comment naming its current head SHA) is reported as "not yet reviewed".`
- Appended to the end of the "Three things you could do next" paragraph: `When at least one pull request outside a wave is not yet reviewed, one of the three is a maya-review sweep of them, size S for up to five pull requests and M for more.`

**Fixture command** (a process package has no calendar fixtures, so this structural gate is the whole suite):
`for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- '---' && sed -n 2p "$f" | grep -q '^name:' && sed -n 3p "$f" | grep -q '^description:' || exit 1; done && jq -e '.name and .version and .description' plugins/maya/.claude-plugin/plugin.json`

**Working.** Before starting, confirm `origin/main` carries plugin version 1.10.4 (wave 1 merged); if not, stop. Create branch `review-prs-outside-a-wave` from `main` in a fresh worktree. Open a draft PR against `main` whose description opens with a "For the Maintainer" section, then the acceptance criteria as a `- [ ]` checklist, and contains `Closes drewsonne/maya-project#63`. Make exactly one commit; CI's version check compares only `HEAD^..HEAD`. Never merge, never push to `main`. Do not run a sweep; this package only writes skill text. Stop and file a stop report (`package`, `step reached`, `attempted`, `failed`, `branch`, `question`) if a criterion is ambiguous, the contract would have to be broken, or CI cannot be made green.

```
id:           review-prs-outside-a-wave
goal:         Every open pull request on a satellite Maya repo whose description closes no hub task is reviewed in its own fresh context and queued for the Maintainer with a verdict, so none sits unseen, and no agent merges one.
story:        #61
outcome:      Review throughput, not agent capacity, limits this project (maya-review's premise); PRs outside a wave currently have no reviewer at all, so they wait indefinitely
binds:        - ADR 0021 "one pull request per reviewing context"
              - ADR 0017 "Autonomous work happens only on a story carrying the `authorized` label, applied by the Maintainer"
              - ADR 0017 "Dependabot merges, majors included, when the target repo's full suite runs and passes — a repo whose suite is absent, skipped or red queues instead"
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
              7. No added line contains `gh pr merge` except the sentence in fixed text D that forbids it.
              8. `git diff --stat origin/main...HEAD` lists only the four scope files, and plugin.json version is 1.10.5.
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
