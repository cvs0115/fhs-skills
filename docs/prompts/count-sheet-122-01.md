# Agent task · count-sheet-122-01 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/count-sheet-122-01.md`, to be run only after its plan review (`docs/reviews/count-sheet-122-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/count-sheet-122-01`
> and tell it "Do the task in docs/prompts/count-sheet-122-01.md". Start only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-sheet-122.zip` into `/srv/fhs-build/reports/count-sheet-122-captures/`. Do not run `docs/prompts/count-sheet-122-01-capture.md`. No new capture.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) counts 207 items on **CARY 1 - FHS Weekly Inventory**. 45 of those names look unused. This task is verify-only: from files only, write the owner's 45-line tick list (Keep? left blank), say who owns that count sheet and whether this login can take a line off, and list how R365 would record a Costco or grocery buy that has no invoice. You never open a browser. Nothing in R365 is changed. The hide itself is count-sheet-122-02, planned later. Capture is already done. The owner fills Keep? after the merge.

## Where you work

- Workspace: `/srv/fhs-build/count-sheet-122-01`, your own clone of the repo. Work only here.
- Branch: create `feat/count-sheet-122-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- This job's captures (read only, outside the repo, already unzipped): `/srv/fhs-build/reports/count-sheet-122-captures/`.
  `pages.csv` plus `TPL-*`, `ITM-*`, `VND-*`, `APF-*`, `EXP-*`, `TXN-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports). `pages.csv` columns: time, URL, action = view/filter/scroll/export.
  Areas: `TPL` (CARY 1 - FHS Weekly Inventory detail: item list, buttons/menus as text not clicked, created/modified, location or brand, history/audit tab if shown; CAMDEN SQUARE - FHS Weekly Inventory **header only**), `ITM` (item detail for these 3 of the 45 only: **BEV APPLE JUICE ALL**, **CLEAN MOP HEAD**, **PAPER FD SM SALAD BOWL** — per-location or count-template setting), `VND` (Vendors search: Costco, Sam's, Walmart, Food Lion, Harris Teeter, "store", "petty"), `APF` (blank new-AP-invoice form, read fields, closed without saving), `EXP` (any expense / receipt / credit-card screen found, or the menus searched if none), `TXN` (AP transactions for CARY 1, any non-Cheney vendor since 05/15/2026 — the count to record; expected 0).
- Tick-list names, 10/04 qty and last Cheney receipt come from `docs/research/count-lines-122.md` only. Do not recapture count-lines or invoices-122. Do not read `/srv/fhs-build/reports/count-lines-122-captures/` or `/srv/fhs-build/reports/invoices-122-captures/` or `/srv/fhs-build/reports/items-122-captures/` as this check's evidence.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/count-sheet-122-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/count-sheet-122.md`
4. `docs/prompts/count-sheet-122-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/count-lines-122.md` (Item table, group **looks dead**: the 45 names, 10/04 qty, last Cheney receipt). Copy those cells exactly. Do not invent names.
6. `docs/research/store-audit-122.md` F5 only (templates: creator R365 DSS User, modifier R365 10/06/2026, CAMDEN twin with 207 items). Facts marked `(?)` stay unverified unless this capture shows them. F5 is expected size only, not this check's ownership evidence.
7. `skills/fhs-skills/references/tech-stack.md` (append lines later in the existing Store 122 audit / R365 inventory facts; do not treat those bullets as this check's ownership or store-run evidence)

## Steps

1. `git switch feat/count-sheet-122-01` if that branch already exists, else `git switch -c feat/count-sheet-122-01`.
2. Confirm `/srv/fhs-build/reports/count-sheet-122-captures/` exists and contains `pages.csv` and at least one `TPL-*` file. Confirm `docs/research/count-lines-122.md` `## Item table` has **45** rows whose Group is **looks dead**. List this job's capture files. If any of those confirms fail, stop and write the report with that reason. `ITM-*`, `VND-*`, `APF-*`, `EXP-*`, and `TXN-*` are expected. If the capture stopped at the blank-form gate (could not close without saving) or a login/MFA stop, a `*-missing.txt` (or equivalent stop note) is expected; do not stop for that — finish the note and use `(?)` where those files are missing.
3. **Hard rule: capture folder and the two research files above only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Toast is not in this check. Do not start a new PC capture. Do not recapture count-lines or invoices-122. Do not fill `Keep?`.
4. From those files only, write `docs/research/count-sheet-122.md`. Start with `# Research · count-sheet-122 · Who owns the Cary 1 count sheet, the owner's tick list, how store runs could reach R365` and the date. Then:

   1. **`## Summary for the owner`** — plain words, **≤6 lines**: who owns the sheet, whether the owner can hide lines, the store-run options seen. Do not fill Keep? here. Do not recommend a hide.

   2. **`## How cells were filled`** — which TPL/ITM/VND/APF/EXP/TXN files, that the 45 Names / 10/04 qty / last Cheney receipt came from count-lines-122 (not this capture), how category was taken from the name prefix, how CAMDEN vs CARY 1 was compared (`templateId` / URL, created/modified, item count; header only), and whether the blank AP form was closed with Cancel/Close or the capture stopped. No empty explanation of a column you then leave blank except `Keep?`, which must stay blank.

   3. **`## Tick list`** — one row for each Item-table row in `docs/research/count-lines-122.md` whose Group is **looks dead**. Columns, in this order:

      | Name | Category | 10/04 qty | Last Cheney receipt | Keep? |

      - **45** data rows. No duplicate names. No extra or missing names. Names copied exactly from count-lines-122.
      - **Category** is the name prefix, exactly one of `BEV`, `CLEAN`, `PAPER FD`, `PAPER NF`, `NON REV`, `DAIRY`, `COUNT`, `Catering`, `CO2`, or `P-` (longest match at the start of Name). If a Name matches none of those, stop and write the report with that reason.
      - **10/04 qty** is the quantity after `10/04/2026:` in that row's **Count quantities** cell, copied exactly (e.g. `0.00`).
      - **Last Cheney receipt** is that row's **Last Cheney receipt** cell, copied exactly.
      - **Keep?** is blank on every row. Do not write keep, hide, yes, no, `-`, `n/a`, or any other placeholder.
      - No other empty cells.

   4. **`## Template ownership`** — answer each question with `seen` + capture file, or `(?)` + what is missing. Do not click and do not infer a click. F5 creator/modifier/207/CAMDEN-twin facts may be cited as expected size only; the answer itself must name a file in this job's captures folder (or `(?)`). Then:

      | Q | Answer | Capture |

      - **(a)** Can the owner's role remove an item or mark it inactive for CARY 1? Answer is `seen: enabled` (control shown and not greyed, not clicked), `seen: greyed`, `seen: not shown` (page captured; neither Remove-from-template nor Inactivate / equivalent is on it), or `(?): <what's missing>`. Say which control (remove from template, Inactivate, "count at location", or the label on screen).
      - **(b)** Is **CAMDEN SQUARE - FHS Weekly Inventory** the same record or a separate copy? Answer is `seen: same record` (same `templateId` / URL) or `seen: separate copy` (different `templateId` or a separate list row), plus created/modified and item count as shown, or `(?): <what's missing>`. Do not use a CAMDEN item list.
      - **(c)** Any sign of a brand/R365 push (location group, "managed by", modified-by history)? Answer is `seen: <the label exactly as written>` or `seen: none of those labels`, or `(?): <what's missing>`.

      Then **`### Item settings (3 of 45)`** — one row each for **BEV APPLE JUICE ALL**, **CLEAN MOP HEAD**, **PAPER FD SM SALAD BOWL**:

      | Name | Per-location or count-template setting | Capture |

      - Copy the setting as shown (for example Inactive, or "count at location"), or `not shown (<file>)`, or `(?): <what's missing>`.
      - If none of the three `ITM-*` files exist, write `none` under the heading and mark (a)'s per-item part `(?)`.

   5. **`## Store runs`** — only ways **seen on a screen** in this job's files. No option without a capture. Columns:

      | Way | Where | Capture |

      - A **way** is a control or page that could record a purchase with no Cheney invoice: a matching vendor from the searches (Costco, Sam's, Walmart, Food Lion, Harris Teeter, "store", "petty"), the blank AP-invoice form (list the field labels shown), or an expense / receipt / credit-card screen (title as shown).
      - Vendor searches that found **no** row are not ways. Record them in How cells were filled, with the `VND-*` file.
      - If a blank-form open could not be closed without saving, do not list that form as a way; write `(?): blank AP form not closed without saving (<file>)`.
      - If no expense / receipt / credit-card screen was found, do not invent one; the menus-searched `EXP-*` (or `*-missing.txt`) is the evidence that none was seen, not a way.
      - If none of the ways were seen, write `none` under the table.
      - Then this line exactly, filled from `TXN-*`: `CARY 1 non-Cheney AP rows since 05/15/2026: <n>` (expected 0). If `TXN-*` is missing, `CARY 1 non-Cheney AP rows since 05/15/2026: (?) missing: <what's missing>`. Do not open those rows in a browser; use the captured count only.

5. Match rows to files using the capture task's names (TPL/ITM/VND/APF/EXP/TXN) and `pages.csv`. Cite the real file name under this job's captures folder (e.g. `TPL-02.txt`, `APF-01.txt`). Every `seen` cell, every store-run **Way** row, and every item-settings row that is not `(?)` must name a capture file that exists there. Typical paths (confirm from the files; unknown `(?)`):

   | Area | Where (R365) | Take from it |
   |---|---|---|
   | TPL | Inventory → Inventory counts → gear → templates `/react/inventory/inventory/settings` then **CARY 1 - FHS Weekly Inventory** `?templateId=` (items-122 TPL path as a start only) | item list; every button and menu shown (label, enabled or greyed); created/modified; location or brand; history or audit tab. CAMDEN SQUARE header only: `templateId` / URL, created/modified, item count |
   | ITM | Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` | per-location or count-template setting for the 3 names only |
   | VND | Accounting → Vendors `/react/accounting/legacy/Vendors` | search / filter only; do not treat a create-vendor control as a way |
   | APF | invoice form `#/form/APInvoiceForm` (blank/new path `(?)`) | field labels on the blank form; Cancel/Close without save |
   | EXP | every menu whose title or labels are expense, receipt, or credit-card `(?)` | each screen found, or the menus searched if none |
   | TXN | Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions` | CARY 1, any non-Cheney vendor, since 05/15/2026; the count (expected 0) |

   Do not copy ownership or store-run options from `docs/research/store-audit-122.md`, `docs/research/count-lines-122.md`, `docs/research/items-122.md`, or `tech-stack.md` except the 45 Names, 10/04 qty, and last Cheney receipt named above. Audit facts marked `(?)` stay unverified unless this capture shows them.

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (R365 inventory facts): added lines only, **who owns count templates** and **where a no-invoice purchase can be recorded**, each with a pointer to `docs/research/count-sheet-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the existing count-template, count-history, or invoice-line bullets.

7. If this job's `pages.csv` has an action other than view/filter/scroll/export, or a URL whose path looks like save / submit / approve / complete / post / create / edit / map / delete / remove / inactivate, record it in the report's deviations. Template detail (`templateId=`), item detail (`purchaseItemId=`), vendor list, AP list, and the blank AP-invoice form are allowed as **view** only. A `create` / `new` URL is allowed only for that one blank-form open whose action is `view`. Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/count-sheet-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/count-sheet-122-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/count-sheet-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, Remove from template, changing a cost/unit/GL, or any button that changes status, or any toggle and checkbox that persists, or an Edit-mode toggle that locks a record. Do not open an In Progress count for editing.
- Run `docs/prompts/count-sheet-122-01-capture.md` or start a new capture.
- Fill `Keep?`. Write a checker script. Hide or remove a count-template line. Inactivate an item. Add a vendor. Save an AP invoice or draft. Recapture count-lines or invoices-122. Add the 31 slow movers or the 32 can't-tell lines. Collect Costco or grocery receipts or bank/card statements. Change store 878 / CAMDEN SQUARE's template. Write count-sheet-122-02. Touch payroll or `browser-02`.
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. This job's captures: `/srv/fhs-build/reports/count-sheet-122-captures`.

1. Data rows under `## Tick list` = **45**. Unique Name values = **45**, and that set equals the Name set in `docs/research/count-lines-122.md` `## Item table` whose Group is **looks dead**. Every Category cell is one of `BEV`, `CLEAN`, `PAPER FD`, `PAPER NF`, `NON REV`, `DAIRY`, `COUNT`, `Catering`, `CO2`, `P-`. Every Keep? cell is empty. Every data row has 5 cells; Name, Category, 10/04 qty, and Last Cheney receipt are non-empty. Each Last Cheney receipt equals that Name's count-lines cell, and each 10/04 qty equals the quantity after `10/04/2026:` in that Name's Count quantities. Headings `## Summary for the owner`, `## How cells were filled`, `## Tick list`, `## Template ownership`, `### Item settings (3 of 45)`, and `## Store runs` exist. Command: a `python3 -c` that prints `rows=<n> unique=<n> missing_names=<n> extra_names=<n> bad_category=<n> keep_filled=<n> empty_required=<n> receipt_mismatch=<n> qty_mismatch=<n> headings_ok=<0|1>`. Pass if `rows == unique == 45`, `missing_names == extra_names == bad_category == keep_filled == empty_required == receipt_mismatch == qty_mismatch == 0`, `headings_ok == 1`.
2. Under `## Template ownership`, rows (a), (b), and (c) exist. Every Answer that starts with `seen` names a capture file that exists in the captures folder (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> seen_missing_file=<n> empty_unknown=<n>`. Pass if `q_rows == 3`, `seen_missing_file == empty_unknown == 0`.
3. Under `## Store runs`, every Way data row names a capture file that exists (`ls -l` each unique name). The line `CARY 1 non-Cheney AP rows since 05/15/2026:` is present. No Way row exists whose Capture file is missing. If the table is `none`, that is a pass for the file check. Print `ways=<n> missing_captures=<n> ap_line=<0|1>`. Pass if `missing_captures == 0` and `ap_line == 1`.
4. This job's `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`; no URL path matching `save|submit|approve|complete|post|create|edit|map|delete|remove|inactivate` (case-insensitive), except template detail (`templateId=`), item detail (`purchaseItemId=`), and the blank AP-invoice form (`APInvoiceForm` and/or a `create`/`new` URL) whose action is `view`. Print the unique actions and any matching URLs (allowed view exceptions listed separately).
5. After the commit: `git diff --name-only main...HEAD` → only `docs/research/count-sheet-122.md` and `skills/fhs-skills/references/tech-stack.md`
6. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
7. After the commit: `git status --short` → empty

## When done

1. Commit on `feat/count-sheet-122-01`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/count-sheet-122-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: count-sheet-122-01 · Branch: feat/count-sheet-122-01 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/7 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
