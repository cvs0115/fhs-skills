# Plan · recipes-122-01 · Cary 1 items sold last week → R365 recipe mapped or not, cost present or $0

Drafted by Cursor Grok 4.6 High from docs/briefs/recipes-122-01.md.

2026-10-12. Plan only, not approved. Don't build from it until `docs/reviews/recipes-122-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/recipes-122-01.md`, its capture task `docs/prompts/recipes-122-01-capture.md` (record of the completed capture; no new capture), and its test plan `docs/tests/recipes-122-01.md` together.
Don't add scope. This redraft binds the brief's 2026-10-12 capture addendum. Earlier review `docs/reviews/recipes-122-01-r1.md` is history of the pre-addendum plan.

- Hub project: `projects/r365-inventory` (F4, verify-only) · Phase: plan page https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK · Spec: `docs/specs/recipes-122.md` · Decisions that bind it: 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 and 17:30 PC jobs run in Claude Code + Claude in Chrome; 2026-10-12T10:00 no R365 change without an OK per change; 2026-10-12 assumption: week 10/05–10/11/2026 (confirmed by capture; fallback 09/28–10/04 unused)
- Research to rely on: `docs/research/store-audit-122.md` F4 (2,331 recipes, 64,670 menu items, $0.00 Estimated Cost, Toast target "Firehouse Subs Group - 435 groups, 1 location"); `skills/fhs-skills/references/tech-stack.md` R365 Recipes line (400120 recipe $1.1858 vs menu item $0.00; the Recipe filter can't select blank). Capture facts below supersede the old "POS code first" join. Facts marked `(?)` stay unverified unless this capture shows them.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: inbox zip (capture already done)

Capture already ran. Do not start a new PC capture. Do not run `docs/prompts/recipes-122-01-capture.md`. The zip is `/root/fhs-skills/inbox/recipes-122.zip` (33 files, week **10/05–10/11/2026**, R365 days Completed; Toast net **$12,550.25** = R365). Capture files are unchanged; no new capture. The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped that zip into `/srv/fhs-build/reports/recipes-122-captures/`. `browser-02` stays parked.

## Verdict

No build (verify-only). Research note and `tech-stack.md` lines only — no skill, no script, no Toast or R365 change, no new capture. A fix plan or support request comes later from the note.

## What changes, in plain words

Capture on your PC is done: last week's Toast sales for Cary 1 (Mon 10/05–Sun 10/11, net $12,550.25) and R365's menu-item and recipe lists, view only. A note on the server lists every sold item and modifier: mapped to an R365 recipe or unmapped, and whether that recipe has a real cost or $0. Nothing in Toast or R365 is changed.

## Files the researcher may edit (in its clone)

- `docs/research/recipes-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the Toast and R365 sections (`## Store 122 audit (2026-10-11)` / those inventory facts): the sales export path, and where POS mapping lives. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/recipes-122-01.md` (report)

Captures live outside the repo and are not edited by the researcher: already sent to `/root/fhs-skills/inbox/recipes-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/recipes-122-captures/`. PC folder `C:\fhs\reports\recipes-122\` is the completed capture, not a new run. Tester report: `/srv/fhs-build/reports/recipes-122-01-test.md`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

Toast and R365, **read-only**, on the owner's PC, owner signed in — **already done**. Remaining steps (Ops unzip, Researcher, Tester, diff review) do not touch Toast or R365. No new capture.

Allowed and forbidden actions as `count-sheet-122-01`, plus the recipes-only extras below (the record of the completed capture; not a new run):

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text. Open a detail page to read it, then Close.
- **Forbidden:** Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Complete, Post, Import, Re-import, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, any status button, any menu or price change, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. Do not open Ad hoc report (it needs a save).
- **Exports** (download a CSV or PDF of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\recipes-122\` with the other captures. An export never changes data.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

Four capture areas (record only), listed in `docs/prompts/recipes-122-01-capture.md` with file names:

1. `SAL-*` — Toast sales by item and by modifier option for restaurant **00122 - Cary 1**, week **10/05–10/11/2026**, plus the week's net sales total. Report name and path as seen.
2. `MNU-*` — R365 Menu Items `/react/inventory/legacy/MenuItems`. `MNU-02.csv` (64,693 rows) columns include `Name, RecipeId, Recipe, EstimatedCost, …, MenuItemId, RecipeIsAssigned`.
3. `RCP-*` — R365 Recipes `/react/inventory/recipe-items`. `RCP-02.csv` has `Cost` (0.00 on sampled rows) and `AvgCost` / `MinCost` / `MaxCost`.
4. `MAP-*` — POS-item mapping / unmapped / sales-by-menu-item screens. `MAP-03` (Point of sale items, 64,866 rows) is screenshot/text only, not exported; cite it for "where mapping lives".

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (header exactly `time,URL,action`; action = view / filter / scroll / export / close). Menu-item and recipe detail pages are allowed as **view** only and must be closed with Close.

**Join (Researcher, after unzip). Drop "POS code first". No POS code anywhere in the exports.** R365 menu-item names are Toast names joined by `-`: `<Item>-<Size>-<Modifier>` (e.g. `*HOOK & LADDER-Medium-MIXED PEPPERS`), `<Item>-<Modifier>` when there is no size (`*HOOK & LADDER SALAD-LITE CUCUMBERS`), and presumably `<Item>-<Size>` / `<Item>` `(?)`. Build the key from `SAL-03.csv` columns (`Item, open item`, `Size modifier`, `Modifiers, special requests`) as that pattern and match `MNU-02.Name` exactly (case and spaces as exported). Then `MNU-02.Recipe` = `RCP-02.Name` exactly. The note states the rule with 5 real examples. A key that matches only after other changes is `(?) possible`, not mapped. No fuzzy matches counted as mapped.

**Sold rows:** `SAL-03.csv` (product mix, all levels) is the row source; its total line ties to $12,550.25 / 1,294 qty. `SAL-05.csv` (Top Modifiers, 591 rows, by modifier name only) is a cross-check, not joined (it has no item or size). `SAL-02.csv` is item-level. Table rows are the SAL-03 item×size×modifier rows that have qty > 0 or net ≠ 0; the tie-out uses those rows.

**Recipe cost:** use **`AvgCost`** and say so. `MNU-02.EstimatedCost` (0.0000 on every row) is not recipe cost. `MI No Recipe Needed` is its own class: count it in `## Totals` as `no recipe needed`, separately from `$0-cost`.

**Deviation (already happened):** the PC agent misclicked **+ Create** on R365 Recipes, opened a blank RecipeItemForm, typed nothing and closed it (`RCP-02.txt` line 10). It is not in `pages.csv`. The note lists it under `## Deviations`. Not a new allowed action.

## Owner steps

None for capture (already sent). After merge, the owner confirms nothing changed in Toast or R365 (post-merge cases, not a merge gate): recipe 400120 still **$1.1858** or its later system cost; no new mapping; R365 Recipes still shows **2,331** (no new blank recipe).

## Done-check (real outcome)

1. `## Sold items` table: Type (item/modifier), Toast name, POS code if shown, qty, net sales, R365 recipe or `unmapped`, recipe cost (`AvgCost`). Row qty and net sales sum to the Toast export totals for the week (within $1); the note shows both sums. Tie-out is the SAL-03 item×size×modifier rows with qty > 0 or net ≠ 0 against the SAL-03 total line ($12,550.25 / 1,294 qty).
2. `## Totals`: rows, unmapped, $0-cost, `no recipe needed`, `(?) possible`, and the % of week net sales on unmapped or $0-cost rows.
3. `## How mapping works`: each fact `seen` + capture, or `(?)` + what is missing (where mapping lives — cite `MAP-03`; Toast or other POS; why menu items show $0.00 while recipes have cost). The join rule with 5 real examples.
4. `## Deviations`: the + Create / blank RecipeItemForm open, typed nothing, closed (`RCP-02.txt` line 10); not in `pages.csv`.
5. Plain-words summary for the owner, ≤6 lines.

## Where it runs

- **Capture:** already done on the owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps used: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Files under `C:\fhs\reports\recipes-122\`, zipped and sent with `send-report.ps1` to `/root/fhs-skills/inbox/recipes-122.zip`. No new desktop run. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK).
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files plus `docs/research/store-audit-122.md` F4 only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture already ran read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/recipes-122-01` via `scripts/build.sh prepare docs/plans/recipes-122-01.md recipes-122-01 --role research`. `prepare` clones `main` at the commit that holds this plan, its task file, the capture task (`docs/prompts/recipes-122-01-capture.md`, kept as the record), the test plan and the APPROVE review; the researcher creates `feat/recipes-122-01` in that clone per the task. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/recipes-122.zip` into `/srv/fhs-build/reports/recipes-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/recipes-122-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/recipes-122-01.md`, `docs/prompts/recipes-122-01-capture.md` (record only), `docs/tests/recipes-122-01.md` and that review to `main` before prepare.
2. Capture is complete. Do not run a new capture. Zip: `/root/fhs-skills/inbox/recipes-122.zip`.
3. `build.sh prepare docs/plans/recipes-122-01.md recipes-122-01 --role research`.
4. **Ops copies the inbox zip into `/srv/fhs-build/reports/recipes-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
5. The Researcher (Cursor Grok 4.6 High) writes the note from those files plus `docs/research/store-audit-122.md` F4; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them. Join by the name pattern above; do not join on POS code.
6. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
7. `build.sh collect recipes-122-01 --role research`.
8. `review.sh --diff feat/recipes-122-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/recipes-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Sum of table qty and net sales = Toast export totals (within $1), recomputed by the tester from `SAL-03.csv` (item×size×modifier rows with qty > 0 or net ≠ 0 vs the total line $12,550.25 / 1,294 qty). The note shows both sums.
- 10 random table rows checked against the R365 exports: mapping and cost match (`AvgCost`). Every `mapped` row has an exact `MNU-02.Name` match and `MNU-02.Recipe` = `RCP-02.Name` exactly. No fuzzy match counted as mapped.
- Each `## How mapping works` answer cites a capture file that exists; each `(?)` names what is missing. `MAP-03` is cited for where mapping lives.
- `pages.csv`: only view/filter/scroll/export/close actions; no save/create/edit/map/update-costs/publish/delete click or URL.
- T5 also greps every `*.txt` for `Create`/`form/` and must find exactly this one, closed without save: `RCP-02.txt` line 10 (blank RecipeItemForm, typed nothing). It is not in `pages.csv`.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Post-merge (owner): nothing changed in Toast or R365 (recipe 400120 still $1.1858 or its later system cost; no new mapping; R365 Recipes still **2,331**, no new blank recipe).

Researcher and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in Toast, R365 and ADP. No mapping, recipe edit, cost update ("Update recipe costs" is not clicked), menu edit, or price change. Store 878 / CAMDEN SQUARE (NCR), recipes that did not sell, the F2 item cost problems, and food cost % (F7) stay out of scope. Franchise-owned settings are not edited. Payroll is unchanged. `browser-02` stays parked. The Windows mirror is unchanged. Capture files and the inbox zip are unchanged (no new capture). A fix plan or support request is a later plan, each with the owner's OK.
