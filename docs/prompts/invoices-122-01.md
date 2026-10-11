# Agent task · invoices-122-01 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/invoices-122-01.md`, to be run only after its plan review (`docs/reviews/invoices-122-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/invoices-122-01`
> and tell it "Do the task in docs/prompts/invoices-122-01.md". Start only after Ops has copied and unzipped `/root/fhs-skills/inbox/invoices-122.zip` into `/srv/fhs-build/reports/invoices-122-captures/`. Do not run `docs/prompts/invoices-122-01-capture.md`. No new capture.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) already counts 207 items on **CARY 1 - FHS Weekly Inventory**. This task is verify-only F3: from PC captures only, list every CARY 1 Cheney invoice and credit memo dated 08/14–10/09/2026 (lines, mapping, approval), then give each of those 207 items its last Cheney receipt in that range. F2 reports have no invoice line detail; this capture's invoice pages are the source. You never open a browser. Nothing in R365 is changed. Fixes are a later plan. Capture is already done.

## Where you work

- Workspace: `/srv/fhs-build/invoices-122-01`, your own clone of the repo. Work only here.
- Branch: create `feat/invoices-122-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- Captures (read only, outside the repo, already unzipped for you): `/srv/fhs-build/reports/invoices-122-captures/`.
  `pages.csv` plus `TXN-*`, `INV-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports). `pages.csv` columns: time, URL, action = view/filter/scroll/export.
  Areas: `TXN` (Cheney vendor Transactions tab for CARY 1, 08/14–10/09/2026 — export = the count to match), `INV` (each CARY 1 Cheney invoice and credit memo in that range, `invoiceId=`, view only: header, footer N, lines, mapping/GL, approval status, approval date + approver if shown). If the line grid was exported instead of scrolled, that export is the line evidence; say so.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/invoices-122-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/electronic-invoices.md`
4. `docs/prompts/invoices-122-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/store-audit-122.md` (F3 only; facts marked `(?)` stay unverified unless this capture shows them)
6. `docs/research/items-122.md` (the 207-item table Names, **Moved to F3**, INV page paths). Last-receipt and unmapped-line evidence come from this capture, not F2 INV files.
7. `skills/fhs-skills/references/tech-stack.md` (append lines later in the existing Store 122 audit / R365 inventory facts; do not treat the F2 "reports have no line detail" bullets as this check's line evidence)

## Steps

1. `git switch feat/invoices-122-01` if that branch already exists, else `git switch -c feat/invoices-122-01`.
2. Confirm the captures folder exists and contains `pages.csv` and at least one `TXN-*` file and one `INV-*` file. List the files. If the folder is missing, empty, has no `pages.csv`, has no `TXN-*`, or has no `INV-*`, stop and write the report with that reason. Confirm `docs/research/items-122.md` has a `## Item table` with **207** unique Name values. If it does not, stop and write the report with that reason.
3. **Hard rule: captures folder only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Toast is not in this check. Do not read `/srv/fhs-build/reports/items-122-captures/` for line detail, last-receipt dates, or unmapped lines (F2 INV-04/05-missing.txt and INV-03.txt have no line detail). Do not start a new PC capture.
4. From those files only, write `docs/research/invoices-122.md`. Start with `# Research · invoices-122 · Verify 122's Cheney invoices: lines, mapping, approval, last receipt` and the date. Then:

   1. **`## Summary for the owner`** — exactly these three facts, filled from the tables below (plain words, one line each):

      - `N invoices waiting for approval`
      - `N Cheney lines not tied to an item ($X)`
      - `N counted items not bought in 8 weeks`

   2. **`## How cells were filled`** — which TXN/INV files, whether lines came from a grid export or from scrolled page text, how Names were matched to invoice lines, and how many matches were **name only**. No empty explanation of a column you then leave blank.

   3. **`## Invoice table`** — one row for each CARY 1 Cheney invoice **and credit memo** dated 08/14–10/09/2026. Columns, in this order:

      | Number | Date | Total | Approval status | Approval date | Approver | Line count N | Lines read | Line sum | Capture |

      - Count of data rows = CARY 1 row count in the Transactions tab export (`TXN-*`). No duplicate Number values.
      - **Line count N** is the footer `1 - N of N Items` (or the export's line count if the capture used a read-only line export instead of scrolling). **Lines read** is how many line amounts you actually have. **Line sum** is the sum of those amounts.
      - No empty cells. If a capture does not show approval date or approver, write `not shown (<file>)` in that cell.
      - Do not invent rows to hit F2's **20** (`INV-03.txt`). That is an expected size only. The TXN export is the count to match. If this capture's TXN count differs, still finish the note from the files, fail that test, and list it under deviations.

   4. **`## Capture gaps`** — invoices where Lines read ≠ N (a grid read short of N). Each row: `| Number | Line count N | Lines read | Capture |`. If none, write `none`. These are **not** amount mismatches.

   5. **`## Amount mismatches`** — invoices where Lines read = N **and** |Line sum − Total| > $0.01. Each row: `| Number | Total | Line sum | Capture |`. If none, write `none`.

   6. **`## Mapping by invoice`** — one row per invoice-table Number:

      | Number | Lines read | Mapped | Unmapped | Unmapped $ | Capture |

      - **Mapped** = line shows an R365 item name. **Unmapped** = GL only / no item. Mapped + Unmapped = Lines read.
      - Then **`## Mapping totals`**: `lines=`, `mapped=`, `unmapped=`, `unmapped_$=` (sums of those columns).
      - Then **`### Unmapped lines`**. Columns: `| Invoice | Line | GL | Amount | Capture |`. Every unmapped line, with its GL. If none, write `none` under the heading.

   7. **`## Item last receipt`** — one row for each of the **207** Names in `docs/research/items-122.md` `## Item table`. Columns, in this order:

      | Name | Last Cheney receipt | Match | Capture |

      - **207** data rows. No duplicate names. Names are the items-122 Name values, copied exactly.
      - **Last Cheney receipt** is the latest invoice or credit-memo **Date** in 08/14–10/09/2026 whose captured line matches that item, or `none in 8 weeks`. Use captured lines only; do not guess unread lines from a capture gap.
      - **Match** is exactly one of `name+number`, `name only`, or `none`. Match on the R365 item name/number shown on the line. `name+number` when both the template Name and a number in that Name (the 7-digit code) appear on the line; `name only` when the Name matches but the number does not; `none` when Last Cheney receipt is `none in 8 weeks`. In **How cells were filled**, write how many rows are `name only`.
      - **Capture** is the INV file of that latest matching line, or `none in 8 weeks`.
      - No empty cells.

   8. **`## P1`** with these headings exactly:

      - **`### Approval wait`** — where both invoice date and approval date are shown: `| Number | Invoice date | Approval date | Wait (days) | Capture |`. Wait is approval date minus invoice date in whole days. Unapproved / `not shown` dates are not in this table. If none, write `none`.
      - **`### Who owns vendor-item mapping`** — exactly one of `owner` / `franchise` / `R365 support` / `can't tell`, from **these** screens (greyed Map/Save, brand/franchise label, created-by). If this capture does not show it, `can't tell`. Do not copy ownership from the store audit unless a file here shows the same label.

5. Match rows to files using the capture task's names (TXN/INV pattern) and `pages.csv`. Cite the real file name under the captures folder (e.g. `TXN-01.csv`, `INV-03.txt`). Every invoice-table row, every unmapped line, and every last-receipt row that is not `none in 8 weeks` must name a capture file that exists there. Typical paths the captures should show (confirm from the files; unknown ones `(?)`):

   | Area | Where (R365) | Take from it |
   |---|---|---|
   | TXN | Accounting → Vendors `/react/accounting/legacy/Vendors` → Cheney Brothers, Inc. → Transactions. CARY 1, 08/14–10/09/2026 `(?)` | count to match; numbers, dates, totals, status |
   | INV | invoice detail `invoiceId=` (view only). Also Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; Inventory → Invoices `/react/inventory/invoices` (`docs/research/items-122.md` INV paths; `docs/research/store-audit-122.md` F3) | header, footer N, lines, mapping/GL, approval status, approval date + approver if shown |

   Do not copy invoice-level numbers from `docs/research/store-audit-122.md`, `docs/research/items-122.md`, or `tech-stack.md` unless this capture shows them. Verified audit facts you may use as expected size only: F2 header export **20** CARY 1 Cheney invoices in range; F3 newest three Unapproved; five AP Credit Memos on the vendor. The 207 names come only from `docs/research/items-122.md`.

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (R365 inventory facts): added lines only, where **invoice line detail** lives and how to read it (menu path and/or URL from this capture, footer `1 - N of N` and/or line export, plus the file name), each with a pointer to `docs/research/invoices-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the F2 bullets that invoice-line **reports** have no line detail.

7. If `pages.csv` has an action other than view/filter/scroll/export, or a URL whose path looks like save / submit / approve / complete / post / create / map, record it in the report's deviations. Invoice detail pages (`invoiceId=`) are allowed as **view** only; do not treat those view URLs as forbidden. Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/invoices-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/invoices-122-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/invoices-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a GL, or any button that changes status, or any toggle and checkbox that persists.
- Run `docs/prompts/invoices-122-01-capture.md` or start a new capture.
- Write a checker script; approve, edit, map, or re-import any invoice; change any GL or import feed; add other vendors, store 878 / CAMDEN SQUARE, AP payments and checks, or the F2 problem list ($0 cost, missing Cheney links, unit mismatches).
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. Captures: `/srv/fhs-build/reports/invoices-122-captures`.

1. Data rows under `## Invoice table` = unique Number values. Every data row has 10 cells; none empty. If a `TXN-*.csv` exists, its data-row count (skip header) = invoice-table rows. Command: a `python3 -c` that reads `docs/research/invoices-122.md`, takes pipe-rows between `## Invoice table` and the next `## `, skips the header and `|---` separator, and prints `rows=<n> unique=<n> empty_cells=<n> txn_rows=<n>|not_csv file=<name>`. Pass if `rows == unique`, `empty_cells == 0`, and (`txn_rows == rows` or `txn_rows=not_csv`).
2. Every invoice with Lines read ≠ Line count N appears under `## Capture gaps`. Every invoice with Lines read = N and |Line sum − Total| > 0.01 appears under `## Amount mismatches`. Headings `## Capture gaps` and `## Amount mismatches` exist. Print `gaps_unlisted=<n> mismatch_unlisted=<n>`. Pass if both are 0.
3. Under `## Mapping by invoice`, Mapped + Unmapped = Lines read on every row. `## Mapping totals` has `lines=`, `mapped=`, `unmapped=`, `unmapped_$=`. Every `### Unmapped lines` data row names a capture file that exists in the captures folder (`ls -l` each unique name). Headings `## Mapping by invoice`, `## Mapping totals`, `### Unmapped lines`, and `## Summary for the owner` exist. The three owner-summary phrases exist. Print `mapping_mismatch=<n> missing_captures=<n>`. Pass if both are 0.
4. Data rows under `## Item last receipt` = **207**. Unique Name values = **207**, and that set equals the Name set in `docs/research/items-122.md` `## Item table`. Every Last Cheney receipt cell is a date or `none in 8 weeks`. Every Match cell is `name+number`, `name only`, or `none`. Print `rows=<n> unique=<n> missing_names=<n> extra_names=<n> name_only=<n> none=<n> bad_receipt=<n>`. Pass if `rows == unique == 207`, `missing_names == extra_names == bad_receipt == 0`.
5. `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`; no URL path matching `save|submit|approve|complete|post|create|map` (case-insensitive), except invoice detail (`invoiceId=`) URLs whose action is `view`. Print the unique actions and any matching URLs (allowed view exceptions listed separately).
6. After the commit: `git diff --name-only main...HEAD` → only `docs/research/invoices-122.md` and `skills/fhs-skills/references/tech-stack.md`
7. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
8. After the commit: `git status --short` → empty

## When done

1. Commit on `feat/invoices-122-01`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/invoices-122-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: invoices-122-01 · Branch: feat/invoices-122-01 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/8 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
