# Research · count-sheet-122 · Who owns the Cary 1 count sheet, the owner's tick list, how store runs could reach R365

2026-10-12. Verify-only from files in `/srv/fhs-build/reports/count-sheet-122-captures/` plus the 45 Names, 10/04 qty, and last Cheney receipt in `docs/research/count-lines-122.md`. No browser was opened. Nothing in R365 was changed. Keep? is blank for the owner. The hide is not this note.

## Summary for the owner

- R365 made the Cary 1 weekly count sheet (created by R365 DSS User on 03/11/2026, last changed by R365 on 10/06/2026). Camden Square has a separate copy with 207 items, not the same record.
- This login does not show a Remove-from-template or Inactivate button on that sheet. On the three items checked, Active looks locked and SAVE is greyed. There is no per-location "count at location" switch.
- No Costco, Sam's, Walmart, Food Lion, Harris Teeter, store, or petty vendor. A blank AP invoice form can be typed by hand (closed without saving). No expense, receipt, or credit-card screen. Cary 1 has 0 non-Cheney AP rows since 05/15/2026.

## How cells were filled

- **This job's captures:** `pages.csv`; `TPL-01.txt` templates list; `TPL-02.txt` / `TPL-02.png` **CARY 1 - FHS Weekly Inventory** detail; `TPL-03.csv` / `TPL-03.txt` CARY 1 item-grid export (207 data rows); `TPL-04.txt` **CAMDEN SQUARE - FHS Weekly Inventory** header only; `ITM-01.txt`–`ITM-03.txt` **BEV APPLE JUICE ALL**; `ITM-04.txt`–`ITM-06.txt` **CLEAN MOP HEAD**; `ITM-07.txt`–`ITM-09.txt` **PAPER FD SM SALAD BOWL**; `VND-01.txt` / `VND-01.csv` Vendors list (114); `VND-02.txt` Costco; `VND-03.txt` Sam; `VND-04.txt` Walmart; `VND-05.txt` Food Lion; `VND-06.txt` Harris Teeter; `VND-07.txt` store; `VND-08.txt` petty; `APF-01.txt` blank AP invoice; `EXP-01.txt`–`EXP-04.txt` menus searched; `EXP-05-missing.txt` none titled expense / receipt / credit-card; `TXN-01.txt` / `TXN-02.csv` AP transactions. PNG files sit next to those `.txt` files and were not used to fill a cell the text does not show.
- **Tick list Name, 10/04 qty, Last Cheney receipt:** copied from `docs/research/count-lines-122.md` `## Item table` rows whose Group is **looks dead**. Not from this capture. 10/04 qty is the number after `10/04/2026:` in that row's Count quantities. Last Cheney receipt is that row's Last Cheney receipt cell, copied exactly.
- **Category:** longest match at the start of Name from `BEV`, `CLEAN`, `PAPER FD`, `PAPER NF`, `NON REV`, `DAIRY`, `COUNT`, `Catering`, `CO2`, `P-`. Every Name matched one.
- **Keep?:** left blank on every row.
- **CAMDEN vs CARY 1:** compared `templateId` / URL, created/modified, and item count only. `TPL-01.txt` is two list rows. `pages.csv` has `?templateId=<redacted>` then `?templateId=<redacted-camden>`. `TPL-04.txt` says the CAMDEN id differs from CARY 1. CAMDEN was header only; its item list was not used.
- **Vendor searches with no row:** Costco (`VND-02.txt`), Sam (`VND-03.txt`; the Sam's search as captured), Walmart (`VND-04.txt`), Food Lion (`VND-05.txt`), Harris Teeter (`VND-06.txt`), store (`VND-07.txt`), petty (`VND-08.txt`). Each is 0 rows. `VND-01.csv` has no Name containing those terms. Those searches are not store-run ways.
- **Blank AP form:** opened as view at `#/form/APInvoiceForm/00000000-0000-0000-0000-000000000000` (`pages.csv`, `APF-01.txt`). Closed with the form's X (Close), never Save; no save prompt; no invoice saved.
- **Expense / receipt / credit-card:** none found. `EXP-05-missing.txt` plus the menus in `EXP-01.txt`–`EXP-04.txt` are that evidence, not a way.
- **F5 expected size only** (not this check's ownership evidence): store-audit-122 F5 listed creator R365 DSS User, modifier R365 10/06/2026, CAMDEN twin with 207 items. This capture's `TPL-01.txt` shows the same list values.

## Tick list

Owner ticked 2026-10-12 on the tick page (https://claude.ai/artifact/LY4J82C4J5XRzrmWhhpukk, db `ticks/cary1-45`) and confirmed in Claude Code: **44 hide, 1 keep**.

| Name | Category | 10/04 qty | Last Cheney receipt | Keep? |
|---|---|---|---|---|
| BEV APPLE JUICE ALL | BEV | 0.00 | none in captured history | hide |
| BEV CCF AHA BLUEBERRY POM | BEV | 0.00 | none in captured history | hide |
| BEV CCF CAFFEINE FREE DIET COKE | BEV | 0.00 | none in captured history | hide |
| BEV CHOCOLATE MILK | BEV | 0.00 | none in captured history | hide |
| BEV MILK SS | BEV | 0.00 | none in captured history | hide |
| BEV POWERADE | BEV | 0.00 | none in captured history | hide |
| Catering Chips - 1001442 | Catering | 0.00 | none in captured history | hide |
| CLEAN CLEANER ALL PURPOSE/GLASS 3 N | CLEAN | 0.00 | none in captured history | hide |
| CLEAN CLEANER FLOOR LIQUID | CLEAN | 0.00 | none in captured history | hide |
| CLEAN COMET SPRAY W/ BLEACH | CLEAN | 0.00 | none in captured history | hide |
| CLEAN FLOOR SPIC SPAN | CLEAN | 0.00 | none in captured history | hide |
| CLEAN MOP HEAD | CLEAN | 0.00 | none in captured history | hide |
| CLEAN PAD SCRUB STNLS 1.75OZ | CLEAN | 0.00 | none in captured history | hide |
| CLEAN SANITIZER HAND | CLEAN | 0.00 | none in captured history | hide |
| CLEAN SANITIZER NO RINSE SINK | CLEAN | 0.00 | none in captured history | hide |
| CLEAN STRIP TEST TAPE QUAT | CLEAN | 0.00 | none in captured history | hide |
| CLEAN VINEGAR WHITE DISTILLED | CLEAN | 0.00 | none in captured history | hide |
| CO2 | CO2 | 0.00 | none in captured history | hide |
| COUNT ALL CHIPS | COUNT | 0.00 | none in captured history | hide |
| DAIRY SHREDDED MOZZARELLA - 1001276 | DAIRY | 0.00 | none in captured history | hide |
| DAIRY SWISS - 1001283 | DAIRY | 0.00 | none in captured history | hide |
| NON REV A1 STEAK BTL | NON REV | 0.00 | none in captured history | hide |
| NON REV Garlic Chips - 1340968 | NON REV | 0.00 | none in captured history | hide |
| NON REV HONEY MUSTARD - 1004033 | NON REV | 0.00 | none in captured history | hide |
| NON REV LTO Caramelized Onions - 1052395 | NON REV | 0.00 | none in captured history | hide |
| NON REV OIL CANOLA OLIVE BLEND - 1001331 | NON REV | 0.00 | none in captured history | hide |
| NON REV ONION GARLIC FRESNO MARINATED - 1340985 | NON REV | 0.00 | none in captured history | hide |
| NON REV PICKLE PLANK SPICY - 1341051 | NON REV | 0.00 | none in captured history | hide |
| NON REV PKT SAUCE LOUISIANA | NON REV | 0.00 | none in captured history | hide |
| NON REV SAUCE GARLIC AIOLI | NON REV | 0.00 | none in captured history | hide |
| NON REV SAUCE GREEN JALAPENO SAUCE | NON REV | 0.00 | none in captured history | hide |
| NON REV SAUCE HOT TEXAS PETE | NON REV | 0.00 | none in captured history | hide |
| NON REV SEASONING CARMELIZED VEGETABLE - 1138068 | NON REV | 0.00 | none in captured history | hide |
| NON REV SPICE RED PEPPER FLAKES - 1002638 | NON REV | 0.00 | none in captured history | hide |
| NON REV SUGAR SUB BLUE PACKET | NON REV | 0.00 | none in captured history | hide |
| NON REV SUGAR SUB YELLOW PACKET | NON REV | 0.00 | none in captured history | hide |
| P-Garlic Fresno Marinated Onion 1 oz | P- | 0.00 | none in captured history | hide |
| PAPER FD CUP PRTN SOUFFLE 2-3 OZ | PAPER FD | 0.00 | none in captured history | hide |
| PAPER FD FILM PVC ROLL 18X2000 CLING | PAPER FD | 0.00 | none in captured history | hide |
| PAPER FD LID PRTN SOUFFLE 2.5 OZ | PAPER FD | 0.00 | none in captured history | hide |
| PAPER FD SM SALAD BOWL | PAPER FD | 0.00 | none in captured history | hide |
| PAPER FD STRAW PLAS JMBO WRPD RED 7.75 | PAPER FD | 0.00 | none in captured history | hide |
| PAPER NF GLOVE VINYL POWD FREE LG | PAPER NF | 0.00 | none in captured history | hide |
| PAPER NF GLOVE VINYL PWDR FREE XXL | PAPER NF | 0.00 | none in captured history | hide |
| PAPER NF INTERFOLD DISPENSER NAPKIN | PAPER NF | 0.00 | none in captured history | keep |

## Template ownership

| Q | Answer | Capture |
|---|---|---|
| (a) Can the owner's role remove an item or mark it inactive for CARY 1? | seen: not shown — no Remove from template or Inactivate control on CARY 1 template detail (`TPL-02.txt`) or on the item Templates tab (`ITM-02.txt`; ADD TO TEMPLATE enabled, not clicked). seen: greyed — Active (checkmark, read-only look) and SAVE on Settings (`ITM-03.txt`). No "count at location" control (`ITM-03.txt`). Header and grid kebab menus were shown and not opened (`TPL-02.txt`). | TPL-02.txt |
| (b) Is CAMDEN SQUARE - FHS Weekly Inventory the same record or a separate copy? | seen: separate copy — different `templateId` / URL (`TPL-04.txt`; `pages.csv` `templateId=<redacted>` vs `templateId=<redacted-camden>`); two list rows (`TPL-01.txt`). CARY 1: 207 items, created 03/11/2026 by R365 DSS User, Modified 10/06/2026 by R365 (`TPL-02.txt`). CAMDEN header: 207 items, Created 03/11/2026 R365 DSS User, Modified 10/06/2026 R365 (`TPL-04.txt`). | TPL-04.txt |
| (c) Any sign of a brand/R365 push (location group, "managed by", modified-by history)? | seen: Modified 10/06/2026 by R365 (`TPL-02.txt`; list `Modified 10/06/2026 R365` on `TPL-01.txt`). Created 03/11/2026 by R365 DSS User (`TPL-02.txt`). No location group or "managed by" on the template (`TPL-02.txt`). No history/audit tab shown (`TPL-02.txt`). Item Brand "Firehouse Subs" and Location Group "Firehouse Subs" (`ITM-01.txt`). | TPL-02.txt |

### Item settings (3 of 45)

| Name | Per-location or count-template setting | Capture |
|---|---|---|
| BEV APPLE JUICE ALL | not shown (ITM-03.txt). Active (greyed checkmark, one global flag); SAVE greyed. Templates tab: weekly Inventory Counts for CAMDEN SQUARE and CARY 1 (ITM-02.txt). | ITM-03.txt |
| CLEAN MOP HEAD | not shown (ITM-06.txt). Active (greyed checkmark, one global flag); SAVE greyed. Templates tab: weekly Inventory Counts for CAMDEN SQUARE and CARY 1 (ITM-05.txt). | ITM-06.txt |
| PAPER FD SM SALAD BOWL | not shown (ITM-09.txt). Active (greyed checkmark, one global flag); SAVE greyed. Templates tab: weekly Inventory Counts for CAMDEN SQUARE and CARY 1 (ITM-08.txt). | ITM-09.txt |

## Store runs

| Way | Where | Capture |
|---|---|---|
| Blank AP invoice form. Field labels: Location*, Vendor*, Invoice Number*, Document Date*, GL Date*, Document Amount, Payment Terms, Due Date, Credit Expected, Comment, Priority, Mark as Paid, Link to Asset, Payment Hold. Tabs: Details, Apply. Detail row: Select Account, Amount, Comment, Location, Add, Clear. Upload File. Top: Save, Approve, Action. Closed with X (Close), never Save. | Accounting → AP transactions → Create → AP invoice; `https://fhs4021089.restaurant365.com/#/form/APInvoiceForm/00000000-0000-0000-0000-000000000000` | APF-01.txt |

CARY 1 non-Cheney AP rows since 05/15/2026: 0
