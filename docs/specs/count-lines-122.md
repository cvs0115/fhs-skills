# Spec · count-lines-122 · Sort out the 108 counted items Cary 1 hasn't bought in 8 weeks

2026-10-11 · Hub project: `projects/r365-inventory` (F2 follow-up, before F4) · Plan page: https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK

## Problem and today

- **Problem:** 108 of the 207 items on **CARY 1 - FHS Weekly Inventory** had no Cheney receipt 08/14–10/09/2026
  (`docs/research/invoices-122.md`, Item last receipt). 95 of them also count at **$0.00** cost (`docs/research/items-122.md`),
  and together they are only **$513.06** of the 10/04/2026 count ($7,461.73). Cary 1 buys **only from Cheney** (owner, 2026-10-11).
  So each of the 108 is one of: a slow mover last bought before 08/14; bought under a different Cheney item (substitution or
  new item number); or a dead line nobody stocks. Until that is known, the $0-cost fix list and food cost (F7) can't be trusted.
- **Today:** the store counts all 207 lines every week. Nobody checks whether a line is still stocked. Dead lines waste count
  time; a live item at $0 undervalues inventory.

## Who runs it

- Claude, once, read-only, from captures taken on the owner's PC (Claude Code + Claude in Chrome, owner signed in).
  The owner reads three short lists: "still bought, just not lately", "bought under another Cheney item", "looks dead".

## Done when (measurable)

1. Each of the 108 items is in exactly one group, with the evidence: **slow mover** (last Cheney receipt date before 08/14/2026);
   **other Cheney item** (the Cheney item it's bought as now, with a receipt date in 08/14–10/09); **looks dead** (no receipt found
   in the longest history R365 shows, and quantity 0 on each captured count); **can't tell** (say what's missing).
2. For each item: quantity on each approved count captured (at least the last 8 weekly counts, if R365 keeps them).
3. The 108 list matches `docs/research/invoices-122.md` exactly (same names, no extras, no gaps).
4. A tester confirms 5 picked items (at least one per non-empty group) against the captures.

## In scope

- P0: the 108 items; R365 count history for CARY 1; the longest Cheney purchase history R365 shows per item.
- P1: for "other Cheney item", whether the count line's Cheney vendor item link points at the old item.

## Out of scope (parked on the hub)

- Removing a line from the count template, changing any item, cost, unit or vendor item link. Fixes are the later F2 fix plan,
  each with the owner's OK; franchise or R365-support owned settings go to them first (CLAUDE.md project rule).
- The 99 items Cary 1 did buy in 8 weeks; 878 / CAMDEN SQUARE; F4 recipes.
- Cheney's own website or order guide (not an R365 screen). Only if R365 history is too short, as a separate owner OK.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| The 108 names | `docs/research/invoices-122.md` Item last receipt | file | yes, 2026-10-11 |
| Cost, unit, Cheney link per item | `docs/research/items-122.md` Item table | file | yes, 2026-10-11 |
| Approved counts before 10/04/2026 | R365 Inventory → Inventory counts (CARY 1) | Item Details export per count on the PC | 10/04 only; older counts `(?)` |
| Per-item purchase history beyond 8 weeks | R365 item detail or a purchase report | screen / export on the PC | not found yet `(?)`; F2/F3 reports had no line detail |
| Cheney invoices before 08/14/2026 | R365 Cheney vendor → Transactions; invoice detail | screen, as in invoices-122-01 | how far back `(?)` |

## Owner rules that bind it

- Read-only exports allowed (hub log 2026-10-10T16:02). Browser work on the owner's PC, owner signed in (2026-10-10T17:01, 17:30).
- Only vendor is Cheney (owner, 2026-10-11). Count scope stays food + paper + chemicals (q3).

## Open questions

- None blocking. How far back R365 history goes is found by the capture, not asked.
