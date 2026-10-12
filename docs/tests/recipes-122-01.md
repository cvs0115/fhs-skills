# Test plan · recipes-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/recipes-122-01.md".

## What's being tested

The research note lists every Cary 1 Toast item and modifier option sold in the captured week, each mapped or unmapped (or `(?) possible`) with recipe cost present, `$0.00`, or `(?)`. Table qty and net sales match the Toast export totals within $1 (recomputed from the export file). Ten random table rows match the R365 exports on mapping and cost, and every `mapped` row has an exact POS-code or exact-name match. Each `## How mapping works` answer cites a capture that exists, or `(?)` names what is missing. `pages.csv` has only view/filter/scroll/export/close. `tech-stack.md` only gained lines. Post-merge (not a gate): nothing in Toast or R365 changed (recipe 400120 still $1.1858 or its later system cost; no new mapping).
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
- Captures are unzipped at `/srv/fhs-build/reports/recipes-122-captures/` and include `pages.csv`, at least one `SAL-*` file, at least one `MNU-*` file, and at least one `RCP-*` file. If that folder is missing, empty, or has no `pages.csv`, mark T2–T5 BLOCKED (captures missing). If no tabular `SAL-*` (`.csv` / `.xlsx`), mark T2 BLOCKED. If no tabular `MNU-*` or no tabular `RCP-*`, mark T3 BLOCKED.
- `MAP-*` is expected. If the capture found no mapping / unmapped / sales-by-menu-item screen, a `MAP-*-missing.txt` (or equivalent stop note) is expected — do not BLOCK T3–T4 for that; the note should use `(?)` where those files are missing.
- You are in `/srv/fhs-build/recipes-122-01` on `feat/recipes-122-01` as `fhsbuild`. Do not run `docs/prompts/recipes-122-01-capture.md`. Do not recapture store-audit F4. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/recipes-122.md`. Headings `## Summary for the owner`, `## Sold items`, `## Totals`, and `## How mapping works` must exist. Count non-blank lines under `## Summary for the owner` until the next `## `. Take pipe-rows between `## Sold items` and the next `## `, skip the header and `\|---` separator (8-column markdown: Type, Toast name, POS code, Qty, Net sales, R365 recipe, Recipe cost). Print `headings_ok=<0\|1> summary_lines=<n> rows=<n> empty_cells=<n> bad_type=<n> bad_recipe=<n> bad_cost=<n> rows_mismatch=<n> unmapped_mismatch=<n> zero_mismatch=<n> possible_mismatch=<n> qty_delta=<n> sales_delta=<n> pct_ok=<0\|1> totals_ok=<0\|1>`. `empty_cells` = blank or missing cells (7 cells per data row). `bad_type` = Type not exactly `item` or `modifier`. `bad_recipe` = R365 recipe not a name, not `unmapped`, and not starting with `(?) possible`. `bad_cost` = Recipe cost not an amount, `$0.00`, `(?)`, `n/a`, or `not shown (<file>)`; also `n/a` on a mapped row, or a dollar amount on `unmapped` / `(?) possible`. Recompute unmapped / `$0-cost` / `(?) possible` / table qty / table net sales from the table (`$0-cost` = mapped rows whose recipe cost is `$0.00`; do not use menu-item Estimated Cost). Compare those to `## Totals`. `qty_delta` / `sales_delta` are \|table − stated export totals\|. `%` of week net sales on unmapped or `$0-cost` must equal (net sales of those rows) / week net sales (export net sales if week net sales is missing); do not fold `(?) possible` into that `%`. Totals must include week, rows, unmapped, `$0-cost`, `(?) possible`, table qty, table net sales, export qty, export net sales, week net sales, and that `%`. Week is `10/05–10/11/2026` or `09/28–10/04/2026` | `headings_ok=1 summary_lines<=6 rows>=1 empty_cells=bad_type=bad_recipe=bad_cost=0` every mismatch `0`, `qty_delta` and `sales_delta` each `<= 1`, `pct_ok=1 totals_ok=1` | command + trimmed output; any bad row or totals that do not tie |
| T2 | shell | From the `SAL-*` export(s) cited in the note (`.csv` or `.xlsx`; item and modifier if both exist), recompute qty and net sales using the same columns the note used. Drop rows with qty 0 and net sales `$0.00` if the export includes them. Do not use the note's stated export totals as the expected value. Print `file=<names> export_qty=<n> export_sales=<n> table_qty=<n> table_sales=<n> qty_delta=<n> sales_delta=<n>` | `qty_delta <= 1` and `sales_delta <= 1` (table sums = Toast export totals within $1) | command + trimmed output; SAL file names; any delta > 1 |
| T3 | shell | A mapped row is one whose R365 recipe cell is a recipe name — not `unmapped`, not `(?) possible`. Against the cited `MNU-*` / `RCP-*` export(s): every mapped row has an exact POS-code match (six-digit Toast POS code, if shown) or else an exact Toast-name match; join is POS code first, then exact name; no fuzzy match is mapped. Print `mapped=<n> mapped_no_exact=<n>`. Then pick 10 sold-items data rows at random (record Toast names); if fewer than 10, pick all. If both mapped and unmapped exist, include at least one of each. For each, open the cited R365 export(s) and compare mapping and recipe cost (recipe cost from `RCP-*`, not menu-item Estimated Cost). For `unmapped` / `(?) possible`, confirm there is no exact code or name match and cost is `n/a` | `mapped_no_exact=0`. Each of the 10 rows matches the R365 export on mapping and cost. Every mapped row has an exact code or name match | command + trimmed output; the 10 names; comparison line each; any mapped row with no exact match |
| T4 | shell | Under `## How mapping works`, rows (a), (b), and (c) exist. Every Answer that starts with `seen` names a capture file that exists in `/srv/fhs-build/reports/recipes-122-captures/` (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> seen_missing_file=<n> empty_unknown=<n>`. Then open each `seen` capture and confirm it shows what that Answer says: (a) where POS-item → recipe mapping lives; (b) Toast or other POS, and the POS or location label on the menu item; (c) why menu items show Estimated Cost `$0.00` while recipes have a cost | `q_rows=3 seen_missing_file=0 empty_unknown=0`. Each answer cites a capture that exists and shows what the answer says. Each `(?)` names what is missing | command + `ls` output; comparison line per (a)(b)(c); any missing file or answer the capture does not show |
| T5 | shell | Read `/srv/fhs-build/reports/recipes-122-captures/pages.csv` (header `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|create\|edit\|map\|publish\|delete\|update` (case-insensitive). Menu-item / recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close` are allowed exceptions — list those separately, do not fail them | unique actions are only `view`, `filter`, `scroll`, `export`, `close`. No save/create/edit/map/update-costs/publish/delete click or URL, except menu-item / recipe list or detail with action `view` or `close` | unique actions; matching URLs or "none"; allowed view/close exceptions listed separately |
| T6 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git status --short` | only `docs/research/recipes-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); `git status --short` empty | commands + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T6 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in Toast or R365 during this check (recipe 400120 still $1.1858 or its later system cost; no new mapping)?" | "no"; recipe 400120 still $1.1858 or its later system cost; no new mapping | the owner's words |

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
- Click anything that changes data: Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Post, Import, New, Add, Sync, Run (any job), any status button, any menu or price change, or any toggle and checkbox that persists.
- Run `docs/prompts/recipes-122-01-capture.md` or start a new capture. Do not recapture store-audit F4.
- Count a fuzzy match as mapped. Use menu-item Estimated Cost as recipe cost. Write a fix plan or a support request.
- Edit, move, or delete anything under `/srv/fhs-build/reports/recipes-122-captures/`.
- Read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence.
