# Brief · <slug>-<nn> · <title>

<YYYY-MM-DD>. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/<plan>.md` (form `docs/templates/plan.md`), `docs/prompts/<plan>.md` and `docs/tests/<plan>.md`. Don't add scope.

- Spec: `docs/specs/<slug>.md` · Hub project: `projects/<slug>` · Binding decisions: <hub log entries, by date>
- Research to rely on: `docs/research/<file>` (facts marked `(?)` stay unverified)

## Problem and decision (3–5 lines)

<What changes and why. The design choice already made, so the Drafter doesn't make one.>

## Files the builder may edit / must not edit

- may: `<path>`
- must not: the served tree `/root/fhs-skills`, `shared/config.json` unless keys are named, <other>

## Live systems touched

<None, or each Toast / R365 / ADP change exactly.>

## Done-check (real outcome)

<Which real week folder, report or screen, and which numbers must match.>

## Where it runs and which tree is live

<Server, desktop or both; the served tree; what stays as is.>

## Tests the test plan must include

- <case: input → expected>

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
