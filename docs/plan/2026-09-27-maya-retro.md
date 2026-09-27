# Plan: maya-retro, a periodic process and product review

Date: 2026-09-27. **1 package, 1 wave.** Target repo: `drewsonne/maya-project`
(the hub; the plugin lives here, ADR 0010). Story #76 (authorized by the
Maintainer) under epic #15. Amended 2026-09-27 after the review of the
first implementation, PR #80: see "Amendment after review of PR #80".

## For the Maintainer

This plans story #76 (the retro skill) as one piece of work, task #78.
Nothing is asked of you. The skill it adds can be merged before you decide
ADR 0024 (a retro may authorize process fixes, PR #77): until that ADR is
accepted on `main`, a retro files its process stories without `authorized`,
and nothing it adds lets a retro authorize anything.

The first build (PR #80) was reviewed as "merge after named changes": once
ADR 0024 is accepted, a retro story would have counted as authorized from a
line in its body even after you removed the `authorized` label. The fault
was in this plan's wording, so task #78 is amended: a retro story now needs
the `authorized` label, the `retro` label, its marker line and ADR 0024
accepted, and removing the label always revokes it. The fix goes on PR #80
as a second commit (plugin 1.11.1). Still nothing to do yet.

## What this plan covers

| story | what changes | package | wave |
|---|---|---|---|
| #76 | new `maya-retro` skill; "Retro due" in `maya-orient`; `maya-fleet` accepts a retro-authorized story only once ADR 0024 is accepted; the ADR 0024 guard re-check in `maya-plan` and `maya-review`; skills README; `docs/retros/README.md`; plugin 1.11.0, then 1.11.1 for the amendment | `wave-1-maya-retro-skill` (task #78) | 1 |

Story-level acceptance that needs a live retro (the first retro commits
`docs/retros/<date>.md`; the Maintainer confirms no question was about
implementation or project management; any story it authorized carries
`retro` and `authorized`), and ADR 0024's acceptance, are demonstrated on
story #76 after the package merges (ADR 0013). They are not package
criteria.

## Inputs read

- Story #76; the design `docs/plan/2026-09-27-maya-retro-design.md`
  (PR #74, branch `worktree-maya-retro-design`); ADR 0024 and its critique
  (PR #77, branch `adr-0024-retro-authorizes-process-fixes`); ADR 0023
  (PR #71). **Where ADR 0024 and the design differ, the ADR governs**: the
  interview filter is the ADR's sentence ("which product outcome the
  project pursues next", not "what the project does next"), the guard is
  the ADR's list (either direction, doubt means without), and the ADR's
  limits (only new stories, only when due, only after the balance answer,
  shown before the session ends, guard checked three times) are in the
  skill.
- ADRs 0009, 0012, 0015, 0017, 0020, 0021; `docs/product/prd.md` §6; the
  current `maya-orient`, `maya-fleet`, `maya-plan`, `maya-review` and
  skills README on `main` (9ce14d4, plugin 1.10.4).

## Decisions taken without asking (obvious defaults)

- **One package, size M.** CI (`.github/workflows/validate.yml`) fails any
  commit touching `plugins/maya/` without a `plugin.json` version change,
  so two skill packages cannot share a wave. Splitting would mean two or
  three sequential waves for one story. The red-team judged one package
  reviewable (see below), so it stays one.
- **Plugin 1.11.0.** A new skill is a minor bump. Description: "Nine
  skills that run the Maya dates project: orient, spec, record, fixtures,
  plan, fleet, implement, review, retro".
- **ADR 0024 is not accepted, so every authorizing path is conditional.**
  The retro's one authorizing command (fixed text T) runs the ADR 0024
  acceptance check (fixed text B: `docs/decisions/0024-*.md` on `main`
  has `- Status: accepted`) and adds the label only if it passes;
  `maya-fleet` counts a retro-authorized story as authorized only while
  that check passes and the story still carries `authorized` and `retro`
  (amended after the PR #80 review; see below). A retro-authorized story is recognised by the last
  line of its body, `Authorized by retro YYYY-MM-DD under ADR 0024.`,
  because the label alone cannot say who applied it (agents and the
  Maintainer act as the same account). The guard re-check in `maya-plan`
  and `maya-review` applies to such stories regardless.
- **The `retro` label was created at planning time** (2026-09-27, "Story
  filed by a maya-retro retro (ADR 0024)"), not by the package: it is repo
  configuration, not a file a PR can carry, and a label nothing uses yet
  is harmless. The skill also creates it if it is ever missing.
- **Where "Retro due" counts waves.** Wave reports carry no uniform date
  line (two of seven lack `- Date collected:`), so a wave counts as
  collected on the date its report was first committed to `main`. The
  check (fixed text C) was run on 2026-09-27: `last=2026-09-13 waves=7
  days=14`, due.
- **The fleet text is a new paragraph in Phase 2**, not a preflight check:
  the sentence story #76 quotes ("the wave's story carries the
  `authorized` label, applied by the Maintainer") is in Phase 2, and
  adding a paragraph there leaves preflight check 7, which PR #72 edits,
  untouched.
- **A guard crossing at planning** removes `authorized` from the story and
  assigns it to the Maintainer (ADR 0024: "stopped and queued for the
  Maintainer"); at review, no agent merges the PR and it is queued.
- **Retro stories go under epic #15** (the delivery pipeline) unless their
  outcome belongs to another open epic.
- **This PR is never agent-merged.** It changes an authorization rule, so
  under ADR 0023 (if accepted) it is G1, and under ADR 0017 no clean-merge
  rule covers it either way; review queues it for the Maintainer.

## Open work this plan defers (fleet preflight check 7)

- **PR #72** (review sweep for PRs outside a wave, branch
  `review-prs-outside-a-wave`, plugin 1.10.5, task #63, story #61) is open
  and waiting on the Maintainer. It edits `maya-fleet` (check 7),
  `maya-orient` (steps 4 and 6), `maya-review` (Rules and a new section
  before `## Rules`) and `plugin.json`. **Explicitly deferred:** this
  package branches from `main` as it is; whichever of the two merges second
  rebases onto `main` and resolves the text conflicts by keeping both
  changes. After the amendment this package is 1.11.1: if #72 merges second,
  it bumps past it (1.11.2); if this package merges second, it keeps
  1.11.1 and does not rebase (conflicts are resolved at merge time). The fixed texts were placed to
  avoid #72's hunks where they could: the fleet paragraph is in Phase 2,
  the review section is appended after Rules, not before it.
- **Story #66's wave 3** (questions for the Maintainer as `question`
  issues; not filed) will touch `maya-plan`, `maya-fleet`, `maya-review`,
  `maya-implement`, `maya-record` and `maya-orient`. It is planned after
  this wave and must branch from a `main` that carries plugin 1.11.0, or
  rebase. The retro's live interview is the one exception to #66, stated
  in ADR 0024 and in the skill.
- **Horizon (ADR 0009).** Open task issues: #63 (wave 2 of the skill
  follow-ups plan, PR #72) and #8/#9 (the fixtures plan, another story).
  This plan files one wave for story #76, within the one-in-flight plus
  one-planned limit.

## Conflict check

One package in the wave, so no two packages share a path glob. Checked.
`depends_on` is empty. No calendar arithmetic is touched, so no fixture
package is needed; the fixture command is the structural skill check.
No layer imports are involved (layer 0, process).

## Re-validate before dispatch (fleet check 9)

`main` still carries the anchors the block names: in `maya-orient` the
paragraph beginning `**Three things you could do next**`; in `maya-fleet`
the Phase 2 paragraph beginning `This is what the Workflow tool is for`;
in `maya-plan` the heading `## Output`; in `maya-review` the `## Rules`
list as the last section; in the skills README the sentence beginning
`Eight Claude Skills` and the `  plan/ ` layout line. If ADR 0024's text
changes before dispatch, re-plan the quoted clauses and fixed texts D, E
and F.

## Red-team (ADR 0020)

Two fresh agents, before filing.

**Exploit pass** (satisfy the criteria while defeating the goal). It judged
one package reviewable in one pass: eight files, about 80% fixed text checked
mechanically, and inert until ADR 0024 is accepted. It found, and the block
now fixes:

1. A retro could add `authorized` without the marker line, so no re-check
   would fire. Fixed text T now also requires the issue to carry `retro` and
   end with the marker before adding the label.
2. "Inside/outside the guard" could be read either way, and whose
   classification wins was unclear. New fixed text V: both the retro and a
   fresh challenge agent must class a story as not crossing; disagreement
   means not authorized.
3. Fleet text L gave only a necessary condition, so fleet would still refuse
   a retro story. L now says it counts as Maintainer-applied while the ADR
   0024 check passes, and stops otherwise.
4. The existing skills could gain extra lines (a second authorize path)
   without failing any check. New criterion 12 whitelists every added line.
5. The fixed-text check was set-based (scrambled lines passed) and several
   placements were unchecked. Replaced with a contiguity check, no HTML
   comments, and placement checks for every fixed text in every file.
6. Review re-checked the guard but not ADR acceptance, and failed open on a
   lookup error. N now re-runs the acceptance check and fails closed.
7. A second retro before the first report merged could authorize three more.
   New limit: one authorizing retro per period.
8. The due check failed open (offline fell back to "due"). C now checks it is
   in a hub clone and that the fetch worked, and prints nothing otherwise.
9. Gather returned figures without sources, so "pattern only" could not cite
   evidence. It now returns each figure's source.
10. The report was committed before stories existed and before the
    Maintainer could strike one. Act is now ordered: file, show, strike,
    then commit.
11. A skipped balance question was an escape. Skipping it now means none
    authorized.
12. Criterion 5's label regex was easy to dodge. Widened to `-l`,
    `labels[]=` and `/labels`.
13. `wc -l` on macOS pads its output. Replaced by `cmp`.
14. Rules and the interview were free text. Rules is now fixed text U,
    including "never ask the Maintainer to approve, rank, size or schedule a
    story", and a criterion keeps every `?` inside `## 4. Ask`.
15. A struck story kept its marker. Striking now replaces it with
    `Filed by retro YYYY-MM-DD; not authorized.`
16. Smaller: the fixture command now checks line 4; README placements are
    checked; "no bug label" is reported, not 0 (the hub has no `bug` or
    `correctness` label).

**Cold implementation from the block alone.** First pass: all 14 criteria
met, 17 gaps. The block now adds the facts that were missing: the current
plugin version, and what #72, #66, #8 and epic #15 are; the sub-issue
command; where B goes in the retro; the exact order of the Authorizing
section; the README sentence fix; who merges the report PR (the Maintainer;
the retro never does); filing commands carry only `--label story --label
retro`; striking a story is not a question; the fixture command runs under
`bash -c`; the commit subject; the fetch only updates remote-tracking refs;
where the due line is recorded. Second pass on the revised block: criteria 1
to 15 pass (16 needs a push). Its three remaining gaps were fixed before
filing: criterion 5 uses `grep -rh`; C "prints nothing on stdout"; and the
one-retro-per-period search counts only issues whose body has a `by retro`
line (it prints 0 today, so the first retro is not blocked).

## Amendment after review of PR #80 (2026-09-27)

Task #78 was implemented as draft PR #80 (branch `maya-retro-skill`, one
commit `c0b770f`, plugin 1.11.0). The review
([verdict comment](https://github.com/drewsonne/maya-project/pull/80#issuecomment-5858279339))
said "merge after named changes" and traced every finding to this block's
fixed texts, not the implementation: once ADR 0024 is accepted, `maya-fleet`
(fixed text L) and `maya-review` (fixed text N) would count a story as
retro-authorized from its `Authorized by retro ` line alone, without the
`authorized` label. Removing the label would not revoke it, and writing the
line into any story would authorize it. The block below is amended; the fix
lands as a second commit on `maya-retro-skill` (see "Landing").

**The rule now.** A retro story is one that carries the `retro` label or has
a line beginning `Authorized by retro `. It counts as authorized only while it
carries both `authorized` and `retro`, has that line, was created (UTC) on the
line's date, and the ADR 0024 acceptance check (fixed text B) exits 0. The
line records where authorization came from and never authorizes on its own.
Removing `authorized` revokes the story; a retro story whose line is gone is
not authorized even if it keeps the label. The Maintainer authorizes a
retro-filed story directly by removing `retro` first.

**What changed in the block.**

| fixed text | change |
|---|---|
| L (`maya-fleet`) | the five-part rule above; any failure, or a check that cannot run, means not authorized and stop |
| N (`maya-review`) | the same rule for active G2; checks every issue the PR closes and each one's parent; a PR with a `Closes` line whose lookup fails crosses the guard, and a PR with no `Closes` line is left to the existing rules |
| M (`maya-plan`) | the same rule, and M now runs B (added under M, before E). A story that does not count as authorized gets no package and no edit. A package that crosses the guard: remove `authorized`, then (only after that succeeds) replace the marker with `Filed by retro YYYY-MM-DD; not authorized.` with a command that cannot blank the body, assign, comment, list |
| T (`maya-retro`, the one authorizing command) | also requires the `story` label, the issue created today (UTC), the marker dated today (UTC) and last in the body, no `Filed by retro ` line, and fewer than three `retro` stories created today already carrying `authorized` (the cap). Still the only line in any skill that adds the label |
| B (acceptance check) | exactly one `0024-*` file, its first `- Status:` line is `- Status: accepted`, and `maya-retro` is on `main` (the ADR's second condition) |
| C, K (retro due) | fail closed in a shallow clone; only non-README `.md` files in `docs/waves/` count; the fetch names its destination so `origin/main` is current |

Criteria: 4, 5 (also case variants and line continuations), 9 (B in plan),
11 and 12 (evaluated on the net diff of both commits against `main`), 15
(1.11.1) and 16 changed; 17 (two commits, the first `c0b770f` unchanged),
18 (the second commit's files and version bump), 19 (no superseded text) and
20 (the retro prose on the UTC marker date and shallow clones) are new.

**Landing.** CI fails a commit touching `plugins/maya/` whose `HEAD^..HEAD`
diff does not change the plugin.json `version` line, and agents never
force-push. So the fix is a second commit on `maya-retro-skill` on top of
`c0b770f`, setting 1.11.1; the first commit is unchanged. PR #72 (review
sweep, 1.10.5) is still open: if #80 merges first, #72 goes to 1.11.2 when it
is rebased.

**Advisory points from the review, disposed.**

| point | disposition |
|---|---|
| T checks only three things; an old story becomes authorizable by rewriting its last line | adopted (required amendment 4): marker date and creation date must be today (UTC); also the `story` label, no `Filed by retro ` line, and the cap of three |
| C: in a shallow clone every wave counts as new | adopted: C exits non-zero in a shallow clone (small, fails closed) |
| C: any file in `docs/waves/` counts, including a future README | adopted: only `.md` files other than `README.md` count |
| B takes the first `0024-*` file | adopted: exactly one match, else exit non-zero |
| B cannot confirm "the pull request that adds `maya-retro` has merged" | adopted: B also requires `plugins/maya/skills/maya-retro/SKILL.md` on `main` |
| The retro report's PR waits for the Maintainer, so the same period still shows due | not adopted: the reviewer found it fails closed, and fixing it means changing fixed text F's period rule, which is outside this amendment |
| The label is applied before the Maintainer sees the list | not adopted: ADR 0024 sets this order, and a fleet run needs filed task packages first, which only a separate `maya-plan` context files, so the gap cannot be reached within a retro session |

**Red-team of the changed texts (ADR 0020).**

*Exploit pass* (satisfy the amended criteria while leaving a second route or
a fail-open path). Findings and fixes:

1. Blocking: L, M and N recognised a retro story only by its marker line.
   Deleting or reformatting the line on a story with `retro` and
   `authorized` (for example if a strike rewrote the marker but the label
   removal failed) made it look Maintainer-authorized and skipped B and the
   guard. Fixed: a retro story is recognised by the `retro` label or the
   line, and one with `authorized` but no marker is not authorized.
2. Blocking: M could strip the marker while `authorized` stayed. Fixed by 1,
   and M now rewrites the marker only after the label removal succeeds.
3. M's body rewrite could blank the story if the read failed. Fixed: the
   body is read into a variable and must be non-empty.
4. M revoked a story permanently when B merely could not run. Fixed: a story
   that does not count as authorized (including B failing) gets no package
   and no edit; only a guard crossing revokes.
5. N checked the parent of one task only. Fixed: every `Closes` issue and its
   parent.
6. N's fail-closed sentence also caught PRs that close no hub issue
   (Dependabot, ADR 0022), changing existing review behaviour. Fixed: it
   applies only when the PR has a `Closes` line.
7. T did not check the `story` label, a `Filed by retro ` line or the cap.
   Fixed in T.
8. Nothing downstream re-checked T's date condition. Fixed: L, M and N
   require the story's creation date (UTC) to equal the marker's date.
9. Criterion 5 missed case variants and line-continued commands; criterion
   20 passed with the old C sentence kept. Fixed: criterion 5 adds a
   case-insensitive `--add-label` count and a no-line-continuation check;
   criterion 19 fails on the old sentence. (A case-insensitive version of
   the main criterion 5 grep was tried and rejected: it matches fixed text
   F's `Authorized by retro` plus `--label retro` line.)
10. C could read a stale `origin/main` in a single-branch clone. Fixed: the
    fetch writes `refs/remotes/origin/main` explicitly.
11. B accepted a `- Status: accepted` line anywhere in the ADR. Fixed: only
    the first `- Status:` line counts.
12. The block's ADR 0024 paragraph named only the ADR file. Fixed: it also
    names `maya-retro` on `main`.

It confirmed B, T's jq (13 synthetic issues), C's arithmetic and M's sed
behave as the block claims.

*Cold implementation from the block alone* (in a scratch clone, nothing
pushed): every local criterion passed. Gaps closed in the block: the
superseded texts are now located for the implementer (same first words; the
old B and T contain `][0] // empty`); where the UTC-date sentence goes
(directly after T's fence) and a criterion that it exists (20); the retro's
sentence after C must now name the shallow clone, checked by 19 and 20;
criterion 4's "first non-blank line" now has an `awk` command; M's heading
and blank line stay and only its paragraph changes; `jq` is named as a
required tool. After both passes the final block was re-checked in the same
scratch clone: criteria 1 to 15, 16's fixture command, 17 (local parts), 18,
19 and 20 all pass.

## Wave 1

### wave-1-maya-retro-skill (task #78)

The block below is the body of task #78, verbatim.

Work package for story drewsonne/maya-project#76, epic #15. Repo: `drewsonne/maya-project` (the hub), default branch `main`. The plugin is `plugins/maya/`; CI is `.github/workflows/validate.yml` and must pass on the branch. This task is hub issue drewsonne/maya-project#78.

**Why.** Story #76: "Every few waves the Maintainer can run a retro that scores how well the process ran and how far the product moved, compares both with the previous retro, asks the Maintainer only product, strategy and vision questions, and files (and, within a guard, authorizes) stories that fix process problems." The Maintainer asked on 2026-09-27 for a way for the skills to learn what worked and what did not, and said questions to them are fine only about product, strategy and vision, never implementation or project management. ADR 0012 already makes every wave commit a report so tuning "can cite wave reports instead of memory", but nothing reads those reports. This package adds the reader: a ninth skill, `maya-retro`; a "Retro due" rule in `maya-orient`; and the changes in `maya-fleet`, `maya-plan` and `maya-review` that let a retro-authorized story flow through them, re-checked against a guard.

**ADR 0024 is not yet accepted.** ADR 0024 (a retro may authorize process fixes) is proposed in hub PR #77. Everything in this package that lets a retro authorize a story works only once `docs/decisions/0024-*.md` on `main` carries the line `- Status: accepted` and `maya-retro` is on `main`, tested by fixed text B. Until then a retro files every process story without `authorized`. This is what makes the package safe to merge before the ADR is accepted. Do not create, edit or accept any ADR.

**This block was amended after review; the work is a second commit.** The block was first implemented as draft PR #80 (branch `maya-retro-skill`, one commit `c0b770fb2f4b76b65fe7b8cc6b832c2a49080974`, plugin 1.11.0). Its review (verdict "merge after named changes", https://github.com/drewsonne/maya-project/pull/80#issuecomment-5858279339) found that, once ADR 0024 is accepted, `maya-fleet` and `maya-review` would treat a story as retro-authorized from its `Authorized by retro ` line alone, even with the `authorized` label removed, so removing the label could not revoke it and writing the line into any story would authorize it. The review traced every finding to this block's fixed texts, not the implementation. So on 2026-09-27 the block was amended: fixed texts B, C, K, L, M, N and T changed (and the explanations under B, C, J and T), the version is now 1.11.1, and criteria 4, 5, 9, 11, 12, 15 and 16 changed and 17 to 20 are new. Your job is to bring the branch in line with the amended block by one more commit on top of `c0b770f`, as set out under **Working**. Everything in `c0b770f` that the amendment does not touch stays as it is.

**The rule the amendment sets.** A retro story is one that carries the `retro` label or has a line beginning `Authorized by retro `. It counts as authorized only while all five hold: it carries the `authorized` label; it carries the `retro` label; its body has a line beginning `Authorized by retro `; it was created (UTC) on that line's date; and fixed text B exits 0. The line only records where the authorization came from and never authorizes on its own; removing `authorized` revokes the story, and a retro story whose marker is gone is not authorized even if it keeps the label (the Maintainer authorizes such a story directly by removing `retro` first).

**Terms used below.** (`gh`, `git` and `jq` are on the path; T and the fixture command use `jq` itself, not only `gh --jq`.)
- *The Maintainer*: the project's owner role (ADR 0015: skill text names the role, never a person). `<login>` in a command is the owner of the hub repo, `drewsonne`.
- *G1, G2, G3*: the three gates of ADR 0017 (when agents may merge). G1 decide (spec, ADR acceptance, epic closure), G2 authorize (autonomous work happens only on a story carrying the `authorized` label), G3 ship (releases).
- *Process ADR* (ADR 0023, proposed in PR #71): an ADR that "changes only how agents work. It touches no gate, nothing on the whitelist above, no agent permission, no rule on what an agent may merge or what counts as a clean verdict, no authorization rule, no review or fixture-integrity rule, and no product or domain convention."
- *Wave report*: a file in `docs/waves/` on `main`, committed when a `maya-fleet` wave is collected. Its reports have no fixed date line, so a wave counts as collected on the date its file was first committed to `main`.
- *Retro report*: `docs/retros/YYYY-MM-DD.md`, named by the date of the retro. The newest is the last retro. With none, the period starts 2026-09-13 (the PRD interview).
- *The `retro` label*: already exists on the hub (created at planning time, 2026-09-27). It marks every story a retro files.
- *Existing labels* on the hub: `story`, `epic`, `authorized`, `blocked`, `retro`, `wave-N`, `layer-0`, `size-XS|S|M|L`. There is no `question`, `bug` or `correctness` label on the hub. Board moves use `scripts/board-status.sh <n> <Backlog|Ready|"In progress"|"In review"|Done>` from the hub root.
- *Epic #15*: the hub epic "The product ships through an autonomous, measured delivery pipeline"; process stories go under it. A story is attached to an epic as a sub-issue with `gh api -X POST repos/drewsonne/maya-project/issues/15/sub_issues -F sub_issue_id=$(gh api repos/drewsonne/maya-project/issues/<n> --jq .id)`.
- *Story #66*: an authorized hub story that will make agents file every question for the Maintainer as a hub issue labelled `question`; not yet in the skills.
- *Hub task #8*: an open task that will build a harness running the fixture suite against the published library.
- *PR #72*: an open hub PR (review sweep for PRs outside a wave) that sets plugin 1.10.5 and edits `maya-fleet`, `maya-orient`, `maya-review`; not merged. On `main` today `plugin.json` is 1.10.4; the first commit on `maya-retro-skill` set 1.11.0. Set the version to 1.11.1 whatever the current value. If PR #80 merges before #72, #72 moves to 1.11.2 when it is rebased; that is #72's work, not yours.

**Contract.** Only the eight files in scope change; `docs/retros/README.md` and `plugins/maya/skills/maya-retro/SKILL.md` are the only new files. Every SKILL.md keeps `---`, `name:`, `description:`, `---` as its first four lines. In the existing skills every rule keeps its meaning: the fixed texts only add. In particular `maya-fleet`'s nine preflight checks keep their numbers and text, and its sentence "the wave's story carries the `authorized` label, applied by the Maintainer" stays word for word; `maya-orient` stays read-only apart from its board reconciliation; `maya-review`'s mechanical checks, verdicts and existing Rules bullets are unchanged. No file under `docs/decisions/`, `docs/product/` or `docs/waves/` changes. Skill text names the role, never a person (ADR 0015). Fixed texts are copied line for line: do not rewrap, reflow or re-punctuate them; a line of a fixed text must appear as a whole line of the target file. The one command in any skill that adds `authorized` to an issue is fixed text T; no skill counts a story as authorized from its `Authorized by retro ` line without the `authorized` label.

**Fences.** A fixed text placed "in a fenced code block" is opened and closed by a bare ```` ``` ```` line (no language tag). No other fences are added to the four existing skills.

**Placeholders inside fixed texts** (`<n>`, `<login>`, `<date>`, `YYYY-MM-DD`) are part of the text and stay as written.

### Fixed text A: maya-retro frontmatter (lines 1 to 4 of the new file)

~~~text
---
name: maya-retro
description: Run a periodic retro of the Maya dates project live with the Maintainer. Scores how well the process ran and how far the product moved, compares both with the last retro, asks only product, strategy and vision questions, and files stories that fix process problems. Use when maya-orient says a retro is due, or the Maintainer asks for one.
---
~~~

### Fixed text B: the ADR 0024 acceptance check

~~~text
f=$(gh api 'repos/drewsonne/maya-project/contents/docs/decisions?ref=main' --jq '[.[].name | select(startswith("0024-"))] | if length == 1 then .[0] else empty end') && test -n "$f" && gh api -H 'Accept: application/vnd.github.raw' "repos/drewsonne/maya-project/contents/docs/decisions/$f?ref=main" | grep -m1 '^- Status:' | grep -qx -- '- Status: accepted' && gh api 'repos/drewsonne/maya-project/contents/plugins/maya/skills/maya-retro/SKILL.md?ref=main' --jq .name >/dev/null
~~~

It exits 0 only when exactly one file in `docs/decisions/` on `main` starts `0024-`, that file's first line starting `- Status:` is exactly `- Status: accepted`, and `plugins/maya/skills/maya-retro/SKILL.md` is on `main` (ADR 0024: "until this ADR is accepted and the pull request that adds `maya-retro` has merged, no retro authorizes anything"). Two files starting `0024-`, a lookup error or a missing file all mean exit non-zero. On 2026-09-27 it exits 1 (ADR 0024 and `maya-retro` are not on `main`); the same command with `0022-` in place of `0024-` and `maya-orient` in place of `maya-retro` exits 0.

### Fixed text C: the retro due check (run from the root of a hub clone)

~~~text
git remote get-url origin | grep -qE '[:/]drewsonne/maya-project(\.git)?$' && [ "$(git rev-parse --is-shallow-repository)" = false ] && git fetch -q origin +main:refs/remotes/origin/main && { last=$(git ls-tree --name-only origin/main docs/retros/ | sed 's#^docs/retros/##' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' | sort | tail -1 | cut -c1-10); last=${last:-2026-09-13}; waves=0; for w in $(git ls-tree --name-only origin/main docs/waves/ | grep -E '\.md$' | grep -v '/README\.md$'); do d=$(git log origin/main --diff-filter=A --format=%cs -- "$w" | tail -1); [[ "$d" > "$last" ]] && waves=$((waves+1)); done; days=$(( ( $(date -u +%s) - $(date -u -j -f %Y-%m-%d "$last" +%s 2>/dev/null || date -u -d "$last" +%s) ) / 86400 )); echo "last=$last waves=$waves days=$days"; [ "$waves" -ge 3 ] || { [ "$days" -ge 14 ] && [ "$waves" -ge 1 ]; }; }
~~~

It prints the last retro's date, the waves collected after it and the days since it, and exits 0 exactly when a retro is due. It prints nothing on stdout and exits non-zero outside a hub clone, in a shallow clone (where every wave would look new) or when the fetch fails: that means the check was skipped, and a retro that was not shown due authorizes nothing. Only `.md` files in `docs/waves/` other than a `README.md` count as wave reports. The fetch names its destination, so `origin/main` is current even in a single-branch clone, and it only updates remote-tracking refs. On 2026-09-27 it printed `last=2026-09-13 waves=7 days=14` and exited 0.

### Fixed text D: the interview filter (ADR 0024, word for word)

~~~text
A question is asked only when its answer could change what the product is, who it is for, or which product outcome the project pursues next, and only the Maintainer can give it; a question about how, when, in what order, which package or which tool is decided by the retro or turned into a process story.
~~~

### Fixed text E: the guard (in maya-retro, maya-plan and maya-review, word for word in all three)

~~~text
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
~~~

### Fixed text F: the limits (maya-retro; ADR 0024)

~~~text
- **Only new stories.** A retro never adds `authorized` to an existing story and never widens an authorized one.
- **Only when due.** A retro authorizes only when the retro due check exited 0 at the start of this retro.
- **Only after the balance answer.** Stories are filed after the interview. If the Maintainer skips the balance question, answers that too much effort is going to process, or the answer leaves it in doubt, the retro authorizes none.
- **One authorizing retro per period.** A retro authorizes nothing if a retro already filed a story after the last retro's date (a hub issue labelled `retro` whose body has a `Filed by retro` or `Authorized by retro` line): `gh issue list --repo drewsonne/maya-project --label retro --state all --search 'created:>YYYY-MM-DD "by retro" in:body' --json number --jq length` must print 0, with the last retro's date, when checked before this retro files any story.
- **Cap.** At most three authorized stories per retro.
- **Pattern only.** Each is for a measure that worsened against the previous retro, or a problem of the same kind that occurred at least twice in the period, with that evidence cited in the story.
- **Shown before the session ends.** The retro lists, in plain words, every story it authorized before the session ends; this is a statement, not a question. One the Maintainer strikes loses the label, and its marker line is replaced with `Filed by retro YYYY-MM-DD; not authorized.`
- **The guard is checked three times.** A fresh challenge agent checks each story's guard classification before it is authorized; `maya-plan` re-checks each package; `maya-review` re-checks each pull request. A package or pull request that crosses the guard is stopped and queued for the Maintainer.
~~~

### Fixed text G: the process scorecard (maya-retro)

~~~text
| measure | what it tells us | good direction |
|---|---|---|
| Review queue: PRs waiting on the Maintainer, and the oldest one's age | Whether the old failure (eleven PRs unmerged for eight months) is returning | fewer, younger |
| Draft to merge: median days from a PR opening to its merge | How fast finished work lands | shorter |
| First-pass rate: share of packages ending `ok`; verdicts split merge / merge after named changes / reject and re-plan | Whether packages were planned and built well first time | higher |
| Stop reports: count, grouped by cause (ambiguous criterion, fixture disagreement, scope, undecided question) | Planning defects | fewer; no repeated cause |
| Repeat findings: the same kind of review finding on three or more PRs, or in two retros running | Where a skill's wording is not landing | none |
| Guardrail breaches: fixture edits, scope violations, an author reviewing their own work | Whether the hard rules hold | zero; any breach is serious |
| Process share: share of merged PRs on the hub (process) against merged PRs on every other maya repo (product), Dependabot excluded | How much effort goes to running the machine | not scored; shown as a trend and asked about |
~~~

### Fixed text H: the product scorecard (maya-retro)

~~~text
| measure | what it tells us |
|---|---|
| Sourced vectors, by provenance (attested, derived, unverified) and by area (winal rollover, proleptic Gregorian, Haab convention, Calendar Round ambiguity, correlation constants, distance numbers, rejection cases) | How complete the yardstick is; an area with no attested vector is a blind spot |
| Pass rate against each surface: libraries, app | The success test itself; an app not yet running the suite is shown as "not wired", never omitted |
| PRD outcomes touched: which had merged work in the period, which had none | Whether effort is spread across what the product promises |
| Epigrapher-visible changes: merged work that passes the epigrapher test from `maya-spec` | Whether the product changed from the user's side |
| Open correctness bugs: count and age | Wrong arithmetic, which outranks everything |
~~~

### Fixed text R: the interview questions (maya-retro)

~~~text
1. Direction: "Here is what moved and what did not. Is this the direction you want for the next period?"
2. Balance: "X% of the effort went to process. Is that the right balance for now?"
3. The user: "Is the epigrapher checking their own working still who this is for? Have you seen or heard anything that changes that?"
4. The test: "Is 'the app passes every sourced vector' still the right success test?"
5. Next outcome: "These PRD outcomes had no work this period. Which matters most next?"
~~~

### Fixed text I: the report sections, in order (maya-retro)

~~~text
1. **For the Maintainer**: whether the retro was due (the line the retro due check printed), what changed since the last retro, and what, if anything, the Maintainer needs to do.
2. **Process scorecard**: each figure with better, worse or unchanged against the last retro.
3. **Product scorecard**: likewise.
4. **Claims and challenges**: each claim and whether it survived the challenge.
5. **Interview**: each question and the answer as given; skipped ones marked unanswered.
6. **Actions**: process stories filed, each linked and marked authorized or not; follow-up stories for `maya-spec` and `maya-record`.
~~~

### Fixed text S: authorization waits for ADR 0024 (maya-retro)

~~~text
**Until ADR 0024 is accepted, a retro authorizes nothing.** ADR 0024 (a retro may authorize process fixes) lets a retro label a process story `authorized` only once it is accepted. Run the ADR 0024 acceptance check before authorizing any story. While it does not exit 0, file every process story with `story` and `retro` and without `authorized`, end its body with the line `Filed by retro YYYY-MM-DD; not authorized.`, and say in the Actions section that ADR 0024 is not yet accepted, so nothing was authorized.
~~~

### Fixed text T: the only command that authorizes (maya-retro)

~~~text
(f=$(gh api 'repos/drewsonne/maya-project/contents/docs/decisions?ref=main' --jq '[.[].name | select(startswith("0024-"))] | if length == 1 then .[0] else empty end') && test -n "$f" && gh api -H 'Accept: application/vnd.github.raw' "repos/drewsonne/maya-project/contents/docs/decisions/$f?ref=main" | grep -m1 '^- Status:' | grep -qx -- '- Status: accepted' && gh api 'repos/drewsonne/maya-project/contents/plugins/maya/skills/maya-retro/SKILL.md?ref=main' --jq .name >/dev/null) && d=$(date -u +%F) && gh issue view <n> --repo drewsonne/maya-project --json labels,body,createdAt | jq -e --arg d "$d" '([.labels[].name] | index("retro")) != null and ([.labels[].name] | index("story")) != null and (.createdAt[0:10] == $d) and (.body | test("(^|\n)Filed by retro ") | not) and (.body | test("(^|\n)Authorized by retro " + $d + " under ADR 0024\\.\\s*\\z"))' >/dev/null && [ "$(gh issue list --repo drewsonne/maya-project --label retro --label authorized --state all --search "created:$d" --json number --jq length)" -lt 3 ] && gh issue edit <n> --repo drewsonne/maya-project --add-label authorized
~~~

Fixed text T is one line: fixed text B in parentheses, then today's UTC date, then a check that the issue carries `retro` and `story`, was created today (UTC), has no `Filed by retro ` line, and its body ends with fixed text J carrying today's UTC date, then a check that fewer than three `retro` issues created today already carry `authorized` (the cap), then the label command. Put it in a fenced code block. It adds `authorized` only when the acceptance check passes and all three hold, so an existing story cannot be made authorizable by rewriting its last line, and a marker from another day never passes. A retro therefore writes the marker with `date -u +%F`; a retro that crosses midnight UTC authorizes nothing more that day. Tested 2026-09-27: it does nothing for 0024; the jq test (`jq -e`, which exits 0 only on `true`) passes for a `retro` issue created today whose body ends with today's marker, and fails when the `retro` or `story` label is missing, the marker's date or the creation date is another day, a `Filed by retro ` line is present, or a line follows the marker.

### Fixed text V: the order of authorizing (maya-retro)

~~~text
Order: draft the stories and classify each against the guard; dispatch a fresh challenge agent with the drafts, your classifications and the guard, and have it classify each as crossing the guard or not crossing it; file every draft with `story` and `retro`; then, only for a story that both you and the challenge agent classed as not crossing the guard, and that is within the limits above, append the marker line to its body and run the authorizing command. A story either classed as crossing, or where the two disagree, is not authorized.
~~~

### Fixed text U: the Rules section of maya-retro (the whole section body)

~~~text
- Ask only questions that pass the interview filter, and only in the interview.
- Never ask the Maintainer to approve, rank, size or schedule a story; showing the authorized stories is a statement, and the Maintainer strikes one by saying so.
- Every claim cites its evidence.
- Never run `maya-spec`, `maya-record`, `maya-plan` or `maya-fleet`.
- Never add `authorized` except by the command in "Authorizing process stories".
- Never merge the retro report's pull request; assign it to the Maintainer.
~~~

### Fixed text J: the marker line (maya-retro)

~~~text
Authorized by retro YYYY-MM-DD under ADR 0024.
~~~

Every story a retro authorizes ends its body with this line, with the retro's date, which is today's UTC date (`date -u +%F`). `maya-fleet`, `maya-plan` and `maya-review` treat a story as a retro story when it carries the `retro` label or has a line beginning `Authorized by retro `, and count it as authorized only while it carries both the `authorized` and `retro` labels, has that line, was created (UTC) on the line's date, and fixed text B exits 0. The line alone never authorizes, and a retro story with `authorized` but no marker is not authorized.

### Fixed text W: Writing for the Maintainer (maya-retro; word for word as in maya-orient, maya-fleet, maya-review and maya-implement)

~~~text
**Writing for the Maintainer.** Write text the Maintainer reads (a report, a verdict comment, a wave report, a pull request description, `docs/STATE.md`) in plain language:
- Put what the Maintainer needs to know or do first.
- Use short sentences, one idea each, and everyday words.
- Say what each issue or PR is, not only its number: "fixtures #16 (rollover vectors)", not "#16".
- The first time an ADR, gate or label appears, explain it in a few words: "ADR 0017 (when agents may merge)", not "ADR 0017" or "G2".
- Use a list or a table for three or more items.
- Leave out process detail the Maintainer does not need in order to act.
~~~

### The maya-retro skill: headings and what goes under each

`grep -E '^#{1,3} ' plugins/maya/skills/maya-retro/SKILL.md` must print exactly these lines, in this order, and no others (a line starting `#` inside a fenced code block counts, so write none there):

~~~text
# Run a retro
## When it runs
## One retro per context
## 1. Gather
## 2. Score
### Process scorecard
### Product scorecard
## 3. Challenge
## 4. Ask
## 5. Act
## The retro report
## Authorizing process stories (ADR 0024)
## Rules
~~~

What each section says. Fixed texts go under the heading named; everything else is your wording, within these facts.

- **When it runs.** The retro runs only when the Maintainer invokes it, in a live session; there are no scheduled or unattended retros. `maya-orient` says when one is due and never runs one. Fixed text C, in a fenced code block, with one sentence on what it prints, that exit 0 means due, and that no output means the check was skipped. Run it first; the line it printed goes in the report's "For the Maintainer" section. A retro that was not shown due still runs if the Maintainer asked, but authorizes nothing.
- **One retro per context** (ADR 0021: a context does one unit of work). Gathering and challenging are each done by a fresh agent the retro dispatches; the retro context consumes their tables and never reads raw evidence itself.
- **1. Gather.** A fresh agent reads the period's evidence (from the last retro's date to today) and returns the two scorecard tables' figures, each with the wave report, pull request, commit or fixture file it came from, and nothing else. Sources: the wave reports in `docs/waves/` committed in the period (outcomes `ok | blocked | failed`, review verdicts, stop reports under `notes`); pull requests on every non-archived `drewsonne/maya*` repo opened, merged or open in the period, with their review verdict comments; the hub's git history; the fixture dataset in `drewsonne/maya-date-fixtures`, where every file under `fixtures/` is a YAML list of records each with a `provenance:` of `attested`, `derived` or `unverified`. Areas map to files: winal rollover `positional-rollover.yaml`, proleptic Gregorian `proleptic-western.yaml`, Haab convention `haab-seating.yaml`, Calendar Round ambiguity `calendar-round-ambiguity.yaml`, correlation constants `correlation-constants.yaml`, distance numbers `distance-numbers.yaml`, rejection cases `rejection.yaml`; any other file is reported under its own name. Pass rate: a surface with no CI job running the fixture suite against it is "not wired" (on 2026-09-27 neither the libraries nor the app has one; hub task #8 builds the library harness). PRD outcomes are the hub's epics (label `epic`); work counts for an outcome when a PR merged in the period closes a task under one of its stories. The epigrapher test (`maya-spec`): a change counts when it can be justified in one sentence to a working epigrapher checking their own arithmetic; list each with that sentence. Open correctness bugs are open issues labelled `correctness` or `bug` on any maya repo, with the oldest one's age; a repo with neither label is reported as "no bug label", not as 0. Nothing new is logged: evidence comes only from what already exists.
- **2. Score.** Fixed text G under `### Process scorecard` and fixed text H under `### Product scorecard`. Set each figure against the previous retro's report as better, worse or unchanged. A measure is **working** when it held or improved against the previous retro; **not working** when it worsened or a problem occurred twice in the period. A single bad event is noted, not acted on. The first retro has no previous figures and reports levels only, saying so.
- **3. Challenge** (ADR 0020, adversarial review). A fresh devil's-advocate agent, never one that gathered or scored, attacks every "worked" and "did not work" claim against the evidence. A claim that does not survive is dropped or marked disputed.
- **4. Ask.** Show both scorecards in plain language, then interview the Maintainer one question at a time. Fixed text D, then fixed text R, then: at most two more questions from this retro's findings, each passing fixed text D (for example "Haab convention has no attested vectors. Does it matter to the user yet?"). Question 2 (balance) is asked at every retro, before any story is filed. Answers are recorded in the retro report in the Maintainer's words; "no change" is an answer and is recorded; a skipped question is marked unanswered and may be asked again next retro. Because the Maintainer is present, answers are not filed as `question` issues; this is the one exception to story #66 (questions for the Maintainer are asked as issues), stated in ADR 0024. The interview is the only moment the retro asks the Maintainer anything; showing the list of authorized stories (fixed text F) is a statement, not a question.
- **5. Act.** In this order: file process stories (see "Authorizing process stories"); show the Maintainer every story authorized and remove the label from any they strike; file follow-up stories (an answer that changes the PRD becomes a story for `maya-spec`, one that settles a decision a story for `maya-record`; the retro never runs those skills); then write and commit the retro report with links to every story filed. Every story the retro files is on the hub, labelled `story` and `retro`, a sub-issue of epic #15 unless its outcome belongs to another open epic (the sub-issue command is in "Terms" above; write it in the skill), placed on the board with `scripts/board-status.sh <n> Backlog`, and cites its evidence (the scorecard figure and the wave report, PR or retro report it came from). Filing commands pass only `--label story --label retro`; put no filing command on a line that also contains the word `authorized` (criterion 5).
- **The retro report.** Written to `docs/retros/YYYY-MM-DD.md` with the retro's date, with fixed text I as its sections, in that order, each a `##` heading in the report. It is committed to the hub on a branch `retro-YYYY-MM-DD` by a pull request whose description opens with a "For the Maintainer" section; the retro assigns that pull request to the Maintainer (`gh pr edit <n> --repo drewsonne/maya-project --add-assignee <login>`) and never merges it. The next retro reads the newest report for its comparison figures. Fixed text W closes this section.
- **Authorizing process stories (ADR 0024).** The section is, in this order: fixed text S; fixed text B in a fenced code block; one or two sentences of yours saying that, once the check passes, a retro may label a process story it files `authorized` as well as `retro`, only within the limits and the guard, and that the story then flows through `maya-plan`, `maya-fleet` and `maya-review` like any authorized story; the heading-free line `**Limits.**` followed by fixed text F; fixed text E; fixed text V; fixed text J in a fenced code block; fixed text T in a fenced code block; then sentences of yours: the marker is written with today's UTC date (`date -u +%F`), because T checks it; the Maintainer revokes a story by removing the label; and if the `retro` label is missing it is created with `gh label create retro --repo drewsonne/maya-project --description "Story filed by a maya-retro retro (ADR 0024)"`.
- **Rules.** Exactly fixed text U, nothing else.

### Fixed text K: the "Retro due" rule (maya-orient)

A new paragraph in section 6, placed directly after the paragraph that begins `**Three things you could do next**`, then fixed text C in a fenced code block directly after it:

~~~text
**Retro due.** When a retro is due, one of the three next actions is "Run a retro (`maya-retro`)", sized S, in the hub repo. A retro is due when either holds: three or more waves have been collected since the last retro; or fourteen or more days have passed since the last retro and at least one wave was collected in that time. The last retro is the newest `docs/retros/YYYY-MM-DD.md` on `main`; with none, the period starts 2026-09-13, the PRD interview. A wave counts as collected on the date its report in `docs/waves/` was first committed to `main`. The command below, run from the root of a hub clone, prints the figures and exits 0 exactly when a retro is due; if it prints nothing on stdout (outside a hub clone, in a shallow clone, or the fetch failed), say the check was skipped. The fetch only updates remote-tracking refs, so orient stays read-only. Orient reports that a retro is due; it never runs one.
~~~

### Fixed text L: retro-authorized stories at dispatch (maya-fleet)

A new paragraph in Phase 2, placed directly after the existing paragraph that begins `This is what the Workflow tool is for` (the paragraph holding the sentence "the wave's story carries the `authorized` label, applied by the Maintainer"; that paragraph is unchanged):

~~~text
A story is a retro story when it carries the `retro` label or its body has a line beginning `Authorized by retro `: a `maya-retro` retro filed it under ADR 0024 (a retro may authorize process fixes), and any authorization it carries came from the retro, not from the Maintainer directly. Its `authorized` label counts as applied by the Maintainer, because ADR 0024 amends G2 for these stories, only while it carries both the `authorized` and `retro` labels, its body has a line beginning `Authorized by retro `, it was created (UTC) on the date in that line, and the ADR 0024 acceptance check below exits 0; the line never authorizes on its own, and removing `authorized` revokes it (`gh issue view <n> --repo drewsonne/maya-project --json labels,body,createdAt` shows the first four). If any of them fails, or cannot be checked, treat the story as not authorized and stop. To authorize a retro story directly, the Maintainer removes its `retro` label and adds `authorized`.
~~~

Then fixed text B in a fenced code block, directly after that paragraph.

### Fixed text M: the guard re-check at planning (maya-plan)

A new section placed directly before `## Output`, consisting of these lines, a blank line, fixed text B in a fenced code block, a blank line, and fixed text E:

~~~text
## Retro stories (ADR 0024)

A story is a retro story when it carries the `retro` label or its body has a line beginning `Authorized by retro `: a `maya-retro` retro filed it under ADR 0024 (a retro may authorize process fixes), and any authorization it carries came from the retro, not from the Maintainer directly. It counts as authorized only while it carries both the `authorized` and `retro` labels, its body has a line beginning `Authorized by retro `, it was created (UTC) on the date in that line, and the ADR 0024 acceptance check below exits 0; the line never authorizes on its own, and removing `authorized` revokes it (`gh issue view <n> --repo drewsonne/maya-project --json labels,body,createdAt` shows the first four). For a retro story that does not count as authorized, including when the check does not exit 0 or cannot be run, file no package for it, change nothing on the issue, and list it in the plan document under the heading "Stopped at the ADR 0024 guard" with the condition that failed. Before filing any package for a retro story that counts as authorized, check the package against the guard below. A package that touches anything on the guard, or where it is in doubt, crosses the guard. Then file no package for the story; remove `authorized` from it (`gh issue edit <n> --repo drewsonne/maya-project --remove-label authorized`); only after that succeeds, replace its marker line with `Filed by retro YYYY-MM-DD; not authorized.`, keeping the retro's date (`b=$(gh issue view <n> --repo drewsonne/maya-project --json body --jq .body) && [ -n "$b" ] && printf '%s\n' "$b" | sed -E 's/^Authorized by retro ([0-9]{4}-[0-9]{2}-[0-9]{2}).*$/Filed by retro \1; not authorized./' | gh issue edit <n> --repo drewsonne/maya-project --body-file -`); assign it to the Maintainer (`gh issue edit <n> --repo drewsonne/maya-project --add-assignee <login>`, where `<login>` is the owner of the hub repo); comment on it naming the package and the guard item crossed, in plain words; and list the package in the plan document under the heading "Stopped at the ADR 0024 guard".
~~~

### Fixed text N: the guard re-check at review (maya-review)

A new section appended at the end of the file, after the Rules list, consisting of these lines, a blank line, fixed text B in a fenced code block, a blank line, and fixed text E:

~~~text
## Retro stories (ADR 0024)

Find every hub issue the pull request closes: each `Closes drewsonne/maya-project#<k>` line in its description names one. For each `<k>`, check that issue and its parent (`gh api repos/drewsonne/maya-project/issues/<k>/parent --jq .number`), reading each with `gh issue view <i> --repo drewsonne/maya-project --json labels,body,createdAt`. A story is a retro story when it carries the `retro` label or its body has a line beginning `Authorized by retro `: a `maya-retro` retro filed it under ADR 0024 (a retro may authorize process fixes), and any authorization it carries came from the retro, not from the Maintainer directly. If any of them is a retro story, the review checks the diff against the guard below. A pull request that touches anything on it, or where it is in doubt, crosses the guard: that is a finding naming the guard item, no agent merges the pull request whatever its verdict, and it is queued for the Maintainer as the Rules above set out. A retro story counts as an active G2 authorization only while it carries both the `authorized` and `retro` labels, its body has a line beginning `Authorized by retro `, it was created (UTC) on the date in that line, and the ADR 0024 acceptance check below exits 0; the line never authorizes on its own, and removing `authorized` revokes it. If the pull request has a `Closes drewsonne/maya-project#<k>` line and any of these commands fails, including a `/parent` lookup that finds no parent, treat the pull request as crossing the guard.
~~~

### Fixed text O: the skills README (`plugins/maya/skills/README.md`)

1. The first sentence starts `Nine Claude Skills that manage this project:` in place of `Eight Claude Skills that manage this project:`, and its ending `, and review the result.` becomes `, review the result, and look back at how it went.`; nothing else in that sentence changes.
2. This row is added as the last row of the table under `## The skills`:

~~~text
| `maya-retro` | a retro run live with the Maintainer when orient says one is due: process and product scorecards compared with the last retro, product-only questions, process stories filed (authorized only under ADR 0024) | `docs/waves/`, `docs/retros/`, pull requests and verdicts, the fixture dataset | `docs/retros/`, stories labelled `retro` |
~~~

3. This line is added as the last line inside the code block under `## How they chain`:

~~~text
maya-retro (when orient says a retro is due) ──► docs/retros/, process stories ──► maya-plan
~~~

4. This line is added directly after the line starting `  plan/ ` in the layout code block under `## Conventions they assume`:

~~~text
  retros/       YYYY-MM-DD.md         (retro reports; the newest is the next retro's baseline)
~~~

### Fixed text P: `docs/retros/README.md` (the whole file, one line)

~~~text
Retro reports written by `maya-retro`, one per retro, named `YYYY-MM-DD.md`; the newest is the baseline the next retro compares against.
~~~

### Fixed text Q: plugin.json description

~~~text
Nine skills that run the Maya dates project: orient, spec, record, fixtures, plan, fleet, implement, review, retro
~~~

**Fixture command** (a process package has no calendar fixtures, so this structural gate is the whole suite):
`bash -c 'for f in plugins/maya/skills/*/SKILL.md; do sed -n 1p "$f" | grep -qx -- "---" && sed -n 2p "$f" | grep -q "^name:" && sed -n 3p "$f" | grep -q "^description:" && sed -n 4p "$f" | grep -qx -- "---" || exit 1; done && jq -e ".name and .version and .description" plugins/maya/.claude-plugin/plugin.json'`
(run it with `bash -c` as written, so its `exit 1` does not close your shell).

**How to check "fixed text X is in file F".** Save the fixed text's lines (between the `~~~` fences, exactly) to `x.txt`; then `n=$(wc -l < x.txt | tr -d ' '); grep -xF -A$((n-1)) -- "$(head -1 x.txt)" F | head -n "$n" | diff - x.txt` prints nothing, and `grep -c '<!--' F` prints 0. This passes only when the fixed text appears in F as one contiguous run of whole lines, in order.

**How to check "fixed text X is under heading H in F".** Define `h() { n=$(grep -nxF -- "$1" "$2" | head -1 | cut -d: -f1); [ -n "$n" ] && head -n "$n" "$2" | grep -E '^#+ ' | tail -1; }`; then `h "<first line of X>" F` prints H.

**Working.** Work on the existing branch `maya-retro-skill` and its draft PR #80; do not create a new branch or PR. In a fresh worktree, `git fetch origin` and check out `maya-retro-skill` at `origin/maya-retro-skill`, whose only commit on top of `main` is `c0b770fb2f4b76b65fe7b8cc6b832c2a49080974`. Replace, in every file that holds it, each line of the superseded fixed texts B, C, K, L, M, N and T with the amended text. The superseded texts are the lines `c0b770f` put where each amended text goes (`git show c0b770f` shows them); every one is a single line that starts with the same words as its amended version, except that the old B line starts `f=$(gh api` and contains `][0] // empty`, and the old T line starts `(f=$(gh api` and contains the same. Where they sit: B in `maya-retro`, `maya-fleet` and `maya-review`, each in its fenced block, and B is newly added to `maya-plan` in a new fenced block between M's paragraph and E (M's heading and blank line are unchanged; only its paragraph line changes); C in `maya-retro` and `maya-orient`; K in `maya-orient`; L in `maya-fleet`; N's paragraph line in `maya-review`; T only in `maya-retro`. In `maya-retro` also: change the sentence after C so it says that no output on stdout means the check was skipped (outside a hub clone, in a shallow clone, or the fetch failed); and add one sentence directly after T's fenced block, before the sentence on revoking, saying the marker is written with today's UTC date (`date -u +%F`) because T checks it. Set the version to 1.11.1. Change nothing else: `docs/retros/README.md`, `plugins/maya/skills/README.md` and the plugin.json description stay as the first commit left them. Commit once, on top of `c0b770f`, with subject `fix(maya-retro): require the authorized label for retro stories` and a body naming the review comment above, then `git push origin maya-retro-skill` (a plain push). CI (`.github/workflows/validate.yml`) fails any commit that touches `plugins/maya/` without changing the plugin.json `version` line, comparing only `HEAD^..HEAD`, and agents never force-push; so never amend, rebase, squash or force-push, and if you need to fix your commit before pushing, reset it (`git reset --soft HEAD^`) and commit again, keeping `c0b770f` as its parent. When you finish, the branch holds exactly two commits: `c0b770f`, unchanged, then yours. Criteria 1 to 15 are checked on the tree at your commit, and 11 and 12 on the net diff of both commits against `main`. Then edit PR #80's description: its "For the Maintainer" section says in plain words what the second commit changed and why (link the review comment), the acceptance criteria below replace the old checklist as a `- [ ]` list, and `Closes drewsonne/maya-project#78` stays. Keep the PR a draft. Never merge, never push to `main`. This PR changes an authorization rule, so no agent merges it: the review queues it for the Maintainer whatever its verdict. Hub PR #72 (review sweep, plugin 1.10.5) is open and also edits `maya-fleet`, `maya-orient`, `maya-review` and `plugin.json`: do not rebase onto `main` even if #72 has merged; the criteria compare against the merge base (`origin/main...HEAD`), and any conflict is resolved at merge time by keeping both changes. Stop and file a stop report (`package`, `step reached`, `attempted`, `failed`, `branch`, `question`) if a criterion is ambiguous, `origin/maya-retro-skill` is not `c0b770f`, the contract would have to be broken, or CI cannot be made green.

```
id:           wave-1-maya-retro-skill
goal:         The Maintainer can run a retro with the new maya-retro skill, orient says when one is due, and a retro-authorized story passes fleet, plan and review only while it carries the `authorized` and `retro` labels, ADR 0024 is accepted, and it is outside the guard.
story:        #76 "Every few waves the Maintainer can run a retro that scores how well the process ran and how far the product moved, compares both with the previous retro, asks the Maintainer only product, strategy and vision questions, and files (and, within a guard, authorizes) stories that fix process problems."
outcome:      PRD §6 (the success test: "The app reproduces every citation-backed fixture vector [...] with zero failures") via epic #15 (an autonomous, measured delivery pipeline): the product scorecard measures distance to §6 every retro, and the process scorecard is the pipeline's measurement, read from the wave reports ADR 0012 already requires.
binds:        - ADR 0024 (proposed) "A retro may label a process story it files `retro` and `authorized` when it files it, and that story then flows through `maya-plan`, `maya-fleet` and `maya-review` like any other authorized story."
              - ADR 0024 (proposed) "The retro's challenge agent checks each authorized story's guard classification, not only its scorecard claims; `maya-plan` re-checks each package; and `maya-review` re-checks each pull request. A package or pull request that crosses the guard is stopped and queued for the Maintainer."
              - ADR 0024 (proposed) "Until this ADR is accepted and the pull request that adds `maya-retro` has merged, no retro authorizes anything."
layer:        0 process
scope:        plugins/maya/skills/maya-retro/SKILL.md (new)
              plugins/maya/skills/maya-orient/SKILL.md
              plugins/maya/skills/maya-fleet/SKILL.md
              plugins/maya/skills/maya-plan/SKILL.md
              plugins/maya/skills/maya-review/SKILL.md
              plugins/maya/skills/README.md
              plugins/maya/.claude-plugin/plugin.json
              docs/retros/README.md (new)
contract:     see Contract above
criteria:     Let S=plugins/maya/skills. "X is in F" and "X is under H" are checked as set out above.
              1. `git diff --name-only origin/main...HEAD | sort` prints exactly the eight scope paths, sorted.
              2. `sed -n 1,4p $S/maya-retro/SKILL.md` prints exactly fixed text A.
              3. `grep -E '^#{1,3} ' $S/maya-retro/SKILL.md` prints exactly the heading list, in order.
              4. Fixed texts B, C, D, E, F, G, H, I, J, R, S, T, U, V and W (as amended) are each in $S/maya-retro/SKILL.md, under these headings: C under `## When it runs`; D and R under `## 4. Ask`; G under `### Process scorecard`; H under `### Product scorecard`; I and W under `## The retro report`; B, E, F, J, S, T and V under `## Authorizing process stories (ADR 0024)`; U under `## Rules`. The first non-blank line after `## Authorizing process stories (ADR 0024)` is the first line of S (`awk '/^## Authorizing process stories \(ADR 0024\)$/{f=1;next} f&&NF{print;exit}' $S/maya-retro/SKILL.md` prints it), and `grep -A1000 -x '## Rules' $S/maya-retro/SKILL.md | sed 1d | grep -v '^$' | diff - <U>` prints nothing, where `<U>` is a file holding fixed text U.
              5. `grep -rh 'authorized' $S | sed 's/--remove-label authorized//g' | grep 'authorized' | grep -E -- '(-l |--label|--add-label|labels(\[\])?=|labels"? *:|/labels)'` prints exactly one line, and it is fixed text T; `grep -rhoiE -- '--add-label +[^ ]+' $S | grep -ci 'authorized'` prints 1 (no other case of the label is added); `grep -c '\\$' $S/maya-retro/SKILL.md` prints 0 (no line-continued commands).
              6. `grep -n '?' $S/maya-retro/SKILL.md | grep -v -e 'ref=main' -e 'git remote get-url origin'` (which leaves out the lines of B, C and T) prints only lines under `## 4. Ask` (check each with `h`).
              7. Fixed texts K and C are in $S/maya-orient/SKILL.md; `grep -A2 -F '**Three things you could do next**' $S/maya-orient/SKILL.md | tail -1` prints the line of K; `grep -c 'three or more waves' $S/maya-orient/SKILL.md` and `grep -c 'fourteen or more days' $S/maya-orient/SKILL.md` each print 1.
              8. Fixed texts L and B are in $S/maya-fleet/SKILL.md; `grep -A2 -F 'This is what the Workflow tool is for' $S/maya-fleet/SKILL.md | tail -1` prints the line of L; `h` on B prints `## Phase 2 — dispatch`.
              9. Fixed texts M, B and E are in $S/maya-plan/SKILL.md; `h` on B and on the first line of E each print `## Retro stories (ADR 0024)`; `grep '^## ' $S/maya-plan/SKILL.md | grep -A1 -x '## Retro stories (ADR 0024)' | tail -1` prints `## Output`.
              10. Fixed texts N, B and E are in $S/maya-review/SKILL.md; `h` on B and on the first line of E each print `## Retro stories (ADR 0024)`; `grep '^## ' $S/maya-review/SKILL.md | tail -1` prints `## Retro stories (ADR 0024)`.
              11. Nothing is removed from the four existing skills, on the net diff against `main` (both commits together): `git diff origin/main...HEAD -- $S/maya-orient $S/maya-fleet $S/maya-plan $S/maya-review | grep '^-' | grep -vc '^--- '` prints 0.
              12. Nothing else is added to them, on the net diff against `main` (both commits together), so no line of the superseded fixed texts survives: with `allfixed.txt` holding the amended fixed texts K, C, L, B, M, E and N concatenated, `git diff -U0 origin/main...HEAD -- $S/maya-orient $S/maya-fleet $S/maya-plan $S/maya-review | grep '^+' | grep -v '^+++ ' | sed 's/^+//' | grep -vxF -e '' -e '```' | grep -vxFf allfixed.txt` prints nothing.
              13. In $S/README.md: `grep -c 'Eight'` prints 0; `grep -c '^Nine Claude Skills that manage this project:.*, review the result, and look back at how it went\.$'` prints 1; the three lines of fixed text O are each in it; `grep -A1 -F '| `maya-review` |' $S/README.md | tail -1` prints the row of fixed text O; the line after the layout line of fixed text O starts `  STATE.md`; the line after the chain line of fixed text O is a bare ```` ``` ````.
              14. `printf '%s\n' '<fixed text P>' | cmp - docs/retros/README.md` exits 0.
              15. `jq -r .version plugins/maya/.claude-plugin/plugin.json` prints `1.11.1`; `jq -r .description plugins/maya/.claude-plugin/plugin.json` prints fixed text Q.
              16. The fixture command exits 0 and the `validate` workflow is green on the PR's head commit.
              17. The branch holds exactly two commits and the first is unchanged: `git rev-list --count origin/main..HEAD` prints 2; `git rev-parse HEAD^` prints `c0b770fb2f4b76b65fe7b8cc6b832c2a49080974`; `git show HEAD^:plugins/maya/.claude-plugin/plugin.json | jq -r .version` prints `1.11.0`; `git ls-remote origin refs/heads/maya-retro-skill | cut -f1` prints the same SHA as `git rev-parse HEAD`.
              18. The second commit touches only the amended files and bumps the version: `git diff --name-only HEAD^ HEAD | sort` prints exactly `plugins/maya/.claude-plugin/plugin.json`, `plugins/maya/skills/maya-fleet/SKILL.md`, `plugins/maya/skills/maya-orient/SKILL.md`, `plugins/maya/skills/maya-plan/SKILL.md`, `plugins/maya/skills/maya-retro/SKILL.md`, `plugins/maya/skills/maya-review/SKILL.md`, in that order; `git diff HEAD^ HEAD -- plugins/maya/.claude-plugin/plugin.json | grep -c '^+ *"version"'` prints 1.
              19. No superseded text survives in any skill: `grep -rcF -e '][0] // empty' -e 'docs/waves/); do' -e '| grep -qx true &&' -e 'if it prints nothing, the check was skipped' $S | grep -v ':0$'` prints nothing.
              20. The `maya-retro` prose matches the amendment: `grep -c 'date -u +%F' $S/maya-retro/SKILL.md` prints 2 (T and the new sentence); `grep -c 'shallow clone' $S/maya-retro/SKILL.md` prints 1 or more.
fixtures:     the fixture command above
depends_on:   none
size:         M
```
