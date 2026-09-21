# Critique of ADR 0007

- Target: 0007-where-project-documentation-lives.md
- Date: 2026-09-21
- Verdict: **superseding-candidate**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision rests on a premise that is false for this specific project, and it directly undermines the project's most valuable output as declared the same day. The Context dismisses a dedicated hub repo with 'a repository nobody visits is documentation that goes stale' — but this is an agent-executed pipeline in which maya-orient is contractually required to read STATE.md at every session start, and every skill writes to docs/ by rule. Visitation here is scripted, not habitual; whatever repo the skills target gets visited, so the staleness argument that eliminated the meta-repo option carries no weight. Meanwhile ADR 0006 — accepted the same day, and a stated dependency — declares the fixtures repo 'the most externally valuable output of the project', versioned, archived, and citable by epigraphers 'without touching JavaScript'. 0007 then piles the PRD, plans, STATE.md, research notes and (via 0009) the entire epic/story/task tracker onto that same archived artifact. Anyone citing an archived tag of the dataset gets the project's process history bundled into the citation object, and the ADR's own 'Harder' section concedes the release machinery must now perfectly filter docs/** or documentation edits mint dataset releases. The decision knowingly traded the integrity of the citable artifact against a staleness risk that could not occur in this pipeline.

## Failure scenario

The dual-purpose repo degrades from day one and becomes untenable within a week: the fixtures tracker mixes dataset issues with project management, git history mixes vectors with process documents, and skills exist in two divergent copies because per-repo skill discovery cannot follow the hub. First noticed exactly when it was noticed — by 2026-09-20, seven days after acceptance, when ADR 0010 had to create drewsonne/maya-project, transfer issues #1–9, rely on GitHub rewriting inbound references so open PRs still closed their tasks, and retarget every skill. The latent sharper failure: a docs/** filter gap in the publish workflow tags a dataset release off a STATE.md edit, corrupting the versioned citation trail 0006 promises academics.

## Who bears the cost

ADR 0006's citability warranty (the archived, citable dataset polluted with process artifacts); the solo Maintainer, who paid a full hub migration one week later — new repo, issue transfer, skill repackaging, workflow rework; and downstream citers who would have received project management inside the dataset archive.

## Overlooked alternative

The Context frames the choice as docs-in-fixtures versus a documentation-only meta-repo 'nobody visits', and never engages with the option 0010 took: a hub repo given intrinsic traffic by co-locating the issue tracker, the plans, and the versioned skills alongside the docs. It also never engages with the fact that agent-scripted visitation (maya-orient reading STATE.md every session) makes any hub repo a visited repo, dissolving its own decisive objection.

## Verdict reasoning

The attack is not hypothetical — it is history. ADR 0010 is the superseding decision, accepted seven days later for precisely these reasons, and it explicitly marks 0007 superseded. Nothing further to do on the record; the lesson worth keeping is that 0007's decisive premise (staleness through non-visitation) was a human-attention argument applied to an agent-visited pipeline.
