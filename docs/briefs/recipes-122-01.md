# Brief · recipes-122-01 · Cary 1 items sold last week → R365 recipe mapped or not, cost present or $0

2026-10-12. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/recipes-122-01.md` (form `docs/templates/plan.md`), `docs/prompts/recipes-122-01.md` (Researcher),
`docs/prompts/recipes-122-01-capture.md` (PC capture) and `docs/tests/recipes-122-01.md`. Don't add scope.

- Spec: `docs/specs/recipes-122.md` · Hub project: `projects/r365-inventory` · Binding decisions (hub log):
  2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 and 17:30 PC jobs run in Claude Code + Claude in Chrome;
  2026-10-12T10:00 no R365 change without an OK per change; 2026-10-12 assumption: week 10/05–10/11/2026 (fallback 09/28–10/04)
- Research to rely on: `docs/research/store-audit-122.md` F4 (2,331 recipes, 64,670 menu items, $0.00 Estimated Cost, Toast target
  "Firehouse Subs Group - 435 groups, 1 location"); `skills/fhs-skills/references/tech-stack.md` R365 Recipes line (400120 recipe
  $1.1858 vs menu item $0.00; the Recipe filter can't select blank). Copy the capture → inbox → Ops unzip → Researcher → Tester shape,
  `pages.csv` page log and forbidden-action list from `docs/plans/count-sheet-122-01.md`.

## Problem and decision (3–5 lines)

Verify-only, no build, no Toast or R365 change. A fix plan or support request comes later from the note. Steps:
1. **PC capture, Toast:** export sales by item and by modifier option for restaurant 00122 - Cary 1 for the week (CSV/XLSX; product
   mix or item/modifier selection details; record the report name and path seen). Also capture the week's net sales total.
2. **PC capture, R365:** export Menu Items (`/react/inventory/legacy/MenuItems`) and Recipes (`/react/inventory/recipe-items`) with
   name, POS id/code, recipe, cost columns. If the full export is too big, filter by the sold names instead. Capture any POS-item
   mapping, "unmapped", or sales-by-menu-item screen R365 shows, plus what the menu item says its POS or location is.
3. **Server, Researcher:** join sold rows to R365 by POS code first (the six-digit number, e.g. 400120), then exact name. Mark each
   mapped/unmapped, recipe cost present/$0.00/`(?)`. No fuzzy matches counted as mapped; list them as `(?) possible`.

## Files the builder may edit / must not edit

- may (Researcher, in its clone): `docs/research/recipes-122.md` (new); `skills/fhs-skills/references/tech-stack.md` (added lines only,
  Toast and R365 sections: the sales export path, where POS mapping lives)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any other file under `skills/`, any other `docs/` file

## Live systems touched

Toast and R365, **read-only**, on the owner's PC, owner signed in. Allowed: view, filter, scroll, export/download, opening a detail page
to read it then Close. Forbidden: Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, any status button, any menu or
price change. A login or MFA prompt means stop and ask the owner.

## Done-check (real outcome)

1. `## Sold items` table: Type (item/modifier), Toast name, POS code if shown, qty, net sales, R365 recipe or `unmapped`, recipe cost.
   Row qty and net sales sum to the Toast export totals for the week (within $1); the note shows both sums.
2. `## Totals`: rows, unmapped, $0-cost, `(?) possible`, and the % of week net sales on unmapped or $0-cost rows.
3. `## How mapping works`: each fact `seen` + capture, or `(?)` + what is missing (where mapping lives; Toast or other POS;
   why menu items show $0.00 while recipes have cost).
4. Plain-words summary for the owner, ≤6 lines.

## Where it runs and which tree is live

Capture: owner's Windows PC (Claude Code + Claude in Chrome), from `C:\fhs\fhs-skills`, files under `C:\fhs\reports\recipes-122\`,
zipped and sent with `send-report.ps1` to `/root/fhs-skills/inbox/recipes-122.zip`. Ops unzips to
`/srv/fhs-build/reports/recipes-122-captures/`. Note, tests and review run on the server. Served tree `/root/fhs-skills` on `main`: on
merge only the note and the `tech-stack.md` lines become visible. Windows mirror unchanged. Gate before capture: owner signed in to
Toast and R365 in Chrome on the PC.

## Tests the test plan must include

- Sum of table qty and net sales = Toast export totals (within $1), recomputed by the tester from the export file.
- 10 random table rows checked against the R365 exports: mapping and cost match. Every `mapped` row has an exact code or name match.
- Each `## How mapping works` answer cites a capture file that exists; each `(?)` names what is missing.
- `pages.csv`: only view/filter/scroll/export/close actions; no save/create/edit/map/update-costs/publish/delete click or URL.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines.
- Post-merge (owner): nothing changed in Toast or R365 (recipe 400120 still $1.1858 or its later system cost; no new mapping).

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## Addendum after the capture (2026-10-12, Claude): binding on the redraft

The capture is in `inbox/recipes-122.zip` (33 files, week **10/05–10/11/2026**, R365 days Completed; Toast net $12,550.25 = R365).
Facts from the export headers that change steps 3 and the tests (capture file unchanged, no new capture):
1. **No POS code anywhere.** `MNU-02.csv` (64,693 rows) has `Name, RecipeId, Recipe, EstimatedCost, …, MenuItemId, RecipeIsAssigned`.
   R365 menu-item names are Toast names joined by `-`: `<Item>-<Size>-<Modifier>` (e.g. `*HOOK & LADDER-Medium-MIXED PEPPERS`),
   `<Item>-<Modifier>` when there is no size (`*HOOK & LADDER SALAD-LITE CUCUMBERS`), and presumably `<Item>-<Size>` / `<Item>` `(?)`.
   **Join rule:** build the key from `SAL-03.csv` columns (`Item, open item`, `Size modifier`, `Modifiers, special requests`) as that
   pattern and match `MNU-02.Name` exactly (case and spaces as exported). Then `MNU-02.Recipe` = `RCP-02.Name` exactly. The note states
   the rule with 5 real examples. A key that matches only after other changes is `(?) possible`, not mapped. Drop "POS code first".
2. **Sold rows:** `SAL-03.csv` (product mix, all levels) is the row source; its total line ties to $12,550.25 / 1,294 qty. `SAL-05.csv`
   (Top Modifiers, 591 rows, by modifier name only) is a cross-check, not joined (it has no item or size). `SAL-02.csv` is item-level.
   Table rows are the SAL-03 item×size×modifier rows that have qty > 0 or net ≠ 0; the tie-out uses those rows.
3. **Recipe cost column:** `RCP-02.csv` has `Cost` (0.00 on sampled rows) and `AvgCost` / `MinCost` / `MaxCost` (e.g. 7.9950).
   Use **`AvgCost`** as recipe cost and say so. `MNU-02.EstimatedCost` (0.0000 on every row) is not recipe cost. `MI No Recipe Needed`
   is its own class: count it in `## Totals` as `no recipe needed`, separately from `$0-cost`.
4. **`MAP-03`** (Point of sale items, 64,866 rows) is a screenshot/text only, not exported; cite it for "where mapping lives".
5. **Deviation:** the PC agent misclicked **+ Create** on R365 Recipes, opened a blank RecipeItemForm, typed nothing and closed it
   (`RCP-02.txt` line 10). It is not in `pages.csv`. The note lists it under `## Deviations`; T5 also greps every `*.txt` for
   `Create`/`form/` and must find exactly this one, closed without save. Post-merge P1 adds: R365 Recipes still shows **2,331**
   (no new blank recipe).
