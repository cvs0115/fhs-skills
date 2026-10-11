# Research · items-122 · Verify 122's counted items: cost, units, Cheney vendor items

2026-10-11. Verify-only F2 from PC captures in `/srv/fhs-build/reports/items-122-captures/`. No browser was opened. Nothing in R365 was changed. Fixes are not this note.

**CARY 1 - FHS Weekly Inventory** (TPL-02.csv: 207 items, On Demand, created by R365 DSS User). Approved count **10/04/2026**, list total **$7,461.73** (CNT-01.txt). Line costs and extended values are from the Item Details export **CNT-03.csv** (207 rows; Current $ Total sums to $7,461.73). Do not use the In Progress 09/28 count.

**How cells were filled**

- **Name:** TPL-02.csv `Item name` (207 unique).
- **Count unit:** CNT-03.csv `UofM`. TPL-02.csv has Reporting UofM only, not the count unit (TPL-02.txt). 72 count-line names append a second item code (`MEAT TURKEY - 1001190 - 1001190`); those were matched back to the template name. One more count-line name adds a code the template omits (`PAPER FD BAG PAPER BRN HNDL CATERING - 1001590`).
- **Cost per count unit / Extended value:** CNT-03.csv `Current $ Cost` / `Current $ Total` on that 10/04 line. Quantity 0 with a non-zero unit cost is not $0 cost. CNT-03 always shows a unit cost, so Avg Cost is not used as a stand-in.
- **Purchase unit:** ITM-01.csv `Inventory UofM` (Items grid, `/react/inventory/purchase-items`). That column matches the count unit on every template purchase item. Four recipe names are not on ITM-01.csv.
- **Cheney vendor item:** ITM-02.csv only (Vendor items, `/react/inventory/legacy/VendorItems`, filter Cheney Brothers, Inc., 819 rows). `yes / <PurchasingUofM>` when the template name equals the export `Item` column (multiple Cheney units joined with ` ; `). The export is Cheney-only, so a template name that is not in the file is `not shown (ITM-02.csv)`, not `no`. 192 names have a Cheney row; 15 do not.
- **Capture:** CNT-03.csv for every row (all 207 template names are on the 10/04 Item Details export).
- **Who can fix:** Brand and Location Group **Firehouse Subs** on every ITM-01.csv row → `franchise` for those items. The four recipe rows are not on that grid; TPL-02.csv Added by **R365 DSS User** / TPL-01.txt Created by **R365 DSS User** → `R365 support`. Item-detail SAVE was visible on the four opened items (ITM-05..ITM-12.txt) and was not captured as greyed; that is not used to mark the other items owner-editable. No page used the words "franchise-owned".

## Item table

| Name | Count unit | Cost per count unit (10/04/2026) | Extended value (10/04/2026) | Purchase unit | Cheney vendor item | Capture |
|---|---|---|---|---|---|---|
| BEV APPLE JUICE ALL | CS - 40/CT | $0.00 | $0.00 | CS - 40/CT | yes / CS - 40/CT | CNT-03.csv |
| BEV BOTTLE SODA | Each | $0.00 | $0.00 | Each | yes / CS - 24/CT | CNT-03.csv |
| BEV BOTTLED WATER | Each | $0.00 | $0.00 | Each | yes / CS - 24/CT | CNT-03.csv |
| BEV CCF AHA BLUEBERRY POM | Pack (21 oz-wt) | $0.00 | $0.00 | Pack (21 oz-wt) | yes / Each | CNT-03.csv |
| BEV CCF BARQS ROOTBEER | Each | $75.58 | $57.44 | Each | yes / Each | CNT-03.csv |
| BEV CCF BLACK CHERRY LIMEAID P1 | Each | $66.26 | $59.63 | Each | yes / Each ; Pack (23 oz-wt) | CNT-03.csv |
| BEV CCF BLACK CHERRY LIMEAID P2 | Each | $12.71 | $11.44 | Each | yes / Each ; Pack (23 oz-wt) | CNT-03.csv |
| BEV CCF CAFFEINE FREE DIET COKE | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| BEV CCF CHERRY FLAVOR | Each | $19.49 | $16.76 | Each | yes / Each | CNT-03.csv |
| BEV CCF COKE | Each | $75.58 | $94.48 | Each | yes / Each ; Pack (46 oz-wt) | CNT-03.csv |
| BEV CCF COKE ZERO | Each | $75.58 | $70.29 | Each | yes / Each ; Pack (46 oz-wt) | CNT-03.csv |
| BEV CCF DIET COKE | Each | $75.58 | $57.44 | Each | yes / Each ; Pack (46 oz-wt) | CNT-03.csv |
| BEV CCF DR PEPPER | Each | $75.58 | $71.80 | Each | yes / Each | CNT-03.csv |
| BEV CCF FANTA | Each | $62.52 | $60.02 | Each | yes / Each | CNT-03.csv |
| BEV CCF FRUIT PUNCH | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| BEV CCF GRAPE FLVR | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| BEV CCF HI-C | Each | $49.51 | $57.43 | Each | yes / Each ; Pack (23 oz-wt) | CNT-03.csv |
| BEV CCF INGREDIENT SOL CC | Each | $12.71 | $9.02 | Each | yes / Each | CNT-03.csv |
| BEV CCF LEMON FLVR | Each | $19.49 | $9.94 | Each | yes / Each | CNT-03.csv |
| BEV CCF LIME FLVR | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| BEV CCF MELLO YELLOW | Each | $59.16 | $65.08 | Each | yes / Each | CNT-03.csv |
| BEV CCF MM LEMONADE LIGHT | Each | $31.64 | $50.31 | Each | yes / Each | CNT-03.csv |
| BEV CCF ORANGE FLVR | Each | $19.49 | $22.61 | Each | yes / Each | CNT-03.csv |
| BEV CCF PEACH FLVR | Each | $19.49 | $23.58 | Each | yes / Each | CNT-03.csv |
| BEV CCF PINEAPPLE CTRG | Pack (21 oz-wt) | $0.00 | $0.00 | Pack (21 oz-wt) | yes / Pack (21 oz-wt) | CNT-03.csv |
| BEV CCF POWERADE | Each | $67.63 | $50.05 | Each | yes / Each | CNT-03.csv |
| BEV CCF SPRITE / ZERO | Each | $114.75 | $190.49 | Each | yes / Each | CNT-03.csv |
| BEV CCF SPRITE / ZERO INGREDIENT SOL AA | Each | $12.71 | $17.41 | Each | yes / Each | CNT-03.csv |
| BEV CCF STRAWBERRY FLVR | Each | $19.49 | $15.20 | Each | yes / Each | CNT-03.csv |
| BEV CCF VANILLA FLVR | Each | $19.49 | $18.71 | Each | yes / Each | CNT-03.csv |
| BEV CCF VITAMIN WATER | Each | $57.01 | $120.29 | Each | yes / Each | CNT-03.csv |
| BEV CHOCOLATE MILK | Each | $0.00 | $0.00 | Each | yes / CS - 12/CT ; CS - 24/CT | CNT-03.csv |
| BEV MILK GALLON | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| BEV MILK SS | Each | $0.00 | $0.00 | Each | yes / CS - 24/CT | CNT-03.csv |
| BEV POWERADE | Each | $0.00 | $0.00 | Each | yes / BIB (2.5 Gallon) | CNT-03.csv |
| BEV SYRUP LIQUID SWEETENER HFCS BIB | Pack (5 Gallon) | $26.18 | $52.36 | Pack (5 Gallon) | yes / BIB (5 Gallon) | CNT-03.csv |
| BEV SYRUP LIQUID SWTNR NON NUTRITV BIB | Pack (2.5 Gallon) | $0.00 | $0.00 | Pack (2.5 Gallon) | yes / BIB (2.5 Gallon) | CNT-03.csv |
| BEV TEA BAG ICED PK | Each | $0.00 | $0.00 | Each | yes / CS - 32/CT ; CS - 96/CT | CNT-03.csv |
| BREAD LARGE WHEAT SUB ROLL | Roll | $0.6131 | $29.43 | Roll | yes / CS - 6/Pack (6 CT) | CNT-03.csv |
| BREAD LARGE WHITE SUB ROLL | Roll | $0.5828 | $69.94 | Roll | yes / CS - 6/Pack (6 CT) | CNT-03.csv |
| BREAD MEDIUM WHEAT SUB ROLL | Roll | $0.3935 | $49.58 | Roll | yes / CS - 12/Pack (6 CT) | CNT-03.csv |
| BREAD MEDIUM WHITE SUB ROLL | Roll | $0.3496 | $151.03 | Roll | yes / CS - 12/Pack (6 CT) | CNT-03.csv |
| BREAD WHITE BREAD | Slice | $0.2101 | $14.29 | Slice | yes / CS - 6/Pack (25 oz-wt) | CNT-03.csv |
| BROWNIE - 1001415 | Pack (24 CT) | $17.305 | $57.68 | Pack (24 CT) | yes / CS - 4/Pack (24 CT) | CNT-03.csv |
| Catering Chips - 1001442 | Each | $0.00 | $0.00 | Each | yes / CS - 104/CT | CNT-03.csv |
| CLEAN CLEANER ALL PURPOSE/GLASS 3 N | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 2/Gallon | CNT-03.csv |
| CLEAN CLEANER FLOOR LIQUID | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 3/Gallon | CNT-03.csv |
| CLEAN COMET SPRAY W/ BLEACH | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 3/Gallon | CNT-03.csv |
| CLEAN DETERGENT DISH POT/PAN | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 2/Gallon ; CS - 4/Gallon | CNT-03.csv |
| CLEAN FLOOR SPIC SPAN | Each | $0.00 | $0.00 | Each | not shown (ITM-02.csv) | CNT-03.csv |
| CLEAN MOP HEAD | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| CLEAN PAD SCRUB STNLS 1.75OZ | Pack (12 CT) | $0.00 | $0.00 | Pack (12 CT) | not shown (ITM-02.csv) | CNT-03.csv |
| CLEAN SANITIZER HAND | Pack (1.2 Liter) | $0.00 | $0.00 | Pack (1.2 Liter) | yes / CS - 4/Pack (1.2 Liter) | CNT-03.csv |
| CLEAN SANITIZER NO RINSE SINK | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 3/Gallon | CNT-03.csv |
| CLEAN SOAP HAND ANTI BACTRL | Pack (1.2 Liter) | $0.00 | $0.00 | Pack (1.2 Liter) | yes / CS - 4/Pack (1.2 Liter) | CNT-03.csv |
| CLEAN STRIP TEST TAPE QUAT | Roll | $0.00 | $0.00 | Roll | not shown (ITM-02.csv) | CNT-03.csv |
| CLEAN TISSUE TOILET 2PLY WHT | Each | $2.5475 | $0.00 | Each | yes / CS - 12/CT | CNT-03.csv |
| CLEAN VINEGAR WHITE DISTILLED | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| CNTR HOT SAUCE CHOLULA BOTTLE | CS - 24/CT | $0.00 | $0.00 | CS - 24/CT | yes / CS - 24/CT | CNT-03.csv |
| CNTR HOT SAUCE HONEY HABANERO | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| CNTR HOT SAUCE PEACH BOURBON | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| CNTR HOT SAUCE PINEAPPLE | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| CNTR HOT SAUCE RED HOT ORIGINAL | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| CNTR HOT SAUCE SAUCE TABASCO | Each | $0.00 | $0.00 | Each | yes / CS - 12/CT | CNT-03.csv |
| CNTR HOT SAUCE SCORPION | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| CO2 | Each | $0.00 | $0.00 | Each | not shown (ITM-02.csv) | CNT-03.csv |
| COUNT ALL CHIPS | Each | $0.7147 | $0.00 | not shown (ITM-01.csv) | not shown (ITM-02.csv) | CNT-03.csv |
| COUNT ALL COOKIES | Each | $0.4138 | $119.17 | not shown (ITM-01.csv) | not shown (ITM-02.csv) | CNT-03.csv |
| DAIRY CHEDDAR - 1001278 | LB | $3.4242 | $39.87 | LB | yes / CS - 16/Pack (46 CT) | CNT-03.csv |
| DAIRY MONTEREY JACK - 1001273 | LB | $3.2541 | $134.72 | LB | yes / CS - 16/Pack (46 CT) | CNT-03.csv |
| DAIRY PEPPER JACK - 1094114 | CS - 8/Pack (20 oz-wt) | $38.985 | $58.48 | CS - 8/Pack (20 oz-wt) | yes / CS - 16/Pack (20 oz-wt) ; CS - 8/Pack (20 oz-wt) | CNT-03.csv |
| DAIRY PROVOLONE - 1001281 | LB | $3.3426 | $142.71 | LB | yes / CS - 18/Pack (46 CT) | CNT-03.csv |
| DAIRY SHREDDED MOZZARELLA - 1001276 | LB | $0.00 | $0.00 | LB | yes / CS - 12/Pack (1 LB) | CNT-03.csv |
| DAIRY SWISS - 1001283 | LB | $0.00 | $0.00 | LB | yes / CS - 18/Pack (46 CT) ; CS - 6/Pack (24 oz-wt) ; CS - 8/Pack (20 oz-wt) | CNT-03.csv |
| FRYER FRENCH FRIES - 1290664 | LB | $2.003 | $15.02 | LB | yes / CS - 6/Pack (5 LB) | CNT-03.csv |
| FRYER OIL SHORTENING | LB | $1.5089 | $39.61 | LB | yes / CS - 35 LB | CNT-03.csv |
| MEAT BACON - 1001141 | Slice | $0.1596 | $95.76 | Slice | yes / CS - 6/Pack (150 CT) | CNT-03.csv |
| MEAT BRISKET - 1001146 | LB | $11.41 | $442.14 | LB | yes / LB ; LB (Order by Case) | CNT-03.csv |
| MEAT CORNED BEEF - 1001152 | LB | $8.05 | $233.53 | LB | yes / CS - 3/Pack (6 LB) ; CS - 3/Pack (7 LB) ; LB (Order by Case) | CNT-03.csv |
| MEAT HAM - 1001175 | LB | $3.07 | $241.92 | LB | yes / CS - 2/Pack (14 LB) ; CS - 3/Pack (14 LB) ; LB (Order by Case) | CNT-03.csv |
| MEAT MEATBALL - 1001179 | LB | $3.6833 | $82.87 | LB | yes / CS - 2/Pack (5 LB) ; CS - 2/Pack (6 LB) | CNT-03.csv |
| MEAT PASTRAMI - 1001165 | LB | $6.94 | $112.78 | LB | yes / CS - 3/Pack (6 LB) ; LB (Order by Case) | CNT-03.csv |
| MEAT PEPPERONI - 1001181 | LB | $4.4025 | $96.86 | LB | yes / CS - 3/Pack (5.5 LB) ; CS - 6/Pack (2 LB) | CNT-03.csv |
| MEAT ROAST BEEF - 1001167 | LB | $8.34 | $200.41 | LB | yes / CS - 2/Pack (9 LB) ; CS - 3/Pack (4.5 LB) ; CS - 3/Pack (6 LB) ; LB (Order by Case) | CNT-03.csv |
| MEAT SALAMI - 1001183 | LB | $4.1433 | $33.15 | LB | yes / CS - 6/Pack (2 LB) | CNT-03.csv |
| MEAT SLICED CHICKEN BREAST | LB | $4.5335 | $113.34 | LB | yes / CS - 2/Pack (5 LB) ; CS - 4/Pack (5 LB) | CNT-03.csv |
| MEAT STEAK | LB | $8.07 | $290.52 | LB | yes / CS - 4/Pack (3 LB) ; CS - 7/Pack (3 LB) ; CS - 7/Pack (4.5 LB) ; CS - 8/Pack (3 LB) ; LB (Order by Case) | CNT-03.csv |
| MEAT TUNA - 1001187 | CS - 24/Pack (170 Gram) | $40.5558 | $34.07 | CS - 24/Pack (170 Gram) | yes / CS - 12/Pack (11 oz-wt) | CNT-03.csv |
| MEAT TURKEY - 1001190 | LB | $3.45 | $399.30 | LB | yes / CS - 2/Pack (9.75 LB) ; LB (Order by Case) | CNT-03.csv |
| NON REV A1 STEAK BTL | CS - 12/CT | $0.00 | $0.00 | CS - 12/CT | yes / CS - 12/CT | CNT-03.csv |
| NON REV BALSAMIC VINAIGARETTE - 1001297 | Gallon | $14.45 | $14.45 | Gallon | yes / CS - 4/Gallon ; Case - 16/Pack (32 oz-fl) ; Gallon | CNT-03.csv |
| NON REV BANANA PEPPER - 1001346 | Gallon | $9.64 | $14.46 | Gallon | yes / CS - 12/Pack (2.5 LB) ; CS - 4/Gallon ; Gallon | CNT-03.csv |
| NON REV BBQ - 1001377 | Gallon | $14.11 | $7.06 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| NON REV BLACK OLIVE - 1001340 | Pack (33 oz-wt) | $9.90 | $89.10 | Pack (33 oz-wt) | yes / CS - 10/Pack (33 oz-wt) ; Pack (33 oz-wt) | CNT-03.csv |
| NON REV BUTTER - 1197472 | Gallon | $20.895 | $31.34 | Gallon | yes / CS - 2/Gallon | CNT-03.csv |
| NON REV CAJUN SEASONING - 1094161 | LB | $6.0125 | $24.05 | LB | yes / Pack (4 LB) | CNT-03.csv |
| NON REV Garlic Chips - 1340968 | OZ-wt | $0.00 | $0.00 | OZ-wt | yes / CS - 6/Pack (10 oz-wt) | CNT-03.csv |
| NON REV GARLIC SEASONING - 1197461 | LB | $5.81 | $23.24 | LB | yes / CS - 4 LB | CNT-03.csv |
| NON REV HONEY MUSTARD - 1004033 | LB | $0.00 | $0.00 | LB | yes / CS - 4/Gallon ; Gallon | CNT-03.csv |
| NON REV ITALIAN DRESSING - 1001304 | Gallon | $12.6175 | $25.24 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| NON REV ITALIAN LT - 1001301 | Gallon | $0.00 | $0.00 | Gallon | yes / Gallon | CNT-03.csv |
| NON REV ITALIAN SEASONING - 1001396 | Pack (2.2 oz-wt) | $0.00 | $0.00 | Pack (2.2 oz-wt) | yes / CS - 20/Pack (2.2 oz-wt) | CNT-03.csv |
| NON REV JALAPENO - 1001352 | Gallon | $8.3575 | $20.89 | Gallon | yes / CS - 12/Pack (2.5 LB) ; CS - 4/Gallon ; Gallon | CNT-03.csv |
| NON REV JAMAICAN SEASONING - 1094189 | LB | $0.00 | $0.00 | LB | yes / Pack (4 LB) | CNT-03.csv |
| NON REV KETCHUP PACKET FCY | CS - 200/CT | $12.20 | $9.15 | CS - 200/CT | yes / CS - 1000/CT ; CS - 200/CT | CNT-03.csv |
| NON REV LTO Caramelized Onions - 1052395 | Pack (2 LB) | $0.00 | $0.00 | Pack (2 LB) | yes / CS - 12/Pack (2 LB) | CNT-03.csv |
| NON REV MAYO - 1001314 | Gallon | $11.615 | $52.27 | Gallon | yes / CS - 4/Gallon ; Gallon | CNT-03.csv |
| NON REV MAYO PACKET - 1001319 | CS - 200/CT | $18.924 | $23.66 | CS - 200/CT | yes / CS - 200/CT ; CS - 500/CT | CNT-03.csv |
| NON REV OIL CANOLA OLIVE BLEND - 1001331 | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Pack (3 Ltr) ; CS - 6/Gallon ; Gallon | CNT-03.csv |
| NON REV ONION GARLIC FRESNO MARINATED - 1340985 | OZ-wt | $0.00 | $0.00 | OZ-wt | not shown (ITM-02.csv) | CNT-03.csv |
| NON REV OYSTER CRACKER - 1058308 | CS - 150/CT | $0.00 | $0.00 | CS - 150/CT | yes / CS - 150/CT | CNT-03.csv |
| NON REV PEPPER PACKET | Pack (1000 CT) | $0.00 | $0.00 | Pack (1000 CT) | yes / CS - 3/Pack (1000 CT) ; CS - 6/Pack (1000 CT) | CNT-03.csv |
| NON REV PICKLE PLANK SPICY - 1341051 | Each | $0.00 | $0.00 | Each | yes / Pack (2 Gallon) | CNT-03.csv |
| NON REV PICKLE SPEAR - 1001364 | BKT (5 Gallon) | $31.80 | $95.40 | BKT (5 Gallon) | yes / BKT (5 Gallon) | CNT-03.csv |
| NON REV PKT CHOLULA | CS - 200/CT | $0.00 | $0.00 | CS - 200/CT | yes / CS - 200/CT | CNT-03.csv |
| NON REV PKT SAUCE CAPTAIN SORENSEN | CS - 200/CT | $0.00 | $0.00 | CS - 200/CT | yes / CS - 200/CT | CNT-03.csv |
| NON REV PKT SAUCE LOUISIANA | Each | $0.00 | $0.00 | Each | yes / CS - 200/CT | CNT-03.csv |
| NON REV RANCH - 1001309 | Gallon | $12.5525 | $25.11 | Gallon | yes / CS - 12/Pack (24 oz-wt) ; CS - 4/Gallon ; Gallon | CNT-03.csv |
| NON REV RELISH - 1001366 | Pack (64 oz-wt) | $6.53 | $359.80 | Pack (64 oz-wt) | yes / CS - 6/Pack (64 oz-wt) ; Gallon | CNT-03.csv |
| NON REV RICE KRISPIE | CS - 600/CT | $0.00 | $0.00 | CS - 600/CT | yes / CS - 600/CT | CNT-03.csv |
| NON REV SALT PACKET | CS - 6/Pack (1000 CT) | $0.00 | $0.00 | CS - 6/Pack (1000 CT) | yes / CS - 3/Pack (1000 CT) ; CS - 6/Pack (1000 CT) | CNT-03.csv |
| NON REV SAUCE CAPTAIN SORENSEN BTL - 1001758 | Pack (16 oz-wt) | $3.9342 | $0.00 | Pack (16 oz-wt) | yes / CS - 24/Pack (16 oz-wt) | CNT-03.csv |
| NON REV SAUCE CARROT CHIPOTLE | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| NON REV SAUCE FIRE BACKDRAFT | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| NON REV SAUCE GARLIC AIOLI | Gallon | $0.00 | $0.00 | Gallon | yes / Gallon | CNT-03.csv |
| NON REV SAUCE GATOR | Pack (12 oz-wt) | $0.00 | $0.00 | Pack (12 oz-wt) | yes / CS - 12/Pack (12 oz-wt) | CNT-03.csv |
| NON REV SAUCE GREEN JALAPENO SAUCE | Pack (4 oz-wt) | $0.00 | $0.00 | Pack (4 oz-wt) | not shown (ITM-02.csv) | CNT-03.csv |
| NON REV SAUCE HOT TEXAS PETE | CS - 200/CT | $0.00 | $0.00 | CS - 200/CT | not shown (ITM-02.csv) | CNT-03.csv |
| NON REV SAUCE MARINARA - 1001384 | Pack (105 oz-wt) | $4.2683 | $21.34 | Pack (105 oz-wt) | yes / CS - 6/Pack (105 oz-wt) | CNT-03.csv |
| NON REV SAUCE MUSTARD SWEET FHS - 1050473 | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| NON REV SEASONING CARMELIZED VEGETABLE - 1138068 | LB | $0.00 | $0.00 | LB | yes / CS - 5 LB | CNT-03.csv |
| NON REV SPICE RED PEPPER FLAKES - 1002638 | Pack (1 Gram) | $0.00 | $0.00 | Pack (1 Gram) | yes / CS - 6/Pack (8.5 oz-wt) ; OZ-wt ; Pack (13 oz-wt) | CNT-03.csv |
| NON REV SPICY DELI MUSTARD - 1001323 | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Gallon ; CS - 6/Pack (48 oz-wt) | CNT-03.csv |
| NON REV SPICY DELI MUSTARD PACKET - 1001326 | CS - 500/CT | $38.22 | $38.22 | CS - 500/CT | yes / CS - 500/CT | CNT-03.csv |
| NON REV SUGAR GRANULATED EXTRA FINE | Pack (3.1 LB) | $2.8348 | $51.03 | Pack (3.1 LB) | yes / CS - 12/Pack (3 LB) ; CS - 12/Pack (3.1 LB) | CNT-03.csv |
| NON REV SUGAR PACKET | CS - 3000/CT | $0.00 | $0.00 | CS - 3000/CT | yes / CS - 2000/CT ; CS - 3000/CT | CNT-03.csv |
| NON REV SUGAR SUB BLUE PACKET | CS - 2000/CT | $0.00 | $0.00 | CS - 2000/CT | yes / CS - 2000/CT | CNT-03.csv |
| NON REV SUGAR SUB YELLOW PACKET | CS - 2000/CT | $0.00 | $0.00 | CS - 2000/CT | yes / CS - 2000/CT | CNT-03.csv |
| NON REV VINEGAR RED WINE PLAS - 1001410 | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 4/Gallon | CNT-03.csv |
| NON REV YELLOW MUSTARD - 1001321 | Gallon | $0.00 | $0.00 | Gallon | yes / CS - 12/CT ; CS - 4/Gallon ; CS - 6/Pack (104 oz-wt) ; Gallon | CNT-03.csv |
| P-Cajun Mayo 1oz - 1271478 | OZ-wt | $0.1169 | $1.87 | not shown (ITM-01.csv) | not shown (ITM-02.csv) | CNT-03.csv |
| P-Garlic Fresno Marinated Onion 1 oz | OZ-wt | $0.00 | $0.00 | not shown (ITM-01.csv) | not shown (ITM-02.csv) | CNT-03.csv |
| PAPER FD BAG PAPER BRN 1/8 TALL MEDIUM | CS - 500/CT | $65.16 | $16.29 | CS - 500/CT | yes / CS - 500/CT | CNT-03.csv |
| PAPER FD BAG PAPER BRN 8# KRFT SMALL | CS - 4/Pack (500 CT) | $75.26 | $22.58 | CS - 4/Pack (500 CT) | yes / CS - 4/Pack (500 CT) ; Pack (500 CT) | CNT-03.csv |
| PAPER FD BAG PAPER BRN 13.5X16.375 LRG | CS - 250/CT | $53.74 | $13.44 | CS - 250/CT | yes / CS - 250/CT ; CS - 400/CT | CNT-03.csv |
| PAPER FD BAG PAPER BRN HNDL CATERING | CS - 200/CT | $84.48 | $316.80 | CS - 200/CT | yes / CS - 200/CT ; CS - 250/CT | CNT-03.csv |
| PAPER FD BOX CARRYOUT TUCK TP 9X5X4 NEW | Pack (250 CT) | $70.38 | $140.76 | Pack (250 CT) | yes / CS - 250/CT | CNT-03.csv |
| PAPER FD BOX CORR CATERING W/ INSERT | Pack (35 CT) | $94.57 | $102.67 | Pack (35 CT) | yes / Pack (35 CT) | CNT-03.csv |
| PAPER FD CHILI BOWL | Pack (50 CT) | $0.00 | $0.00 | Pack (50 CT) | yes / CS - 20/Pack (50 CT) | CNT-03.csv |
| PAPER FD CONTAINER FIBER BAGASS 6X6 | Pack (125 CT) | $0.00 | $0.00 | Pack (125 CT) | yes / CS - 4/Pack (125 CT) ; CS - 8/Pack (50 CT) | CNT-03.csv |
| PAPER FD CONTAINER FIBER BAGASS 9.85 | Pack (100 CT) | $14.43 | $43.29 | Pack (100 CT) | yes / CS - 3/Pack (100 CT) ; CS - 6/Pack (50 CT) | CNT-03.csv |
| PAPER FD CONTAINER FIBER BAGASS 13.35 | Pack (100 CT) | $18.5333 | $55.60 | Pack (100 CT) | yes / CS - 3/Pack (100 CT) ; CS - 6/Pack (50 CT) | CNT-03.csv |
| PAPER FD CUP PAPER 12OZ | Pack (100 CT) | $0.00 | $0.00 | Pack (100 CT) | yes / CS - 20/Pack (100 CT) | CNT-03.csv |
| PAPER FD CUP PAPER 22OZ | Pack (50 CT) | $2.9263 | $0.00 | Pack (50 CT) | yes / CS - 24/Pack (50 CT) | CNT-03.csv |
| PAPER FD CUP PAPER 32OZ | Pack (40 CT) | $0.00 | $0.00 | Pack (40 CT) | yes / CS - 15/Pack (40 CT) | CNT-03.csv |
| PAPER FD CUP PAPER SOUP RND WHT DFR 6OZ - 1059333 | Each | $0.00 | $0.00 | Each | yes / CS - 1000/CT | CNT-03.csv |
| PAPER FD CUP PRTN SOUFFLE 1oz - 1001699 | Each | $0.0105 | $19.69 | Each | yes / CS - 10/Pack (250 CT) ; CS - 2500/CT | CNT-03.csv |
| PAPER FD CUP PRTN SOUFFLE 2-3 OZ | Pack (200 CT) | $0.00 | $0.00 | Pack (200 CT) | yes / CS - 2500/CT | CNT-03.csv |
| PAPER FD FILM PVC ROLL 12x2000 CLING | Each | $16.71 | $33.42 | Each | yes / Each | CNT-03.csv |
| PAPER FD FILM PVC ROLL 18X2000 CLING | Each | $0.00 | $0.00 | Each | yes / Each | CNT-03.csv |
| PAPER FD FOIL ALMN SHEET LARGE - 1001654 | Pack (500 CT) | $0.00 | $0.00 | Pack (500 CT) | yes / CS - 6/Pack (500 CT) ; Pack (500 CT) | CNT-03.csv |
| PAPER FD FOIL ALMN SHEET SMALL - 1001657 | Pack (500 CT) | $0.00 | $0.00 | Pack (500 CT) | yes / CS - 6/Pack (500 CT) | CNT-03.csv |
| PAPER FD FORK CUTLERY WRPD - 1068074 | CS - 1000/CT | $0.00 | $0.00 | CS - 1000/CT | yes / CS - 600/CT | CNT-03.csv |
| PAPER FD JUG PLASTIC GALLON EMPTY W/LID | Each | $1.36 | $24.48 | Each | yes / CS - 24/CT | CNT-03.csv |
| PAPER FD KNIFE WRAPPED | Each | $0.00 | $0.00 | Each | yes / CS - 600/CT | CNT-03.csv |
| PAPER FD LID PLAS FOR 12-22 OZ CUP | Pack (100 CT) | $0.00 | $0.00 | Pack (100 CT) | yes / CS - 24/Pack (100 CT) | CNT-03.csv |
| PAPER FD LID PLAS FOR 32 OZ CUP | Each | $0.00 | $0.00 | Each | yes / CS - 10/Pack (100 CT) | CNT-03.csv |
| PAPER FD LID PRTN SOUFFLE 1 OZ - 1010700 | Pack (100 CT) | $0.7728 | $19.32 | Pack (100 CT) | yes / CS - 25/Pack (100 CT) | CNT-03.csv |
| PAPER FD LID PRTN SOUFFLE 2.5 OZ | CS - 20/Pack (125 CT) | $0.00 | $0.00 | CS - 20/Pack (125 CT) | yes / CS - 2500/CT | CNT-03.csv |
| PAPER FD LID SOUP PLAS CLR F/DFR10 & DFT16 - 1044642 | Pack (50 CT) | $0.00 | $0.00 | Pack (50 CT) | yes / CS - 20/Pack (50 CT) | CNT-03.csv |
| PAPER FD LINER BAG FOOD 1/4 & 1/3 PAN | CS - 250/CT | $0.00 | $0.00 | CS - 250/CT | not shown (ITM-02.csv) | CNT-03.csv |
| PAPER FD LINER BAG FOOD 1/6 PAN | CS - 250/CT | $12.53 | $0.00 | CS - 250/CT | yes / CS - 100/CT ; CS - 250/CT ; Pack (100 CT) | CNT-03.csv |
| PAPER FD LINER PAN SCRUB SAVER COLD 1/3 & 1/4 | Each | $0.1134 | $0.00 | Each | yes / CS - 100/CT ; CS - 250/CT ; Pack (100 CT) | CNT-03.csv |
| PAPER FD LINER PLAS TEA URN | CS - 100/CT | $87.30 | $130.95 | CS - 100/CT | yes / CS - 100/CT ; CS - 150/CT | CNT-03.csv |
| PAPER FD LRG SALAD BOWL | CS - 300/CT | $39.95 | $19.98 | CS - 300/CT | yes / CS - 300/CT ; Case - 2/Pack (150 CT) | CNT-03.csv |
| PAPER FD NAPKINS FOR DSPNSR 2PFLD - 1001710 | Pack (250 CT) | $1.2025 | $36.08 | Pack (250 CT) | yes / CS - 12/Pack (500 CT) ; CS - 24/Pack (250 CT) | CNT-03.csv |
| PAPER FD PAPER WAX SHEET 15X15 | CS - 2/Pack (500 CT) | $0.00 | $0.00 | CS - 2/Pack (500 CT) | yes / CS - 2/Pack (500 CT) | CNT-03.csv |
| PAPER FD PICK WOOD BAMBOO CLUB FRILL | Pack (1000 CT) | $0.00 | $0.00 | Pack (1000 CT) | yes / CS - 10/Pack (1000 CT) | CNT-03.csv |
| PAPER FD SM SALAD BOWL | CS - 300/CT | $0.00 | $0.00 | CS - 300/CT | yes / CS - 300/CT ; CS - 500/CT | CNT-03.csv |
| PAPER FD SPOON SOUP WRAPPED - 1068078 | CS - 600/CT | $0.00 | $0.00 | CS - 600/CT | yes / CS - 600/CT | CNT-03.csv |
| PAPER FD STRAW PLAS JMBO RED WRPD 9.5 | Pack (500 CT) | $0.00 | $0.00 | Pack (500 CT) | yes / CS - 4/Pack (300 CT) ; CS - 4/Pack (500 CT) ; CS - 6/Pack (1000 CT) | CNT-03.csv |
| PAPER FD STRAW PLAS JMBO WRPD RED 7.75 | Pack (500 CT) | $0.00 | $0.00 | Pack (500 CT) | yes / CS - 12/Pack (500 CT) ; CS - 4/Pack (500 CT) ; CS - 6/Pack (200 CT) | CNT-03.csv |
| PAPER FD TONG PLAS BLK PP 9 SERVING | CS - 100/CT | $37.4167 | $17.96 | CS - 100/CT | yes / CS - 36/CT | CNT-03.csv |
| PAPER FD TRAY CARRIER 4 CUP 8-44 OZ | Pack (75 CT) | $0.00 | $0.00 | Pack (75 CT) | yes / CS - 100/CT ; CS - 200/CT ; CS - 250/CT ; CS - 300/CT ; CS - 4/Pack (75 CT) | CNT-03.csv |
| PAPER FD WRAP DELI INTRFLD 12X10.75 | Pack (500 CT) | $7.3267 | $43.96 | Pack (500 CT) | yes / CS - 12/Pack (500 CT) ; CS - 2000/CT | CNT-03.csv |
| PAPER FD WRAP DRY WAX STEAMER 12X10.75 | Pack (500 CT) | $7.8675 | $86.54 | Pack (500 CT) | yes / CS - 12/Pack (500 CT) ; CS - 6000/CT | CNT-03.csv |
| PAPER NF GLOVE VINYL POWD FREE LG | Pack (100 CT) | $0.00 | $0.00 | Pack (100 CT) | yes / CS - 10/Pack (100 CT) ; CS - 5/Pack (200 CT) | CNT-03.csv |
| PAPER NF GLOVE VINYL POWD FREE MED | Pack (100 CT) | $0.00 | $0.00 | Pack (100 CT) | yes / CS - 10/Pack (100 CT) ; CS - 5/Pack (200 CT) | CNT-03.csv |
| PAPER NF GLOVE VINYL PWDR FREE XL | Pack (100 CT) | $2.411 | $0.00 | Pack (100 CT) | yes / CS - 10/Pack (100 CT) | CNT-03.csv |
| PAPER NF GLOVE VINYL PWDR FREE XXL | Pack (100 CT) | $0.00 | $0.00 | Pack (100 CT) | yes / CS - 10/Pack (100 CT) | CNT-03.csv |
| PAPER NF INTERFOLD DISPENSER NAPKIN | CS - 36/Pack (200 CT) | $0.00 | $0.00 | CS - 36/Pack (200 CT) | not shown (ITM-02.csv) | CNT-03.csv |
| PAPER NF TOWEL ROLL 7.875 NAT | Each | $4.1783 | $0.00 | Each | yes / CS - 6/CT | CNT-03.csv |
| PROD CUCUMBERS - 1001207 | CS - 3 LB | $18.4229 | $31.63 | CS - 3 LB | yes / Pack (6 CT) | CNT-03.csv |
| PROD LEMONS - 1001211 | Dozen | $8.226 | $16.45 | Dozen | yes / CS - 10 LB | CNT-03.csv |
| PROD LETTUCE 1/8" SHREDDED - 1001214 | LB | $1.5685 | $62.74 | LB | yes / CS - 4/Pack (5 LB) | CNT-03.csv |
| PROD LIMES | CS - 12/CT | $15.3788 | $3.84 | CS - 12/CT | yes / Pack (2 LB) | CNT-03.csv |
| PROD MUSHROOM SLICED SEASND IN BRNE - 1001221 | Pack (5.89 LB) | $10.9717 | $27.43 | Pack (5.89 LB) | yes / CS - 4/Pack (4.17 LB) ; CS - 6/Pack (5.89 LB) | CNT-03.csv |
| PROD ONIONS YELLOW JUMBO - 1001228 | LB | $0.7034 | $3.52 | LB | yes / CS - 50 LB | CNT-03.csv |
| PROD PEPPERS GREEN - 1001232 | LB | $1.2048 | $18.07 | LB | yes / CS - 25 LB | CNT-03.csv |
| PROD ROMAINE CHOPPED - 1001239 | LB | $3.19 | $9.57 | LB | yes / CS - 6/Pack (2 LB) | CNT-03.csv |
| PROD TOMATOES - 1001243 | CS - 25 LB | $37.12 | $556.80 | CS - 25 LB | yes / CS - 25 LB | CNT-03.csv |
| SOUP CHILI - 1001268 | LB | $2.9935 | $119.74 | LB | yes / CS - 4/Pack (5 LB) | CNT-03.csv |
| SOUP MACARONI AND CHS | Pack (8 oz-wt) | $0.00 | $0.00 | Pack (8 oz-wt) | yes / CS - 36/Pack (8 oz-wt) | CNT-03.csv |
| SOUP POTATO LOADED SOUP | CS - 12/Pack (3 LB) | $69.42 | $40.49 | CS - 12/Pack (3 LB) | yes / CS - 12/Pack (3 LB) | CNT-03.csv |
| ZZZ BREAD ROLL Breads SNGL SLI GLU FREE | Each | $0.00 | $0.00 | Each | yes / CS - 16/CT ; CS - 6/CT | CNT-03.csv |
| ZZZPAPER FD PLATE ROUND 9IN | CS - 4/Pack (125 CT) | $0.00 | $0.00 | CS - 4/Pack (125 CT) | not shown (ITM-02.csv) | CNT-03.csv |
| ZZZPAPER NF LINER PAN SCRUB SAVER 1/6TH | CS - 250/CT | $0.00 | $0.00 | CS - 250/CT | not shown (ITM-02.csv) | CNT-03.csv |

## Totals

- Item table data rows: **207**. Unique Name values: **207**.
- Sum of extended values (CNT-03.csv `Current $ Total`, parsed `$` and commas): **$7,461.73**.
- Approved count list total (CNT-01.txt): **$7,461.73**.
- Delta vs $7,461.73: **$0.00**.
- CNT-04.txt COUNT ENTRY footer showed **$7,461.69** (4 cents under the Item Details / list total). The table uses CNT-03.csv, which matches $7,461.73.

## Problem list

Each template item is in at most one bucket, in this order: $0 cost, then no Cheney vendor item linked, then Cheney unit ≠ count unit with no clear conversion. Conversion evidence is ITM-04.csv unit definitions (equivalent qty / equivalent UofM chain) plus the four opened item pages ITM-05..ITM-12. If Cheney unit ≠ count unit but those files show a usable chain (including a shared equivalent such as Each or Gallon), it is not listed. Measurement Conversions was OFF on all four opened items; case size still converted through the unit definition (ITM-03-missing.txt, ITM-05..ITM-12.txt).

### $0 cost

| Name | Capture | Who can fix | Note |
|---|---|---|---|
| BEV APPLE JUICE ALL | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV BOTTLE SODA | CNT-03.csv | franchise | qty 70.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV BOTTLED WATER | CNT-03.csv | franchise | qty 30.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV CCF AHA BLUEBERRY POM | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV CCF CAFFEINE FREE DIET COKE | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV CCF FRUIT PUNCH | CNT-03.csv | franchise | qty 1.00 on 10/04; count-line unit cost $0.00; Avg Cost $19.4900 (ITM-01.csv). |
| BEV CCF GRAPE FLVR | CNT-03.csv | franchise | qty 1.34 on 10/04; count-line unit cost $0.00; Avg Cost $19.4900 (ITM-01.csv). |
| BEV CCF LIME FLVR | CNT-03.csv | franchise | qty 1.11 on 10/04; count-line unit cost $0.00; Avg Cost $19.4900 (ITM-01.csv). |
| BEV CCF PINEAPPLE CTRG | CNT-03.csv | franchise | qty 1.45 on 10/04; count-line unit cost $0.00; Avg Cost $1.0800 (ITM-01.csv). |
| BEV CHOCOLATE MILK | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV MILK GALLON | CNT-03.csv | franchise | qty 18.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV MILK SS | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV POWERADE | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| BEV SYRUP LIQUID SWTNR NON NUTRITV BIB | CNT-03.csv | franchise | qty 0.50 on 10/04; count-line unit cost $0.00; Avg Cost $119.1600 (ITM-01.csv). |
| BEV TEA BAG ICED PK | CNT-03.csv | franchise | qty 81.60 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| Catering Chips - 1001442 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN CLEANER ALL PURPOSE/GLASS 3 N | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN CLEANER FLOOR LIQUID | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN COMET SPRAY W/ BLEACH | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN DETERGENT DISH POT/PAN | CNT-03.csv | franchise | qty 0.00 on 10/04; count-line unit cost $0.00; Avg Cost $33.2700 (ITM-01.csv). |
| CLEAN FLOOR SPIC SPAN | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN MOP HEAD | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN PAD SCRUB STNLS 1.75OZ | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN SANITIZER HAND | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN SANITIZER NO RINSE SINK | CNT-03.csv | franchise | qty 0.00 on 10/04; count-line unit cost $0.00; Avg Cost $34.4900 (ITM-01.csv). |
| CLEAN SOAP HAND ANTI BACTRL | CNT-03.csv | franchise | qty 0.00 on 10/04; count-line unit cost $0.00; Avg Cost $9.6400 (ITM-01.csv). |
| CLEAN STRIP TEST TAPE QUAT | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CLEAN VINEGAR WHITE DISTILLED | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE CHOLULA BOTTLE | CNT-03.csv | franchise | qty 0.10 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE HONEY HABANERO | CNT-03.csv | franchise | qty 2.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE PEACH BOURBON | CNT-03.csv | franchise | qty 10.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE PINEAPPLE | CNT-03.csv | franchise | qty 2.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE RED HOT ORIGINAL | CNT-03.csv | franchise | qty 2.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE SAUCE TABASCO | CNT-03.csv | franchise | qty 2.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| CNTR HOT SAUCE SCORPION | CNT-03.csv | franchise | qty 4.00 on 10/04; count-line unit cost $0.00; Avg Cost $4.9500 (ITM-01.csv). |
| CO2 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| DAIRY SHREDDED MOZZARELLA - 1001276 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| DAIRY SWISS - 1001283 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV A1 STEAK BTL | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV Garlic Chips - 1340968 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV HONEY MUSTARD - 1004033 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV ITALIAN LT - 1001301 | CNT-03.csv | franchise | qty 1.50 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV ITALIAN SEASONING - 1001396 | CNT-03.csv | franchise | qty 4.50 on 10/04; count-line unit cost $0.00; Avg Cost $1.0500 (ITM-01.csv). |
| NON REV JAMAICAN SEASONING - 1094189 | CNT-03.csv | franchise | qty 2.12 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV LTO Caramelized Onions - 1052395 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV OIL CANOLA OLIVE BLEND - 1001331 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV ONION GARLIC FRESNO MARINATED - 1340985 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV OYSTER CRACKER - 1058308 | CNT-03.csv | franchise | qty 0.25 on 10/04; count-line unit cost $0.00; Avg Cost $25.5900 (ITM-01.csv). |
| NON REV PEPPER PACKET | CNT-03.csv | franchise | qty 0.75 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV PICKLE PLANK SPICY - 1341051 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV PKT CHOLULA | CNT-03.csv | franchise | qty 0.01 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV PKT SAUCE CAPTAIN SORENSEN | CNT-03.csv | franchise | qty 0.50 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV PKT SAUCE LOUISIANA | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV RICE KRISPIE | CNT-03.csv | franchise | qty 1.28 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SALT PACKET | CNT-03.csv | franchise | qty 0.13 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE CARROT CHIPOTLE | CNT-03.csv | franchise | qty 7.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE FIRE BACKDRAFT | CNT-03.csv | franchise | qty 8.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE GARLIC AIOLI | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE GATOR | CNT-03.csv | franchise | qty 3.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE GREEN JALAPENO SAUCE | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE HOT TEXAS PETE | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SAUCE MUSTARD SWEET FHS - 1050473 | CNT-03.csv | franchise | qty 1.50 on 10/04; count-line unit cost $0.00; Avg Cost $15.7300 (ITM-01.csv). |
| NON REV SEASONING CARMELIZED VEGETABLE - 1138068 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SPICE RED PEPPER FLAKES - 1002638 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SPICY DELI MUSTARD - 1001323 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SUGAR PACKET | CNT-03.csv | franchise | qty 0.75 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SUGAR SUB BLUE PACKET | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV SUGAR SUB YELLOW PACKET | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| NON REV VINEGAR RED WINE PLAS - 1001410 | CNT-03.csv | franchise | qty 0.75 on 10/04; count-line unit cost $0.00; Avg Cost $9.9000 (ITM-01.csv). |
| NON REV YELLOW MUSTARD - 1001321 | CNT-03.csv | franchise | qty 0.15 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| P-Garlic Fresno Marinated Onion 1 oz | CNT-03.csv | R365 support | qty 0.00 on 10/04; not on ITM-01.csv (recipe); Added by R365 DSS User (TPL-02.csv). |
| PAPER FD CHILI BOWL | CNT-03.csv | franchise | qty 10.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD CONTAINER FIBER BAGASS 6X6 | CNT-03.csv | franchise | qty 4.40 on 10/04; count-line unit cost $0.00; Avg Cost $13.0900 (ITM-01.csv). |
| PAPER FD CUP PAPER 12OZ | CNT-03.csv | franchise | qty 17.00 on 10/04; count-line unit cost $0.00; Avg Cost $4.9500 (ITM-01.csv). |
| PAPER FD CUP PAPER 32OZ | CNT-03.csv | franchise | qty 0.00 on 10/04; count-line unit cost $0.00; Avg Cost $4.1300 (ITM-01.csv). |
| PAPER FD CUP PAPER SOUP RND WHT DFR 6OZ - 1059333 | CNT-03.csv | franchise | qty 1,100.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD CUP PRTN SOUFFLE 2-3 OZ | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD FILM PVC ROLL 18X2000 CLING | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD FOIL ALMN SHEET LARGE - 1001654 | CNT-03.csv | franchise | qty 6.00 on 10/04; count-line unit cost $0.00; Avg Cost $4.2400 (ITM-01.csv). |
| PAPER FD FOIL ALMN SHEET SMALL - 1001657 | CNT-03.csv | franchise | qty 3.50 on 10/04; count-line unit cost $0.00; Avg Cost $2.9700 (ITM-01.csv). |
| PAPER FD FORK CUTLERY WRPD - 1068074 | CNT-03.csv | franchise | qty 0.15 on 10/04; count-line unit cost $0.00; Avg Cost $27.7000 (ITM-01.csv). |
| PAPER FD KNIFE WRAPPED | CNT-03.csv | franchise | qty 150.00 on 10/04; count-line unit cost $0.00; Avg Cost $0.0500 (ITM-01.csv). |
| PAPER FD LID PLAS FOR 12-22 OZ CUP | CNT-03.csv | franchise | qty 10.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD LID PLAS FOR 32 OZ CUP | CNT-03.csv | franchise | qty 0.75 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD LID PRTN SOUFFLE 2.5 OZ | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD LID SOUP PLAS CLR F/DFR10 & DFT16 - 1044642 | CNT-03.csv | franchise | qty 15.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD LINER BAG FOOD 1/4 & 1/3 PAN | CNT-03.csv | franchise | qty 1.00 on 10/04; count-line unit cost $0.00; Avg Cost $5.6000 (ITM-01.csv). |
| PAPER FD PAPER WAX SHEET 15X15 | CNT-03.csv | franchise | qty 0.75 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD PICK WOOD BAMBOO CLUB FRILL | CNT-03.csv | franchise | qty 5.00 on 10/04; count-line unit cost $0.00; Avg Cost $0.8400 (ITM-01.csv). |
| PAPER FD SM SALAD BOWL | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD SPOON SOUP WRAPPED - 1068078 | CNT-03.csv | franchise | qty 0.50 on 10/04; count-line unit cost $0.00; Avg Cost $27.7000 (ITM-01.csv). |
| PAPER FD STRAW PLAS JMBO RED WRPD 9.5 | CNT-03.csv | franchise | qty 3.00 on 10/04; count-line unit cost $0.00; Avg Cost $4.1400 (ITM-01.csv). |
| PAPER FD STRAW PLAS JMBO WRPD RED 7.75 | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER FD TRAY CARRIER 4 CUP 8-44 OZ | CNT-03.csv | franchise | qty 1.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER NF GLOVE VINYL POWD FREE LG | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER NF GLOVE VINYL POWD FREE MED | CNT-03.csv | franchise | qty 0.00 on 10/04; count-line unit cost $0.00; Avg Cost $2.5900 (ITM-01.csv). |
| PAPER NF GLOVE VINYL PWDR FREE XXL | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| PAPER NF INTERFOLD DISPENSER NAPKIN | CNT-03.csv | franchise | qty 0.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| SOUP MACARONI AND CHS | CNT-03.csv | franchise | qty 18.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| ZZZ BREAD ROLL Breads SNGL SLI GLU FREE | CNT-03.csv | franchise | qty 28.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| ZZZPAPER FD PLATE ROUND 9IN | CNT-03.csv | franchise | qty 0.45 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |
| ZZZPAPER NF LINER PAN SCRUB SAVER 1/6TH | CNT-03.csv | franchise | qty 2.00 on 10/04; Avg Cost $0.0000 (ITM-01.csv). |

_102 items. Count-line `Current $ Cost` is 0 (CNT-03.csv). Includes quantity 0 and quantity > 0. Does not include quantity 0 with a non-zero unit cost._

### No Cheney vendor item linked

| Name | Capture | Who can fix | Note |
|---|---|---|---|
| COUNT ALL CHIPS | ITM-02.csv | R365 support | template name not in ITM-02.csv (Cheney Brothers vendor-item export, 819 rows). Item type Recipe (TPL-02.csv). |
| COUNT ALL COOKIES | ITM-02.csv | R365 support | template name not in ITM-02.csv (Cheney Brothers vendor-item export, 819 rows). Item type Recipe (TPL-02.csv). |
| P-Cajun Mayo 1oz - 1271478 | ITM-02.csv | R365 support | template name not in ITM-02.csv (Cheney Brothers vendor-item export, 819 rows). Item type Recipe (TPL-02.csv). |

_3 items remaining after $0 cost. Cheney cell is `not shown (ITM-02.csv)`. No template name appears in ITM-02.csv with an empty Cheney link (`no`)._

### Cheney unit ≠ count unit with no clear conversion

| Name | Capture | Who can fix | Note |
|---|---|---|---|
| BREAD WHITE BREAD | ITM-03-unitdiff.csv | franchise | count unit Slice (CNT-03.csv); Cheney PurchasingUofM CS - 6/Pack (25 oz-wt) (ITM-02.csv). ITM-04.csv: count Slice = 1.0000 Each → Each; Cheney CS - 6/Pack (25 oz-wt) = 150.0000 OZ-wt → OZ-wt. Chains do not meet (weight vs each/volume, or each vs volume). |
| DAIRY CHEDDAR - 1001278 | ITM-02.csv | franchise | count unit LB (CNT-03.csv); Cheney PurchasingUofM CS - 16/Pack (46 CT) (ITM-02.csv). ITM-04.csv: count LB = 16.0000 OZ-wt → OZ-wt; Cheney CS - 16/Pack (46 CT) = 736.0000 Each → Each. Chains do not meet (weight vs each/volume, or each vs volume). |
| DAIRY MONTEREY JACK - 1001273 | ITM-02.csv | franchise | count unit LB (CNT-03.csv); Cheney PurchasingUofM CS - 16/Pack (46 CT) (ITM-02.csv). ITM-04.csv: count LB = 16.0000 OZ-wt → OZ-wt; Cheney CS - 16/Pack (46 CT) = 736.0000 Each → Each. Chains do not meet (weight vs each/volume, or each vs volume). |
| DAIRY PROVOLONE - 1001281 | ITM-02.csv | franchise | count unit LB (CNT-03.csv); Cheney PurchasingUofM CS - 18/Pack (46 CT) (ITM-02.csv). ITM-04.csv: count LB = 16.0000 OZ-wt → OZ-wt; Cheney CS - 18/Pack (46 CT) = 828.0000 Each → Each. Chains do not meet (weight vs each/volume, or each vs volume). |
| PROD CUCUMBERS - 1001207 | ITM-02.csv | franchise | count unit CS - 3 LB (CNT-03.csv); Cheney PurchasingUofM Pack (6 CT) (ITM-02.csv). ITM-04.csv: count CS - 3 LB = 3.0000 LB → LB = 16.0000 OZ-wt → OZ-wt; Cheney Pack (6 CT) = 6.0000 Each → Each. Chains do not meet (weight vs each/volume, or each vs volume). |
| PROD LEMONS - 1001211 | ITM-02.csv | franchise | count unit Dozen (CNT-03.csv); Cheney PurchasingUofM CS - 10 LB (ITM-02.csv). ITM-04.csv: count Dozen = 12.0000 Each → Each; Cheney CS - 10 LB = 160.0000 OZ-wt → OZ-wt. Chains do not meet (weight vs each/volume, or each vs volume). |
| PROD LIMES | ITM-03-unitdiff.csv | franchise | count unit CS - 12/CT (CNT-03.csv); Cheney PurchasingUofM Pack (2 LB) (ITM-02.csv). ITM-04.csv: count CS - 12/CT = 12.0000 Each → Each; Cheney Pack (2 LB) = 2.0000 LB → LB = 16.0000 OZ-wt → OZ-wt. Chains do not meet (weight vs each/volume, or each vs volume). |

_7 items remaining after the two buckets above. Purchase unit ≠ count unit is not this bucket; on this capture Inventory UofM matched count unit for every ITM-01.csv template item. ITM-03-unitdiff.csv lists 70 name-level unit differences using CNT-03 raw names, so doubled-code items are missing from that helper; those rows cite ITM-02.csv._

## Moved to F3

Not findings for this check. INV files are read-only R365 reports with no line detail, plus a 2-invoice sample (`INV-03.txt`). Last-receipt dates and unmapped Cheney lines were not filled from them.

- No Cheney receipt in 8 weeks
- Cheney line not mapped to an item

## Captures

| Area | Where (R365) | File | Take from it |
|---|---|---|---|
| TPL | Inventory → Inventory counts → gear → templates (`/react/inventory/inventory/settings`). Opened **CARY 1 - FHS Weekly Inventory** (`?templateId=`). | TPL-01.txt, TPL-02.csv | 207 names, Reporting UofM, Added by R365 DSS User |
| CNT | Inventory → Inventory counts `/react/inventory/inventory`, CARY 1. Opened Approved **10/04/2026** `?countId=3`. Item Details tab. | CNT-01.txt, CNT-03.csv | count unit, unit cost, extended value, header total $7,461.73 |
| ITM | Inventory → Items `/react/inventory/purchase-items`; Vendor items `/react/inventory/legacy/VendorItems`; Units of measure `/react/inventory/UnitsOfMeasure`; four item drawers `?purchaseItemId=` tabs ItemCost and Settings. | ITM-01.csv, ITM-02.csv, ITM-03-unitdiff.csv, ITM-04.csv, ITM-05..ITM-12.txt | purchase/inventory unit, Avg Cost, Cheney link + unit, unit definitions, conversions |
| INV | Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; Inventory → Invoices `/react/inventory/invoices`; Reports `#/ReportViewer`. | INV-01.csv, INV-02.csv, INV-03.txt, INV-04-missing.txt, INV-05-missing.txt | header-only invoices; 2-invoice sample; no line-detail report |

`pages.csv` actions are only view / filter / export. Invoice detail (`invoiceId=`) and ReportViewer appear as view only. UTF-8 BOM on the header row.

## Deviations

- CNT-02.csv Variance Review has **206** data rows (four recipe names omitted). CNT-03.csv Item Details has **207** and is the count-line source.
- CNT-04.txt COUNT ENTRY footer **$7,461.69** vs list/Item Details **$7,461.73**.
- ITM-02.txt counted 122 Cheney matches against raw CNT-03 names; matching template names to ITM-02.csv `Item` gives **192** linked / **15** not shown.
- ITM-03-unitdiff.csv used those same raw CNT-03 names, so it omits doubled-code template items (e.g. DAIRY CHEDDAR - 1001278). Unit-mismatch rows not in that file cite ITM-02.csv.
- TPL-02.csv has no count-unit column (TPL-02.txt).
- INV has no invoice line detail (Amendment 1; INV-04-missing.txt, INV-05-missing.txt). Expected; not a stop.
- `pages.csv` first bytes are UTF-8 BOM + `time,URL,action`. Unique actions: view, filter, export. No URL path matching save / submit / approve / post / create.
- Captures folder also contains `items-122.zip` (the inbox zip). Not used as evidence.
- Four template recipes are not on ITM-01.csv: COUNT ALL CHIPS, COUNT ALL COOKIES, P-Cajun Mayo 1oz - 1271478, P-Garlic Fresno Marinated Onion 1 oz.

