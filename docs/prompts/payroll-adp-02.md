# Agent task · payroll-adp-02 · build

> **For the coding agent (Composer 2.5 via `agent`; as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/payroll-adp-02.md`, to be run only after its plan review (`docs/reviews/payroll-adp-02.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/payroll-adp-02`
> and tell it "Do the task in docs/prompts/payroll-adp-02.md". Start only after payroll-adp-01 post-merge P1/P2 have run on the PC.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). This task is the four leftover nits from the payroll-adp-01
diff review, each as stated, nothing more: (1) sort the combined issue list once after contributor
issues are appended, so every High prints before every Medium and Info; (2) new NCR and toast
mismatch fixtures that prove the contributor check stays off for NCR even when tip files don't
match; (3) SKILL.md step 6 lists saved reports to the owner before ADP entry, and step 9 copies
that list into the concerns note; (4) the extract-format row for `_tip_sources.txt` says $0 lines
are allowed and ignored. You never open Toast, R365 or ADP. You do not run the real week folders
(that done-check is post-merge on the PC). Design is already chosen; do not invent another.

## Where you work

- Workspace: `/srv/fhs-build/payroll-adp-02`, your own clone of the repo. Work only here.
- Branch: create `feat/payroll-adp-02` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/payroll-adp-02.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `skills/fhs-payroll-adp/scripts/payroll.py` (`find_issues` sort key at `order = {HIGH: 0, MEDIUM: 1, INFO: 2}`, then employee; `main`'s `issues.extend(tip_contributor_issues(...))` and the leftover-tips `insert`)
4. `skills/fhs-payroll-adp/SKILL.md` (steps 6 and 9 only)
5. `skills/fhs-payroll-adp/references/extract-formats.md` (the `_tip_sources.txt` table row only)
6. `docs/fixtures/payroll-adp-01/` and `docs/tests/payroll-adp-01.md` T4 — read only; do not edit them

## Steps

1. `git switch feat/payroll-adp-02` if that branch already exists, else `git switch -c feat/payroll-adp-02`.
2. **Issue order in `payroll.py` `main` only.** `issues.extend(tip_contributor_issues(...))` runs after `find_issues` has sorted, so a High contributor issue can print after Mediums (stdout and HTML report). Sort the combined list once, immediately after that extend, with the same key `find_issues` uses: `order = {HIGH: 0, MEDIUM: 1, INFO: 2}`, then employee. Move or reuse that key; don't change it. Leave the leftover-tips `issues.insert(0, ...)` where it is (after that sort). No other `payroll.py` change: not ADP math, not the contributor-check logic, not `find_issues` itself except sharing the key if you lift it.
3. **Fixtures** under `docs/fixtures/payroll-adp-02/` (anonymised: no real staff names, no real pay). Each case is its own folder with a local `config.json` (script reads cwd `config.json` first) plus the `<prefix>_*.txt` extracts `payroll.py` needs to run (`hours`, `shifts`, `totals`, `tips`, `tip_sources`, `tip_contributors`). Fake names already used in 01 (e.g. `Alex Rivera`, `KIOSK KIOSK - 550`) are fine. Default checks apply (`store_open` 10:00 AM, `open_buffer_minutes` 60 so earliest in is 9:00 AM, `max_shift_hours` 12, `pattern_min_count` 3). Do not copy or edit `docs/fixtures/payroll-adp-01/`. Folders:
   - `order-high-medium/` — store `122` / prefix `122_2026-10-05_2026-10-18`, `pos` `toast_r365`. At least one Medium shift issue (e.g. Alex Rivera on 8:00 AM–9:00 PM × 3 days, as in 01 `quiet-kiosk/`) **and** at least one High `Tip source missing from R365 contributors` (a `_tip_sources.txt` kiosk line with Card Tips > 0 whose R365 Contributor is **missing** from `_tip_contributors.txt` that day). Keep `tips_collected` equal to ADP CC Tips paid so leftover-tips High does not fire. `missing-contributor/` in 01 does **not** already yield a Medium; do not rely on copying it alone.
   - `ncr-mismatch/` — store `878` / prefix `878_2026-10-05_2026-10-18`, `pos` `ncr`. `_tip_sources.txt` has a source with Card Tips > 0 (use `10/6/2026`, kiosk, `20.00`) that is **missing** from `_tip_contributors.txt` that day.
   - `toast-mismatch/` — store `122` / prefix `122_2026-10-05_2026-10-18`, `pos` `toast_r365`. **Same** `_tip_sources.txt` and `_tip_contributors.txt` contents as `ncr-mismatch/` (same date, source, amount, missing contributor). Quiet shifts so this run raises **exactly one** High `Tip source missing from R365 contributors` for that date and source. `_tips.txt` present so the check runs.
4. **`SKILL.md` steps 6 and 9 only.** Step 6 today lists saved reports "in the concerns note" before ADP entry, but the note is written in step 9 after ADP. Retitle step 6 so it no longer names the concerns note, and so it still says required before ADP entry. Step 6 still exports every source report into the week folder (including browser pulls) and records the list of saved file names **in the reply to the owner as part of the run notes**; it stays required before ADP entry. Step 9 copies that step 6 list into `<prefix>_concerns.md`. Step numbers stay. Headings of steps other than 6 stay. Do not change any other SKILL.md section.
5. **`extract-formats.md`, the `_tip_sources.txt` row only.** That row today says "one line per tip source per day with card tips > 0". Say lines with $0 card tips are allowed and ignored by the check. No code change for this. Do not edit any other row or section.
6. Run every Tests command below. Record the real output.

## You may edit only

- `skills/fhs-payroll-adp/scripts/payroll.py` (the sort only)
- `skills/fhs-payroll-adp/SKILL.md` (steps 6 and 9 only)
- `skills/fhs-payroll-adp/references/extract-formats.md` (the `_tip_sources.txt` row only)
- new fixtures under `docs/fixtures/payroll-adp-02/` (anonymised, no real names or pay)
- Outside the repo, only `/srv/fhs-build/reports/payroll-adp-02.md` (builder report)

## You must not

- Edit any file not listed above, or anything under `shared/`, `docs/plans/`, `docs/reviews/` or `docs/prompts/`.
- Edit `skills/fhs-payroll-adp/scripts/period.py`, `docs/fixtures/payroll-adp-01/`, any other skill, or `memory/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Log in to anything, type a password, or open Toast, R365 or ADP.
- Install packages or change system settings.
- Add config keys, change ADP math, change contributor-check logic (except the sort after extend), change existing extract columns, refresh the Windows mirror, or run real Dropbox week folders.

## Tests (run every one, record the real output)

Order: run tests 1–6, then commit (When done step 1), then run test 7 on the committed branch.

Working directory: the clone, except payroll.py runs (cwd = a **copy** of that fixture folder in `mktemp -d`; do not write `_adp_entry.csv` or `_discrepancy_report.html` into the clone). `PAYROLL=skills/fhs-payroll-adp/scripts/payroll.py`. Prefix `122_2026-10-05_2026-10-18` unless noted. `CLONE=/srv/fhs-build/payroll-adp-02`. Issue lines on stdout look like `  [High] Employee: Issue - detail` (same for Medium / Info). For a before-change compare, write `git show main:skills/fhs-payroll-adp/scripts/payroll.py` to a temp file and run that copy from the same cwd.

1. High before Medium. Copy `docs/fixtures/payroll-adp-02/order-high-medium/` to a temp dir; run `python3 "$CLONE/$PAYROLL" 122_2026-10-05_2026-10-18`. Parse stdout issue lines. `high_n` / `med_n` = counts of High / Medium lines. `order_ok=1` iff in that list every High appears before every Medium and every Info (once a Medium or Info is seen, no later High). In `122_2026-10-05_2026-10-18_discrepancy_report.html`, read Issues-table pill classes in row order the same way → `html_order_ok`. Run `main`'s payroll.py on a second copy of the same fixture → `old_n`; `count_same=1` iff new stdout issue count equals `old_n`. Print `high_n=<n> med_n=<n> order_ok=<0|1> html_order_ok=<0|1> count_same=<0|1>`. Pass if `high_n>=1`, `med_n>=1`, and the three flags are 1. At least one High must be `Tip source missing from R365 contributors`.
2. NCR gate. Copy `ncr-mismatch/` to a temp dir; run `python3 "$CLONE/$PAYROLL" 878_2026-10-05_2026-10-18`. `ncr_msg` = count of issues titled `Tip contributor check not run` **or** `Tip source missing from R365 contributors`. Copy `toast-mismatch/` to a new temp dir; run payroll.py with prefix `122_2026-10-05_2026-10-18`. `toast_high` = count of High `Tip source missing from R365 contributors`; `names_date=1` iff that High's detail (or Employee) contains `10/6` or `10/6/2026`; `names_source=1` iff it contains `kiosk` (any case). Print `ncr_msg=<n> toast_high=<n> names_date=<0|1> names_source=<0|1>`. Pass if `ncr_msg==0`, `toast_high==1`, and both names flags are 1.
3. Every `payroll-adp-01` fixture. For each of `quiet-kiosk/`, `missing-contributor/`, `contributor-ok/`, `missing-date/`, `not-run/`, `no-kiosk/` (prefix `122_2026-10-05_2026-10-18`) and `ncr/` (prefix `878_2026-10-05_2026-10-18`): copy the 01 folder to two temp dirs; run new `payroll.py` in one and `main`'s `payroll.py` in the other. `cmp -s` the two `*_adp_entry.csv` files → `IDENTICAL` or not. Issue **set** is the frozenset of `(severity, employee, issue, detail)` from parsed stdout lines (order ignored). Print per folder `csv=<IDENTICAL|DIFF> set_ok=<0|1>`. Pass if every folder is `IDENTICAL` and `set_ok=1`.
4. SKILL.md. From `$CLONE`, a `python3 -c` that splits `skills/fhs-payroll-adp/SKILL.md` on markdown headings. Find the heading whose text starts with `6.`. `step6_required=<0|1>` is 1 iff that heading contains `required before ADP entry`. `step6_no_concerns=<0|1>` is 1 iff neither that heading nor the body until the next heading contains `concerns note`. `step9_copies=<0|1>` is 1 iff the heading that starts with `9.` exists and the body until the next heading contains `_concerns.md` and (`step 6` or `step6`). Print `step6_required=<0|1> step6_no_concerns=<0|1> step9_copies=<0|1>`. Pass if all three are 1.
5. extract-formats.md. From `$CLONE`, a `python3 -c` that finds the table row whose first cell is `` `_tip_sources.txt` `` (or `_tip_sources.txt`) and prints `zero_ok=<0|1>`: 1 iff that row's text contains `$0` (or `0 card`) and (`allowed` or `ignored`). Pass if `zero_ok==1`.
6. `python3 -m py_compile skills/*/scripts/*.py` → exit 0.
7. After the commit (only then): `git log --oneline main..HEAD` → at least one commit; `git diff --name-only main...HEAD` → only paths under `skills/fhs-payroll-adp/scripts/payroll.py`, `skills/fhs-payroll-adp/SKILL.md`, `skills/fhs-payroll-adp/references/extract-formats.md`, and `docs/fixtures/payroll-adp-02/`. `git status --short` → empty.

## When done

1. Commit on `feat/payroll-adp-02` after tests 1–6 and before test 7. End the message with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/payroll-adp-02.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: payroll-adp-02 · Branch: feat/payroll-adp-02 · Commits: <hashes>
Files changed: <list>
Tests: <n>/7 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
