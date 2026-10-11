# Spec · items-122 · Check that 122's counted items have the right cost, units and vendor (F2)

2026-10-11 · Hub project: `projects/r365-inventory` (Phase 2, F2) · Plan page: https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK

## Problem and today

- **Problem:** food cost is only as good as the cost and unit on each counted item. The store audit
  (`docs/research/store-audit-122.md` F2) found items, units and vendors **in place**, but many items show Avg Cost **$0.00**
  and a few have purchase and count units that differ (BEV APPLE JUICE ALL, BREAD WHITE BREAD).
  Nobody knows yet whether any of the **207 items on CARY 1 - FHS Weekly Inventory** are among them.
- **Today:** the store counts weekly in R365 (last approved 10/04/2026, $7,461.73). Cheney Brothers invoices arrive by R365 Import.
  Nobody checks item by item. A counted item at $0.00, or counted in the wrong unit, undervalues inventory and skews COGS without anyone noticing.

## Who runs it

- Claude, once, read-only, with the owner signed in on the PC (Claude Code + Claude in Chrome). The owner reads a short list of
  problem items in plain words: "these N items count at $0", "these N are counted in a different unit than Cheney sells them".

## Done when (measurable)

1. Every one of the 207 template items is listed with: count unit, cost per count unit and extended value on the 10/04/2026 approved count,
   last Cheney receipt date and purchase unit (or "none in 8 weeks").
2. The per-item extended values on the 10/04/2026 count add up to **$7,461.73** (within $1.00).
3. A problem list sorts every item into one of: $0 cost · no Cheney receipt in 8 weeks · purchase unit ≠ count unit with no
   clear conversion · Cheney invoice line not mapped to an item. Each problem names the capture it came from.
4. A tester confirms 5 picked items against the PC captures (no live browser).

## In scope

- P0: the 207 counted items for CARY 1; Cheney Brothers invoices for the last 8 weeks (08/14–10/09/2026 range seen in the audit).
- P1: who can fix each problem (owner vs franchise vs R365 support), from what the screens show.

## Out of scope (parked on the hub)

- Changing any item, unit, conversion, vendor item or cost. Fixes are a later plan, each with the owner's OK; franchise-owned
  settings go to the franchise first (CLAUDE.md project rule).
- Items not on the count template; other vendors; 878 / CAMDEN SQUARE (copy later).
- A reusable checker script. Decide after this check shows how big the problem is.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Count template items (207) | R365 Inventory → Count templates | screen / export on the PC | yes, count only (audit F5) |
| Approved count 10/04/2026 lines | R365 Inventory → Inventory counts | screen / export | total only ($7,461.73) |
| Item units, conversions, Avg Cost | R365 Inventory → Items | grid export + item detail | partly (audit F2); conversions `(?)` |
| Cheney invoice lines | R365 Accounting → AP / vendor Cheney Brothers | invoice detail / export | headers only (audit F3) |

## Owner rules that bind it

- Read-only exports allowed (hub log 2026-10-10T16:02). Browser work on the owner's PC, owner signed in (2026-10-10T17:01, 17:30).
- Scope stays food + paper + chemicals as counted today (q3, owner).

## Open questions

- None blocking. Franchise food cost % (q5) is for F7, not this check.
