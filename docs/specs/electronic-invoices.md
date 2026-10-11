# Spec · electronic-invoices · Check that 122's Cheney invoices land complete and mapped in R365 (F3)

2026-10-11 · Hub project: `projects/electronic-invoices` · Plan page: none yet

## Problem and today

- **Problem:** purchases are half of food cost. The store audit (`docs/research/store-audit-122.md` F3) found Cheney Brothers
  invoices **in place**: they arrive by R365 Import, about two a week, CARY 1 rows from 08/14/2026 to 10/09/2026. Three things
  are still unknown: whether every invoice line maps to an R365 item, whether every counted item is still being bought, and
  whether invoices get approved on time. The newest three CARY 1 invoices were Unapproved, and the vendor shows $264,494.94
  pending approval company-wide `(?)`. F2 (`docs/research/items-122.md` "Moved to F3") had no invoice line detail, so it
  could not check receipt dates or unmapped lines.
- **Today:** invoices import on their own. Nobody checks line by line. An unmapped line puts the cost in the wrong GL account or
  nowhere, and an unapproved invoice stays out of COGS for that week. Either one makes weekly food cost (F7) wrong without
  anyone noticing.

## Who runs it

- Claude, once, read-only, with the owner signed in on the PC (Claude Code + Claude in Chrome). The owner reads a short list in
  plain words: "N invoices still waiting for approval", "N Cheney lines are not tied to an item", "N counted items not bought in 8 weeks".
- Later, if this check finds real gaps: a weekly step in `fhs-skills` ("approve and check this week's Cheney invoices"). That
  is decided after this check, not built now.

## Done when (measurable)

1. Every CARY 1 Cheney invoice and credit memo dated 08/14–10/09/2026 is listed with number, date, total and approval status.
   The count matches the Cheney vendor Transactions tab for CARY 1 in that range.
2. For each invoice, the line amounts add up to the invoice total (within $0.01). Any that don't are listed.
3. Every invoice line is marked mapped (with its R365 item) or unmapped (GL account only, or no item).
4. Each of the 207 items on CARY 1 - FHS Weekly Inventory gets its last Cheney receipt date in the range, or "none in 8 weeks".
5. A tester confirms 3 picked invoices against the PC captures (no live browser).

## In scope

- P0: CARY 1 Cheney Brothers invoices and credit memos, 08/14–10/09/2026; line detail; approval status; mapping; last receipt per counted item.
- P1: who approves invoices today and how long they wait (invoice date vs approval date, where the screens show it); who owns
  the vendor-item mapping (owner, franchise or R365 support).

## Out of scope (parked on the hub)

- Approving, editing, mapping or re-importing any invoice, and any change to the import feed. Fixes are a later plan, each with
  the owner's OK; franchise-owned settings go to the franchise first (CLAUDE.md project rule).
- Fixing the F2 problem list ($0 cost, missing Cheney links, unit mismatches): its own fix plan, after this check.
- Other vendors (Coke, bread, produce) `(?)` whether any exist for CARY 1; 878 / CAMDEN SQUARE (PFG); AP payments and checks (F8 area).
- A reusable invoice checker script. Decide after this check shows how big the gaps are.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Invoice headers (number, date, total, status) | R365 Accounting → AP transactions; vendor Cheney → Transactions | grid export (INV-01/02.csv exist from F2) | yes, headers (F2 captures) |
| Invoice lines (item, qty, unit, amount, GL) | R365 AP invoice detail, or an item purchase report | **unknown which**: no line-detail report was found in F2 (INV-04/05-missing) | `(?)` → research |
| Import feed (who sends, how) | R365 Admin → Integrations; R365 support | screen | partly: Supplyit and NDCP Disconnected, feed not on those tiles `(?)` |
| Counted items (207) | `docs/research/items-122.md` item table | file | yes (F2 merged 6bcd0e8) |
| Approval date / approver | R365 invoice detail or audit trail | screen | `(?)` → research |

## Owner rules that bind it

- Read-only exports allowed (hub log 2026-10-10T16:02). Browser work on the owner's PC, owner signed in (2026-10-10T17:01, 17:30).
- q1 (owner): Cheney Brothers is the distributor; invoices come by R365 Import.
- Receipt recency and unmapped invoice lines moved here from F2 (owner, 2026-10-11).

## Open questions

- None blocking. Research first finds where R365 shows invoice line detail (a purchase report or each invoice opened); if there
  are more than ~40 invoices and no report, the plan says how many to open and asks the owner before a long capture.
