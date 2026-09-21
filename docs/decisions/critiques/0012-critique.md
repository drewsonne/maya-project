# Critique of ADR 0012

- Target: 0012-wave-reports-as-process-telemetry.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

Two later ADRs assign this artifact a safety function its design cannot reliably deliver. ADR 0017 lets clean PRs auto-merge and names wave telemetry as the review mechanism if Dependabot-majors-on-green proves wrong; ADR 0020 makes adversarial findings advisory rather than blocking, explicitly because 'wave telemetry (ADR 0012) is the watch on whether that trade holds.' Yet the wave report is unverified self-report: it is written by the collect phase of the same pipeline whose performance it measures, committed autonomously between the guard gates, with no adversarial pass on the report itself — the one artifact 0020's author-never-reviews rule does not cover. A wave that gamed its criteria produces a clean-looking report, so the telemetry is weakest exactly when 0017 and 0020 need it. And as measurement, a free-form markdown table with a prose notes column is a poor instrument for the stated purpose ('trends... become visible in git history'): wave-1.md already improvises its columns ('n/a — package creates the gate'), different collecting sessions and hand-collected waves will drift further, and this is a project that schema-validates its fixtures, its skill frontmatter, and its plugin manifests in CI — but not the file it plans to tune the pipeline by. Trend analysis over N format-drifted markdown files is manual re-reading: memory with extra steps.

## Failure scenario

The Maintainer faces the decision 0020 defers — whether to flip advisory findings to blocking — and cites wave reports whose findings counts and criteria-met columns were self-reported by the collecting sessions. First noticed either when a post-merge defect traces back to a wave whose committed report shows all green (the watchdog reported nothing because the watched party wrote the report), or around wave ten, when an attempted trend query — findings per wave, fixture disagreements over time — finds the columns non-comparable across reports and the 'visible in git history' promise reduces to re-reading every file by hand.

## Who bears the cost

The Maintainer's tuning decisions (task horizon, package sizing, the advisory-vs-blocking call), and transitively the safety case for 0017's autonomous merging — which means, ultimately, consumers of the citable dataset if gamed work merges under telemetry that said everything was fine.

## Overlooked alternative

Two alternatives the Context never engages. First, structured records: a schema-validated YAML wave record checked by the hub's existing validate.yml machinery — the project already owns exactly this pattern for fixtures, so machine-comparable telemetry costs almost nothing extra over hand-formatted markdown. Second, the Context's premise that the evidence 'evaporates with the conversation' is only half-true: PRs, review verdicts, check runs, and issue timestamps are already durable and queryable in GitHub. What evaporates is the synthesis. A report derived from (and cross-checkable against) those primary records — or at minimum required to link them — is verifiable telemetry; a hand-typed table is a lossy secondary copy that can silently disagree with the primary record it summarises.

## Verdict reasoning

The core decision — every wave leaves a committed report, a wave without one is incomplete — survives any attack; it is cheap, reversible, and strictly better than nothing. But the gap between the load-bearing role 0017 and 0020 assign this telemetry and its actual design (self-authored by the measured party, no schema, no verification) is a real weakness. No urgency at current wave counts, where the Maintainer reads every report personally; it should be weighed before autonomy scales, ideally in implementation #22 (schema-validate the report, require primary-record links, or put the report itself under an adversarial eye).
