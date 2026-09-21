# Critique of ADR 0010

- Target: 0010-project-repo-as-plugin-marketplace.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision moves 'the entire hub function' wholesale, and in doing so silently reverses the central argument of the ADR it supersedes without ever engaging it. ADR 0007's strongest claim was not about where issues live — it was that a sourced research finding and the fixture that encodes it are 'the same fact written twice' and therefore must live in the same repo so a vector's provenance and its justification are reviewed in the same pull request. ADR 0010's Context addresses the tracker-hygiene and skill-distribution problems well, but says nothing about why the research/fixture co-review property is now safe to give up. Under 0010, a new attested vector lands as a PR on maya-date-fixtures while the research doc that sources it lands as a separate PR on maya-project: two diffs, two reviews, no atomic link. Worse for the project's stated purpose: ADR 0006 makes the dataset citable via versioned tags and archiving, but the research that justifies the vectors is no longer in the archived artifact at all — an academic citing dataset v1.4.0 gets vectors whose written sourcing lives in an unarchived project-management repo they were explicitly meant not to wade through, at whatever HEAD it happens to be.

## Failure scenario

ADR 0020's citation audit (stage 3) refutes an attested vector's value; the fixture is corrected in maya-date-fixtures, but the research doc in maya-project — a different repo, a different PR, no mechanical coupling — is not updated, or is updated in a later commit that no dataset tag references. First noticed when a downstream implementer or the next citation audit traces a vector to its research doc and finds the doc still asserting the refuted value, or when someone archives the dataset for citation and discovers its justification layer is not in the archive. This is exactly the 'same fact written twice, drifting' failure that 0007 was written to prevent, now reintroduced across a repo boundary.

## Who bears the cost

Dataset consumers and academics tracing provenance (the project's primary external audience per ADR 0006); the citation-audit adversary, whose job gets harder when sourcing lives away from the vectors; and the Maintainer, who becomes the only reconciliation mechanism between two repos' versions of the same fact.

## Overlooked alternative

A partition instead of a wholesale move: project management (issues, plans, STATE.md, skills, marketplace) goes to maya-project, while docs/research — which is dataset provenance, not project management — stays in maya-date-fixtures next to the vectors it justifies, versioned and archived with them. 0007 itself drew this kind of line ('decisions affecting exactly one package live in that package'); research findings that justify fixtures are the clearest possible case of package-local documentation, and 0010's Context never weighs keeping them behind.

## Verdict reasoning

The core of the decision survives: the marketplace solves a real two-copies problem (and the workspace copies were in fact deleted — I checked), and 0007's 'meta-repo nobody visits' objection is answered because every task, plan and skill now forces visits to maya-project. But the wholesale inclusion of docs/research reverses 0007's co-review argument without engagement, and the cost lands on the project's most valuable external artifact. Worth a deliberate weigh-in on whether research belongs with the dataset; no urgency because the divergence has not happened yet.
