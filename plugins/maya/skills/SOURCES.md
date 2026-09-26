# Sources

Research the skills' context-handling rules rest on. Each entry states what
the source establishes and which skill rule depends on it, so a rule can be
traced to evidence and revisited when the evidence changes.

Checked: 2026-09-26. Findings are numbered F1–F6 and referenced from the
skills and from the gap analysis that produced this file.

## F1. Input length alone degrades output

Chroma, *Context Rot: How Increasing Input Tokens Impacts LLM Performance*,
2025. <https://www.trychroma.com/research/context-rot> — replication kit at
<https://github.com/chroma-core/context-rot>.

Eighteen frontier models, task difficulty held constant, only input length
varied. Every model degraded at every length increment, well before the
window limit. Distractors, haystack structure and needle–question similarity
all worsen the effect non-uniformly.

Liu et al., *Lost in the Middle: How Language Models Use Long Contexts*,
2023. <https://arxiv.org/abs/2307.03172>

The positional form: material at the start and end of a long context is
recalled markedly better than material in the middle.

Rules resting on this: `maya-fleet` "each agent receives only its package
block, scope, fixture command"; `maya-orient` 250-word report cap; the
principle that a working context loads the leaf and its binding constraints,
not the tree above it.

## F2. Self-conditioning: a model's own earlier errors poison later steps

Sinha et al., *The Illusion of Diminishing Returns: Measuring Long Horizon
Execution in LLMs*, 2025. <https://arxiv.org/abs/2509.09677>

Per-step accuracy falls as step count rises, and a large part of that is not
context length: when the context contains the model's own prior mistakes, it
reads them as an established pattern and builds on them. Scaling model size
does not remove the effect; extended thinking mitigates it. Isolating
execution (plan and knowledge supplied up front) substantially lengthens the
task a model can complete.

Rules resting on this: one agent per package; "never dispatch the next wave
from inside a run"; author ≠ reviewer; devil's-advocate and red-team passes
run in a fresh agent; the proposed rule that a session does one task, or one
level of the tree, then ends.

## F3. A wrong early turn is not recovered inside the same conversation

Laban, Hayashi, Zhou and Neville, *LLMs Get Lost In Multi-Turn
Conversation*, 2025. <https://arxiv.org/abs/2505.06120>

Across 200,000+ simulated conversations and six task types, multi-turn
performance averaged 39% below single-turn on the same underlying task,
decomposed as a small aptitude loss and a large reliability loss. Models
assume early, attempt a solution prematurely, then over-rely on it; once
off track they do not come back.

Rules resting on this: `maya-spec` interviews one round at a time and writes
each answer before asking the next, never drafting the whole document for
correction; `maya-implement` and `maya-fleet` treat stop-and-report as the
correct output on ambiguity, red baseline, fixture disagreement, scope
escape or an unmade decision; `maya-review` stops at the first failed
mechanical check rather than continuing into judgement.

## F4. Goal drift is pattern-matching, and recitation counters it

Arike et al., *Evaluating Goal Drift in Language Model Agents*, 2025,
AIES. <https://arxiv.org/abs/2505.02709>

Agents given a goal in the system prompt and then exposed to competing
environmental pressure drift from it, and the drift correlates with
susceptibility to pattern-matching as context grows rather than with
inability to recall the goal. An agent that periodically re-derives its
goal held adherence past 100k tokens.

Ji, *Context Engineering for AI Agents: Lessons from Building Manus*, 2025.
<https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus>

Production practice: a todo file rewritten at the end of every step keeps
the objective in the model's recency zone across ~50-call tasks. Recitation,
not memory, is what holds the goal.

Rules resting on this: `maya-implement` step 6 (re-read every acceptance
criterion by name before finishing); the proposed rule that every task,
ADR and PRD section restates its goal at the top, and that an agent keeps a
criteria checklist in its PR description from the first commit.

## F5. Clean windows that return compact summaries

Anthropic, *Effective context engineering for AI agents*, 2025.
<https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents>

Context is a finite resource with diminishing returns. Three mitigations:
compaction (summarise and restart), structured note-taking outside the
window, and sub-agent architectures in which each sub-agent works deeply in
a clean window and returns a compact summary to the coordinator.

Rules resting on this: the package block, the ADR and the PR description are
the written handoffs at tree boundaries; `maya-review` returns one verdict
and at most five findings; `maya-fleet` collects one table, not one report
per package; `maya-orient` is a summary, not a working context.

## F6. Failure attribution, not just length

*The Long-Horizon Task Mirage? Diagnosing Where and Why Agentic Systems
Break*, 2026. <https://arxiv.org/html/2604.11978v1>

Introduces the HORIZON diagnostic benchmark (3,100+ trajectories across four
agentic domains) and a trajectory-grounded judge for attributing failures
to specific breakdown points rather than to horizon length as such. Useful
as a reminder that "the task was too long" is not a root cause; the wave
report and stop reports should name where the break happened.

Rules resting on this: `maya-fleet` wave report and gap analysis (ADR 0012,
ADR 0020); the stop-report shape proposed in the gap analysis.

## Not yet used

Sources found but not yet tied to a rule. Kept so the next revision does not
re-search them.

- *Beyond pass@1: A Reliability Science Framework for Long-Horizon LLM
  Agents*, 2026. <https://arxiv.org/html/2603.29231v1> — reliability
  degrades super-linearly with task duration × domain structure; relevant if
  the project ever measures wave reliability rather than pass/fail.
- *Beyond Compaction: Structured Context Eviction for Long-Horizon Agents*,
  2026. <https://arxiv.org/pdf/2606.11213>
- *Slipstream: Trajectory-Grounded Compaction Validation for Long-Horizon
  Agents*, 2026. <https://arxiv.org/pdf/2605.08580>
