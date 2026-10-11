# Agent task · count-lines-122-01 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/count-lines-122-01.md`, to be run only after its plan review (`docs/reviews/count-lines-122-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/count-lines-122-01`
> and tell it "Do the task in docs/prompts/count-lines-122-01.md". Start only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-lines-122.zip` into `/srv/fhs-build/reports/count-lines-122-captures/`. Do not run `docs/prompts/count-lines-122-01-capture.md`. No new capture.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) counts 207 items on **CARY 1 - FHS Weekly Inventory**. 108 of those names had no Cheney receipt 08/14–10/09/2026. This task is verify-only: from files only, put each of those 108 in one group (slow mover / other Cheney item / looks dead / can't tell). You never open a browser. Nothing in R365 is changed. Fixes are a later plan. Capture is already done.

## Where you work

- Workspace: `/srv/fhs-build/count-lines-122-01`, your own clone of the repo. Work only here.
- Branch: create `feat/count-lines-122-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- This job's captures (read only, outside the repo, already unzipped): `/srv/fhs-build/reports/count-lines-122-captures/`.
  `pages.csv` plus `CNT-*`, `ITM-*`, and maybe `TXN-*` / `INV-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports). `pages.csv` columns: time, URL, action = view/filter/scroll/export.
  Areas: `CNT` (each Approved CARY 1 count dated on or after 08/01/2026 — Item Details export, same shape as items-122 `CNT-03.csv`), `ITM` (item detail for the 108: purchase-history or last-cost view if R365 shows dates), `TXN` / `INV` (CARY 1 Cheney invoices 05/15–08/13/2026 only if item detail had no dated purchase history; skipped if that history exists; not opened if the header count was >45).
- Step 1 also reads (do not recapture): `/srv/fhs-build/reports/invoices-122-captures/` (`pages.csv`, `TXN-*`, `INV-*`).
- 10/04 quantity check uses `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` (`Current Qty`). Do not use that folder for older counts or for invoice lines.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/count-lines-122-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/count-lines-122.md`
4. `docs/prompts/count-lines-122-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/invoices-122.md` (the 108 names: Item last receipt rows whose Last Cheney receipt is `none in 8 weeks`; Mapping by invoice: the R365 item on every line). Facts marked `(?)` stay unverified unless this capture shows them.
6. `docs/research/items-122.md` (Item table: cost, unit, Cheney vendor item, 10/04 $). 10/04 $ and the P1 Cheney vendor item come from this table, copied exactly.
7. `skills/fhs-skills/references/tech-stack.md` (append lines later in the existing Store 122 audit / R365 inventory facts; do not treat those bullets as this check's item-level evidence)

## Steps

1. `git switch feat/count-lines-122-01` if that branch already exists, else `git switch -c feat/count-lines-122-01`.
2. Confirm `/srv/fhs-build/reports/count-lines-122-captures/` exists and contains `pages.csv` and at least one `CNT-*` file. Confirm `/srv/fhs-build/reports/invoices-122-captures/` exists and contains `pages.csv` and at least one `INV-*` file. Confirm `docs/research/invoices-122.md` `## Item last receipt` has **108** rows whose Last Cheney receipt is `none in 8 weeks`, and `docs/research/items-122.md` `## Item table` has **207** unique Name values. List the count-lines-122 capture files. If any of those confirms fail, stop and write the report with that reason. `ITM-*` should exist (the 3-item purchase-history probe). `TXN-*` / `INV-*` in the count-lines folder are required only when item detail had no dated purchase history and the header count was ≤45. If the capture stopped at the >45-invoice gate, a `*-missing.txt` (or equivalent stop note) is expected; do not stop for that — finish the note and use **can't tell** where older receipts are missing.
3. **Hard rule: capture folders only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Toast is not in this check. Do not use an In Progress count (including 09/28) as quantity evidence. Do not start a new PC capture. Do not recapture invoices-122.
4. From those files only, write `docs/research/count-lines-122.md`. Start with `# Research · count-lines-122 · Sort the 108 not-bought counted items: slow, substituted or dead` and the date. Then:

   1. **`## Summary for the owner`** — exactly these four facts, filled from the item table (plain words, one line each). The four N values sum to 108. `$X` is the sum of **$ on 10/04** for **looks dead** rows:

      - `N still bought, just not lately`
      - `N bought under another Cheney item`
      - `N look dead ($X on the 10/04 count)`
      - `N can't tell`

   2. **`## How cells were filled`** — which CNT/ITM/TXN/INV files (this job and invoices-122), whether older purchases came from item purchase history or from 05/15–08/13 invoices (or stopped at >45), **Earliest history date: `<date>` (`<source>`)**, how the 108 Names were matched on count lines (same doubled-code match as items-122; longest Name wins), and how pairs were tied vs marked `(?)`. No empty explanation of a column you then leave blank.

   3. **`## Other Cheney item candidates`** — from the invoices-122 captures only (INV line Item column, page text or line export). One row for every R365 item on a CARY 1 Cheney line dated 08/14–10/09/2026 that is **not** one of the 207 count names in items-122 `## Item table`. Columns, in this order:

      | Non-count item | Receipt date | Likely count name | Pair | Capture |

      - **Likely count name** is one of the 108, chosen by same product words, size or category, or `none`.
      - **Pair** is `tied` when item numbers or this job's item-detail files tie them; otherwise `(?)`; `none` when Likely count name is `none`.
      - Expected size only: invoices-122.md says **150** mapped names are not on the 207. If this list's count differs, still finish from the files and list it under deviations.
      - If none, write `none`.

   4. **`## Count history`** — one row for each **Approved** CARY 1 count in this job's `CNT-*` files. Columns, in this order:

      | Date | Status | List total | Export total | Capture |

      - Date order, oldest first. Include 10/04/2026. Status must be Approved. Do not invent a 09/28 In Progress row.
      - **List total** is that count's header/list total. **Export total** is the sum of Item Details `Current $ Total` (or the export's own total if shown). No empty cells.

   5. **`## Item table`** — one row for each of the **108** names whose Last Cheney receipt in invoices-122 is `none in 8 weeks`, copied exactly. Columns, in this order:

      | Name | Group | Last Cheney receipt | Source | Count quantities | $ on 10/04 | Capture |

      - **108** data rows. No duplicate names. No extra or missing names.
      - **Group** is exactly one of `slow mover` / `other Cheney item` / `looks dead` / `can't tell`. Assign in this order so each name has one group:
        1. **other Cheney item** — that Name is a **tied** (not `(?)`) likely count name in the candidates table, and the paired non-count item has a receipt 08/14–10/09. Pairing evidence stays in the candidates table and in P1.
        2. **slow mover** — a Cheney receipt of **that Name** before 08/14 in the captured purchase history, and no tied pair above.
        3. **looks dead** — captured purchase history actually covers the stated range (dated item purchase history was used, or 05/15–08/13 invoices were listed and opened), no receipt of that Name in that range, qty **0** on every captured count, and no tied pair.
        4. **can't tell** — anything else. **Source** for these rows is `missing: <what's missing>` (e.g. older invoices not captured, pair is `(?)` only, a count export lacks qty).
      - **Last Cheney receipt:** for **slow mover**, the latest date of **that Name** before 08/14; for **other Cheney item**, the paired item's receipt date in 08/14–10/09; for **looks dead**, `none in captured history`; for **can't tell**, the latest date of that Name if one exists, else `none in captured history`.
      - **Source** is the capture file that showed that receipt (this job's `ITM-*` / `INV-*`, or invoices-122 `INV-*` for a pair's 08/14–10/09 receipt), or the `missing:` text above.
      - **Count quantities** is `MM/DD/YYYY: <qty>` for every Count-history date, same order, separated by `; `. Qty is Item Details `Current Qty` for that Name (doubled-code match as items-122). If that count's export lacks the name, `MM/DD/YYYY: not shown (<file>)`.
      - **$ on 10/04** is the items-122 Item table **Extended value (10/04/2026)** for that Name, copied exactly. Do not re-sum from this job's 10/04 export.
      - **Capture** is the main file for that row's group evidence (the receipt file, or the count export if looks dead / can't tell with no receipt).
      - No empty cells.

   6. **`## P1`** with this heading exactly:

      - **`### Other Cheney item`** — one row per item-table row whose Group is `other Cheney item`:

        | Name | Count line Cheney vendor item | Item bought now | Receipt date | Capture |

        - **Count line Cheney vendor item** is the items-122 Item table **Cheney vendor item** cell for that Name, copied exactly.
        - **Item bought now** is the tied non-count item. **Receipt date** is that item's 08/14–10/09 receipt. **Capture** is the invoices-122 (or this job) file of that line.
        - If none, write `none`.

5. Match rows to files using the capture task's names (CNT/ITM/TXN/INV) and `pages.csv`. Cite the real file name (e.g. `CNT-02.csv`, invoices-122 `INV-13.txt`). Every item-table row and every **tied** candidate must name a capture file that exists in the folder it came from. Typical paths (confirm from the files; unknown `(?)`):

   | Area | Where (R365) | Take from it |
   |---|---|---|
   | invoices-122 INV | invoice/credit-memo forms `#/form/APInvoiceForm/{id}` and `#/form/APCreditMemoForm/{id}` (`docs/research/invoices-122.md` INV paths) | R365 item on every Cheney line 08/14–10/09; non-count names for pairing |
   | CNT | Inventory → Inventory counts `/react/inventory/inventory` (Item Details export as `CNT-03.csv` in items-122; 10/04 was `?countId=3`) `(?)` | quantity per item per Approved count on or after 08/01/2026; list total vs export total |
   | ITM | Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` (ItemCost / Settings in items-122 `ITM-05`..`ITM-12`) `(?)` | purchase-history or last-cost view with dates; if dated, this is the older-purchase source for all 108 |
   | TXN / INV (this job) | Accounting → Vendors `/react/accounting/legacy/Vendors` → Cheney Brothers, Inc. → Transactions; Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; AP forms as invoices-122-01 | only if ITM had no dated history; CARY 1 Cheney invoices 05/15–08/13/2026. Header count first; if >45, capture stopped |

   Do not copy groups or last-receipt dates from `docs/research/invoices-122.md`, `docs/research/items-122.md`, or `tech-stack.md` except the 108 Names, the 207 count names, 10/04 $, and Cheney vendor item cells named above. Audit facts marked `(?)` stay unverified unless this capture shows them.

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (R365 inventory facts): added lines only, where **count history** lives (Approved CARY 1 counts → Item Details export) and where **item purchase history** lives (or that this capture did not find a dated view and used invoices instead), each with a pointer to `docs/research/count-lines-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the existing count-line or invoice-line bullets.

7. If this job's `pages.csv` has an action other than view/filter/scroll/export, or a URL whose path looks like save / submit / approve / complete / post / create / edit / map, record it in the report's deviations. Count detail (`countId=`), item detail (`purchaseItemId=`), and invoice detail (`invoiceId=` / AP forms) are allowed as **view** only; do not treat those view URLs as forbidden. Do not edit `pages.csv`. Do not hide it. Do not grade invoices-122 `pages.csv` (already checked in F3).

## You may edit only

- `docs/research/count-lines-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/count-lines-122-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, or `/srv/fhs-build/reports/items-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a cost/unit/GL, removing an item from a template, or any button that changes status, or any toggle and checkbox that persists. Do not open an In Progress count for editing.
- Run `docs/prompts/count-lines-122-01-capture.md` or start a new capture.
- Write a checker script; change any item, cost, unit, vendor-item link, or count template; add the 99 items Cary 1 did buy in 8 weeks, store 878 / CAMDEN SQUARE, F4 recipes, Cheney's own website or order guide, the F2 problem list ($0 cost, missing Cheney links, unit mismatches), payroll, or `browser-02`.
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. This job's captures: `/srv/fhs-build/reports/count-lines-122-captures`. F3: `/srv/fhs-build/reports/invoices-122-captures`. F2 10/04: `/srv/fhs-build/reports/items-122-captures/CNT-03.csv`.

1. Data rows under `## Item table` = **108**. Unique Name values = **108**, and that set equals the Name set in `docs/research/invoices-122.md` `## Item last receipt` whose Last Cheney receipt is `none in 8 weeks`. Every Group cell is `slow mover`, `other Cheney item`, `looks dead`, or `can't tell`. Every data row has 7 cells; none empty. The four owner-summary N values sum to 108 and equal the item-table counts of `slow mover`, `other Cheney item`, `looks dead`, and `can't tell` in that order. Headings `## Summary for the owner`, `## How cells were filled`, `## Other Cheney item candidates`, `## Count history`, `## Item table`, `## P1`, and `### Other Cheney item` exist. How cells include `Earliest history date:`. Command: a `python3 -c` that prints `rows=<n> unique=<n> missing_names=<n> extra_names=<n> bad_group=<n> empty_cells=<n> summary_sum=<n> group_mismatch=<n> headings_ok=<0|1>`. Pass if `rows == unique == 108`, `missing_names == extra_names == bad_group == empty_cells == group_mismatch == 0`, `summary_sum == 108`, `headings_ok == 1`.
2. Under `## Count history`, |Export total − List total| ≤ $1.00 on every row. 10/04/2026 is present. For each of the 108 Names, the `MM/DD/YYYY` qty for 10/04 in **Count quantities** equals `Current Qty` for that Name in `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` (doubled-code match as items-122). Print `count_rows=<n> total_mismatch=<n> qty_mismatch=<n> has_1004=<0|1>`. Pass if `total_mismatch == 0`, `qty_mismatch == 0`, `has_1004 == 1`.
3. Every **looks dead** row: every qty in **Count quantities** is `0` / `0.00`, **Last Cheney receipt** is `none in captured history`, and no `not shown`. Print `dead=<n> dead_bad=<n>`. Pass if `dead_bad == 0`.
4. Every **other Cheney item** row has a matching `### Other Cheney item` row; that row cites Item bought now, a receipt date in 08/14–10/09/2026, and a capture file that exists (`ls -l` each unique name under this job's folder or invoices-122-captures). Every **tied** candidates row whose Likely count name is in the 108 appears as Group `other Cheney item`. Print `other=<n> p1_missing=<n> missing_captures=<n> tied_ungrouped=<n>`. Pass if `p1_missing == missing_captures == tied_ungrouped == 0`.
5. This job's `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`; no URL path matching `save|submit|approve|complete|post|create|edit|map` (case-insensitive), except count detail (`countId=`), item detail (`purchaseItemId=`), and invoice detail (`invoiceId=` / `APInvoiceForm` / `APCreditMemoForm`) URLs whose action is `view`. Print the unique actions and any matching URLs (allowed view exceptions listed separately).
6. After the commit: `git diff --name-only main...HEAD` → only `docs/research/count-lines-122.md` and `skills/fhs-skills/references/tech-stack.md`
7. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
8. After the commit: `git status --short` → empty

## When done

1. Commit on `feat/count-lines-122-01`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/count-lines-122-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: count-lines-122-01 · Branch: feat/count-lines-122-01 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/8 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
