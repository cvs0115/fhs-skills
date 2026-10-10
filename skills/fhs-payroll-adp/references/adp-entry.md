# ADP RUN: entering payroll and verifying the Preview

Sign-in page (the owner signs in - never type credentials):
https://online.adp.com/signin/v1/?APPID=RUN&productId=80e309c3-70c3-bae1-e053-3505430b5495

ADP signs out after idle time; if a page shows "You are not authorized", reopen the sign-in page and
ask the owner to sign in again.

## Getting to the grid
1. Companies → the store's company (`adp_company` in config, e.g. "Firehouse Subs 122").
2. Payroll → Run payroll for the biweekly period. Confirm the pay period and check date on screen match
   the period from `period.py`.
3. Grid columns: Name, Rate, Salary Amount, Regular Hours, Overtime Hours (Qualified),
   CC Tips Owed (Qualified), Bonus Amount. Rows sorted by last name.

## Entering values (what works in the browser pane)
- The pane is narrow and ADP hides profile details below ~1000px ("sign in on a computer"). Emulate a
  wide viewport so the whole grid fits: resize_window 1280x1000. Reset to desktop when done.
- **Click each cell directly**, type the value, then click the next cell (or an empty cell) to commit.
  Tab/Enter navigation is inconsistent - one tip once landed in the Overtime column.
- To replace an existing value: click the cell, ctrl+a, type.
- Clear a wrong value: click, ctrl+a, Delete, click elsewhere.
- Enter column by column (all Regular Hours, then all CC Tips, then Bonus) - fewer mistakes.
- **Never refresh the page** - it wiped a full grid of unsaved entries once. Use "Finish later" to save.

## Read-back check (always, before Preview)
Read the grid rows (role=row text; values are in a separate pane from names, in the same order) and
compare every person and the Totals row to the ADP table: Regular Hours, Overtime, CC Tips, Bonus, and
salary lines. Report mismatches by name and the exact value expected.

## Preview check
After the owner clicks Preview payroll, read the table (Employee, Type, Total hours, Gross pay, Taxes,
Net pay, Employer taxes) and confirm for each person:
- hourly: gross = rate × regular hours + 1.5 × rate × OT hours + CC tips
- salaried with bonus: gross = salary + CC tips + bonus (hours show the 80 entered)
- salary only (e.g. owner): gross = salary
Also confirm totals, cash required, pay period, check date, and that "Unpaid" people are the expected
zero-hour employees. Then say "clear to approve" or list fixes. The owner clicks **Approve**.

## Store notes
Per-store ADP rules are in config.json `adp_notes` - read them before entering.
