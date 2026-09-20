# 0015. Project documents refer to roles, not people

- Status: accepted
- Date: 2026-09-20

## Context

The skills, ADRs, README and PRD named the project's one human by first
name. That reads poorly in public repos, breaks the moment a
collaborator joins, and conflates a person with the authority they
exercise. The pipeline's design already treats the human as a set of
authority points (spec source, ADR acceptance, merge), which is a role
description.

## Decision

Project documents refer to the **Maintainer**: the accountable human who
is interviewed for the spec, accepts ADRs, and merges. Skills, ADRs,
plans and the README use the role name; personal names appear only where
they are facts (git authorship, GitHub owner paths such as
`drewsonne/...`, citation of a person's published work). Existing
documents are updated mechanically — a name-to-role substitution changes
no decision and does not count as rewriting an accepted ADR. The role is
currently held by one person; if it is ever split (say, a separate
Reviewer), that is a new decision.

## Consequences

Documents survive contributors and read as process, not biography.
Manifest attribution fields (`plugin.json` author, `marketplace.json`
owner) keep the personal name — they record ownership, not process.
Pronouns for the Maintainer in project prose are they/them.
