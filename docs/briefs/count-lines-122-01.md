# Brief · count-lines-122-01 · Sort the 108 not-bought counted items: slow, substituted or dead

2026-10-11. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/count-lines-122-01.md` (form `docs/templates/plan.md`), `docs/prompts/count-lines-122-01.md` (Researcher),
`docs/prompts/count-lines-122-01-capture.md` (PC capture) and `docs/tests/count-lines-122-01.md`. Don't add scope.

- Spec: `docs/specs/count-lines-122.md` · Hub project: `projects/r365-inventory` · Binding decisions (hub log):
  2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent;
  2026-10-10T17:30 PC jobs run in Claude Code, restricted key; 2026-10-11 owner: next job is the 108 items; Cary 1 buys only from Cheney
- Research to rely on: `docs/research/invoices-122.md` (Item last receipt: the 108 `none in 8 weeks` rows; Mapping by invoice: the
  R365 item on every line), `docs/research/items-122.md` (Item table: cost, unit, Cheney link). Copy the capture → inbox → Ops unzip →
  Researcher → Tester shape, `pages.csv` page log and forbidden-action list from `docs/plans/invoices-122-01.md`.

## Problem and decision (3–5 lines)

Verify-only, no build. Three sources, in this order:
1. **No browser:** from the invoices-122 captures, list every R365 item on a Cheney line 08/14–10/09 that is **not** one of the 207
   count names. Pair each with a likely count name among the 108 (same product words, size or category); mark pairs `(?)` unless the
   item numbers or item detail tie them. These are "other Cheney item" candidates.
2. **PC capture, count history:** export Item Details (as CNT-03.csv in items-122) for each approved CARY 1 count back to 08/01/2026
   (≈10 counts). Gives quantity per item per week.
3. **PC capture, older purchases:** first open 3 of the 108 items' detail pages and save any purchase-history or last-cost view; if one
   exists with dates, use it for all 108 and skip invoices. Else list CARY 1 Cheney invoices 05/15–08/13/2026 (header count first);
   if ≤45, open each view-only as in invoices-122-01; if more, stop and ask the owner.

## Files the builder may edit / must not edit

- may (Researcher, in its clone): `docs/research/count-lines-122.md` (new); `skills/fhs-skills/references/tech-stack.md` (added
  lines only, R365 section: where count history and item purchase history live)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any other file under `skills/`, any other `docs/` file

## Live systems touched

R365 only, **read-only**, on the owner's PC, owner signed in. Allowed: view, filter, scroll, export/download, opening count, item and
invoice detail pages to read. Forbidden: Save, Approve, Complete, Create, Edit, Delete, Map/assign, Re-import, removing an item from a
template, changing a cost/unit/GL, or any status button. A login or MFA prompt means stop and ask the owner. Toast not touched.

## Done-check (real outcome)

1. `docs/research/count-lines-122.md` has a row for each of the 108 names (copied exactly from invoices-122): group (slow mover /
   other Cheney item / looks dead / can't tell), last Cheney receipt found and its source, quantity on each captured count, $ on 10/04,
   capture file. No extra or missing names.
2. Group rules: **slow mover** = a Cheney receipt of that item before 08/14; **other Cheney item** = a paired non-count item with a
   receipt 08/14–10/09 and the pairing evidence; **looks dead** = no receipt in the history captured and qty 0 on every captured count;
   **can't tell** = anything else, with what's missing. State the earliest date the history reached.
3. Count history: number of approved counts captured and their dates; each export's total = that count's list total ±$1.
4. P1: for each "other Cheney item", the count line's current Cheney vendor item (from items-122) vs the item bought now.
5. Plain-words summary for the owner: "N still bought, just not lately", "N bought under another Cheney item", "N look dead
   ($X on the 10/04 count)", "N can't tell".

## Where it runs and which tree is live

Capture: owner's Windows PC (Claude Code + Claude in Chrome), from `C:\fhs\fhs-skills`, files under `C:\fhs\reports\count-lines-122\`,
zipped and sent with `send-report.ps1` to `/root/fhs-skills/inbox/count-lines-122.zip`. Ops unzips to
`/srv/fhs-build/reports/count-lines-122-captures/`. Step 1 reads `/srv/fhs-build/reports/invoices-122-captures/`. Note, tests, review:
server. Served tree `/root/fhs-skills` on `main`: on merge only the note and the `tech-stack.md` lines become visible. Windows mirror
unchanged (refresh is a separate OK). Gate before capture: owner signed in to R365 in Chrome on the PC.

## Tests the test plan must include

- 108 names = the `none in 8 weeks` names in `docs/research/invoices-122.md`; each in exactly one group.
- Each count export total = its count's list total ±$1; 10/04 quantities agree with items-122 CNT-03.csv.
- Every "looks dead" row: qty 0 on every captured count and no receipt in the stated history range.
- Every "other Cheney item" row cites the paired item, its receipt date and the capture.
- Tester picks 5 items (at least one per non-empty group) and confirms them against the captures.
- `pages.csv`: only view/filter/scroll/export actions; no save/approve/complete/create/edit/map URL or click.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines.
- Post-merge (owner): nothing changed in R365.

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
