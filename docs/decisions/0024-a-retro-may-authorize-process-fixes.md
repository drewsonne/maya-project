# 0024. A retro may authorize process fixes

- Status: proposed
- Date: 2026-09-27
- Implementation: #76
- Binds: maya-retro, maya-orient, maya-plan, maya-fleet, maya-review
- Amends: 0023 if 0023 is accepted, otherwise 0017

## Context

The Maintainer asked on 2026-09-27 for a way for the skills to understand
what worked and what did not, and to revise the work periodically. They
added that questions to them are fine, but only about product, strategy
and vision, never implementation or project management. In the same
session they chose the shape: a new skill, `maya-retro`, run live by the
Maintainer when `maya-orient` says one is due; two scorecards, process
and product, weighted equally; and, for a process problem, that the
retro may "file the fix as a story and pre-authorize it". The design is
`docs/plan/2026-09-27-maya-retro-design.md`; the Maintainer approved it
in that session.

The evidence for the process scorecard already exists. ADR 0012 makes
every dispatched wave commit a report and says: "Horizon, sizing and
skill changes can cite wave reports instead of memory." Nothing reads
those reports yet.

Two parts of that shape collide with the gates.

First, authorization. ADR 0017's G2 says: "Autonomous work happens only
on a story carrying the `authorized` label, applied by the Maintainer.
Authorization covers planning the story and dispatching its waves
sequentially (one at a time, preflight-gated) until the story is done or
blocked. Removing the label revokes it." ADR 0023, proposed in pull
request #71, keeps this as a hard gate, "**G2:** applying `authorized`
to a new story", and adds: "Every moment on the whitelist is a hard
gate. No agent passes it without the Maintainer's explicit input,
whatever any other ADR, label, review verdict or earlier answer says."
A retro that labels its own stories `authorized` passes G2 unless the
gate's own text allows it.

Second, asking. ADR 0023 says "By default, agents act and do not ask.
The Maintainer is asked only at the moments listed below. The list is a
closed whitelist", and its G1 lists "the product's purpose or spec; a
calendar or domain convention [...]; any ADR that is not a process ADR
[...]; epic closure; or any change to the gates, this whitelist or an
agent permission." A retro interview about direction, balance and the
user is not on that list. Story #66 says "Any question for the
Maintainer is filed as a GitHub issue on the hub, labelled `question`",
where a retro asks live.

ADR 0023 defines the only ADRs an agent may accept: "A process ADR is
one that changes only how agents work. It touches no gate, nothing on
the whitelist above, no agent permission, no rule on what an agent may
merge or what counts as a clean verdict, no authorization rule, no
review or fixture-integrity rule, and no product or domain convention."
It also makes a skill pull request that changes any of those rules G1:
"A skill pull request that changes any of the rules listed as excluded
from a process ADR is a change to the gates, so it is G1 and queued,
whatever its verdict." This decision changes a gate and an authorization
rule, so it is not a process ADR, and only the Maintainer accepts it.

ADR 0020 requires adversarial review and holds that "Author ≠ reviewer,
always". ADR 0021 says "At the levels above, a context does one unit".
ADR 0009 allows only the wave in flight and one planned wave to hold
task issues. The hub is the process repository by design, so most of
its commits are process work whatever the balance of the project as a
whole; the risk the Maintainer was shown is that a machine authorizing
its own process stories could raise the process share further.

## Decision

A retro interview is a moment on the whitelist, under G1: at a retro the
Maintainer invokes in a live session, they are asked product, strategy
and vision questions, and only those. A question is asked only when its
answer could change what the product is, who it is for, or which
product outcome the project pursues next, and only the Maintainer can
give it; a question about how, when, in what order, which package or
which tool is decided by the retro or turned into a process story.
Answers are recorded in the retro report in the Maintainer's words, not
filed as `question` issues; this is the one exception to story #66.

A retro may label a process story it files `retro` and `authorized`
when it files it, and that story then flows through `maya-plan`,
`maya-fleet` and `maya-review` like any other authorized story.
Accepting this ADR is the Maintainer's explicit, standing input to G2
for those stories, and G2 reads: "applying `authorized` to a new story,
except a story a retro authorizes under ADR 0024". The Maintainer
revokes one by removing the label. The following limits hold:

- **Only new stories.** A retro never adds `authorized` to an existing
  story and never widens an authorized one.
- **Only when due.** A retro authorizes only when `maya-orient`'s "Retro
  due" thresholds were met for its period.
- **Only after the balance answer.** Stories are filed after the
  interview. If the Maintainer answers that too much effort is going to
  process, the retro authorizes none.
- **Cap.** At most three authorized stories per retro.
- **Pattern only.** Each is for a measure that worsened against the
  previous retro, or a problem of the same kind that occurred at least
  twice in the period, with that evidence cited in the story.
- **Shown before the session ends.** The retro lists, in plain words,
  every story it authorized before the session ends; one the Maintainer
  strikes loses the label.
- **The guard.** A retro never authorizes a story that touches any rule
  ADR 0023 excludes from a process ADR, in either direction — a gate,
  the whitelist, an agent permission, what an agent may merge or what
  counts as a clean verdict, authorization, review or fixture
  integrity, or a product or domain convention — nor one that touches
  citation rules or the retro's own powers, needs any ADR other than a
  process ADR, or changes product scope. Such a story is still filed,
  without `authorized`, and doubt means without.
- **The guard is checked three times.** The retro's challenge agent
  checks each authorized story's guard classification, not only its
  scorecard claims; `maya-plan` re-checks each package; and
  `maya-review` re-checks each pull request. A package or pull request
  that crosses the guard is stopped and queued for the Maintainer.

Merges keep the existing clean-merge rule, and releases stay G3.

This amends ADR 0023 if it is accepted: the interview is added to its
G1 and the exception above to its G2 text. If ADR 0023 is rejected, it
amends ADR 0017 instead: the interview is added to G1, G2's "applied by
the Maintainer" gains "or by a retro under ADR 0024", and "a process
ADR" in the guard means none. This ADR is not accepted while ADR 0023
is still proposed. The amended ADR gains an `Amended by: 0024` line
when this one is accepted.

## Consequences

Process problems the evidence shows get fixed without waiting on the
Maintainer, and the Maintainer's attention at a retro goes to product,
strategy and vision. Wave reports finally have a reader, and each retro
report is the baseline for the next.

G2 is no longer applied only story by story. For retro stories the
Maintainer gives their input once, by accepting this ADR, and the
`retro` label is the record of which authorizations came that way. The
Maintainer loses a per-story veto before the story is filed; what
remains is the list shown before the session ends and removal of the
label afterwards. A bad retro story can reach `main` through the clean
merge path without the Maintainer reading it. If it edits skill text,
the marketplace serves that text from `main` at once, as ADR 0023
already says of any skill merge.

That a retro was run live by the Maintainer is not mechanically
verifiable: the report is written by an agent and, under ADR 0023,
merges itself. The guard rests on the trigger model (ADR 0017:
"autonomy executes during sessions, kicked off by the Maintainer") and
on the list shown before the session ends, not on proof. Nothing limits
how often the Maintainer invokes a retro; the "only when due" rule
stops extra retros from authorizing anything. A story has no size limit
(ADR 0011), so the cap counts stories, not work.

The retro judges the process that runs it. Its challenge step (a fresh
devil's-advocate agent, ADR 0020) and the rule that every claim cites
evidence are the check against self-praise. The balance question is
asked at every retro, before any story is filed.

Retro stories compete with the Maintainer's own stories for the one
wave in flight and the one planned wave that ADR 0009 allows, so a retro
that authorizes three stories can push product work back by several
waves.

Early retros have few waves to read. They report levels, not trends,
and a first retro can authorize only for a problem that occurred at
least twice within its own period.

Retros run only when the Maintainer invokes one; `maya-orient` says
when one is due and never runs one. There are no scheduled or unattended
retros.

Story #76 adds the `maya-retro` skill and the `retro` label, the "Retro
due" rule in `maya-orient`, `docs/retros/`, the guard re-check in
`maya-plan` and `maya-review`, and the change to `maya-fleet`'s
preflight, whose text "the wave's story carries the `authorized` label,
applied by the Maintainer" would otherwise refuse a retro story. Until
this ADR is accepted and the pull request that adds `maya-retro` has
merged, no retro authorizes anything.
