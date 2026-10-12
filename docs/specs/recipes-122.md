# Spec · recipes-122 · Does every item Cary 1 sold last week have an R365 recipe with a cost?

2026-10-12 · Hub project: `projects/r365-inventory` (F4, verify-only) · Plan page: https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK

## Problem and today

- **Problem:** R365 food cost (F7, actual vs theoretical) needs every Toast item and modifier that sold to map to an R365 recipe
  with a real cost. A sold item with no recipe, or a recipe at $0.00, makes theoretical food cost too low.
- **Today:** recipes and menu mapping look brand-supplied (`docs/research/store-audit-122.md` F4, owner franchise). R365 has 2,331
  recipes and 64,670 menu items (the whole list, not Cary 1). Visible menu items had a recipe but Estimated Cost **$0.00**. One check
  (6" Turkey & Ham, 400120) found the recipe at **$1.1858** while its menu item showed $0.00 (`tech-stack.md`). No one has checked
  the items Cary 1 actually sells. An "unmapped with sales" view was not found `(?)`.

## Who runs it

- Claude in Chrome on the owner's PC exports and captures, read-only, owner signed in to Toast and R365.
- The Researcher (Grok) joins the exports on the server and writes the note. The owner reads a plain-words summary.

## Done when (measurable)

1. A table of every Toast item and modifier option with sales at 122 Cary 1 in one complete week, with qty sold and net sales, each
   marked **mapped** (R365 recipe name) or **unmapped**, and for mapped ones the R365 recipe cost (or `$0.00`, or `(?)`).
2. Totals: rows, unmapped count, $0-cost count, and the share of the week's net sales on unmapped or $0-cost rows.
3. The table's qty and net sales add up to the Toast export's totals for the week (within $1).
4. Each "how R365 maps POS items" fact (where the mapping lives, Toast vs other POS, why the menu item shows $0.00) is `seen` with a
   capture or `(?)`.
5. A fix plan (or a support request, if the franchise owns it) can be written from the note without new research.

## In scope

- P0: Toast sales by item and by modifier for Cary 1 for the week (export); R365 menu-item → recipe mapping and recipe cost for
  those names (export or capture).
- P1: R365's own unmapped/POS-item view or sales-by-menu-item report, if one exists, as a cross-check.

## Out of scope (parked on the hub)

- Any change in Toast or R365: mapping, recipe edits, cost updates ("Update recipe costs" is not clicked), menu edits.
- 878 / CAMDEN SQUARE (NCR); recipes that did not sell; the F2 item cost problems (sent to R365 support, row 16); food cost % (F7).

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Items and modifiers sold, qty, net sales | Toast Reports (product mix / item and modifier selection) | PC export, read-only | `(?)` report name and export |
| POS item → R365 recipe | R365 Menu Items, `/react/inventory/legacy/MenuItems` | PC export or filtered capture | grid seen 2026-10-11; export `(?)` |
| Recipe cost | R365 Recipes, `/react/inventory/recipe-items` | PC export | grid seen; export `(?)` |
| Unmapped or sales-by-menu-item view | R365 | PC capture | not found `(?)` |

## Owner rules that bind it

- Read-only exports allowed (hub log 2026-10-10T16:02). PC jobs run in Claude Code + Claude in Chrome (2026-10-10T17:01, 17:30).
- No change in R365 or Toast without an OK per change (2026-10-12T10:00). CLAUDE.md: franchise-owned settings get research first.

## Open questions

- None blocking. Which week: the last complete Mon–Sun week (10/05–10/11/2026). If R365 sales for it are not posted yet, use
  09/28–10/04/2026 (the 10/04 count week) and say which. (Assumption, logged.)
