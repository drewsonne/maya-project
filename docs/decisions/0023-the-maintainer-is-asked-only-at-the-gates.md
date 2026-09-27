# 0023. The Maintainer is asked only at the gates

- Status: proposed
- Date: 2026-09-27
- Implementation: #70
- Binds: maya-plan, maya-fleet, maya-review, maya-implement, maya-record, maya-orient
- Amends: 0017, 0020

## Context

ADR 0017 set three human guard gates and made the work between them
autonomous:

- G1, "**Decide.** Spec rounds, ADR acceptance, epic closure. The
  Maintainer is the source of product truth."
- G2, "**Authorize.** Autonomous work happens only on a story carrying
  the `authorized` label, applied by the Maintainer."
- G3, "**Ship.** Anything crossing the repo boundary — release-PR
  merges, deploys, plugin releases — is the Maintainer's until the
  release ADR (story #16) says otherwise."

ADR 0017 lets agents merge only "a PR whose review verdict is **merge**
with zero findings, full suite green, scope clean and no fixture edits",
under an active authorization. ADR 0020, stage 5, says "every ADR draft
reaches the Maintainer with its strongest counter-argument attached".

On 2026-09-27, by the coordinating session's count, the Maintainer
merged about 15 pull requests and answered about 8 questions in chat.
By the gates above only one of them needed the Maintainer: whether
Dependabot merges need an authorized story, which became ADR 0022. The
rest reached the Maintainer for four reasons:

- clean-review merges that the Claude Code harness did not let agents
  perform (that permission has since been granted);
- wave reports and plan documents that a session chose to put in pull
  requests for the Maintainer to merge;
- skill pull requests held back because G3 names "plugin releases" as
  the Maintainer's, and every skill change bumps the plugin version;
- choices with an obvious default that a session asked about anyway.

ADR 0017 says what agents *may* do between the gates. It never says
when they must *not* ask, so nothing stops a session asking. The
Maintainer said on 2026-09-27: "My goal with these skills is to have an
autonomous system which only asks me when you need to," and asked for a
clean line between when they are asked and when agents continue. They
then set the shape of that line: "we should have a default position
that you do not ask and you act, and we should whitelist when to ask",
and "those whitelists must be gates. You CAN NOT pass by those
whitelist gates without my input".

## Decision

By default, agents act and do not ask. The Maintainer is asked only at
the moments listed below. The list is a closed whitelist: a moment not
on it is never a reason to ask. The moments are:

- **G1:** the product's purpose or spec; a calendar or domain convention
  (for example the correlation constant or Haab numbering); any ADR that
  is not a process ADR as defined below; epic closure; or any change to
  the gates, this whitelist or an agent permission.
- **G2:** applying `authorized` to a new story.
- **G3:** anything that crosses the repo boundary other than merging a
  skill or plugin pull request into the hub: npm release pull requests,
  deploys, publishing the fixture dataset, and tags or GitHub releases.
- **An exception:** a review verdict with findings or anything short of
  a clean merge; a stop report the planner cannot resolve; a wave in
  which more than a third of the packages end `blocked` or `failed`
  (in a wave of one or two packages, any one); or drift between `main`,
  the board and the docs that no agent can explain with evidence
  written into its output.

Every moment on the whitelist is a hard gate. No agent passes it
without the Maintainer's explicit input, whatever any other ADR, label,
review verdict or earlier answer says. At a gate the agent stops the
work that depends on it, files a `question` issue or queues the pull
request for the Maintainer, and continues only work that does not
depend on it. That an obvious default exists never passes a gate.

Everything else is decided by the agent: what to plan next among
authorized stories, scope and packaging, wording, and process choices
within the gates. A default is obvious when an ADR, a skill, the spec
or the current plan already points to it, or when it is reversible
inside the repo and touches no gate. The agent takes the obvious
default, or where there is none the most conservative option (the
smallest and most easily reversed), states the choice in its output,
and records it where it belongs. It never asks the Maintainer about a
choice outside the gates. A question at a gate is filed as a hub issue
labelled `question` and assigned to the Maintainer (story #66), never
asked only in chat or inside a document, and work that does not depend
on the answer continues. A spec interview (`maya-spec`) is itself a G1
gate, and its questions are asked live.

Records merge themselves: a wave report, plan document, research
finding or `docs/STATE.md` update is merged by the agent that wrote it,
in a session the Maintainer started, once every check on the pull
request has completed and passed. Merging a record does not take the
place of queueing: a pull request or question the record says needs the
Maintainer is still assigned to them.

A process ADR is one that changes only how agents work. It touches no
gate, nothing on the whitelist above, no agent permission, no rule on
what an agent may merge or what counts as a clean verdict, no
authorization rule, no review or fixture-integrity rule, and no product
or domain convention.
A process ADR is accepted by the recording agent once a fresh agent has
critiqued it, and merged on green checks; its critique is committed with
it. Every other ADR, and any ADR whose class is in doubt, is proposed
and queued for the Maintainer with its critique attached.

A skill or plugin pull request is not a release. One whose `maya-review`
verdict is merge, with zero findings and every check green, made under
an active authorization, is merged by an agent. The release is the
Maintainer running `/plugin update`. A skill pull request that changes
any of the rules listed as excluded from a process ADR is a change to
the gates, so it is G1 and queued, whatever its verdict.

This decision narrows ADR 0017 and ADR 0020 without superseding them.
In ADR 0017, G1 no longer covers process ADRs, G3 no longer covers
merging skill or plugin pull requests, and the autonomous list gains
record merges, clean skill merges and process-ADR acceptance. In ADR
0020, stage 5's critique of a process ADR goes into the pull request
instead of to the Maintainer. The rest of both stands.

Because this decision changes the gates, it is itself G1. It is
proposed, and the Maintainer accepts it by merging its pull request;
closing the pull request rejects it.

## Consequences

The Maintainer's queue holds only gate decisions, `question` issues and
exceptions. Of the 2026-09-27 touchpoints above, only the Dependabot
question would have reached them.

The Maintainer accepted the risk in choosing this: "Maybe that will come
back to bite me, but if the whitelist is at the right moments, it
should be ok." A misfire is either an agent acting where it should have
been stopped, or asking where it should have acted. Both are caught
after the fact: wave telemetry (ADR 0012) records what each wave did,
and the wave gap analysis (ADR 0020, stage 4) asks what a wave missed.
A moment is added to or removed from the whitelist only by a later ADR
that the Maintainer accepts; no agent, skill or answer to a question
widens or narrows it.

A merge to the hub's `main` makes a new plugin version installable at
once, because the marketplace serves `./plugins/maya` from `main`. The
Maintainer's `/plugin update` is the release only for their own
sessions, and only while marketplace auto-update is off. Anyone else
who installs the marketplace gets skill text no human has read.

What guards those merges is the clean `maya-review` verdict, whose
adversarial part is advisory (ADR 0020), and the checks on the pull
request. The hub's `main` has no branch protection, so "every check
passed" is checked by the merging agent, not enforced by GitHub. A
pull request that changes `maya-review` is reviewed by the version it
changes.

Records and process ADRs are merged by their authors. ADR 0020's
"author ≠ reviewer" still holds for code and skill changes, but records
get no second reader before `main`. A process ADR still gets a fresh
agent's critique; only acceptance moves to the agent.

Agents now choose where they used to ask, so a wrong default is found
after the fact rather than before, and each unratified default can
become precedent. Each choice is written into the output that made it,
and `maya-orient` is where the Maintainer sees them when they look.

The process-ADR test is judged by the recording agent. The list of what
makes an ADR not a process ADR is the check, and doubt sends it to the
Maintainer.

Every skill that asks the Maintainer anything or opens pull requests
must follow this decision: `maya-plan`, `maya-fleet`, `maya-review`,
`maya-implement`, `maya-record` and `maya-orient`. Agents load the
installed skills, not this file, so until story #70 ships, skills behave
as written, and a session briefed with this decision follows it. Story
#66 carries the sentence "merges and releases stay with the Maintainer
as ADR 0017 sets out", which must be read as ADR 0017 as amended here.
ADR 0017 and ADR 0020 each carry an `Amended by: 0023` line.
