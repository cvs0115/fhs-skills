# Spec · payroll-mixed-source · Payroll for a pay period that spans a POS cut-over (878: NCR to Toast + R365)

2026-10-31 · Hub project: `projects/payroll-mixed-source` (not yet on the board) · Plan page: none yet

## Problem and today

- **Problem:** `fhs-payroll-adp` reads one `pos` value per store from `shared/config.json`. Store 878 moved from NCR to Toast + R365 on 10/21/2026, so the 10/19-11/1 pay period has NCR days (10/19-10/20) and R365 days (10/21 on). One setting can't describe both.
- **Today:** 878 is still `"pos": "ncr"`. The SKILL.md text (commit `8517cf1`) tells Claude to use NCR files for 10/19-10/20 and R365 from 10/21, and the extract step already writes normalized files, so the mixed hours can be merged by hand. But with `ncr` set:
  - the R365 tip-contributor check (`payroll.py:154`, `tip_contributor_issues`) is skipped for 878, so kiosk and other tip sources from 10/21 on are not checked against R365 contributors;
  - the report list in SKILL.md step 2 shows only NCR files for 878;
  - flipping to `toast_r365` would apply Toast/R365 checks to the NCR days (no R365 tip distribution exists for 10/19-10/20, and NCR tips of $36.83 + $71.26 = $108.09 come from NCR Tip Income).
- **Cost:** a missed tip source or a wrongly applied check on 878's first mixed period, and Claude doing the merge by hand each time with no test.

## Who runs it

- The owner, through Claude, in the usual payroll session. They download the reports to the week folder and approve ADP entry. They should not have to know about the switch date.

## Done when (measurable)

1. A config entry for 878 that says which POS applies from which date (for example NCR through 10/20/2026, Toast + R365 from 10/21/2026), and 122 still works unchanged with its single `pos` value.
2. A real run of the 878 period 10/19-11/1/2026 (once the reports exist) gives hours, OT and tips that match the NCR report for 10/19-10/20 plus the R365 report for 10/21 on, to the cent on tips and 0.01 hr on hours.
3. The R365 tip-contributor check runs for 878's R365 days only and does not flag the NCR days.
4. Tips paid out equal tips collected: NCR Tip Income for 10/19-10/20 ($108.09) plus R365 distributions for the rest.
5. Week 40 and Week 42 for 122 give a byte-identical ADP CSV and the same issue set as before the change.

## In scope

- P0: a date-aware POS setting in `config.json` and `payroll.py` (the script picks the source per day); the contributor check limited to R365 days; a fixture for a mixed period.
- P0: SKILL.md step 2 and `references/extract-formats.md` say which files a mixed period needs and how the two sources are merged.
- P1: a discrepancy-report note that names the cut-over date, so the owner sees where the source changes.
- P1: a check that no employee has hours from both systems on the same day.
- P2: reuse the same setting for future store moves (the `fhs-store-migration` checklist).

## Out of scope (parked on the hub)

- Updating Toni Langley to hourly in ADP (owner action, in `memory/payroll-rules.md`).
- Approving the 10/21-10/27 R365 tip distributions (owner action).
- Cleaning up duplicate Toni Langley records and old jobs in R365.
- Scheduled payroll runs.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| 878 hours 10/19-10/20 | NCR 3.01 Time Clock Detail | owner downloads to the week folder | yes, used for 10/5-10/18 |
| 878 tips 10/19-10/20 | NCR Tip Income ($36.83, $71.26) | owner downloads | amounts from `docs/research/tip-automation-878.md`; file not yet seen `(?)` |
| 878 hours, tips 10/21 on | R365 Labor Payroll Review, Tip Distributions | owner downloads | tips verified 10/28 against Toast ($196.02, 10/21-10/27); the full hours file for this period not yet run `(?)` |
| Cut-over date | `shared/config.json` | owner/manager, Toast data starts 10/21 | yes, research note 2026-10-28 |
| The 10/21 business day | R365 day runs 4:00 AM to 3:59 AM | research note | punches before 4 AM on 10/21 belong to 10/20 (NCR or R365?) `(?)` |

## Owner rules that bind it

- A change to `shared/config.json` needs its own OK, and so does any change to a running payroll (`CLAUDE.md`).
- Flag discrepancies; never auto-decide (config `adp_notes`).
- Always save the source reports to the week folder ([[save-source-reports]]).
- Nothing is entered in ADP without the owner's yes; passwords are never typed by Claude.

## Open questions

- [NEEDS CLARIFICATION] Which system owns the punches that straddle midnight on 10/20 to 10/21 (an NCR clock-in on 10/20 with a Toast clock-out after the cut-over)? Does the owner know if any exist? → hub `questions/q-cutover-straddle`
- [NEEDS CLARIFICATION] Is the 10/19-11/1 run planned to wait until 11/1 closes, or does the owner want a preview run now on 10/19-10/31? → hub `questions/q-878-run-timing`
- [NEEDS CLARIFICATION] Do the NCR export and R365 report cover the same employee names (ADP names), so one merged `_hours.txt` is enough, or must name aliases be added? → research on the real files
- Research needed before the plan: pull one real NCR file (10/19-10/20) and one R365 Labor Payroll Review (10/21 on) for 878 and confirm the merged file layout (`(?)` until seen).
