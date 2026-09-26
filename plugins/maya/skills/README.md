# Maya Dates project skills

Eight Claude Skills that manage this project: define the product, capture decisions, prove correctness, plan work, dispatch agents to do it, implement each package under fixed craft rules, and review the result.

Work is tracked per ADR 0009: all issues live on this hub repo as a native
sub-issue hierarchy — epic (label `epic`) → story (label `story`) → task
(type Task, a maya-plan package block). Tasks are created just-in-time, at
most the wave in flight plus one planned ahead; satellite-repo PRs close hub
tasks with the full cross-repo form (`Closes drewsonne/maya-project#N`).
Stories are the unbounded backlog (ADR 0011) — capture future work freely;
a story that needs breaking down is relabelled `epic` in place, its parts
becoming new stories beneath it.

Each is a directory containing a `SKILL.md`. Together they are served as the `maya` plugin from this repo's own marketplace (ADR 0010); see [Installing](#installing) below.

## The skills

| skill | job | reads | writes |
|---|---|---|---|
| `maya-orient` | session entry: repo map, work in flight, blockers, three sized next actions | everything | board corrections (ADR 0019) |
| `maya-spec` | interviews you into a product definition, one topic per round | — | `docs/product/` |
| `maya-record` | a settled decision (ADR) or a sourced finding | `docs/decisions/` | `docs/decisions/`, `docs/research/` |
| `maya-fixtures` | citation-backed correctness vectors; differential testing | `docs/fixtures/` | `docs/fixtures/` |
| `maya-plan` | spec → non-colliding work packages grouped into waves | `docs/product/`, `docs/decisions/` | `docs/plan/`, issues |
| `maya-fleet` | preflight gate → dispatch one wave → collect results | `docs/plan/`, `docs/fixtures/` | pull requests (through its agents), `docs/waves/` |
| `maya-implement` | the craft rules one dispatched agent works under: fixtures first, one package per context, criteria checklist in the PR from the first commit | its package block, the fixture command, the target repo's fixtures and code | one branch and one draft pull request on the target repo, or a stop report |
| `maya-review` | one pull request per context: mechanical checks, an adversarial pass, then judgement — one verdict, at most five findings | the PR diff, the package block its `Closes` line names, the ADR clauses that block binds | a verdict and findings on the pull request; a clean PR merged under G2 |

## How they chain

```
maya-spec ──► maya-fixtures ──► maya-plan ──► maya-fleet (preflight, dispatch)
                                                  │  one agent per package
                                                  ▼
                                            maya-implement ──► draft pull request
                                                                      │  one fresh agent per PR
                                                                      ▼
                                                                 maya-review
                                                                      │  verdict + findings
                                                                      ▼
                                                        maya-fleet (collect) ──► docs/waves/
                                                                      │
maya-orient (session start)                                           │
maya-record (whenever something settles) ◄────────────────────────────┘ findings, blocked packages
```

`maya-fixtures` sits between spec and plan deliberately. `maya-plan` refuses to plan calendar-arithmetic work that no fixture covers, and `maya-fleet` refuses to dispatch against a suite that does not pass. Without fixtures the chain is a locked door — which is the intended behaviour on a project where correctness is the product.

The lower loop is the wave. `maya-fleet` dispatches one agent per package, each working under `maya-implement` and ending when its draft pull request is open or its stop report is filed. At collection, `maya-fleet` fans review out: one fresh `maya-review` agent per pull request, whose verdict and findings the collecting context consumes without reading a diff itself. The fleet context never implements or reviews a package itself, and its wave report is committed to `docs/waves/` before the wave counts as collected.

## One context, one unit of work

Every context does one unit of work, then ends (ADR 0021, proposed): one package per implementing agent, ending at its draft pull request or stop report; one pull request per reviewing agent; one spec round, ADR, plan, wave or orientation per session. The context that plans never dispatches, the one that dispatches never implements, and a coordinator consumes tables and reports rather than doing a package itself. Every handoff is a written artifact sufficient on its own: a package block quoting its story, PRD outcome and binding ADR clauses; a fixed-shape stop report; a PR description carrying its acceptance criteria as a checklist from the first commit. The evidence behind the rule is collected in [`SOURCES.md`](SOURCES.md).

## Invoking them

Either let Claude trigger a skill from its `description`, or call it by name, namespaced by the plugin: `/maya:maya-orient`, `/maya:maya-plan`, and so on.

## Conventions they assume

The skills read and write a fixed layout. They create directories they need, but they expect this shape:

```
docs/
  product/      prd.md, non-goals.md, maintenance-backlog.md
  decisions/    NNNN-kebab-title.md   (Nygard ADRs)
  research/     <topic>.md            (sourced findings, citations required)
  fixtures/     *.yaml                (test vectors, citations required)
  plan/         <slug>.md             (waves and work packages)
  STATE.md      where things stand; open questions
```

They also assume the four-layer architecture from ADR 0001 — representation, operations, parsing, presentation, with dependencies pointing inward only — and the npm-workspaces monorepo from ADR 0002. **ADR 0002 has to land before `maya-plan` is useful**, because it scopes work packages against workspace paths and `maya-fleet` gates on one green `main` and one test suite.

## Rules worth knowing before you use them

These are enforced by the skills, not suggestions:

- **`maya-fixtures`: never generate an expected value from the code under test.** A fixture derived from the implementation proves only that it agrees with itself, and cements whatever is already wrong. Values come from a published source, an independent implementation, or hand calculation shown in the file.
- **`maya-fleet`: agents may never edit a fixture, spec, or expected value to make a test pass.** Doing so fails the package regardless of whether tests then pass. On a calendar tool, an agent that adjusts an expected date to get green has produced something worse than nothing.
- **`maya-plan`: no package whose acceptance criteria a human has to eyeball.** If it cannot be checked by a machine it cannot be dispatched.
- **`maya-spec`: the epigrapher test.** A requirement you cannot justify to a working epigrapher is marked `dx-only` and leaves the PRD. Not condemned — just not competing with product scope.
- **`maya-record`: one decision per file**, and every research claim carries author, year, and page or table number.

## Installing

The skills are served as the `maya` plugin from this repo's own marketplace (ADR 0010). Install once, in Claude Code:

```
/plugin marketplace add drewsonne/maya-project
/plugin install maya@maya-project
```

Installed users receive a skill change only through a version bump in `plugins/maya/.claude-plugin/plugin.json`: an edit lands here as a commit plus a bump, and CI refuses one without the other. Local copies are not a source — a skill directory copied into a project or home directory, or saved to a claude.ai account, does not update and is not the skill. This repo is the single source of truth.
