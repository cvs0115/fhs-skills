# Test plan · count-sheet-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/count-sheet-122-01.md".

## What's being tested

The research note is the owner's 45-line tick list (exactly the count-lines-122 "looks dead" names, `Keep?` blank), plus who owns the Cary 1 count sheet and how a no-invoice store run could be recorded, each answer backed by this job's captures. `pages.csv` has only view/filter/scroll/export, with template detail, item detail, and the one blank AP-invoice form allowed as view only (that form closed with Cancel/Close, or the capture stopped). `tech-stack.md` only gained lines. Post-merge (not a gate): nothing in R365 changed (template still 207 items; no new vendor or AP draft).
Plan: `docs/plans/count-sheet-122-01.md` · Researcher report: `/srv/fhs-build/reports/count-sheet-122-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/count-sheet-122-01` on branch `feat/count-sheet-122-01`, as `fhsbuild` | read the note, `tech-stack.md`, `docs/research/count-lines-122.md`, and this job's captures; run commands; edit nothing in the repo |
| browser-server | not used | tester reads captures only; never open R365, Toast, or ADP |
| browser-windows | not used | same; `browser-02` stays parked; no new capture |
| owner | the owner answers | write down exactly what they report |

No browser cases for the tester. Check the clone and `/srv/fhs-build/reports/count-sheet-122-captures/` only. Never open R365, Toast, or ADP.

Browser rules: N/A. Do not open a browser or R365.

## Preconditions

- Researcher report `/srv/fhs-build/reports/count-sheet-122-01.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/count-sheet-122-captures/` and include `pages.csv` and at least one `TPL-*` file. If that folder is missing, empty, or has no `pages.csv`, mark T2–T4 BLOCKED (captures missing). If no `TPL-*`, mark T2 BLOCKED.
- `ITM-*`, `VND-*`, `APF-*`, `EXP-*`, and `TXN-*` are expected. If the capture stopped at the blank-form gate (could not close without saving) or a login/MFA stop, a `*-missing.txt` (or equivalent stop note) is expected — do not BLOCK T2–T4 for that; the note should use `(?)` where those files are missing.
- You are in `/srv/fhs-build/count-sheet-122-01` on `feat/count-sheet-122-01` as `fhsbuild`. Do not run `docs/prompts/count-sheet-122-01-capture.md`. Do not recapture count-lines or invoices-122. Do not read `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, or `/srv/fhs-build/reports/items-122-captures/` as this check's evidence.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/count-sheet-122.md`, takes pipe-rows between `## Tick list` and the next `## `, skips the header and `\|---` separator, and prints `rows=<n> unique=<n> missing_names=<n> extra_names=<n> bad_category=<n> keep_filled=<n> empty_required=<n> receipt_mismatch=<n> qty_mismatch=<n> headings_ok=<0\|1>` (5 cells per data row). Unique = distinct Name values. Compare that Name set to the Name set in `docs/research/count-lines-122.md` `## Item table` whose Group is `looks dead`. `bad_category` counts Category cells that are not exactly `BEV`, `CLEAN`, `PAPER FD`, `PAPER NF`, `NON REV`, `DAIRY`, `COUNT`, `Catering`, `CO2`, or `P-`. `keep_filled` counts Keep? cells that are not empty (including `-`, `n/a`, keep, hide, yes, no). `empty_required` counts rows whose Name, Category, 10/04 qty, or Last Cheney receipt is empty, or that do not have 5 cells. Each Last Cheney receipt must equal that Name's count-lines **Last Cheney receipt** cell; each 10/04 qty must equal the quantity after `10/04/2026:` in that Name's **Count quantities**. Headings `## Summary for the owner`, `## How cells were filled`, `## Tick list`, `## Template ownership`, `### Item settings (3 of 45)`, and `## Store runs` must exist | `rows=45 unique=45 missing_names=0 extra_names=0 bad_category=0 keep_filled=0 empty_required=0 receipt_mismatch=0 qty_mismatch=0 headings_ok=1`. 45 data rows, no duplicate names, Name set equals the count-lines-122 looks-dead names. Keep? blank on all 45 | command + trimmed output; any missing, extra, or duplicate name; any filled Keep? |
| T2 | shell | Under `## Template ownership`, rows (a), (b), and (c) exist. Every Answer that starts with `seen` names a capture file (Capture column or Answer) that exists in `/srv/fhs-build/reports/count-sheet-122-captures/` (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> seen_missing_file=<n> empty_unknown=<n>`. Then open each `seen` capture (.txt or .png) and confirm it shows what that Answer says: (a) the named control enabled, greyed, or not shown; (b) same `templateId` / URL vs a separate copy, plus created/modified and item count as written; (c) the label as written, or none of those labels. If `### Item settings (3 of 45)` has data rows (not `none`), each non-`(?)` row's Capture file exists and shows the setting named | `q_rows=3 seen_missing_file=0 empty_unknown=0`. Each ownership answer cites a capture that exists and shows what the answer says. Each `(?)` names what is missing | command + `ls` output; comparison line per (a)(b)(c); any missing file or answer the capture does not show |
| T3 | shell | Under `## Store runs`, every Way data row names a capture file that exists (`ls -l` each unique name). The line `CARY 1 non-Cheney AP rows since 05/15/2026:` is present. If the table is `none`, that is a pass for the file check. Print `ways=<n> missing_captures=<n> ap_line=<0\|1>`. Then open each Way's capture and confirm it shows that way (matching vendor, blank-form field labels, or expense/receipt/credit-card title as written). Vendor searches that found no row are not ways. Compare the AP count to `TXN-*` (pass if the number matches that capture; if `TXN-*` is missing, the line must be `CARY 1 non-Cheney AP rows since 05/15/2026: (?) missing: <what's missing>`). Do not fail the case because the count is not 0 | `missing_captures=0 ap_line=1`. Each store-run option cites a capture that shows it. No option is named without a capture. AP line present and matches `TXN-*` or `(?)` | command + `ls` output; comparison line per way (or `none`); AP line and TXN count |
| T4 | shell | Read `/srv/fhs-build/reports/count-sheet-122-captures/pages.csv` (header `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|submit\|approve\|complete\|post\|create\|edit\|map\|delete\|remove\|inactivate` (case-insensitive). Template detail (`templateId=`), item detail (`purchaseItemId=`), and the blank AP-invoice form (`APInvoiceForm` and/or a `create`/`new` URL) whose action is `view` are allowed exceptions — list those separately, do not fail them. A `create`/`new` URL is allowed only for that one blank-form open. If an `APF-*` exists, `## How cells were filled` or that file shows Cancel or Close without save. If that section says the capture stopped because the form could not be closed without saving, that is not a T4 fail (record it). Do not grade count-lines-122 `pages.csv` | unique actions are only `view`, `filter`, `scroll`, `export`. No save/submit/approve/create/delete/remove/inactivate click or URL (and no complete/post/edit/map URL), except template/item detail and the one blank AP form with action `view`. That blank-form open was closed with Cancel/Close, or the capture stopped | unique actions; matching URLs or "none"; allowed view exceptions listed separately; Cancel/Close or stop note |
| T5 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git status --short` | only `docs/research/count-sheet-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); `git status --short` empty | commands + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T5 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in R365 during this check (CARY 1 - FHS Weekly Inventory still 207 items; no new vendor or AP draft)?" | "no"; template still 207 items; no new vendor or AP draft | the owner's words |

## Results

Write `/srv/fhs-build/reports/count-sheet-122-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: count-sheet-122-01 · Branch: feat/count-sheet-122-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run, Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, Remove from template, changing a cost/unit/GL, or any button that changes status, or any toggle and checkbox that persists, or an Edit-mode toggle that locks a record. Do not open an In Progress count for editing. Do not open Ad hoc report.
- Run `docs/prompts/count-sheet-122-01-capture.md` or start a new capture. Do not recapture count-lines or invoices-122.
- Fill `Keep?`. Hide or remove a count-template line. Inactivate an item. Add a vendor. Save an AP invoice or draft.
- Edit, move, or delete anything under `/srv/fhs-build/reports/count-sheet-122-captures/`.
- Read `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, or `/srv/fhs-build/reports/items-122-captures/` as this check's evidence.
