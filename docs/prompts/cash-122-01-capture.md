# Agent task · cash-122-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Drafted by Cursor Grok 4.6 High from `docs/briefs/cash-122-01.md`. Runs only after the plan review is APPROVE and the PC clone is refreshed.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/cash-122-01-capture.md". Start only after runbook row 9 (clone, restricted key, alias) and the owner signed in to **Toast and R365** in Chrome, restaurant **00122 - Cary 1**, store **CARY 1**. ADP is not this task; do not open it. **Must not share the PC with another lane's capture at the same time.**

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) takes in cash, card and other tenders;
Toast pays card money to the bank, and R365 Daily Sales Summary should show the deposit. This task
only **captures** plan parts 1–2, read-only: Toast sales / payouts / External / drawers / deposit
records (`SAL-*` / `PAY-*` / `EXT-*` / `CDR-*` / `TDP-*`), then R365 Daily Sales Summary (`DSS-*`).
You do not write the research note or join the rows. You change nothing in Toast or R365. A later
server agent writes the note from your files. Part 3 (optional owner bank CSV) is not downloaded by
you. Part 4 (the join) is not this task.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tabs where the owner is already signed in. Store 122: Toast restaurant **00122 - Cary 1**, R365 location **CARY 1**.
- Captures (outside the repo): `C:\fhs\reports\cash-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.
- Must not share the PC with another lane's capture at the same time.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/cash-122-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` row 9 (PC clone, restricted key, alias) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)
5. `docs/research/store-audit-122.md` F8 / F9 paths only as a start (Payout overview `F8-02` / `F8-03`; Cash Drawer History `F8-04`; Daily sales `/react/sales-and-forecasting/daily-sales` `F9-01`).

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there, in `docs/research/store-audit-122.md` F8 / F9, and in this file are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`. Do not follow the F8/F9 capture (`docs/prompts/store-audit-122-02-capture.md`) beyond those path starts. Do not recapture F2–F7 or F10–F12. Do not recapture F8-01 bank reconciliations, F9-02 weekly overview, F9-03 subscriptions, or F13. Do not recapture recipes-122, count-sheet-122, items-122, invoices-122, or count-lines-122. Do not use the audit's month-to-date payout totals as this range's evidence.

## Hard rules (read twice)

- **Read-only.** Allowed: view, filter, scroll, export/download. Navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text. Open a payout detail or an R365 day to read it, then Close / Cancel.
- **Prefer export.** If a Toast report or an R365 DSS grid offers Export / Download / Excel / CSV / PDF, take that file. That export is the evidence. Still save a `.png` and `.txt` of the page header, row count, report name, dates, totals, and ownership labels. If the export is the current page only, page through and export each page (increment `nn`). If no export exists, write `<area>-<nn>-missing.txt` saying what you searched and capture `.png` / `.txt` of every page of the list instead (log `scroll` if you scroll).
- **Never click:** Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Sync, Run, Send, Pay, Close day, Close out drawer, Deposit, Cash out, Reconcile, any persistent toggle or checkbox, any settings page edit. No user or permission changes. Do not open Ad hoc report (it needs a save). You may click navigation links, tabs, menu items, and report **View** controls. Opening **Payout overview** and payout detail is **view**, not Pay. Expanding a DSS **Deposits** area on an already-open day is **view**, not Deposit. If the only control that opens a report, a payout, or a DSS day is labelled Edit, Run, Generate, or Update and it does not Save, Submit, Approve, Complete, Post, Create, New, Add, Delete, Import, Sync, Send, Pay, Close day, Close out drawer, Deposit, Cash out, or Reconcile, treat it as View, log `view`, capture, and leave with Close or Cancel. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- **R365 DSS day:** open **view only**. The status / Complete control is not clicked. Expanding Deposits can make Save clickable (`docs/research/store-audit-122.md` F8 / tech-stack Daily sales); **do not click Save**. Leave with Cancel/Close. If it cannot be closed without saving, write `DSS-nn-missing.txt`, **stop and ask the owner**. Do not zip or send until the owner answers. Do not open another day first.
- If you open an edit form by accident, leave with Cancel or Close, never Save. If expanding a section makes Save clickable, do not click Save; screenshot what is already visible and leave. Do not open Ad hoc report (it needs a save).
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab. Do not skip past a login wall. Do not zip or send until the owner answers. Do not open anything else first.
- **Exports:** download a CSV or XLSX/PDF of a report or grid: allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\cash-122\` with the other captures (move the file here if the browser dropped it in Downloads). Record the report name and path as shown. An export never changes data. Never use an export or sync that sends data somewhere else. Do not open Ad hoc report (it needs a save).
- Snapshot (screenshot) before every click. Pick restaurant **00122 - Cary 1** in Toast and **CARY 1** / store **122** in R365 wherever a store picker exists. Date range for every Toast and R365 filter: **09/28/2026–10/11/2026** (both weeks). Do not open CAMDEN SQUARE days. Do not audit store 878 / CAMDEN SQUARE. Do not open ADP, a bank website, or Toast/R365 bank-account settings.
- Any misclick goes in the matching `.txt` (and later the note's `## Deviations`); not a new allowed action.
- Do not ask hub q1–q5. Do not recapture F2–F7 or F10–F12. Do not write the research note. Do not enter a deposit, mark a day Completed, close a drawer, or move money. Do not download a bank statement. If `BNK-*` is already in the capture folder, leave it and include it in the zip; do not open it; do not copy numbers from it into other files. In any `.txt` you write, last 4 of an account or card only.

## File names and `pages.csv`

Create `C:\fhs\reports\cash-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `SAL-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, totals, errors, report name and path, every button and menu shown as text not clicked — label, enabled or greyed — whether controls look editable / franchise-labelled, Created by / Modified by). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.xlsx` or `<area>-<nn>.pdf`
- Missing page or missing export: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view` (or `export` if you tried an export control that produced nothing).
- Extra screens for the same page: increment `nn` (`SAL-02.png`, …). Do not skip numbers inside an area.

Areas: `SAL` (Toast sales summary by day with tenders: cash, card, other, External; restaurant **00122 - Cary 1**; dates **09/28/2026–10/11/2026**; report name and path as seen), `PAY` (Payout overview for that range, payout list, each payout's detail: sales date it covers, fees, External), `EXT` (drill-down behind "External (not settled by Toast)", or `EXT-*-missing.txt`), `CDR` (Cash & loss management → cash drawer overview / history per day), `TDP` (any Toast deposit or "cash out / deposit" record and its fields, or `TDP-*-missing.txt` if none), `DSS` (R365 Daily Sales Summary list for CARY 1, the 14 days; one day's Deposits area view-only; one Completed CARY 1 day up to 10/05 view-only), `BNK` (optional owner bank-statement CSV already in this folder, e.g. `BNK-01.csv`; the PC agent does not download it and does not open the bank).

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or scroll or export or close.

- `time`: local ISO-8601 with offset (e.g. `2026-10-12T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, `scroll`, `export`, or `close`

No other action. Payout detail and DSS day pages are allowed as **view** only and must be closed with Cancel/Close (`close`). Do not click Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Sync, Run, Send, Pay, Close day, Close out drawer, Deposit, Cash out, Reconcile, or any write. A `create` / `new` URL is never allowed.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to Toast (`https://www.toasttab.com/restaurants/admin/`, restaurant **00122 - Cary 1**) and R365 (`https://fhs4021089.restaurant365.com/`) on **CARY 1**, or another lane is using the PC for capture, stop and ask the owner (runbook row 9). Do not open ADP, a bank website, or Toast/R365 bank-account settings.
2. Create `C:\fhs\reports\cash-122\`. Write `pages.csv` with only the header row. If `BNK-*` is already in that folder, leave it. Then capture every row in **Pages to capture**, in order (Toast both weeks, then R365 DSS; stop if a DSS row hits the Save gate). For each row: screenshot before the click; open the page; set Toast to **00122 - Cary 1** and R365 to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; **export when the page offers it** (do not wait for the row to say the word export); append `pages.csv`. Close every payout detail and every DSS day with Cancel/Close (log `close`).
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a Brand / Location group / franchise / corporate / "managed by" label is shown, plus Created by / Modified by if visible. Start every area's first `.txt` with `Dates: 09/28/2026–10/11/2026`. Do not create a separate ownership area.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\cash-122\* -DestinationPath C:\fhs\reports\cash-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\cash-122.zip -Name cash-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

Toast base: `https://www.toasttab.com/restaurants/admin/`. R365 base: `https://fhs4021089.restaurant365.com/`. Known starts (confirm; unknown `(?)`): Toast Reports → Sales summary (by day, tenders); Toast Reports → Payments → Payout overview (audit `F8-02` / `F8-03`); Toast Reports → Cash & loss management → cash drawer overview / Cash Drawer History (audit `F8-04`); R365 Sales & forecasting → Daily sales summary `/react/sales-and-forecasting/daily-sales` (audit `F9-01`). External drill-down and Toast deposit / "cash out / deposit" paths `(?)` until this capture. Date range for every Toast and R365 filter: **09/28/2026–10/11/2026** (both weeks). Do not open CAMDEN SQUARE days. Do not open ADP.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| SAL | `SAL-01` report home or list (png/txt); then `SAL-nn` **sales summary by day with tenders** (png + txt; csv/xlsx/pdf if offered). Extra screens increment `nn`. `SAL-nn-missing.txt` if the named report will not open or will not export | Toast Reports → Sales summary (by day, tenders) `(?)`. Restaurant **00122 - Cary 1**. Dates **09/28/2026–10/11/2026**. View, filter, export only. Do not open Menu manager. Do not change a menu or a price | Start `.txt` with `Dates: 09/28/2026–10/11/2026`. Write `Report: <name>` and `Path: <menu path or URL as seen>`. Per day: net sales, cash, card, other, External. If External is not split from other, capture other as shown and say so in the `.txt` |
| PAY | `PAY-01` Payout overview for **09/28/2026–10/11/2026** (png + txt; csv/xlsx/pdf if offered); `PAY-nn` payout list; then one `PAY-nn` **each payout's detail** (png + txt), then Close (`close`). Extra screens increment `nn`. `PAY-nn-missing.txt` if overview or a detail will not open | Toast Reports → Payments → Payout overview (audit `F8-02` / `F8-03` as a start only). Set the range to **09/28/2026–10/11/2026**, not "this month". View, filter, export, close only. Open each payout in that list to read it, then Close. Do not click Pay | Overview **card**, **External (not settled by Toast)**, and **payout** totals for **this** range (do not copy the audit MTD figures). Each detail: which sales date it covers, fees, External. Start each detail `.txt` with `Payout: <date> <amount>`. Write in the `.txt` that the detail was closed with Close |
| EXT | `EXT-01` drill-down behind **External (not settled by Toast)** (png + txt; csv/xlsx if offered). Extra screens increment `nn`. `EXT-nn-missing.txt` if no drill-down exists | From Payout overview, the External line `(?)`. View, filter, export, close only. Do not click Pay | What External is as Toast shows it (labels, amounts, any named source). If the line is not clickable, that search page plus `EXT-nn-missing.txt` is the evidence |
| CDR | `CDR-01` cash drawer overview (png + txt; export if offered); `CDR-nn` Cash Drawer History for **09/28/2026–10/11/2026**, per day (png + txt; csv/xlsx/pdf if offered). If the page shows only one day, increment `nn` for each of the 14 days. `CDR-nn-missing.txt` if a named page will not open | Toast Reports → Cash & loss management → cash drawer overview / Cash Drawer History (audit `F8-04` as a start only). View, filter, export only. Do not click Close day, Close out drawer, Deposit, or Cash out | Per-day drawer figures (starting cash, cash in, cash out / paid-out as Toast labels them, ending cash). Write `Report: <name>` and `Path:` as seen |
| TDP | `TDP-nn` each Toast deposit or "cash out / deposit" record found (png + txt; export if offered). Extra screens increment `nn`. `TDP-*-missing.txt` if none | Look under Reports and Cash & loss management for a deposit / "cash out / deposit" **record or report** `(?)`. View, filter, export only. **Do not click** Deposit, Cash out, Close day, or Close out drawer | Fields a Toast-recorded deposit shows (date, amount, drawer, status), or `TDP-*-missing.txt` (what you searched, what you saw instead). A report named Deposits is view; the Deposit **button** is forbidden |
| DSS | `DSS-01` Daily Sales Summary list for CARY 1, dates **09/28/2026–10/11/2026** (png + txt; csv/xlsx if offered); then `DSS-nn` **one** day's detail **view only** on its Deposits area (png + txt), then Cancel/Close (`close`); then `DSS-nn` **one** CARY 1 day up to **10/05** marked Completed, view only (png + txt), then Cancel/Close (`close`). Extra screens increment `nn`. `DSS-nn-missing.txt` if the list will not open, no Completed day ≤10/05 is found, or a day cannot be closed without saving | R365 Sales & forecasting → Daily sales summary `/react/sales-and-forecasting/daily-sales` (audit `F9-01`). Location **CARY 1** only. View, filter, scroll, export, close only. Open a day **view only**. The status / Complete control is not clicked. Expand Deposits if shown; **do not click Save**. Leave with Cancel/Close. If it cannot be closed without saving, **stop and ask the owner**. Do not zip or send until the owner answers. Do not open CAMDEN SQUARE days. A Completed day ≤10/05 may be before 09/28; open **one** such CARY 1 day only, then Cancel/Close. If the Deposits sample day is also that Completed day, one open is enough (record both in the `.txt`) | List: 14 days, net sales, deposit, Over/Short, status. Deposits sample: the fields a deposit entry needs, the Over/Short formula as shown, the status/Complete control (label, enabled or greyed — **not clicked**). Completed sample: who/when completed and what deposit shows. Write in each day `.txt` that it was closed with Cancel/Close |

Do not capture bank reconciliation, bank-account settings, AR customers, weekly overview, report subscriptions, count history, invoices, storage locations, recipes, menu mapping, vendors, AP, F2–F7, F10–F12, F13, store 878 / CAMDEN SQUARE, Toast Menu manager, payroll, Ad hoc report, integrations, or ADP. Do not recapture store-audit F8/F9 beyond the path starts above, recipes-122, count-sheet-122, items-122, invoices-122, or count-lines-122. Do not enter a deposit. The PC agent does not download a bank CSV and does not open the bank.

## You may edit only

- Files under `C:\fhs\reports\cash-122\` (png, txt, csv, xlsx, pdf, `pages.csv`; leave any owner `BNK-*` as-is)
- The zip `C:\fhs\reports\cash-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open ADP, a bank website, or Toast/R365 bank-account settings.
- Do any forbidden action listed above. Click Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Sync, Run, Send, Pay, Close day, Close out drawer, Deposit, Cash out, Reconcile, any persistent toggle or checkbox, or any settings page edit. No user or permission changes. Do not open Ad hoc report.
- Write `docs/research/cash-122.md` or any other repo file.
- Recapture F2–F7 or F10–F12. Recapture recipes-122, count-sheet-122, items-122, invoices-122, or count-lines-122. Touch payroll or `browser-02`. Share the PC with another lane's capture.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt or a DSS Save-gate stop without the owner answering.
- Print a full bank account number or card number in any `.txt` you write (last 4 only).

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\cash-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas SAL, PAY, EXT, CDR, TDP, DSS. Every required area has at least one `.png`/`.txt` or a `-missing.txt`. SAL has sales summary by day with tenders for **09/28/2026–10/11/2026**; the `.txt` has `Dates:`, `Report:`, and `Path:`. PAY has Payout overview for that range (card / External / payout totals) and each payout's detail closed with Close. EXT has the External drill-down or `EXT-*-missing.txt`. CDR has cash drawer overview / history covering the 14 days. TDP has a deposit / "cash out / deposit" record or `TDP-*-missing.txt`. DSS has the 14-day CARY 1 list, one Deposits-area view-only closed with Cancel/Close, and one Completed CARY 1 day up to 10/05 closed with Cancel/Close (or a `-missing.txt` that none was found). `BNK-*` is optional (present or absent is both fine). If the DSS Save gate stopped the run, SAL/PAY/EXT/CDR/TDP exist, DSS has that `-missing.txt`, and later DSS day files may be absent.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `scroll`, `export`, `close`
4. No `pages.csv` URL with path segments `save`, `submit`, `approve`, `complete`, `post`, `create`, `new`, `add`, `edit`, `delete`, `import`, `sync`, `run`, `send`, `pay`, `reconcile`, `close-day`, `closeout`, `close-out`, or `cash-out` (case-insensitive), except Toast report / payments / payout / cash-drawer URLs whose action is `view`, `filter`, `export`, or `close` (paths may match `pay`), and R365 `daily-sales` URLs whose action is `view`, `filter`, `export`, or `close` (even if the path contains deposit). Payout detail and DSS day pages must be `view` or `close`. A `create` / `new` URL is never allowed.
5. No `pages.csv` URL for ADP, a bank website, or Toast/R365 bank-account / bank-reconciliation settings. No CAMDEN SQUARE / 878. Toast and R365 only.
6. After the send step: the `send-report.ps1` line printed `MATCH` (skip this test if you stopped at the DSS Save gate or a login / MFA prompt and the owner has not said to send)

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped), whether a `BNK-*` file was already in the folder, and whether capture stopped at the DSS Save gate or a login / MFA prompt.

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
