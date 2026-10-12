# Agent task · recipes-122-01 · capture

> **RECORD ONLY, DO NOT RUN.** This capture was done on 2026-10-12 (week 10/05–10/11/2026); the result is `inbox/recipes-122.zip`.

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/recipes-122-01.md`. Runs only after the plan review is APPROVE and the PC clone is refreshed.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/recipes-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to **Toast and R365** in Chrome, restaurant **00122 - Cary 1**, store **CARY 1**. ADP is not this task; do not open it.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) sells Toast items and modifiers that should
map to R365 recipes with a real cost. This task only **captures** plan parts 1–2, read-only: Toast
sales (`SAL-*`), then R365 menu items (`MNU-*`), recipes (`RCP-*`), and any POS mapping / unmapped /
sales-by-menu-item screen (`MAP-*`). You do not write the research note or join the rows. You change
nothing in Toast or R365. A later server agent writes the note from your files. Part 3 (the join) is
not this task. A fix plan or support request comes later from the note.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tabs where the owner is already signed in. Store 122: Toast restaurant **00122 - Cary 1**, R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\recipes-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/recipes-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)
5. `docs/research/store-audit-122.md` F4 paths only as a start (Recipes `/react/inventory/recipe-items`; Menu Items `/react/inventory/legacy/MenuItems`). Toast Reports `https://www.toasttab.com/restaurants/admin/reports/home`.

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there, in `docs/research/store-audit-122.md` F4, and in this file are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`. Do not follow the F4 capture (`docs/prompts/store-audit-122-02-capture.md`) beyond those path starts. Do not recapture F2–F13, count-sheet-122, items-122, invoices-122, or count-lines-122.

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text, scrolling a grid, downloading a read-only report or grid CSV, Excel, or PDF. Open a detail page to read it, then Close.
- **Prefer export.** If a Toast report or an R365 Menu Items / Recipes grid offers Export / Download / Excel / CSV / PDF, take that file. That export is the evidence. Still save a `.png` and `.txt` of the page header, row count, report name, dates, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead (log `scroll` if you scroll). If a full Menu Items or Recipes export is too big or the download fails, filter by the sold names (or POS codes) from the `SAL-*` export instead, then export or capture those filtered pages. Do not skip sold names.
- **Never click:** Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, any status button, any menu or price change, Submit, Approve, Complete, Post, Import, Re-import, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens a report is labelled Edit, Run, Generate, or Update and it does not post, import, email, calculate, save, map, publish, or update recipe costs, treat it as View, log `view`, capture, and leave with Close, Cancel, or Back. Do not click a control labelled **Update recipe costs**. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- If you open an edit form by accident, leave with Close, Cancel, or Back, never Save. If expanding a section makes Save clickable, do not click Save; screenshot what is already visible and leave. Do not open Ad hoc report (it needs a save).
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab. Do not skip past a login wall. Do not zip or send until the owner answers. Do not open anything else first.
- **Exports:** read-only CSV / Excel / PDF of a report or grid only, saved in the capture folder (move it here if the browser dropped it in Downloads). An export never changes data. Never use an export or sync that sends data somewhere else. Do not open Ad hoc report (it needs a save).
- Snapshot (screenshot) before every click. Pick restaurant **00122 - Cary 1** in Toast and **CARY 1** / store **122** in R365 wherever a store picker exists. Do not audit store 878 / CAMDEN SQUARE. Do not open ADP.
- Do not ask hub q1–q5. Do not recapture F2–F13. Do not write the research note. Do not map or assign a POS item. Do not change a menu or a price.

## File names and `pages.csv`

Create `C:\fhs\reports\recipes-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `SAL-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, report name and path, every button and menu shown as text not clicked — label, enabled or greyed — whether controls look editable / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`SAL-02.png`, …). Do not skip numbers inside an area.

Areas: `SAL` (Toast sales by item and by modifier option for restaurant **00122 - Cary 1** for the week, plus the week's net sales total; report name and path as seen), `MNU` (R365 Menu Items export or filtered captures: name, POS id/code, recipe, cost columns), `RCP` (R365 Recipes export: name, POS id/code, cost columns), `MAP` (any POS-item mapping, "unmapped", or sales-by-menu-item screen R365 shows, plus what the menu item says its POS or location is; or `MAP-*-missing.txt` if none).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or scroll or export or close.

- `time`: local ISO-8601 with offset (e.g. `2026-10-12T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, `scroll`, `export`, or `close`

No other action. Menu-item and recipe detail pages are allowed as **view** only and must be closed with Close (log `close`). Do not click Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, or any write.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to Toast (`https://www.toasttab.com/restaurants/admin/reports/home`, restaurant **00122 - Cary 1**) and R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, stop and ask the owner (runbook row 9). Do not open ADP.
2. Create `C:\fhs\reports\recipes-122\`. Write `pages.csv` with only the header row. **Pick the week before Toast.** In R365, location **CARY 1**, open a sales-by-menu-item screen if shown, else Daily sales `/react/sales-and-forecasting/daily-sales` `(?)`, dates **10/05–10/11/2026** (log `filter`). If that week shows posted sales, the week is **10/05–10/11/2026**. If sales are not posted, the week is **09/28–10/04/2026**. Save `MAP-01.png` and `MAP-01.txt`; start the `.txt` with `Week: <dates> (R365 sales for 10/05–10/11 posted | not posted)`. Do not open Actual vs Theoretical, food cost, or P&L. Then capture every row in **Pages to capture**, in order, using that **one** week for Toast and R365. For each row: screenshot before the click; open the page; set Toast to **00122 - Cary 1** and R365 to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate / "managed by" label is shown, plus Created by / Modified by if visible. Start every later area's first `.txt` with `Week: <dates>`. Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\recipes-122\* -DestinationPath C:\fhs\reports\recipes-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\recipes-122.zip -Name recipes-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

Toast base: `https://www.toasttab.com/restaurants/admin/reports/home`. R365 base: `https://fhs4021089.restaurant365.com/`. Confirmed starts (use if the menu agrees): Toast Reports (product mix or item/modifier selection details; report name and path `(?)` until this capture); R365 Menu Items `/react/inventory/legacy/MenuItems`; R365 Recipes `/react/inventory/recipe-items`. Daily sales `/react/sales-and-forecasting/daily-sales` is the week-gate only if no sales-by-menu-item screen is shown. POS / menu-item mapping path `(?)`. Confirm; unknown `(?)`. Do not open ADP.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| SAL | `SAL-01` report home or list (png/txt); then `SAL-nn` **sales by item** (png + txt; csv/xlsx); `SAL-nn` **sales by modifier option** (png + txt; csv/xlsx) — one export that includes both is enough, say so in the `.txt`; `SAL-nn` **week net sales total** (png + txt; export if offered). Extra screens increment `nn`. `SAL-nn-missing.txt` if a named report will not open or will not export | Toast Reports → product mix or item/modifier selection details `(?)`. Restaurant **00122 - Cary 1**. Dates = the chosen week. View, filter, export only. Do not open Menu manager. Do not change a menu or a price | Start `.txt` with `Week: <dates>`. Write `Report: <name>` and `Path: <menu path or URL as seen>`. Item rows and modifier-option rows with qty and net sales. Write `Week net sales: <amount>`. POS code column if shown; do not hunt it on other Toast screens |
| MNU | `MNU-01` Menu Items list (png/txt); `MNU-nn` **export** of that grid if offered; more `MNU-nn` if paged or if you filter to sold names. `MNU-nn-missing.txt` if no export was offered and a sold name will not show | Inventory → Menu Items `/react/inventory/legacy/MenuItems`. Location **CARY 1** if a picker exists. View, filter, scroll, export only. Close/Cancel/Back, never Save. Do not click Map/assign, Edit, or Create. Prefer the full export; if it is too big or fails, filter to sold names or POS codes from `SAL-*` | Columns: name, POS id/code, recipe, cost (Estimated Cost is not recipe cost; still capture that column). Grid header and row count |
| RCP | `RCP-01` Recipes list (png/txt); `RCP-nn` **export**; more `RCP-nn` if paged or filtered to sold names. `RCP-nn-missing.txt` if no export was offered | Inventory → Recipes `/react/inventory/recipe-items`. View, filter, scroll, export only. Do not click **Update recipe costs** or Create. Close/Cancel/Back, never Save. Prefer the full export; if it is too big or fails, filter to sold names or POS codes from `SAL-*` | Columns: name, POS id/code, recipe cost. Grid header and row count. F4 expected size 2,331 is not this check's evidence |
| MAP | Week-gate is `MAP-01` from Steps (already captured). Then `MAP-nn` each POS-item mapping, "unmapped", or sales-by-menu-item screen found (png + txt; csv/xlsx if offered). One menu-item detail for a sold name (png + txt), then Close (`close`). If a linked recipe is shown, open it only to read cost vs Estimated Cost `$0.00`, then Close. Extra screens increment `nn`. `MAP-nn-missing.txt` if no mapping / unmapped / sales-by-menu-item screen exists (week-gate Daily sales does not count as that screen) | POS / menu-item mapping `(?)`; sales-by-menu-item if shown; menu-item detail from `/react/inventory/legacy/MenuItems`; recipe detail from `/react/inventory/recipe-items`. View, filter, close only. Never Map/assign. Never **Update recipe costs**. Leave every detail with Close | Mapping screen title as shown, or `MAP-nn-missing.txt` (what you searched). Menu item: POS or location label exactly as written (or `not shown`). Write in the `.txt` that the detail was closed with Close |

Do not capture count history, invoices, storage locations, count templates, vendors, AP, F2 item costs, F7 food cost, F2–F13, store 878 / CAMDEN SQUARE, recipes that did not sell except as part of a full MNU/RCP export, Toast Menu manager, payroll, Ad hoc report, integrations, or ADP. Do not recapture store-audit F4, count-sheet-122, items-122, invoices-122, or count-lines-122.

## You may edit only

- Files under `C:\fhs\reports\recipes-122\` (png, txt, csv, xlsx, pdf, `pages.csv`)
- The zip `C:\fhs\reports\recipes-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open ADP.
- Do any forbidden action listed above. Click Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, Submit, Approve, Post, Import, New, Add, Sync, Run-as-job, any status button, or any menu or price change.
- Write `docs/research/recipes-122.md` or any other repo file.
- Recapture F2–F13, count-sheet-122, items-122, invoices-122, or count-lines-122. Touch payroll or `browser-02`.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt without the owner answering.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\recipes-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas SAL, MNU, RCP, MAP. Every required area has at least one `.png`/`.txt` or a `-missing.txt`. SAL has sales by item and by modifier (two exports, or one file that includes both) and the week's net sales total; the `.txt` has `Week:`, `Report:`, `Path:`, and `Week net sales:`. MNU has an export (or filtered captures) with name / POS id/code / recipe / cost. RCP has an export (or filtered captures) with name / POS id/code / cost. MAP has `MAP-01` with the week-gate line, plus a mapping / unmapped / sales-by-menu-item capture or a `MAP-*-missing.txt` that none was found.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `scroll`, `export`, `close`
4. No `pages.csv` URL with path segments `save`, `submit`, `approve`, `complete`, `post`, `create`, `edit`, `map`, `delete`, `remove`, `inactivate`, `publish`, or `update` (case-insensitive), except menu-item / recipe list or detail URLs (`MenuItems`, `recipe-items`, or a recipe/menu-item id query) whose action is `view` or `close`. Toast report URLs are allowed as `view`, `filter`, or `export`. A `create` / `new` URL is never allowed.
5. No `pages.csv` URL for ADP. No CAMDEN SQUARE / 878. Toast and R365 only.
6. After the send step: the `send-report.ps1` line printed `MATCH` (skip this test if you stopped at a login / MFA prompt and the owner has not said to send)

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped), which week was captured (`10/05–10/11/2026` or `09/28–10/04/2026`), and whether capture stopped at a login / MFA prompt.

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
