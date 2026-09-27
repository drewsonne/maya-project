# Wave 2 — the vectors

- Plan: `docs/plan/2026-09-13-fixtures-first.md` (story #12, epic #10)
- Date dispatched: 2026-09-21, six agents, one package each, own branches on
  `drewsonne/maya-date-fixtures` (PRs #16–#21). Preflight and dispatch ran in
  a prior session; no dispatch report was committed at the time.
- Date collected: 2026-09-26/27 — reviews ran 2026-09-26, were cut off by an
  API session limit, and were resumed and completed 2026-09-27. **Collected;
  not complete** — all six pull requests are still open, queued for the
  Maintainer (see *Merge queue*).
- Target repo `main` at collection: d68d8a2, validate workflow green.

Review ran one fresh agent per pull request (ADR 0020/0021), each with its
package block, the shared wave-2 contract and the maya-review skill text;
each re-fetched every cited source, recomputed every typed value with its
own routines (never the library), and put value- or citation-changing
candidates to a three-refuter panel. Where the verdict was *merge after
named changes*, a fresh author context applied exactly the named edits and
the original reviewer re-checked the delta cold. Verdicts are attached to
each PR as a comment and a COMMENT review.

| package | PR | fixtures | criteria met | scope | outcome | review verdict | notes |
|---|---|---|---|---|---|---|---|
| wave-2-positional-rollover | #16 | validate 0; test 11/11; broken copy rejected | 4/4 | clean | ok | merge after named changes → **merge** on re-check (fdc5d62) | 12/12 recomputed; M&S 2012 pp. 3–4 and Stuart 2012 fetched. 2 required (both citation wording: the paper's "115,000" misprint silently corrected; two quoted phrases located in the post body but actually in the author's comment reply), 4 advisory |
| wave-2-western-correlation | #20 | validate 0; test 11/11; broken copy rejected | 4/4 | clean | ok | merge after named changes → **merge** on re-check (c097547) | 14/14 recomputed with own JDN routines; M&S 2012 and K&H 2018 p. 53 fetched. 1 required: Landa's "12 K'an 1 Pop" asserted as `calendar_round` in three attested records with no convention stated, where Classic arithmetic gives 2 Pop and the source prints both — dropped (c097547). 2 advisory |
| wave-2-cycles-and-seating | #21 | validate 0; test 11/11; broken copy rejected | 4/4 | clean | ok | merge after named changes → **merge** on re-check (5a9c287) | 24/24 recomputed; M&S 2012, K&H 2019, Stuart 2004, Stuart 2005 fetched. 1 required: Stuart 2005 Glyph G1 cross-reference cited to p. 62, printed on p. 63 — fixed (5a9c287). 5 advisory. Contract clause "divergence written up via maya-record" unverifiable from the PR |
| wave-2-distance-numbers | #19 | validate 0; test 11/11; broken copy rejected | 3/3 | clean | ok | **merge** | 12/12 recomputed incl. every anchor±DN walk and CR/G from MDN; Lounsbury 1976 pp. 220–221 and K&H 2020 p. 52 confirmed. 0 required, 2 advisory |
| wave-2-cr-ambiguity | #18 | validate 0; test 11/11; broken copy rejected | 3/3 | clean | ok | **merge** | 28/28 recomputed; candidate sets re-enumerated by brute force; M&S 2012 pp. 6, 9 confirmed. 0 required, 3 advisory |
| wave-2-rejection-and-leniency | #17 | validate 0; test 11/11; broken copy rejected | 3/3 | clean | ok | merge after named changes → **merge** on re-check (c78e1ab) | 13/13 recomputed; K&H 2020 App. E pp. 47–49 fetched. 2 required: the `maya_day_number >= 0` bound presented as a calendar fact (pre-era inscriptional dates exist) rather than input-domain policy; two Haab/Wayeb bounds labelled attested where the page prints only 1-based labels — restated and relabelled derived (c78e1ab). 3 advisory |

Outcome per package is `ok`: fixtures green, scope clean, every criterion
met. No package touched a fixture file outside its scope, `schema/**` or
`scripts/**`; no value was traced to an implementation run.

## Findings count

23 total across six reviews: **0 fixture disagreements** (every typed value
recomputed independently reconciles), **0 scope deviations**, **6 named
changes** (all citation wording, provenance labels or a contested
`calendar_round`; no `long_count`, `maya_day_number` or `julian_day_number`
changed), **19 advisory**. Panels: seven candidate findings went to
three-refuter panels; five stood (3/3, 2/3, 3/3, 2/3, 3/3, 3/3 on the six
required changes, counting #17's two separately), two were refuted and did
not surface.

## Wave gap analysis (ADR 0020, advisory)

Fresh completeness critic, read-only, seeds the next wave. Verdict: the wave
adds up to the story outcome **partly**. Every named case class has a file,
and each file pins its case when read by a human. But the wave-1 schema has
typed fields only for a single date (LC, CR, G, MDN, JDN, Gregorian,
correlation), so four files pin their case only in `notes`:

- `distance-numbers.yaml` — anchor, distance number and direction live in
  the id grammar and notes; a harness sees a plain date vector.
- `calendar-round-ambiguity.yaml` — window and candidate set live in notes,
  one record per candidate joined by an id prefix.
- `rejection.yaml` — the rejected string and the required error live in
  notes; six malformed-string records carry no typed field at all.
- `lenient-input.yaml` — the normalised form lives in notes (all six
  records are `unverified` and gated out, as the contract required).
- `proleptic-western.yaml` — the Julian calendar date lives in notes; only
  the Gregorian side is a typed field.

Gaps between scopes: notation for the day after the era base
(13.0.0.0.1 vs 0.0.0.0.1); the 1-based Haab convention is never labelled
or pinned as such; no alternative Lord of the Night numbering; orthography
acceptance (old-orthography CR strings appear as valid values in one file
and are never addressed by rejection); impossible CR pairings; bak'tun ≥ 20
in five positions neither rejected nor normalised; no tzolk'in-only partial,
bak'tun-straddling window or empty candidate set; only three correlation
constants.

Cross-file disagreements a harness would hit on an all-green wave:

- **"13.0.0.0.0" ↔ MDN 0 or 1,872,000.** Era-base records in three files put
  the era base at MDN 0 (sourced: Martin & Skidmore 2012 p. 4 define the
  Maya Day Number as days since 13.0.0.0.0 4 Ajaw 8 Kumk'u); the 2012
  station records in two files put the same string at 1,872,000. Both are
  right and both are flagged in notes; a consumer keying on `long_count`
  alone cannot pass both.
- **11.16.13.16.4 = 12 K'an 1 Pop or 2 Pop.** Resolved for this wave by
  dropping the CR from the correlation-constants records (#20); the
  divergence itself (Landa's Colonial count vs the Classic count) remains
  recorded per source in `haab-seating.yaml`.
- **2.0.0.10.2 = "9 Ik' 0 Sak" vs "9 Ik 0 Zac".** Same day, per-source
  orthography, string mismatch.
- The validator enforces neither id uniqueness across files nor LC/MDN/CR
  consistency.

## Decisions nobody made (route to `maya-record`)

Collected from the six reviews; none blocks merge, each is encoded somewhere
in the data without a recorded decision:

1. The layer-1 rule for reading the bare string "13.0.0.0.0" (era base at
   MDN 0 vs the 2012 station), and how post-era days are written.
2. Piktun convention: six-position 1.0.0.0.0.0 = 2,880,000 is chosen and
   corroborated (Stuart 2012), but the generalised base-20 bak'tun→piktun
   model in the notes is the author's, not Stuart's; the PRD has no piktun
   policy.
3. Haab day-coefficient numbering: 0-seating ([0,19]; Wayeb [0,4]) is the
   de facto dataset convention; the 1-based Colonial count is documented
   but not pinned. PRD §3 wants a flag per convention.
4. Strict input domain `maya_day_number >= 0`: required by the wave-2
   criteria, makes pre-era inscriptional dates (Temple of the Cross
   12.19.13.4.0, MDN −2440) unrepresentable; recorded in no accepted ADR.
5. An error taxonomy: eight `ERR_*` identifiers proposed in
   `rejection.yaml` notes.
6. Schema representation of a candidate set, a partial Calendar Round, a
   distance-number chain, a rejected input and a Julian calendar date —
   all currently notes-only conventions.
7. Record-level vs field-level provenance when a typed field is a
   deterministic re-expression of a printed value (a Gregorian date from
   a printed JDN). Panel 2/3 refuted relabelling; question stands.
8. `calendar_round` string grammar: "0 X" for glyphic "Seating of X",
   per-source orthography, ASCII apostrophes — now the de facto format.
9. Lord of the Night rule G = MDN mod 9 with G9 at the era base — stated in
   a file header, decided nowhere.
10. Which correlation era-base-style anchors are expressed under (584285
    where the paper's sentence uses it; PRD default 584286).

Research findings surfaced by the citation audits, for `docs/research/`:
Martin & Skidmore 2012 p. 4 misprints 16 k'atuns as 115,000 days; Kettunen &
Helmke 2018 p. 53's worked example lands one day early (May 2 for JDN
1990731, which is May 3); Stuart 2005 pp. 61–63's pre-era platform date
12.10.1.13.2 9 Ik' 5 Mol G1 is a good attested pre-era Lord of the Night
vector for a later package.

## Seeds for the next wave (from the gap analysis)

1. Schema v2 — typed `anchor`/`distance_number`/`chain`, `window` +
   `candidates`, `input` + `expect_error`, `normalised_long_count`,
   `julian_calendar_date`, `haab_convention`, `mode`; then migrate the four
   notes-only files. **M.** This precedes `wave-3-js-harness` as planned,
   or wave 3 executes only the date-vector files.
2. Record the 13.0.0.0.0 / era-notation convention and re-pin the affected
   records. **S.**
3. Label and pin the 1-based Haab convention with vectors. **S.**
4. Orthography policy fixtures. **S.**
5. Rejection/leniency for bak'tun ≥ 20, impossible CR pairings, empty
   candidate set. **S.**
6. Cross-file id uniqueness and LC/MDN/CR consistency in
   `scripts/validate.js`. **XS.**

## Process findings

- **The interrupted-review recovery worked.** Five of six review contexts
  were killed mid-run by an API session limit on 2026-09-26; one had already
  posted. Each was resumed the next day with its context intact and
  finished from where it stopped; nothing was re-reviewed from scratch and
  no verdict changed on resumption.
- **Un-drafting and merging is a Maintainer action in this environment.**
  The harness's permission classifier blocked `gh pr ready` twice (as the
  wave-1 report recorded for `gh pr merge`). ADR 0017's autonomous clean
  merge therefore reduces, here, to "queue with the verdict attached". The
  same classifier blocked `gh pr comment` for one reviewer, which posted
  the identical body through `gh api` instead and said so.
- **`board-status.sh` trips GitHub's GraphQL secondary limit.** Twenty-one
  reconciliation moves were pending from the orient pass because two runs
  exhausted the quota; sixteen went through today before the limit hit
  again with 4,893 points nominally remaining. One cached item list per
  session, or the REST projects endpoints, would fix it (story-worthy;
  orient named it).
- **Pre-0021 package blocks worked, with one seam.** The wave was planned
  before ADR 0021, so blocks carried no `story:`/`outcome:`/`binds:`; the
  coordinator supplied those in each review prompt. The #21 contract
  clause "written up via maya-record" names a hub artifact outside the
  package's scope and was unverifiable from the PR — a planning defect of
  the kind ADR 0021's self-sufficient block is meant to prevent.
- **The schema freeze was the right call and its cost is now visible.** Six
  packages shipped without touching `schema/**`, as the contract required;
  the price is five notes-only files. The gap analysis turns that into the
  first package of the next wave rather than an argument for having let
  agents edit the schema.
- The wave-2 PR descriptions do not carry the ADR 0021 `- [ ]` checklist
  (they predate it); reviewers walked criteria by name from the block.

## Merge queue (ADR 0017, G3 in this environment)

All six PRs are drafts with CI green on their heads. Each is queued for the
Maintainer with its verdict attached on the PR:

- Verdict **merge** at first review: #18, #19.
- Verdict *merge after named changes*, named changes applied by a fresh
  author context and re-checked cold by the original reviewer, final
  verdict **merge**: #16 (fdc5d62), #17 (c78e1ab), #20 (c097547),
  #21 (5a9c287).

Every PR therefore meets ADR 0017's clean case (verdict merge, zero
required findings, suite green, scope clean, no fixture edits outside the
package's own new files). To merge, from any checkout:

```
for n in 16 17 18 19 20 21; do
  gh pr ready $n --repo drewsonne/maya-date-fixtures
  gh pr merge $n --repo drewsonne/maya-date-fixtures --squash --delete-branch
done
```

Advisory findings on every PR are attached and do not block (ADR 0020).
Merging closes tasks #2–#7 through their `Closes drewsonne/maya-project#N`
lines. Story #12 closes only after every task is closed and its acceptance
("every wave-2 fixture file validates, covers its named cases, and carries
real citations") is demonstrated against `main` — the reviews are that
demonstration once the files are on `main`.

## Board state (ADR 0018/0019)

Tasks #2–#7 at **In review**; PRs #16–#21 on the board at **In review**
(#20, #21 and tasks #3, #4 were added today; their 2026-09-21 moves had
failed on the rate limit). Story #12 and epic #10 at In progress. Nothing
moves to Done until the Maintainer merges.
