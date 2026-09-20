# maya-project

Project management hub for the Maya dates project (ADR 0010): all issues,
decisions, product docs, plans, research — and the project's Claude Code
skills, served from this repo as a plugin marketplace.

## Install the skills

```
/plugin marketplace add drewsonne/maya-project
/plugin install maya@maya-project
```

Skills are then invocable anywhere, namespaced: `/maya:maya-orient`,
`/maya:maya-plan`, and so on. See `plugins/maya/skills/README.md` for what
each does and how they chain. Skills change only via a commit here plus a
version bump in `plugins/maya/.claude-plugin/plugin.json`.

## The artifacts, and how work flows between them

Seven kinds of artifact. Four live as files in this repo, three as issues.

| artifact | lives in | what it is | written by |
|---|---|---|---|
| **Research** | `docs/research/` | A sourced fact about the world — a published date pair, a convention in the literature, a disagreement between authors. Never a choice. | `maya-record` |
| **ADR** | `docs/decisions/` | A choice that constrains the code, made by the Maintainer. Numbered, never rewritten — superseded by a later ADR. | `maya-record` |
| **Product** | `docs/product/` | The PRD: who the product is for and what it must get right. Outcomes, never technologies. | `maya-spec` (interview) |
| **Plan** | `docs/plan/` | Waves of work packages decomposed from stories — scope, contract, criteria, fixtures per package. | `maya-plan` |
| **Epic** | issue, label `epic` | A PRD outcome, long-lived. Few. Carries stories, never tasks directly. | `maya-plan` / by hand |
| **Story** | issue, label `story`, sub-issue of an epic | One outcome with acceptance criteria. The backlog — unbounded (ADR 0011). | anyone, any time |
| **Task** | issue, type `Task`, sub-issue of a story | One work package verbatim: one agent, one branch, one PR. Just-in-time only. | `maya-plan` |

Every skill acts at exactly one place in this flow — skills are the verbs,
artifacts are the nouns. `maya-orient` is the exception: it reads everything
and writes nothing (run it at session start).

```mermaid
flowchart TD
    SPEC([maya-spec<br/>interviews the Maintainer<br/>— gate G1]) --> P[Product PRD<br/>docs/product]
    REC([maya-record]) --> R[Research<br/>docs/research]
    REC --> A[ADR<br/>docs/decisions]
    R -->|"finding first, then a<br/>decision that cites it"| A
    P -->|each outcome| E[Epic]
    E --> ST[Story<br/>unbounded backlog]
    ST -->|"gate G2: Maintainer applies<br/>the authorized label"| PLAN([maya-plan<br/>decomposes, justified<br/>by PRD + ADRs])
    A --> PLAN
    PLAN --> PL[Plan<br/>docs/plan]
    PL -->|"wave in flight + 1 only"| T[Task]
    R -->|sourced vectors| FIX([maya-fixtures<br/>builds the correctness suite<br/>in maya-date-fixtures])
    FIX -->|"suite must exist and pass —<br/>gates arithmetic planning<br/>and every dispatch"| FLEET
    T --> FLEET([maya-fleet<br/>preflight, dispatch one wave,<br/>each agent under<br/>maya-implement rules])
    FLEET --> PR[Draft pull request<br/>on a satellite repo]
    PR --> REV([maya-review<br/>mechanical checks,<br/>then judgement])
    REV -->|"clean: auto-merge (ADR 0017);<br/>findings: queue for the Maintainer;<br/>Closes drewsonne/maya-project#N"| DONE[Task closed<br/>story rolls up<br/>epic closes at gate G1]
    DONE -.->|"release PR / deploy —<br/>gate G3, the Maintainer"| SHIP[Shipped<br/>pending story #16 ADR]
    ST -.->|"outgrows one outcome:<br/>relabelled epic in place,<br/>parts become new stories"| E
    REV -.->|"silent decision or fixture<br/>disagreement → maya-record"| REC
    FLEET -.->|"blocked, ambiguous,<br/>or plan proved wrong"| PLAN
```

Rounded nodes are skills; rectangles are artifacts. Not shown:
`maya-orient` (reads all of it), and `maya-implement`, which is not a step
but the rulebook every dispatched agent — and every hand-made change —
works under between dispatch and PR.

### Movement rules

- **Research → ADR.** When the literature says X and we therefore do Y,
  the finding is written first and the decision cites it — never merged
  into one document (`maya-record`).
- **Product → Epic.** Epics trace to PRD outcomes. A feature idea with no
  PRD outcome behind it prompts a `maya-spec` round, not a stealth epic.
- **Epic → Story.** Stories are created freely, at any time, for any
  future work (ADR 0011). Capturing an idea costs one issue; nothing worth
  doing lives only in a conversation.
- **Story → Epic (promotion).** A story that needs more than one coherent
  outcome is relabelled `epic` on the same issue; its parts become new
  stories beneath it. Demotion is the same move in reverse. Epics are
  earned from evidence of complexity, never guessed up front.
- **Story → Plan → Task.** When a story enters the active slice,
  `maya-plan` decomposes it into packages, each justified by the PRD or an
  ADR. Tasks exist for the wave in flight plus at most one planned ahead
  (ADR 0009); a queued wave is re-validated against `main` before dispatch.
  Decomposition is cheap to regenerate — a task inventory is a liability.
- **Task → PR → closed.** One task, one branch, one draft PR on the repo
  that owns the code, closing its task with the full cross-repo form
  (`Closes drewsonne/maya-project#N`). `maya-review` gates the merge; the Maintainer
  merges.
- **Task → PR: interfaces land first.** If package B needs a signature
  package A introduces, A lands it (a stub is enough) in an earlier wave.
  Two agents never negotiate an interface between themselves — they will
  produce two incompatible ones and both will pass their own tests.
- **Story → closed.** A story closes only when every task beneath it is
  closed *and* its acceptance is demonstrated against `main`, stated in a
  closing comment (ADR 0013). An epic closes when the Maintainer restates its PRD
  outcome as achieved.
- **Anything → Research/ADR (findings loop).** A fixture disagreement, a
  silent decision discovered in review, or a blocked package is a finding.
  It flows back through `maya-record` — the fixture is never edited to
  resolve it, and a planning error is fixed in the plan, not negotiated
  with the implementation.

### The Maintainer and the three guard gates

The pipeline runs autonomously except at three human guard gates
(ADR 0017), all held by the Maintainer (ADR 0015). A gate sits where a
mistake is irreversible, externally visible, or a value judgment —
never where correctness is mechanically checkable.

- **G1 — Decide.** Spec rounds (`maya-spec` never invents requirements),
  ADR acceptance, epic closure.
- **G2 — Authorize.** Autonomous work happens only on a story carrying
  the `authorized` label. The label covers planning and dispatching all
  of that story's waves, one at a time, until done or blocked; removing
  it revokes the authorization.
- **G3 — Ship.** Release-PR merges, deploys and plugin releases are the
  Maintainer's until the release ADR (story #16) says otherwise.

Between the gates, agents dispatch waves, merge **clean** PRs (verdict
merge, zero findings, full suite green, scope clean, no fixture edits),
close stories with demonstration comments, commit wave reports, and
merge Dependabot PRs when the target's full suite passes. Anything
weaker queues for the Maintainer with the evidence attached —
escalation is always to them, never around them. No scheduled or
background execution: autonomy runs in sessions the Maintainer kicks
off ("continue authorized work").

### State management: the board

The "Maya Dates" project board mirrors issue state (ADR 0018) — it is
how the Maintainer watches autonomous work move without reading
transcripts. Every issue is on it; transitions are performed by the
skill or agent that causes the state change, via
`scripts/board-status.sh <issue> <status>`: **Backlog** (filed) →
**Ready** (authorized wave, preflight passed) → **In progress**
(dispatched) → **In review** (draft PR open) → **Done** (closed). A
missing transition is a defect.

### Measuring the process

Every dispatched wave leaves a committed report in `docs/waves/`
(ADR 0012): packages, fixture results, criteria met, review verdicts,
findings count. Tuning the pipeline — the task horizon, package sizing,
skill wording — cites wave reports, not memory. The plugin itself is CI'd:
`.github/workflows/validate.yml` checks the marketplace and plugin
manifests, every skill's frontmatter, and that skill changes ship with a
version bump.

## Layout

- `STATE.md` — where things stand; start here.
- `docs/decisions/` — numbered ADRs. 0009: the issue model. 0010: this
  repo. 0011: stories as the unbounded backlog.
- `docs/product/` — the PRD and non-goals.
- `docs/plan/` — dependency-ordered work-package waves.
- `docs/research/` — sourced findings.
- `plugins/maya/skills/` — the eight skills (the `maya` plugin).

## The repos

- [`maya-date-fixtures`](https://github.com/drewsonne/maya-date-fixtures) — citation-backed correctness vectors (the dataset).
- [`maya-dates`](https://github.com/drewsonne/maya-dates) — the conversion library.
- [`maya-calculator-parser`](https://github.com/drewsonne/maya-calculator-parser) — date-expression parser.
- [`maya-calculator`](https://github.com/drewsonne/maya-calculator) — the app.
