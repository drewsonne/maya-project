# Wave — ADR devil's advocate critiques (story #41)

- Date dispatched: 2026-09-20 (Maintainer instruction; `authorized` on #41)
- Date collected: 2026-09-21
- Shape: 10 parallel agents, 2 ADRs each, cold reads (ADR 0020 independence)
- Output: one critique per ADR under `docs/decisions/critiques/`

| ADR | verdict | one-line |
|---|---|---|
| 0001 | worth-revisiting | layer-equals-package assumption never weighed against intra-package enforcement; split straddles the shared mixed-radix arithmetic |
| 0002 | worth-revisiting | stands only while its mitigations (CI, bumps) stay alive — the thing that decayed last time |
| 0003 | worth-revisiting | core unassailable; still `proposed` while wave 3 approaches needing it |
| 0004 | worth-revisiting | fixture gate excellent; "enforceability requires a separate package" is the weak link (see 0001) |
| 0005 | worth-revisiting | diagnosis right; two open questions should be settled at acceptance, not during |
| 0006 | worth-revisiting | dataset repo decision decisive; release mechanics of the *published* dataset unspecified |
| 0007 | superseding-candidate | already superseded by 0010 — critique confirms the history, nothing to do |
| 0008 | worth-revisiting | division correct; scope/enforcement (CI pairing check) is where it will fail |
| 0009 | worth-revisiting | hierarchy/JIT stand; the horizon constant's revisit trigger was arguably pulled by 0017 same-day |
| 0010 | worth-revisiting | marketplace solves a real problem; single point where a plugin version lag stalls every consumer |
| 0011 | worth-revisiting | capture-free insight right; promotion-in-place can nest epics and dodge PRD tracing — needs a rule |
| 0012 | worth-revisiting | reports load-bearing for 0017/0020 yet schema-less and unenforced by CI |
| 0013 | worth-revisiting | closure prose is the one non-mechanical, non-adversarial link in the chain |
| 0014 | worth-revisiting | sound; majors-auto-on-green success criterion is untestable in thin-coverage repos |
| 0015 | stands | — |
| 0016 | stands | enforcement partly honour-system, but cheap and net-positive |
| 0017 | worth-revisiting | gates well placed; Dependabot majors-auto is the acknowledged weak edge |
| 0018 | stands | — |
| 0019 | stands | mirror-only confirmed as the safe design |
| 0020 | worth-revisiting | architecture stands; advisory-safety leans on telemetry that 0012's critique shows is underspecified |

- Findings count: 20 critiques; 4 stands, 15 worth-revisiting, 1 superseding-candidate (moot — already superseded).
- All advisory (ADR 0020). Cross-cutting themes for the Maintainer: (1) the
  layer-equals-package assumption (0001/0002/0004) is the deepest single
  challenge and is cheapest to weigh now while 0004 is still proposed;
  (2) several decisions lean on wave telemetry that ADR 0012 leaves
  schema-less — hardening the report format would firm up 0017 and 0020;
  (3) process ADRs accepted same-day as their triggers (0009/0017) carry
  constants worth a deliberate second look.
- Board: #41, #42 → Done at closure. Agent cost: 10 agents, ~452k tokens, 3 min.
