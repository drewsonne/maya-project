# Critique of ADR 0014

- Target: 0014-dependency-and-supply-chain-policy.md
- Date: 2026-09-21
- Verdict: **worth-revisiting**
- Advisory per ADR 0020 — this critique informs the Maintainer and blocks nothing.

## Strongest counter-argument

The policy secures the wrong surface. 'An agent may touch only contract-listed dependencies' is a rule about the `package.json` diff, but the code that actually enters the trust boundary is the lockfile's transitive tree — which the policy explicitly puts in every such scope ('scopes that include package.json include the lockfile') while providing no review mechanism for it. A reviewer 'checks a dependency diff against the package block mechanically': the block names the direct dependency, and the accompanying multi-thousand-line lockfile churn of transitives is checked by nobody, human or agent. Combined with caret ranges (so every regeneration floats transitives forward) and ADR 0017's autonomous merging of green Dependabot PRs — with monthly *grouped* minor+patch PRs that destroy bisectability, so one bad bump rides in with twenty good ones — the effective policy is 'whatever npm serves on regeneration day ships, if the fixtures pass'. And the fixtures are precisely the wrong detector: they prove Long Count arithmetic, not the absence of a malicious postinstall script. This matters more here than on a typical project for two reasons the Context never mentions: (1) this is an agent-executed pipeline, so `npm install`/`npm ci` runs unattended, repeatedly, in sessions holding the Maintainer's GitHub and npm credentials — install-time script execution is the exact vector of the 2025 npm worm-style compromises, and nothing in the policy sets `ignore-scripts`, a minimum-release-age cooldown, or a lockfile-diff gate; (2) one of the four repos publishes a dataset marketed as a citable academic reference (0006), whose implied warranty a build-time compromise would poison. 'Security alerts are immediate' even codifies pulling freshly-cut versions fastest, the opposite of a quarantine posture.

## Failure scenario

A transitive of a dev dependency in any of the four repos ships a compromised patch release. It arrives via lockfile regeneration on a contract-permitted bump, or inside a monthly grouped Dependabot PR. CI is green — the fixture suite measures calendar correctness, not node_modules behavior — so under 0017 an agent merges it autonomously. The next wave's agents run `npm ci`; a postinstall script executes unattended with access to gh/npm tokens and exfiltrates or republishes tampered @drewsonne/* packages, including maya-date-fixtures. First noticed externally — an npm advisory, a registry takedown, or a downstream consumer's report — because no gate inside this pipeline observes anything but calendar correctness. For the citable dataset, the damage (a tampered published version others cite) is exactly the 'worse than a wrong private test value' harm 0006 warned about.

## Who bears the cost

The Maintainer's credentials and every repo they control; external consumers of the @drewsonne packages; most acutely the academic credibility of maya-date-fixtures, the project's self-declared most externally valuable output.

## Overlooked alternative

A quarantine-and-verify posture, cheap and mechanical, fully compatible with the contract rule: Dependabot `cooldown`/minimum-release-age (e.g., 7–14 days) so freshly published versions are never auto-taken; `ignore-scripts=true` in each repo's .npmrc so unattended agent installs never execute install hooks; and a lockfile-integrity gate in CI (dependency-review action or lockfile-lint) so the transitive diff is checked by a machine since no human will read it. The Context discusses cadence, grouping, and majors — the schedule of updates — and never engages with what executes at install time or who inspects the transitive tree.

## Verdict reasoning

The core rule — agents change only contract-listed dependencies, lockfile committed, npm ci in CI, Dependabot uniform across the four repos — is sound and strictly better than the prior vacuum, so this is not a superseding case. But the policy's own success criterion ('a reviewer can check a dependency diff mechanically') is only true for the direct-dependency layer, and the unattended-agent-install vector is specific to this pipeline's design and entirely unaddressed. The fixes are additive (cooldown, ignore-scripts, lockfile gate) and should be weighed before the first autonomous Dependabot merge under 0017, not after.
