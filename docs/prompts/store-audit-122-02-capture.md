# Agent task · store-audit-122-02 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Test-style, read-only. Written with its plan (`docs/reviews/store-audit-122-02.md`: APPROVE).
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/store-audit-122-02-capture.md". Start only after runbook rows 9–10 (clone, restricted key, alias; owner signed in to R365 and Toast in Chrome).

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) uses Toast and R365. Labor and tips already
work for payroll. This task only **captures** what those two systems already show for each back-office
function F2–F13, plus licensed modules, Toast → R365 integration, and who owns each setting. You do
not write the research note. You change nothing in R365 or Toast. A later server agent writes the
note from your files.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read the clone. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tabs where the owner is already signed in. Store 122: R365 location **CARY 1**, Toast restaurant **366968** (picker: **00122 - Cary 1**).
- Captures (outside the repo): `C:\fhs\reports\store-audit-122\`
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- Do not use a Cursor agent, Playwright MCP, Chrome DevTools MCP, or the server browser. `browser-02` stays parked.

## Read first

1. This file (the assignment)
2. `CLAUDE.md`
3. `docs/plans/store-audit-122-02.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/RUNBOOK.md` rows 9–10 (PC clone, restricted key, alias; signed in to R365 and Toast in Chrome) and `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)

Do not copy numbers from `skills/fhs-skills/references/tech-stack.md`. Known URLs there are only a start if the menu path matches. Menu paths below are typical; confirm the real path and mark unknown ones `(?)`.

## Hard rules (read twice)

- **Read-only.** Allowed: navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text, downloading a read-only report CSV or PDF.
- **Never click:** Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. You may click navigation links, tabs, menu items, and report **View** controls. If the only control that opens an on-screen report is labelled Run and it does not post, import, email, or calculate, treat it as View, log `view`, and capture. If unsure, skip that control, write `<area>-<nn>-missing.txt`, and continue.
- If you open an edit form by accident, leave with Cancel or Back, never Save. If expanding a section makes Save clickable (daily sales deposits do this), do not click Save; screenshot what is already visible and leave.
- **Never type credentials.** Claude in Chrome never types a username, password, or MFA code. A login or MFA prompt means **stop and ask the owner** to sign in in that tab, then continue. Do not skip past a login wall.
- **Exports:** read-only CSV/PDF of a report only, saved in the capture folder. An export never changes data. Never use an export or sync that sends data somewhere else.
- Snapshot (screenshot) before every click. Pick **CARY 1** / store **122** wherever a store picker exists. Do not audit CAMDEN SQUARE / 878. Do not open ADP.
- Do not ask hub q1–q5. If a page you already opened shows distributor, counting, item scope, corporate recipes, or a food-cost target, that text is enough.

## File names and `pages.csv`

Create `C:\fhs\reports\store-audit-122\` if it is missing. Put every capture in that folder (no extra subfolders).

- Screenshots: `<area>-<nn>.png` (e.g. `F4-01.png`)
- Page text: `<area>-<nn>.txt` (visible counts, dates, labels, errors, whether controls look editable / greyed / franchise-labelled). UTF-8.
- Report exports: `<area>-<nn>.csv` or `<area>-<nn>.pdf`
- Missing page: `<area>-<nn>-missing.txt` (what you searched, what you saw instead). Still log the search page in `pages.csv` as `view`.
- Extra screens for the same page: increment `nn` (`F2-05.png`, …). Do not skip numbers inside an area.

`pages.csv` (header exactly `time,URL,action`): one row after every page you open or filter or export.

- `time`: local ISO-8601 with offset (e.g. `2026-10-11T15:04:00-04:00`)
- `URL`: full URL with secrets stripped (`token`, `code`, `session`, `access_token`, and similar query params). Keep location and date filters.
- `action`: exactly `view`, `filter`, or `export`

No other action. Viewing a mapping list or an import-status page is `view`. Do not click Map, Import, or any write.

## Steps

1. Confirm the gate. If `C:\fhs\fhs-skills` is missing, or this file is missing, or Chrome is not signed in to R365 (`https://fhs4021089.restaurant365.com/`) and Toast Web (`https://www.toasttab.com/restaurants/admin/`, restaurant 366968), stop and ask the owner (runbook rows 9–10).
2. Create `C:\fhs\reports\store-audit-122\`. Write `pages.csv` with only the header row. Then capture every row in **Pages to capture**, in order. For each row: screenshot before the click; open the page; set the store to CARY 1 / 122 if a picker exists; apply the listed filter (log `filter`); save `<area>-<nn>.png` and `<area>-<nn>.txt`; export only when the row says export; append `pages.csv`.
3. On every captured page, record in the `.txt` whether the owner's role can edit, the controls are greyed out, or a franchise/corporate label is shown. Copy any such label into `O1-*.png` / `O1-01.txt` as well.
4. Zip the folder contents (files at the zip root, not a nested folder; do not put the zip inside the capture folder):

   `Compress-Archive -Path C:\fhs\reports\store-audit-122\* -DestinationPath C:\fhs\reports\store-audit-122.zip -Force`

5. Send until the script prints `MATCH`:

   `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\store-audit-122.zip -Name store-audit-122.zip -SshHost dev-lxc-1-agent`

   If it prints that the remote file already exists, or anything other than `MATCH`, stop and ask the owner. Do not pick a new name unless the owner says so.

## Pages to capture

R365 base: `https://fhs4021089.restaurant365.com/`. Toast base: `https://www.toasttab.com/restaurants/admin/`. Confirmed R365 starts (use if the menu agrees): Items ` /react/inventory/purchase-items `; Counts `/react/inventory/inventory`; Recipes `/react/inventory/recipe-items`; Menu items `/react/inventory/legacy/MenuItems`; Daily sales `/react/sales-and-forecasting/daily-sales`. Other paths `(?)`. Last week = the last complete week before today. Last 30 / 60 days = from today.

| Area | Files | System → page | What to capture (evidence) |
|---|---|---|---|
| M0 | `M0-01.png` `.txt`; more `M0-nn` if needed | R365 landing / top menu / app switcher (Operations, Inventory, Purchasing, AP, Accounting, Scheduling, Labor) `(?)` | Licensed / visible modules: what is visible; which the owner's role can open (screenshot a permission denial if it appears) |
| F2 | `F2-01` items list; `F2-02` ten high-dollar items; `F2-03` one item detail (conversions); `F2-04` vendors | R365 Inventory → Items `(?)`; Purchasing → Vendors `(?)` | Grid total; sample 10 high-dollar items (meats, cheese, bread, drinks): purchase unit, count unit, conversions, cost, GL; vendors listed. In place = items exist with units and costs, and vendors listed |
| F3 | `F3-01` invoice list; `F3-02` one invoice read-only; `F3-03` vendor EDI flag; `F3-04` email-capture address or `-missing.txt` | R365 AP → AP Invoices or Inventory → Invoices `(?)`, CARY 1, last 60 days; Vendors → integration/EDI `(?)` | Count, dates, source EDI/email/manual if shown. Open one invoice; Cancel/Back, never Save. In place = invoices arrive by EDI or email capture |
| F4 | `F4-01` recipes; `F4-02` POS / menu item mapping (unmapped with sales if a filter exists); `F4-03` Toast menu | R365 Inventory → Recipes `(?)`; POS / Menu Item Mapping `(?)`. Toast Menu → items and modifiers `(?)` | Recipe count; mapping list (view only, never Map); Toast item/modifier count. In place = recipes exist and Toast items are mapped |
| F5 | `F5-01` storage locations; `F5-02` count templates; `F5-03` past counts | R365 Inventory → Storage Locations; Count Templates; past counts `(?)` | Locations, template names, last count date and status. In place = locations and templates exist, and a count posted in the last 30 days |
| F6 | `F6-01` R365 waste; `F6-02` Toast void/waste reasons | R365 Inventory → Waste `(?)`. Toast void/waste reasons in setup `(?)` | Entries in the last 30 days, or empty/missing. In place = waste entries in the last 30 days |
| F7 | `F7-01` Actual vs Theoretical; `F7-02` Theoretical Food Cost; `F7-03` COGS; `F7-04` P&L; export if the report shows numbers | R365 Reports with last week's dates `(?)` | Open on screen (View). If a parameter error appears, capture it; do not start a job to fix it. In place = reports return numbers, not empty |
| F8 | `F8-01` R365 bank/deposits / cash recon; `F8-02` Toast payments, deposits, cash/drawer | R365 Accounting → Bank / Deposits, cash reconciliation `(?)`. Toast Reports → Payments, Deposits, Cash management / drawer `(?)` | Whether deposits are recorded and reconciled. Do not click Save if it becomes enabled |
| F9 | `F9-01` R365 daily sales/labor flash and any scheduled report emails; `F9-02` Toast sales summary and scheduled emails | R365 Reports / Dashboards: daily sales and labor flash `(?)`. Toast Reports → Sales summary; scheduled email reports `(?)` | A daily report exists; whether it is sent. In place = a daily report exists and is sent |
| F10 | `F10-01` R365 scheduling / OT alerts; `F10-02` Toast Scheduling | R365 Scheduling module `(?)`. Toast Scheduling `(?)` | Schedules published? OT alerts? In place = schedules are made in the system and OT alerts exist |
| F11 | `F11-01` R365 tip rules; `F11-02` Toast tip settings | R365 Labor → Tip Automation rules for CARY 1 `(?)` (search “Tip Automation”). Toast tip settings | Rules exist (known for payroll; confirm). View the rule only. Never Calculate, Approve, or edit |
| F12 | `F12-01` Labor Payroll Review; `F12-02` Tip Automation Distributions; `F12-03` Toast time entries | R365 Labor → Labor Payroll Review, Tip Automation Distributions `(?)`. Toast Labor → Time entries `(?)` | Reports exist (known; confirm). Open on screen; export allowed |
| F13 | `F13-01` R365 third-party delivery deposits; `F13-02` Toast channel integrations | R365 AP or Accounting: third-party delivery deposits `(?)`. Toast Integrations: DoorDash, Uber Eats, Grubhub, ezCater, first-party online ordering `(?)` | Channels in Toast; whether payouts are reconciled. In place = channels flow into Toast and payouts are reconciled |
| I1 | `I1-01` R365 POS / sales import; `I1-02` Toast → R365 | R365 POS integration / sales import for CARY 1 `(?)`. Toast Integrations → R365 `(?)` | **Last sales import date**, **last labor import date**, errors. In place = daily import with a recent date and no errors |
| O1 | `O1-01.txt` (required); `O1-nn.png` for franchise/corporate/greyed labels | Same pages as M0 and F2–F13 / I1 | For each F row: editable by the owner's role, greyed out, or labelled franchise/corporate. Owner = owner / franchise / R365 support / unknown |

## You may edit only

- Files under `C:\fhs\reports\store-audit-122\` (png, txt, csv, pdf, `pages.csv`)
- The zip `C:\fhs\reports\store-audit-122.zip` (create/overwrite)

## You must not

- Edit anything under `C:\fhs\fhs-skills` (including this file), `C:\Users\mayur\.claude\skills`, Dropbox, `shared/config.json`, or any other path.
- Push, merge, commit, or refresh the Windows skills mirror.
- Type credentials, fill a login or MFA form, or open ADP.
- Do any forbidden action listed above. Click Map, Import, Save, Submit, Approve, Post, or Run-as-job.
- Install packages or change system settings.
- Ask the owner q1–q5, or keep going after a login/MFA prompt without the owner signing in.

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\store-audit-122`.

1. `Get-ChildItem -File` → `pages.csv` plus png/txt (and any exports) for areas M0, F2–F13, I1, O1. Every area has at least one `.png`/`.txt` or a `-missing.txt`.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in `pages.csv` data rows → only `view`, `filter`, `export`
4. No `pages.csv` URL with path segments `save`, `submit`, `post`, or `approve` (case-insensitive). No edit / new / import / mapping **action** URL (a write). Viewing a mapping or import-status page is allowed.
5. After the send step: the `send-report.ps1` line printed `MATCH`

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped).

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
