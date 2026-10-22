# Browser recipes (fallback when reports weren't downloaded, and for fixes)

Logins (the owner signs in; never type credentials):
- Toast: https://www.toasttab.com/restaurants/admin/reports/home
- R365 (Firehouse instance): https://fhs4021089.restaurant365.com/
- ADP RUN: see adp-entry.md

## Toast (legacy labor reports)
URL pattern (dates MM-DD-YYYY, group id from config `toast_restaurant_group_id`):
```
https://www.toasttab.com/restaurants/admin/reports/home?reportDateRange=custom&reportDateStart=09-21-2026&reportDateEnd=10-04-2026&reportTimeRange=-2&reportGroupIds=900000028346197274&reportName=labor#labor-summary
```
Tabs by hash: `#labor-summary`, `#labor-pooledtips`, `#labor-time-entries`. Switch store with the
location picker at the top first.
- Labor Summary text: `document.body.innerText` between "Employee Summary" and "Generated on".
- Time Entries with tips: open "Show / hide columns", tick **Non Cash Tips**, then page through with the
  `Next →` link, collecting `table tbody tr` rows (wait for the first row to change after each click).
- Fixing a punch: Reports → Labor → Time entry management (`/restaurants/admin/labor/time/entries`),
  set the date, click the employee row, change Time out, add a reason, Save changes. Adding a missing
  shift: "+ Add entry" (employee, job, date + time in/out). Only with the owner's explicit OK.
- Toast tip pooling policy: Employees → Payroll management → Tips pooling policy (needs admin permission).

## R365 reports (pop-up workaround)
R365's RUN button opens the viewer in a new tab, which the browser pane blocks. Instead:
1. Reports → My reports, click the report's RUN once (this saves its parameters in localStorage
   `reportPassed`; the pop-up is blocked but that's fine).
2. In the page, edit `reportPassed`: set `Start`/`End` selectedItem to ISO strings
   (e.g. `2026-09-21T04:00:00.000Z`), optionally `RunAs` to `{"0":{"value":"2","display":"Detail"}}`.
3. Set `location.hash = '#/ReportViewer'`. The report renders in the second iframe; read it with
   `document.querySelectorAll('iframe')[1].contentDocument` (rows: `tr` → cells).
The report covers all locations unless filtered - filter rows to the store's `r365_location`.

### R365 report viewer → PDF export
When saving a report to the week folder (Labor Payroll Review, Tip Automation Distributions, etc.):
1. Open the report in the viewer (RUN / ReportViewer iframe).
2. Click the **Export** icon (real click, not a JS-only click — that does not start the download).
3. Set Page Scaling to **Adjust 100%**.
4. Click **EXPORT** and save the PDF into the store's Dropbox week folder with the date range in the filename
   (e.g. `Tip Automation Distributions Report 10-05 to 10-18.pdf`).

## R365 Tip Automation
Search "Tip Automation" (Workforce → Time & Attendance). Pick the location. Pending tab:
"Calculate All Distributions", then approve days. The gear opens the rule (receivers/contributors).
Calculating only produced days after the rule existed in testing - backfilling earlier days may need
R365 support. Editing the rule or approving distributions needs the owner's explicit OK (the
permission system may still block it; then give the owner exact click steps).
