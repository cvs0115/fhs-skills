# Agent task · count-lines-122-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/count-lines-122-01.md`. Runs only after the plan review is APPROVE and the PC clone is refreshed.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/count-lines-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to R365 in Chrome, store **CARY 1**. Toast is not this task; do not open it.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) already counts 207 items on **CARY 1 - FHS Weekly Inventory**. 108 of those names had no Cheney receipt 08/14–10/09/2026. This task only **captures** plan areas 2–3, read-only: Item Details for each Approved CARY 1 count on or after 08/01/2026 (`CNT-*`), then older purchases (`ITM-*`, and maybe `TXN-*` / `INV-*`). You do not write the research note. You change nothing in R365. A later server agent writes the note from your files. Area 1 (pairing from invoices-122 captures) is not this task; do not recapture 08/14–10/09/2026.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tab where the owner is already signed in. Store 122: R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\count-lines-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/count-lines-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)
5. `docs/research/invoices-122.md` (the 108 names: Item last receipt rows whose Last Cheney receipt is `none in 8 weeks`). Copy those names exactly. Do not invent names.
6. `docs/research/items-122.md` CNT / ITM paths only as a start (Item Details export as `CNT-03.csv`; item detail `?purchaseItemId=`).

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there and in `docs/research/items-122.md` CNT/ITM paths and `docs/research/invoices-122.md` INV paths are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`. Do not follow the F2 capture (`docs/prompts/items-122-01-capture.md` INV rows). Do not recapture invoices-122 (`docs/prompts/invoices-122-01-capture.md` TXN/INV for 08/14–10/09/2026).

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening count, item and invoice detail pages to read, changing on-screen filters or date ranges, taking screenshots, saving page text, scrolling a grid, downloading a read-only report or grid CSV, Excel, or PDF.
- **CNT: Item Details export.** Open only **Approved** CARY 1 counts dated on or after 08/01/2026. For each, use the Item Details export (same export as items-122 `CNT-03.csv`). That export is the line evidence. Still save a `.png` and `.txt` of the count header (date, status, list total) and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the grid instead (log `scroll` if you scroll). Do not use Variance Review or COUNT ENTRY as the line source. **Do not open** an In Progress count (including 09/28/2026) for editing. Include the Approved **10/04/2026** count. ≈10 counts is expected size only; capture every Approved row in range; do not stop at 10.
- **ITM: three items first, then maybe all 108.** First open 3 of the 108 items' detail pages and save any purchase-history or last-cost view. If one exists **with dates**, use that same view for all 108 and **skip TXN and INV**. Else continue to TXN (header count first).
- **TXN: prefer export; header count first.** If invoices are in play and the Transactions tab (or AP transactions) offers Export / Download / Excel / CSV / PDF of the list, take that file. That export is the count to match. Still save a `.png` and `.txt` of the page header, row count, totals, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead. **Do not open INV until you have the header count.** **≤45 gate:** if that CARY 1 Cheney invoice-and-credit-memo count for 05/15–08/13/2026 is **more than 45**, write the count in the `.txt` and a `TXN-nn-missing.txt` that invoices were not opened, **stop and ask the owner**. Do not open those invoices. Do not continue to INV. Do not zip or send until the owner answers.
- **INV lines: export if present, else scroll.** Only if ITM had no dated purchase history **and** the TXN header count is **≤45**. If the invoice line grid has a read-only export button, use it instead of scrolling, log `export`, and say so in that invoice's `.txt`. The export is the line evidence. Still save a `.png` and `.txt` of the header, footer `1 - N of N Items`, approval fields, and ownership labels. If no line export exists, scroll the virtualized grid until the lines you have recorded equal the footer **1 - N of N Items**, record N, and log each scroll as `scroll`. Visible rows are not the full set until that match. If earlier rows leave the viewport, save extra `INV-nn.png` / `.txt` so every line is in a file. If after scrolling you still have fewer lines than N, write Lines read vs N in the `.txt` (a capture gap) and go on to the next invoice; do not guess missing lines.
- **Never click:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a cost/unit/GL, removing an item from a template, or any button that changes status, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens a count, an item, or an invoice is labelled Edit or Run and it does not post, import, email, calculate, approve, complete, or save, treat it as View, log `view`, capture, and leave with Cancel or Back. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- If you open an edit form by accident, leave with Cancel or Back, never Save. Never Approve or Complete a count. Never Approve an invoice. If you open an In Progress count by accident, leave with Cancel or Back, never Save.
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab, then continue. Do not skip past a login wall.
- **Exports:** read-only CSV / Excel / PDF of a report or grid only, saved in the capture folder (move it here if the browser dropped it in Downloads). An export never changes data. Never use an export or sync that sends data somewhere else. Do not substitute a ReportViewer or other report for opening each invoice. Do not open Ad hoc report (it needs a save).
- Snapshot (screenshot) before every click. Pick **CARY 1** / store **122** wherever a store picker exists. Do not audit CAMDEN SQUARE / 878. Do not open Toast or ADP.
- Do not ask hub q1–q5. The 108 names come from invoices-122.md. Do not recapture 08/14–10/09/2026. Do not skip credit memos on the 05/15–08/13 list. Do not stop at ≈10 counts.

## File names and `pages.csv`

Create `C:\fhs\reports\count-lines-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `CNT-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, whether controls look editable / greyed / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`CNT-02.png`, …). Do not skip numbers inside an area.

Areas: `CNT` (each Approved CARY 1 count dated on or after 08/01/2026 — Item Details export, same shape as items-122 `CNT-03.csv`), `ITM` (item detail for the 108: purchase-history or last-cost view if R365 shows dates), `TXN` / `INV` (CARY 1 Cheney invoices 05/15–08/13/2026 only if item detail had no dated purchase history; skipped if that history exists; not opened if the header count was >45).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or scroll or export.

- `time`: local ISO-8601 with offset (e.g. `2026-10-11T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, `scroll`, or `export`

No other action. Viewing a count, an item, or an invoice is `view`. Scrolling a grid is `scroll`. Do not click Map, Import, Approve, Complete, or any write. Count detail (`countId=`), item detail (`purchaseItemId=`), and invoice detail pages (`invoiceId=` / AP forms) are allowed as **view** only.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, stop and ask the owner (runbook row 9). Do not open Toast.
2. Create `C:\fhs\reports\count-lines-122\`. Write `pages.csv` with only the header row. Then capture every row in **Pages to capture**, in order (skip TXN and INV when the ITM row says to skip; stop before INV when the TXN row hits the >45 gate). For each row: screenshot before the click; open the page; set the store to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate label is shown, plus Created by / Modified by if visible. Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\count-lines-122\* -DestinationPath C:\fhs\reports\count-lines-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\count-lines-122.zip -Name count-lines-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

R365 base: `https://fhs4021089.restaurant365.com/`. Confirmed R365 starts (use if the menu agrees): Inventory counts `/react/inventory/inventory` (Item Details export as `CNT-03.csv` in items-122; 10/04 was `?countId=3`); Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` (ItemCost / Settings in items-122 `ITM-05`..`ITM-12`); Vendors `/react/accounting/legacy/Vendors`; AP transactions `/react/accounting/ap-transactions?tab=transactions`; invoice/credit-memo forms `#/form/APInvoiceForm/{id}` and `#/form/APCreditMemoForm/{id}`. Confirm; unknown `(?)`. Do not open Toast.

The 108 names are every Name in `docs/research/invoices-122.md` `## Item last receipt` whose Last Cheney receipt is `none in 8 weeks`. Copy them exactly.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| CNT | `CNT-01` counts list (png/txt; export if offered); then one consecutive `CNT-nn` run per opened Approved count (png + txt; Item Details csv/xlsx/pdf if offered). Extra screens for header vs lines increment `nn`. `CNT-nn-missing.txt` if a listed Approved count will not open or has no Item Details export | Inventory → Inventory counts `/react/inventory/inventory`, CARY 1. Open each **Approved** CARY 1 count dated on or after **08/01/2026**, including **10/04/2026**. Start each count `.txt` with `Count: <date> <status> list total <amount>`. **Do not open** In Progress (including 09/28/2026). View, filter, export only. Cancel/Back, never Save, Approve, or Complete | List: every CARY 1 row's date, status, list total. Per opened count: date, status, **list total**, ownership labels; **Item Details** lines (name, UofM, Current Qty, Current $ Cost, Current $ Total) — same export as items-122 `CNT-03.csv`. That export is the line evidence. Do not use Variance Review or COUNT ENTRY as the line source. ≈10 is expected size only; do not stop at 10 |
| ITM | Search/list screens as needed to open a name; then one consecutive `ITM-nn` run per opened item (png + txt; csv if a history grid exports). Start `.txt` with `Item: <name>`. Extra tabs increment `nn`. `ITM-nn-missing.txt` if a name will not open or has no purchase-history/last-cost view | Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` `(?)`. **First** open these 3 of the 108: **BEV APPLE JUICE ALL**, **BEV BOTTLE SODA**, **BEV BOTTLED WATER**. Save any purchase-history or last-cost view (last received date, ItemCost history, a purchases tab with dates). **If one of those three shows dates**, open the **same** view for **all 108** names and **skip TXN and INV** (do not recapture the 3). **If none of the three shows dates**, write `ITM-nn-missing.txt` that no dated purchase history was found, then continue to TXN. View only; Cancel/Back, never Save. Do not click cost recalculation or Update recipe costs | For each opened item: whether a purchase-history or last-cost view exists; any receipt dates, invoice numbers, vendor, qty, cost, U of M. "With dates" means a last-received date or a history grid with invoice/receipt dates, not Avg Cost alone |
| TXN | Only if ITM found no dated purchase history. `TXN-01` Cheney Transactions tab (png/txt); `TXN-02` (or next `nn`) **export** of that tab for CARY 1, 05/15–08/13/2026; more `TXN-nn` if the list is paged; `TXN-nn-missing.txt` if no export was offered. If AP transactions is how you get the header count, use the next `TXN-nn` for it | Accounting → Vendors `/react/accounting/legacy/Vendors` → **Cheney Brothers, Inc.** → **Transactions**. Filter location **CARY 1**, dates **05/15/2026–08/13/2026** `(?)`. And/or Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions` with the same filters. View, filter, export only. **Header count first.** Leave with Cancel or Back, never Save | Every CARY 1 Cheney **invoice and credit memo** in range: number, date, total, type (invoice vs credit memo if shown), status. That export (or the on-screen list if no export) is the **count for the ≤45 gate**. **If that count is >45, stop and ask the owner.** Write the count in the `.txt` and a `TXN-nn-missing.txt` that invoices were not opened. Do not open those invoices. Do not continue to INV |
| INV | Only if ITM found no dated purchase history **and** the TXN header count is **≤45**. One consecutive `INV-nn` run per opened invoice or credit memo (png + txt; csv/xlsx/pdf if a line-grid export is offered). Extra screens for scroll or header vs lines increment `nn`. Finder lists only if a TXN row will not open detail | From the TXN list, **open each** CARY 1 Cheney invoice and credit memo (`invoiceId=` / `#/form/APInvoiceForm/{id}` / `#/form/APCreditMemoForm/{id}`, view only), in list order. Start `.txt` with `Invoice: <number>`. If a Transactions-tab row does not open detail, try Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions` with the same number, still view only, and say so in the `.txt`. Confirm; unknown `(?)`. Cancel/Back, never Save or Approve | **Header:** number, date, total, approval status, approval date, approver (write `not shown` if a field is absent). **Footer N** from **1 - N of N Items**. **Per line:** item, vendor item #, U of M, qty, each, total, GL, description (`not shown` if a column is absent). Scroll until lines read = N (log `scroll`) **or** use a read-only line-grid export if present (log `export`, say so in the `.txt`). Do not use a report instead of opening the invoice. Do not skip credit memos. Do not recapture 08/14–10/09/2026 |

Do not capture storage locations, recipes, menu mapping, other vendors, store 878 / CAMDEN SQUARE, AP payments and checks, integrations, Documents to process, count templates, ReportViewer as a stand-in for invoice lines, Cheney's own website or order guide, the 99 items Cary 1 did buy in 8 weeks, or invoices dated 08/14–10/09/2026.

## You may edit only

- Files under `C:\fhs\reports\count-lines-122\` (png, txt, csv, xlsx, pdf, `pages.csv`)
- The zip `C:\fhs\reports\count-lines-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open Toast or ADP.
- Do any forbidden action listed above. Click Map, Import, Re-import, Save, Submit, Approve, Complete, Post, Run-as-job, or change a cost/unit/GL. Do not approve, edit, map, or re-import any invoice. Do not open an In Progress count for editing. Do not remove an item from a template.
- Write `docs/research/count-lines-122.md` or any other repo file.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt without the owner signing in.
- Open INV when the header count is >45, or open TXN/INV after a dated ITM purchase-history view.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\count-lines-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas CNT, ITM. Every required area has at least one `.png`/`.txt` or a `-missing.txt`. CNT has an Item Details `.csv`/`.xlsx`/`.pdf` for each opened Approved count, or a `-missing.txt` that says no export was offered. ITM has at least one `.png`/`.txt` (or `-missing.txt`) for each of the 3 probe items, and for all 108 if dated history was used. TXN and INV files exist only if invoices were in play; if dated ITM history was used, TXN/INV may be absent. If the >45 gate stopped the run, TXN has the header count and a `-missing.txt`, and INV is absent.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `scroll`, `export`
4. No `pages.csv` URL with path segments `save`, `submit`, `post`, `approve`, `complete`, `create`, `edit`, or `map` (case-insensitive). No edit / new / import / mapping **action** URL (a write). Viewing a count, an item, or an invoice is allowed; `countId=`, `purchaseItemId=`, `invoiceId=`, `APInvoiceForm`, and `APCreditMemoForm` URLs are allowed as **view** only.
5. No `pages.csv` URL for Toast, ADP, or CAMDEN SQUARE / 878.
6. After the send step: the `send-report.ps1` line printed `MATCH` (skip this test if you stopped at the >45 gate and the owner has not said to send)

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped), including whether invoices were skipped (dated ITM history) or stopped at the >45 gate.

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
