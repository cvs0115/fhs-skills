# Agent task · waste-log-01 · capture

> **For Claude Code + Claude in Chrome on the owner's Windows PC.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Read-only. Written by Claude to fix plan review r1 (major) from `docs/plans/waste-log-01.md` plan parts 1–6. Runs only after the plan review is APPROVE and the PC clone is refreshed.
> Hand-off: on the PC, from `C:\fhs\fhs-skills`, a normal Claude Code session (it asks before each command; do not bypass permissions). Tell it "Do the task in docs/prompts/waste-log-01-capture.md". Start only after the owner or manager made the POS test entry, and the owner signed in to **Toast and R365** in Chrome (restaurant **00122 - Cary 1**, location **CARY 1**). ADP is not this task.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office. Store 122 (Cary 1) is moving waste entry
to the Toast POS (associates press a waste button). This task only **captures** what Toast and R365 show about that waste,
read-only. You do not write the research note and you change nothing in Toast or R365. A later server agent writes the note
from your files.

## Where you work

- Workspace: `C:\fhs\fhs-skills` (the PC clone). **Read it. Do not edit it.** No branch, no commit, no push.
- Browser: Chrome with Claude in Chrome, in the tabs where the owner is already signed in.
- Captures (outside the repo): `C:\fhs\reports\waste-log-122\`. The owner already put the part-1 `POS-*` files there; leave them as they are and include them in the zip.
- Send the zip with `scripts\windows\send-report.ps1` and `-SshHost dev-lxc-1-agent`.
- No Cursor agent, Playwright MCP, Chrome DevTools MCP or server browser. No other lane may use the PC for capture at the same time.

## Read first

1. This file
2. `CLAUDE.md`
3. `docs/plans/waste-log-01.md` (if this file and the plan disagree, stop and tell the owner)
4. `docs/runbooks/windows-agent.md` (D5, `send-report.ps1`)
5. `docs/research/store-audit-122.md` F6 and F7 paths only as a start (R365 `F6-01`, Toast `F6-02`, AvT `F7-02`).

Known URLs are only a start if the menu path matches. Mark anything you cannot confirm `(?)`.

## Hard rules (read twice)

- **Read-only.** Allowed: view, filter, scroll, export/download, screenshots, saving page text, opening a detail page and closing it.
- **Never click:** Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Sync, Run, Send, Pay, any persistent toggle or checkbox, any settings edit. No user or permission changes. Do not open Ad hoc report.
- **R365 new-log form:** open the blank new waste log **once**, read its fields, then **Cancel/Close**. Never Save. If it cannot be closed without saving, write `WL-nn-missing.txt`, **stop and ask the owner**; do not zip or send.
- **AvT:** view only. Do not click Run on AvT Analysis if it asks for ToCount.
- **Never type credentials.** A login or MFA prompt means stop and ask the owner to sign in. Do not zip or send until they answer.
- Snapshot before every click. Pick **00122 - Cary 1** in Toast and **CARY 1** in R365. Do not open CAMDEN SQUARE / 878, ADP, a bank site, or payroll.
- Any misclick goes in the matching `.txt` (and later the note's `## Deviations`); not a new allowed action.
- Do not recapture F2–F5 or F8–F13 or re-audit food-cost totals. Do not write the research note.

## File names and `pages.csv`

- Screenshots `<area>-<nn>.png`; page text `<area>-<nn>.txt` (counts, dates, labels, totals, report name and path, every button shown as text not clicked with enabled or greyed, whether controls look editable or franchise/brand labelled, Created by / Modified by); exports `<area>-<nn>.csv|xlsx|pdf`; missing page `<area>-<nn>-missing.txt` (what you searched, what you saw). Extra screens increment `nn`.
- `pages.csv`, header exactly `time,URL,action`, one row after every page opened, filtered, scrolled, exported or closed. `time` local ISO-8601 with offset; `URL` full with `token`/`code`/`session` params stripped; `action` exactly `view`, `filter`, `scroll`, `export` or `close`. The one blank new-log form URL may contain `new`/`create` and must be followed by a `close` row. `POS-*` has no URL.

## Steps

1. Confirm the gate: the clone, this file and `POS-*` exist, Chrome is signed in to Toast and R365, no other lane is capturing. If not, stop and ask the owner.
2. Write `pages.csv` with only the header. Capture each area below in order. Start each area's first `.txt` with the date range used.
3. Zip the folder contents (files at the zip root): `Compress-Archive -Path C:\fhs\reports\waste-log-122\* -DestinationPath C:\fhs\reports\waste-log-122.zip -Force`
4. Send until it prints `MATCH`: `powershell -File C:\fhs\fhs-skills\scripts\windows\send-report.ps1 -Path C:\fhs\reports\waste-log-122.zip -Name waste-log-122.zip -SshHost dev-lxc-1-agent`. Anything other than `MATCH`: stop and ask the owner.

## Pages to capture

| Area | System → page | What to capture |
|---|---|---|
| POS | Already supplied by owner/manager (button screenshot, steps note, item/reason/$, void vs test). **Do not create.** If missing, tell the owner and stop | — |
| TWR | Toast Menus → Food waste reporting (audit `F6-02`), 00122 - Cary 1, date filter covering the test day | Report name, path, date filter; the test row's item, reason and $ (must equal the POS $). If missing: the empty/wrong total and what was filtered |
| VDR | Toast void/waste reasons: the reason list and the setup page if found | Reasons shown; who can add/edit (owner, franchise, can't tell). If not in nav: the menus searched, `(?)` |
| WL | R365 Inventory → Waste (`/react/inventory/waste-logs?activeTab=wasteLogs`), CARY 1 | The list (does a new log appear for the test, or still only WL-000002?); WL-000002 detail (fields, item, reason, cost, account); then the blank new-log form's fields, then Cancel/Close |
| ACC | R365 item detail for the WL-000002 item (if named) plus **one** other CARY 1 food item | Where a wasted item's cost and waste account come from (and the grid's waste-account column if shown). Do not recapture the 551-item grid |
| AVT | R365 Actual vs Theoretical Location Summary (audit `F7-02`), view only | The **Variance includes waste** setting as shown; whether the test waste is listed. If it can't show yet: `(?)` plus what is missing |

## You may edit only

- Files under `C:\fhs\reports\waste-log-122\` (add png, txt, csv, xlsx, pdf, `pages.csv`; leave `POS-*` as-is) and the zip `C:\fhs\reports\waste-log-122.zip`.

## You must not

- Edit anything under `C:\fhs\fhs-skills`, Dropbox, `shared/config.json`, or any other path. Push, merge, commit or refresh the Windows mirror.
- Type credentials, open ADP, a bank site, store 878, or payroll. Install packages or change system settings.
- Click anything on the never-click list, or keep going after a login/MFA prompt or the new-log Save gate without the owner answering.
- Print a full account or card number in any `.txt` (last 4 only).

## Tests (run every one, record the real output)

Working directory: `C:\fhs\reports\waste-log-122`.

1. `Get-ChildItem -File` → `pages.csv`, the supplied `POS-*`, and png/txt (or `-missing.txt`) for TWR, VDR, WL, ACC, AVT.
2. `Get-Content pages.csv -TotalCount 1` → `time,URL,action`
3. Unique `action` values in data rows → only `view`, `filter`, `scroll`, `export`, `close`
4. No `pages.csv` URL with `save`, `submit`, `approve`, `complete`, `post`, `delete`, `import`, `sync`, `run`, `send`, `pay`, except the one blank new-log URL followed by a `close` row.
5. No `pages.csv` URL for ADP, a bank site, CAMDEN SQUARE / 878.
6. After the send step: `send-report.ps1` printed `MATCH` (skip if you stopped at a login/MFA prompt or the Save gate and the owner has not said to send).

## When done

Do not commit. Tell the owner the send result (`MATCH` or stopped), whether `POS-*` was present, and whether capture stopped at a Save gate or login prompt.

If a step can't be done exactly as written, stop, tell the owner the reason, and don't work around it.
