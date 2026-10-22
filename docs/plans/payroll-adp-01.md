# Plan · payroll-adp-01 · Save source reports, quiet kiosk, tip-contributor check

Drafted by Cursor Grok 4.6 High from docs/briefs/payroll-adp-01.md.

2026-10-22. Plan only, not approved. Don't build from it until `docs/reviews/payroll-adp-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its task file `docs/prompts/payroll-adp-01.md`, and its test plan `docs/tests/payroll-adp-01.md` together.
Don't add scope.

- Hub project: `projects/payroll` · Phase: none · Spec: none (bug-fix path from the 10/21/2026 payroll run)
- Decisions that bind it: owner 2026-10-21 (R365 tip amounts go to ADP after refresh; save source reports); owner OK 2026-10-22 (`KIOSK KIOSK - 550` added to 122 `non_employee_accounts`, commit `db0d7ce`)
- Research to rely on: `skills/fhs-payroll-adp/references/extract-formats.md`, `memory/payroll-rules.md` (R365 Tip Automation gap, 10/21), `memory/save-source-reports.md`
- `ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`)

## Verdict

Build.

## What changes, in plain words

The 10/5–10/18 payroll for Cary 1 missed three things. From now on, every source report is exported into the week folder and listed in the concerns note, including ones read in the browser. The kiosk stops getting shift and overtime flags (it is a tip source, not a person). A new High check catches a tip source that rang card tips but was left off that day's R365 Tip Automation contributors — the gap that dropped $42.07 of kiosk tips from 10/5–10/10.

## Design (already chosen; do not invent another)

1. **Save source reports.** `SKILL.md` makes this a required step **before** ADP entry: export every source report into the store's Dropbox week folder (including browser pulls) and list the saved files in the concerns note. `browser-recipes.md` gets export steps only: R365 report viewer → Export icon → PDF, Page Scaling "Adjust 100%", EXPORT, real clicks (a JS click does not trigger the download). Example names already used: `Labor Payroll Review (Detail) 10-05 to 10-18.pdf`, `Tip Automation Distributions Report 10-05 to 10-18.pdf`.
2. **Quiet the kiosk.** `payroll.py` skips **all** per-shift checks and the OT check for `non_employee_accounts` (122 already lists `KIOSK KIOSK - 550` and `KIOSK - 550, KIOSK`). Do not emit very-long-shift, early clock-in, auto clock-out, missing clock-out, overlap, short shift, stayed-after, OT, or repeated-pattern issues whose employee is a non-employee account. Extraction-total and tip-payout checks stay. No new config keys.
3. **Tip-contributor check (toast_r365 only).** Two new **optional** extracts, documented in `extract-formats.md`:
   - `_tip_sources.txt` = `Date|Source|Card Tips|R365 Contributor` — one line per tip source per day with card tips, from Toast. Last column is the contributor name as the R365 tip rule lists it (kiosk → `KIOSK USER`).
   - `_tip_contributors.txt` = `Date|Contributor|Amount` — from R365 Tip Automation for that day.
   Check: for each `_tip_sources` line with Card Tips > 0, its R365 Contributor must appear on that date in `_tip_contributors` (loose name match with existing `key()`). Else High **Tip source missing from R365 contributors** naming date, source, and amount. A date in `_tip_sources` with no rows for that date in `_tip_contributors` is High too. Source with $0 card tips → no issue.
   - `pos` is `toast_r365` and `_tips.txt` is present but either new file is missing → one Medium **Tip contributor check not run**. Do not run the High check.
   - Both new files present and `pos` is `toast_r365` → run the High check. ADP figures are unchanged by this check.
   - `pos` is `ncr`: no check, no message (even if the new files exist or `_tips.txt` exists).
4. **First builder step — PDF, not a guessed screen.** `[NEEDS CLARIFICATION]` which R365 screen or report section lists contributors per day `(?)`: the Distributions Report may have a contributors section next to "Daily Rules - Receivers". Confirm from the saved PDF `Tip Automation Distributions Report 10-05 to 10-18.pdf` (owner sends it to `/root/fhs-skills/inbox/` from the PC). `extract-formats.md` names **only** the section that PDF shows. If the PDF has no per-day contributors, **stop** and leave `[NEEDS CLARIFICATION]` — do not guess a screen. Do not commit the PDF (real names and pay).

## Files the builder may edit

- `skills/fhs-payroll-adp/SKILL.md`
- `skills/fhs-payroll-adp/scripts/payroll.py`
- `skills/fhs-payroll-adp/references/extract-formats.md`
- `skills/fhs-payroll-adp/references/browser-recipes.md` (export steps only)
- test fixtures under `docs/fixtures/payroll-adp-01/` (anonymised, no real names or pay)
- Outside the repo, only `/srv/fhs-build/reports/payroll-adp-01.md` (builder report)

## Files the builder must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json` (no new keys; both copies already have the kiosk names)
- `skills/fhs-payroll-adp/scripts/period.py`
- Any other skill
- The PC mirror `C:\fhs\fhs-skills`
- The PDF in inbox / reports (read, never committed)
- Everything else, inside or outside the clone

## Live systems touched

None. Read-only: the owner exports R365 reports (viewer → Export → PDF, Page Scaling "Adjust 100%", EXPORT, real clicks). No Toast, R365 or ADP setting changes. Each export still needs the owner's yes at the time.

## Done-check (real outcome)

On the PC (desktop mirror **after** a refresh — that refresh is its own OK), rerun `payroll.py` on the real 122 week folders:

- `00122\2026\10 OCT\Week 42` (10/5–10/18): ADP figures unchanged (294.94 reg, 5.67 OT, CC tips $869.95, Miguel bonus $43.04); zero shift/OT issues for the kiosk; contributor check passes every day (data captured after the owner's refresh).
- `Week 40` (9/21–10/4), contributors as R365 shows them today (not refreshed, owner deferred): the check raises High on each day from 9/26 with kiosk card tips > 0 and no KIOSK USER contributor, or the owner confirms those days are fine. The numbers of flagged days and their kiosk tips must match the Toast per-day kiosk tips.

## Where it runs

Both. Server sessions run `main` via `/root/.claude/skills/fhs-*`. Payroll runs on the owner's Windows desktop from the mirror `C:\fhs\fhs-skills` (Dropbox week folders; `py` on `payroll.py`). Deploying the change to the desktop is a mirror refresh (a separate OK, per the windows-agent runbook). Windows apps: whatever the current payroll run already uses (Dropbox, Chrome if a report is pulled in the browser). Config stays as is.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. Merge is the release for server sessions.
- **Windows mirror:** affected. It stays on the old payroll skill until the owner OKs a refresh (its own OK). Nothing on the desktop counts as this change until that refresh.
- **Live before merge:** current `fhs-payroll-adp` (kiosk still flagged; no contributor check; save-source-reports not a required SKILL step).

## Where the builder works

`/srv/fhs-build/payroll-adp-01` via `scripts/build.sh prepare docs/plans/payroll-adp-01.md payroll-adp-01 --role build`. `prepare` clones `main` at the commit that holds this plan, its task file, the test plan and the APPROVE review; the builder creates `feat/payroll-adp-01` in that clone per the task. Model `composer-2.5`, user `fhsbuild`. Starts only after Ops has copied `/root/fhs-skills/inbox/Tip Automation Distributions Report 10-05 to 10-18.pdf` to `/srv/fhs-build/reports/payroll-adp-01/` for `fhsbuild` (who cannot read `/root`).

## Sequence

`ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/payroll-adp-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/payroll-adp-01.md`, `docs/tests/payroll-adp-01.md` and that review to `main` before prepare.
2. Gate: the PDF is in `/root/fhs-skills/inbox/` (owner sends it from the PC if it is not already there).
3. `build.sh prepare docs/plans/payroll-adp-01.md payroll-adp-01 --role build`.
4. **Ops copies the inbox PDF into `/srv/fhs-build/reports/payroll-adp-01/` for `fhsbuild`, before the Builder starts.**
5. Builder (Composer 2.5): confirm the contributor section from that PDF, then edit only the files listed above. First implementation step after the PDF: if the PDF has no per-day contributors, stop. Fixtures are anonymised.
6. A fresh Composer tester (`composer-2.5`) runs `docs/tests/payroll-adp-01.md`.
7. `build.sh collect payroll-adp-01`.
8. `review.sh --diff feat/payroll-adp-01 --writer composer`. The reviewer is `cursor-grok-4.6-xhigh`. It must be APPROVE. Merge on APPROVE with every pre-merge test PASS.
9. Post-merge: owner OKs a Windows mirror refresh, then the done-check on the real Week 42 and Week 40 folders. A failure opens a fix plan.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No builder-written code runs as root until the diff review is APPROVE.

## Test plan

`docs/tests/payroll-adp-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner/PC cases are post-merge (not a merge gate). Cases the test plan must include:

- Fixture with a kiosk shift 9 AM–9 PM plus OT under `KIOSK KIOSK - 550` → no very-long-shift, early clock-in, OT or repeated-pattern issue for it; a real employee with the same shift still flagged. (If 9 AM is exactly the open buffer and 9 AM–9 PM is exactly 12 h, the fixture uses times that **do** fire those flags for the employee, including 3+ repeats for the pattern.)
- `_tip_sources` kiosk $20 on 10/6, `_tip_contributors` for 10/6 without KIOSK USER → one High naming 10/6, kiosk, $20.
- Same with KIOSK USER present → no issue. Source with $0 card tips → no issue. A date in `_tip_sources` absent from `_tip_contributors` → High.
- toast_r365 store, `_tips.txt` present, new files absent → one Medium "not run"; NCR fixture → no contributor message.
- ADP CSV byte-identical to before the change on an existing fixture with no kiosk lines.
- SKILL.md: the save-source-reports step appears before ADP entry and names the concerns-note listing (grep).
- `python3 -m py_compile skills/*/scripts/*.py`.

Post-merge (PC, after refresh OK): the done-check Week 42 / Week 40 reruns above.

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

ADP math, the daily tip rule, shared-login handling, Miguel's 100-hour bonus, `period.py`, existing extract files (`_hours`, `_shifts`, `_totals`, `_tips`, `_crosscheck_hours`) and their columns, NCR payroll except that it never runs the contributor check, and every `shared/config.json` key. No Toast, R365 or ADP setting is changed. Week 40 R365 data is not refreshed. The Windows mirror is unchanged until its own OK. A later plan may change a tip rule or a live system, each with the owner's yes at the time.
