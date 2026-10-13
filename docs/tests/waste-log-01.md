# Test plan · waste-log-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/waste-log-01.md".

## What's being tested

The research note records Cary 1 Toast POS waste (button name and one owner/manager test entry), Toast Food waste reporting, who sets void/waste reasons, and whether that Toast waste reaches the R365 waste log and AvT. Every claim cites a capture file that exists in this job's folder, or is marked `(?)` with what is missing. The test entry's POS button, steps, and screenshot (`POS-*`) match Toast Food waste reporting (`TWR-*`) on item, reason and **$** (or both the button and the report row are `(?)` because there was no waste button). `pages.csv` has only view/filter/scroll/export/close. `tech-stack.md` only gained waste / Food-waste / R365-and-AvT lines. Post-merge (not a gate): nothing in Toast or R365 changed beyond that one owner/manager test waste (voided or marked test as Toast allows).
Plan: `docs/plans/waste-log-01.md` · Researcher report: `/srv/fhs-build/reports/waste-log-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/waste-log-01` on branch `feat/waste-log-01`, as `fhsbuild` | read the note, `tech-stack.md`, and this job's captures; run commands; edit nothing in the repo |
| browser-server | not used | tester reads captures only; never open R365, Toast, or ADP |
| browser-windows | not used | same; `browser-02` stays parked; no new capture |
| owner | the owner answers | write down exactly what they report |

No browser cases for the tester. Check the clone and `/srv/fhs-build/reports/waste-log-122-captures/` only. Never open R365, Toast, or ADP. Do not tap or drive the POS.

Browser rules: N/A. Do not open a browser, R365, Toast, or ADP.

## Preconditions

- Researcher report `/srv/fhs-build/reports/waste-log-01.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/waste-log-122-captures/` and include `pages.csv`, at least one `POS-*` file, at least one `TWR-*` file, and at least one `WL-*` file. If that folder is missing, empty, or has no `pages.csv`, mark T1–T3 BLOCKED (captures missing). If no `POS-*` or no `TWR-*`, mark T2 BLOCKED.
- `VDR-*`, `ACC-*`, and `AVT-*` are expected. If the capture stopped at the R365 new-log-form gate (could not close without saving) or a login/MFA stop, a `*-missing.txt` (or equivalent stop note) is expected — do not BLOCK T1–T3 for that; the note should use `(?)` where those files are missing.
- You are in `/srv/fhs-build/waste-log-01` on `feat/waste-log-01` as `fhsbuild`. Do not run `docs/prompts/waste-log-01-capture.md`. Do not recapture F2–F5 or F8–F13. Do not recapture F6 from the store-audit zip. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/recipes-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/count-sheet-122-captures/`, or `/srv/fhs-build/reports/cash-122-captures/` as this check's evidence. Do not use audit F6 (WL-000002 **$0.92**, Toast Food waste this month **$0**) as this check's POS-test or TWR expected $.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: a `python3 -c` that reads `docs/research/waste-log-122.md`. Headings `## Summary for the owner`, `## How cells were filled`, `## Test entry`, `## Toast reasons`, `## R365 waste log`, `## Cost and accounts`, `## AvT`, `## Who owns what`, and `## Deviations` must exist. Count non-blank lines under `## Summary for the owner` until the next `## `. Take pipe-rows between `## Test entry` and the next `## `, skip the header and `\|---` separator (**6 cells** per data row: Source, Button or report, Item, Reason, $, Capture). Data rows must be **2**; Sources exactly `POS` then `Toast Food waste reporting`. `empty_cells` = blank or missing cells (`(?)` with a reason and `not shown (<file>)` are not empty; a cell that is only `(?)` with nothing after it counts as empty). Every Capture cell must name a file that exists in `/srv/fhs-build/reports/waste-log-122-captures/`, or start with `(?)`, or be `not shown (<file>)`. The line `same_item_reason_dollar:` must be present. Under `## Toast reasons`, rows (a) and (b) exist; (b)'s Answer is `seen: owner`, `seen: franchise`, `seen: can't tell`, or starts with `(?)`. Under `## R365 waste log`, rows (c), (d), and (e) exist. Under `## AvT`, rows (f) and (g) exist. Under `## Cost and accounts`, at least **1** data row; every data row has **4 cells**; none empty. Every Answer / Capture that starts with `seen` (or is a Capture that is not `(?)` / `not shown`) names a file that exists (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Under `## Who owns what`, every Owner cell is `owner`, `franchise`, `R365`, `Toast`, or `unknown`; every row that is not `unknown` names a capture file that exists; the table has a row for each of: POS waste button (or none), Toast void/waste reasons, Toast Food waste reporting, R365 waste log, waste accounts, AvT **Variance includes waste**. `## Deviations` exists and is `none` or lists every misclick. Print `headings_ok=<0\|1> summary_lines=<n> rows=<n> empty_cells=<n> missing_captures=<n> same_line=<0\|1> q_rows=<n> b_ok=<0\|1> r365_rows=<n> avt_rows=<n> acc_rows=<n> empty_acc=<n> seen_missing_file=<n> empty_unknown=<n> own_rows=<n> bad_owner=<n> own_missing=<n> need_own_missing=<n> deviations_ok=<0\|1>` | `headings_ok=1 summary_lines<=6 rows=2 empty_cells=0 missing_captures=0 same_line=1 q_rows=2 b_ok=1 r365_rows=3 avt_rows=2 acc_rows>=1 empty_acc=0 seen_missing_file=0 empty_unknown=0 own_rows>=6 bad_owner=0 own_missing=0 need_own_missing=0 deviations_ok=1`. Note exists. Every claim cites a capture file that exists, or is marked `(?)` with what is missing | command + trimmed output; `ls` of cited files; any missing heading, empty cell, missing file, or `(?)` with nothing after it |
| T2 | shell | Tester reads this job's `POS-*` and `TWR-*` only (not Toast). Do not use F6 **$0** / **$0.92** as the expected $. A `POS-*` screenshot must exist (`POS-*.png` or `POS-*.jpg`). From `## Test entry` and the captures: POS **Button or report** is the waste-button name as shown (steps note + screenshot), or `(?)` plus what the POS showed if there is no waste button. TWR **Button or report** is the report name, path, and date filter as shown on `TWR-*`. Compare POS Item, Reason and $ to TWR Item, Reason and $ (same text after stripping `$` / commas for the money cell). Read `same_item_reason_dollar:`: `yes` when those three match; `no` when a test entry exists and they differ; `(?) no button` when there was no waste button; `(?) TWR row missing` when a test entry exists but TWR has no matching row. Print `pos_shot=<0\|1> match=<yes\|no\|no_button\|twr_missing> item_eq=<0\|1> reason_eq=<0\|1> dollar_eq=<0\|1>`. If `match` is `no` or `twr_missing`, this case **FAIL** (record the POS vs TWR values). If no `POS-*`/`TWR-*` file is readable as a screenshot or steps/report text, mark T2 BLOCKED (capture not parseable), not FAIL | `pos_shot=1` and (`match=yes` with `item_eq=reason_eq=dollar_eq=1`, or `match=no_button` with POS Button and TWR Item/Reason/$ containing `(?)`). POS button name and steps with a screenshot → Toast Food waste reporting shows the same item, reason and **$** (or no button, both `(?)`) | command + trimmed output; POS button name; POS item / reason / $; TWR report name / path / date filter; TWR item / reason / $; `same_item_reason_dollar` value; `POS-*` and `TWR-*` file names |
| T3 | shell | Read `/srv/fhs-build/reports/waste-log-122-captures/pages.csv` (header exactly `time,URL,action`). List unique `action` values in data rows. Check each URL path for `save\|submit\|approve\|complete\|post\|create\|new\|add\|edit\|delete\|import\|map\|sync\|run\|send\|pay` (case-insensitive). Toast Food waste / void-reason URLs whose action is `view`, `filter`, `export`, or `close` are allowed exceptions — list those separately, do not fail them (a path may contain `void`; viewing VDR is allowed; a Void **click** on Toast Web is not). R365 `waste-logs`, `purchase-items`, item-detail, and AvT Location Summary URLs whose action is `view`, `filter`, `export`, or `close` are allowed exceptions. A `create` / `new` URL is allowed only for that one blank R365 new-waste-log form whose action is `view` or `close`, closed without save (`close` in `pages.csv` or Cancel/Close in the matching `*.txt`). If `## How cells were filled` or a `WL-*` / stop note says the capture stopped because the form could not be closed without saving, that is not a T3 fail (record it). `POS-*` must not appear as a `pages.csv` URL. `## Deviations` is `none` or lists every misclick; if opening the R365 new-log form made Save clickable, that section says Save was **not** clicked. Print unique actions, matching URLs (allowed exceptions listed separately), and `deviations_ok=<0\|1>` | unique actions are only `view`, `filter`, `scroll`, `export`, `close`. No forbidden click or URL (Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Map, Sync, Run, Send, Pay, Void), except the Toast Food-waste / void-reason and R365 waste-logs / purchase-items / item-detail / AvT view/filter/export/close exceptions, and that one blank new-log form with action `view` or `close`. Form closed with Cancel/Close, or the capture stopped. `deviations_ok=1` | unique actions; matching URLs or "none"; allowed exceptions listed separately; Cancel/Close or stop note; deviations line |
| T4 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^+## '`; `git status --short`. List every `^+` line in the `tech-stack.md` diff (skip `+++`). Confirm added lines are only **POS waste / void-reason** facts, **Toast Food waste reporting** facts, and **whether Toast waste reaches R365 and AvT**, under `## Store 122 audit (2026-10-11)`, with a pointer to `docs/research/waste-log-122.md`. `off_topic` = added lines about anything else (payroll, recipes, CAMDEN, rewriting the F6 waste bullet WL-000002 / $0.92 / Toast food waste this month $0, a weekly skill, an AvT product change) | only `docs/research/waste-log-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing (`tech-stack.md` diff has no `-` lines); no `^+## ` line (no new top-level section); `git status --short` empty; added lines are only waste / Food-waste / R365-and-AvT facts | commands + trimmed output; added-line list; any off-topic line |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T4 are the merge gate. Mark P1 BLOCKED until the owner answers, then fill it in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in Toast or R365 during this check beyond the one test waste you or the manager entered on the Cary 1 POS (voided or marked test as Toast allows)? No R365 waste log saved by the capture; the new-log form was not saved. (A new R365 log that arrived by itself from Toast is a finding, not a capture write.)" | "no" change by the capture; only that one owner/manager test waste (voided or marked test as Toast allows); new-log form not saved. A new R365 log that arrived by itself from Toast is recorded as a finding, not a FAIL of "capture wrote a log" | the owner's words; if they report a new R365 log from Toast, note it as a finding |

## Results

Write `/srv/fhs-build/reports/waste-log-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: waste-log-01 · Branch: feat/waste-log-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Map, Sync, Run (any job, including AvT Analysis), Send, Pay, Void (on Toast Web), any persistent toggle or checkbox, any settings page edit. Do not open Ad hoc report. Do not enter waste in R365. Do not tap or drive the POS.
- Run `docs/prompts/waste-log-01-capture.md` or start a new capture. Do not recapture F2–F5 or F8–F13. Do not recapture F6 from the store-audit zip.
- Write a checker script, a manager guide, a weekly "was waste logged" skill, or an AvT product change. Recapture the 551-item grid. Re-audit food-cost totals. Open store 878 / CAMDEN SQUARE / NCR, ADP, or the manager's old waste sheet. Touch payroll or `browser-02`.
- Edit, move, or delete anything under `/srv/fhs-build/reports/waste-log-122-captures/`.
- Read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/recipes-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/count-sheet-122-captures/`, or `/srv/fhs-build/reports/cash-122-captures/` as this check's evidence.
