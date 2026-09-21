# Critique of ADR 0008

- Target: 0008-documentation-language-policy.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

This decision creates the only class of work in the entire pipeline that agents are structurally forbidden to perform, and then wires it into a blocking CI gate. Sourced terminology ('checked against the literature before use, not rendered by a translator or by an English speaker's best guess') and research-grade translation are, by the ADR's own admission, work that 'cannot be completed by anyone who does not read the literature' — i.e. the Maintainer. Meanwhile the mandated CI check fails any PR that adds an English prose page without a Spanish counterpart. Put together: every future docs-touching change becomes non-clean by construction under ADR 0017's merge rules, because the agent that wrote it is prohibited from producing the Spanish half. The project just spent ADR 0017 removing the Maintainer's attention as the throughput ceiling; 0008 quietly reinstalls it for all outward documentation. And the benefit side is asserted, not evidenced — there are zero Spanish-language issues, users, or citations yet. The cost (2x maintenance on six pages plus fixtures README, schema docs, four library READMEs, app UI and tutorials) is certain and front-loaded; the audience is hypothetical. The ADR also chooses Docusaurus's copy-based i18n model — the exact drift-prone structure whose failure mode ('a translated ADR that falls behind its original is worse than no translation') it uses to justify keeping maintainer docs English-only, mitigated only by a CI check that does not exist yet.

## Failure scenario

First noticed at the first post-acceptance agent wave that adds or materially edits a prose page in maya-dates: the bilingual-completeness CI check fails, the agent cannot legally fix it (unsourced Spanish is forbidden, and the terminologia-es.md glossary must pre-exist any shipped Spanish text), the PR queues for the Maintainer, and documentation work silently exits the autonomous pipeline. Second-order failure arrives months later: the standing translation debt means an update to julian-v-gregorian.md — the page the ADR itself calls the largest source of error in the domain — lands in English while the Spanish version keeps the superseded explanation, and a Spanish-reading epigrapher acts on it in good faith. That is precisely the 'worse than no translation' failure the ADR names, now aimed at the project's most error-prone domain concept and its most valued audience.

## Who bears the cost

The Maintainer, who acquires a permanent, personally non-delegable translation and terminology-research duty on the critical path of every docs change; the agent pipeline, which loses autonomy over documentation entirely; and ultimately Spanish-reading researchers, who are served stale domain explanations the moment the Maintainer falls behind — a worse outcome for them than a clearly English-only page.

## Overlooked alternative

Staged translation. The ADR's own analysis identifies the two pages that carry nearly all the value (julian-v-gregorian.md and spelling-variations.md) and then commits to six pages plus READMEs plus app UI anyway. The unengaged middle: make only those two pages plus the fixtures-repo README the bilingual set now, with the CI pairing check scoped to exactly that list, and expand on demonstrated Spanish readership (first Spanish issue, first citation). Also unengaged: letting agents draft Spanish prose gated by the cited glossary — terminology human-sourced, prose agent-produced and glossary-checked — which would keep docs work inside the autonomous pipeline instead of making the all-or-nothing human-research requirement cover ordinary sentences as well as calendrical terms.

## Verdict reasoning

The core division — outward-facing bilingual, maintainer docs English-only, terminology sourced not translated — is correct and genuinely well-fitted to this project; the sourced-glossary idea is a real contribution. The weakness is scope and enforcement: the full bilingual surface plus a hard CI gate plus a non-delegable research dependency contradicts the throughput design of ADR 0017. The ADR is still 'proposed', so the right move is to trim the bilingual set to the two named high-value pages and soften the CI gate (warn/track rather than fail, or scope it to the named list) before acceptance — a revision, not a reversal.
