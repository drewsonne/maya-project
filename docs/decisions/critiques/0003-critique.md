# Critique of ADR 0003

- Target: 0003-parser-public-api.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The decision hard-orders itself before 0004 ("This decision lands before 0004 and 0005") and moves every parser import to the maya-dates root barrel — the exact surface 0004 is about to break. The barrel today exports LongcountOperation, the wildcard expanders and CommentWrapper; 0004 drops the operations exports at maya-dates 2.0.0 and explicitly leaves CommentWrapper's layer unresolved, and the parser's token base class (maya-date-parser/src/tokens/base.ts) imports CommentWrapper. So 0003 does not 'resolve the collision with #142 rather than deferring it' — it swaps a deep-import collision for a barrel collision one release later, forcing a second parser import migration and a second publish, each a full serialized land-publish-bump-verify cycle under 0002's separate-repo structure. Worse, the semver story is inverted: the ADR admits the token types 'were never designed to be a contract', yet ships the first-ever public API as a 1.x minor whose AST exposes maya-dates 1.x class instances (LongCount, CalendarRound). When maya-dates 2.0.0 lands, the parser's exported AST types change identity, so the parser's first stable contract is guaranteed a major bump within one cycle. The package provably has zero consumers today (main is a 0-byte file) — the one free moment to design the contract for the post-0004 world, or to cut the coupling entirely, is being spent blessing pre-split shapes.

## Failure scenario

0003 lands, parser 1.1.0 publishes with an AST built from maya-dates 1.x classes imported via the root barrel. 0004 then releases maya-dates 2.0.0; the parser's scheduled latest-upstream CI job (0002's own mitigation) goes red — CommentWrapper and any operation symbol have moved or vanished. The app (0005) cannot bump either package until a second parser migration wave re-plans imports across two packages, republishes, and re-verifies. First noticed at 0004 execution as a red contract build blocking the 0005 chain — churn that co-planning 0003+0004, or a plain-data AST, would have avoided.

## Who bears the cost

The Maintainer, who pays two serialized cross-repo migration/release cycles instead of one, and any early parser adopter (realistically the app) whose first depended-on contract breaks within a cycle of existing.

## Overlooked alternative

A plain-data AST: the parse function could return positions, strings and numbers (spans plus lexeme structure) instead of constructed maya-dates instances, with consumers building values via the existing factories. That decouples the parser's semver from maya-dates majors entirely — the parser survives the 0004 split untouched — and the Context never weighs it, nor the option of shipping the package plumbing (lib/, files allowlist) now while timing the API export with 0004 so the contract is born against the post-split world.

## Verdict reasoning

The core — export an API, publish built output — is unassailable and urgently unblocks 0005; agents are cheap and 0002 already prices in serialized waves, so the double-migration alone would not overturn it. But the ADR is still 'proposed', the package has zero possible consumers, and the choice of what the AST exposes (maya-dates classes vs plain data) plus the 1.x-minor-versus-post-split timing are genuine unengaged design decisions that determine whether the parser's first contract survives 0004. Weighing them now, before acceptance, is free; after 1.1.0 publishes it is not.
