# Critique of ADR 0011

- Target: 0011-stories-are-the-unbounded-backlog.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision's two halves each collide with ADR 0009, which it claims merely to clarify. First, 'stories may be created freely, at any time — the backlog is unbounded' is structurally false under 0009, which defines stories as sub-issues of an epic, where epics are 'few' and each 'traces to a PRD outcome' (the README adds: a feature idea with no PRD outcome behind it prompts a maya-spec round, not a stealth epic). So a freely-filed idea either needs a matching PRD-traced epic — meaning ideas outside the current PRD still have nowhere to go, defeating the ADR's stated purpose of keeping ideas out of chat logs — or it floats parentless or under the wrong epic, eroding the hierarchy 0009 built. Second, promotion-in-place manufactures exactly the 'stealth epic' the project's own movement rules forbid: a story relabelled epic keeps its issue number, its discussion, and its sub-issue parent, producing an epic nested under an epic (a four-level shape 0009's three-level model never defined, and one the board's Kind/label filters and maya-orient's tree walks assume cannot exist) that traces to no PRD outcome and passed through no G1 gate. Promotion is gated on 'evidence of complexity' alone, while epic creation everywhere else is gated on PRD tracing — the ADR opens a side door around its own governance. Third, the ADR never argues why the staleness logic it inherits from 0009 ('a stored task inventory is a liability; pre-written tasks encode assumptions about code that has changed') stops at the story level: stories carry machine-checkable acceptance criteria, which encode assumptions about product and package shape just as tasks do, and in an agent-executed pipeline where filing costs one issue and 'anyone, any time' includes agents, the unbounded backlog grows at LLM speed while the only triage resource is the same solo Maintainer whose throughput 0009 identifies as the binding constraint. Tasks get re-validated against main at dispatch; nothing ever re-validates stories against a revised PRD.

## Failure scenario

A freely-filed story under epic E accretes scope and is promoted in place per this ADR. The hub now holds an epic nested under an epic, traced to no PRD outcome: label-filtered views, the board's Kind field mirror (ADRs 0018/0019), and maya-orient's 'epics are few, top-level, PRD-traced' reading are all silently wrong. First noticed at the next session's orientation or when maya-plan walks the tree and finds stories two epics deep. Separately and later: the Maintainer authorizes (G2) a months-old story whose acceptance criteria reference a package shape or PRD outcome that a subsequent spec round superseded; maya-plan dutifully decomposes it, and a wave of agent work is dispatched and reviewed against stale intent — noticed only at review or at the ADR-0013 demonstration step, after the throughput-limited resource has already been spent.

## Who bears the cost

The Maintainer's triage attention at G2, the project's scarcest resource; the orientation and board layers (maya-orient, ADRs 0018/0019) whose invariants the nested untraced epic silently breaks; the PRD-tracing discipline that keeps epics honest.

## Overlooked alternative

Separating capture from backlog membership: an 'idea' tier (label idea, no acceptance criteria, no parent required, excluded from orientation counts and planning) that is genuinely unbounded, with promotion to story — not the story tier itself — as the commitment point requiring an epic parent and current acceptance criteria. This preserves the ADR's real insight (capture must cost one issue) without making committed, criteria-bearing stories the dumping ground, and without the parentage contradiction with 0009. The Context frames only two misreadings of 0009 and never engages with this third shape, nor with what a promoted epic owes the PRD.

## Verdict reasoning

The core insight — capture must be nearly free, epics are earned from evidence rather than guessed — is right for a solo, agent-driven project, and the failure modes here are cheap to repair (relabels and reparents, with demotion already defined). But the decision as made leaves three concrete gaps: where a free story attaches when no PRD-traced epic fits, how a promoted epic re-ties to a PRD outcome or triggers a spec round, and whether stories are exempt from the staleness argument that justified the task horizon. A short amending ADR closes all three; no urgency, but the promotion path should not be exercised before it is.
