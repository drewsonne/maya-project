# 0021. One context does one unit of work, and every handoff is self-sufficient

- Status: accepted
- Date: 2026-09-26
- Implementation: #43
- Depends on: 0009, 0020
- Amends: 0017 (a story's authorization spans successive contexts)
- Binds: maya-plan, maya-fleet, maya-implement, maya-review, maya-orient, maya-record, maya-spec; the task level

## Context

The work tree runs product → epic → story → task → pull request, with ADRs
attached as cross-cutting constraints. Nothing says who walks it. In
practice one session has walked it end to end: interviewing the spec,
recording three ADRs, planning a wave and then starting to implement it.
The 2026-09-20 bootstrap that ADR 0016 had to backfill was one such walk.
The Maintainer's observation is the primary evidence: sessions deep in the
tree lose track of where they are and what was asked; agents given many
tasks in one run drift on the later ones.

The published evidence, collected in `plugins/maya/skills/SOURCES.md`,
separates that into mechanisms with different remedies. A model
conditioned on its own earlier steps makes more errors, and supplying the
plan up front and isolating execution lengthens what it can do (F2). A
wrong early turn is not recovered inside the same conversation, and the
remedy measured there is a consolidated specification rather than one
delivered in shards (F3). Goal adherence is held by recitation (F4). Clean
windows that return compact summaries scale (F5). Failures should be
attributed to a named breakdown point, not to "too long" (F6). Length
alone also degrades output (F1), but that is a reason to keep each
context small, not the reason for this rule.

The skills already isolate dispatched agents: `maya-fleet` gives each
agent one package, and ADR 0020 puts red-team, bad-faith review and
devil's advocate in fresh agents. They do not isolate the coordinating
session, do not fan review out one context per pull request, and the
artifacts passed between contexts are not written to be sufficient on
their own — an agent that needs the story, the PRD outcome or the binding
ADR has to go and find them.

## Decision

At the task and review levels, one context does one unit and ends: one
package per implementing context, ending when its draft pull request is
open or its stop report is filed; one pull request per reviewing context.
At the levels above, a context does one unit — a spec round, an ADR, a
plan for one story, one wave, one orientation — and then ends or, for a
wave coordinator only, compacts and continues into collection. The
context that plans never dispatches; the context that dispatches never
implements; a coordinator consumes tables and reports and never does a
package itself. This amends the reading of ADR 0017: a story's
authorization spans the successive contexts that plan and dispatch its
waves, not one long-lived session.

Every handoff across a context boundary is a written artifact that is the
consolidated specification for the receiving context, not a shard of it.
A package block carries its story number, the PRD outcome it serves and
the ADR clauses that bind it, quoted with their numbers. A stop report has
a fixed shape naming the step reached and the breakdown, which a fresh
context can resume from. A pull request description carries the
acceptance criteria as a checklist from its first commit, ticked as each
is met, so the goal is recited into the working context and handed to the
reviewer. An ADR carries a `Binds:` line naming the skills, layers or
levels it constrains, so a planner selects the few that apply; a `Binds:`
that names everything is a smell.

ADR 0012 wave telemetry is the watch: if stop reports and wave reports
show breakdowns clustering at the new boundaries rather than inside
contexts, a superseding decision relaxes the ending rule to a budget and
trigger.

## Consequences

More contexts and more writing at boundaries: a wave of four packages
costs four implementing agents, four reviewing agents and a coordinator,
where one session previously did it all, and each boundary is a place to
lose fidelity if the handoff is thin. In exchange each context starts
clean, and leaves a trail a human or a fresh context can pick up. The
coordinator keeps every package's table, so the cross-package view that
collection depends on is not lost.

ADR clauses quoted into a package fork from their source. The existing
re-validation of a queued wave against `main` before dispatch is where a
superseded clause is caught; a package quoting a superseded ADR is
re-planned.

Parallel edits to the plugin collide on the version line, because CI
requires a bump in every commit that touches `plugins/maya/`. Waves that
edit skills assign each package a distinct version and merge in order.

The rule is now a violation rather than a habit: a session about to start
a second unit stops and reports, as an agent stops on an ambiguous
criterion. It is not mechanically enforced; story #17's behavioural evals
are where enforcement would live. Existing ADRs 0001–0020 have no
`Binds:` line; retrofitting them is a story of its own.
