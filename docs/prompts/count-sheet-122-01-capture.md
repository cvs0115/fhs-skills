# Agent task · count-sheet-122-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/count-sheet-122-01.md`. Runs only after the plan review is APPROVE and the PC clone is refreshed.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/count-sheet-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to R365 in Chrome, store **CARY 1**. Toast is not this task; do not open it.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) already counts 207 items on **CARY 1 - FHS Weekly Inventory**. 45 of those names look unused. This task only **captures** plan parts 2–3, read-only: template ownership (`TPL-*`, then `ITM-*` for 3 items), then store runs (`VND-*` / `APF-*` / `EXP-*` / `TXN-*`). You do not write the research note or the tick list. You change nothing in R365. A later server agent writes the note from your files. Part 1 (the 45-line tick list) is not this task; do not recapture count-lines or invoices-122. The hide itself is count-sheet-122-02, planned later.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tab where the owner is already signed in. Store 122: R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\count-sheet-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/count-sheet-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)
5. `docs/research/items-122.md` TPL / ITM paths only as a start (templates `/react/inventory/inventory/settings` then `?templateId=`; item detail `?purchaseItemId=`).

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there, in `docs/research/items-122.md` TPL/ITM paths, and in `docs/research/store-audit-122.md` F5 (207 items, CAMDEN twin) are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`. Do not follow the F2 capture (`docs/prompts/items-122-01-capture.md`) beyond those TPL starts. Do not recapture count-lines (`docs/prompts/count-lines-122-01-capture.md`) or invoices-122 (`docs/prompts/invoices-122-01-capture.md`). Do not reopen F2–F13 (`docs/prompts/store-audit-122-02-capture.md`).

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening a blank form to read its fields then Cancel or Close, changing on-screen filters or date ranges, taking screenshots, saving page text, scrolling a grid, downloading a read-only report or grid CSV, Excel, or PDF.
- **Prefer export.** If a template item list or AP list offers Export / Download / Excel / CSV / PDF, take that file. That export is the evidence. Still save a `.png` and `.txt` of the page header, row count, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead (log `scroll` if you scroll).
- **Never click:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map, Map/assign an item, Edit, Delete, Create (other than once to open the blank AP-invoice form), New (same exception), Add (same exception), Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, Remove from template, changing a cost/unit/GL, or any button that changes status, or any toggle and checkbox that persists, or an Edit-mode toggle that locks a record. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens a template, an item, or a list is labelled Edit or Run and it does not post, import, email, calculate, approve, complete, save, inactivate, or remove from a template, treat it as View, log `view`, capture, and leave with Cancel or Back. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- **Blank AP form:** you may click Create, New, or Add **once** to open the new-AP-invoice form, only to read its field labels. Log `view`. Leave with Cancel or Close, never Save. Do not type into the form except as needed to leave it. If it cannot be closed without saving, write `APF-nn-missing.txt`, **stop and ask the owner**. Do not zip or send until the owner answers. Do not continue to EXP or TXN. Do not click Create/New/Add for a vendor or anything else.
- If you open an edit form by accident, leave with Cancel or Back, never Save. If you open an In Progress count by accident, leave with Cancel or Back, never Save. Never Approve or Complete a count. Never Approve an invoice. **Do not open** an In Progress count for editing. Do not open Ad hoc report (it needs a save).
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab. Do not skip past a login wall. Do not zip or send until the owner answers. Do not open anything else first.
- **Exports:** read-only CSV / Excel / PDF of a report or grid only, saved in the capture folder (move it here if the browser dropped it in Downloads). An export never changes data. Never use an export or sync that sends data somewhere else. Do not open Ad hoc report (it needs a save).
- Snapshot (screenshot) before every click. Pick **CARY 1** / store **122** wherever a store picker exists. Open **CAMDEN SQUARE - FHS Weekly Inventory** **header only** (compare `templateId` / URL, created/modified, item count). Do not change that template. Do not capture its full item list. Do not otherwise audit store 878. Do not open Toast or ADP.
- Do not ask hub q1–q5. Do not recapture count-lines or invoices-122. Do not reopen F2–F13. Do not fill Keep?. Do not hide or remove a line. Do not create a vendor.

## File names and `pages.csv`

Create `C:\fhs\reports\count-sheet-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `TPL-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, every button and menu shown as text not clicked — label, enabled or greyed — whether controls look editable / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`TPL-02.png`, …). Do not skip numbers inside an area.

Areas: `TPL` (CARY 1 - FHS Weekly Inventory detail: item list, buttons/menus as text not clicked, created/modified, location or brand, history/audit tab if shown; CAMDEN SQUARE - FHS Weekly Inventory **header only**), `ITM` (item detail for these 3 of the 45 only: **BEV APPLE JUICE ALL**, **CLEAN MOP HEAD**, **PAPER FD SM SALAD BOWL** — per-location or count-template setting), `VND` (Vendors search: Costco, Sam's, Walmart, Food Lion, Harris Teeter, "store", "petty"), `APF` (blank new-AP-invoice form, read fields, closed without saving), `EXP` (any expense / receipt / credit-card screen found, or the menus searched if none), `TXN` (AP transactions for CARY 1, any non-Cheney vendor since 05/15/2026 — the count to record; expected 0).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or scroll or export.

- `time`: local ISO-8601 with offset (e.g. `2026-10-12T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, `scroll`, or `export`

No other action. A blank-form open is `view` and must be closed with Cancel or Close. Template detail (`templateId=`), item detail (`purchaseItemId=`), vendor list, AP list, and the blank AP-invoice form are allowed as **view** only. A `create` / `new` URL is allowed only for that one blank-form open that was closed without save. Do not click Save, Submit, Approve, Complete, Create (except that one form), Delete, Remove, Inactivate, or any write.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, stop and ask the owner (runbook row 9). Do not open Toast.
2. Create `C:\fhs\reports\count-sheet-122\`. Write `pages.csv` with only the header row. Then capture every row in **Pages to capture**, in order (stop before EXP and TXN if the APF row hits the blank-form gate). For each row: screenshot before the click; open the page; set the store to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate / "managed by" label is shown, plus Created by / Modified by if visible. On the CARY 1 template page, list every button and menu (label, enabled or greyed). Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\count-sheet-122\* -DestinationPath C:\fhs\reports\count-sheet-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\count-sheet-122.zip -Name count-sheet-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

R365 base: `https://fhs4021089.restaurant365.com/`. Confirmed R365 starts (use if the menu agrees): Inventory → Inventory counts → gear → templates `/react/inventory/inventory/settings` then **CARY 1 - FHS Weekly Inventory** `?templateId=` (items-122 TPL); Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=`; Accounting → Vendors `/react/accounting/legacy/Vendors`; Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; invoice form `#/form/APInvoiceForm` (blank/new path `(?)`). Menu paths for expense, receipt, or credit-card screens are unknown `(?)` until this capture. Confirm; unknown `(?)`. Do not open Toast.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| TPL | `TPL-01` templates list (png/txt; export if offered); then `TPL-nn` opened **CARY 1 - FHS Weekly Inventory** (png + txt; item-list csv/xlsx/pdf if offered). Extra screens for buttons vs list vs history/audit tab increment `nn`. Then `TPL-nn` **CAMDEN SQUARE - FHS Weekly Inventory** header only (png + txt; no item-list export). `TPL-nn-missing.txt` if a named template will not open | Inventory → Inventory counts → gear → templates `/react/inventory/inventory/settings` then **CARY 1 - FHS Weekly Inventory** `?templateId=` (items-122 TPL). View only. Cancel/Back, never Save. Do not click Remove from template or Inactivate. Open the CAMDEN header after CARY 1 detail; leave it without changing it | CARY 1: item list; **every button and menu shown** (as text, not clicked: label, enabled or greyed); created/modified; any location or brand field; any history or audit tab (open the tab if shown; view only). Start the CARY 1 `.txt` with `Template: CARY 1 - FHS Weekly Inventory templateId=<id> items=<n>`. CAMDEN header only: `templateId` / URL, created/modified, item count. Do not capture CAMDEN's full item list |
| ITM | Search/list screens as needed to open a name; then one consecutive `ITM-nn` run per opened item (png + txt). Start `.txt` with `Item: <name>`. Extra tabs increment `nn`. `ITM-nn-missing.txt` if a name will not open or has no per-location / count-template setting | Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` `(?)`. Open these **3 of the 45 only**: **BEV APPLE JUICE ALL**, **CLEAN MOP HEAD**, **PAPER FD SM SALAD BOWL**. View only; Cancel/Back, never Save. Do not click Inactivate or Remove from template. Do not open the other 42 | For each opened item: any per-location or count-template setting (for example Inactive, or "count at location"); whether that control is shown and enabled or greyed. Write `not shown` in the `.txt` if absent |
| VND | `VND-01` Vendors list; then one `VND-nn` per search (png + txt; csv if the grid exports). Start `.txt` with `Search: <term>`. `VND-nn-missing.txt` if a search will not run | Accounting → Vendors `/react/accounting/legacy/Vendors`. Search / filter only for **Costco**, **Sam's**, **Walmart**, **Food Lion**, **Harris Teeter**, **store**, and **petty**. Do not create a vendor. Do not click New/Add on this page. View, filter, export only | Whether a matching vendor row exists (name as shown). A search with **no** row is still a capture, not a missing page |
| APF | `APF-01` blank new-AP-invoice form (png + txt of field labels). Extra screens increment `nn`. `APF-nn-missing.txt` if the form will not open, or if it cannot be closed without saving | Open the new-AP-invoice form (`#/form/APInvoiceForm`, blank/new path `(?)`). You may click Create, New, or Add **once** for this form only. Log `view`. Leave with Cancel or Close, never Save. If it cannot be closed without saving, **stop and ask the owner**. Do not continue to EXP or TXN. Do not zip or send until the owner answers | Every field label shown; that it was closed with Cancel or Close (write that in the `.txt`) |
| EXP | One `EXP-nn` run per expense / receipt / credit-card screen found (png + txt). If none, `EXP-nn` of the menus searched plus `EXP-nn-missing.txt` that none was found | Look under every menu for a screen whose title or labels are expense, receipt, or credit-card `(?)`. Open and capture each one found. View only; Cancel/Back, never Save. Do not reopen F2–F13. Do not open Ad hoc report | Title as shown, field labels. If none, the menus you opened are the evidence that none was seen |
| TXN | `TXN-01` AP transactions (png/txt); `TXN-nn` **export** of that list if offered; more `TXN-nn` if paged; `TXN-nn-missing.txt` if no export was offered | Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`. Filter location **CARY 1**, dates **since 05/15/2026**, any **non-Cheney** vendor. View, filter, export only. Do not open those rows unless needed to read the count. Cancel/Back, never Save | The **count** of CARY 1 non-Cheney AP rows in range (expected 0). Write `CARY 1 non-Cheney AP rows since 05/15/2026: <n>` in the `.txt`. That export (or the on-screen list if no export) is the count. If a vendor filter cannot exclude Cheney, capture the list and count the non-Cheney rows; do not guess |

Do not capture count history, Cheney invoices, storage locations, recipes, menu mapping, other vendors, store 878 / CAMDEN SQUARE beyond the template header, AP payments and checks, integrations, Documents to process, Ad hoc report, F2–F13, the 31 slow movers, the 32 can't-tell lines, Costco or grocery receipts, or bank or card statements. Do not recapture count-lines or invoices-122.

## You may edit only

- Files under `C:\fhs\reports\count-sheet-122\` (png, txt, csv, xlsx, pdf, `pages.csv`)
- The zip `C:\fhs\reports\count-sheet-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open Toast or ADP.
- Do any forbidden action listed above. Click Map, Import, Re-import, Save, Submit, Approve, Complete, Post, Run-as-job, Inactivate, Remove from template, or change a cost/unit/GL. Do not open an In Progress count for editing. Do not add a vendor. Do not save an AP invoice or draft. Do not click Create/New/Add except the one blank AP-invoice form.
- Write `docs/research/count-sheet-122.md` or any other repo file. Fill Keep?. Hide or remove a count-template line.
- Recapture count-lines or invoices-122. Reopen F2–F13. Write count-sheet-122-02. Touch payroll or `browser-02`.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt or a blank-form stop without the owner answering.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\count-sheet-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas TPL, ITM, VND, APF, EXP, TXN. Every required area has at least one `.png`/`.txt` or a `-missing.txt`. TPL has CARY 1 detail and a CAMDEN header capture. ITM has at least one `.png`/`.txt` (or `-missing.txt`) for each of the 3 names. VND has a file for each of the 7 searches. APF has the blank form closed with Cancel/Close, or a `-missing.txt` that it could not be closed without saving. EXP has each screen found, or the menus searched plus a `-missing.txt` that none was found. TXN has the count in a `.txt` (and an export, or a `-missing.txt` that no export was offered). If the blank-form gate stopped the run, TPL/ITM/VND exist, APF has that `-missing.txt`, and EXP/TXN may be absent.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `scroll`, `export`
4. No `pages.csv` URL with path segments `save`, `submit`, `approve`, `complete`, `post`, `create`, `edit`, `map`, `delete`, `remove`, or `inactivate` (case-insensitive), except template detail (`templateId=`), item detail (`purchaseItemId=`), and the blank AP-invoice form (`APInvoiceForm` and/or a `create`/`new` URL) whose action is `view`. A `create`/`new` URL is allowed only for that one blank-form open. Vendor list and AP list are allowed as **view** only.
5. No `pages.csv` URL for Toast or ADP. CAMDEN SQUARE / 878 only as the template-header view (`templateId=`).
6. After the send step: the `send-report.ps1` line printed `MATCH` (skip this test if you stopped at the blank-form gate or a login/MFA prompt and the owner has not said to send)

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped), including whether capture stopped at the blank AP form or a login / MFA prompt.

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
