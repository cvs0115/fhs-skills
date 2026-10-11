# Research · count-lines-122 · Sort the 108 not-bought counted items: slow, substituted or dead

2026-10-11. Verify-only from files in `/srv/fhs-build/reports/count-lines-122-captures/` plus `/srv/fhs-build/reports/invoices-122-captures/` (08/14–10/09 lines) and `/srv/fhs-build/reports/items-122-captures/CNT-03.csv` (10/04 qty check / $). No browser was opened. Nothing in R365 was changed. Fixes are not this note.

## Summary for the owner

- 31 still bought, just not lately
- 0 bought under another Cheney item
- 45 look dead ($0.00 on the 10/04 count)
- 32 can't tell

## How cells were filled

- **Counts:** this job's `CNT-01.txt` is the Inventory counts list for CARY 1 (`/react/inventory/inventory`, `pages.csv`). It shows **1–3 of 3** rows: **Approved 10/04/2026** list total **$7,461.73**; **In Progress 09/28/2026** (not opened, not used); **Approved 01/08/2026** (business date before 08/01/2026, not opened). The PC capture found **only one** Approved CARY 1 count on or after 08/01/2026. That count was opened at `?countId=3` (`CNT-02.txt`). Item Details export is **`CNT-02.csv`** (207 item rows; `Current $ Total` sums to $7,461.73). Quantity per Name uses that export (and matches items-122 `CNT-03.csv`). Do not use the 09/28 In Progress count.
- **Older purchases — item detail first:** `ITM-01.txt` / `ITM-02.txt` / `ITM-03.txt` are the three-item probe (**BEV APPLE JUICE ALL**, **BEV BOTTLE SODA**, **BEV BOTTLED WATER**) on Inventory → Items `/react/inventory/purchase-items` → item detail `?purchaseItemId=` **Transactions** tab (`pages.csv`). That tab is a dated grid (Transaction Type, Transaction Date, Number, …). For all three it showed **only Inventory Count rows** (10/04 Approved and 09/28 In Progress). **No Purchase / invoice / receipt rows.** `ITM-03-missing.txt` records that. Dated item purchase history was **not** used as the older-purchase source for the 108.
- **Older purchases — invoices instead:** `TXN-01.txt` is Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`, filtered Vendor Cheney / Location CARY 1. `TXN-02.csv` is that list's export (154 CARY 1 Cheney rows). In **05/15/2026–08/13/2026** there are **37** invoices and credit memos (32 AP Invoice + 5 AP Credit Memo), which is ≤45, so the forms were opened. `INV-01.txt`–`INV-37.txt` are those 37 AP forms (`#/form/APInvoiceForm/{id}` and `#/form/APCreditMemoForm/{id}`, view only). No line-grid export; the full grid is in the page text; footer `1 - N of N items` matches lines read on all 37 (`TXN-02.txt`). **Earliest history date: 05/15/2026 (`INV-37.txt`, 05/15–08/13 invoices).**
- **08/14–10/09 pairing:** invoices-122 `INV-01.txt`–`INV-25.txt` (CARY 1 Cheney lines in that window). A line's R365 item is the Item column with the Vendor Item number suffix removed when present. A line is a **count name** when Item starts with that Name (longest Name wins, same doubled-code match as items-122 / invoices-122: `MEAT TURKEY - 1001190 - 1001190` matches `MEAT TURKEY - 1001190`; `BEV CCF COKE ZERO` is not `BEV CCF COKE`). **Non-count** items are the rest. invoices-122's **150** is the **line** count of those non-count rows; unique R365 items among them are **38**. 10/04 **$** and **Cheney vendor item** cells are copied from items-122 `## Item table`, not re-summed.
- **Pairs:** **tied** only if a 7-digit item number is shared with a 108 Name, or this job's ITM files tie them. The ITM probe had no purchase rows. No candidate shares a 7-digit code with a 108 Name. Product-word / size / category matches are **`(?)`**. Chip SKUs pair with **COUNT ALL CHIPS**; cookie/bar SKUs with **COUNT ALL COOKIES**; other likely names are same product words or size. **`none`** when nothing in the 108 fits.
- **Groups (one each, this order):** **other Cheney item** = tied likely name in the candidates table and a 08/14–10/09 receipt of that non-count item (none here); **slow mover** = a Cheney receipt of **that Name** on the 05/15–08/13 forms; **looks dead** = history covers 05/15–08/13 (those 37 forms were listed and opened), no receipt of that Name in that range, qty **0** on every captured count (only 10/04), no tied pair; **can't tell** = anything else (here: qty not 0 on 10/04 and no receipt of that Name).

## Other Cheney item candidates

| Non-count item | Receipt date | Likely count name | Pair | Capture |
|---|---|---|---|---|
| BEV TEA BLK BLEND - 1341579 | 09/11/2026 | BEV TEA BAG ICED PK | (?) | invoices-122 INV-13.txt |
| BREAD GF CIABATTA ROLL | 10/02/2026 | ZZZ BREAD ROLL Breads SNGL SLI GLU FREE | (?) | invoices-122 INV-04.txt |
| BREAD SMALL WHITE SUB ROLL | 10/09/2026 | none | none | invoices-122 INV-01.txt |
| CHIP CHEESE CRUNCHY CHEETOS - 1001462 REG | 09/29/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-05.txt |
| CHIP DILL PICKLE SPICY KETTLE - 1124222 | 10/06/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-03.txt |
| CHIP DORITOS TORTILLA COOL RANCH - 1001451 | 09/29/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-05.txt |
| CHIP DORITOS TORTILLA NACHO CHEESE - 1001453 | 10/06/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-03.txt |
| CHIP POTATO BAKED LAYS - 1001428 | 09/29/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-05.txt |
| CHIP POTATO BBQ KETTLE - 1001446 | 09/22/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-08.txt |
| CHIP POTATO BBQ REG - 1001424 | 09/15/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-11.txt |
| CHIP POTATO JALAPENO KETTLE - 1001433 | 09/29/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-05.txt |
| CHIP POTATO KETTLE SEA SALT - 1003592 | 09/22/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-08.txt |
| CHIP POTATO REG LAYS - 1001439 | 10/09/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-01.txt |
| CHIP POTATO SALT & VNGR KETTLE | 10/06/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-03.txt |
| CHIP POTATO SOUR CREAM ONION | 10/06/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-03.txt |
| CHIP RUFFLES REG CHEDDAR & SOUR CREAM - 1001437 | 10/06/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-03.txt |
| CHIP SUNCHIP MULTIGRAIN HARVEST CHDR - 1001421 | 10/09/2026 | COUNT ALL CHIPS | (?) | invoices-122 INV-01.txt |
| CHOCOLATE CHIP COOKIE - 1001456 | 09/22/2026 | COUNT ALL COOKIES | (?) | invoices-122 INV-08.txt |
| CLEAN CLEANER RESTROOM | 09/18/2026 | CLEAN CLEANER ALL PURPOSE/GLASS 3 N | (?) | invoices-122 INV-10.txt |
| CLEAN LINER TRASH NAT 40X46 14 MICRO | 09/08/2026 | none | none | invoices-122 INV-15.txt |
| CLEAN PAD SCOUR GREEN 6X9 | 09/01/2026 | CLEAN PAD SCRUB STNLS 1.75OZ | (?) | invoices-122 INV-19.txt |
| COOKIE COOKIES & CREAM | 08/28/2026 | COUNT ALL COOKIES | (?) | invoices-122 INV-20.txt |
| DAIRY SHREDDED CHEESE MEX BLEND | 09/22/2026 | DAIRY SHREDDED MOZZARELLA - 1001276 | (?) | invoices-122 INV-08.txt |
| K-9 CREW PLUSH | 10/09/2026 | none | none | invoices-122 INV-02.txt |
| MEAT TURKEY ROASTED - 1304375 | 10/06/2026 | none | none | invoices-122 INV-03.txt |
| Misc Charge/Fee | 10/09/2026 | none | none | invoices-122 INV-01.txt |
| NON REV SAUCE CRANBERRY - 1002421 | 09/11/2026 | none | none | invoices-122 INV-14.txt |
| NON REV STUFFING STOVE TOP - 1304378 | 10/06/2026 | none | none | invoices-122 INV-03.txt |
| OATMEAL RAISIN COOKIE - 1001460 | 09/29/2026 | COUNT ALL COOKIES | (?) | invoices-122 INV-05.txt |
| PAPER FD CUP PLASTIC 12OZ | 09/08/2026 | PAPER FD CUP PAPER 12OZ | (?) | invoices-122 INV-15.txt |
| PAPER FD CUP PLASTIC 40/44 OZ | 10/02/2026 | none | none | invoices-122 INV-04.txt |
| PAPER FD FRY CLAMSHELL REGULAR | 10/09/2026 | none | none | invoices-122 INV-01.txt |
| PAPER FD LID PLAS SLOTD NAT DISP 44OZ | 09/08/2026 | none | none | invoices-122 INV-15.txt |
| PAPER NF 3 1/8" X 200FT - POS THERMAL PAPER RECEIPT ROLLS | 09/25/2026 | none | none | invoices-122 INV-06.txt |
| PECAN PIE BAR | 10/02/2026 | COUNT ALL COOKIES | (?) | invoices-122 INV-04.txt |
| PROD PEPPERS RED BELL - 1001236 - 1341651 | 10/06/2026 | none | none | invoices-122 INV-03.txt |
| SOUP GRAVY - 1341437 | 10/09/2026 | none | none | invoices-122 INV-01.txt |
| SOUP NEW MACARONI & CHEESE | 10/09/2026 | SOUP MACARONI AND CHS | (?) | invoices-122 INV-01.txt |

## Count history

| Date | Status | List total | Export total | Capture |
|---|---|---|---|---|
| 10/04/2026 | Approved | $7,461.73 | $7,461.73 | CNT-02.csv |

## Item table

| Name | Group | Last Cheney receipt | Source | Count quantities | $ on 10/04 | Capture |
|---|---|---|---|---|---|---|
| BEV APPLE JUICE ALL | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV BOTTLE SODA | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 70.00 | $0.00 | CNT-02.csv |
| BEV BOTTLED WATER | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 30.00 | $0.00 | CNT-02.csv |
| BEV CCF AHA BLUEBERRY POM | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV CCF BARQS ROOTBEER | slow mover | 07/17/2026 | INV-12.txt | 10/04/2026: 0.76 | $57.44 | INV-12.txt |
| BEV CCF CAFFEINE FREE DIET COKE | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV CCF DIET COKE | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 0.76 | $57.44 | INV-02.txt |
| BEV CCF FRUIT PUNCH | slow mover | 06/09/2026 | INV-29.txt | 10/04/2026: 1.00 | $0.00 | INV-29.txt |
| BEV CCF GRAPE FLVR | slow mover | 06/09/2026 | INV-29.txt | 10/04/2026: 1.34 | $0.00 | INV-29.txt |
| BEV CCF HI-C | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 1.16 | $57.43 | INV-02.txt |
| BEV CCF LIME FLVR | slow mover | 05/15/2026 | INV-37.txt | 10/04/2026: 1.11 | $0.00 | INV-37.txt |
| BEV CCF MELLO YELLOW | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 1.10 | $65.08 | INV-02.txt |
| BEV CCF ORANGE FLVR | slow mover | 07/17/2026 | INV-12.txt | 10/04/2026: 1.16 | $22.61 | INV-12.txt |
| BEV CCF PEACH FLVR | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 1.21 | $23.58 | INV-02.txt |
| BEV CCF PINEAPPLE CTRG | slow mover | 05/15/2026 | INV-37.txt | 10/04/2026: 1.45 | $0.00 | INV-37.txt |
| BEV CCF POWERADE | slow mover | 07/17/2026 | INV-12.txt | 10/04/2026: 0.74 | $50.05 | INV-12.txt |
| BEV CCF STRAWBERRY FLVR | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 0.78 | $15.20 | INV-02.txt |
| BEV CCF VANILLA FLVR | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 0.96 | $18.71 | INV-02.txt |
| BEV CHOCOLATE MILK | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV MILK GALLON | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 18.00 | $0.00 | CNT-02.csv |
| BEV MILK SS | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV POWERADE | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| BEV TEA BAG ICED PK | slow mover | 07/24/2026 | INV-09.txt | 10/04/2026: 81.60 | $0.00 | INV-09.txt |
| Catering Chips - 1001442 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN CLEANER ALL PURPOSE/GLASS 3 N | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN CLEANER FLOOR LIQUID | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN COMET SPRAY W/ BLEACH | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN DETERGENT DISH POT/PAN | slow mover | 07/24/2026 | INV-09.txt | 10/04/2026: 0.00 | $0.00 | INV-09.txt |
| CLEAN FLOOR SPIC SPAN | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN MOP HEAD | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN PAD SCRUB STNLS 1.75OZ | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN SANITIZER HAND | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN SANITIZER NO RINSE SINK | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN SOAP HAND ANTI BACTRL | slow mover | 06/05/2026 | INV-30.txt | 10/04/2026: 0.00 | $0.00 | INV-30.txt |
| CLEAN STRIP TEST TAPE QUAT | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CLEAN VINEGAR WHITE DISTILLED | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE CHOLULA BOTTLE | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.10 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE HONEY HABANERO | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 2.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE PEACH BOURBON | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 10.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE PINEAPPLE | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 2.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE RED HOT ORIGINAL | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 2.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE SAUCE TABASCO | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 2.00 | $0.00 | CNT-02.csv |
| CNTR HOT SAUCE SCORPION | slow mover | 06/05/2026 | INV-30.txt | 10/04/2026: 4.00 | $0.00 | INV-30.txt |
| CO2 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| COUNT ALL CHIPS | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| COUNT ALL COOKIES | can't tell | none in captured history | missing: pair is (?) only | 10/04/2026: 288.00 | $119.17 | CNT-02.csv |
| DAIRY SHREDDED MOZZARELLA - 1001276 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| DAIRY SWISS - 1001283 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV A1 STEAK BTL | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV Garlic Chips - 1340968 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV HONEY MUSTARD - 1004033 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV ITALIAN LT - 1001301 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 1.50 | $0.00 | CNT-02.csv |
| NON REV JAMAICAN SEASONING - 1094189 | slow mover | 05/29/2026 | INV-33.txt | 10/04/2026: 2.12 | $0.00 | INV-33.txt |
| NON REV LTO Caramelized Onions - 1052395 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV OIL CANOLA OLIVE BLEND - 1001331 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV ONION GARLIC FRESNO MARINATED - 1340985 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV OYSTER CRACKER - 1058308 | slow mover | 07/24/2026 | INV-09.txt | 10/04/2026: 0.25 | $0.00 | INV-09.txt |
| NON REV PEPPER PACKET | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.75 | $0.00 | CNT-02.csv |
| NON REV PICKLE PLANK SPICY - 1341051 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV PKT CHOLULA | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.01 | $0.00 | CNT-02.csv |
| NON REV PKT SAUCE CAPTAIN SORENSEN | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.50 | $0.00 | CNT-02.csv |
| NON REV PKT SAUCE LOUISIANA | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV RICE KRISPIE | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 1.28 | $0.00 | CNT-02.csv |
| NON REV SALT PACKET | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.13 | $0.00 | CNT-02.csv |
| NON REV SAUCE CARROT CHIPOTLE | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 7.00 | $0.00 | CNT-02.csv |
| NON REV SAUCE FIRE BACKDRAFT | slow mover | 06/09/2026 | INV-29.txt | 10/04/2026: 8.00 | $0.00 | INV-29.txt |
| NON REV SAUCE GARLIC AIOLI | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SAUCE GATOR | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 3.00 | $0.00 | CNT-02.csv |
| NON REV SAUCE GREEN JALAPENO SAUCE | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SAUCE HOT TEXAS PETE | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SEASONING CARMELIZED VEGETABLE - 1138068 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SPICE RED PEPPER FLAKES - 1002638 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SUGAR PACKET | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.75 | $0.00 | CNT-02.csv |
| NON REV SUGAR SUB BLUE PACKET | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV SUGAR SUB YELLOW PACKET | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| NON REV VINEGAR RED WINE PLAS - 1001410 | slow mover | 08/04/2026 | INV-06.txt | 10/04/2026: 0.75 | $0.00 | INV-06.txt |
| NON REV YELLOW MUSTARD - 1001321 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.15 | $0.00 | CNT-02.csv |
| P-Cajun Mayo 1oz - 1271478 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 16.00 | $1.87 | CNT-02.csv |
| P-Garlic Fresno Marinated Onion 1 oz | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD CHILI BOWL | slow mover | 05/19/2026 | INV-36.txt | 10/04/2026: 10.00 | $0.00 | INV-36.txt |
| PAPER FD CUP PAPER 12OZ | slow mover | 05/29/2026 | INV-33.txt | 10/04/2026: 17.00 | $0.00 | INV-33.txt |
| PAPER FD CUP PAPER SOUP RND WHT DFR 6OZ - 1059333 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 1,100.00 | $0.00 | CNT-02.csv |
| PAPER FD CUP PRTN SOUFFLE 2-3 OZ | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD FILM PVC ROLL 18X2000 CLING | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD FOIL ALMN SHEET LARGE - 1001654 | slow mover | 06/16/2026 | INV-24.txt | 10/04/2026: 6.00 | $0.00 | INV-24.txt |
| PAPER FD FOIL ALMN SHEET SMALL - 1001657 | slow mover | 07/31/2026 | INV-07.txt | 10/04/2026: 3.50 | $0.00 | INV-07.txt |
| PAPER FD FORK CUTLERY WRPD - 1068074 | slow mover | 06/12/2026 | INV-28.txt | 10/04/2026: 0.15 | $0.00 | INV-28.txt |
| PAPER FD JUG PLASTIC GALLON EMPTY W/LID | slow mover | 08/11/2026 | INV-02.txt | 10/04/2026: 18.00 | $24.48 | INV-02.txt |
| PAPER FD KNIFE WRAPPED | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 150.00 | $0.00 | CNT-02.csv |
| PAPER FD LID PLAS FOR 12-22 OZ CUP | slow mover | 07/21/2026 | INV-11.txt | 10/04/2026: 10.00 | $0.00 | INV-11.txt |
| PAPER FD LID PLAS FOR 32 OZ CUP | slow mover | 08/04/2026 | INV-06.txt | 10/04/2026: 0.75 | $0.00 | INV-06.txt |
| PAPER FD LID PRTN SOUFFLE 2.5 OZ | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD LID SOUP PLAS CLR F/DFR10 & DFT16 - 1044642 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 15.00 | $0.00 | CNT-02.csv |
| PAPER FD LINER BAG FOOD 1/4 & 1/3 PAN | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 1.00 | $0.00 | CNT-02.csv |
| PAPER FD PAPER WAX SHEET 15X15 | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.75 | $0.00 | CNT-02.csv |
| PAPER FD PICK WOOD BAMBOO CLUB FRILL | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 5.00 | $0.00 | CNT-02.csv |
| PAPER FD SM SALAD BOWL | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD SPOON SOUP WRAPPED - 1068078 | slow mover | 06/26/2026 | INV-19.txt | 10/04/2026: 0.50 | $0.00 | INV-19.txt |
| PAPER FD STRAW PLAS JMBO WRPD RED 7.75 | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER FD TRAY CARRIER 4 CUP 8-44 OZ | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 1.00 | $0.00 | CNT-02.csv |
| PAPER NF GLOVE VINYL POWD FREE LG | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER NF GLOVE VINYL POWD FREE MED | slow mover | 07/24/2026 | INV-09.txt | 10/04/2026: 0.00 | $0.00 | INV-09.txt |
| PAPER NF GLOVE VINYL PWDR FREE XXL | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| PAPER NF INTERFOLD DISPENSER NAPKIN | looks dead | none in captured history | INV-01.txt–INV-37.txt | 10/04/2026: 0.00 | $0.00 | CNT-02.csv |
| SOUP MACARONI AND CHS | can't tell | none in captured history | missing: pair is (?) only | 10/04/2026: 18.00 | $0.00 | CNT-02.csv |
| ZZZ BREAD ROLL Breads SNGL SLI GLU FREE | can't tell | none in captured history | missing: pair is (?) only | 10/04/2026: 28.00 | $0.00 | CNT-02.csv |
| ZZZPAPER FD PLATE ROUND 9IN | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 0.45 | $0.00 | CNT-02.csv |
| ZZZPAPER NF LINER PAN SCRUB SAVER 1/6TH | can't tell | none in captured history | missing: no receipt of this Name in 05/15–08/13; qty not 0 on 10/04 | 10/04/2026: 2.00 | $0.00 | CNT-02.csv |

## P1

### Other Cheney item

none

## Deviations

- **Count history size:** expected about 10 Approved CARY 1 counts on or after 08/01/2026. The list (`CNT-01.txt`) has **one** in that window: 10/04/2026. 09/28 is In Progress (not used). 01/08/2026 is Approved but dated before 08/01/2026.
- **Item purchase history:** the Transactions tab is a dated view, but the 3-item probe showed **no purchase rows** (`ITM-01.txt`–`ITM-03.txt`, `ITM-03-missing.txt`). Older purchases came from the 37 invoices/credit memos instead, as the capture task requires when that history is missing.
- **Candidates vs 150:** invoices-122.md's **150** is the number of **lines** (08/14–10/09) whose Item does not prefix-match a 207 count name. Unique R365 items among those lines: **38** (this table). Unique full Item-column strings: 43.
- **`pages.csv`:** actions are only `view`, `filter`, `export`. No `scroll` (invoice grids were fully in the page text). No save / submit / approve / complete / post / create / edit / map path. Count detail (`countId=3`), item detail (`purchaseItemId=`), and AP forms are `view` (plus the one Item Details `export` and the AP-transactions `export`).

