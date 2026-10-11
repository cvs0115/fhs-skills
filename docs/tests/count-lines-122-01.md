# Test plan · count-lines-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/count-lines-122-01.md".

## What's being tested

The research note puts each of the 108 CARY 1 count names with no Cheney receipt in 8 weeks (`docs/research/invoices-122.md` Item last receipt) in exactly one group (slow mover / other Cheney item / looks dead / can't tell); each count export total matches that count's list total ±$1; 10/04 quantities agree with items-122 `CNT-03.csv`; every looks-dead row is qty 0 on every captured count with no receipt in the stated history; every other-Cheney-item row cites the paired item, its 08/14–10/09 receipt date and a capture that exists; five tester-picked items (at least one per non-empty group) match those captures; `pages.csv` has only view/filter/scroll/export, with count, item and invoice detail allowed as view only; `tech-stack.md` only gained lines. Post-merge (not a gate): nothing in R365 changed (no count, item, template, or invoice status changed by the capture).
Plan: `docs/plans/count-lines-122-01.md` · Researcher report: `/srv/fhs-build/reports/count-lines-122-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/count-lines-122-01` on branch `feat/count-lines-122-01`, as `fhsbuild` | read the note, `tech-stack.md`, `docs/research/invoices-122.md`, `docs/research/items-122.md`, this job's captures, invoices-122 captures, and items-122 `CNT-03.csv`; run commands; edit nothing in the repo |
| browser-server | not used | tester reads captures only; never open R365, Toast, or ADP |
| browser-windows | not used | same; `browser-02` stays parked; no new capture |
| owner | the owner answers | write down exactly what they report |

No browser cases for the tester. Check the clone, `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, and `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` only. Never open R365, Toast, or ADP.

Browser rules: N/A. Do not open a browser or R365.

## Preconditions

- Researcher report `/srv/fhs-build/reports/count-lines-122-01.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/count-lines-122-captures/` and include `pages.csv` and at least one `CNT-*` file. If that folder is missing, empty, or has no `pages.csv`, mark T2–T6 BLOCKED (captures missing). If no `CNT-*`, mark T2 BLOCKED.
- `/srv/fhs-build/reports/invoices-122-captures/` exists (pair receipts). If that folder is missing or empty, mark T4 BLOCKED (pair captures missing).
- `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` exists. If it is missing, mark T2 BLOCKED (10/04 qty file missing). Do not use that folder for older counts or for invoice lines.
- You are in `/srv/fhs-build/count-lines-122-01` on `feat/count-lines-122-01` as `fhsbuild`. Do not run `docs/prompts/count-lines-122-01-capture.md`. Do not recapture invoices-122. Do not use an In Progress count (including 09/28) as quantity evidence. If the capture stopped at the >45-invoice gate, **can't tell** is expected where older receipts are missing — do not fail T3 for an empty looks-dead group.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/count-lines-122.md`, takes pipe-rows between `## Item table` and the next `## `, skips the header and `\|---` separator, and prints `rows=<n> unique=<n> missing_names=<n> extra_names=<n> bad_group=<n> empty_cells=<n> summary_sum=<n> group_mismatch=<n> headings_ok=<0\|1>` (7 cells per data row; a blank or missing cell counts as empty). Unique = distinct Name values. Compare that Name set to the Name set in `docs/research/invoices-122.md` `## Item last receipt` whose Last Cheney receipt is `none in 8 weeks`. `bad_group` counts Group cells that are not exactly `slow mover`, `other Cheney item`, `looks dead`, or `can't tell`. `summary_sum` is the four N values under `## Summary for the owner` (`N still bought, just not lately`, `N bought under another Cheney item`, `N look dead ($X on the 10/04 count)`, `N can't tell`). `group_mismatch` is 0 only when those four N values equal the item-table counts of `slow mover`, `other Cheney item`, `looks dead`, and `can't tell` in that order. Headings `## Summary for the owner`, `## How cells were filled`, `## Other Cheney item candidates`, `## Count history`, `## Item table`, `## P1`, and `### Other Cheney item` must exist | `rows=108 unique=108 missing_names=0 extra_names=0 bad_group=0 empty_cells=0 summary_sum=108 group_mismatch=0 headings_ok=1`. 108 data rows, no duplicate names, Name set equals the invoices-122 `none in 8 weeks` names. Each name is in exactly one of the four groups | command + trimmed output; any missing, extra, or duplicate name |
| T2 | shell | Same note, pipe-rows between `## Count history` and the next `## `. For each row, parse List total and Export total (`$` and commas) and count `total_mismatch` when \|Export total − List total\| > 1.00. Confirm Date `10/04/2026` is present and every Status cell is `Approved`. For each of the 108 Names, the `MM/DD/YYYY: <qty>` for 10/04/2026 in **Count quantities** equals `Current Qty` for that Name in `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` (doubled-code match as items-122: a count-line name that appends a second item code matches the longest template Name; longest Name wins). `not shown` on 10/04 counts as a mismatch. Print `count_rows=<n> total_mismatch=<n> qty_mismatch=<n> has_1004=<0\|1>` | `total_mismatch=0 qty_mismatch=0 has_1004=1`. Every count-history row is Approved. Each export total = that count's list total ±$1.00. Every 10/04 qty agrees with `CNT-03.csv` | command + trimmed output; any total or qty mismatch |
| T3 | shell | Every item-table row whose Group is `looks dead`: every qty in **Count quantities** is `0` / `0.00` (no `not shown`), and **Last Cheney receipt** is `none in captured history`. Print `dead=<n> dead_bad=<n>` | `dead_bad=0` (an empty looks-dead group is PASS) | command + trimmed output; any looks-dead row that fails |
| T4 | shell | Every item-table row whose Group is `other Cheney item` has a matching `### Other Cheney item` row; that row cites Item bought now, a receipt date in 08/14–10/09/2026, and a capture file. For each unique capture name: `ls -l` under `/srv/fhs-build/reports/count-lines-122-captures/` or `/srv/fhs-build/reports/invoices-122-captures/`. Every **tied** row under `## Other Cheney item candidates` whose Likely count name is in the 108 has Group `other Cheney item`. If the P1 section is `none`, `other` must be 0. Print `other=<n> p1_missing=<n> missing_captures=<n> tied_ungrouped=<n>` | `p1_missing=0 missing_captures=0 tied_ungrouped=0`. Every other-Cheney-item row cites the paired item, its receipt date and a capture that exists | command + `ls` output; any missing P1 row, date out of range, or missing file |
| T5 | shell | Pick 5 items from the item table, at least 1 from each non-empty group (if fewer than 4 groups are non-empty, pick all of them and the rest from remaining rows, and note that). For each, open the cited capture (this job's folder or invoices-122-captures) and compare Name, Group, Last Cheney receipt, 10/04 qty, and (for other Cheney item) the paired item and receipt date. `$ on 10/04` is the items-122 Item table **Extended value (10/04/2026)** for that Name, copied exactly | each item matches its capture (and items-122 $ on 10/04) | the 5 names, group each, capture file per item, and a comparison line each |
| T6 | shell | Read `/srv/fhs-build/reports/count-lines-122-captures/pages.csv` (header `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|submit\|approve\|complete\|post\|create\|edit\|map` (case-insensitive). Count detail (`countId=`), item detail (`purchaseItemId=`), and invoice detail (`invoiceId=` / `APInvoiceForm` / `APCreditMemoForm`) URLs whose action is `view` are allowed exceptions — list those separately, do not fail them. Do not grade invoices-122 `pages.csv` | unique actions are only `view`, `filter`, `scroll`, `export`. No save/approve/complete/create/edit/map URL (and no submit/post URL), except count/item/invoice detail with action `view` | unique actions; matching URLs or "none"; allowed view exceptions listed separately |
| T7 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git status --short` | only `docs/research/count-lines-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); `git status --short` empty | commands + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T7 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in R365 during this check (no count, item, template, or invoice status changed by the capture)?" | "no" | the owner's words |

## Results

Write `/srv/fhs-build/reports/count-lines-122-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: count-lines-122-01 · Branch: feat/count-lines-122-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run, Send, Email, Pay, Print-to-vendor, Calculate, changing a cost/unit/GL, removing an item from a template, or any button that changes status. Do not open an In Progress count for editing.
- Run `docs/prompts/count-lines-122-01-capture.md` or start a new capture. Do not recapture invoices-122.
- Edit, move, or delete anything under `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, or `/srv/fhs-build/reports/items-122-captures/`.
- Read `/srv/fhs-build/reports/items-122-captures/` except `CNT-03.csv` for T2 10/04 quantities.
