# 0010. Project management and skills live in maya-project, distributed as a Claude plugin marketplace

- Status: accepted
- Date: 2026-09-20
- Implementation: #20

## Context

ADR 0007 made `maya-date-fixtures` the hub, and ADR 0009 put the whole
epic → story → task hierarchy on it. That left the fixtures repo doing double
duty: ADR 0006 wants it to be a published, citable dataset, but its tracker
mixed dataset work with project management and its history mixed vectors with
process documents. Separately, the project skills existed as two copies — one
tracked in the hub, one loose and unversioned in the local workspace — because
working-directory skill discovery is per-repo and symlinks are not followed.
Claude Code plugin marketplaces solve the distribution half: a repo carrying
`.claude-plugin/marketplace.json` can serve versioned skills to any machine
and any working directory via `/plugin install`, namespaced (`maya:maya-plan`).

## Decision

We create `drewsonne/maya-project` and move the entire hub function to it:
`docs/decisions`, `docs/product`, `docs/plan`, `docs/research`, `STATE.md`,
all project issues (the ADR 0009 hierarchy included), and the eight project
skills — packaged as the `maya` plugin under `plugins/maya/skills/` and served
by the repo's own marketplace definition. `maya-date-fixtures` reverts to what
ADR 0006 describes: the dataset, its schema, and its harnesses, nothing else.
ADR 0009 stands unchanged except that every reference to "the hub" now means
`maya-project`; satellite PRs close tasks with
`Closes drewsonne/maya-project#N`.

## Consequences

The skills gain a single versioned home, installed once per machine with
`/plugin marketplace add drewsonne/maya-project` then
`/plugin install maya@maya-project`, and invoked namespaced. Unversioned
workspace copies become deletable. The fixtures repo becomes citable without
asking academics to wade through project management. Issue transfer preserved
numbers 1–9 and GitHub rewrote inbound references, so open PRs still close
their tasks.

It becomes true that skill edits ship only when committed to `maya-project`
and picked up on plugin update — local tweaks in a working copy no longer
take effect, which is the point. ADR 0007 is superseded by this decision.
The plugin's `version` field must be bumped for installed users to receive
skill changes.
