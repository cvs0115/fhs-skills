# Test plan · payroll-adp-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/payroll-adp-01.md".

## What's being tested

The payroll skill exports every source report into the week folder (including browser pulls) and lists those files in the concerns note **before** ADP entry; it skips all per-shift and OT flags for `non_employee_accounts` (the kiosk); and on toast_r365 stores it raises High when a Toast tip source with card tips > 0 is missing from that day's R365 Tip Automation contributors. This proves the plan's done-check: after a Windows mirror refresh, Week 42 ADP figures stay 294.94 reg / 5.67 OT / CC tips $869.95 / Miguel bonus $43.04 with zero kiosk shift/OT issues and a passing contributor check; Week 40 flags each day from 9/26 with kiosk card tips > 0 and no KIOSK USER, matching Toast, or the owner confirms those days are fine.
Plan: `docs/plans/payroll-adp-01.md` · Builder report: `/srv/fhs-build/reports/payroll-adp-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/payroll-adp-01` on branch `feat/payroll-adp-01`, as `fhsbuild` | run commands; edit nothing in the repo |
| browser-server | not used | never open Toast, R365 or ADP |
| browser-windows | not used | same; no capture |
| owner | the owner (or a Windows payroll session they start) runs the real week folders after a mirror refresh and pastes the result | write down exactly what they report |

No browser cases. Pre-merge uses the clone and its fixtures only. Post-merge P1–P2 run on the PC after the owner OKs a refresh; mark them BLOCKED until that output is pasted.

Browser rules: N/A. Do not open a browser, Toast, R365 or ADP. Never type a username or password. Never click save, submit, approve, pay, send or delete.

## Preconditions

- Builder report `/srv/fhs-build/reports/payroll-adp-01.md` exists. You are in `/srv/fhs-build/payroll-adp-01` on `feat/payroll-adp-01` as `fhsbuild`.
- Set `CLONE=/srv/fhs-build/payroll-adp-01` and `PAYROLL=$CLONE/skills/fhs-payroll-adp/scripts/payroll.py`. Prefix is `122_2026-10-05_2026-10-18` unless a case names another.
- Fixture folders exist under `$CLONE/docs/fixtures/payroll-adp-01/`: `quiet-kiosk/`, `missing-contributor/`, `contributor-ok/`, `missing-date/`, `not-run/`, `ncr/`, `no-kiosk/`. If a named folder is missing, that case is BLOCKED (fixtures missing), not FAIL.
- For every `payroll.py` case: copy that fixture folder to a temp dir (`mktemp -d`) and run from the copy. Do not write `_adp_entry.csv` or `_discrepancy_report.html` into the clone.
- Issue lines on stdout look like `  [High] Employee: Issue - detail` (same for Medium / Info). Parse those; do not use the HTML (it stamps a clock time).
- Do not run real Dropbox week folders. Do not read or copy the Distributions PDF (real names and pay). Do not refresh the Windows mirror.
- If the builder report Summary says it **stopped** (PDF had no per-day contributors), still run every case. Missing fixtures → BLOCKED as above.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | Copy `$CLONE/docs/fixtures/payroll-adp-01/quiet-kiosk/` to a temp dir; `cd` there; `python3 "$PAYROLL" 122_2026-10-05_2026-10-18`. Parse stdout issue lines. An issue is **kiosk** when Employee is `KIOSK KIOSK - 550` (or the name contains `KIOSK` and no other person in the run does). Four kinds: Issue exactly `Very long shift`; exactly `Clock-in before store hours`; exactly `Overtime`; Issue starts with `Repeated`. For each kind print `kiosk_hit=<n> employee_hit=<n>` (employee = not kiosk). Print four pairs labeled `very_long`, `early`, `ot`, `repeated`. | For each of the four kinds: `kiosk_hit=0` and `employee_hit>=1`. No very-long-shift, early clock-in, OT, or repeated-pattern issue for the kiosk; the fake employee with the same shifts is flagged for those | command + trimmed stdout + the four `kiosk_hit` / `employee_hit` pairs |
| T2 | shell | Copy `missing-contributor/` to a temp dir; run `python3 "$PAYROLL" 122_2026-10-05_2026-10-18`. Count High issues whose Issue is exactly `Tip source missing from R365 contributors`. On that one High, `names_date=1` iff the detail (or Employee) contains `10/6` or `10/6/2026`; `names_source=1` iff it contains `kiosk` (any case); `names_amt=1` iff it contains `$20` or `20.00`. Print `high_n=<n> names_date=<0\|1> names_source=<0\|1> names_amt=<0\|1>` | `high_n=1 names_date=1 names_source=1 names_amt=1`. One High naming 10/6, kiosk, and $20 | command + trimmed stdout + the printed flags |
| T3 | shell | Copy `contributor-ok/` to a temp dir; run payroll.py with the same prefix. Count High `Tip source missing from R365 contributors` → `ok_high`. Copy `missing-date/` to a new temp dir; run payroll.py → count the same High title → `missing_date_high`. Print `ok_high=<n> missing_date_high=<n>` | `ok_high=0 missing_date_high>=1`. KIOSK USER present and a $0 card-tips source: no High. A `_tip_sources` date with no `_tip_contributors` rows: High | both commands + trimmed stdout + the two counts |
| T4 | shell | Copy `not-run/` to a temp dir; run payroll.py (prefix `122_2026-10-05_2026-10-18`). `med` = count of issues whose Issue is exactly `Tip contributor check not run`; `not_run_high` = count of High `Tip source missing from R365 contributors`. Copy `ncr/` to a new temp dir; run `python3 "$PAYROLL" 878_2026-10-05_2026-10-18`. `ncr_msg` = count of issues whose Issue is `Tip contributor check not run` **or** `Tip source missing from R365 contributors`. Print `med=<n> not_run_high=<n> ncr_msg=<n>` | `med=1 not_run_high=0 ncr_msg=0`. toast_r365 with `_tips.txt` and neither new file: one Medium "not run". NCR: no contributor message | both commands + trimmed stdout + the three counts |
| T5 | shell | Copy `no-kiosk/` to a temp dir; run `python3 "$PAYROLL" 122_2026-10-05_2026-10-18`. Then `cmp -s 122_2026-10-05_2026-10-18_adp_entry.csv expected_adp_entry.csv && echo IDENTICAL`. If `expected_adp_entry.csv` is missing, BLOCKED (no before-change CSV), not FAIL | `IDENTICAL`. ADP CSV byte-identical to the capture from before the `payroll.py` change | command + `IDENTICAL` or `cmp` message |
| T6 | shell | From `$CLONE`, a `python3 -c` that reads `skills/fhs-payroll-adp/SKILL.md`. Find the first markdown heading whose text contains `Enter in ADP RUN`. `save_before_adp=1` iff that heading exists and the text **before** it contains `every source report` and `browser`. `names_concerns=1` iff a 400-character window around `every source report` (in that same before-ADP text) contains `concerns` and (`list` or `listing`). Print `save_before_adp=<0\|1> names_concerns=<0\|1>` | `save_before_adp=1 names_concerns=1`. The save-source-reports step is before ADP entry and names listing the saved files in the concerns note | command + printed flags; the heading text; the save-step sentence |
| T7 | shell | From `$CLONE`: `python3 -m py_compile skills/*/scripts/*.py; echo exit=$?` | `exit=0`. Every skill script compiles | command + trimmed output |
| T8 | shell | From `$CLONE`: `git diff --name-only main...HEAD`; `git status --short`. Allowed paths only: `skills/fhs-payroll-adp/SKILL.md`, `skills/fhs-payroll-adp/scripts/payroll.py`, `skills/fhs-payroll-adp/references/extract-formats.md`, `skills/fhs-payroll-adp/references/browser-recipes.md`, and anything under `docs/fixtures/payroll-adp-01/`. Print `extra=<n>` = count of other paths and `commits=<n>` from `git log --oneline main..HEAD`. Run on the builder's committed branch (T1–T5 run in temp dirs and don't touch the clone) | `commits>=1`, `extra=0`; `git status --short` empty. Only the plan's allowed files | both commands + path list + `extra=` |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T8 are the merge gate. Mark P1 and P2 BLOCKED until the owner OKs a Windows mirror refresh and pastes the runs. Do not treat a missing refresh as FAIL.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | After the owner OKs a refresh of `C:\fhs\fhs-skills`, from the real 122 week folder `...\Locations\00122\2026\10 OCT\Week 42` (10/5–10/18), run `py` on `skills\fhs-payroll-adp\scripts\payroll.py` with prefix `122_2026-10-05_2026-10-18`. Read the TOTAL line and the Miguel row from stdout (and the CSV if pasted). Count kiosk issues of the four T1 kinds. Count High `Tip source missing from R365 contributors` and Medium `Tip contributor check not run` | TOTAL Regular Hours `294.94`, OT `5.67`, CC tips `869.95`; Miguel bonus `43.04`. Zero of the four T1 kinds for the kiosk. Zero High contributor issues. Zero Medium `Tip contributor check not run` | the owner's pasted stdout (TOTAL + Miguel + Issues); any kiosk or contributor hits |
| P2 | owner | Same refresh. From `...\Locations\00122\2026\10 OCT\Week 40` (9/21–10/4), run payroll.py with prefix `122_2026-09-21_2026-10-04`. List High `Tip source missing from R365 contributors` with date and kiosk amount. Compare to Toast per-day kiosk card tips on/after 9/26 (from `_tip_sources.txt` in that folder, or the owner's Toast figures). If `_tip_sources.txt` is missing, BLOCKED (extracts not present) unless the owner confirms the days. The owner may instead confirm those days are fine | High on each day from 9/26 with kiosk card tips > 0 and no KIOSK USER contributor, **or** the owner confirms those days are fine. The count of flagged days and their kiosk tip amounts match Toast | pasted Issues lines; the date/amount list vs Toast; or the owner's words |

## Results

Write `/srv/fhs-build/reports/payroll-adp-01-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: payroll-adp-01 · Branch: feat/payroll-adp-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Type credentials, or click anything that changes data in Toast, R365, ADP or any site.
- Open Toast, R365 or ADP, or a browser. Run real Dropbox week folders (P1–P2 only, and only after the owner OKs a refresh).
- Refresh the Windows mirror. Copy, move, or commit the Distributions PDF. Put real staff names or pay from that PDF into the test report.
