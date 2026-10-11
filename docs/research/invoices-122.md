# Research · invoices-122 · Verify 122's Cheney invoices: lines, mapping, approval, last receipt

2026-10-11. Verify-only F3 from PC captures in `/srv/fhs-build/reports/invoices-122-captures/` plus the F2 AP header export used as the count source (below). No browser was opened. Nothing in R365 was changed. Fixes are not this note.

## Summary for the owner

- 3 invoices waiting for approval
- 0 Cheney lines not tied to an item ($0.00)
- 108 counted items not bought in 8 weeks

## How cells were filled

- **Count (done-check 1):** the Cheney vendor Transactions tab had no export (`TXN-02-missing.txt`: Filter/Columns/kebab only). The count source is the F2 AP transactions export `/srv/fhs-build/reports/items-122-captures/INV-01.csv` filtered to Company Cheney Brothers, Inc. + Location CARY 1 + Date 08/14/2026–10/09/2026: **25** rows (17 approved AP Invoices + 3 unapproved AP Invoices + 5 AP Credit Memos). That list was cross-checked with the on-screen Open transactions list in `TXN-01.txt` (25 CARY 1 rows, same numbers, dates, totals, and approval status). F2's earlier **20** was invoices only and is not this count. This capture has no `TXN-*.csv`.
- **Invoice / credit-memo pages:** `INV-01.txt`–`INV-25.txt` (one opened form each, view only). URLs are `#/form/APInvoiceForm/{id}` and `#/form/APCreditMemoForm/{id}` (`pages.csv`). Header number, document date, amount, and Unapproved/Approved + Operations Status come from those files. Lines came from the tab-separated grid in the **page text**, not from a line-grid export and not from scrolling (`pages.csv` actions are only `view` and `filter`; the full grid was in the text). **Line count N** is the footer `1 - N of N items`. **Lines read** is the data rows (Item column filled). **Line sum** is the sum of those Total values.
- **INV-01..INV-03 extra line:** the capture agent reported each of `INV-01.txt`–`INV-03.txt` showing one more line than the footer. That extra row is the grid **totals/summary row** (blank Item, quantity total, document total). It is not a duplicate data line, not a column-header row, and not a real extra invoice line. Footer N is the data-line count; Lines read excludes the totals row. The same totals row is on `INV-04.txt`–`INV-25.txt` as well. After dropping it, Lines read = N on all 25 invoices.
- **Approval date:** not on the invoice/credit-memo forms. Every Approval date cell is `not shown (<INV file>)`.
- **Approver:** not on those forms. The F2 AP export used as the count source has column `ApprovedBy`: **Kimberly Helou** on all 22 Approved rows, blank on the 3 Unapproved rows. Approved rows use `Kimberly Helou (INV-01.csv)`; Unapproved rows use `not shown (<INV file>)`.
- **Mapping:** **Mapped** = the line's Item column has an R365 item name. **Unmapped** = GL only / no item. All 609 lines have an item name (including `Misc Charge/Fee - 0099000x`). 150 of those names are not on the 207-item count template; they are still mapped to an R365 item.
- **Last Cheney receipt:** each of the 207 Names from `docs/research/items-122.md` `## Item table`, copied exactly. A captured line matches when its Item column starts with that Name. Longest Name wins (`BEV CCF COKE ZERO` is not `BEV CCF COKE`; `MEAT TURKEY ROASTED - 1304375` is not `MEAT TURKEY - 1001190`). Credit-memo dates count. **Match** is `name+number` when the template Name contains a 7-digit code and that code appears on the line (**49** rows); `name only` when the Name matches but the Name has no 7-digit code (**50** rows); `none` when Last Cheney receipt is `none in 8 weeks` (**108** rows). No `name only` row is a missing-number case: every Name that has a 7-digit code and matched also showed that code on the line.
- **P1 wait:** both invoice date and approval date must be shown. Approval date is never shown, so the wait table is `none`.
- **P1 mapping owner:** from these screens only (no Map control, Save visible and not clicked, no Created by / Modified by, no franchise/corporate mapping label). Credit-memo vendor field `Cheney Brothers, Inc. // Firehouse Subs` (`INV-07.txt`, `INV-09.txt`, `INV-21.txt`) is a vendor string, not a mapping-owner label. Result: **can't tell**.

## Invoice table

| Number | Date | Total | Approval status | Approval date | Approver | Line count N | Lines read | Line sum | Capture |
|---|---|---|---|---|---|---|---|---|---|
| 9100633687 | 10/09/2026 | $1,916.30 | Unapproved | not shown (INV-01.txt) | not shown (INV-01.txt) | 31 | 31 | $1,916.30 | INV-01.txt |
| 9100633686 | 10/09/2026 | $481.67 | Unapproved | not shown (INV-02.txt) | not shown (INV-02.txt) | 1 | 1 | $481.67 | INV-02.txt |
| 9100612350 | 10/06/2026 | $1,983.60 | Unapproved | not shown (INV-03.txt) | not shown (INV-03.txt) | 36 | 36 | $1,983.60 | INV-03.txt |
| 9100594310-CARY | 10/02/2026 | $1,832.25 | Approved | not shown (INV-04.txt) | Kimberly Helou (INV-01.csv) | 36 | 36 | $1,832.25 | INV-04.txt |
| 9100574737-CARY | 09/29/2026 | $1,924.78 | Approved | not shown (INV-05.txt) | Kimberly Helou (INV-01.csv) | 32 | 32 | $1,924.78 | INV-05.txt |
| 9100554801-CARY | 09/25/2026 | $1,617.59 | Approved | not shown (INV-06.txt) | Kimberly Helou (INV-01.csv) | 31 | 31 | $1,617.59 | INV-06.txt |
| 9800050078-CARY | 09/23/2026 | $25.86 | Approved | not shown (INV-07.txt) | Kimberly Helou (INV-01.csv) | 2 | 2 | $25.86 | INV-07.txt |
| 9100535786- CARY | 09/22/2026 | $2,320.01 | Approved | not shown (INV-08.txt) | Kimberly Helou (INV-01.csv) | 40 | 40 | $2,320.01 | INV-08.txt |
| 9800049255-CARY | 09/22/2026 | $37.12 | Approved | not shown (INV-09.txt) | Kimberly Helou (INV-01.csv) | 1 | 1 | $37.12 | INV-09.txt |
| 9100518226- CARY | 09/18/2026 | $1,800.45 | Approved | not shown (INV-10.txt) | Kimberly Helou (INV-01.csv) | 34 | 34 | $1,800.45 | INV-10.txt |
| 9100496699 | 09/15/2026 | $2,650.00 | Approved | not shown (INV-11.txt) | Kimberly Helou (INV-01.csv) | 32 | 32 | $2,650.00 | INV-11.txt |
| 9100496697 | 09/15/2026 | $59.75 | Approved | not shown (INV-12.txt) | Kimberly Helou (INV-01.csv) | 1 | 1 | $59.75 | INV-12.txt |
| 9100478590-CARY | 09/11/2026 | $2,409.46 | Approved | not shown (INV-13.txt) | Kimberly Helou (INV-01.csv) | 43 | 43 | $2,409.46 | INV-13.txt |
| 9100478575-CARY | 09/11/2026 | $428.84 | Approved | not shown (INV-14.txt) | Kimberly Helou (INV-01.csv) | 4 | 4 | $428.84 | INV-14.txt |
| 9100458917-CARY | 09/08/2026 | $2,036.70 | Approved | not shown (INV-15.txt) | Kimberly Helou (INV-01.csv) | 35 | 35 | $2,036.70 | INV-15.txt |
| 9800041936-CARY | 09/08/2026 | $36.39 | Approved | not shown (INV-16.txt) | Kimberly Helou (INV-01.csv) | 1 | 1 | $36.39 | INV-16.txt |
| 9100442428-CARY | 09/04/2026 | $1,801.44 | Approved | not shown (INV-17.txt) | Kimberly Helou (INV-01.csv) | 39 | 39 | $1,801.44 | INV-17.txt |
| 9700011604-CARY | 09/01/2026 | $50.34 | Approved | not shown (INV-18.txt) | Kimberly Helou (INV-01.csv) | 1 | 1 | $50.34 | INV-18.txt |
| 9100421988-CARY | 09/01/2026 | $1,341.57 | Approved | not shown (INV-19.txt) | Kimberly Helou (INV-01.csv) | 28 | 28 | $1,341.57 | INV-19.txt |
| 9100404438-CARY | 08/28/2026 | $2,016.77 | Approved | not shown (INV-20.txt) | Kimberly Helou (INV-01.csv) | 34 | 34 | $2,016.77 | INV-20.txt |
| 9800036617-CARY | 08/26/2026 | $29.12 | Approved | not shown (INV-21.txt) | Kimberly Helou (INV-01.csv) | 1 | 1 | $29.12 | INV-21.txt |
| 9100385374-CARY | 08/25/2026 | $2,792.78 | Approved | not shown (INV-22.txt) | Kimberly Helou (INV-01.csv) | 43 | 43 | $2,792.78 | INV-22.txt |
| 9100367104-CARY | 08/21/2026 | $1,801.42 | Approved | not shown (INV-23.txt) | Kimberly Helou (INV-01.csv) | 27 | 27 | $1,801.42 | INV-23.txt |
| 9100347284-CARY | 08/18/2026 | $1,939.90 | Approved | not shown (INV-24.txt) | Kimberly Helou (INV-01.csv) | 35 | 35 | $1,939.90 | INV-24.txt |
| 9100329133-CARY | 08/14/2026 | $2,168.10 | Approved | not shown (INV-25.txt) | Kimberly Helou (INV-01.csv) | 41 | 41 | $2,168.10 | INV-25.txt |

## Capture gaps

none

## Amount mismatches

none

## Mapping by invoice

| Number | Lines read | Mapped | Unmapped | Unmapped $ | Capture |
|---|---|---|---|---|---|
| 9100633687 | 31 | 31 | 0 | $0.00 | INV-01.txt |
| 9100633686 | 1 | 1 | 0 | $0.00 | INV-02.txt |
| 9100612350 | 36 | 36 | 0 | $0.00 | INV-03.txt |
| 9100594310-CARY | 36 | 36 | 0 | $0.00 | INV-04.txt |
| 9100574737-CARY | 32 | 32 | 0 | $0.00 | INV-05.txt |
| 9100554801-CARY | 31 | 31 | 0 | $0.00 | INV-06.txt |
| 9800050078-CARY | 2 | 2 | 0 | $0.00 | INV-07.txt |
| 9100535786- CARY | 40 | 40 | 0 | $0.00 | INV-08.txt |
| 9800049255-CARY | 1 | 1 | 0 | $0.00 | INV-09.txt |
| 9100518226- CARY | 34 | 34 | 0 | $0.00 | INV-10.txt |
| 9100496699 | 32 | 32 | 0 | $0.00 | INV-11.txt |
| 9100496697 | 1 | 1 | 0 | $0.00 | INV-12.txt |
| 9100478590-CARY | 43 | 43 | 0 | $0.00 | INV-13.txt |
| 9100478575-CARY | 4 | 4 | 0 | $0.00 | INV-14.txt |
| 9100458917-CARY | 35 | 35 | 0 | $0.00 | INV-15.txt |
| 9800041936-CARY | 1 | 1 | 0 | $0.00 | INV-16.txt |
| 9100442428-CARY | 39 | 39 | 0 | $0.00 | INV-17.txt |
| 9700011604-CARY | 1 | 1 | 0 | $0.00 | INV-18.txt |
| 9100421988-CARY | 28 | 28 | 0 | $0.00 | INV-19.txt |
| 9100404438-CARY | 34 | 34 | 0 | $0.00 | INV-20.txt |
| 9800036617-CARY | 1 | 1 | 0 | $0.00 | INV-21.txt |
| 9100385374-CARY | 43 | 43 | 0 | $0.00 | INV-22.txt |
| 9100367104-CARY | 27 | 27 | 0 | $0.00 | INV-23.txt |
| 9100347284-CARY | 35 | 35 | 0 | $0.00 | INV-24.txt |
| 9100329133-CARY | 41 | 41 | 0 | $0.00 | INV-25.txt |

## Mapping totals

lines=609, mapped=609, unmapped=0, unmapped_$=$0.00

### Unmapped lines

none

## Item last receipt

| Name | Last Cheney receipt | Match | Capture |
|---|---|---|---|
| BEV APPLE JUICE ALL | none in 8 weeks | none | none in 8 weeks |
| BEV BOTTLE SODA | none in 8 weeks | none | none in 8 weeks |
| BEV BOTTLED WATER | none in 8 weeks | none | none in 8 weeks |
| BEV CCF AHA BLUEBERRY POM | none in 8 weeks | none | none in 8 weeks |
| BEV CCF BARQS ROOTBEER | none in 8 weeks | none | none in 8 weeks |
| BEV CCF BLACK CHERRY LIMEAID P1 | 09/11/2026 | name only | INV-13.txt |
| BEV CCF BLACK CHERRY LIMEAID P2 | 09/11/2026 | name only | INV-13.txt |
| BEV CCF CAFFEINE FREE DIET COKE | none in 8 weeks | none | none in 8 weeks |
| BEV CCF CHERRY FLAVOR | 09/11/2026 | name only | INV-13.txt |
| BEV CCF COKE | 09/11/2026 | name only | INV-13.txt |
| BEV CCF COKE ZERO | 09/11/2026 | name only | INV-13.txt |
| BEV CCF DIET COKE | none in 8 weeks | none | none in 8 weeks |
| BEV CCF DR PEPPER | 09/11/2026 | name only | INV-13.txt |
| BEV CCF FANTA | 09/11/2026 | name only | INV-13.txt |
| BEV CCF FRUIT PUNCH | none in 8 weeks | none | none in 8 weeks |
| BEV CCF GRAPE FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF HI-C | none in 8 weeks | none | none in 8 weeks |
| BEV CCF INGREDIENT SOL CC | 09/11/2026 | name only | INV-13.txt |
| BEV CCF LEMON FLVR | 09/11/2026 | name only | INV-13.txt |
| BEV CCF LIME FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF MELLO YELLOW | none in 8 weeks | none | none in 8 weeks |
| BEV CCF MM LEMONADE LIGHT | 09/11/2026 | name only | INV-13.txt |
| BEV CCF ORANGE FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF PEACH FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF PINEAPPLE CTRG | none in 8 weeks | none | none in 8 weeks |
| BEV CCF POWERADE | none in 8 weeks | none | none in 8 weeks |
| BEV CCF SPRITE / ZERO | 09/11/2026 | name only | INV-13.txt |
| BEV CCF SPRITE / ZERO INGREDIENT SOL AA | 09/11/2026 | name only | INV-13.txt |
| BEV CCF STRAWBERRY FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF VANILLA FLVR | none in 8 weeks | none | none in 8 weeks |
| BEV CCF VITAMIN WATER | 09/11/2026 | name only | INV-13.txt |
| BEV CHOCOLATE MILK | none in 8 weeks | none | none in 8 weeks |
| BEV MILK GALLON | none in 8 weeks | none | none in 8 weeks |
| BEV MILK SS | none in 8 weeks | none | none in 8 weeks |
| BEV POWERADE | none in 8 weeks | none | none in 8 weeks |
| BEV SYRUP LIQUID SWEETENER HFCS BIB | 10/06/2026 | name only | INV-03.txt |
| BEV SYRUP LIQUID SWTNR NON NUTRITV BIB | 10/06/2026 | name only | INV-03.txt |
| BEV TEA BAG ICED PK | none in 8 weeks | none | none in 8 weeks |
| BREAD LARGE WHEAT SUB ROLL | 10/09/2026 | name only | INV-01.txt |
| BREAD LARGE WHITE SUB ROLL | 10/09/2026 | name only | INV-01.txt |
| BREAD MEDIUM WHEAT SUB ROLL | 10/06/2026 | name only | INV-03.txt |
| BREAD MEDIUM WHITE SUB ROLL | 10/09/2026 | name only | INV-01.txt |
| BREAD WHITE BREAD | 08/18/2026 | name only | INV-24.txt |
| BROWNIE - 1001415 | 09/01/2026 | name+number | INV-19.txt |
| Catering Chips - 1001442 | none in 8 weeks | none | none in 8 weeks |
| CLEAN CLEANER ALL PURPOSE/GLASS 3 N | none in 8 weeks | none | none in 8 weeks |
| CLEAN CLEANER FLOOR LIQUID | none in 8 weeks | none | none in 8 weeks |
| CLEAN COMET SPRAY W/ BLEACH | none in 8 weeks | none | none in 8 weeks |
| CLEAN DETERGENT DISH POT/PAN | none in 8 weeks | none | none in 8 weeks |
| CLEAN FLOOR SPIC SPAN | none in 8 weeks | none | none in 8 weeks |
| CLEAN MOP HEAD | none in 8 weeks | none | none in 8 weeks |
| CLEAN PAD SCRUB STNLS 1.75OZ | none in 8 weeks | none | none in 8 weeks |
| CLEAN SANITIZER HAND | none in 8 weeks | none | none in 8 weeks |
| CLEAN SANITIZER NO RINSE SINK | none in 8 weeks | none | none in 8 weeks |
| CLEAN SOAP HAND ANTI BACTRL | none in 8 weeks | none | none in 8 weeks |
| CLEAN STRIP TEST TAPE QUAT | none in 8 weeks | none | none in 8 weeks |
| CLEAN TISSUE TOILET 2PLY WHT | 08/25/2026 | name only | INV-22.txt |
| CLEAN VINEGAR WHITE DISTILLED | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE CHOLULA BOTTLE | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE HONEY HABANERO | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE PEACH BOURBON | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE PINEAPPLE | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE RED HOT ORIGINAL | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE SAUCE TABASCO | none in 8 weeks | none | none in 8 weeks |
| CNTR HOT SAUCE SCORPION | none in 8 weeks | none | none in 8 weeks |
| CO2 | none in 8 weeks | none | none in 8 weeks |
| COUNT ALL CHIPS | none in 8 weeks | none | none in 8 weeks |
| COUNT ALL COOKIES | none in 8 weeks | none | none in 8 weeks |
| DAIRY CHEDDAR - 1001278 | 10/09/2026 | name+number | INV-01.txt |
| DAIRY MONTEREY JACK - 1001273 | 10/02/2026 | name+number | INV-04.txt |
| DAIRY PEPPER JACK - 1094114 | 09/15/2026 | name+number | INV-11.txt |
| DAIRY PROVOLONE - 1001281 | 10/06/2026 | name+number | INV-03.txt |
| DAIRY SHREDDED MOZZARELLA - 1001276 | none in 8 weeks | none | none in 8 weeks |
| DAIRY SWISS - 1001283 | none in 8 weeks | none | none in 8 weeks |
| FRYER FRENCH FRIES - 1290664 | 10/09/2026 | name+number | INV-01.txt |
| FRYER OIL SHORTENING | 09/29/2026 | name only | INV-05.txt |
| MEAT BACON - 1001141 | 10/09/2026 | name+number | INV-01.txt |
| MEAT BRISKET - 1001146 | 09/29/2026 | name+number | INV-05.txt |
| MEAT CORNED BEEF - 1001152 | 10/02/2026 | name+number | INV-04.txt |
| MEAT HAM - 1001175 | 10/09/2026 | name+number | INV-01.txt |
| MEAT MEATBALL - 1001179 | 10/09/2026 | name+number | INV-01.txt |
| MEAT PASTRAMI - 1001165 | 09/15/2026 | name+number | INV-11.txt |
| MEAT PEPPERONI - 1001181 | 10/02/2026 | name+number | INV-04.txt |
| MEAT ROAST BEEF - 1001167 | 10/02/2026 | name+number | INV-04.txt |
| MEAT SALAMI - 1001183 | 10/06/2026 | name+number | INV-03.txt |
| MEAT SLICED CHICKEN BREAST | 10/06/2026 | name only | INV-03.txt |
| MEAT STEAK | 10/09/2026 | name only | INV-01.txt |
| MEAT TUNA - 1001187 | 09/22/2026 | name+number | INV-08.txt |
| MEAT TURKEY - 1001190 | 10/09/2026 | name+number | INV-01.txt |
| NON REV A1 STEAK BTL | none in 8 weeks | none | none in 8 weeks |
| NON REV BALSAMIC VINAIGARETTE - 1001297 | 10/09/2026 | name+number | INV-01.txt |
| NON REV BANANA PEPPER - 1001346 | 10/02/2026 | name+number | INV-04.txt |
| NON REV BBQ - 1001377 | 09/18/2026 | name+number | INV-10.txt |
| NON REV BLACK OLIVE - 1001340 | 09/04/2026 | name+number | INV-17.txt |
| NON REV BUTTER - 1197472 | 09/25/2026 | name+number | INV-06.txt |
| NON REV CAJUN SEASONING - 1094161 | 09/29/2026 | name+number | INV-05.txt |
| NON REV Garlic Chips - 1340968 | none in 8 weeks | none | none in 8 weeks |
| NON REV GARLIC SEASONING - 1197461 | 09/18/2026 | name+number | INV-10.txt |
| NON REV HONEY MUSTARD - 1004033 | none in 8 weeks | none | none in 8 weeks |
| NON REV ITALIAN DRESSING - 1001304 | 10/09/2026 | name+number | INV-01.txt |
| NON REV ITALIAN LT - 1001301 | none in 8 weeks | none | none in 8 weeks |
| NON REV ITALIAN SEASONING - 1001396 | 10/06/2026 | name+number | INV-03.txt |
| NON REV JALAPENO - 1001352 | 10/02/2026 | name+number | INV-04.txt |
| NON REV JAMAICAN SEASONING - 1094189 | none in 8 weeks | none | none in 8 weeks |
| NON REV KETCHUP PACKET FCY | 09/22/2026 | name only | INV-08.txt |
| NON REV LTO Caramelized Onions - 1052395 | none in 8 weeks | none | none in 8 weeks |
| NON REV MAYO - 1001314 | 10/09/2026 | name+number | INV-01.txt |
| NON REV MAYO PACKET - 1001319 | 09/04/2026 | name+number | INV-17.txt |
| NON REV OIL CANOLA OLIVE BLEND - 1001331 | none in 8 weeks | none | none in 8 weeks |
| NON REV ONION GARLIC FRESNO MARINATED - 1340985 | none in 8 weeks | none | none in 8 weeks |
| NON REV OYSTER CRACKER - 1058308 | none in 8 weeks | none | none in 8 weeks |
| NON REV PEPPER PACKET | none in 8 weeks | none | none in 8 weeks |
| NON REV PICKLE PLANK SPICY - 1341051 | none in 8 weeks | none | none in 8 weeks |
| NON REV PICKLE SPEAR - 1001364 | 10/09/2026 | name+number | INV-01.txt |
| NON REV PKT CHOLULA | none in 8 weeks | none | none in 8 weeks |
| NON REV PKT SAUCE CAPTAIN SORENSEN | none in 8 weeks | none | none in 8 weeks |
| NON REV PKT SAUCE LOUISIANA | none in 8 weeks | none | none in 8 weeks |
| NON REV RANCH - 1001309 | 09/01/2026 | name+number | INV-19.txt |
| NON REV RELISH - 1001366 | 08/25/2026 | name+number | INV-22.txt |
| NON REV RICE KRISPIE | none in 8 weeks | none | none in 8 weeks |
| NON REV SALT PACKET | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE CAPTAIN SORENSEN BTL - 1001758 | 10/06/2026 | name+number | INV-03.txt |
| NON REV SAUCE CARROT CHIPOTLE | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE FIRE BACKDRAFT | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE GARLIC AIOLI | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE GATOR | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE GREEN JALAPENO SAUCE | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE HOT TEXAS PETE | none in 8 weeks | none | none in 8 weeks |
| NON REV SAUCE MARINARA - 1001384 | 10/06/2026 | name+number | INV-03.txt |
| NON REV SAUCE MUSTARD SWEET FHS - 1050473 | 09/29/2026 | name+number | INV-05.txt |
| NON REV SEASONING CARMELIZED VEGETABLE - 1138068 | none in 8 weeks | none | none in 8 weeks |
| NON REV SPICE RED PEPPER FLAKES - 1002638 | none in 8 weeks | none | none in 8 weeks |
| NON REV SPICY DELI MUSTARD - 1001323 | 10/06/2026 | name+number | INV-03.txt |
| NON REV SPICY DELI MUSTARD PACKET - 1001326 | 09/08/2026 | name+number | INV-15.txt |
| NON REV SUGAR GRANULATED EXTRA FINE | 10/02/2026 | name only | INV-04.txt |
| NON REV SUGAR PACKET | none in 8 weeks | none | none in 8 weeks |
| NON REV SUGAR SUB BLUE PACKET | none in 8 weeks | none | none in 8 weeks |
| NON REV SUGAR SUB YELLOW PACKET | none in 8 weeks | none | none in 8 weeks |
| NON REV VINEGAR RED WINE PLAS - 1001410 | none in 8 weeks | none | none in 8 weeks |
| NON REV YELLOW MUSTARD - 1001321 | none in 8 weeks | none | none in 8 weeks |
| P-Cajun Mayo 1oz - 1271478 | none in 8 weeks | none | none in 8 weeks |
| P-Garlic Fresno Marinated Onion 1 oz | none in 8 weeks | none | none in 8 weeks |
| PAPER FD BAG PAPER BRN 1/8 TALL MEDIUM | 10/09/2026 | name only | INV-01.txt |
| PAPER FD BAG PAPER BRN 8# KRFT SMALL | 09/18/2026 | name only | INV-10.txt |
| PAPER FD BAG PAPER BRN 13.5X16.375 LRG | 10/06/2026 | name only | INV-03.txt |
| PAPER FD BAG PAPER BRN HNDL CATERING | 08/25/2026 | name only | INV-22.txt |
| PAPER FD BOX CARRYOUT TUCK TP 9X5X4 NEW | 08/14/2026 | name only | INV-25.txt |
| PAPER FD BOX CORR CATERING W/ INSERT | 09/18/2026 | name only | INV-10.txt |
| PAPER FD CHILI BOWL | none in 8 weeks | none | none in 8 weeks |
| PAPER FD CONTAINER FIBER BAGASS 6X6 | 10/02/2026 | name only | INV-04.txt |
| PAPER FD CONTAINER FIBER BAGASS 9.85 | 10/09/2026 | name only | INV-01.txt |
| PAPER FD CONTAINER FIBER BAGASS 13.35 | 10/09/2026 | name only | INV-01.txt |
| PAPER FD CUP PAPER 12OZ | none in 8 weeks | none | none in 8 weeks |
| PAPER FD CUP PAPER 22OZ | 09/04/2026 | name only | INV-17.txt |
| PAPER FD CUP PAPER 32OZ | 10/02/2026 | name only | INV-04.txt |
| PAPER FD CUP PAPER SOUP RND WHT DFR 6OZ - 1059333 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD CUP PRTN SOUFFLE 1oz - 1001699 | 09/04/2026 | name+number | INV-17.txt |
| PAPER FD CUP PRTN SOUFFLE 2-3 OZ | none in 8 weeks | none | none in 8 weeks |
| PAPER FD FILM PVC ROLL 12x2000 CLING | 09/29/2026 | name only | INV-05.txt |
| PAPER FD FILM PVC ROLL 18X2000 CLING | none in 8 weeks | none | none in 8 weeks |
| PAPER FD FOIL ALMN SHEET LARGE - 1001654 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD FOIL ALMN SHEET SMALL - 1001657 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD FORK CUTLERY WRPD - 1068074 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD JUG PLASTIC GALLON EMPTY W/LID | none in 8 weeks | none | none in 8 weeks |
| PAPER FD KNIFE WRAPPED | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LID PLAS FOR 12-22 OZ CUP | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LID PLAS FOR 32 OZ CUP | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LID PRTN SOUFFLE 1 OZ - 1010700 | 09/25/2026 | name+number | INV-06.txt |
| PAPER FD LID PRTN SOUFFLE 2.5 OZ | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LID SOUP PLAS CLR F/DFR10 & DFT16 - 1044642 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LINER BAG FOOD 1/4 & 1/3 PAN | none in 8 weeks | none | none in 8 weeks |
| PAPER FD LINER BAG FOOD 1/6 PAN | 09/25/2026 | name only | INV-06.txt |
| PAPER FD LINER PAN SCRUB SAVER COLD 1/3 & 1/4 | 10/06/2026 | name only | INV-03.txt |
| PAPER FD LINER PLAS TEA URN | 09/11/2026 | name only | INV-13.txt |
| PAPER FD LRG SALAD BOWL | 08/14/2026 | name only | INV-25.txt |
| PAPER FD NAPKINS FOR DSPNSR 2PFLD - 1001710 | 10/02/2026 | name+number | INV-04.txt |
| PAPER FD PAPER WAX SHEET 15X15 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD PICK WOOD BAMBOO CLUB FRILL | none in 8 weeks | none | none in 8 weeks |
| PAPER FD SM SALAD BOWL | none in 8 weeks | none | none in 8 weeks |
| PAPER FD SPOON SOUP WRAPPED - 1068078 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD STRAW PLAS JMBO RED WRPD 9.5 | 10/02/2026 | name only | INV-04.txt |
| PAPER FD STRAW PLAS JMBO WRPD RED 7.75 | none in 8 weeks | none | none in 8 weeks |
| PAPER FD TONG PLAS BLK PP 9 SERVING | 09/04/2026 | name only | INV-17.txt |
| PAPER FD TRAY CARRIER 4 CUP 8-44 OZ | none in 8 weeks | none | none in 8 weeks |
| PAPER FD WRAP DELI INTRFLD 12X10.75 | 09/04/2026 | name only | INV-17.txt |
| PAPER FD WRAP DRY WAX STEAMER 12X10.75 | 09/11/2026 | name only | INV-13.txt |
| PAPER NF GLOVE VINYL POWD FREE LG | none in 8 weeks | none | none in 8 weeks |
| PAPER NF GLOVE VINYL POWD FREE MED | none in 8 weeks | none | none in 8 weeks |
| PAPER NF GLOVE VINYL PWDR FREE XL | 10/09/2026 | name only | INV-01.txt |
| PAPER NF GLOVE VINYL PWDR FREE XXL | none in 8 weeks | none | none in 8 weeks |
| PAPER NF INTERFOLD DISPENSER NAPKIN | none in 8 weeks | none | none in 8 weeks |
| PAPER NF TOWEL ROLL 7.875 NAT | 08/25/2026 | name only | INV-22.txt |
| PROD CUCUMBERS - 1001207 | 10/02/2026 | name+number | INV-04.txt |
| PROD LEMONS - 1001211 | 09/25/2026 | name+number | INV-06.txt |
| PROD LETTUCE 1/8" SHREDDED - 1001214 | 10/09/2026 | name+number | INV-01.txt |
| PROD LIMES | 10/06/2026 | name only | INV-03.txt |
| PROD MUSHROOM SLICED SEASND IN BRNE - 1001221 | 10/09/2026 | name+number | INV-01.txt |
| PROD ONIONS YELLOW JUMBO - 1001228 | 10/06/2026 | name+number | INV-03.txt |
| PROD PEPPERS GREEN - 1001232 | 09/29/2026 | name+number | INV-05.txt |
| PROD ROMAINE CHOPPED - 1001239 | 10/09/2026 | name+number | INV-01.txt |
| PROD TOMATOES - 1001243 | 10/09/2026 | name+number | INV-01.txt |
| SOUP CHILI - 1001268 | 10/02/2026 | name+number | INV-04.txt |
| SOUP MACARONI AND CHS | none in 8 weeks | none | none in 8 weeks |
| SOUP POTATO LOADED SOUP | 09/11/2026 | name only | INV-13.txt |
| ZZZ BREAD ROLL Breads SNGL SLI GLU FREE | none in 8 weeks | none | none in 8 weeks |
| ZZZPAPER FD PLATE ROUND 9IN | none in 8 weeks | none | none in 8 weeks |
| ZZZPAPER NF LINER PAN SCRUB SAVER 1/6TH | none in 8 weeks | none | none in 8 weeks |

## P1

### Approval wait

none

### Who owns vendor-item mapping

can't tell
