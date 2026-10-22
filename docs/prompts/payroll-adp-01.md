# Agent task · payroll-adp-01 · build

> **For the coding agent (Composer 2.5 via `agent`; as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/payroll-adp-01.md`, to be run only after its plan review (`docs/reviews/payroll-adp-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/payroll-adp-01`
> and tell it "Do the task in docs/prompts/payroll-adp-01.md". Start only after Ops has copied `/root/fhs-skills/inbox/Tip Automation Distributions Report 10-05 to 10-18.pdf` to `/srv/fhs-build/reports/payroll-adp-01/`.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). This task is three payroll-skill fixes from the 10/5–10/18
Cary 1 run: (a) `SKILL.md` requires exporting every source report into the week folder (including
browser pulls) and listing those files in the concerns note, before ADP entry; (b) `payroll.py`
stops flagging `non_employee_accounts` (the kiosk) for per-shift and OT checks; (c) a new High
check, toast_r365 only, that a Toast tip source with card tips > 0 that day appears as a contributor
in that day's R365 Tip Automation data. You never open Toast, R365 or ADP. You do not run the
real week folders (that done-check is post-merge on the PC). Design is already chosen; do not invent another.

## Where you work

- Workspace: `/srv/fhs-build/payroll-adp-01`, your own clone of the repo. Work only here.
- Branch: create `feat/payroll-adp-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- PDF (read only, outside the repo, already copied for you): `/srv/fhs-build/reports/payroll-adp-01/Tip Automation Distributions Report 10-05 to 10-18.pdf`. Do not edit, move, or commit it.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/payroll-adp-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `skills/fhs-payroll-adp/SKILL.md`
4. `skills/fhs-payroll-adp/scripts/payroll.py` (`key()`, `find_issues`, `non_employee_accounts_keys`, issue titles)
5. `skills/fhs-payroll-adp/references/extract-formats.md`
6. `skills/fhs-payroll-adp/references/browser-recipes.md`
7. `memory/save-source-reports.md` and `memory/payroll-rules.md` (R365 Tip Automation gap, 10/21) — read only; do not edit `memory/`

## Steps

1. `git switch feat/payroll-adp-01` if that branch already exists, else `git switch -c feat/payroll-adp-01`.
2. Confirm the PDF exists at `/srv/fhs-build/reports/payroll-adp-01/Tip Automation Distributions Report 10-05 to 10-18.pdf`. If it is missing, stop and write the report with that reason.
3. **First implementation step — PDF, not a guessed screen.** Read that PDF's text layer. Confirm which R365 report section lists contributors per day (the Distributions Report may have a contributors section next to "Daily Rules - Receivers"). `[NEEDS CLARIFICATION]` until the PDF shows it. If the PDF has no per-day contributors (no such section, or no text layer you can read), **stop**, leave `[NEEDS CLARIFICATION]`, write the report with that reason, and do not guess a screen. Do not implement the contributor check from a guessed UI. Do not commit the PDF (real names and pay).
4. **`extract-formats.md`.** Keep every existing extract and column. Add two **optional** files to the table and document how to fill them:
   - `_tip_sources.txt` = `Date|Source|Card Tips|R365 Contributor` — one line per tip source per day with card tips, from Toast (the Labor Summary / Time Entries already in this file; do not add a new Toast screen). Last column is the contributor name as the R365 tip rule lists it (kiosk → `KIOSK USER`). Date as `M/D/YYYY` (same date shape as `_shifts` In/Out).
   - `_tip_contributors.txt` = `Date|Contributor|Amount` — from R365 Tip Automation for that day. Name **only** the section heading the PDF shows, and how its columns map to Date, Contributor, Amount. Do not name any other R365 screen.
5. **Quiet the kiosk in `payroll.py`.** Skip **all** per-shift checks and the OT check for `cfg["non_employee_accounts_keys"]` (122 already lists `KIOSK KIOSK - 550` and `KIOSK - 550, KIOSK`). Do not emit, for a non-employee account: Very long shift, Clock-in before store hours, Likely auto clock-out, Missing clock-out, Overlapping shifts, Very short shift, Clock-out after store hours, Shift much longer than usual, Stayed after everyone else left, Punch with no hours counted, Has shifts but missing from hours report, Overtime, or Repeated-pattern issues. Do not add Info "Excluded from payroll" for them (that stays for `exclude_from_payroll` only). Extraction-total checks and tip-payout checks stay. No new config keys. ADP math unchanged (non-employees already omitted from ADP rows).
6. **Tip-contributor check in `payroll.py`** (do not change ADP figures):
   - Run only when store `pos` is `toast_r365` **and** both new files exist **and** `_tips.txt` is present. Then: for each `_tip_sources` line with Card Tips > 0, its R365 Contributor must appear on that date in `_tip_contributors` (loose name match with existing `key()`). Else High issue title exactly `Tip source missing from R365 contributors`, detail naming the date, the Toast **Source**, and the amount. A date that appears in `_tip_sources` with no rows for that date in `_tip_contributors` is High too (same title; each Card Tips > 0 line on that date). Source with $0 card tips → no issue.
   - `pos` is `toast_r365` and `_tips.txt` is present but either new file is missing → one Medium issue title exactly `Tip contributor check not run`. Do not run the High check.
   - `pos` is `ncr`: no check, no message (even if the new files exist or `_tips.txt` exists).
7. **`SKILL.md`.** Make "export every source report to the week folder and list it in the concerns note" a **required** workflow step **before** ADP entry, including browser pulls. That step must name listing the saved files in the concerns note. Example names already used: `Labor Payroll Review (Detail) 10-05 to 10-18.pdf`, `Tip Automation Distributions Report 10-05 to 10-18.pdf`. Add the new High and the Medium "not run" to the discrepancy-checks table. In the extract step (step 3), add one line: toast_r365 stores also write `_tip_sources.txt` and `_tip_contributors.txt` (see `extract-formats.md`) so the contributor check runs. Do not add other workflow.
8. **`browser-recipes.md` — export steps only.** Add R365 report-viewer export: Export icon → PDF, Page Scaling "Adjust 100%", EXPORT, real clicks (a JS click does not trigger the download). Do not change login, RUN, or pull recipes except to add this export path.
9. **Fixtures** under `docs/fixtures/payroll-adp-01/` (anonymised: no real staff names, no real pay). Each case is its own folder with a local `config.json` (script reads cwd `config.json` first) plus `<prefix>_*.txt`. Use store `122` / prefix `122_2026-10-05_2026-10-18` unless noted. Default checks apply (`store_open` 10:00 AM, `open_buffer_minutes` 60 so earliest in is 9:00 AM, `max_shift_hours` 12, `pattern_min_count` 3). 9:00 AM–9:00 PM is exactly the open buffer and exactly 12 h — **do not** use that window; use times that **do** fire the flags for a real employee (8:00 AM–9:00 PM = 13 h, clock-in before 9:00 AM, 3+ such days for the pattern). Folders:
   - `quiet-kiosk/` — `KIOSK KIOSK - 550` in `non_employee_accounts`; same 8:00 AM–9:00 PM shifts plus OT on the kiosk **and** on one fake employee (e.g. `Alex Rivera`); both new tip files present and matching so the contributor check is quiet.
   - `missing-contributor/` — `_tips.txt` present; `_tip_sources` one kiosk line Card Tips `20.00` on `10/6/2026`; `_tip_contributors` for that date **without** KIOSK USER.
   - `contributor-ok/` — same as missing-contributor but KIOSK USER present on 10/6; also a source line with $0 card tips.
   - `missing-date/` — `_tips.txt` present; a `_tip_sources` date with Card Tips > 0 that has **no** rows in `_tip_contributors`.
   - `not-run/` — `pos` `toast_r365`, `_tips.txt` present, neither new file present; shifts that do not themselves raise High/Medium noise.
   - `ncr/` — store `878`, prefix `878_2026-10-05_2026-10-18`, `pos` `ncr`; `_tips.txt` present; new files may be present.
   - `no-kiosk/` — `pos` `toast_r365`, no kiosk lines, no new tip files. **Before changing `payroll.py`** (or via `git show main:skills/fhs-payroll-adp/scripts/payroll.py` in a temp copy), run it from this folder and save the ADP CSV as `expected_adp_entry.csv` in the same folder. After the change, the new CSV must be byte-identical to that file.
10. Run every Tests command below. Record the real output.

## You may edit only

- `skills/fhs-payroll-adp/SKILL.md`
- `skills/fhs-payroll-adp/scripts/payroll.py`
- `skills/fhs-payroll-adp/references/extract-formats.md`
- `skills/fhs-payroll-adp/references/browser-recipes.md` (export steps only)
- test fixtures under `docs/fixtures/payroll-adp-01/` (anonymised, no real names or pay)
- Outside the repo, only `/srv/fhs-build/reports/payroll-adp-01.md` (builder report)

## You must not

- Edit any file not listed above, or anything under `shared/`, `docs/plans/`, `docs/reviews/` or `docs/prompts/`.
- Edit `skills/fhs-payroll-adp/scripts/period.py`, any other skill, or `memory/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Log in to anything, type a password, or open Toast, R365 or ADP.
- Copy, move, or commit the PDF. Install packages or change system settings.
- Add config keys, change ADP math, change existing extract columns, refresh the Windows mirror, or run real Dropbox week folders.

## Tests (run every one, record the real output)

Order: run tests 1–7, then commit (When done step 1), then run test 8 on the committed branch.

Working directory: the clone, except payroll.py runs (cwd = that fixture folder). `PAYROLL=skills/fhs-payroll-adp/scripts/payroll.py`. Prefix `122_2026-10-05_2026-10-18` unless noted.

1. Quiet kiosk. From `docs/fixtures/payroll-adp-01/quiet-kiosk/`: `python3 "$CLONE/$PAYROLL" 122_2026-10-05_2026-10-18`. Expect: **no** Very long shift, Clock-in before store hours, Overtime, or Repeated-pattern issue whose employee is `KIOSK KIOSK - 550`; the fake employee with the same shifts **is** flagged for those. Print kiosk_hit=<n> employee_hit=<n>. Pass if `kiosk_hit == 0` and `employee_hit >= 1` for each of those four issue kinds.
2. Missing contributor. From `missing-contributor/`: run payroll.py. Expect **one** High `Tip source missing from R365 contributors` whose detail names `10/6` (or `10/6/2026`), kiosk, and `$20` / `20.00`. Print high_n=<n> names_date=<0|1> names_source=<0|1> names_amt=<0|1>. Pass if `high_n == 1` and the three names flags are 1.
3. Contributor present / $0 / missing date. From `contributor-ok/`: run payroll.py → **zero** High `Tip source missing from R365 contributors` (KIOSK USER present; $0 card tips is not an issue). From `missing-date/`: run payroll.py → at least one High `Tip source missing from R365 contributors`. Print ok_high=<n> missing_date_high=<n>. Pass if `ok_high == 0` and `missing_date_high >= 1`.
4. Not run / NCR. From `not-run/`: run payroll.py → **one** Medium `Tip contributor check not run` and zero High contributor issues. From `ncr/` (prefix `878_2026-10-05_2026-10-18`): run payroll.py → **zero** issues titled `Tip contributor check not run` or `Tip source missing from R365 contributors`. Print med=<n> ncr_msg=<n>. Pass if `med == 1` and `ncr_msg == 0`.
5. ADP CSV unchanged. From `no-kiosk/`: run payroll.py; `cmp -s 122_2026-10-05_2026-10-18_adp_entry.csv expected_adp_entry.csv && echo IDENTICAL`. Pass if `IDENTICAL`.
6. SKILL.md. A `python3 -c` that prints `save_before_adp=<0|1> names_concerns=<0|1>`: `save_before_adp` is 1 iff the required export/save of every source report into the week folder (including browser pulls) appears **before** the ADP RUN entry heading; `names_concerns` is 1 iff that save step names listing the saved files in the concerns note. Pass if both are 1.
7. `python3 -m py_compile skills/*/scripts/*.py` → exit 0.
8. After the commit (only then): `git log --oneline main..HEAD` → at least one commit; `git diff --name-only main...HEAD` → only paths under `skills/fhs-payroll-adp/SKILL.md`, `skills/fhs-payroll-adp/scripts/payroll.py`, `skills/fhs-payroll-adp/references/extract-formats.md`, `skills/fhs-payroll-adp/references/browser-recipes.md`, and `docs/fixtures/payroll-adp-01/`. `git status --short` → empty.

## When done

1. Commit on `feat/payroll-adp-01` after tests 1–7 and before test 8. End the message with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/payroll-adp-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: payroll-adp-01 · Branch: feat/payroll-adp-01 · Commits: <hashes>
Files changed: <list>
PDF section used for _tip_contributors: <exact heading, or stopped>
Tests: <n>/8 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
