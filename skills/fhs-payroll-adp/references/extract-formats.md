# Standard extract files

All files live in the week folder, are named `<prefix>_<kind>.txt` (prefix = `<store>_<start>_<end>`),
are pipe-delimited (`|`), and start with a header line. Lines starting with `#` are ignored.
Copy names exactly as the report prints them - the script matches "Cruz, Ashley", "AShley Cruz (2847)"
and "ASHLEY CRUZ" to each other, so don't normalize by hand. Include shared logins and excluded
people too; the script decides who is paid.

| File | Columns | Required | Purpose |
|---|---|---|---|
| `_hours.txt` | `Employee\|Job\|Reg Hours\|OT Hours` | yes | Source-of-truth hours. One line per employee per job. |
| `_shifts.txt` | `Employee\|Job\|In\|Out\|Hours\|Tips` | yes | Every punch. Drives the shift checks and the daily tip rule. In/Out as `M/D/YYYY H:MM AM`; leave Out blank if missing. Hours = paid hours (reg+OT) for that punch; Tips = card tips rung on that shift, 0 if the report has none. |
| `_totals.txt` | `Key\|Value` | yes | The report's own grand totals: `reg_hours`, `ot_hours`, `tips_collected`. Used to catch misreads. |
| `_tips.txt` | `Employee\|CC Tips` | when available | Tip payouts per person (R365 Tip Automation Distributions or NCR Tip Income). Goes straight to ADP. |
| `_crosscheck_hours.txt` | `Employee\|Total Hours` | Toast/R365 stores | Hours from the *other* system (Toast when R365 is the source) to catch shifts missing from one side. |
| `_tip_sources.txt` | `Date\|Source\|Card Tips\|R365 Contributor` | toast_r365, optional | One line per tip source per day with card tips > 0 (lines with $0 card tips are allowed and ignored by the check), from Toast Labor Summary / Time Entries (same screens as shift tips). `Date` as `M/D/YYYY` (same shape as `_shifts` In/Out). `Source` = Toast name (e.g. kiosk). `R365 Contributor` = name as the R365 tip rule lists it (kiosk → `KIOSK USER`). |
| `_tip_contributors.txt` | `Date\|Contributor\|Amount` | toast_r365, optional | Per-day contributors from the R365 Tip Automation Distributions Report **Daily Rules - Contributors** section: `Date Worked` → Date (`M/D/YYYY`), `Labor Rule` → Contributor (tip-rule name, e.g. `KIOSK USER` or `Cashier` — **not** `Employee Name`, which is the labor account such as `KIOSK KIOSK - 550` or `Cashier2 Cashier2`), `Card Tips` (overflow pages) → Amount (informational only; payroll.py does not use Amount for the contributor check). |

## Reading each report

### R365 Labor Payroll Review (toast_r365 stores → `_hours`, `_totals`, and `_shifts` if Detail)
- Each employee block: `Name (ID)` then `Total <Job>` rows with Reg Hrs, OT Hrs. Write one `_hours` line
  per `Total <Job>` row (skip the `Total <Name>` row - it's the sum).
- Grand `Total` row → `reg_hours`, `ot_hours`. Note the PDF's text layer lists numbers in a separate
  block from names; pair them in order and check the sum against the Total row.
- **Detail** view adds a line per shift: date, in, out, location, job, reg, OT, … and `Charge Tips`. Those
  become `_shifts` lines. Rows with a date but no in/out and a small tip amount are R365 tip-automation
  distribution lines, not shifts - skip them in `_shifts`.
- `Charge Tips` grand total is tips rung by employees; kiosk tips aren't in it (no labor). Use the Toast
  Labor Summary total (or Sales Summary tips) for `tips_collected`.

### R365 Tip Automation Distributions Report (→ `_tips`, `_tip_contributors`)
- "Daily Rules - Receivers" section: Employee, Job, Location, Labor Rule, Hours, Amount Received.
  Sum Amount Received per employee across the period → `_tips`.
- **Daily Rules - Contributors** section (same PDF): one row per contributor per day worked. Main pages
  show `Date Worked`, `Employee Name` (labor account — not the match key), `Labor Rule` (tip-rule name →
  Contributor), `Net Sales`, and `Basis Value`. Overflow pages continue the section with `Card Tips` (and
  related tip columns) aligned to those rows → `Amount` when you fill the file (optional; the check matches
  on Contributor only).
- Check the report covers **every day** of the period. If days are missing (not calculated/approved),
  don't write `_tips.txt`; tell the owner which days are missing and let the daily rule run instead.
- Any amount to Cashier1/Cashier2 means the rule still lists Cashier as a receiver - flag it.

### Toast Labor Summary / Time Entries (toast_r365 stores → `_crosscheck_hours`, shift tips)
- Labor Summary "Employee Summary": per employee the Regular/Overtime totals → `_crosscheck_hours`
  (reg + OT). The per-employee Tips column summed = card tips collected → `tips_collected`
  (Cashier2 + KIOSK + others). Prefer this over the Pooled Tips report total.
- Time Entries reporting with the **Non Cash Tips** column turned on: one row per shift with tips →
  `_shifts` (when R365 Detail isn't available). Non-tipped jobs (e.g. ASM) show blank tips → 0.

### NCR 3.01 Time Clock Detail (ncr stores → `_hours`, `_shifts`, `_totals`)
- Blocks start `Employee / Job: Last, First - <SSN-ish> / <ID> / <Job>`. Use only `Last, First` as the
  name - **never copy the long number** (it looks like an SSN) into any file.
- Each row: Site, Shift Date, Rate, Day, Clock In, Clock Out, Reg Hours, Reg Wages, OT Hours, OT Wages,
  Total Wages, Declared Tips. `_shifts` Hours = Reg + OT for the row. A row with in/out but blank hours
  is a punch with no hours counted - keep it (Hours 0) so the check flags it.
- `<Job> Totals` row → `_hours` line (Reg, OT). `Labor Grand Totals` → `reg_hours`, `ot_hours`.

### NCR Tip Income (→ `_tips`) and Tips Breakout (→ `tips_collected`)
- Tip Income: Employee Name and **Tip Share Earned** → `_tips`. (Charge Tips there is what that person
  rang up - already included in the pool; don't add it again.)
- Tips Breakout: the Total column of "Total" row → `tips_collected`; should equal Tip Share Earned total.

## Example (122, 9/21-10/4/2026)
```
122_2026-09-21_2026-10-04_hours.txt
Employee|Job|Reg Hours|OT Hours
AShley Cruz|Team Member|17.48|0.00
Miguel Cabanzo Huerta|Team Member|80.00|24.39
Cashier2 Cashier2|Cashier|80.00|145.54

122_2026-09-21_2026-10-04_totals.txt
Key|Value
reg_hours|482.76
ot_hours|169.93
tips_collected|743.90
```
