# Spec · count-sheet-122 · Take dead lines off the Cary 1 count sheet; get store-run buys into food cost

2026-10-12 · Hub project: `projects/r365-inventory` (F2 fix) · Plan page: https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK

## Problem and today

- **Problem 1, dead lines:** 45 of the 207 lines on **CARY 1 - FHS Weekly Inventory** look dead: 0 on hand on 10/04/2026 and no
  Cheney receipt since 05/15/2026 (`docs/research/count-lines-122.md`, group "looks dead"). The store still counts them every week.
- **Problem 2, store runs:** 32 lines have stock on hand but no Cheney receipt. The owner says those items come from store runs
  (Costco, grocery) paid by card or cash, so they never reach R365 as invoices (hub log 2026-10-12T10:01). R365 food cost (F7) then
  misses those purchases, and those items count at $0.00.
- **Today:** the template was created by **R365 DSS User** and last modified by **R365** on 10/06/2026. CAMDEN SQUARE has a twin
  template with the same 207 items (`docs/research/store-audit-122.md` F5). So R365 support or the franchise may own it, and the
  owner's role may not be able to edit it. How store runs are recorded today is unknown.

## Who runs it

- The owner ticks the 45-line list: keep a line if the store still uses it (hub log 2026-10-12, this spec).
- Claude in Chrome on the owner's PC captures R365 screens read-only (owner signed in).
- Each later R365 change: the owner or Claude in Chrome, one owner OK per change. A request to R365 support or the franchise, if
  they own the template, comes from the owner.

## Done when (measurable)

1. **Tick list:** the owner has marked each of the 45 names "hide" or "keep". The names match the research exactly (no extras, no gaps).
2. **Who owns the template:** shown from R365 screens, with captures. Can the owner's role edit the CARY 1 template (remove an item,
   or mark it inactive for CARY 1 only)? Does a change there also change CAMDEN SQUARE? Could an R365 or brand push put a line back?
   Each answer is "seen" with a capture, or `(?)` with what is missing.
3. **Store runs:** the ways R365 offers to record a purchase that has no vendor invoice, as seen on screen for CARY 1 (for example
   a store-purchase vendor, an AP invoice typed by hand, expense or card receipts). Note whether any CARY 1 store-run purchase is
   already in R365. No option goes in the note unless it was seen on a screen.
4. A follow-up plan (count-sheet-122-02) can be written from the note without new research. That plan makes the change, or the
   owner sends a request to the template's owner.

## In scope

- P0: the owner's tick list for the 45; read-only captures of the CARY 1 template (detail, item list, edit controls, history if shown)
  and the item-at-location settings for 3 of the 45.
- P1: read-only captures of how R365 can record store-run purchases for CARY 1 (vendors list, AP entry form, any expense or
  receipt screen).

## Out of scope (parked on the hub)

- Any R365 change: removing or hiding a line, adding a vendor, entering a purchase. Those happen in count-sheet-122-02, one OK per change.
- The 31 slow movers and the 32 can't-tell lines staying on the sheet (they stay); $0.00 costs (later F2 fix); 878 / CAMDEN SQUARE's template.
- Collecting Costco or grocery receipts, or bank or card statements.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| The 45 names | `docs/research/count-lines-122.md` Item table, group "looks dead" | file | yes, 2026-10-11 |
| Template creator and modifier | R365 Inventory → Count templates | `docs/research/store-audit-122.md` F5 | yes, 2026-10-11 |
| Template edit rights, per-location hide | R365 count template detail; item → location settings | PC capture, read-only | `(?)` |
| Ways to record store-run buys | R365 Accounting (vendors, AP entry), any expense screen | PC capture, read-only | `(?)` |

## Owner rules that bind it

- Hide plan chosen; corporate ownership checked first; no R365 change without an OK per change (hub log 2026-10-12T10:00).
- The owner ticks the list before anything is hidden (owner, 2026-10-12, this session).
- Store runs are card or cash buys from Costco and grocery stores (hub log 2026-10-12T10:01). Read-only exports allowed (2026-10-10T16:02).
- CLAUDE.md project rule: R365 settings may be franchise-owned; research says who owns one before a plan changes it.

## Outcome (2026-10-12)

- count-sheet-122-02 closed with no build. Owner: leave the 44 ticked lines on the sheet for now (removal would need R365 support).
- Store runs parked: a bookkeeper records them in QuickBooks, so typing them into R365 could double count. The owner asks the bookkeeper first (hub log 2026-10-12T15:00–15:02).

## Open questions

- None blocking. The capture answers the ownership questions. The owner answers the tick list.
