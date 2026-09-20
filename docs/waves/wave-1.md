# Wave 1 — schema and CI gate

- Date dispatched: 2026-09-20 (by hand, single package; no fleet run)
- Date collected: 2026-09-20
- Plan: `docs/plan/2026-09-13-fixtures-first.md`

| package | PR | fixtures | criteria met | scope | notes |
|---|---|---|---|---|---|
| wave-1-schema-ci | maya-date-fixtures#10 | n/a — package creates the gate; suite 11/11 green | 4/4, each verified via CLI exit code | clean, one flagged deviation (package-lock.json, plan amended) | merged 2026-09-20 |

- Review verdict: merge after named changes — 3 findings, all addressed
  (unknown-field rejection added; lockfile scope amended in plan and issue;
  derived→notes rule ratified).
- Findings count: 3 (0 fixture disagreements, 1 scope deviation, 2 judgement).
- Story #11 closed on demonstrated acceptance: validate workflow live and
  green on maya-date-fixtures `main`, both push and pull_request triggers.
