# Spec · store-migration · Move 878 Camden Square from NCR/Aloha to Toast + R365, and the store functions it depends on

2026-10-10 · Hub project: `projects/878-migration` · Plan page: none yet
Future skill: `fhs-store-migration` (a checklist that copies a store's finished setup to another store, plus the NCR-specific steps)

## Problem and today

- **Problem:** 878 runs on NCR/Aloha. Its payroll comes from downloaded NCR reports. It has no food cost, inventory, cash
  reconciliation or daily flash in R365. Moving it means rebuilding everything 122 has, and 122 itself is still missing most
  of the back-office functions (inventory, recipes, menu mapping, invoices, counts, food cost, cash and deposits, scheduling).
- **Today:** 122 is on Toast + R365, but R365 is used only for labor and tips (payroll). 878 is on NCR. Payroll runs for both from
  Windows. The R365 inventory audit for 122 is waiting for a server browser.

## Approach: build each function at 122, prove it, then copy it to 878

Each function below is built and proven at 122 first (per the `fhs-skills` playbook: "Store 122 first, then copy to 878").
The migration skill then replays the proven setup for 878, in one cutover, on a pay-period boundary.

## Function catalog (what each store needs)

| ID | Function | 122 today | 878 needs | Depends on | Existing hub project / skill |
|---|---|---|---|---|---|
| F0 | **Server browser** for agents (owner signs in) | none (Windows only) | same | — | browser-research-01 → browser build plan |
| F1 | **Store audit (R365 + Toast)**: for **every function F2–F13**, mark it in place, partial or missing, with evidence (a screen or report); plus licensed modules and who owns each setting (owner, franchise or R365) | not done | done for its CAMDEN SQUARE location | F0 | `r365-inventory` Phase 0 |
| F2 | **Items, units, vendors**: purchase/count units, conversions, GL categories | unknown (?) | copy from 122 | F1 | `r365-inventory` Phase 2 |
| F3 | **Electronic invoices**: distributor EDI or R365 email capture, invoice line → item mapping | unknown (?) | copy, plus its own vendor accounts | F1, F2 | `electronic-invoices` |
| F4 | **Recipes and menu mapping**: every Toast item/modifier → R365 recipe | unknown (?) | rebuild the Toast menu, reuse the recipes | F1, F2 | `r365-inventory` Phase 3 |
| F5 | **Inventory counts**: storage locations, count sheets in shelf order, weekly Sunday count | unknown (?) | copy the layout; opening count at go-live | F2 | `r365-inventory` Phase 4 |
| F6 | **Waste log** | unknown (?) | copy | F2 | `r365-inventory` Phase 5 |
| F7 | **Weekly food cost check**: COGS, food cost %, actual vs theoretical (AvT) | not possible yet | after 2–3 weeks of counts | F3, F4, F5 | `fhs-skills` food-cost-check → `fhs-food-cost` |
| F8 | **Cash and deposits**: Toast payments, cash drawer, bank deposits reconciled daily | not set up | new processor (Toast payments) at cutover | F0 | `cash-and-deposits` |
| F9 | **Daily flash**: sales, labor %, key numbers each morning | not set up | after cutover | F0 | `daily-flash` |
| F10 | **Labor and scheduling**: R365 scheduling, OT warning | not set up | copy | F1 | `r365-scheduling`, `labor-ot-warning` |
| F11 | **Tips automation** in R365 | ✅ working (payroll uses it) | add rules for 878 | — | `fhs-payroll-adp` |
| F12 | **Payroll from R365 reports** | ✅ working | switch at cutover (config `pos` ncr → toast_r365) | F11 | `fhs-payroll-adp` |
| F13 | **Delivery reconciliation**: DoorDash, Uber Eats, Grubhub, ezCater, first-party | not set up | repoint apps to Toast at cutover | F8 | `delivery-recon` (Wave 2) |
| M1 | **NCR history export** before access ends: sales, product mix, labor, tips | n/a | required | — | migration only |
| M2 | **Toast build for 878**: menu copy, prices, hardware, payments, online ordering, loyalty/gift cards | n/a | required | F4 | migration only |
| M3 | **Cutover**: pay-period-boundary go-live, opening count, overlap-day reconciliation, training, fallback | n/a | required | all above | migration only |

## Build order (owner decision, 2026-10-10)

The "122 today" column above is a starting guess. The F1 audit replaces it with evidence. A function the audit finds in place
gets a verify-only test plan (prove it on real data) instead of a build. Partial functions get a plan for the missing part only
(owner, 2026-10-10: "some of this may already be in place").


1. F0 server browser → 2. F1 R365 audit → 3. F2 items, units, vendors → 4. F3 electronic invoices → 5. F4 recipes and menu
mapping → 6. F5 counts (+ F6 waste) → 7. F8 cash and deposits → 8. F7 weekly food cost → 9. F9 daily flash →
10. F10 scheduling and OT → 11. F13 delivery reconciliation → 12. 878 migration (M1–M3), **after 122 is stable**: its
inventory, food cost and cash functions have all passed their test plans. Until then, 878 work is research only
(NCR contract, history export, the Aloha → R365 bridge question).

## Done when

1. Every F function in scope is live at 122 and has passed its test plan on real data (for example food cost within an agreed
   tolerance of the R365 COGS report for 3 weeks running).
2. 878 goes live on Toast + R365 on a Monday after a period-end Sunday, and its first payroll comes from R365 reports with no NCR mix.
3. 878's NCR history is exported and stored in its Dropbox store folder before NCR access ends.
4. 878's first weekly food cost check runs after its opening count plus 2 weekly counts.

## In scope

- P0: F0, F1, then the inventory foundation F2–F5, and F8 (cash and deposits).
- P1: F7, F9, F10, F6.
- P2: F13; then M1–M3 (878 migration) once 122 is stable.

## Out of scope (parked)

- Choosing the POS for 878: assumed Toast (franchise standard) `[NEEDS CLARIFICATION]`.
- Prime cost and P&L (Wave 3, after F7 and payroll data are combined).

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| What R365 has set up (122, CAMDEN SQUARE) | R365 | server browser, owner signed in | no → F1 audit |
| Toast menu, payments, deposits (122) | Toast | server browser / reports | partly (labor and tips via payroll) |
| NCR sales, labor, tips history (878) | NCR / Aloha | owner downloads | payroll reports only |
| Aloha → R365 integration (an interim bridge for 878) | R365 docs / support | research | no → `(?)` |
| Pay periods | `shared/config.json` (`pay_period_anchor` 2026-09-21, biweekly Monday–Sunday) | config | yes |

## Owner rules that bind it

- Store 122 first, then copy to 878 (`skills/fhs-skills/SKILL.md`, 2026-10-08).
- One yes per live change in Toast, R365 or ADP. Never click anything that moves money or submits to a vendor.
- Franchise-owned settings: ask before changing anything that looks corporate-managed (CLAUDE.md project rule).
- 2026-10-10: R365 inventory/food cost is the first framework project, ahead of the 10/9 waves.

## Open questions (hub `questions/`)

- [NEEDS CLARIFICATION] Does the franchise require Toast for 878, and is there a target cutover date?
- [NEEDS CLARIFICATION] When does the NCR contract end, and how long does data access last after cancellation?
- [NEEDS CLARIFICATION] Should we research an interim Aloha → R365 sales and labor feed, so 878 gets food cost before the POS swap?
- Existing: main distributor and invoice method (q1); current counting (q2); food only or also paper and chemicals (q3);
  corporate recipes and items (q4); target food cost % (q5).
