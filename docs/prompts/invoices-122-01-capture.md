# Agent task · invoices-122-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/invoices-122-01.md`. Plan only, not approved. Run only after the plan review is APPROVE on `main`.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/invoices-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to R365 in Chrome, store **CARY 1**. Toast is not this task; do not open it.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) already counts 207 items on **CARY 1 - FHS Weekly Inventory**. F2 reports have **no invoice line detail**. This task only **captures** two R365 read-only views: the Cheney Brothers **Transactions** tab for CARY 1, and every CARY 1 Cheney invoice and credit memo dated 08/14–10/09/2026 opened one by one (`invoiceId=`, view only), including the virtualized line grid. You do not write the research note. You change nothing in R365. A later server agent writes the note from your files.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tab where the owner is already signed in. Store 122: R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\invoices-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/invoices-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there and in `docs/research/store-audit-122.md` F3 and `docs/research/items-122.md` INV paths are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`. Do not follow the F2 capture (`docs/prompts/items-122-01-capture.md` INV rows): that run did **not** open invoices one by one and its reports have no line detail.

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening invoice detail pages (`invoiceId=`) to read, changing on-screen filters or date ranges, taking screenshots, saving page text, scrolling a grid, downloading a read-only report or grid CSV, Excel, or PDF.
- **TXN: prefer export.** If the Transactions tab offers Export / Download / Excel / CSV / PDF of the list, take that file. That export is the count to match. Still save a `.png` and `.txt` of the page header, row count, totals, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead.
- **INV lines: export if present, else scroll.** If the invoice line grid has a read-only export button, use it instead of scrolling, log `export`, and say so in that invoice's `.txt`. The export is the line evidence. Still save a `.png` and `.txt` of the header, footer `1 - N of N Items`, approval fields, and ownership labels. If no line export exists, scroll the virtualized grid until the lines you have recorded equal the footer **1 - N of N Items**, record N, and log each scroll as `scroll`. Visible rows are not the full set until that match. If earlier rows leave the viewport, save extra `INV-nn.png` / `.txt` so every line is in a file. If after scrolling you still have fewer lines than N, write Lines read vs N in the `.txt` (a capture gap) and go on to the next invoice; do not guess missing lines.
- **Never click:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a GL, or any button that changes status, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens an invoice is labelled Edit or Run and it does not post, import, email, calculate, approve, complete, or save, treat it as View, log `view`, capture, and leave with Cancel or Back. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- If you open an edit form by accident, leave with Cancel or Back, never Save. Never Approve an invoice.
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab, then continue. Do not skip past a login wall.
- **Exports:** read-only CSV / Excel / PDF of a report or grid only, saved in the capture folder (move it here if the browser dropped it in Downloads). An export never changes data. Never use an export or sync that sends data somewhere else. Do not substitute a ReportViewer or other report for opening each invoice (F2 reports have no line detail). Do not open Ad hoc report (it needs a save).
- Snapshot (screenshot) before every click. Pick **CARY 1** / store **122** wherever a store picker exists. Do not audit CAMDEN SQUARE / 878. Do not open Toast or ADP.
- Do not ask hub q1–q5. Open every CARY 1 Cheney invoice **and credit memo** in 08/14–10/09/2026 from the TXN export. F2's **20** is an expected size only; the TXN export is the list. Do not stop at 20. Do not skip credit memos.

## File names and `pages.csv`

Create `C:\fhs\reports\invoices-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `TXN-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, whether controls look editable / greyed / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`TXN-02.png`, …). Do not skip numbers inside an area.

Areas (only these two): `TXN` (Cheney vendor Transactions tab for CARY 1, 08/14–10/09/2026 — export = the count to match), `INV` (each CARY 1 Cheney invoice and credit memo in that range, `invoiceId=`, view only).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or scroll or export.

- `time`: local ISO-8601 with offset (e.g. `2026-10-11T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, `scroll`, or `export`

No other action. Viewing an invoice is `view`. Scrolling the line grid is `scroll`. Do not click Map, Import, Approve, Complete, or any write. Invoice detail pages (`invoiceId=`) are allowed as **view** only.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, stop and ask the owner (runbook row 9). Do not open Toast.
2. Create `C:\fhs\reports\invoices-122\`. Write `pages.csv` with only the header row. Then capture every row in **Pages to capture**, in order. For each row: screenshot before the click; open the page; set the store to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate label is shown, plus Created by / Modified by if visible. Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\invoices-122\* -DestinationPath C:\fhs\reports\invoices-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\invoices-122.zip -Name invoices-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

R365 base: `https://fhs4021089.restaurant365.com/`. Confirmed R365 starts (use if the menu agrees): Vendors `/react/accounting/legacy/Vendors`; AP transactions `/react/accounting/ap-transactions?tab=transactions`; Inventory → Invoices `/react/inventory/invoices`; invoice detail `invoiceId=`. Confirm; unknown `(?)`. Do not open Toast.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| TXN | `TXN-01` Cheney Transactions tab (png/txt); `TXN-02` (or next `nn`) **export** of that tab for CARY 1, 08/14–10/09/2026; more `TXN-nn` if the list is paged; `TXN-nn-missing.txt` if no export was offered | Accounting → Vendors `/react/accounting/legacy/Vendors` → **Cheney Brothers, Inc.** → **Transactions**. Filter location **CARY 1**, dates **08/14/2026–10/09/2026** `(?)`. View, filter, export only | Every CARY 1 Cheney **invoice and credit memo** in range: number, date, total, type (invoice vs credit memo if shown), status. That export is the **count to match** and the list of pages to open under INV. F2 header export **20** is expected size only; do not stop at 20; do not skip credits. Leave with Cancel or Back, never Save |
| INV | One consecutive `INV-nn` run per opened invoice or credit memo (png + txt; csv/xlsx/pdf if a line-grid export is offered). Extra screens for scroll or header vs lines increment `nn`. Finder lists only if a TXN row will not open detail | From the TXN list, **open each** CARY 1 Cheney invoice and credit memo (`invoiceId=`, view only), in list order. Start `.txt` with `Invoice: <number>`. If a Transactions-tab row does not open detail, try Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions` or Inventory → Invoices `/react/inventory/invoices` with the same number, still view only, and say so in the `.txt`. Confirm; unknown `(?)`. Cancel/Back, never Save or Approve | **Header:** number, date, total, approval status, approval date, approver (write `not shown` if a field is absent). **Footer N** from **1 - N of N Items**. **Per line:** item, vendor item #, U of M, qty, each, total, GL, description (`not shown` if a column is absent). Scroll until lines read = N (log `scroll`) **or** use a read-only line-grid export if present (log `export`, say so in the `.txt`). Do not use a report instead of opening the invoice |

Do not capture storage locations, recipes, menu mapping, other vendors, store 878 / CAMDEN SQUARE, AP payments and checks, integrations, Documents to process, Items, Counts, templates, or ReportViewer as a stand-in for invoice lines.

## You may edit only

- Files under `C:\fhs\reports\invoices-122\` (png, txt, csv, xlsx, pdf, `pages.csv`)
- The zip `C:\fhs\reports\invoices-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open Toast or ADP.
- Do any forbidden action listed above. Click Map, Import, Re-import, Save, Submit, Approve, Complete, Post, Run-as-job, or change a GL. Do not approve, edit, map, or re-import any invoice.
- Write `docs/research/invoices-122.md` or any other repo file.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt without the owner signing in.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\invoices-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas TXN, INV. Every area has at least one `.png`/`.txt` or a `-missing.txt`. TXN has a `.csv`/`.xlsx`/`.pdf` export, or a `-missing.txt` that says no export was offered. INV has at least one `.png`/`.txt` (or line export) per opened invoice, or a `-missing.txt` for a TXN row that would not open.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `scroll`, `export`
4. No `pages.csv` URL with path segments `save`, `submit`, `post`, `approve`, `complete`, `create`, or `map` (case-insensitive). No edit / new / import / mapping **action** URL (a write). Viewing an invoice is allowed, and `invoiceId=` URLs are allowed as **view** only.
5. No `pages.csv` URL for Toast, ADP, or CAMDEN SQUARE / 878.
6. After the send step: the `send-report.ps1` line printed `MATCH`

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped).

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
