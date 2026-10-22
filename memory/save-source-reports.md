---
name: save-source-reports
description: Always export and save every original source report into the store's week folder whenever payroll (or any period) data is captured, including data Claude pulls in the browser
metadata:
  type: feedback
---

Whenever data is captured for a period, export each original report and save it in the store's Dropbox week folder `Locations\<store>\<year>\<MM MON>\Week <n>` with the dates in the filename, then list the saved files in the period's concerns note.

- R365: report viewer → Export icon → PDF, Page Scaling "Adjust 100%", EXPORT. Use real clicks; a JS click does not trigger the download.
- Example (10/21/2026, store 122): `Labor Payroll Review (Detail) 10-05 to 10-18.pdf`, `Tip Automation Distributions Report 10-05 to 10-18.pdf`.

**Why:** on 10/21/2026 the owner caught that the 122 source reports had not been saved after Claude read them in the browser; without them the period can't be re-checked later.
**How to apply:** treat "reports saved and listed" as part of every payroll run, before ADP entry. The fhs-payroll-adp change in `docs/briefs/payroll-adp-01.md` makes it a skill step. Related: [[payroll-rules]], [[payroll-skill]]
