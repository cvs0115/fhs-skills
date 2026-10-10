# Playbook: R365 inventory, recipes, AP and food cost (store 122 first)

Work one phase at a time. Each phase ends with a check; record the result in `state/setup-tracker.md`.
R365 menu names below are typical. Write down the real paths you find in tech-stack.md.

## Phase 0 - Audit (read-only)
Goal: find out what exists before building anything. The owner signs in to R365 in the browser pane.
Check and record:
- Modules visible (Operations / Inventory / Recipes / Purchasing / AP / Accounting / Scheduling) and
  which ones the owner's role can edit.
- **Items** (purchased items): how many, are they corporate-provided, do they have units of measure and costs?
- **Vendors**: which exist; any with EDI/integration turned on.
- **AP invoices**: any in the last 60 days? How do they arrive (EDI, email capture, manual)?
- **Recipes / menu items**: do recipes exist; is there a POS menu item mapping page; how many Toast
  items are unmapped?
- **Inventory count templates / storage locations**: any? Any past counts?
- **POS integration**: Toast → R365 sales import running daily for CARY 1? Last import date?
- **Reports available**: Actual vs Theoretical, Theoretical Food Cost, Product Mix, COGS / P&L.
Deliverable: a short audit summary for the owner (what's there, what's missing, who likely owns it
- owner vs franchise vs R365 support). Update tech-stack.md.

## Phase 1 - Vendors and invoices
- Confirm the main distributor(s) and other vendors (bread/produce/beverage, paper, chemicals).
- Electronic invoices: distributor EDI to R365 if offered (request usually goes through R365 support
  + distributor rep), otherwise R365 invoice email capture. The owner makes those requests; draft the
  email/text for them.
- Map invoice lines to R365 items (purchase unit = case; check cost per case is right).
Check: last 2 weeks of invoices in R365, totals match the paper/PDF invoices.

## Phase 2 - Items and units
- Each item: purchase unit (case), count unit (lb / each / bag), inventory unit, conversions
  (e.g. 1 case turkey = 4 x 5 lb). Wrong conversions are the #1 cause of crazy counts.
- Categories / GL accounts: Food, Paper, Beverage, Chemicals/Cleaning, Smallwares - so food cost
  and "other consumption" are reported separately.
Check: spot-check 10 high-dollar items (meats, cheese, bread, drinks): case cost / conversion = sensible per-unit cost.

## Phase 3 - Recipes and menu mapping
- Use corporate recipes if provided (portion specs from the Firehouse build charts); otherwise build
  recipes for top sellers first (top 20 items ≈ 80% of sales - get from Toast product mix).
- Include modifiers (extra meat, cheese, size) and packaging (wrap, cup, lid, bag) if they should count.
- Map every Toast menu item / modifier to a recipe. Target: 0 unmapped items with sales.
Check: Theoretical food cost % for the last week looks plausible (typically high-20s-low-30s % for
subs - confirm the franchise benchmark with the owner).

## Phase 4 - Counts
- Storage locations in walking order: Walk-in → Freezer → Dry storage → Line → Front/Beverage.
- Count template per location, ordered by shelf. Weekly count Sunday after close.
  High-dollar items optionally daily.
- Use the R365 mobile app for counts (owner/manager installs it; they sign in).
- First count = baseline (opening inventory).
Check: count posts without errors; total inventory $ is plausible for the store.

## Phase 5 - Waste log
- Simple: manager logs waste in R365 (or Toast waste/void reasons if that's better). Categories:
  expired, dropped, wrong order, comps/employee meals.
Check: one week of waste entries.

## Phase 6 - Go live and review
- Run 2-3 weekly cycles before trusting the numbers. Each Monday: COGS, food cost %, AvT by item.
- Investigate the biggest AvT gaps with the owner: often a mapping or unit mistake, not theft.
- When stable → mark "inventory live" in the tracker; turn on the weekly food-cost check.

## Later
- Par levels + suggested orders (par − on hand), order guide by vendor.
- Prime cost (food + labor) using payroll data.
- Copy the whole setup to 878 when it moves to Toast/R365 (until then: invoices + weekly count in a
  spreadsheet for basic COGS).
