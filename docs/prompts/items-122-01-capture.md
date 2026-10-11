# Agent task · items-122-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/items-122-01.md`, reviewed with its plan (run only after the plan review is APPROVE on `main`).
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/items-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to R365 in Chrome, store **CARY 1**. Toast is not this task; do not open it.

> **DONE 2026-10-11 — record only, do not run again.** The capture ran on a changed route (Amendment 1 in
> `docs/briefs/items-122-01.md`, hub log 2026-10-11T21:00, owner chose): invoice lines came from read-only R365 reports, which have no
> line detail; no Ad hoc report; no invoice screenshots; invoices were **not** opened one by one. What was actually captured
> (`items-122.zip`, 52 files): `TPL-01..02`, `CNT-01..04` (count list and 10/04 approved count lines), `ITM-01` (Items grid), **`ITM-02.csv` (Vendor items export, 819 rows: the Cheney link and
> unit per item)**, `ITM-03-missing.txt`, `ITM-03-unitdiff.csv`, `ITM-04` (units of measure), `ITM-05..12` (4 item conversion pages),
> `INV-01` (AP transactions export), `INV-02` (invoice list), `INV-03.txt` (2-invoice sample), `INV-04/05-missing.txt`, `pages.csv`. The ITM and INV rows below record what was captured;
> the pre-amendment "open each invoice" step and line-level INV target were dropped.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) already counts 207 items on **CARY 1 - FHS Weekly Inventory**. This task only **captures** four R365 read-only views for that template: the template item list, the 10/04/2026 approved count line detail, Items units/conversions/Avg Cost for those items, and Cheney Brothers invoice lines 08/14–10/09/2026. You do not write the research note. You change nothing in R365. A later server agent writes the note from your files.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tab where the owner is already signed in. Store 122: R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\items-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/items-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there and in `docs/research/store-audit-122.md` F2 / F3 / F5 are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`.

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text, downloading a read-only report CSV, Excel, or PDF.
- **Prefer export.** If the page offers Export / Download / Excel / CSV / PDF of the list or lines, take that file. That export is the evidence. Still save a `.png` and `.txt` of the page header, row count, total, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead.
- **Never click:** Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Update recipe costs, cost recalculation, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens the template item list or an on-screen report is labelled Edit or Run and it does not post, import, email, calculate, or save, treat it as View, log `view`, capture, and leave with Cancel or Back. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- If you open an edit form by accident, leave with Cancel or Back, never Save.
- **Do not open** the In Progress **09/28/2026** count (list total $20.53). If opened by accident, leave with Cancel or Back, never Save. Open only the **Approved 10/04/2026** count.
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab, then continue. Do not skip past a login wall.
- **Exports:** read-only CSV / Excel / PDF of a report or grid only, saved in the capture folder (move it here if the browser dropped it in Downloads). An export never changes data. Never use an export or sync that sends data somewhere else.
- Snapshot (screenshot) before every click. Pick **CARY 1** / store **122** wherever a store picker exists. Do not audit CAMDEN SQUARE / 878. Do not open Toast or ADP.
- Do not ask hub q1–q5. Scope is the template as counted today (food + paper + chemicals already on it). Do not filter those categories off.

## File names and `pages.csv`

Create `C:\fhs\reports\items-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `TPL-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, whether controls look editable / greyed / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`TPL-02.png`, …). Do not skip numbers inside an area.

Areas (only these four): `TPL` (template item list), `CNT` (10/04/2026 approved count lines), `ITM` (Items units, conversions, Avg Cost), `INV` (Cheney invoices 08/14–10/09/2026 (headers + 2-invoice sample; no line detail, Amendment 1)).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or export.

- `time`: local ISO-8601 with offset (e.g. `2026-10-11T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, or `export`

No other action. Viewing an invoice or a template item list is `view`. Do not click Map, Import, Approve, or any write.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, stop and ask the owner (runbook row 9). Do not open Toast.
2. Create `C:\fhs\reports\items-122\`. Write `pages.csv` with only the header row. Then capture every row in **Pages to capture**, in order. For each row: screenshot before the click; open the page; set the store to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate label is shown, plus Created by / Modified by if visible. Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\items-122\* -DestinationPath C:\fhs\reports\items-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\items-122.zip -Name items-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

R365 base: `https://fhs4021089.restaurant365.com/`. Confirmed R365 starts (use if the menu agrees): Items `/react/inventory/purchase-items`; Counts `/react/inventory/inventory`; AP transactions `/react/accounting/ap-transactions?tab=transactions`; Vendors `/react/accounting/legacy/Vendors`. Count templates, Inventory → Invoices, Units of measure, and item-detail conversion URLs `(?)`. Do not open Toast.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| TPL | `TPL-01` templates list; `TPL-02` opened **CARY 1 - FHS Weekly Inventory** item list (export if offered); more `TPL-nn` if the list is paged | R365 Inventory → Count templates `(?)`. Open **CARY 1 - FHS Weekly Inventory** only (CARY 1, 207 items, On Demand). Do not open CAMDEN SQUARE - FHS Weekly Inventory or monthly | The **207 item names and count unit**. The 3-row templates list is not enough. Export the item list if the page offers CSV/Excel/PDF. Record created-by / modified-by. Leave with Cancel or Back, never Save |
| CNT | `CNT-01` counts list; `CNT-02` opened **Approved 10/04/2026** line detail (export if offered); more `CNT-nn` if paged | R365 Inventory → Inventory counts `/react/inventory/inventory`, CARY 1. Open the **Approved** row **10/04/2026**, total **$7,461.73**, template CARY 1 - FHS Weekly Inventory. **Do not open** In Progress 09/28/2026 | Every count **line**: name, count unit, qty, cost per count unit, extended value, and the header total. The 3-row counts list is not enough. Export lines if offered. Approved view only; Cancel/Back, never Save or Approve |
| ITM | **As captured:** `ITM-01` Items grid export; `ITM-02.csv` **Vendor items export** (819 rows, the Cheney vendor item, link and unit per item); `ITM-03-missing.txt`, `ITM-03-unitdiff.csv` (items whose Cheney unit ≠ count unit); `ITM-04` Units of measure export; `ITM-05`..`ITM-12` four item-detail conversion pages | R365 Inventory → Items `/react/inventory/purchase-items`; Vendor items `/react/inventory/legacy/VendorItems`; Units of measure `/react/inventory/UnitsOfMeasure`. View, filter, export only; item detail closed with Cancel/Back | Units, conversions and Avg Cost for the 207 template names, and the Cheney link + unit per item from `ITM-02.csv` |
| INV | **As captured:** `INV-01` AP transactions export (Cheney, CARY 1, 08/14–10/09/2026, headers); `INV-02` Invoices list export; `INV-03.txt` 2-invoice sample (viewed, not edited); `INV-04-missing.txt`, `INV-05-missing.txt` (read-only reports in `ReportViewer` have no line detail) | Accounting → AP transactions; Inventory → Invoices; Reports `ReportViewer`. No Ad hoc report (it needs a save); invoices were **not** opened one by one; never Approve | Invoice headers and a sample only. Line-level receipt recency and unmapped invoice lines move to F3 (electronic invoices), owner 2026-10-11 |

Do not capture storage locations, recipes, menu mapping, other vendors, credit-memo detail (unless a Cheney CARY 1 credit appears in the same filtered invoice list — then note it in `.txt` and skip opening it), integrations, or Documents to process.

## You may edit only

- Files under `C:\fhs\reports\items-122\` (png, txt, csv, xlsx, pdf, `pages.csv`)
- The zip `C:\fhs\reports\items-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open Toast or ADP.
- Do any forbidden action listed above. Click Map, Import, Save, Submit, Approve, Post, Run-as-job, Update recipe costs, or cost recalculation. Do not open the In Progress 09/28 count for editing.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt without the owner signing in.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\items-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas TPL, CNT, ITM, INV. Every area has at least one `.png`/`.txt` or a `-missing.txt`. Each area has a `.csv`/`.xlsx`/`.pdf` export, or a `-missing.txt` that says no export was offered.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `export`
4. No `pages.csv` URL with path segments `save`, `submit`, `post`, `approve`, or `create` (case-insensitive). No edit / new / import / mapping **action** URL (a write). Viewing an invoice or template is allowed, and `invoiceId=` and `ReportViewer` URLs are allowed as **view** only.
5. No `pages.csv` URL for Toast, ADP, or a 09/28 / 2026-09-28 count.
6. After the send step: the `send-report.ps1` line printed `MATCH`

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped).

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
