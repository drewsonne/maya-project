# Plan: one context per unit of work (ADR 0021)

Date: 2026-09-26. 5 packages, 2 waves. Target repo: `drewsonne/maya-project`
(the plugin lives on the hub, ADR 0010). Story: #43 under epic #15.

## Why this slice

ADR 0021 (proposed) turns the evidence in `plugins/maya/skills/SOURCES.md`
into a rule: one context, one unit of work, self-sufficient handoffs. The
gap analysis of 2026-09-26 found eight gaps across seven skills. This plan
closes all eight in one wave of four skill packages, then a release
package that fixes the stale README and bumps the plugin.

**Not planned, and why:** retrofitting `Binds:` lines onto ADRs 0001–0020
is a separate story (backlog). Amending ADR 0009 for orphan stories is a
G1 question, not work. Behavioural evals for these rules belong to story
#17. `SOURCES.md` is committed with the ADR, not by a package.

**Layer note:** the plugin is outside the four code layers (ADR 0010);
packages carry `layer: 0 process`, as the fixtures plan carried
`layer: 0 dataset`.

**Dependency note:** the red-team found that packages 1, 2 and 3 would
each need text the others introduce (the agent's input list, the
stop-report fields, the `binds:` field). Rather than serialise the wave,
those texts are fixed here in the issue preamble and each package
implements the same wording. Wave 1 stays parallel.

## Issue preamble

Every wave-1 task issue carries this preamble verbatim above its block,
so an agent can work from the issue alone (ADR 0021).

> Work package from `docs/plan/2026-09-26-one-context-per-unit.md`, story
> drewsonne/maya-project#43, epic #15, implementing ADR 0021 (proposed;
> `docs/decisions/0021-one-context-one-unit-of-work.md`). Repo:
> `drewsonne/maya-project`, default branch `main`. The plugin is
> `plugins/maya/`; CI is `.github/workflows/validate.yml` and must pass on
> the branch.
>
> **Shared wave-1 contract.** Only the files in scope change. No new file
> is created. SKILL.md frontmatter keeps `---`, `name:`, `description:`,
> `---` as its first four lines. Every existing rule keeps its meaning: a
> rewording is allowed, a weakening or deletion is not, and existing
> bullets in a section named by a criterion are retained. Every criterion
> is met by a sentence that changes what an agent does; a heading with an
> empty or decorative body fails the criterion. The reviewer states which
> sentence enacts each criterion.
>
> **Version.** CI fails any commit touching `plugins/maya/` without a
> `plugin.json` version change, so each wave-1 package sets the distinct
> patch version its block names; the wave is merged in package order and
> `plugin.json` resolved to the incoming version at each merge.
>
> **Shared fixture command** (process packages have no calendar fixtures;
> the structural gate is the suite):
> `for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- '---' && sed -n 2p "$f" | grep -q '^name:' && sed -n 3p "$f" | grep -q '^description:' || exit 1; done && jq -e '.name and .version and .description' plugins/maya/.claude-plugin/plugin.json`
>
> **Fixed texts.** Where two skills state the same thing they use the
> same words. The agent input list is: *its package block, the
> maya-implement skill text, its path scope, the command that runs the
> fixtures, and the instruction to open a draft pull request and stop.*
> The stop-report fields are exactly, in this order: `package`, `step
> reached`, `attempted`, `failed`, `branch`, `question`. The collect-table
> outcome values are `ok | blocked | failed`.
>
> **Working.** Create a branch `<package id>` from `main` in a fresh
> worktree, open a draft PR against `main` whose description begins with
> the acceptance criteria as a `- [ ]` checklist and closes the task with
> `Closes drewsonne/maya-project#<task>`. Never merge; never push to
> `main`. Stop and file a stop report (the six fields above) if a
> criterion is ambiguous, the contract would have to be broken, or the
> validate workflow cannot be made green.

## Wave 1 — the skills

Conflict check: four packages, scopes are disjoint SKILL.md files; every
package also names `plugins/maya/.claude-plugin/plugin.json` for the
version line only, with a distinct value each — the one deliberate,
stated overlap, handled by the version note. Checked.

```
id:           wave-1-implement-one-context
goal:         An agent given maya-implement and a package block does exactly one package in a fresh context, recites its criteria as it works, and leaves a resumable stop report when it cannot finish.
story:        #43
outcome:      PRD §2 — correctness above everything; a change made by an agent that has lost its goal is a correctness risk
binds:        - ADR 0021 "one package per implementing context, ending when its draft pull request is open or its stop report is filed"
              - ADR 0021 "a stop report has a fixed shape naming the step reached and the breakdown, which a fresh context can resume from"
              - ADR 0021 "a pull request description carries the acceptance criteria as a checklist from its first commit, ticked as each is met"
layer:        0 process
scope:        plugins/maya/skills/maya-implement/SKILL.md, plugins/maya/.claude-plugin/plugin.json (version line only)
contract:     shared wave-1 contract; the five bullets under "Absolute rules", the bullets under "Conventions" and the five conditions in "When to stop" are retained
criteria:     - SKILL.md contains the heading `## One package per context` whose body states, without qualification or exception, that the context ends when its draft PR is open or its stop report is filed and that it never starts a second package
              - SKILL.md contains the heading `## Stop report` whose body defines the shape with exactly the fields `package`, `step reached`, `attempted`, `failed`, `branch`, `question` in that order, and states that a fresh context must be able to resume from it without the author's context
              - the "When to stop" section names the stop report as the required output of every stop condition
              - the "Order of work" list has a step, before the implementation step, that opens the draft PR at the first commit with every acceptance criterion as an unchecked `- [ ]` item, and states that each item is ticked `- [x]` in the commit that satisfies it
              - SKILL.md contains one sentence beginning `A dispatched agent receives only` followed by the fixed agent input list from the preamble, verbatim
              - the "Conventions" section opens with a sentence that tooling lines apply only to repos that use them and the agent confirms against the target repo's package.json before relying on one; its existing bullets are retained
              - plugin.json version is `1.9.2`
              - shared fixture command exits 0
fixtures:     none (process); command: shared fixture command
depends_on:   []
size:         S
```

```
id:           wave-1-plan-self-sufficient-block
goal:         A package block is sufficient on its own for a fresh context, and the planning context ends when the issues are filed.
story:        #43
outcome:      PRD §2 — an agent that must climb the tree to learn why it is working is an agent that will guess
binds:        - ADR 0021 "a package block carries its story number, the PRD outcome it serves and the ADR clauses that bind it, quoted with their numbers"
              - ADR 0021 "the context that plans never dispatches"
              - ADR 0021 "an ADR carries a Binds: line ... so a planner selects the few that apply"
layer:        0 process
scope:        plugins/maya/skills/maya-plan/SKILL.md, plugins/maya/.claude-plugin/plugin.json (version line only)
contract:     shared wave-1 contract; the two refusals, the horizon rule, the red-team step and the Output and Rules bullets are retained; the Inputs section keeps prd.md, docs/plan/ and the open issues as inputs
criteria:     - the package shape block lists, directly after `goal:` and in this order, the fields `story:` (hub issue number), `outcome:` (PRD section and one sentence) and `binds:` (up to three ADR clauses, each an ADR number plus the quoted clause), and the text states a package missing any of them is not ready to dispatch
              - the "Inputs" section replaces "every accepted ADR" with: the ADRs whose `Binds:` line names the level, layer or skill the story touches; until an ADR carries a `Binds:` line, the default set is 0001, 0009, 0011, 0014, 0017, 0018, 0020 and 0021 plus any ADR whose title names the layer or repository the story touches
              - SKILL.md contains the heading `## The planning context ends here` whose body states that after filing the context reports package and wave counts and ends, does not dispatch or implement, and that dispatch is a separate maya-fleet invocation in a fresh context
              - the "Red-team before filing" section instructs (not permits) the red-team to attempt one package from its block alone in a fresh context, to report anything it had to look up outside the block as a gap, and requires every gap to be closed in the block before filing
              - plugin.json version is `1.9.3`
              - shared fixture command exits 0
fixtures:     none (process); command: shared fixture command
depends_on:   []
size:         S
```

```
id:           wave-1-fleet-review-fan-out
goal:         The fleet context does one wave and fans review out to one fresh agent per pull request; agents receive a fixed, stated set of inputs assembled in a stated order.
story:        #43
outcome:      PRD §2 — a review conditioned on three earlier reviews is a weaker review of the fourth
binds:        - ADR 0021 "one pull request per reviewing context"
              - ADR 0020 "Author ≠ reviewer, always: whoever authored a change — agent or session — never runs its review; review reads the diff cold"
              - ADR 0021 "a coordinator consumes tables and reports and never does a package itself"
layer:        0 process
scope:        plugins/maya/skills/maya-fleet/SKILL.md, plugins/maya/skills/maya-review/SKILL.md, plugins/maya/.claude-plugin/plugin.json (version line only)
contract:     shared wave-1 contract; all nine preflight checks, the "Hard rules for agents" bullets, the merging and story-closure paragraph, maya-review's six mechanical checks, its adversarial pass and its Rules bullets are retained
criteria:     - maya-fleet Phase 2 contains one sentence beginning `Each agent receives only` followed by the fixed agent input list from the preamble, verbatim
              - maya-fleet Phase 2 requires (not describes) that the agent prompt be assembled in this order: hard rules first, the maya-implement text next, the package block last, and states why: the criteria are then the most recent thing in context
              - maya-fleet Phase 3 states that for each PR the collecting context dispatches one fresh review agent running maya-review, consumes its verdict, findings and per-criterion results, and never reads a diff or runs the suite itself; the sentences that had the collecting context run the fixture suite, check criteria and diff scope now assign those to the review agent
              - maya-fleet contains one sentence that the fleet context does one wave — preflight, dispatch, collect, report — then ends, and never plans or implements
              - maya-fleet's collect table gains an `outcome` column with values `ok | blocked | failed`, and Phase 3 states that an agent's stop report is recorded verbatim under `notes` with outcome `blocked` and is not retried in place
              - maya-review contains the heading `## One pull request per context` whose body states that a reviewer carries no prior review's context and that its inputs are the diff, the package block from the hub issue the PR closes, and the ADR clauses that block's `binds:` field quotes
              - plugin.json version is `1.9.4`
              - shared fixture command exits 0
fixtures:     none (process); command: shared fixture command
depends_on:   []
size:         S
```

```
id:           wave-1-session-skills-goal-lines
goal:         Orient, spec and record each run as one unit in one context, and the documents they produce open with the line a later context recites.
story:        #43
outcome:      PRD §1 — the purpose sentence is what every context recites; orientation must not fill the working context
binds:        - ADR 0021 "a context does one unit — a spec round, an ADR, a plan for one story, one wave, one orientation — and then ends"
              - ADR 0021 "an ADR carries a Binds: line naming the skills, layers or levels it constrains ... a Binds: that names everything is a smell"
              - ADR 0019 "reconciliation flows reality → board only"
layer:        0 process
scope:        plugins/maya/skills/maya-orient/SKILL.md, plugins/maya/skills/maya-spec/SKILL.md, plugins/maya/skills/maya-record/SKILL.md, plugins/maya/.claude-plugin/plugin.json (version line only)
contract:     shared wave-1 contract; orient's six steps and Rules bullets are retained, with its read-only claim reworded to except ADR 0019 reconciliation; spec's six rounds, epigrapher test and Rules bullets are retained; record's two formats keep every existing line and add only what the criteria name
criteria:     - maya-orient's first paragraph after the title states that orient runs in a fresh sub-agent context and returns only its report, and that the invoking context receives the report and nothing else orient read
              - maya-orient step 5 states that reconciliation runs in its own fresh context and returns the list of corrections, which orient includes in its report
              - maya-orient's report section begins with a first line that quotes the purpose line of `docs/product/prd.md` verbatim, or states that the PRD has no purpose line
              - maya-spec's "Output" section instructs that `prd.md` opens, under its title, with a one-line purpose statement distilled from round 1 and confirmed by the Maintainer before it is written, and that this is the line other skills recite
              - maya-spec's "Rules" gains a bullet: the spec context ends when the PRD is written; it does not plan
              - maya-record's decision format contains the line `- Binds: <skills, layers or levels this constrains; "all" only when it genuinely constrains every one>` directly after `- Implementation:`
              - maya-record's "Rules" gains a bullet: an ADR is read alone — Context names the problem without requiring another ADR to be open, and other ADRs are cited by number with the relied-on clause quoted
              - maya-record's "Rules" gains a bullet: the recording context ends when the ADR and its story are filed; it does not plan the story's tasks
              - plugin.json version is `1.9.5`
              - shared fixture command exits 0
fixtures:     none (process); command: shared fixture command
depends_on:   []
size:         S
```

## Wave 2 — the release

Carries the same preamble, with the version set to `1.10.0`.

```
id:           wave-2-readme-sources-release
goal:         The README describes all eight skills, the marketplace install and the one-context rule, and the plugin releases at 1.10.0.
story:        #43
outcome:      PRD §6 and ADR 0010 — installed users receive skill updates only through a version bump; the README is what a new contributor reads first
binds:        - ADR 0010 "the hub repo serves the skills as a plugin from its own marketplace"
              - ADR 0021 "every handoff across a context boundary is a written artifact that is the consolidated specification for the receiving context"
layer:        0 process
scope:        plugins/maya/skills/README.md, plugins/maya/.claude-plugin/plugin.json (version line only)
contract:     no SKILL.md or SOURCES.md changes; the README's "Rules worth knowing" bullets and "Conventions they assume" layout are retained
criteria:     - the README table has one row per skill for all eight, each with job, reads and writes filled in
              - the chain diagram shows maya-implement and maya-review as nodes with their edges (fleet → implement → review → fleet collect)
              - the README "Installing" section describes only the marketplace install (`/plugin marketplace add drewsonne/maya-project`, `/plugin install maya@maya-project`) and states that local copies are not a source
              - no occurrence of the string `.claude/skills/` remains anywhere in the README
              - the README contains the heading `## One context, one unit of work` whose body summarises ADR 0021 in 60–120 words and links `SOURCES.md`
              - the README's opening sentence no longer says the table below completes the set with two skills listed elsewhere
              - plugin.json version is `1.10.0`
              - shared fixture command exits 0
fixtures:     none (process); command: shared fixture command
depends_on:   [wave-1-implement-one-context, wave-1-plan-self-sufficient-block, wave-1-fleet-review-fan-out, wave-1-session-skills-goal-lines]
size:         XS
```

## Red-team findings (ADR 0020, before filing)

A fresh agent attacked the first draft of these packages: 25 exploits
across the five packages and 13 things the fleet package could not learn
from its block alone. All were closed before filing. The main changes:

- Criteria that could be met by a heading with no body, a qualifier
  ("unless asked"), a bulk tick at the end, or by deleting the thing the
  contract meant to protect were reworded to name the enacting sentence,
  forbid qualification, tick per commit, and retain existing bullets.
- Two skills would have stated two different "what an agent receives"
  lists; the list, the stop-report fields and the outcome values are now
  fixed texts in the preamble that every package quotes verbatim.
- The fleet package's collector would have been forbidden to read a diff
  while a retained sentence still told it to; both sentences now move.
- Package 2's Binds selector would have matched nothing on day one; it
  names a default set until ADRs are retrofitted.
- Spec's "distilled purpose line" would have been agent-authored text in
  a document that forbids that; it is now Maintainer-confirmed.
- The README's stale `.claude/skills/` claim appeared twice; the
  criterion is now "no occurrence remains".
- Every fact the fleet package would have had to look up (repo, story,
  contract, CI, versions, fixture command, where a block lives) is in the
  issue preamble.
