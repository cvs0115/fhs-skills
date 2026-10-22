# Test plan · payroll-adp-02

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/payroll-adp-02.md".

## What's being tested

Four leftover nits from payroll-adp-01: High issues print before Medium and Info in stdout and the HTML report; a new NCR mismatch fixture proves the contributor check stays off for NCR even when tip files don't match; SKILL.md step 6 lists saved reports to the owner before ADP entry and step 9 copies that list into the concerns note; the extract-format row for `_tip_sources.txt` says $0 lines are allowed and ignored. This proves the plan's done-check: after the next owner-OK'd PC mirror refresh (one refresh carries 01 and 02), Week 42 and Week 40 ADP CSVs match the 01 run on the same folder, the issue list matches as a set, and every High comes before every Medium and Info in the printed list and the HTML report. On the server, each 01 fixture's ADP CSV is byte-identical before and after the change.
Plan: `docs/plans/payroll-adp-02.md` · Builder report: `/srv/fhs-build/reports/payroll-adp-02.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/payroll-adp-02` on branch `feat/payroll-adp-02`, as `fhsbuild` | run commands; edit nothing in the repo |
| browser-server | not used | never open Toast, R365 or ADP |
| browser-windows | not used | same; no capture |
| owner | the owner (or a Windows payroll session they start) runs the real week folders after a mirror refresh and pastes the result | write down exactly what they report |

No browser cases. Pre-merge uses the clone and its fixtures only. Post-merge P1–P2 run on the PC after the owner OKs a refresh; mark them BLOCKED until that output is pasted.

Browser rules: N/A. Do not open a browser, Toast, R365 or ADP. Never type a username or password. Never click save, submit, approve, pay, send or delete.

## Preconditions

- Builder report `/srv/fhs-build/reports/payroll-adp-02.md` exists. You are in `/srv/fhs-build/payroll-adp-02` on `feat/payroll-adp-02` as `fhsbuild`.
- Set `CLONE=/srv/fhs-build/payroll-adp-02` and `PAYROLL=$CLONE/skills/fhs-payroll-adp/scripts/payroll.py`. Prefix is `122_2026-10-05_2026-10-18` unless a case names another.
- 02 fixture folders exist under `$CLONE/docs/fixtures/payroll-adp-02/`: `order-high-medium/`, `ncr-mismatch/`, `toast-mismatch/`. 01 fixture folders exist under `$CLONE/docs/fixtures/payroll-adp-01/`: `quiet-kiosk/`, `missing-contributor/`, `contributor-ok/`, `missing-date/`, `not-run/`, `no-kiosk/`, `ncr/`. If a named folder is missing, that case is BLOCKED (fixtures missing), not FAIL.
- For every `payroll.py` case: copy that fixture folder to a temp dir (`mktemp -d`) and run from the copy. Do not write `_adp_entry.csv` or `_discrepancy_report.html` into the clone.
- Issue lines on stdout look like `  [High] Employee: Issue - detail` (same for Medium / Info). Parse those for counts, order, and issue sets. For HTML order only: use the Issues table (between `<h2>Issues</h2>` and `<h2>ADP RUN entry</h2>`), reading `class='pill …'` on each row (`high` / `medium` / `info`). Do not byte-compare HTML (it stamps a clock time).
- For a before-change compare, write `git show main:skills/fhs-payroll-adp/scripts/payroll.py` to a temp file and run that copy from the same fixture cwd. If `git show` fails, the compare case is BLOCKED (no main script), not FAIL.
- Do not run real Dropbox week folders. Do not refresh the Windows mirror. Do not put real staff names or pay into the test report.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | Copy `$CLONE/docs/fixtures/payroll-adp-02/order-high-medium/` to a temp dir; `cd` there; `python3 "$PAYROLL" 122_2026-10-05_2026-10-18`. Parse stdout issue lines. `high_n` / `med_n` = counts of High / Medium lines. `order_ok=1` iff every High appears before every Medium and every Info (once a Medium or Info is seen, no later High). In `122_2026-10-05_2026-10-18_discrepancy_report.html`, read Issues-table pill classes in row order the same way → `html_order_ok`. Run `main`'s payroll.py on a second copy of the same fixture → `old_n`; `count_same=1` iff new stdout issue count equals `old_n`. Print `high_n=<n> med_n=<n> order_ok=<0\|1> html_order_ok=<0\|1> count_same=<0\|1>`. Note whether at least one High is titled `Tip source missing from R365 contributors`. | `high_n>=1`, `med_n>=1`, `order_ok=1`, `html_order_ok=1`, `count_same=1`. At least one High is `Tip source missing from R365 contributors`. High lines come before every Medium in stdout and the HTML report; total issue count same as before the change | command + trimmed stdout + the printed flags + HTML Issues-table order |
| T2 | shell | Copy `ncr-mismatch/` to a temp dir; run `python3 "$PAYROLL" 878_2026-10-05_2026-10-18`. `ncr_msg` = count of issues titled `Tip contributor check not run` **or** `Tip source missing from R365 contributors`. Copy `toast-mismatch/` to a new temp dir; run payroll.py with prefix `122_2026-10-05_2026-10-18`. `toast_high` = count of High `Tip source missing from R365 contributors`; `names_date=1` iff that High's detail (or Employee) contains `10/6` or `10/6/2026`; `names_source=1` iff it contains `kiosk` (any case). Print `ncr_msg=<n> toast_high=<n> names_date=<0\|1> names_source=<0\|1>` | `ncr_msg=0 toast_high=1 names_date=1 names_source=1`. NCR: zero of those two titles. toast_r365 with the same tip files: exactly one High `Tip source missing from R365 contributors` for that date and source | both commands + trimmed stdout + the printed flags |
| T3 | shell | For each of `quiet-kiosk/`, `missing-contributor/`, `contributor-ok/`, `missing-date/`, `not-run/`, `no-kiosk/` (prefix `122_2026-10-05_2026-10-18`) and `ncr/` (prefix `878_2026-10-05_2026-10-18`) under `$CLONE/docs/fixtures/payroll-adp-01/`: copy the 01 folder to two temp dirs; run new `payroll.py` in one and `main`'s `payroll.py` in the other. `cmp -s` the two `*_adp_entry.csv` files → `IDENTICAL` or not. Issue **set** is the frozenset of `(severity, employee, issue, detail)` from parsed stdout lines (order ignored). Print per folder `csv=<IDENTICAL\|DIFF> set_ok=<0\|1>` | every folder `csv=IDENTICAL` and `set_ok=1`. ADP CSV byte-identical to `main` before the change; issue set identical; only order may change | per-folder commands + `csv=` / `set_ok=` lines |
| T4 | shell | From `$CLONE`, a `python3 -c` that splits `skills/fhs-payroll-adp/SKILL.md` on markdown headings. Find the heading whose text starts with `6.`. `step6_required=<0\|1>` is 1 iff that heading contains `required before ADP entry`. `step6_no_concerns=<0\|1>` is 1 iff neither that heading nor the body until the next heading contains `concerns note`. `step9_copies=<0\|1>` is 1 iff the heading that starts with `9.` exists and the body until the next heading contains `_concerns.md` and (`step 6` or `step6`). Print `step6_required=<0\|1> step6_no_concerns=<0\|1> step9_copies=<0\|1>` | `step6_required=1 step6_no_concerns=1 step9_copies=1`. Step 6 no longer says to write the list "in the concerns note" before ADP; step 6 still says required before ADP entry; step 9 says to copy the step 6 list into `_concerns.md` | command + printed flags; the step 6 heading; the step 9 sentence that names `_concerns.md` |
| T5 | shell | From `$CLONE`, a `python3 -c` that finds the table row whose first cell is `` `_tip_sources.txt` `` (or `_tip_sources.txt`) and prints `zero_ok=<0\|1>`: 1 iff that row's text contains `$0` (or `0 card`) and (`allowed` or `ignored`) | `zero_ok=1`. The `_tip_sources.txt` row says $0 lines are allowed and ignored | command + printed flag + the matching row text |
| T6 | shell | From `$CLONE`: `python3 -m py_compile skills/*/scripts/*.py; echo exit=$?` | `exit=0`. Every skill script compiles | command + trimmed output |
| T7 | shell | From `$CLONE`, on the builder's **committed** branch (T1–T6 run in temp dirs and don't touch the clone): `git log --oneline main..HEAD`; `git diff --name-only main...HEAD`; `git status --short`. Allowed paths only: `skills/fhs-payroll-adp/scripts/payroll.py`, `skills/fhs-payroll-adp/SKILL.md`, `skills/fhs-payroll-adp/references/extract-formats.md`, and anything under `docs/fixtures/payroll-adp-02/`. Print `extra=<n>` = count of other paths and `commits=<n>` from the log | `commits>=1`, `extra=0`; `git status --short` empty. Only the plan's allowed files | both commands + path list + `extra=` |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T7 are the merge gate. Mark P1 and P2 BLOCKED until (a) payroll-adp-01 P1/P2 evidence exists and (b) the owner OKs a Windows mirror refresh that includes 02 (one refresh may carry 01 and 02) and pastes the new runs. Do not treat a missing refresh as FAIL. Compare to the 01 run on the same folder (01 test-report TOTAL/CSV/Issues if the week-folder CSV was overwritten).

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | After the owner OKs a refresh of `C:\fhs\fhs-skills`, from the real 122 week folder `...\Locations\00122\2026\10 OCT\Week 42` (10/5–10/18), run `py` on `skills\fhs-payroll-adp\scripts\payroll.py` with prefix `122_2026-10-05_2026-10-18`. Compare the ADP CSV (or TOTAL + employee rows) and parsed Issues to the payroll-adp-01 P1 run on the same folder. Check stdout issue order and the HTML Issues-table pill order | ADP CSV identical to the 01 run. Issue set (severity, employee, issue, detail) identical; only order may change. In the printed list and the HTML report, every High comes before every Medium and Info | the owner's pasted stdout (TOTAL + Issues); CSV `IDENTICAL` or a row-by-row match to 01; HTML Issues-table order |
| P2 | owner | Same refresh. From `...\Locations\00122\2026\10 OCT\Week 40` (9/21–10/4), run payroll.py with prefix `122_2026-09-21_2026-10-04`. Compare ADP CSV and issue set to the payroll-adp-01 P2 run on the same folder. Check stdout and HTML order the same way as P1 | ADP CSV identical to the 01 run. Issue set identical; only order may change. In the printed list and the HTML report, every High comes before every Medium and Info | pasted stdout; CSV match to 01; HTML Issues-table order |

## Results

Write `/srv/fhs-build/reports/payroll-adp-02-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: payroll-adp-02 · Branch: feat/payroll-adp-02 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Type credentials, or click anything that changes data in Toast, R365, ADP or any site.
- Open Toast, R365 or ADP, or a browser. Run real Dropbox week folders (P1–P2 only, and only after the owner OKs a refresh).
- Refresh the Windows mirror. Put real staff names or pay into the test report.
