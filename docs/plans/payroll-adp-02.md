# Plan · payroll-adp-02 · Clean up the four minors from payroll-adp-01

Drafted by Cursor Grok 4.6 High from docs/briefs/payroll-adp-02.md.

2026-10-22. Plan only, not approved. Don't build from it until `docs/reviews/payroll-adp-02.md` holds an APPROVE for this file.
The reviewer checks this plan, its task file `docs/prompts/payroll-adp-02.md`, and its test plan `docs/tests/payroll-adp-02.md` together.
Don't add scope.

- Hub project: `projects/payroll` · Phase: none · Spec: none (follow-up to `docs/reviews/payroll-adp-01-diff.md` r2 APPROVE, merged `2756ff6`; the four non-blocking minors)
- Decisions that bind it: same as `docs/briefs/payroll-adp-01.md` (owner 2026-10-21: R365 tip amounts go to ADP after refresh; save source reports; owner OK 2026-10-22: `KIOSK KIOSK - 550` added to 122 `non_employee_accounts`, commit `db0d7ce`); nothing new
- Research to rely on: `skills/fhs-payroll-adp/references/extract-formats.md`, `docs/tests/payroll-adp-01.md` (T4 and the fixtures in `docs/fixtures/payroll-adp-01/`)
- `ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`)

## Verdict

Build.

## What changes, in plain words

Four leftover nits from the payroll-adp-01 review, each as stated, nothing more. High issues print before Medium and Info in stdout and the HTML report. A new NCR fixture proves the contributor check stays off for NCR even when tip files don't match. Step 6 lists saved reports to the owner before ADP entry; step 9 copies that list into the concerns note. The extract-format row for `_tip_sources.txt` says $0 lines are allowed and ignored.

## Design (already chosen; do not invent another)

1. **Issue order.** In `skills/fhs-payroll-adp/scripts/payroll.py` `main`, `issues.extend(tip_contributor_issues(...))` runs after `find_issues` has sorted, so a High contributor issue can print after Mediums (stdout and HTML report). Sort the combined list once, after the extend, with the same key `find_issues` uses (`order = {HIGH: 0, MEDIUM: 1, INFO: 2}`, then employee). Move or reuse that key; don't change it. No other `payroll.py` change.
2. **NCR gate not proven.** `docs/fixtures/payroll-adp-01/ncr/` has tip files that already match, so T4's `ncr_msg=0` would pass even without the `pos != toast_r365` gate. Add a new fixture `docs/fixtures/payroll-adp-02/ncr-mismatch/` (878, `pos` = ncr) whose `_tip_sources.txt` has a source with card tips > 0 that is **missing** from `_tip_contributors.txt` that day, plus a control copy `toast-mismatch/` with the same tip files under a `toast_r365` config that must raise the High. Include the anonymised extracts `payroll.py` needs to run (no real names or pay). Leave the 01 fixtures as they are.
3. **SKILL.md step order.** Step 6 says to list saved reports "in the concerns note" before ADP entry, but the note is written in step 9 after ADP. Step 6 records the list of saved file names in the reply to the owner as part of the run notes, and stays required before ADP entry. Step 9 copies that list into `<prefix>_concerns.md`. Step numbers stay. Headings of steps other than 6 stay. Step 6's heading today names the concerns note; retitle it so it no longer does, and so it still says required before ADP entry.
4. **extract-formats.md.** The `_tip_sources.txt` row says "one line per tip source per day with card tips > 0". Say lines with $0 card tips are allowed and ignored by the check. No code change for this. Edit that row only.

## Files the builder may edit

- `skills/fhs-payroll-adp/scripts/payroll.py` (the sort only)
- `skills/fhs-payroll-adp/SKILL.md` (steps 6 and 9 only)
- `skills/fhs-payroll-adp/references/extract-formats.md` (the `_tip_sources.txt` row only)
- new fixtures under `docs/fixtures/payroll-adp-02/` (anonymised, no real names or pay)
- Outside the repo, only `/srv/fhs-build/reports/payroll-adp-02.md` (builder report)

## Files the builder must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- `skills/fhs-payroll-adp/scripts/period.py`
- `docs/fixtures/payroll-adp-01/`
- Any other skill
- The PC mirror `C:\fhs\fhs-skills`
- Everything else, inside or outside the clone

## Live systems touched

None.

## Done-check (real outcome)

Same real folders as payroll-adp-01 P1/P2, after the next owner-OK'd PC mirror refresh (one refresh carries 01 and 02): rerun `payroll.py` on `00122\2026\10 OCT\Week 42` and `Week 40`. ADP CSV identical to the 01 run on the same folder; issue list identical as a set; in the printed list and HTML report every High comes before every Medium and Low. On the server: the ADP CSV for each 01 fixture is byte-identical before and after the change.

## Where it runs

Both. Server sessions run `main` via `/root/.claude/skills/fhs-*`. Payroll runs on the owner's Windows desktop from the mirror `C:\fhs\fhs-skills` (Dropbox week folders; `py` on `payroll.py`). Deploying the change to the desktop is a mirror refresh (a separate OK). Windows apps: whatever the current payroll run already uses (Dropbox, Chrome if a report is pulled in the browser). Config stays as is.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. Merge is the release for server sessions.
- **Windows mirror:** affected. It stays on its current version until the owner OKs a refresh (its own OK). One refresh carries 01 and 02. Nothing on the desktop counts as this change until that refresh.
- **Live before merge:** payroll-adp-01 as merged at `2756ff6` (contributor issues appended after the sort; 01 NCR fixture already matches; SKILL step 6 names the concerns note before ADP; `_tip_sources.txt` row says card tips > 0).

## Where the builder works

`/srv/fhs-build/payroll-adp-02` via `scripts/build.sh prepare docs/plans/payroll-adp-02.md payroll-adp-02 --role build`. `prepare` clones `main` at the commit that holds this plan, its task file, the test plan and the APPROVE review; the builder creates `feat/payroll-adp-02` in that clone per the task. Model `composer-2.5`, user `fhsbuild`. Starts only after payroll-adp-01 post-merge P1/P2 have run on the PC.

## Sequence

`ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/payroll-adp-02.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/payroll-adp-02.md`, `docs/tests/payroll-adp-02.md` and that review to `main` before prepare.
2. Gate: payroll-adp-01 post-merge P1/P2 have run on the PC.
3. `build.sh prepare docs/plans/payroll-adp-02.md payroll-adp-02 --role build`.
4. Builder (Composer 2.5): edit only the files listed above.
5. A fresh Composer tester (`composer-2.5`) runs `docs/tests/payroll-adp-02.md`.
6. `build.sh collect payroll-adp-02`.
7. `review.sh --diff feat/payroll-adp-02 --writer composer`. The reviewer is `cursor-grok-4.6-xhigh`. It must be APPROVE. Merge on APPROVE with every pre-merge test PASS.
8. Post-merge: owner OKs a Windows mirror refresh (one refresh carries 01 and 02), then the done-check on the real Week 42 and Week 40 folders. A failure opens a fix plan.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No builder-written code runs as root until the diff review is APPROVE.

## Test plan

`docs/tests/payroll-adp-02.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner/PC cases are post-merge (not a merge gate). Cases the test plan must include:

- Fixture with at least one Medium shift issue and one High contributor issue (new under `payroll-adp-02/`, or a copy of `missing-contributor/` if it already yields a Medium) → in stdout and the HTML report the High line comes before every Medium; total issue count same as before the change.
- `ncr-mismatch/` → zero issues named `Tip contributor check not run` or `Tip source missing from R365 contributors`. `toast-mismatch/` (same tip files, toast_r365) → exactly one High `Tip source missing from R365 contributors` for that date and source. Together these prove the gate.
- Every `payroll-adp-01` fixture: ADP CSV byte-identical to `main` before the change; issue set (severity, employee, issue, detail) identical; only order may change.
- SKILL.md (grep): step 6 no longer says to write the list "in the concerns note" before ADP; step 6 still says required before ADP entry; step 9 says to copy the step 6 list into `_concerns.md`.
- extract-formats.md (grep): the `_tip_sources.txt` row says $0 lines are allowed and ignored.
- `python3 -m py_compile skills/*/scripts/*.py`.

Post-merge (PC, after refresh OK): the done-check Week 42 / Week 40 reruns above.

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

ADP math, the daily tip rule, shared-login handling, Miguel's 100-hour bonus, the leftover-tips insert, `period.py`, existing extract files and their columns, the contributor-check logic (except the sort after extend), NCR payroll except that it never runs the contributor check, every `shared/config.json` key, and every `docs/fixtures/payroll-adp-01/` file. SKILL.md steps other than 6 and 9 stay. No Toast, R365 or ADP setting is changed. The Windows mirror is unchanged until its own OK. A later plan may change a tip rule or a live system, each with the owner's yes at the time.
