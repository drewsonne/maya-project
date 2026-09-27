# Critique of ADR 0023 — devil's advocate (ADR 0020, stage 5)

Date: 2026-09-27. A fresh agent read the first draft cold and checked it
against ADRs 0012, 0013, 0017, 0020 and 0022, the skills, the
marketplace files and the hub's branch protection. The draft was then
revised, including for the Maintainer's later instruction that every
whitelist entry is a hard gate. The disposition of each point is at the
end.

## 1. What breaks if the decision is wrong

1. **A merge to `main` is in effect the release.** The marketplace
   serves `./plugins/maya` from this repo, and CI makes every change
   there bump `plugin.json`, so a merge publishes an installable version
   at once. `/plugin update` only pulls it, and with auto-update it may
   not be a deliberate act.
2. **Skill merges can quietly change gate behaviour.** A skill pull
   request is not an ADR, so a change to the clean-merge rule in
   `maya-review` or the queueing rule in `maya-fleet` could merge on a
   clean verdict, judged by the `maya-review` it changes.
3. **`main` is unprotected.** Branch protection returns 404, so "once CI
   passes" is an agent's promise, not something GitHub enforces.
4. **Bad defaults go unseen.** Wave reports are now self-merged and
   unread, and choices made outside waves never appear in one.

## 2. Who is harmed if it is right

5. The Maintainer loses the last point where they read skill text, plans
   and `docs/STATE.md`; the only guard is an advisory review.
6. Anyone else who installs the marketplace gets unread skill changes.
7. Each silent "most conservative" default becomes precedent without
   being ratified.

## 3. Strongest counter-argument

8. The noise had operational causes, mostly fixed already: the harness
   permission is granted, story #66 routes questions to issues, and the
   plugin-release question belongs to the release ADR (story #16). A
   smaller fix would define "plugin release" as a version the Maintainer
   cuts and leave skill merges as they are.

## Loopholes and ambiguities

9. Records and process ADRs are merged or accepted by their authors,
   against ADR 0020's "Author ≠ reviewer, always".
10. Self-acceptance contradicts ADR 0020 stage 5 and `maya-record`
    step 3; ADR 0020 was not listed as amended.
11. The process-ADR test missed review intensity, fixture-edit rules,
    authorization and similar.
12. "Obvious default" was undefined and pulls against "most
    conservative".
13. "More than a third fail" breaks on small waves, and "fail" was
    undefined.
14. "Drift no agent can explain": any agent can offer an explanation.
15. G3 was narrowed by listing, dropping fixture-dataset publication
    (ADR 0006) and tags or GitHub releases.
16. It was unclear whether record, skill and process-ADR merges need an
    authorized story.
17. `maya-spec` was bound, although it interviews the Maintainer live
    and story #66 excludes it.
18. "Amends: 0017" left no trace in ADR 0017.
19. A self-merged wave report could hide its list of pull requests
    that need the Maintainer.
20. "This ADR wins" over skill text is empty: agents load the installed
    skill, not the ADR.
21. The Implementation line was a placeholder.
22. The 15/8 counts had no source, and "would have reached them once"
    was unverifiable.

## Disposition

- **1 (merge is effectively the release): adopted as a consequence.**
  The ADR now says a merge makes the version installable, that
  `/plugin update` is the release only for the Maintainer's own
  sessions and only with auto-update off, and that other installers get
  unread text. The rule itself stays: the Maintainer chose "skill merges
  aren't releases".
- **2 (skill merges changing gates): adopted.** A skill pull request
  that changes a gate, the whitelist, an agent permission, merge or
  clean-verdict rules, authorization, or review or fixture rules is G1
  and queued, whatever its verdict.
- **3 (unprotected `main`): adopted as a consequence.** Merges need
  every check completed and passing, checked by the merging agent; the
  missing protection is stated.
- **4, 7 (unseen defaults, precedent): adopted.** An obvious default is
  now defined, choices are stated in the output, and the Consequences
  name wave telemetry (ADR 0012), the gap analysis (ADR 0020 stage 4)
  and `maya-orient` as where misfires show.
- **5, 6 (who is harmed): adopted** into the Consequences.
- **8 (smaller fix): not adopted.** It reverses the Maintainer's choices
  "Let agents merge", "Records merge themselves" and "Skill merges
  aren't releases", and their later instruction to default to acting.
- **9 (author merges own records): not adopted** for records, since
  "Records merge themselves" is the Maintainer's choice; the loss of a
  second reader is stated in the Consequences. For process ADRs the
  fresh-agent critique stays; only acceptance moves.
- **10 (ADR 0020 and `maya-record`): adopted.** ADR 0020 is listed as
  amended, the narrowed clause is quoted, and story #70 changes
  `maya-record`.
- **11 (process-ADR test): adopted.** The test now excludes anything
  touching a gate, the whitelist, an agent permission, merge or
  clean-verdict rules, authorization, review or fixture rules, or a
  product or domain convention; doubt means proposed.
- **12 (obvious default): adopted.** Defined as one an ADR, skill, the
  spec or the current plan points to, or one that is reversible in the
  repo and touches no gate. An obvious default never passes a gate.
- **13 (a third): adopted.** "Fail" means `blocked` or `failed`, and in
  a wave of one or two packages any one counts.
- **14 (drift): adopted.** The explanation must rest on evidence
  written into the agent's output.
- **15 (G3 narrowed): adopted.** G3 keeps everything crossing the repo
  boundary except merging a skill or plugin pull request into the hub,
  naming fixture-dataset publication and tags or releases.
- **16 (authorization): adopted.** Skill merges need an active
  authorization; records and process ADRs need a session the Maintainer
  started.
- **17 (`maya-spec`): adopted.** Removed from Binds and from story #70;
  a spec interview is itself a G1 gate, asked live.
- **18 (trace in 0017): adopted.** ADR 0017 and ADR 0020 each carry an
  `Amended by: 0023` line.
- **19 (hidden action list): adopted.** Merging a record does not
  replace queueing; what it says needs the Maintainer is still assigned
  to them.
- **20 ("this ADR wins"): adopted.** Replaced: skills behave as written
  until story #70 ships, and a session briefed with this ADR follows it.
- **21 (placeholder): resolved.** Story #70 is filed.
- **22 (counts): adopted.** The counts are attributed to the
  coordinating session, and the claim is limited to the listed
  touchpoints.
