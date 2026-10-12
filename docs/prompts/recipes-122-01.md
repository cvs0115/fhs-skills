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
Cary 1 item and modifier option that sold in one complete week, mark each mapped or unmapped, and
whether the recipe cost is present, `$0.00`, or `(?)`. You never open a browser. Nothing in Toast or
R365 is changed. A fix plan or support request comes later from the note. Capture is already done.

## Where you work

- Workspace: `/srv/fhs-build/recipes-122-01`, your own clone of the repo. Work only here.
- Branch: create `feat/recipes-122-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- This job's captures (read only, outside the repo, already unzipped): `/srv/fhs-build/reports/recipes-122-captures/`.
  `pages.csv` plus `SAL-*`, `MNU-*`, `RCP-*`, `MAP-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports). `pages.csv` columns: time, URL, action = view/filter/scroll/export/close.
  Areas: `SAL` (Toast sales by item and by modifier option for restaurant **00122 - Cary 1** for the week, plus the week's net sales total; report name and path as seen), `MNU` (R365 Menu Items: name, POS id/code, recipe, cost columns; full export or filtered to sold names), `RCP` (R365 Recipes: name, POS id/code, cost columns; full export or filtered to sold names), `MAP` (any POS-item mapping, "unmapped", or sales-by-menu-item screen R365 shows, plus what the menu item says its POS or location is).

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/recipes-122-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/recipes-122.md`
4. `docs/prompts/recipes-122-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/store-audit-122.md` F4 only (2,331 recipes, 64,670 menu items, visible Estimated Cost `$0.00`, Toast target "Firehouse Subs Group - 435 groups, 1 location"). Facts marked `(?)` stay unverified unless this capture shows them. F4 is expected size only, not this check's sold-row evidence.
6. `skills/fhs-skills/references/tech-stack.md` (R365 Recipes line: 400120 recipe `$1.1858` vs menu item `$0.00`; the Recipe filter can't select blank). Append lines later in the Toast and R365 parts of `## Store 122 audit (2026-10-11)`; do not treat those bullets as this check's sold-row or mapping evidence.

## Steps

1. `git switch feat/recipes-122-01` if that branch already exists, else `git switch -c feat/recipes-122-01`.
2. Confirm `/srv/fhs-build/reports/recipes-122-captures/` exists and contains `pages.csv`, at least one `SAL-*` file, at least one `MNU-*` file, and at least one `RCP-*` file. List this job's capture files. If any of those confirms fail, stop and write the report with that reason. `MAP-*` is expected. If the capture found no mapping / unmapped / sales-by-menu-item screen, a `MAP-*-missing.txt` (or equivalent stop note) is expected; do not stop for that — finish the note and use `(?)` where those files are missing.
3. **Hard rule: this job's capture folder and the two research files above only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Do not start a new PC capture. Do not recapture store-audit F4. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, or `/srv/fhs-build/reports/count-sheet-122-captures/` as this check's evidence.
4. From those files only, write `docs/research/recipes-122.md`. Start with `# Research · recipes-122 · Cary 1 sold items: R365 recipe mapped or not, cost present or $0` and the date. Then:

   1. **`## Summary for the owner`** — plain words, **≤6 lines**: how many sold rows mapped vs unmapped, how many mapped recipes are `$0.00` or `(?)`, and the share of week net sales on unmapped or `$0-cost` rows. Do not recommend a fix or a support request.

   2. **`## Sold items`** — one row for each Toast item **and** each modifier option with sales at restaurant **00122 - Cary 1** in the week. Columns, in this order:

      | Type | Toast name | POS code | Qty | Net sales | R365 recipe | Recipe cost |

      - **Type** is exactly `item` or `modifier`.
      - **Toast name**, **Qty**, and **Net sales** come from the `SAL-*` export(s). Omit rows with no sales (qty 0 and net sales `$0.00`). If the export includes those, drop them and say how many under **How mapping works**.
      - **POS code** is the six-digit number if the Toast export shows it (e.g. `400120`); otherwise `not shown (<SAL file>)`. Do not fill this cell from R365.
      - **R365 recipe** is the R365 recipe name, `unmapped`, or `(?) possible`. Join sold rows to R365 **by POS code first** (the six-digit number, e.g. 400120), **then exact name**. No fuzzy match is mapped; list it as `(?) possible` (you may add the nearest R365 name after a colon). A `mapped` row is one whose R365 recipe cell is a recipe name — not `unmapped`, not `(?) possible`.
      - **Recipe cost** is the **recipe** cost from `RCP-*` (present amount, `$0.00`, or `(?)`). Do not use the menu item Estimated Cost as recipe cost. Menu item `$0.00` with a recipe cost is **not** `$0-cost`. For `unmapped` or `(?) possible`, write `n/a`.
      - No empty cells. If a capture does not show a value, write `not shown (<file>)` in that cell (POS code uses the `not shown` form above).
      - The note uses **one** week for Toast and R365: last complete Mon–Sun **10/05–10/11/2026**, or fallback **09/28–10/04/2026** if that is the week the captures used. Say which.

   3. **`## Totals`** — these metrics, each with a value (a table or labeled lines). The note must show both the table sums and the Toast export totals:

      | Metric | What it is |
      |---|---|
      | week | the one week used |
      | rows | sold-items data rows |
      | unmapped | rows whose R365 recipe is `unmapped` |
      | $0-cost | **mapped** rows whose recipe cost is `$0.00` |
      | (?) possible | rows whose R365 recipe is `(?) possible` |
      | table qty / table net sales | sums of the Qty and Net sales columns |
      | export qty / export net sales | totals from the `SAL-*` export(s) those rows came from |
      | week net sales | the captured week's net sales total (the `%` denominator) |
      | % of week net sales on unmapped or $0-cost | that share; do not fold `(?) possible` into this `%` |

      Table qty and table net sales must match the Toast export totals within `$1`. If week net sales is missing, use export net sales as the denominator and say so.

   4. **`## How mapping works`** — start with which week, which SAL/MNU/RCP/MAP files, and that join was POS code then exact name. Then answer each question with `seen` + capture file, or `(?)` + what is missing. Do not click and do not infer a click. F4 / tech-stack facts may be cited as expected size only; the answer itself must name a file in this job's captures folder (or `(?)`). Then:

      | Q | Answer | Capture |

      - **(a)** Where does POS-item → recipe mapping live? Include any POS-item mapping, "unmapped", or sales-by-menu-item screen shown (`MAP-*`). Answer is `seen: <path or label exactly as written>` or `seen: not shown`, or `(?): <what's missing>`.
      - **(b)** Is the POS Toast or another POS? What does the menu item say its POS or location is? Answer is `seen: <the label exactly as written>` or `seen: not named`, or `(?): <what's missing>`.
      - **(c)** Why do menu items show Estimated Cost `$0.00` while recipes have a cost? Answer is `seen: <what the screens show>` or `(?): <what's missing>`.

5. Match rows to files using the capture task's names (SAL/MNU/RCP/MAP) and `pages.csv`. Cite the real file name under this job's captures folder (e.g. `SAL-01.csv`, `MNU-01.csv`, `RCP-01.csv`). Every `seen` cell must name a capture file that exists there. Every `mapped` row must have an exact POS-code match or an exact name match in `MNU-*` / `RCP-*`. Typical paths (confirm from the files; unknown `(?)`):

   | Area | Where | Take from it |
   |---|---|---|
   | SAL | Toast Reports (product mix or item/modifier selection details; report name and path `(?)` until this capture). Restaurant **00122 - Cary 1** | sold item and modifier rows, qty, net sales, POS code if shown, week net sales total, report name and path |
   | MNU | R365 Menu Items `/react/inventory/legacy/MenuItems` | name, POS id/code, recipe, cost columns (Estimated Cost is not recipe cost) |
   | RCP | R365 Recipes `/react/inventory/recipe-items` | name, POS id/code, recipe cost |
   | MAP | any POS-item mapping, unmapped, or sales-by-menu-item screen `(?)`; menu-item / recipe detail (view, then Close) | where mapping lives; POS or location on the menu item; why Estimated Cost is `$0.00` |

   Do not copy sold-item rows from `docs/research/store-audit-122.md` or `tech-stack.md`. Verified audit facts you may use as expected size only: 2,331 recipes; 64,670 menu items; visible Estimated Cost `$0.00`; Toast Target Firehouse Subs Group, 435 groups, 1 location; recipe **400120** current cost `$1.1858` vs its menu item `$0.00`. If this capture does not show 400120, leave that pair unverified. Audit facts marked `(?)` stay unverified unless this capture shows them (including "unmapped with sales" not found).

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (Toast and R365 facts): added lines only, the **Toast sales export path** (report name and/or URL from this capture, plus the file name) and **where POS mapping lives**, each with a pointer to `docs/research/recipes-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the existing Recipes or Menu Items bullets (400120, 2,331, 64,670).

7. If this job's `pages.csv` has an action other than view/filter/scroll/export/close, or a URL whose path looks like save / create / edit / map / update-costs / publish / delete, record it in the report's deviations. Menu-item and recipe detail pages are allowed as **view** only and should have a `close` (or leave) after. Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/recipes-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/recipes-122-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/recipes-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Post, Import, New, Add, Sync, Run (any job), any status button, any menu or price change, or any toggle and checkbox that persists. No settings pages edited.
- Run `docs/prompts/recipes-122-01-capture.md` or start a new capture.
- Write a checker script. Count a fuzzy match as mapped. Use menu item Estimated Cost as recipe cost. Include recipes that did not sell. Audit store 878 / CAMDEN SQUARE (NCR). Reopen F2 item-cost problems or F7 food cost %. Touch payroll or `browser-02`. Write a fix plan or a support request.
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. This job's captures: `/srv/fhs-build/reports/recipes-122-captures`.

1. Headings `## Summary for the owner`, `## Sold items`, `## Totals`, and `## How mapping works` exist. Data rows under `## Sold items`: every row has 7 cells; none empty; every Type is `item` or `modifier`; every R365 recipe cell is a name, `unmapped`, or starts with `(?) possible`; every Recipe cost cell is an amount, `$0.00`, `(?)`, `n/a`, or `not shown (<file>)`. Command: a `python3 -c` that prints `headings_ok=<0|1> rows=<n> empty_cells=<n> bad_type=<n> bad_recipe=<n> bad_cost=<n>`. Pass if `headings_ok == 1`, `rows >= 1`, `empty_cells == bad_type == bad_recipe == bad_cost == 0`.
2. Under `## Totals`, values exist for rows, unmapped, `$0-cost`, `(?) possible`, table qty, table net sales, export qty, export net sales, week net sales, and `%` of week net sales on unmapped or `$0-cost`. Recompute unmapped / `$0-cost` / `(?) possible` / table qty / table net sales from the sold-items table. Print `rows_mismatch=<n> unmapped_mismatch=<n> zero_mismatch=<n> possible_mismatch=<n> qty_delta=<n> sales_delta=<n> totals_ok=<0|1>`. Pass if every mismatch is 0, `qty_delta` and `sales_delta` vs the **stated export totals** are each `<= 1`, and `totals_ok == 1`.
3. Under `## How mapping works`, rows (a), (b), and (c) exist. Every Answer that starts with `seen` names a capture file that exists in the captures folder (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> seen_missing_file=<n> empty_unknown=<n>`. Pass if `q_rows == 3`, `seen_missing_file == empty_unknown == 0`.
4. This job's `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`, `close`; no URL path matching `save|create|edit|map|publish|delete|update` (case-insensitive), except menu-item / recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close`. Print the unique actions and any matching URLs (allowed view/close exceptions listed separately).
5. After the commit: `git diff --name-only main...HEAD` → only `docs/research/recipes-122.md` and `skills/fhs-skills/references/tech-stack.md`
6. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
7. After the commit: `git status --short` → empty

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
Tests: <n>/7 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
