# maya-project

Project management hub for the Maya dates project (ADR 0010): all issues,
decisions, product docs, plans, research — and the project's Claude Code
skills, served from this repo as a plugin marketplace.

## Install the skills

```
/plugin marketplace add drewsonne/maya-project
/plugin install maya@maya-project
```

Skills are then invocable anywhere, namespaced: `/maya:maya-orient`,
`/maya:maya-plan`, and so on. See `plugins/maya/skills/README.md` for what
each does and how they chain.

## Layout

- `STATE.md` — where things stand; start here.
- `docs/decisions/` — numbered ADRs. 0009 defines the epic → story → task
  issue model on this repo; 0010 defines this repo itself.
- `docs/product/` — the PRD and non-goals.
- `docs/plan/` — dependency-ordered work-package waves.
- `docs/research/` — sourced findings.
- `plugins/maya/skills/` — the eight skills (the `maya` plugin).

## The repos

- [`maya-date-fixtures`](https://github.com/drewsonne/maya-date-fixtures) — citation-backed correctness vectors (the dataset).
- [`maya-dates`](https://github.com/drewsonne/maya-dates) — the conversion library.
- [`maya-calculator-parser`](https://github.com/drewsonne/maya-calculator-parser) — date-expression parser.
- [`maya-calculator`](https://github.com/drewsonne/maya-calculator) — the app.
