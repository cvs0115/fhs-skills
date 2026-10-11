# Research · store-audit-122 · What R365 and Toast already do for store 122

2026-10-11. Read-only F1 audit from PC captures in `/srv/fhs-build/reports/store-audit-122-captures/` (`pages.csv` plus png/txt; one `-missing.txt`). No browser was opened. Numbers are from those files only. Menu paths that the capture did not fully confirm are marked `(?)`. Capture date 2026-10-11; last complete week before that is 2026-10-04–2026-10-10; last 30 days from 2026-09-11; last 60 days from 2026-08-12. Store: R365 location **CARY 1**, Toast restaurant **00122 - Cary 1** (366968).

## Summary

| ID | Function | Status | Evidence | Owner | Note |
|---|---|---|---|---|---|
| M0 | Licensed / visible modules | in place | R365 Dashboards → Operations overview (`M0-01.png`); Reports (`M0-03.txt`); More / Admin (`M0-04.txt`, `M0-04.png`); Toast home (`M0-05.txt`); Toast Payroll discover (`M0-06.txt`); Toast Shop (`M0-07.png`) | owner | R365 Admin opens (71 users). Orders tile greyed. Toast Payroll / Scheduling / tip pooling = not licensed. Toast Shop = permission denied. |
| F2 | Items, units, vendors | in place | R365 Inventory → Items (`F2-01.png`, `F2-02.txt`, `F2-03.png`); Accounting → Vendors (`F2-04.txt`) | franchise | 551 items with units; many Avg Cost $0.00; 114 vendors. CARY 1 receipts from Cheney Brothers. Item Brand = Firehouse Subs. Hub q1/q3/q4: see section F2. |
| F3 | Electronic invoices | in place | R365 Accounting → AP transactions (`F3-01.png`); vendor Cheney Brothers (`F3-03.txt`); invoice form (`F3-02.txt`); Admin → Integrations INVOICES (`F3-06.png`); Documents to process (`F3-04-missing.txt`) | R365 support | Invoices arrive Modified by R365 Import (Cheney, `-CARY` numbers). Supplyit and NDCP Disconnected. No email-capture address on Documents to process. Hub q1: Cheney Brothers, import not email. |
| F4 | Recipes and menu mapping | in place | R365 Inventory → Recipes (`F4-01.png`); Menu Items (`F4-02.png`); Toast Menus → Menu manager (`F4-03.png`) | franchise | 2,331 recipes; 64,670 menu items, visible rows mapped to `MI …` recipes. Toast Target = Firehouse Subs Group, 435 groups, 1 location. Unmapped-with-sales filter not found `(?)`. Hub q4/q5: see section F4. |
| F5 | Inventory counts | in place | R365 Inventory → Storage locations (`F5-01.png`); Count templates (`F5-02.png`, `F5-02.txt`); Inventory counts (`F5-03.png`) | owner | 11 named locations + Unassigned 212. Template **CARY 1 - FHS Weekly Inventory** (207 items, On Demand). Last approved count 10/04/2026, $7,461.73. Hub q2/q3: counts happen; paper and chemicals locations exist. |
| F6 | Waste log | in place | R365 Inventory → Waste (`F6-01.png`); Toast Food waste breakdown (`F6-02.txt`) | owner | 1 R365 log in last 30 days: WL-000002, 09/28/2026, 1 item, $0.92, Approved. Toast this month $0 / 0 items. Void-reason setup page not found `(?)`. |
| F7 | Food cost reporting | partial | R365 Reports → Actual vs Theoretical Analysis (`F7-01.png`); Actual vs Theoretical Location Summary (`F7-02.png`); P&L comparison (`F7-03.png`, `F7-04.png`) | R365 support | AvT Analysis: "The 'ToCount' parameter is missing a value" (no numbers). Location Summary returns numbers for 10/11–10/11 with End 0.00. P&L Period 10 2026 returns numbers but has no Sales section. No report named Theoretical Food Cost. Hub q5: no food-cost % target on these pages. |
| F8 | Cash and deposits | partial | R365 Accounting → Bank reconciliations (`F8-01.png`); Toast Reports → Payout overview (`F8-02.png`, `F8-03.png`); Cash Drawer History (`F8-04.txt`) | unknown | R365: 0 bank reconciliations; DSS Total Deposit $0.00. Toast: 10 October payouts, card $8,917.23, payout $8,370.60; cash drawer starting cash $250.00. |
| F9 | Daily flash | partial | R365 Sales & forecasting → Daily sales summary (`F9-01.png`); Report subscriptions (`F9-03.png`); Toast Reports → Weekly overview (`F9-02.png`) | owner | Daily DSS exists (CARY 1 through 10/10/2026). Toast weekly overview exists. R365 subscriptions = 0 of 0 (nothing emailed). |
| F10 | Scheduling and overtime | partial | R365 Workforce → Scheduling (`F10-01.png`); Toast Team → Scheduling (`F10-02.txt`) | owner | R365 week of Oct 5 exists, status Unpublished; OT Hours 69.61; 13 Shifts Not Sent to POS. Toast Scheduling = Sling connect error / not set up. |
| F11 | Tips automation | in place | R365 Workforce → Tip automation (`F11-01.png`); Toast Tip withholding (`F11-02.txt`); Team settings (`F11-03.txt`) | owner | Rule **Cary1 Tip Rule**, Frequency Daily, 18 pending days. Last POS import 10/11/2026 10:08 AM. Toast tip pooling = UPGRADE; no tip withholding. |
| F12 | Payroll reports | in place | R365 Reports → Labor Payroll Review (`F12-01.png`); Tip Automation Distributions (`F12-02.txt`); Toast time entries (`F12-03.txt`); R365 Labor details (`F12-04.txt`) | owner | Both R365 reports open without a parameter error (default range 10/11–10/11 was empty). Toast time entries list exists. R365 labor details: 4,295 rows; some CARY 1 pay rates $0.00. |
| F13 | Delivery reconciliation | partial | R365 Accounting → Customers (`F13-01.txt`); Toast Integrations (`F13-02.png`); Takeout & delivery (`F13-03.png`); menu visibility (`F4-03.txt`); payouts External (`F8-02.png`) | franchise | R365: 0 AR customers; DSS deposits $0.00. Toast Integrations view-only for this login. Menu items tagged Catering (ezCater) and Online ordering partners. External (not settled by Toast) −$546.63 MTD. |
| I1 | Toast → R365 integration | partial | R365 Admin → Integrations POS (`I1-01.png`); Tip automation Last POS import (`F11-01.png`); Daily sales (`F9-01.png`); Toast Integrations (`I1-02.txt`) | R365 support | Last POS import 10/11/2026 10:08 AM (next 10/12/2026 10:49 AM). CARY 1 sales through 10/10/2026 match Toast. Admin Toast tile Disconnected (employee/job push). Toast installed-integrations list not readable. |
| O1 | Who owns what | in place | `O1-01.txt`; franchise/greyed labels (`O1-02.png`, `O1-03.png`, `O1-04.png`, `O1-05.png`, `O1-06.png`) | unknown | Mixed: franchise/brand for items, recipes, Toast menu; R365 support for weekly count template and system reports; owner for counts, waste, tip rule, DSS. No page said "franchise-owned" in those words. |

## F2 · Items, units, vendors

**Status:** in place. **Owner:** franchise (Brand / Location group Firehouse Subs on items; vendor item list is brand-wide). Owner role sees Create and item Edit/Save (not clicked).

R365 Inventory → Items → Items, `https://fhs4021089.restaurant365.com/react/inventory/purchase-items` (`F2-01.png`): grid **1–250 of 551 Items**. Columns include Name, Avg Cost, Reporting UofM, Min/Max Cost, Inventory UofM, cost/inventory/waste/donation accounts, Brand, Cost Update Method **Last Received**. First alphabetical rows are paper and beverages; many Avg Cost **$0.00** (e.g. BAG PAPER, BAG SANDWICH, BAGASSE BOWL, BEV APPLE JUICE ALL, BEV BOTTLE SODA). Some beverages have cost (from `F2-01.txt`): BEV CCF BARQS ROOTBEER **$75.58** Each. Items (classic) `/react/inventory/legacy/Items` shows **1–250 of 2882** (capture still loading on `M0-02.txt`; likely includes inactive/other-brand rows `(?)`).

Sorted by Avg Cost (`F2-02.txt`):

| Name | Avg Cost | Reporting / inventory UofM | Cost account |
|---|---|---|---|
| BEV SYRUP LIQUID SWTNR NON NUTRITV BIB | $119.16 | Pack (2.5 Gallon) | BEVERAGE COST |
| BEV CCF SPRITE / ZERO | $114.75 | Each | BEVERAGE COST |
| PAPER FD BOX CORR CATERING W/ INSERT | $94.62 | Pack (35 CT) | PAPER COST - FOOD RELATED COST |
| PAPER FD LINER PLAS TEA URN | $87.30 | CS - 100/CT | (paper) |
| PAPER FD BAG PAPER BRN HNDL CATERING | $84.48 | CS - 200/CT | (paper) |
| MEAT TURKEY ROASTED - 1304375 | $7.46 | LB / LB | MEAT COST |
| MEAT TURKEY - 1001190 | $3.56 | LB / LB | MEAT COST |
| DAIRY SHREDDED CHEESE MEX BLEND | $1.78 (min $1.64 max $1.92) | Pack (8 oz-wt) | DAIRY COST |
| BREAD LARGE WHEAT SUB ROLL | $0.62 | Roll | BREAD COST |
| BREAD LARGE WHITE SUB ROLL | $0.59 grid / **$0.58** on CARY 1 detail | Roll | BREAD COST |

Several cheese and bread items show **$0.00** (e.g. DAIRY CHEESE FETA, BREAD BAGEL EVERYTHING, ZZZ-prefixed retired rows). Purchase unit and count unit match on most grid rows; exceptions include BEV APPLE JUICE ALL (reporting Each vs inventory CS - 40/CT) and BREAD WHITE BREAD (Each vs Slice).

Item detail BREAD LARGE WHITE SUB ROLL (`F2-03.png`): Inventory Cost **$0.58 per Roll** as of 8/8/2026; Cost Method Last Received; last received **#9100594310-CARY**, Cheney Brothers, Inc., **10/02/2026**, U of M **CS - 6/Pack (6 CT)**, qty **2.00**, total **$41.96**. Location costing: CAMDEN SQUARE $0.59 / Roll; CARY 1 $0.58 / Roll. Vendor Items tab (`F2-05.txt`): **45** vendor items (Ben E. Keith regions, Merchants, Harbor, BrownFoodService, Cheney, Gordon Foods). Settings tab (`F2-06.txt`): categories Food / Breads; Location Groups Firehouse Subs; SAVE greyed (no edit). Measurement Conversions section present; conversion values themselves not captured `(?)`.

Vendors (`F2-04.txt`): Accounting → Accounts payable → Vendors, `/react/accounting/legacy/Vendors`, **1–114 of 114** (company-wide). Payment Hold = No on visible rows. Visible names start A&A Produce, AJ Lanzarotta, Alpha Produce, AmeriCare, Baldar, Bedway Produce, Ben E Keith (several cities), Bix Produce. CARY 1 item receipts in this audit are Cheney Brothers, Inc.

**Hub q1 (distributor):** Cheney Brothers, Inc. is the vendor on CARY 1 receipts and invoices. **Hub q3 (item scope):** paper items and PAPER COST accounts exist on the item grid; not food-only. **Hub q4 (corporate items):** names carry 7-digit numbers (e.g. 1001190) and Brand Firehouse Subs `(?)` brand-pushed.

## F3 · Electronic invoices

**Status:** in place (invoices arrive by R365 Import, not typed). **Owner:** R365 support for the feed; owner role can Approve (3 newest CARY 1 invoices still Unapproved).

AP transactions (New), `/react/accounting/ap-transactions?tab=transactions` (`F3-01.png`): **1–250 of 269** company-wide. Newest CARY 1 rows: **9100633687** 10/09/2026 Cheney Brothers; **9100633686** 10/09/2026 Cheney $481.67; **9100612350** 10/06/2026 Cheney. All visible CARY 1 rows **Unapproved**, operational status In progress, **Modified by R365 Import** (`F3-01.txt`). CAMDEN SQUARE rows are PFG (out of scope).

Vendor Cheney Brothers, Inc. (`F3-03.txt`): Active, payment method Check, All locations. Approved balance **$39,982.21** (+ **$264,494.94** pending approval). Last payment "-", payment terms "-". Procurement: Vendor group empty, Food-service distributor empty, PO file format empty; no field labelled EDI. Transactions tab lists CARY 1 invoices from **08/14/2026** through **10/09/2026**, about two a week, including **9100594310-CARY** 10/02/2026 **$1,832.25 Approved** and the three newest Unapproved (10/06 $1,983.60; 10/09 ×2). Five AP Credit Memos also listed. Invoice numbers use a **`-CARY`** suffix on approved rows.

One invoice opened read-only (`F3-02.txt`): **9100633686**, CARY 1, 10/9/2026, **$481.67**, one line K-9 CREW PLUSH - 10185850 to account **7622 - CHARITY**. No attachment. Closed without Save.

Documents to process (`F3-04-missing.txt`): list empty; **no inbound email-capture address** on that page. Admin → Integrations → INVOICES (`F3-06.png`): **Supplyit = Disconnected**, **NDCP = Disconnected**. Invoices still arrive via R365 Import from Cheney; the connector for that feed is not one of those two tiles `(?)`.

**Hub q1 (invoice method):** electronic import into R365 (Modified by R365 Import), not email capture, not Supplyit/NDCP.

## F4 · Recipes and menu mapping

**Status:** in place (recipes exist; visible Toast/R365 menu rows have a recipe). **Owner:** franchise.

R365 Inventory → Recipes, `/react/inventory/recipe-items` (`F4-01.png`): view **Recipes - R365**, **1–250 of 2331**. Sample: 10 Medium Honey Ham - 406024 **$8.00** Each; 10 Medium Smoked Turkey - 406014 **$9.33**; BOX LUNCH PAPER **$0.37**; Catering Platter Paper **$3.01**. Six-digit numbers on recipe names look like brand menu codes `(?)`. Buttons: Update recipe costs, Create (not clicked).

R365 Inventory → Menu Items (classic), `/react/inventory/legacy/MenuItems` (`F4-02.png`): **1–250 of 64670**. Visible rows Estimated Cost **$0.00**, Target Profit **% 0.00**, Recipe filled (`MI Pickle Spear - 123510…`, `MI Sorensen Sauce Medium - 114105`, `MI No Recipe Needed`, `MI DELUXE CATERING SALAD…`). No Unmapped filter was applied; unmapped-with-sales view not found `(?)`.

Toast Menus → Menu manager → Items (`F4-03.png`): restaurant 00122 - Cary 1. Total item count not shown (paged, "Load more"). First rows: !Bottle Drinks, !Canned Soda, !Chips, fountain sizes. Every visible Target = **Firehouse Subs Group - 435 groups, 1 location**. Pricing strategy Base; Cost **"—"**. Visibility includes POS, Kiosk, Toast Order and Pay, Toast Online Ordering, Toast Takeout App, **Online ordering partners**; some items tagged **Catering (ezCater)** (`F4-03.txt`). Save greyed. Modifiers tab not opened.

**Hub q4:** recipes and Toast menu look brand-supplied (recipe numbers; 435-group target). **Hub q5:** Target Profit % = **0.00** on visible R365 menu items; no food-cost % target labelled on these pages.

## F5 · Inventory counts

**Status:** in place. **Owner:** owner for posted counts; weekly template created by **R365 DSS User** / modified by **R365** (`F5-02.txt`) → R365 support for the template.

Storage locations, CARY 1 (`F5-01.png`, `F5-01.txt`): **12** groups.

| Location | Items |
|---|---|
| Unassigned | 212 |
| BEVERAGE STATION | 14 |
| BOTTLE COOLER | 7 |
| CHEMICAL & JANITORIAL | 18 |
| CHIPS | 1 |
| COOLER | 40 |
| DISPLAY | 7 |
| DRY | 78 |
| FREESTYLE | 30 |
| FREEZER | 14 |
| LINE | 77 |
| REGISTER | 6 |

11 named locations; 212 unassigned. Create Storage Location enabled (not clicked).

Templates (`F5-02.txt`; `F5-02.png` shows the first row before horizontal scroll): **1–3 of 3**.

- CAMDEN SQUARE - FHS Weekly Inventory · 207 items · On Demand · GL Posting Yes · created 03/11/2026 by R365 DSS User · modified 10/06/2026 by R365
- **CARY 1 - FHS Weekly Inventory** · CARY 1 · **207 items** · **On Demand** · GL Posting Yes · created 03/11/2026 by R365 DSS User · modified 10/06/2026 by R365
- monthly · CAMDEN SQUARE +1 · 250 items · Period · created 10/04/2026 by Mayuriben Surati

Inventory counts, CARY 1 (`F5-03.png`): **1–3 of 3**.

| Status | Business date | Total | Template |
|---|---|---|---|
| Approved | 10/04/2026 | $7,461.73 | CARY 1 - FHS Weekly Inventory |
| In Progress | 09/28/2026 | $20.53 | CARY 1 - FHS Weekly Inventory |
| Approved | 01/08/2026 | $2,625.45 | FHS Weekly Inventory |

Latest posted count **10/04/2026** is inside 30 days of 2026-10-11. Completed by Mayuriben Surati 10/04/2026 12:59:59 PM (`F5-03.txt`). Template is On Demand (not a scheduled Sunday job).

**Hub q2:** counts happen (approved 10/04/2026; weekly template exists). **Hub q3:** CHEMICAL & JANITORIAL (18 items) and paper on the item list → not food-only.

## F6 · Waste log

**Status:** in place per “entries in the last 30 days”; use is 1 log / $0.92. **Owner:** owner.

R365 Inventory → Waste, `/react/inventory/waste-logs?activeTab=wasteLogs` (`F6-01.png`): **1–1 of 1** all-time. **WL - 000002**, Approved, CARY 1, **09/28/2026**, Item Count **1**, Total **$0.92**. Within last 30 days (13 days before 2026-10-11). Log number 000002 implies at most two waste logs ever `(?)`; WL-000001 not listed.

Toast Menus → Food waste reporting, This month Oct 1–Oct 11 (`F6-02.txt`): Total food waste **$0**, items **0**, "There is no data for the selected filters." Void/waste reason setup page not found in Toast nav `(?)`.

## F7 · Food cost reporting

**Status:** partial. Reports exist; AvT Analysis does not return numbers; P&L numbers are not a usable food-cost P&L (no sales). **Owner:** R365 support (System View; Customize greyed).

Actual vs Theoretical Analysis (`F7-01.png`): viewer message **The 'ToCount' parameter is missing a value**. No numbers. CARY 1 has one recent approved weekly count (10/04/2026) and one old dated 01/08/2026, so a From/To count pair for last week was not on screen.

No report titled **Theoretical Food Cost**. Closest opened: Actual vs Theoretical Location Summary (`F7-02.png`), default range **10/11/2026–10/11/2026**. It returned numbers, CARY 1 only. Parameters: Key items only No; Items to display All Items; Show unapproved Yes; Variance includes waste No; Costing method End Count Cost.

| Row | Begin | Purch | Xfer | End | Actl | Theo | Var |
|---|---|---|---|---|---|---|---|
| Grand total / CARY 1 total | 7,520.46 | 0.00 | 0.00 | 0.00 | 7,520.46 | 4,485.73 | 3,034.73 |
| Food > Beverages | 1,201.77 | 0.00 | 0.00 | 0.00 | — | 1,201.77 | 1,114.72 |
| Food > Breads | 314.26 | 0.00 | 0.00 | 0.00 | — | 314.26 | 323.39 |
| Food > Cookies | 119.17 | 0.00 | 0.00 | 0.00 | — | 119.17 | 119.17 |

End **0.00** on a one-day range: not a real actual-vs-theoretical between two posted counts. Chemical & Janitorial begin **0.00**.

P&L comparison (`F7-03.png`, `F7-04.png`): As Of **Period 10, 2026**, Show Unapproved **No**, Rounding Whole Numbers. The report **starts at Cost of Goods Sold** (no Sales/Revenue section). F7-04 totals: Total COGS - PURCHASES CAMDEN **1,246** / CARY 1 **−5,266** / Total **−4,020**; Gross Profit **−1,246** / **5,266** / **4,020**; Net Operating Income **−1,439** / **5,609** / **4,170**. infnty% on variance. Labor/payroll expense lines not on this P&L. Negative CARY 1 COGS with Show Unapproved = No matches unapproved recent invoices plus the 10/04/2026 count dollar value `(?)`.

**Hub q5:** no food-cost % target on AvT or P&L pages.

## F8 · Cash and deposits

**Status:** partial (Toast records and settles card payouts; R365 does not record deposits or bank rec). **Owner:** unknown (Toast payout group is Firehouse Subs Management Group).

R365 Accounting → Banking → Bank reconciliations (`F8-01.png`): **No items to display**. CREATE present, not clicked. Bank accounts / activity / transactions not opened.

Toast Reports → Payments → Payout overview (`F8-02.png`): group **Firehouse Subs Management Group - 00122 - Cary 1**, This month Oct 1–31, data as of Oct 10, 2026. Card payments **$8,917.23**; Refunds/Fees/Withholdings/Chargebacks **$0.00**; External (not settled by Toast) **−$546.63**; Payout total **$8,370.60**. Payout list (`F8-03.png`): **1 to 10 of 10** payouts in October; one per business day, settled about two days after the sales period (e.g. Sat Oct 10 settles Thu 10/8 sales $1,085.66, payout about $970).

Toast Cash Drawer History, Today 10/11/2026 (`F8-04.txt`): Starting Cash total **$250.00** (Cashier 2 RP $250.00, Cashier 1 RP $0.00); cash in hand **$13.93** so far; drawers still open. Cash activity audit exists in the menu (not opened).

R365 Daily Sales (`F9-01.png` / `F9-01.txt`): every CARY 1 day shown has Total Deposit **$0.00** and negative Over/Short (10/10 **−$98.48**, 10/09 **−$208.16**, 10/08 **−$20.33**, 10/07 **−$58.11**, 10/06 **−$148.77**), status In Progress.

## F9 · Daily flash

**Status:** partial (daily/weekly report exists on screen; nothing is emailed). **Owner:** owner.

R365 Sales & forecasting → Daily sales summary (DSS Beta), `/react/sales-and-forecasting/daily-sales` (`F9-01.png`): **1–250 of 726**. CARY 1 newest:

| Date | Net Sales | Labor $ | Hours | Deposit | Over/Short | Guests |
|---|---|---|---|---|---|---|
| 10/10/2026 | $1,693.17 | $0.00 | 38.33 | $0.00 | −$98.48 | 86 |
| 10/09/2026 | $2,046.26 | $0.00 | 36.83 | $0.00 | −$208.16 | 118 |
| 10/08/2026 | $1,908.04 | $0.00 | 40.08 | $0.00 | −$20.33 | 111 |
| 10/07/2026 | $1,904.10 | $0.00 | 35.69 | $0.00 | −$58.11 | 114 |
| 10/06/2026 | $1,745.26 | $0.00 | 36.54 | $0.00 | −$148.77 | 109 |

All Status **In Progress**. Labor $ **$0.00** / Labor % **0.00** for CARY 1 (hours import; dollars missing). Operations overview “A Look at Yesterday” (`M0-01.txt`): Total Sales **$1,693.17**, Over/Short **−$98.48**, SPLH **$44.17** (matches 10/10).

Toast Reports → Weekly overview Oct 5–11 (`F9-02.png`): Mon $1,936.29, Tue **$1,745.26**, Wed **$1,904.10**, Thu **$1,908.04**, Fri **$2,046.26**, Sat **$1,693.17**, Sun $252.91 so far; week to date $11,486.03. Tue–Sat match R365 DSS **to the cent**. Toast labor cost $0 / 0% every day.

R365 Report subscriptions (`F9-03.png`): **No records to display**, **0–0 of 0**. ADD enabled, not clicked. Toast scheduled-email list was not a separate page; Email export icon on Weekly overview was not clicked (`F9-02.txt`).

## F10 · Scheduling and overtime

**Status:** partial. **Owner:** owner.

R365 Workforce → Scheduling → Schedule, CARY 1, week of Oct 5, 2026 (`F10-01.png`): badge **Unpublished**. **OT Hours 69.61**. Banner **13 Shifts Not Sent to POS**. Shifts exist by job (GM - Salary, Shift Lead, Team Member) including Unassigned open shifts. Red outlines on over-hours rows. PUBLISH and New Shift present, not clicked. Employees list note: 97 employees (`F10-01.txt`; details not captured).

Toast Team → Scheduling `/scheduling/sling/connect` (`F10-02.txt`): error “Oops! We have some cleaning up to do”. Home promo “Try now” for Toast scheduling (`M0-05.txt`). Toast Scheduling is not in use.

## F11 · Tips automation

**Status:** in place. **Owner:** owner.

R365 Workforce → Tip automation, CARY 1 (`F11-01.png`): **Last POS import: 10/11/2026 - 10:08 AM**. **Next POS import: 10/12/2026 - 10:49 AM**. Week of Oct 5: Collected Tips Cash **$0.00**, Card **$411.72**; Average Tip % Cash 0.00%, Card **7.90%**. Pending: **1–18 of 18**. Rows use rule **Cary1 Tip Rule**, Last Calculated 10/11/2026 - 6:16 AM, Frequency **Daily** (`F11-01.txt`). VIEW not opened; Calculate/Approve not clicked.

Toast Tip Withholding (`F11-02.txt`): **No Tip Withholding setup.** Team settings (`F11-03.txt`): Tip pooling policy **UPGRADE**; Payroll/Tips/Contests locked. Tips are collected in Toast and distributed in R365.

## F12 · Payroll reports

**Status:** in place (reports exist and run). **Owner:** owner.

Labor Payroll Review System View (`F12-01.png`): opened 10/11/2026 11:37:21 AM EDT, range **10/11/2026–10/11/2026**, table empty (Total label only). No parameter error. Columns include Location, Reg/OT/DT Hrs, pay, break and split-shift fields.

Tip Automation Distributions Report (`F12-02.txt`): title “… Employee | 10/11/2026 - 10/11/2026”, no rows, no parameter error.

Toast Labor → Time entry management (`F12-03.txt`): Today 10/11, CARY 1, three open entries (ASM - Hourly 8:24 AM, Team Member 9:59 AM, Cashier 10:10 AM), 0.00 hours, Anomalies empty. Add entry enabled, not clicked.

R365 Labor details (`F12-04.txt`): **1–250 of 4295**, imported punches through 10/10. Many CARY 1 rows Pay Rate **$0.00** and Total **$0.00** with hours (explains DSS Labor $ = $0.00); other rows have rates in the $10.00–$16.80 range.

## F13 · Delivery reconciliation

**Status:** partial. **Owner:** franchise (Toast Integrations view-only; menu target is the brand group).

R365 Accounting → Customers (`F13-01.txt`, `M0-04.png`): **No items to display**, 0 customers. No third-party delivery partner as an AR customer. No dedicated delivery-deposits page in the Accounting menu that was opened.

Toast Integrations (`F13-02.png`): catalog Add Integrations; banner **You do not have permission to Manage Integrations for this restaurant, therefore this page is view only.** My Integrations list did not open. Uber Eats appears as a Preferred Partner tile on the catalog (not proof it is installed).

Toast Takeout & delivery (`F13-03.png`): advertising and an Online Ordering training pop-up; no DoorDash / Uber Eats / Grubhub / ezCater / first-party channel list.

Indirect evidence channels may flow: menu visibility **Online ordering partners** and **Catering (ezCater)** (`F4-03.txt`); payout **External (not settled by Toast) −$546.63** MTD (`F8-02.png`). Payouts are not reconciled in R365 (deposits $0.00, 0 bank recs, 0 AR customers).

## Licensed modules

**Status:** in place. **Evidence:** R365 Operations overview `M0-01.png`; Reports `M0-03.txt`; More/Admin `M0-04.txt`; Toast home `M0-05.txt`; Payroll discover `M0-06.txt`; Shop `M0-07.png`. **Owner:** owner (R365 Admin opens); Toast Shop / Integrations managed by an account admin.

R365 left rail visible and opened: Dashboards (Classic, Labor, Operations, Operations overview, Tasks), Reports (Ad hoc, AI dashboards, Custom financial, My reports, P&L comparison, Report subscriptions), Accounting (AP, AR, Banking, Fixed assets, GL, Transactions), Inventory (Inventory, Invoices, Items, Recipes), Sales & forecasting (Daily sales summary, Forecasting, Menu items, Sales tickets), Workforce (Employees, Scheduling, Time & attendance), Task management, Manager log, More (**Hire, Payroll, Training**), **Admin**, Marketplace (`M0-04.txt`). Operations overview tiles (`M0-01.png`): Invoices, Schedule, Inventory, **Orders (greyed)**, Transfers, Reports, Waste Log, Tasks (**34**). Permission denials: none on R365 except the grey Orders tile. Admin → Users & security: **71 users**. Admin → Integrations sections: Employee HR, Payroll (Netchex Disconnected), Invoices (Supplyit/NDCP Disconnected), Banking, POS (PAR Brink, Xenial, Toast, Simphony all Disconnected) (`M0-04.txt`, `I1-01.png`).

Toast left nav visible (`M0-05.txt`): Home, Toast IQ, Inbox, Reports, Discover products, Team, Finance, Payroll, Menus, Takeout & delivery, Catering & events, Advertising, Marketing, Front of house, Kitchen, xtraCHEF, Waitlist & Reservations, Retail, Scheduling, Websites, Manager Log, Integrations, Shop, Toast account, Support Center, Device hub. In use on this login: Reports, Menus, Team time entries, Payments/payouts. **Not licensed / not set up:** Toast Payroll = discover page “Add Toast Payroll”, **38 employees** at 00122 (`M0-06.txt`); Scheduling = Sling error (`F10-02.txt`); Websites = Get Started (`M0-06.txt`); tip pooling / Team Pro = UPGRADE (`F11-03.txt`); Toast Online Ordering home promo “Upgrade now” (`M0-05.txt`). Toast Shop (`M0-07.png`): **Toast Shop access limited** — this login cannot purchase; contact account admin.

## Toast → R365 integration

**Status:** partial. **Evidence:** `I1-01.png`, `F11-01.png`, `F9-01.png`, `F9-02.png`, `F12-04.txt`, `I1-02.txt`. **Owner:** R365 support (POS import schedule); Toast side unreadable for this login.

**Last sales import date:** CARY 1 Daily Sales rows through **10/10/2026** (`F9-01.png`); those net sales match Toast Weekly overview to the cent (`F9-02.png`). Combined POS import stamp on Tip automation: **Last POS import 10/11/2026 - 10:08 AM** (`F11-01.png`). The captures do not show a separate “last sales import” field distinct from that POS import stamp.

**Last labor import date:** Labor details imported through **10/10/2026** (`F12-04.txt`). Same POS import stamp **10/11/2026 - 10:08 AM**; **Next POS import 10/12/2026 - 10:49 AM** (daily). Labor hours import; CARY 1 labor **dollars** stay $0.00 on DSS where pay rate is $0.00.

**Errors shown:** none on the import stamp or DSS grid. Related issues, not import failures: Admin POS **Toast = Disconnected** (“Creates and updates Toast employee and job records with data from R365”) (`I1-01.png`) — that tile is employee/job **push**, not the sales/labor pull; **13 Shifts Not Sent to POS** (`F10-01.png`); Toast Integrations page view-only so the Toast-side R365 connector cannot be confirmed (`I1-02.txt`).

## Who owns what

**Status:** in place (recorded per row from the same captures). **Evidence:** `O1-01.txt` and `O1-02.png`–`O1-06.png`. **Owner:** mixed; table uses **unknown** as the single-cell summary.

Franchise / brand / corporate signals (no page used the words “franchise-owned” or “corporate-managed”):

- R365 item Brand and Location group **Firehouse Subs**; recipe and item numbers; weekly count template created by **R365 DSS User** / modified by **R365**.
- Toast menu Target **Firehouse Subs Group - 435 groups, 1 location** (`O1-03.png` / `F4-03.png`).
- Toast payouts under **Firehouse Subs Management Group** (`F8-02.png`).
- Toast Integrations **view only** (`O1-05.png` / `F13-02.png`); Toast Shop purchase denied (`O1-04.png` / `M0-07.png`); Team Pro / Payroll / tip pooling upgrade walls (`O1-06.png`).

Greyed / locked: R365 Orders tile (`O1-02.png` / `M0-01.png`); report Customize on System Views; Toast Save on Menu manager (unchanged); Toast Shop; Toast Integrations manage.

Editable by this login (controls seen enabled, never clicked): R365 item Create/Edit, vendor Save, invoice Save/Approve, count Create, waste Create, schedule Publish, tip-rule VIEW, report Add subscription, Admin CONNECT. R365 Admin menu opens.

Per-function owner (from `O1-01.txt`, same evidence as the F-rows): F2 franchise; F3 feed R365 support, approval owner; F4 franchise; F5 template R365 support, counts owner; F6 owner; F7 R365 support (system reports); F8 unknown; F9 owner; F10 owner; F11 owner; F12 owner; F13 franchise; I1 R365 support / franchise `(?)`.
