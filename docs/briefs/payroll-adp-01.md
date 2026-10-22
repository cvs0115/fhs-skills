# Brief · payroll-adp-01 · Save source reports, quiet kiosk, tip-contributor check

2026-10-22. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/payroll-adp-01.md` (form `docs/templates/plan.md`), `docs/prompts/payroll-adp-01.md` and `docs/tests/payroll-adp-01.md`. Don't add scope.

- Spec: none (bug-fix path from the 10/21/2026 payroll run; symptom, cause and proof below) · Hub project: `projects/payroll` · Binding decisions: owner 2026-10-21 (R365 tip amounts go to ADP after refresh; save source reports), owner OK 2026-10-22 (`KIOSK KIOSK - 550` added to 122 `non_employee_accounts`, commit `db0d7ce`)
- Research to rely on: `skills/fhs-payroll-adp/references/extract-formats.md`, `memory/payroll-rules.md` (R365 Tip Automation gap, 10/21), `memory/save-source-reports.md`

## Problem and decision (3–5 lines)

The 10/5–10/18 run for 122 showed three gaps. (a) The source reports were not saved when Claude read them in the browser. (b) The kiosk (`non_employee_accounts`) got shift flags (very long shift, early clock-in, OT) that are noise. (c) R365 Tip Automation left kiosk card tips ($42.07) out of 10/5–10/10 because those days were calculated before KIOSK USER was a contributor on the tip rule; nothing caught it. Decision: (a) SKILL.md makes "export every source report to the week folder and list it in the concerns note" a required step, including browser pulls; (b) `payroll.py` skips all per-shift and OT checks for `non_employee_accounts`; (c) a new **High** check: per day, every tip source with card tips > 0 must appear as a contributor in that day's R365 Tip Automation data.

Design already chosen for (c), so the Drafter doesn't invent one:
- Two new optional extracts, documented in `extract-formats.md`: `_tip_sources.txt` = `Date|Source|Card Tips|R365 Contributor` (one line per tip source per day with card tips, from Toast; the last column is the contributor name as the R365 tip rule lists it, e.g. kiosk → `KIOSK USER`), and `_tip_contributors.txt` = `Date|Contributor|Amount` (from R365 Tip Automation for that day).
- Check: for each `_tip_sources` line with Card Tips > 0, its R365 Contributor must appear on that date in `_tip_contributors` (loose name match with the existing `key()`), else High "Tip source missing from R365 contributors" with date, source and amount. Days missing from `_tip_contributors` entirely → High too.
- `toast_r365` store with `_tips.txt` but without both new files → Medium "Tip contributor check not run". NCR stores: no check, no message.
- No new config keys. `[NEEDS CLARIFICATION]` which R365 screen or report section lists contributors per day `(?)`: the Distributions Report may have a contributors section next to "Daily Rules - Receivers". The plan's first step confirms it from the saved PDF `Tip Automation Distributions Report 10-05 to 10-18.pdf` (owner sends it to `inbox/` from the PC) and the extract instructions name only what that PDF shows.

## Files the builder may edit / must not edit

- may: `skills/fhs-payroll-adp/SKILL.md`, `skills/fhs-payroll-adp/scripts/payroll.py`, `skills/fhs-payroll-adp/references/extract-formats.md`, `skills/fhs-payroll-adp/references/browser-recipes.md` (export steps only), test fixtures under `docs/fixtures/payroll-adp-01/` (anonymised, no real names or pay)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, `period.py`, any other skill, the PC mirror

## Live systems touched

None. Read-only: the owner exports R365 reports (viewer → Export → PDF, Page Scaling "Adjust 100%", EXPORT, real clicks). No Toast, R365 or ADP setting changes.

## Done-check (real outcome)

On the PC (desktop mirror after refresh), rerun `payroll.py` on the real 122 week folders:
- `00122\2026\10 OCT\Week 42` (10/5–10/18): ADP figures unchanged (294.94 reg, 5.67 OT, CC tips $869.95, Miguel bonus $43.04); zero shift/OT issues for the kiosk; contributor check passes every day (data captured after the owner's refresh).
- `Week 40` (9/21–10/4), contributors as R365 shows them today (not refreshed, owner deferred): the check raises High on each day from 9/26 with kiosk card tips > 0 and no KIOSK USER contributor, or the owner confirms those days are fine. The numbers of flagged days and their kiosk tips must match the Toast per-day kiosk tips.

## Where it runs and which tree is live

Both. Server sessions run `main` via the `/root/.claude/skills/fhs-*` symlinks; payroll runs on the Windows PC from the mirror `C:\fhs\fhs-skills`, which stays on the old version until the owner OKs a refresh (its own OK, per the windows-agent runbook). Build in `/srv/fhs-build/payroll-adp-01`. Config stays as is (both copies already have the kiosk names).

## Tests the test plan must include

- Fixture with a kiosk shift 9 AM–9 PM plus OT under `KIOSK KIOSK - 550` → no very-long-shift, early clock-in, OT or repeated-pattern issue for it; a real employee with the same shift still flagged.
- `_tip_sources` kiosk $20 on 10/6, `_tip_contributors` for 10/6 without KIOSK USER → one High naming 10/6, kiosk, $20.
- Same with KIOSK USER present → no issue. Source with $0 card tips → no issue. A date in `_tip_sources` absent from `_tip_contributors` → High.
- toast_r365 store, `_tips.txt` present, new files absent → one Medium "not run"; NCR fixture → no contributor message.
- ADP CSV byte-identical to before the change on an existing fixture with no kiosk lines.
- SKILL.md: the save-source-reports step appears before ADP entry and names the concerns-note listing (grep).
- `python3 -m py_compile skills/*/scripts/*.py`.

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
