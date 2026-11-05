# Tip automation at 878 CAMDEN SQUARE (Toast + R365)

Research note, 2026-10-28. Read-only checks plus the owner-approved changes listed under "Changes made".
Anything not confirmed is marked `(?)`.

## Why the Camden distribution was empty

- Camden went live on Toast on **10/21/2026** (manager). Toast has sales, orders and time entries only from 10/21.
  NCR (Aloha) carried 10/18–10/20 (NCR tips Mon 10/19 $36.83, Tue 10/20 $71.26, $0 from Wed 10/21).
- R365 created Camden's Toast POS employees (37) and Toast jobs on **10/22 3:23 AM**. Toast jobs carry a Toast GUID as
  POS ID. The older jobs (names like `TeamMember`, `Shift Lead`, `ASM- Hourly`, numeric POS IDs, 11/12/2025 or hand-made
  10/07 and 10/11) are a separate set. Camden's rule was built on the old set.
- **The tip rule job picker only offers jobs that have a Tip designation.** Camden's Toast jobs had none, so
  they could not be chosen. Cary's Toast jobs (set 10/07) are Directly Tipped. Setting the designation made them appear.
- R365 "Collected Tips" for the week of 10/19 was $255.93 = Toast $147.84 (10/19–10/25) + NCR $108.09. R365 imports both,
  so tips were collected but never attributed to people.
- Saving a rule regenerates all pending distributions (new IDs; old links go stale).
- Changing the rule's effective date to 10/21 removed the 10/18–10/20 distributions from Pending.

## Job configuration (R365 Workforce > Employees > Jobs)

Requirement (owner): hourly tipped roles are Directly Tipped with GL 7105 HOURLY WAGES PAID.

| Camden Toast job | Tip designation | GL | Note |
|---|---|---|---|
| Team Member | Directly Tipped | Hourly Wages Paid | set 10/28 |
| Shift Leader | Directly Tipped | Hourly Wages Paid | set 10/28 |
| Cashier | Directly Tipped | Hourly Wages Paid | set 10/28 (no Camden shifts yet) |
| ASM - Hourly | Directly Tipped | Hourly Wages Paid | already correct |
| GM - Hourly | Directly Tipped | Hourly Wages Paid | owner: GM - Hourly gets tips; set 10/28 |
| KIOSK USER | Directly Tipped | Hourly Wages Paid | matched Cary; GL was empty; set 10/28 |
| GM - Salary | Directly Tipped | Hourly Wages Paid | **exception**, see Decisions |
| ASM - Salary | none | none | matches Cary |

## Rules

- Cary1 Tip Rule (works): effective 9/21/2026, hours basis, Declared tips paid with payroll ON. **Correction:** an early read
  of this rule showed only the first jobs (Shift Leader, Cashier / Shift Leader, Team Member) because the picker was collapsed.
  The payroll notes (`memory/payroll-rules.md`) have the fuller lists: contributors Shift Leader, Cashier x2, Kiosk, ASM - Hourly,
  Bread, Team Member, Bev Attend, KIOSK USER; receivers Shift Leader, Team Member, ASM - Hourly, Bev Attend, Cashier. Re-read
  the expanded lists before copying anything from Cary (?).
- Camden Square rule (final, 10/28): contribution based on Tips, funding on Job Title, divided by Worked Hours,
  100% pool, Declared tips OFF, effective **10/21/2026**.
  - Contributors: Shift Leader, Cashier, KIOSK USER, GM - Hourly, GM - Salary, ASM - Hourly.
  - Receivers: Shift Leader, Team Member, GM - Hourly, GM - Salary, ASM - Hourly.
- Business day is 4:00 AM–3:59 AM, so early-morning punches count toward the previous day.

## Verification (10/21–10/27)

Toast Orders report by server, tips total $196.02. R365 pool equals Toast per day: 10/21 $28.31, 10/22 $27.56, 10/23 $34.95,
10/24 $25.23, 10/25 $31.79, 10/26 $23.54, 10/27 $24.64. Payouts are within $0.01 a day (rounding).
Hours in the distributions equal R365 Labor Details punches (Eleanor 10/21 is 12.00 not 14.20 because of the 4 AM day start).
Not checked against Toast time entries directly (?).

Who collected tips: Josean Del Moral Cruz (Shift Leader), Eleanor Adams (Shift Leader), KIOSK - 550 (KIOSK USER),
Toni Langley (GM - Salary 10/21–10/24, ASM - Hourly 10/27). No Team Member or Cashier collected tips.

## Toni Langley

- Toast had two employee records: GM - Salary (record with account check mark, 167a850b…) and ASM - Hourly (5680859c…).
  Her latest punches (10/26–10/27) were on the ASM - Hourly record at $16.80.
- Owner decision: Toni is GM - Hourly at **$16.80**. Done 10/28 on the 5680859c… record (ASM - Hourly unchecked, GM - Hourly checked,
  wage $16.80). The 167a850b… record was **archived** (restorable under Toast Archived). First punch on 10/29 should be watched (?).
- R365 has three Toni Langley employee records (one NCR ID 458031 with ARM $16, two Toast-created 10/22). Not cleaned up.
- ADP not changed: she is now hourly.

## Decisions (owner, 2026-10-28)

- GM - Hourly gets tips; KIOSK USER matches Cary; start the rule on 10/21 (NCR days handled outside R365).
- **Conflict with the earlier "salaried roles are not Directly Tipped":** owner chose to make Camden's GM - Salary Directly Tipped
  with Hourly Wages Paid so Toni's $68.52 of 10/21–10/24 tips could be pooled. Camden only; Cary unchanged.
- GM - Salary and ASM - Hourly are both contributors and receivers.

## Open items

- Pay NCR tips for 10/19 and 10/20 ($108.09) from NCR Tip Income; 10/18 NCR tips not checked.
- Approve 10/21–10/27 in R365 (owner). Nothing was approved by Claude.
- ADP: Toni salary to hourly.
- Test Mode in the rule panel is unexplained; it was not used.
- Clean up duplicate Toni Langley records in R365 after the sync.
- Retire or relabel the old hand-made jobs (TeamMember, Shift Lead, ASM- Hourly, GM, ASM) later (?). Corporate may own the list.

## How the data was pulled (for the next person)

- R365 Labor Details is a Kendo grid in a nested iframe; `dataSource` can be filtered and read in the page.
- Toast legacy report `Reports > Orders` has Server and Tip columns; paging needs the numbered links.
- The R365 distribution page lists contributors (POS tips) and receivers (hours worked, tips owed).

## PC read-only check (2026-11-03, owner's PC, nothing changed)

- **Kiosk:** `KIOSK KIOSK - 550`, job `KIOSK USER`, $0 rate, same name in Toast and R365. A punch every day 10/21 to 11/1 (12 R365 rows, 140.09 hours). Toast flagged 10/21 and 10/22 AUTO CLOCK-OUT (out 2:00 AM, 16.00 and 11.40 hours); R365 was corrected to 11.00 and 6.40.
- **Other non-person accounts:** `Terminal2 Cashier2` (job RM, NCR-era shared login; 24.09 hours on 10/18-10/20, none after 10/21); `TST User (Do Not Delete)` (job Toast TST, 0.02 hours on 10/21); `KDS KDS - 660`, `RTG RTG Login`, a "General Login" (no hours). The General Login name field holds a note that looks like a password: owner should clean it up and change that password.
- **Toast location:** `00878 - Camden Square` under group `00878 - Firehouse Subs`. Toast "Restaurant ID" 367024 (not confirmed as the restaurant group id `(?)`). R365 location id for Camden Square `973d061c-93f4-4407-b26e-83efa9e77da3`.
- **R365 holds hours for 10/19 and 10/20** under NCR job names (ARM, RM, TeamMember): 39.53 hours on 10/19 (6 rows), 43.52 on 10/20 (6 rows), 83.05 total. Toast has nothing for those days. A period run must not include them if those days are entered by hand.
- **Cross-over shifts:** Toni Langley (ARM) in 10/20 7:58 PM, out 10/21 1:48 AM (5.83 hours), dated 10/20 in R365 (NCR side). Eleanor Adams (Shift Leader) in 10/21 1:48 AM, out 4:00 PM, 14.20 hours in R365; Toast shows 1:45 AM to 3:58 PM, 14.23. The 1:48 AM start looks like a leftover of the NCR night punch `(?)`; ask Eleanor or Toni.
- **Tip distributions:** R365 Approved tab lists Camden Square 10/21 to 11/1, all calculated 10/29 or later; Pending is empty (this closes the "approve 10/21-10/27" open item).
- **Toni Langley:** Toast job GM - Salary through 10/25, ASM - Hourly from 10/26; the Toast employee list now says GM - Hourly; R365 shows a GM - Hourly entry of 3.18 hours on 11/1. ADP not checked `(?)`.
- **Dropbox:** 878 Week 43 and Week 44 folders are empty.

## Overtime across the cut-over (PC check, 2026-11-05)

R365 holds 10/19-10/20 on old NCR employee records, so it shows 0.00 OT for the week 10/19-10/25 even when the combined week is over 40.
Combined week 1: Toni 20.39 + 32.47 = 52.86 h, OT 12.86 (5.65 on 10/23, 7.21 on 10/24); Eleanor 14.84 + 26.60 = 41.44 h, OT 1.44 (10/25);
Josean 35.46, Jason 21.85, Alonda 14.18 (no OT). Toni's period total: 80.00 regular, 25.54 OT (week 2 is all electronic: 40.00 + 12.68).
Entry rule: hand-enter 10/19-10/20 as regular and put the week's OT on the electronic line (Toni 59.61 reg / 25.54 OT electronic; Eleanor 62.96 / 1.44).
Not yet checked against the printed NCR Time Clock Detail. Toni's GM - Salary hours (10/21-10/24) are an open owner decision that changes her numbers `(?)`.
