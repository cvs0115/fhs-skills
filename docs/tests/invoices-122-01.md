# Test plan · invoices-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/invoices-122-01.md".

## What's being tested

The research note lists every CARY 1 Cheney invoice and credit memo dated 08/14–10/09/2026 (number, date, total, approval status, approval date + approver or "not shown", line count N, capture file) with that count equal to the Cheney vendor Transactions tab export for CARY 1 and no duplicate numbers; every invoice has lines read = footer N or is listed as a capture gap; line sums match invoice totals ±$0.01 except listed mismatches/gaps; each of the 207 counted items has a last Cheney receipt date in range or "none in 8 weeks" with no duplicate names; three tester-picked invoices (at least one with an unmapped line if any) match header, lines and mapping in the captures; `pages.csv` has only view/filter/scroll/export, with `invoiceId=` allowed as view only; `tech-stack.md` only gained lines. Post-merge (not a gate): nothing in R365 changed (no invoice status changed by the capture).
Plan: `docs/plans/invoices-122-01.md` · Researcher report: `/srv/fhs-build/reports/invoices-122-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/invoices-122-01` on branch `feat/invoices-122-01`, as `fhsbuild` | read the note, `tech-stack.md`, `docs/research/items-122.md`, and the captures folder; run commands; edit nothing in the repo |
| browser-server | not used | tester reads captures only; never open R365, Toast, or ADP |
| browser-windows | not used | same; `browser-02` stays parked; no new capture |
| owner | the owner answers | write down exactly what they report |

No browser cases for the tester. Check the clone and `/srv/fhs-build/reports/invoices-122-captures/` only. Never open R365, Toast, or ADP.

Browser rules: N/A. Do not open a browser or R365.

## Preconditions

- Researcher report `/srv/fhs-build/reports/invoices-122-01.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/invoices-122-captures/` and include `pages.csv` and at least one `TXN-*` file and one `INV-*` file. If that folder is missing, empty, or has no `pages.csv`, mark T1 and T4–T5 BLOCKED (captures missing). If no `TXN-*`, mark T1 BLOCKED. If no `INV-*`, mark T4 BLOCKED.
- You are in `/srv/fhs-build/invoices-122-01` on `feat/invoices-122-01` as `fhsbuild`. Do not run `docs/prompts/invoices-122-01-capture.md`. Do not read `/srv/fhs-build/reports/items-122-captures/` for line detail, last-receipt dates, or unmapped lines.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/invoices-122.md`, takes pipe-rows between `## Invoice table` and the next `## `, skips the header and `\|---` separator, and prints `rows=<n> unique=<n> empty_cells=<n> txn_rows=<n>\|not_csv file=<name>` (10 cells per data row; a blank or missing cell counts as empty). Unique = distinct Number values. If a `TXN-*.csv` exists under `/srv/fhs-build/reports/invoices-122-captures/`, `txn_rows` is that file's data-row count (skip header) and `file` is its name; if several, use the TXN export the note cites. If no `TXN-*.csv`, print `txn_rows=not_csv` and count CARY 1 rows in the cited TXN file another way. F2's **20** is not the expected count | `rows == unique`, `empty_cells=0`, and invoice-table rows = the Transactions tab CARY 1 count (`txn_rows == rows`, or the non-csv TXN count = rows). Every data row has Number, Date, Total, Approval status, Approval date, Approver, Line count N, Lines read, Line sum, Capture — or `not shown (<file>)` in the approval-date or approver cell. No duplicate numbers | command + trimmed output; TXN file name and count; any duplicate or incomplete row |
| T2 | shell | Same invoice table. Headings `## Capture gaps` and `## Amount mismatches` exist. Every invoice with Lines read ≠ Line count N appears under `## Capture gaps`. Every invoice with Lines read = N and \|Line sum − Total\| > 0.01 (parse `$` and commas) appears under `## Amount mismatches`. A grid read short of N is a capture gap, not a mismatch. Print `gaps_unlisted=<n> mismatch_unlisted=<n>` | `gaps_unlisted=0 mismatch_unlisted=0`; both headings exist | command + trimmed output; any unlisted gap or mismatch |
| T3 | shell | A `python3 -c` that reads pipe-rows between `## Item last receipt` and the next `## `, skips the header and `\|---` separator, and prints `rows=<n> unique=<n> missing_names=<n> extra_names=<n> name_only=<n> none=<n> bad_receipt=<n>`. Unique = distinct Name values. Compare that Name set to the Name set in `docs/research/items-122.md` `## Item table`. `bad_receipt` counts Last Cheney receipt cells that are neither a date nor `none in 8 weeks`. Confirm every Match cell is `name+number`, `name only`, or `none` | `rows=207 unique=207 missing_names=0 extra_names=0 bad_receipt=0`. 207 data rows, no duplicate names, Name set equals the items-122 names. Every Last Cheney receipt is a date or `none in 8 weeks` | command + trimmed output; any missing, extra, or duplicate name |
| T4 | shell | Pick 3 invoices from the invoice table, at least 1 with an unmapped line if `## Mapping by invoice` / `### Unmapped lines` has any (if none, pick 3 and note that). For each, open the cited capture under `/srv/fhs-build/reports/invoices-122-captures/` (page text or line export) and compare Number, Date, Total, approval status, approval date + approver (or `not shown`), Line count N, lines, and mapped vs unmapped (mapped = R365 item name on the line; unmapped = GL only / no item) | each invoice matches its capture | the 3 numbers, capture file per invoice, and a comparison line each |
| T5 | shell | Read `/srv/fhs-build/reports/invoices-122-captures/pages.csv` (header `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|submit\|approve\|complete\|post\|create\|map` (case-insensitive). Invoice detail (`invoiceId=`) URLs whose action is `view` are allowed exceptions — list those separately, do not fail them | unique actions are only `view`, `filter`, `scroll`, `export`. No save/approve/complete/create/map URL (and no submit/post URL), except `invoiceId=` with action `view` | unique actions; matching URLs or "none"; allowed view exceptions listed separately |
| T6 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git status --short` | only `docs/research/invoices-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); `git status --short` empty | commands + trimmed output |
| T7 | shell | In the clone: a `python3 -c` that reads `docs/research/invoices-122.md` and prints `headings_ok=<0\|1> summary_ok=<0\|1> mapping_mismatch=<n> totals_mismatch=<n>`. Headings `## Mapping totals`, `### Unmapped lines`, `## P1`, and `## Summary for the owner` must exist. The summary must contain the three lines `N invoices waiting for approval`, `N Cheney lines not tied to an item ($X)`, `N counted items not bought in 8 weeks` (N and $X filled). Under `## Mapping by invoice`, one row per invoice-table Number, Mapped + Unmapped = Lines read, and Lines read matches the invoice table. `## Mapping totals` `lines=`, `mapped=`, `unmapped=`, `unmapped_$=` equal those column sums | `headings_ok=1 summary_ok=1 mapping_mismatch=0 totals_mismatch=0` | command + trimmed output; any missing heading, missing summary line, or totals that do not tie to the invoice table |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T7 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in R365 during this check (no invoice status changed by the capture)?" | "no" | the owner's words |

## Results

Write `/srv/fhs-build/reports/invoices-122-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: invoices-122-01 · Branch: feat/invoices-122-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run, Send, Email, Pay, Print-to-vendor, Calculate, changing a GL, or any button that changes status.
- Run `docs/prompts/invoices-122-01-capture.md` or start a new capture.
- Edit, move, or delete anything under `/srv/fhs-build/reports/invoices-122-captures/`.
- Read `/srv/fhs-build/reports/items-122-captures/` for line detail, last-receipt dates, or unmapped lines.
