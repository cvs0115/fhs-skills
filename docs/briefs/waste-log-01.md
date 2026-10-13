# Brief · waste-log-01 · Waste log research

2026-10-13. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/waste-log-01.md`, `docs/prompts/waste-log-01.md` and `docs/tests/waste-log-01.md`. Don't add scope.

- Spec: `docs/specs/waste-log.md` · Hub project: `projects/waste-log` · Binding decisions: owner 2026-10-13: associates will record waste in Toast at the POS (a waste button, `(?)`); the old manager sheet to R365 process is being replaced.
- Research to rely on: `docs/research/store-audit-122.md` F6 (R365 shows one log WL-000002; Toast waste $0; void-reason page `(?)`)

## Problem and decision (3–5 lines)

Waste moves to the Toast POS. Read-only research finds out what the POS waste button/void reasons really are, who sets the reasons up (franchise vs owner), where Toast Food waste reporting shows them, and whether/how Toast waste reaches R365 (integration or not) and AvT. The skill later checks "sheet vs R365"; this plan builds no skill, only the research note.

## Files the builder may edit / must not edit

- may: `docs/research/waste-log-122.md`, new facts in `skills/fhs-skills/references/tech-stack.md`
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any skill script

## Live systems touched

None. Read-only on R365 (Inventory → Waste: list, one log's detail, the new-log form opened and NOT saved, item waste accounts) and Toast (Food waste reporting, void reasons).

## Done-check (real outcome)

Owner's PC capture plus one real test waste entry made on the POS by the owner/manager (and voided or marked test as Toast allows): it must appear in Toast Food waste reporting with item, reason and $. Unverified items marked `(?)`.

## Where it runs and which tree is live

PC capture (Claude in Chrome); note written in a clone. Nothing goes live; no skill changes.

## Tests the test plan must include

- Note exists, every claim cites a capture file or is marked `(?)`.
- Test entry: POS button name and steps (with a screenshot) → appears in the Toast report with the same $.
- No R365 or Toast record changed (owner confirms after capture).

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
