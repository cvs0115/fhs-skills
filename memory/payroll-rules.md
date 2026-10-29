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
- R365 Tip Automation gap (found 10/21/26): kiosk card tips ($42.07) were left out of 10/5-10/10 because those days were calculated in the 10/11 6:16 AM batch, before KIOSK USER was added as a contributor on the Cary1 Tip Rule. Contributors now: Shift Leader, Cashier x2, Kiosk, ASM - Hourly, Bread, Team Member, Bev Attend, KIOSK USER. Fix: unapprove (R365 only unapproves newest-first), ⋮ → Refresh Data, re-approve. After the fix R365 paid $869.95 of $869.96 collected (1 cent rounding); owner chose R365 amounts for ADP. Week 40 (9/21-10/4) checked 10/22/26 with the new contributor check: R365 had KIOSK USER as contributor only on 10/4, so 12 days of kiosk tips ($70.21, matches Toast) were left out, and R365 paid Cashier2 $11.36 on 9/21 (old rule). Staff got $662.34 of $743.90 collected, $81.56 short. Owner chose to decide later whether to pay it back (open).
- Toast job wages (found 10/21/26): R365 labor cost for CARY 1 was $0 because Toast job wages were blank (R365 takes the wage from Toast punches). Owner entered per-employee Wage overrides in Toast = ADP rates: Ashley 10.00, Trea 10.00, Eric 13.50 (ASM-Hourly + Shift Leader), Zerick 10.00, Shayla 9.50, Emiliano 11.96, Oliver 9.50, Kevin 11.20 (both jobs), Miguel 13.75 (costing only). Claude verified all 9. Claude's permission check blocks it from saving Toast wage edits; the owner does those. Open: confirm new CARY 1 punches carry rates after the 10/22 ~10:22 AM R365 import.
- R365 prints the kiosk as `KIOSK KIOSK - 550`; it is in store 122 `non_employee_accounts` (added 10/22/26). The kiosk is a tip source, not an employee.
- 878 Eleanor Adams (10/21/26): ADP had $12/hr vs Aloha/R365 $10; the manager fixed it per the owner. Not re-verified.
- Period 10/5-10/18/26: 122 = 294.94 reg, 5.67 OT (Eric), CC tips $869.95, Miguel bonus $43.04 (103.13 hrs), submitted by owner. 878 = 380.09 reg, 21.41 OT, $447.97 tips from NCR. Always save source reports: [[save-source-reports]].
- 878 Camden moved to Toast + R365 on 10/21/2026 (owner/manager; Toast data starts 10/21). Pay period 10/19-11/1/26 therefore mixes sources: 10/19 and 10/20 hours and tips come from NCR (NCR tips Mon $36.83, Tue $71.26, $108.09 total; NCR shows $0 from 10/21); 10/21 on come from R365. R365 tip distributions for 10/21-10/27 were verified 10/28/26 (pool = Toast tips each day, $196.02) and left unapproved for the owner. Rule "Camden Square" effective 10/21/26. Details: [[tip-automation-878]] and `docs/research/tip-automation-878.md`.
- Toni Langley (878 GM): changed 10/28/26 from GM - Salary to GM - Hourly at $16.80 in Toast (owner). She was ASM - Hourly at $16.80 on 10/26-10/27 punches. Old Toast record archived. ADP still shows her per its own record: update ADP to hourly (open, not done by Claude). For 10/21-10/24 her punches carry job GM - Salary at $0.
- Camden tip policy (owner, 10/28/26): GM - Hourly and ASM - Hourly get tips and also contribute; kiosk tips are pooled; GM - Salary is Directly Tipped at Camden only so Toni's 10/21-10/24 tips pool.
