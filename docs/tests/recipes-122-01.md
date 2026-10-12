# Test plan · recipes-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/recipes-122-01.md".

## What's being tested

The research note lists every Cary 1 SAL-03 item×size×modifier row that sold in week **10/05–10/11/2026**, each mapped or unmapped (or `(?) possible`) by exact `MNU-02.Name` key (no POS code), with recipe cost as **`AvgCost`** present, `$0.00`, or `(?)`. `MI No Recipe Needed` is counted separately from `$0-cost`. Table qty and net sales match the SAL-03 total line (**1,294** qty / **$12,550.25**) within $1, recomputed from `SAL-03.csv`. Ten random table rows match the R365 exports on mapping and `AvgCost`, and every `mapped` row has an exact `MNU-02.Name` match and `MNU-02.Recipe` = `RCP-02.Name`. Each `## How mapping works` answer cites a capture that exists (`MAP-03` for where mapping lives), or `(?)` names what is missing. `pages.csv` has only view/filter/scroll/export/close. Capture `*.txt` files show exactly one Create / `form/` hit: `RCP-02.txt` line 10, closed without save, listed under `## Deviations`. `tech-stack.md` only gained lines. Post-merge (not a gate): nothing in Toast or R365 changed (recipe 400120 still $1.1858 or its later system cost; no new mapping; Recipes still **2,331**).
Plan: `docs/plans/recipes-122-01.md` · Researcher report: `/srv/fhs-build/reports/recipes-122-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/recipes-122-01` on branch `feat/recipes-122-01`, as `fhsbuild` | read the note, `tech-stack.md`, and this job's captures; run commands; edit nothing in the repo |
| browser-server | not used | tester reads captures only; never open R365, Toast, or ADP |
| browser-windows | not used | same; `browser-02` stays parked; no new capture |
| owner | the owner answers | write down exactly what they report |

No browser cases for the tester. Check the clone and `/srv/fhs-build/reports/recipes-122-captures/` only. Never open R365, Toast, or ADP.

Browser rules: N/A. Do not open a browser or R365.

## Preconditions

- Researcher report `/srv/fhs-build/reports/recipes-122-01.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/recipes-122-captures/` and include `pages.csv`, `SAL-03.csv`, `MNU-02.csv`, `RCP-02.csv`, and `RCP-02.txt`. If that folder is missing, empty, or has no `pages.csv`, mark T2–T5 BLOCKED (captures missing). If no `SAL-03.csv`, mark T2 BLOCKED. If no `MNU-02.csv` or no `RCP-02.csv`, mark T3 BLOCKED. If no `RCP-02.txt`, mark T5 BLOCKED.
- `MAP-03` (png and/or txt) is expected; cite it for where mapping lives. If it is missing, do not BLOCK T4; the note should use `(?)` for that fact (T4 still requires (a) to name `MAP-03`). `SAL-02.csv` and `SAL-05.csv` are expected (item-level and Top Modifiers cross-check, not joined).
- You are in `/srv/fhs-build/recipes-122-01` on `feat/recipes-122-01` as `fhsbuild`. Do not run `docs/prompts/recipes-122-01-capture.md`. Do not recapture store-audit F4. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence. Do not join on POS code.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/recipes-122.md`. Headings `## Summary for the owner`, `## Sold items`, `## Totals`, `## How mapping works`, and `## Deviations` must exist. Count non-blank lines under `## Summary for the owner` until the next `## `. Take pipe-rows between `## Sold items` and the next `## `, skip the header and `\|---` separator (**7 cells** per data row: Type, Toast name, POS code, Qty, Net sales, R365 recipe, Recipe cost). Under `## How mapping works`, count **5** real join-rule examples. Print `headings_ok=<0\|1> summary_lines=<n> rows=<n> empty_cells=<n> bad_type=<n> bad_recipe=<n> bad_cost=<n> examples=<n> rows_mismatch=<n> unmapped_mismatch=<n> zero_mismatch=<n> norecipe_mismatch=<n> possible_mismatch=<n> qty_delta=<n> sales_delta=<n> pct_ok=<0\|1> totals_ok=<0\|1>`. `empty_cells` = blank or missing cells. `bad_type` = Type not exactly `item` or `modifier`. `bad_recipe` = R365 recipe not a name, not `unmapped`, and not starting with `(?) possible`. `bad_cost` = Recipe cost not an amount, `$0.00`, `(?)`, `n/a`, or `not shown (<file>)`; also `n/a` on a mapped row, or a dollar amount on `unmapped` / `(?) possible`. A mapped row is one whose R365 recipe cell is a recipe name — not `unmapped`, not `(?) possible`. Recompute unmapped / `$0-cost` / `no recipe needed` / `(?) possible` / table qty / table net sales from the table. `$0-cost` = **mapped** rows whose recipe cost is `$0.00`, **excluding** `MI No Recipe Needed`. `no recipe needed` = rows whose R365 recipe is `MI No Recipe Needed`. Compare those to `## Totals`. `qty_delta` / `sales_delta` are \|table − stated export totals\|. Stated export totals in the note must be **1294** qty and **12550.25**. `%` of week net sales on unmapped or `$0-cost` must equal (net sales of those rows) / week net sales (**$12,550.25**); do not fold `(?) possible` or `no recipe needed` into that `%`. Totals must include week, rows, unmapped, `$0-cost`, `no recipe needed`, `(?) possible`, table qty, table net sales, export qty, export net sales, week net sales, and that `%`. Week is **10/05–10/11/2026** (fallback 09/28–10/04 unused) | `headings_ok=1 summary_lines<=6 rows>=1 empty_cells=bad_type=bad_recipe=bad_cost=0 examples=5` every mismatch `0`, `qty_delta` and `sales_delta` each `<= 1`, `pct_ok=1 totals_ok=1` | command + trimmed output; any bad row or totals that do not tie |
| T2 | shell | From `/srv/fhs-build/reports/recipes-122-captures/SAL-03.csv` only (not `SAL-02.csv` or `SAL-05.csv`), recompute qty and net sales from the item×size×modifier rows with qty > 0 or net ≠ 0. Omit the SAL-03 total line and any parent/subtotal row whose qty or net is already in a more detailed child row. Do not use the note's stated export totals as the expected value. Compare table sums to that recompute and to the SAL-03 total line (**1,294** qty / **$12,550.25**). Print `file=SAL-03.csv export_qty=<n> export_sales=<n> total_line_qty=<n> total_line_sales=<n> table_qty=<n> table_sales=<n> qty_delta=<n> sales_delta=<n>` | `qty_delta <= 1` and `sales_delta <= 1` (table sums = SAL-03 totals within $1 / 1 qty). Total line is 1294 / 12550.25 | command + trimmed output; any delta > 1 |
| T3 | shell | Join is the name-key rule, not POS code. Toast name in the table is the key built from SAL-03 `Item, open item`, `Size modifier`, `Modifiers, special requests` as `MNU-02.Name` (`<Item>-<Size>-<Modifier>`, or `<Item>-<Modifier>` when there is no size). Against `MNU-02.csv` / `RCP-02.csv`: every mapped row has an **exact** `MNU-02.Name` match (case and spaces as exported) and `MNU-02.Recipe` = `RCP-02.Name` exactly; no fuzzy match is mapped. Recipe cost is **`AvgCost`** (not `MNU-02.EstimatedCost`, not `RCP-02.Cost`). Print `mapped=<n> mapped_no_exact=<n>`. Then pick 10 sold-items data rows at random (record Toast names); if fewer than 10, pick all. If both mapped and unmapped exist, include at least one of each. For each, open `MNU-02.csv` / `RCP-02.csv` and compare mapping and `AvgCost`. For `unmapped` / `(?) possible`, confirm there is no exact Name match (or the key matches only after other changes) and cost is `n/a`. For `MI No Recipe Needed`, the recipe cell is that name and cost is still `AvgCost` | `mapped_no_exact=0`. Each of the 10 rows matches the R365 export on mapping and `AvgCost`. Every mapped row has an exact `MNU-02.Name` match and `MNU-02.Recipe` = `RCP-02.Name` | command + trimmed output; the 10 names; comparison line each; any mapped row with no exact match |
| T4 | shell | Under `## How mapping works`, rows (a), (b), and (c) exist. (a)'s Capture names `MAP-03`. Every Answer that starts with `seen` names a capture file that exists in `/srv/fhs-build/reports/recipes-122-captures/` (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> map03=<0\|1> seen_missing_file=<n> empty_unknown=<n>`. Then open each `seen` capture and confirm it shows what that Answer says: (a) where POS-item → recipe mapping lives (`MAP-03`); (b) Toast or other POS, and the POS or location label on the menu item; (c) why menu items show Estimated Cost `$0.00` while recipes have a cost (`AvgCost`) | `q_rows=3 map03=1 seen_missing_file=0 empty_unknown=0`. Each answer cites a capture that exists and shows what the answer says. Each `(?)` names what is missing | command + `ls` output; comparison line per (a)(b)(c); any missing file or answer the capture does not show |
| T5 | shell | Read `/srv/fhs-build/reports/recipes-122-captures/pages.csv` (header `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|submit\|approve\|complete\|post\|create\|edit\|map\|delete\|remove\|inactivate\|publish\|update` (case-insensitive). Menu-item / recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close` are allowed exceptions — list those separately, do not fail them. Toast report URLs are allowed as `view`, `filter`, or `export`. A `create` / `new` URL is never allowed. Then grep every capture `*.txt` for `Create` and `form/`. Must find **exactly** this one, closed without save: `RCP-02.txt` line 10 (blank RecipeItemForm, typed nothing). It is not in `pages.csv`. `## Deviations` names that file and line. Print `create_hits=<n> rcp02_line10=<0\|1> deviations_ok=<0\|1>`. Extra hits: this case fails (do not edit the captures) | unique actions are only `view`, `filter`, `scroll`, `export`, `close`. No save/create/edit/map/update-costs/publish/delete click or URL (and no submit/approve/complete/post/remove/inactivate URL), except menu-item / recipe list or detail with action `view` or `close`. Toast report URLs only as view/filter/export. `create_hits=1 rcp02_line10=1 deviations_ok=1` | unique actions; matching URLs or "none"; allowed view/close exceptions listed separately; grep hits; deviations line |
| T6 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git status --short` | only `docs/research/recipes-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); `git status --short` empty | commands + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T6 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in Toast or R365 during this check (recipe 400120 still $1.1858 or its later system cost; no new mapping; R365 Recipes still 2,331, no new blank recipe)?" | "no"; recipe 400120 still $1.1858 or its later system cost; no new mapping; Recipes still 2,331 | the owner's words |

## Results

Write `/srv/fhs-build/reports/recipes-122-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: recipes-122-01 · Branch: feat/recipes-122-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Complete, Post, Import, Re-import, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, any status button, any menu or price change, or any toggle and checkbox that persists.
- Run `docs/prompts/recipes-122-01-capture.md` or start a new capture. Do not recapture store-audit F4.
- Join on POS code, or count a fuzzy match as mapped. Use menu-item Estimated Cost or `RCP-02.Cost` as recipe cost (use **`AvgCost`**). Fold `MI No Recipe Needed` into `$0-cost`. Join `SAL-05.csv`. Write a fix plan or a support request.
- Edit, move, or delete anything under `/srv/fhs-build/reports/recipes-122-captures/`.
- Read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence.
