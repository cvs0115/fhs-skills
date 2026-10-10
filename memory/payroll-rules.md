---
name: payroll-rules
description: "User's biweekly payroll process: Toast (Firehouse Subs stores) -> ADP RUN, plus employee exceptions (Miguel, shared Cashier logins)"
metadata:
  node_type: memory
  type: project
  originSessionId: 7ea7fc92-25d9-44aa-9b05-8ac214be32bf
  modified: 2026-10-08T01:57:20.809Z
---

User runs biweekly payroll for multiple Firehouse Subs stores (store 122 = Cary 1, done first) from Toast reports into ADP RUN. Per employee: regular hours, OT hours, CC tips.

- Data: Toast legacy reports URL `/restaurants/admin/reports/home?reportDateRange=custom&reportDateStart=MM-DD-YYYY&reportDateEnd=MM-DD-YYYY&reportName=labor#labor-summary` (per-employee hours) and `#labor-pooledtips` (CC tips). User logs in themselves.
- ADP RUN payroll grid column order: Reg Hours, OT, CC Tips, Bonus. adp_entry.csv follows that order.
- Miguel in ADP: ALWAYS enter 80 hours on his salary line (so ADP counts salary correctly), plus Bonus $ = (worked hrs - 100) x (biweekly salary / 100). The "100 hrs" is only for computing the bonus. Only flag Miguel if he works UNDER 100 hrs in a period - owner does not want OT/exempt warnings for him (decided 10/7/26).
- Miguel (Cabanzo Huerta) original rule: 100 reg hrs; hours over 100 = bonus at (ADP biweekly amount / 100). Treat amount as variable from ADP. He keeps his tips.
- Cashier1/Cashier2 are shared logins with fake auto-clockout hours: don't pay; redistribute their pooled tips to real employees by pooled hours. Exclude Mayuri (Surati, owner) from distribution.
- NC Cary (district manager login) stays off payroll.
- Store 122 ADP extras: Iris Brower = seasonal; Vivek Surati and Khushi Surati = part-time. None appear in Toast for store 122 (as of 10/7/26). ADP lists all three as "Full time | Hourly" - mismatch flagged, not changed.
- ADP rates (10/4/26): Eric $13.50/hr, Ashley $10.00/hr, Miguel $1,375 biweekly salary (-> $13.75/hr for 100-hr rule).
- Kevin Teruel-Olvera: do NOT split ASM/Shift Leader hours in ADP - one line, total hours.
- SOURCE OF TRUTH = R365 (hours + tips). Toast must be kept aligned to R365 as a sanity/discrepancy check. R365 reports open via localStorage 'reportPassed' + #/ReportViewer (popups blocked in pane). R365 Tip Automation: Workforce > Time & Attendance > Tip Automation, rule "Cary1 Tip Rule" (eff 9/21/26, by worked hours; receivers Shift Leader, Team Member, ASM - Hourly, Bev Attend, Cashier). Distributions must be calculated + approved before they show in Tip Automation Distributions Report. Eric (ASM) SHOULD get tips.
- Older note - data source order Toast > R365 > ADP; user believes ADP has the latest employee info (rates/pay type) - flag any mismatches across the three.
- Store hours 10 AM-9 PM; ~1 hr buffer either side for prep/close is normal.
- Workflow: save Toast page text as `<store>_<start>_<end>_labor_summary.txt` / `_pooled_tips.txt` in project root, run `py payroll.py <prefix>` (rules in config.json). Use `py`, not `python`. New subfolders in this OneDrive dir vanish between commands - keep files flat in root.
- Owner OK'd fixing obvious auto clock-outs directly in Toast Time entry management (did Zerick 9/30 -> 2 PM).
- Restaurant365 (R365) is included via Firehouse Subs franchise - candidate for scheduling (Toast Scheduling not set up). Scheduled-vs-actual check could pull from R365.
- First period handled: 9/21-10/4/26.
