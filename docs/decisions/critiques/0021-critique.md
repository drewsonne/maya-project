# Critique of ADR 0021 — devil's advocate (ADR 0020, stage 5)

Date: 2026-09-26. Produced by a fresh agent reading the draft cold, before
the ADR was committed. Points 1, 3, 4 and part of 5 were incorporated into
the draft; the disposition of each is noted at the end.

## 1. What breaks if the decision is wrong

The rule forbids continuity even when nothing has gone wrong. If the real
driver is error-conditioning (F2) rather than boundary-crossing, 0021 pays
full coordination cost for zero benefit and adds a new failure class: every
forced boundary is a re-specification, and re-specification from a partial
artifact is exactly the sharded-instruction condition F3 measures at -39%.
A wave that previously failed once inside one context now has ~10 places
to lose fidelity. And the rule is unenforceable: it is detected by a
session noticing its own drift — the precise faculty F1/F4 say degrades.
Unlike fixtures, CI and scope diffs (0017's entire design premise), nothing
mechanical catches a violation.

## 2. Who is harmed if it is right

Per 0017, autonomy runs only in Maintainer-kicked sessions, never
scheduled. Multiplying context boundaries multiplies restart points that
can stall on a human — reimposing, as latency, the touchpoint cost 0017
deleted. Cost: four packages become ~10 contexts, each re-paying preamble.
Quoting ADR clauses into packages forks the text from its source with no
sync mechanism — an amended or superseded ADR lives on verbatim in flight.
Lost insight: fleet's collect deliberately sees all packages at once; a
cross-package pattern is visible only to a context holding both.

## 3. Does F1–F6 support this rule?

- F1 measures degradation by token length, not by unit count. A unit is a
  poor proxy: one wave collect can dwarf three ADRs. Lost in the Middle is
  about retrieval position, not boundary discipline — stretched.
- F2 finds poisoning by the model's own prior mistakes, and that isolating
  execution helps. It supports ending a context that errs; it says nothing
  about ending a clean one.
- F3 is the strongest counter-evidence, cited as support. Its remedy is
  consolidating requirements into one shot; 0021 mandates more shards.
- F4 states an agent re-deriving its goal held adherence past 100k tokens.
  Recitation is already adopted — which makes the ending rule redundant.
- F5 describes coordinator + subagents and compaction; the coordinator
  persists across many subagents. "Coordinator ends after one wave" is not
  in F5, and compaction is never considered.
- F6 says explicitly that "the task was too long" is not a root cause — an
  argument against a length-prophylactic rule, cited for one.

## 4. Internal contradictions

- 0017 G2 authorizes "planning the story and dispatching its waves
  sequentially until the story is done." 0021 forbids both in one context.
  That is an amendment to an accepted ADR, filed as "Depends on."
- 0021's own unit "one wave" includes running suites, checking criteria,
  gap analysis, merging under G2, board updates and report commit —
  several levels of the tree. The unit boundary is arbitrary.
- The claimed gap "not for review fan-out" is largely false: 0020 already
  mandates fresh agents at stages 2, 3 and 5.
- `Binds: all skills; every level` names everything, so it selects
  nothing — the exemplar refutes its own stated purpose, and with
  0001–0020 unretrofitted the selector is unusable on day one.

## 5. Cheaper alternative

Split the ADR. Ship the handoff-sufficiency half now (self-contained
package blocks, fixed stop-report shape, PR criteria checklist, `Binds:`)
— well-supported by F4/F5, costs nothing, needs no new contexts. Replace
"one unit then end" with budget-and-trigger: a context ends on a measured
token/step budget, on an error it authored, or on a stop condition —
otherwise it compacts in place (F5) and recites its goal (F4). Name ADR
0012 wave telemetry and F6 breakdown-point attribution as the watch.

## Disposition

- 4a (0017 conflict): accepted. The ADR now states it amends 0017's
  reading: a story's authorization spans successive contexts.
- 4d (`Binds: all`): accepted. The line now names the seven skills and the
  task level, and the ADR says a `Binds:` that names everything is a
  smell.
- 3 (F3 and F6 cut the other way): accepted in part. Context no longer
  leans on length; it states that the handoff artifact must be the
  consolidated spec (F3's remedy), not a shard, and that F6 is why stop
  reports name a breakdown point.
- 2 (forked ADR quotes, lost cross-package view): accepted as
  consequences. Re-validation against `main` before dispatch is the sync;
  the coordinator keeps every package's table.
- 1 and 5 (drop the ending rule for clean contexts; budget-and-trigger):
  declined for the task and review levels, where the Maintainer's own
  observation of drift is the evidence and F2's isolation result applies.
  Accepted for the coordinator: it may persist across one wave and compact
  rather than end mid-wave. ADR 0012 telemetry is named as the watch,
  as in 0020.
