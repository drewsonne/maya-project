# Critique of ADR 0024 — devil's advocate (ADR 0020, stage 5)

Date: 2026-09-27. A fresh agent read the first draft cold and checked it
against ADRs 0017, 0020, 0022 and 0023 (pull request #71), stories #66,
#70 and #76, the retro design, `maya-fleet` and the hub's git history.
The draft was then revised. The disposition of each point is at the end.

## 1. What breaks if the decision is wrong

1. **Bad process changes reach `main` unread.** A retro story that edits
   skill text can merge on a clean review, and the marketplace serves
   that text from `main` at once.
2. **The machine feeds itself.** Retro stories add process work that
   the next retro measures; the balance question comes only as often as
   retros do.

## 2. Who is harmed if it is right

3. **The Maintainer loses a per-story say.** Stories are filed after the
   interview; the Maintainer may never see the list in the session.
4. **Product work is pushed back.** ADR 0009 allows one wave in flight
   and one planned; up to three retro stories compete for those slots.

## 3. Strongest counter-argument

5. **The Maintainer is already there.** A live retro could ask
   "authorize these stories? yes or no", which meets G2 as written and
   needs no gate change, guard or cap. Standing pre-authorization saves
   seconds and removes the veto at the one moment it is cheap.

## 4. Loopholes and ambiguities

6. **Drift after authorization.** The guard is checked once, at filing;
   later packages could cross it. With ADR 0023 rejected, nothing
   catches that at merge.
7. **Nobody checks the guard** but the retro that files the story;
   author ≠ reviewer is not applied.
8. **"Run live by the Maintainer" is unverifiable.** The report is
   agent-written and self-merges under ADR 0023.
9. **The cap can be dodged**: more retros, bigger stories, or labelling
   or widening existing stories.
10. **The pattern rule is loose.** "Occurred twice" needs no previous
    retro, contradicting "an early retro may authorize nothing".
11. **Conflict with ADR 0023's hard-gate clause**, "whatever any other
    ADR, label [...] says". Standing input survives only if G2's text is
    itself changed.
12. **The conditional amend depends on order.** With 0023 rejected,
    "whitelist" and "process ADR" mean nothing in ADR 0017; with 0024
    accepted first, 0023's clause overrides it.
13. **Binds and story #76 disagree.** Story #76 changes neither
    `maya-plan` nor `maya-fleet`; `maya-fleet`'s preflight text "applied
    by the Maintainer" would refuse a retro story; `maya-review` is not
    bound; the exception to story #66 needs skill text.
14. **The guard forbids only loosening.** ADR 0023's exclusion list
    covers changes in either direction.
15. **The interview filter admits project management**: "what the
    project does next" covers sequencing.
16. **"Until story #76 ships" is vague**, and #76's acceptance needs a
    retro that uses the power.
17. **The Decision was one 300-word paragraph.**
18. **"22 of 32 hub commits since 2026-09-13" is unsourced.** Hub
    history starts 2026-09-20 and the hub is the process repo by design.
19. **"Approved on 2026-09-27" contradicts the design file**, whose
    status line says it awaits review.

## Disposition

- **1 (unread merges): adopted as a consequence.** Stated, with ADR
  0023's marketplace point.
- **2 (feeds itself): adopted.** Stories are filed after the interview,
  and if the Maintainer answers that process share is too high, the
  retro authorizes none.
- **3 (per-story say): adopted in part.** The retro shows every story it
  authorized before the session ends, and one the Maintainer strikes
  loses the label. This is shown, not asked.
- **4 (product pushed back): adopted as a consequence.**
- **5 (just ask yes or no): not adopted.** The Maintainer chose
  pre-authorization over asking in the design session, and ADR 0023's
  default is not to ask. Point 3's disposition gives the Maintainer the
  chance to strike a story without a question. **The Maintainer should
  weigh this point when deciding whether to accept.**
- **6 (drift): adopted.** The guard is re-checked by `maya-plan` on each
  package and `maya-review` on each pull request; `maya-review` added to
  Binds; story #76 carries it.
- **7 (who checks): adopted.** The retro's challenge agent checks each
  authorized story's guard classification.
- **8 (unverifiable): adopted as a consequence.** Stated plainly; the
  guard rests on the trigger model and the list shown in session.
- **9 (cap): adopted.** Only new stories; never widening; only when the
  "Retro due" thresholds were met. Story size is stated as a limit of
  the cap.
- **10 (pattern rule): adopted.** "A problem of the same kind at least
  twice in the period"; the early-retro consequence corrected.
- **11 (hard-gate clause): adopted.** The ADR gives G2's replacement
  text.
- **12 (order): adopted.** Replacement text for each case, and this ADR
  is not accepted while ADR 0023 is still proposed.
- **13 (Binds and story): adopted.** `maya-review` bound; story #76 now
  changes `maya-fleet`'s preflight and adds the re-check to `maya-plan`
  and `maya-review`. The exception to story #66 lives in `maya-retro`:
  #66's paragraph goes into five other skills, not this one.
- **14 (either direction): adopted.** The guard reuses ADR 0023's
  exclusion list and applies in either direction.
- **15 (filter): adopted.** Now "which product outcome the project
  pursues next"; order, timing, packages and tools fail the filter.
- **16 (ships): adopted.** "Until this ADR is accepted and the pull
  request that adds `maya-retro` has merged."
- **17 (one paragraph): adopted.** Limits and guard are a list.
- **18 (unsourced count): adopted.** Removed; the Context says the hub
  is the process repo by design.
- **19 (approval): adopted in part.** The ADR says the Maintainer
  approved the design in the 2026-09-27 session, per the coordinating
  session; the design file's status line predates that and should be
  updated when the design is merged.
