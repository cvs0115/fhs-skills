# Brief · payroll-adp-02 · Clean up the four minors from payroll-adp-01

2026-10-22. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/payroll-adp-02.md` (form `docs/templates/plan.md`), `docs/prompts/payroll-adp-02.md` and `docs/tests/payroll-adp-02.md`. Don't add scope.

- Spec: none (follow-up to `docs/reviews/payroll-adp-01-diff.md` r2 APPROVE, merged `2756ff6`; the four non-blocking minors) · Hub project: `projects/payroll` · Binding decisions: same as `docs/briefs/payroll-adp-01.md`; nothing new
- Research to rely on: `skills/fhs-payroll-adp/references/extract-formats.md`, `docs/tests/payroll-adp-01.md` (T4 and the fixtures in `docs/fixtures/payroll-adp-01/`)

## Problem and decision (3–5 lines)

The payroll-adp-01 diff review left four minors. Fix each as stated, nothing more:
1. **Issue order.** In `skills/fhs-payroll-adp/scripts/payroll.py` `main`, `issues.extend(tip_contributor_issues(...))` runs after `find_issues` has sorted, so a High contributor issue can print after Mediums (stdout and HTML report). Decision: sort the combined list once, after the extend, with the same key `find_issues` uses (severity order, then employee). Move or reuse that key; don't change it.
2. **NCR gate not proven.** `docs/fixtures/payroll-adp-01/ncr/` has tip files that already match, so T4's `ncr_msg=0` would pass even without the `pos != toast_r365` gate. Decision: add a new fixture `docs/fixtures/payroll-adp-02/ncr-mismatch/` (878, `pos` = ncr) whose `_tip_sources.txt` has a source with card tips > 0 that is **missing** from `_tip_contributors.txt` that day, plus a control copy `toast-mismatch/` with the same tip files under a `toast_r365` config that must raise the High. Leave the 01 fixtures as they are.
3. **SKILL.md step order.** Step 6 says to list saved reports "in the concerns note" before ADP entry, but the note is written in step 9 after ADP. Decision: step 6 records the list of saved file names (say where: in the reply to the owner as part of the run notes) and stays required before ADP entry; step 9 copies that list into `<prefix>_concerns.md`. Step numbers and headings otherwise stay.
4. **extract-formats.md.** The `_tip_sources.txt` row says "one line per tip source per day with card tips > 0". Decision: say lines with $0 card tips are allowed and ignored by the check. No code change for this.

## Files the builder may edit / must not edit

- may: `skills/fhs-payroll-adp/scripts/payroll.py` (the sort only), `skills/fhs-payroll-adp/SKILL.md` (steps 6 and 9 only), `skills/fhs-payroll-adp/references/extract-formats.md` (the `_tip_sources.txt` row only), new fixtures under `docs/fixtures/payroll-adp-02/` (anonymised, no real names or pay)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, `period.py`, `docs/fixtures/payroll-adp-01/`, any other skill, the PC mirror

## Live systems touched

None.

## Done-check (real outcome)

Same real folders as payroll-adp-01 P1/P2, after the next owner-OK'd PC mirror refresh (one refresh carries 01 and 02): rerun `payroll.py` on `00122\2026\10 OCT\Week 42` and `Week 40`. ADP CSV identical to the 01 run on the same folder; issue list identical as a set; in the printed list and HTML report every High comes before every Medium and Low. On the server: the ADP CSV for each 01 fixture is byte-identical before and after the change.

## Where it runs and which tree is live

Both. Server sessions run `main` via the `/root/.claude/skills/fhs-*` symlinks; payroll runs on the Windows PC from the mirror `C:\fhs\fhs-skills`, which stays on its current version until the owner OKs a refresh (its own OK). Build in `/srv/fhs-build/payroll-adp-02`, started only after payroll-adp-01 post-merge P1/P2 have run on the PC. Config stays as is.

## Tests the test plan must include

- Fixture with at least one Medium shift issue and one High contributor issue (new under `payroll-adp-02/`, or a copy of `missing-contributor/` if it already yields a Medium) → in stdout and the HTML report the High line comes before every Medium; total issue count same as before the change.
- `ncr-mismatch/` → zero issues named `Tip contributor check not run` or `Tip source missing from R365 contributors`. `toast-mismatch/` (same tip files, toast_r365) → exactly one High `Tip source missing from R365 contributors` for that date and source. Together these prove the gate.
- Every `payroll-adp-01` fixture: ADP CSV byte-identical to `main` before the change; issue set (severity, employee, issue, detail) identical; only order may change.
- SKILL.md (grep): step 6 no longer says to write the list "in the concerns note" before ADP; step 6 still says required before ADP entry; step 9 says to copy the step 6 list into `_concerns.md`.
- extract-formats.md (grep): the `_tip_sources.txt` row says $0 lines are allowed and ignored.
- `python3 -m py_compile skills/*/scripts/*.py`.

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
