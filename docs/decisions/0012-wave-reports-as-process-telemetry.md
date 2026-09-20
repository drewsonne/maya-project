# 0012. Every dispatched wave leaves a committed wave report

- Status: accepted
- Date: 2026-09-20

## Context

The pipeline's tuning constants — the task horizon (ADR 0009), package
sizing, the wording of the skills — are currently adjusted on instinct.
The fleet's collect phase already produces the needed evidence (packages
dispatched, fixtures passed, criteria met, scope violations, review
findings) but it evaporates with the conversation. ADR 0011 makes epics
earned from evidence; the process itself deserves the same standard.

## Decision

Every `maya-fleet` run commits its collect table to
`docs/waves/<wave-id>.md` in this repo before the wave is considered
collected. The report carries: the wave id and date, one row per package
(PR, fixtures result, criteria met, scope check, notes), the review
verdicts, and a findings count. Waves executed by hand (no fleet run) get
the same report written by whoever collected them.

## Consequences

Horizon, sizing and skill changes can cite wave reports instead of
memory. Trends — rising findings per wave, repeated fixture
disagreements, scope violations — become visible in git history. The
cost is one small committed file per wave. `maya-fleet` gains the step;
a wave without a report is not complete.
