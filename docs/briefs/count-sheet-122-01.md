# Brief · count-sheet-122-01 · Who owns the Cary 1 count sheet, the owner's tick list, how store runs could reach R365

2026-10-12. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/count-sheet-122-01.md` (form `docs/templates/plan.md`), `docs/prompts/count-sheet-122-01.md` (Researcher),
`docs/prompts/count-sheet-122-01-capture.md` (PC capture) and `docs/tests/count-sheet-122-01.md`. Don't add scope.

- Spec: `docs/specs/count-sheet-122.md` · Hub project: `projects/r365-inventory` · Binding decisions (hub log):
  2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 and 17:30 PC jobs run in Claude Code + Claude in Chrome;
  2026-10-12T10:00 hide the 45, check ownership first, OK per change; 2026-10-12T10:01 the 32 can't-tell lines are store runs;
  2026-10-12 owner ticks the 45 list before any hide
- Research to rely on: `docs/research/count-lines-122.md` (Item table, group "looks dead": the 45 names, 10/04 qty, last receipt),
  `docs/research/store-audit-122.md` F5 (templates: creator R365 DSS User, modifier R365 10/06/2026, CAMDEN twin with 207 items).
  Copy the capture → inbox → Ops unzip → Researcher → Tester shape, `pages.csv` page log and forbidden-action list from
  `docs/plans/count-lines-122-01.md`.

## Problem and decision (3–5 lines)

Verify-only, no build, no R365 change. The actual hide is count-sheet-122-02, planned later from this note. Three parts:
1. **Tick list (no browser):** the 45 "looks dead" names in a table for the owner (Name, category from the name prefix, 10/04 qty,
   last Cheney receipt, `Keep?` left blank). The owner fills in `Keep?` after the merge, and Claude records it.
2. **PC capture, template ownership:** open CARY 1 - FHS Weekly Inventory detail. Capture the item list, every button and menu shown
   (as text, not clicked), the created/modified fields, any location or brand field, and any history or audit tab. Open the CAMDEN
   SQUARE template header to see if it is the same record or a copy. For 3 of the 45 (BEV APPLE JUICE ALL, CLEAN MOP HEAD,
   PAPER FD SM SALAD BOWL), open the item detail and capture any per-location or count-template setting (for example Inactive, or
   "count at location").
3. **PC capture, store runs (P1):** in R365 Accounting, search Vendors for Costco, Sam's, Walmart, Food Lion, Harris Teeter, "store" and
   "petty". Open the new-AP-invoice form only to read its fields, and close it without saving. Look under every menu for an expense,
   receipt or credit-card screen and capture it. Filter AP transactions for CARY 1 by any non-Cheney vendor since 05/15/2026 and record the count.

## Files the builder may edit / must not edit

- may (Researcher, in its clone): `docs/research/count-sheet-122.md` (new); `skills/fhs-skills/references/tech-stack.md` (added lines
  only, R365 section: who owns count templates, where a no-invoice purchase can be recorded)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any other file under `skills/`, any other `docs/` file

## Live systems touched

R365 only, **read-only**, on the owner's PC, owner signed in. Allowed: view, filter, scroll, export/download, opening a detail page or a
blank form to read it, then Cancel or Close. Forbidden: Save, Submit, Approve, Complete, Create (other than opening the blank form),
Edit-mode toggles that lock a record, Delete, Remove from template, Inactivate, Map/assign, Re-import, or any status button. If a
blank form can't be closed without saving, stop and ask the owner. A login or MFA prompt also means stop and ask. Toast not touched.

## Done-check (real outcome)

1. `## Tick list` has exactly the 45 "looks dead" names from `docs/research/count-lines-122.md` (no extras, no gaps), with blank `Keep?`.
2. `## Template ownership` answers each question with `seen` + capture file, or `(?)` + what is missing: (a) can the owner's role
   remove an item or mark it inactive for CARY 1 (control shown and enabled, not clicked); (b) is CAMDEN SQUARE's template the same
   record or a separate copy; (c) any sign of a brand/R365 push (location group, "managed by", modified-by history).
3. `## Store runs` lists only ways seen on a screen, each with its capture. It also gives the count of CARY 1 non-Cheney AP rows since 05/15/2026 (expected 0).
4. Plain-words summary for the owner, ≤6 lines: who owns the sheet, whether the owner can hide lines, the store-run options seen.

## Where it runs and which tree is live

Capture: owner's Windows PC (Claude Code + Claude in Chrome), from `C:\fhs\fhs-skills`, files under `C:\fhs\reports\count-sheet-122\`,
zipped and sent with `send-report.ps1` to `/root/fhs-skills/inbox/count-sheet-122.zip`. Ops unzips to
`/srv/fhs-build/reports/count-sheet-122-captures/`. Note, tests and review run on the server. Served tree `/root/fhs-skills` on `main`: on merge only the
note and the `tech-stack.md` lines become visible. Windows mirror unchanged (refresh is a separate OK). Gate before capture: owner
signed in to R365 in Chrome on the PC.

## Tests the test plan must include

- Tick list names = the 45 "looks dead" names in count-lines-122.md; `Keep?` blank on all 45.
- Each ownership answer cites a capture file that exists and shows what the answer says. Each `(?)` names what is missing.
- Each store-run option cites a capture that shows it. No option is named without a capture.
- `pages.csv`: only view/filter/scroll/export actions and blank-form opens closed with Cancel/Close; no save/submit/approve/create/
  delete/remove/inactivate click or URL.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines.
- Post-merge (owner): nothing changed in R365 (template still 207 items; no new vendor or AP draft).

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
