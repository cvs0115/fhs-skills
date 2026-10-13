# Agent task · recipes-122-01 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/recipes-122-01.md`, to be run only after its plan review (`docs/reviews/recipes-122-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/recipes-122-01`
> and tell it "Do the task in docs/prompts/recipes-122-01.md". Start only after Ops has copied and unzipped `/root/fhs-skills/inbox/recipes-122.zip` into `/srv/fhs-build/reports/recipes-122-captures/`. Do not run `docs/prompts/recipes-122-01-capture.md`. No new capture.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) sells Toast items and modifiers that should
map to R365 recipes with a real cost. This task is verify-only F4: from PC captures only, list every
Cary 1 SAL-03 item×size×modifier row that sold in week **10/05–10/11/2026**, mark each mapped or
unmapped by exact name key (no POS code), and whether recipe **`AvgCost`** is present, `$0.00`, or
`(?)`. You never open a browser. Nothing in Toast or R365 is changed. A fix plan or support request
comes later from the note. Capture is already done.

## Where you work

- Workspace: `/srv/fhs-build/recipes-122-01`, your own clone of the repo. Work only here.
- Branch: create `feat/recipes-122-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- This job's captures (read only, outside the repo, already unzipped): `/srv/fhs-build/reports/recipes-122-captures/`.
  33 files: `pages.csv` plus `SAL-*`, `MNU-*`, `RCP-*`, `MAP-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports). `pages.csv` columns: time, URL, action = view/filter/scroll/export/close.
  Areas: `SAL` (Toast sales; **row source `SAL-03.csv`** product mix all levels, total line **$12,550.25** / **1,294** qty; `SAL-02.csv` item-level; `SAL-05.csv` Top Modifiers, 591 rows, cross-check not joined), `MNU` (`MNU-02.csv`, 64,693 rows: `Name, RecipeId, Recipe, EstimatedCost, …, MenuItemId, RecipeIsAssigned`), `RCP` (`RCP-02.csv`: `Cost` 0.00 on sampled rows; use **`AvgCost`**, also `MinCost` / `MaxCost`), `MAP` (`MAP-03` Point of sale items, 64,866 rows, screenshot/text only, not exported — cite it for where mapping lives).

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/recipes-122-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/recipes-122.md`
4. `docs/prompts/recipes-122-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/store-audit-122.md` F4 only (2,331 recipes, 64,670 menu items, visible Estimated Cost `$0.00`, Toast target "Firehouse Subs Group - 435 groups, 1 location"). Facts marked `(?)` stay unverified unless this capture shows them. F4 is expected size only, not this check's sold-row evidence. This capture's `MNU-02.csv` row count (64,693) supersedes 64,670 as the file size for this note.
6. `skills/fhs-skills/references/tech-stack.md` (R365 Recipes line: 400120 recipe `$1.1858` vs menu item `$0.00`; the Recipe filter can't select blank). Append lines later in the Toast and R365 parts of `## Store 122 audit (2026-10-11)`; do not treat those bullets as this check's sold-row or mapping evidence.

## Steps

1. `git switch feat/recipes-122-01` if that branch already exists, else `git switch -c feat/recipes-122-01`.
2. Confirm `/srv/fhs-build/reports/recipes-122-captures/` exists and contains `pages.csv`, `SAL-03.csv`, `MNU-02.csv`, `RCP-02.csv`, and `RCP-02.txt`. List this job's capture files. If any of those confirms fail, stop and write the report with that reason. `MAP-03` (png and/or txt) is expected; cite it for where mapping lives. `SAL-02.csv` and `SAL-05.csv` are expected (item-level and Top Modifiers cross-check). If `MAP-03` is missing, finish the note and use `(?)` for that fact.
3. **Hard rule: this job's capture folder and the two research files above only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Do not start a new PC capture. Do not recapture store-audit F4. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence. **Drop "POS code first". Do not join on POS code.** No POS code anywhere in the exports.
4. From those files only, write `docs/research/recipes-122.md`. Start with `# Research · recipes-122 · Cary 1 sold items: R365 recipe mapped or not, cost present or $0` and the date. Then:

   1. **`## Summary for the owner`** — plain words, **≤6 lines**: how many sold rows mapped vs unmapped, how many `no recipe needed`, how many mapped recipes are `$0.00` or `(?)`, and the share of week net sales on unmapped or `$0-cost` rows. Do not recommend a fix or a support request.

   2. **`## Sold items`** — one row for each SAL-03 **item×size×modifier** row with qty > 0 or net ≠ 0. Columns, in this order:

      | Type | Toast name | POS code | Qty | Net sales | R365 recipe | Recipe cost |

      - **Type** is exactly `item` or `modifier`. `modifier` when SAL-03 `Modifiers, special requests` is non-empty; otherwise `item`.
      - **Toast name** is the join key built from SAL-03 `Item, open item`, `Size modifier`, `Modifiers, special requests` as R365 `MNU-02.Name`: `<Item>-<Size>-<Modifier>` (e.g. `*HOOK & LADDER-Medium-MIXED PEPPERS`), `<Item>-<Modifier>` when there is no size (`*HOOK & LADDER SALAD-LITE CUCUMBERS`), and presumably `<Item>-<Size>` / `<Item>` `(?)`. Case and spaces as exported. Do not trim or rewrite.
      - **Qty** and **Net sales** come from that SAL-03 row. Omit the SAL-03 total line and any parent/subtotal row whose qty or net is already in a more detailed child row. Omit rows with qty 0 **and** net `$0.00` / `0`.
      - **POS code** is `not shown (SAL-03.csv)` on every row unless a capture file actually shows a POS-code column — this capture has none. Do not fill this cell from R365 (`MenuItemId`, `RecipeId`, or a six-digit suffix on a recipe name).
      - **R365 recipe** is `MNU-02.Recipe` on an **exact** `MNU-02.Name` match to the join key, `unmapped` if no exact Name match, or `(?) possible` if the key matches only after other changes (case, spaces, punctuation, order). No fuzzy match is mapped. Then `MNU-02.Recipe` must equal `RCP-02.Name` exactly to take **`AvgCost`**. A `mapped` row is one whose R365 recipe cell is a recipe name — not `unmapped`, not `(?) possible`.
      - **Recipe cost** is **`AvgCost`** from `RCP-02.csv` (present amount, `$0.00`, or `(?)`). Say in **How mapping works** that cost is `AvgCost`. Do not use `MNU-02.EstimatedCost` (0.0000 on every row) or `RCP-02.Cost` (0.00 on sampled rows) as recipe cost. Menu item `$0.00` with a recipe `AvgCost` is **not** `$0-cost`. For `unmapped` or `(?) possible`, write `n/a`.
      - `MI No Recipe Needed` stays that recipe name in the cell. Count those rows in **Totals** as `no recipe needed`, not as `$0-cost`, even if `AvgCost` is `$0.00`.
      - No empty cells. If a capture does not show a value, write `not shown (<file>)` in that cell (POS code uses the form above).
      - The week is **10/05–10/11/2026** (confirmed by capture; Toast net **$12,550.25** = R365). Fallback 09/28–10/04 unused. If the files show a different week, stop and write the report with that reason.

   3. **`## Totals`** — these metrics, each with a value (a table or labeled lines). The note must show both the table sums and the SAL-03 total line:

      | Metric | What it is |
      |---|---|
      | week | **10/05–10/11/2026** |
      | rows | sold-items data rows |
      | unmapped | rows whose R365 recipe is `unmapped` |
      | $0-cost | **mapped** rows whose recipe `AvgCost` is `$0.00`, excluding `no recipe needed` |
      | no recipe needed | rows whose R365 recipe is `MI No Recipe Needed` |
      | (?) possible | rows whose R365 recipe is `(?) possible` |
      | table qty / table net sales | sums of the Qty and Net sales columns |
      | export qty / export net sales | SAL-03 total line: **1,294** qty / **$12,550.25** |
      | week net sales | **$12,550.25** (the `%` denominator) |
      | % of week net sales on unmapped or $0-cost | that share; do not fold `(?) possible` or `no recipe needed` into this `%` |

      Table qty and table net sales must match the SAL-03 total line within `$1` / 1 qty. Tie-out uses the table rows (item×size×modifier, qty > 0 or net ≠ 0) against that total line.

   4. **`## How mapping works`** — start with which week, which SAL/MNU/RCP/MAP files, that join is the name-key rule (not POS code), and that recipe cost is **`AvgCost`**. State the join rule with **5 real examples** from this capture (include at least one `<Item>-<Size>-<Modifier>` and one `<Item>-<Modifier>`; mark `<Item>-<Size>` / `<Item>` `(?)` unless a real row confirms them). Note that `SAL-05.csv` is a cross-check, not joined (modifier name only, no item or size). Then answer each question with `seen` + capture file, or `(?)` + what is missing. Do not click and do not infer a click. F4 / tech-stack facts may be cited as expected size only; the answer itself must name a file in this job's captures folder (or `(?)`). Then:

      | Q | Answer | Capture |

      - **(a)** Where does POS-item → recipe mapping live? Cite **`MAP-03`**. Include any POS-item mapping, "unmapped", or sales-by-menu-item screen shown (`MAP-*`). Answer is `seen: <path or label exactly as written>` or `seen: not shown`, or `(?): <what's missing>`.
      - **(b)** Is the POS Toast or another POS? What does the menu item say its POS or location is? Answer is `seen: <the label exactly as written>` or `seen: not named`, or `(?): <what's missing>`.
      - **(c)** Why do menu items show Estimated Cost `$0.00` while recipes have a cost? Answer is `seen: <what the screens show>` (Estimated Cost vs `AvgCost`) or `(?): <what's missing>`.

   5. **`## Deviations`** — list the completed-capture misclick: the PC agent clicked **+ Create** on R365 Recipes, opened a blank RecipeItemForm, typed nothing, and closed it (`RCP-02.txt` line 10). It is not in `pages.csv`. Not a new allowed action. If `pages.csv` or other `*.txt` files show further Create / form / save / edit hits, list those too; do not hide them.

5. Match rows to files using the capture task's names (SAL/MNU/RCP/MAP) and `pages.csv`. Cite the real file name under this job's captures folder (e.g. `SAL-03.csv`, `MNU-02.csv`, `RCP-02.csv`, `MAP-03.txt`). Every `seen` cell must name a capture file that exists there. Every `mapped` row must have an exact `MNU-02.Name` match and `MNU-02.Recipe` = `RCP-02.Name` exactly. Typical paths (confirm from the files; unknown `(?)`):

   | Area | Where | Take from it |
   |---|---|---|
   | SAL | Toast Reports, product mix all levels; report name and path from the `SAL-*` `.txt`. Restaurant **00122 - Cary 1**. Week **10/05–10/11/2026** | `SAL-03.csv` sold item×size×modifier rows, qty, net sales, total line $12,550.25 / 1,294; `SAL-02.csv` item-level (not joined); `SAL-05.csv` Top Modifiers (cross-check, not joined) |
   | MNU | R365 Menu Items `/react/inventory/legacy/MenuItems` | `MNU-02.csv` Name (join target), Recipe, EstimatedCost (not recipe cost), RecipeIsAssigned, MenuItemId |
   | RCP | R365 Recipes `/react/inventory/recipe-items` | `RCP-02.csv` Name, **AvgCost** (recipe cost); `RCP-02.txt` line 10 Create / RecipeItemForm |
   | MAP | Point of sale items (`MAP-03`, text/screenshot only); other mapping / unmapped / sales-by-menu-item screens; menu-item / recipe detail (view, then Close) | where mapping lives (`MAP-03`); POS or location on the menu item; why Estimated Cost is `$0.00` |

   Do not copy sold-item rows from `docs/research/store-audit-122.md` or `tech-stack.md`. Verified audit facts you may use as expected size only: 2,331 recipes; 64,670 menu items (this file: 64,693); visible Estimated Cost `$0.00`; Toast Target Firehouse Subs Group, 435 groups, 1 location; recipe **400120** current cost `$1.1858` vs its menu item `$0.00`. If this capture does not show 400120, leave that pair unverified. Audit facts marked `(?)` stay unverified unless this capture shows them.

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (Toast and R365 facts): added lines only, the **Toast sales export path** (report name and/or URL from this capture, plus `SAL-03.csv`) and **where POS mapping lives** (`MAP-03`), each with a pointer to `docs/research/recipes-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the existing Recipes or Menu Items bullets (400120, 2,331, 64,670).

7. If this job's `pages.csv` has an action other than view/filter/scroll/export/close, or a URL whose path looks like save / submit / approve / complete / post / create / edit / map / delete / remove / inactivate / publish / update, record it in the report's deviations. Menu-item and recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close` are allowed. Toast report URLs are allowed as `view`, `filter`, or `export`. A `create` / `new` URL in `pages.csv` is never allowed (the RecipeItemForm open is only in `RCP-02.txt`, not `pages.csv`). Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/recipes-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/recipes-122-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/recipes-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Complete, Post, Import, Re-import, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, any status button, any menu or price change, or any toggle and checkbox that persists. No settings pages edited. Do not open Ad hoc report.
- Run `docs/prompts/recipes-122-01-capture.md` or start a new capture.
- Join on POS code, or count a fuzzy match as mapped. Use menu item Estimated Cost or `RCP-02.Cost` as recipe cost (use **`AvgCost`**). Fold `MI No Recipe Needed` into `$0-cost`. Include recipes that did not sell. Join `SAL-05.csv`. Audit store 878 / CAMDEN SQUARE (NCR). Reopen F2 item-cost problems or F7 food cost %. Touch payroll or `browser-02`. Write a checker script, a fix plan, or a support request.
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. This job's captures: `/srv/fhs-build/reports/recipes-122-captures`.

1. Headings `## Summary for the owner`, `## Sold items`, `## Totals`, `## How mapping works`, and `## Deviations` exist. Data rows under `## Sold items`: every row has 7 cells; none empty; every Type is `item` or `modifier`; every R365 recipe cell is a name, `unmapped`, or starts with `(?) possible`; every Recipe cost cell is an amount, `$0.00`, `(?)`, `n/a`, or `not shown (<file>)`. **How mapping works** states the join rule and has **5** real examples. Command: a `python3 -c` that prints `headings_ok=<0|1> rows=<n> empty_cells=<n> bad_type=<n> bad_recipe=<n> bad_cost=<n> examples=<n>`. Pass if `headings_ok == 1`, `rows >= 1`, `empty_cells == bad_type == bad_recipe == bad_cost == 0`, `examples == 5`.
2. Under `## Totals`, values exist for rows, unmapped, `$0-cost`, `no recipe needed`, `(?) possible`, table qty, table net sales, export qty, export net sales, week net sales, and `%` of week net sales on unmapped or `$0-cost`. Recompute unmapped / `$0-cost` / `no recipe needed` / `(?) possible` / table qty / table net sales from the sold-items table. `$0-cost` excludes `MI No Recipe Needed`. Export totals in the note are **1294** qty and **12550.25**. Print `rows_mismatch=<n> unmapped_mismatch=<n> zero_mismatch=<n> norecipe_mismatch=<n> possible_mismatch=<n> qty_delta=<n> sales_delta=<n> totals_ok=<0|1>`. Pass if every mismatch is 0, `qty_delta` and `sales_delta` vs the **stated export totals** are each `<= 1`, and `totals_ok == 1`.
3. Under `## How mapping works`, rows (a), (b), and (c) exist. (a)'s Capture names `MAP-03`. Every Answer that starts with `seen` names a capture file that exists in the captures folder (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> map03=<0|1> seen_missing_file=<n> empty_unknown=<n>`. Pass if `q_rows == 3`, `map03 == 1`, `seen_missing_file == empty_unknown == 0`.
4. This job's `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`, `close`; no URL path matching `save|submit|approve|complete|post|create|edit|map|delete|remove|inactivate|publish|update` (case-insensitive), except menu-item / recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close`. Toast report URLs are allowed as `view`, `filter`, or `export`. A `create` / `new` URL is never allowed. Print the unique actions and any matching URLs (allowed view/close exceptions listed separately).
5. Grep every capture `*.txt` for `Create` and `form/`. Must find **only** the one misclick note, closed without save: line 10 of `RCP-01.txt` and line 10 of `RCP-02.txt` (same note in both files, blank RecipeItemForm, typed nothing). It is not in `pages.csv`. `## Deviations` names that note. Print `create_hits=<n> rcp01_rcp02_line10=<0|1> deviations_ok=<0|1>`. Pass if `create_hits == 2`, `rcp01_rcp02_line10 == 1`, `deviations_ok == 1`. Extra hits: record in the report's deviations; this test fails (do not edit the captures).
6. After the commit: `git diff --name-only main...HEAD` → only `docs/research/recipes-122.md` and `skills/fhs-skills/references/tech-stack.md`
7. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
8. After the commit: `git status --short` → empty

## When done

1. Commit on `feat/recipes-122-01`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/recipes-122-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: recipes-122-01 · Branch: feat/recipes-122-01 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/8 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
