# Brief · invoices-122-01 · Verify 122's Cheney invoices: lines, mapping, approval, last receipt

2026-10-11. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/invoices-122-01.md` (form `docs/templates/plan.md`), `docs/prompts/invoices-122-01.md` (Researcher),
`docs/prompts/invoices-122-01-capture.md` (PC capture) and `docs/tests/invoices-122-01.md`. Don't add scope.

- Spec: `docs/specs/electronic-invoices.md` · Hub project: `projects/electronic-invoices` (F3) · Binding decisions (hub log):
  2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent;
  2026-10-10T17:30 PC jobs run in Claude Code, restricted key; q1 Cheney by R365 Import; 2026-10-11 receipt recency and unmapped
  lines moved here from F2
- Research to rely on: `docs/research/store-audit-122.md` (F3), `docs/research/items-122.md` (207-item table, "Moved to F3", INV
  page paths). Copy the capture → inbox → Ops unzip → Researcher → Tester shape, `pages.csv` page log and forbidden-action list from
  `docs/plans/items-122-01.md`.

## Problem and decision (3–5 lines)

Verify-only, no build. F2 proved R365's reports have **no invoice line detail** (`INV-04/05-missing.txt`), and the F2 header export
shows **20** CARY 1 Cheney invoices in range (`INV-03.txt`). So the decision: the **capture opens each CARY 1 Cheney invoice and
credit memo dated 08/14–10/09/2026, view only**, and saves its page text. That is under the spec's ~40 limit, so no owner question.
The invoice line grid is virtualized: the capture scrolls it until the lines read equal the footer "1 - N of N Items" and records N.
If the grid has a read-only export button, use it instead and say so. Also save the Cheney vendor **Transactions** tab export for CARY 1
(the count to match) and, where the invoice page shows them, approval date and approver.

## Files the builder may edit / must not edit

- may (Researcher, in its clone): `docs/research/invoices-122.md` (new); `skills/fhs-skills/references/tech-stack.md` (added lines only,
  R365 section: where invoice line detail lives and how to read it)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any other file under `skills/`, any other `docs/` file

## Live systems touched

R365 only, **read-only**, on the owner's PC, owner signed in. Allowed: view, filter, scroll, export/download, opening invoice detail
pages (`invoiceId=`) to read. Forbidden: Save, Approve, Complete, Create, Edit, Delete, Map/assign an item, Re-import, changing a GL,
or any button that changes status. A login or MFA prompt means stop and ask the owner. Toast not touched.

## Done-check (real outcome)

1. `docs/research/invoices-122.md` lists every CARY 1 Cheney invoice and credit memo 08/14–10/09/2026: number, date, total, approval
   status, approval date + approver (or "not shown"), line count N, capture file. Count = the Transactions tab export count for CARY 1.
2. Per invoice, lines sum to the total within $0.01; mismatches listed (a grid read short of N is a capture gap, not a mismatch).
3. Every line: mapped (R365 item name) or unmapped (GL only / no item), with GL. Totals: lines, mapped, unmapped, unmapped $.
4. Each of the **207** counted items (from `docs/research/items-122.md`) gets its last Cheney receipt date in range, or "none in 8 weeks".
   Match on the R365 item name/number shown on the line; say how many matched by name only.
5. P1 section: approval wait (invoice date → approval date) where shown; who appears to own vendor-item mapping (owner / franchise /
   R365 support / can't tell), from the screens.
6. Plain-words summary for the owner: "N invoices waiting for approval", "N Cheney lines not tied to an item ($X)", "N counted items not
   bought in 8 weeks".

## Where it runs and which tree is live

Capture: owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills`, files under
`C:\fhs\reports\invoices-122\`, zipped and sent with `send-report.ps1` to `/root/fhs-skills/inbox/invoices-122.zip`. Ops unzips to
`/srv/fhs-build/reports/invoices-122-captures/`. Note, tests, review: server. Served tree `/root/fhs-skills` on `main`: on merge only the
note and the `tech-stack.md` lines become visible. Windows mirror unchanged (refresh is a separate OK). Gate before capture: owner
signed in to R365 in Chrome on the PC.

## Tests the test plan must include

- Invoice count = Transactions tab count for CARY 1 in range; no duplicate numbers.
- Every invoice: lines read = footer N, or listed as a capture gap.
- Line sums = invoice totals ±$0.01 (except listed mismatches/gaps).
- 207 items present, each with a date or "none in 8 weeks"; no duplicates.
- Tester picks 3 invoices (at least 1 with an unmapped line if any) and confirms header, lines and mapping against the captures.
- `pages.csv`: only view/filter/scroll/export actions; no save/approve/complete/create/map URL or click.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines.
- Post-merge (owner): nothing changed in R365 (no invoice status changed by the capture).

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
