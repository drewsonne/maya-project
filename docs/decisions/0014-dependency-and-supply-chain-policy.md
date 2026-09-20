# 0014. Agents touch only contract-listed dependencies; monthly grouped Dependabot everywhere

- Status: accepted
- Date: 2026-09-20
- Implementation: #18

## Context

Agents author most changes, and a dependency is the one place a small
diff imports someone else's code into the trust boundary. There was no
written rule: whether an agent may add a test library, what pinning
means, and Dependabot existed only on maya-dates (weekly, majors
ignored). Story #18 under epic #15 called for the policy.

## Decision

- An agent may add, remove or bump a dependency only if its package
  block's contract names that dependency explicitly. Anything else —
  dev or runtime — is a blocked finding to report, never a judgement
  call.
- `package.json` uses caret ranges; a committed lockfile pins the tree;
  CI installs with `npm ci`. Scopes that include `package.json` include
  the lockfile (per the wave-1 amendment).
- Dependabot runs uniformly on the four active repos (maya-dates,
  maya-calculator-parser, maya-calculator, maya-date-fixtures): monthly,
  npm and github-actions ecosystems, minor+patch grouped into one PR,
  majors arriving as individual PRs rather than ignored. Security
  alerts are immediate regardless of schedule.

## Consequences

The supply-chain surface changes only where a plan said it would, and a
reviewer can check a dependency diff against the package block
mechanically. Monthly cadence keeps PR volume low on a quiet project;
majors being visible (not ignored) means aging is a queue, not a
surprise. maya-dates' existing weekly/majors-ignored config aligns via
the open PR #201 rather than a competing edit on main.
