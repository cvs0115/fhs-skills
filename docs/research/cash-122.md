# Research · cash-122 · Cary 1 two weeks of money in → bank: what Toast and R365 really show

2026-10-13. Verify-only from PC captures in `/srv/fhs-build/reports/cash-122-captures/` (`pages.csv` plus `SAL-*`, `PAY-*`, `EXT-*`, `CDR-*`, `TDP-*`, `DSS-*`; no `BNK-*`). No browser was opened. Nothing in Toast or R365 was changed. Dates **09/28/2026–10/11/2026** (14 days). Restaurant **00122 - Cary 1**. R365 location **CARY 1**.

## Summary for the owner

Toast net sales match R365 Daily Sales Summary to the cent on all 14 days ($25,097.64).
Twelve of the 14 Toast payouts in this range match a sales day in the two weeks (settled about two days later); two payouts are unmatched because they cover 09/26 and 09/27; 10/10 and 10/11 have no payout yet.
External (not settled by Toast) for this range is **−$932.32**, and every expanded payout names it **Amex Direct** (American Express paid straight, not by Toast). That is not the sales-summary Other line (DoorDash / UberEats / GrubHub / digital).
No bank CSV was given, so whether the payout reached the bank stays unknown.
Toast has no cash-deposit record (Actual Deposit N/A every day). R365 on this capture shows Completed days with a Total Deposit filled (not the earlier audit’s $0.00).

## How cells were filled

- **Files:** `pages.csv`; `SAL-01.txt` / `SAL-01.png` (report home); `SAL-02.csv` / `SAL-02.txt` / `SAL-02.png` (Sales by day); `SAL-03.csv` (Payments summary, **period totals only**); `SAL-04.csv` (Cash summary); `SAL-05.csv` (Cash activity); `SAL-06.csv` (Net sales summary); `PAY-01.csv` / `PAY-01.txt` / `PAY-01.png` (Payout overview 09/28–10/11); `PAY-02.txt` / `PAY-02.png` (payout list); `PAY-03.txt`–`PAY-16.txt` (each payout’s detail, closed with Close); `EXT-01.txt` / `EXT-01.png` (External expander on the 10/11 payout); `CDR-01.txt` (Drawer History refused a multi-day range); `CDR-02.csv` / `CDR-02.txt` (Cash Activity Audit, 102 rows); `CDR-03.txt`–`CDR-16.txt` (Drawer History one day each); `CDR-17.csv` / `CDR-17.txt` (typed 14-day drawer summary); `TDP-01.txt` / `TDP-01.png` (Deposit Totals Overview = card settlements); `TDP-02-missing.txt` (no cash deposit report); `DSS-01.csv` / `DSS-01.txt` / `DSS-01.png` (CARY 1 DSS export; 364 CARY 1 days, 14 days taken from that file); `DSS-02.txt` / `DSS-02.png` (10/05 day panel); `DSS-03.txt` / `DSS-03.png` (10/05 Deposits area); `DSS-04-missing.txt` (Save-prompt stop). No `BNK-*`.
- **Date range:** Toast filters and this note use **09/28/2026–10/11/2026**. Restaurant **00122 - Cary 1** (`SAL-02.txt`, `PAY-01.txt`). R365 list filtered to **CARY 1** only (`DSS-01.txt`); date was not filtered on screen (see Deviations).
- **Toast net sales:** `SAL-02.csv` column Net sales (Sales summary → Sales by day). Report: Sales summary. Path: Reports > Sales > Sales summary `https://www.toasttab.com/restaurants/admin/reports/sales/sales-summary?startDate=20260928&endDate=20261011` (`SAL-02.txt`).
- **Card and External/other:** `SAL-03.csv` is the whole 14 days, not per day (`SAL-02.txt`: “Tenders are NOT split per day”). There is no External label on Sales summary; third-party and digital tenders sit under Other. Per-day Card and External/other are `(?) not split per day (SAL-03.csv)`. Period Other is $14,007.20 (DoorDash Payment $3,593.44, UberEats Payment $3,549.56, GrubHub Payment $357.30, plus digital cards). That period Other is not copied onto each day and is not the Payout External line.
- **Cash:** Sales summary does not split cash per day (`SAL-03.csv` Cash $1,155.72 for the period). Per-day cash is **Total cash payments** on Cash Drawer History (`CDR-17.csv`, `CDR-03.txt`–`CDR-16.txt`). Those 14 figures sum to $1,155.72, matching `SAL-03.csv` and `CDR-02.csv` CASH_PAYMENT rows.
- **Toast payout (date + amount):** matched from payout **detail** (`PAY-03.txt`–`PAY-16.txt` plus `PAY-01.csv`). Sales day = the local restaurant day of the detail’s Time period / sales period (CSV times are about four hours later than the on-screen local times, `PAY-02.txt`). Example: settled 10/11 covers Fri 10/09 11:26 AM–7:53 PM (`PAY-03.txt`). If that local day is not one of the 14 dates, the payout is `unmatched` on **Payouts** and does not fill a Days cell. `none` when no payout in this range covers that sales day.
- **Expected cash deposit:** Toast **Total cash payments** minus **Pay Out** as Drawer History shows them (`CDR-03.txt`–`CDR-16.txt`, `CDR-17.csv`). Pay Out is **$0.00** every day. The 09/28 Cash In +$50.00 / Cash Out −$50.00 is not Pay Out (`CDR-03.txt`). Toast’s **Expected Deposit** field (actual closeout minus $250.00 starting cash, `CDR-17.txt`) is **not** this column; it includes over/short. Payout overview **card** amounts are not subtracted.
- **Toast-recorded deposit:** `none`. Drawer History **Actual Deposit** is N/A on all 14 days (`CDR-17.csv`). `TDP-02-missing.txt`: no cash deposit / “cash out / deposit” record. `TDP-01.txt` is a **card** settled-deposits report, not a cash deposit.
- **R365 DSS deposit and Over/Short:** `DSS-01.csv` columns Total Deposit and Over/Short for Location CARY 1 and that Date. All 14 days Status **Completed**. This capture’s deposits are **not** $0.00 (the audit’s 10/06–10/10 $0.00 figures are not used).
- **Bank:** no `BNK-*` in the capture folder. Every Bank cell is `(?) no bank CSV`. Heading **Bank match** is omitted.

## Days

| Date | Toast net sales | Card | Cash | External/other | Toast payout (date + amount) | Expected cash deposit | Toast-recorded deposit | R365 DSS deposit | R365 Over/Short | Bank |
|---|---|---|---|---|---|---|---|---|---|---|
| 09/28/2026 | $1,576.60 | (?) not split per day (SAL-03.csv) | $133.89 | (?) not split per day (SAL-03.csv) | 09/30/2026 $680.87 | $133.89 | none | $133.89 | -$0.33 | (?) no bank CSV |
| 09/29/2026 | $1,698.33 | (?) not split per day (SAL-03.csv) | $61.78 | (?) not split per day (SAL-03.csv) | 10/01/2026 $842.33 | $61.78 | none | $61.78 | $0.10 | (?) no bank CSV |
| 09/30/2026 | $1,711.28 | (?) not split per day (SAL-03.csv) | $56.82 | (?) not split per day (SAL-03.csv) | 10/02/2026 $740.47 | $56.82 | none | $56.82 | $0.00 | (?) no bank CSV |
| 10/01/2026 | $1,876.07 | (?) not split per day (SAL-03.csv) | $66.51 | (?) not split per day (SAL-03.csv) | 10/03/2026 $726.72 | $66.51 | none | $66.51 | -$0.32 | (?) no bank CSV |
| 10/02/2026 | $2,500.00 | (?) not split per day (SAL-03.csv) | $63.56 | (?) not split per day (SAL-03.csv) | 10/04/2026 $1,302.29 | $63.56 | none | $63.56 | $0.25 | (?) no bank CSV |
| 10/03/2026 | $1,784.50 | (?) not split per day (SAL-03.csv) | $71.34 | (?) not split per day (SAL-03.csv) | 10/05/2026 $548.74 | $71.34 | none | $71.34 | $0.00 | (?) no bank CSV |
| 10/04/2026 | $1,400.61 | (?) not split per day (SAL-03.csv) | $79.42 | (?) not split per day (SAL-03.csv) | 10/06/2026 $503.28 | $79.42 | none | $79.42 | $0.00 | (?) no bank CSV |
| 10/05/2026 | $1,936.29 | (?) not split per day (SAL-03.csv) | $68.89 | (?) not split per day (SAL-03.csv) | 10/07/2026 $908.86 | $68.89 | none | $68.89 | $0.00 | (?) no bank CSV |
| 10/06/2026 | $1,745.26 | (?) not split per day (SAL-03.csv) | $149.96 | (?) not split per day (SAL-03.csv) | 10/08/2026 $929.19 | $149.96 | none | $148.77 | $0.00 | (?) no bank CSV |
| 10/07/2026 | $1,904.10 | (?) not split per day (SAL-03.csv) | $56.88 | (?) not split per day (SAL-03.csv) | 10/09/2026 $898.63 | $56.88 | none | $58.11 | $0.00 | (?) no bank CSV |
| 10/08/2026 | $1,908.04 | (?) not split per day (SAL-03.csv) | $20.38 | (?) not split per day (SAL-03.csv) | 10/10/2026 $970.09 | $20.38 | none | $20.33 | $0.00 | (?) no bank CSV |
| 10/09/2026 | $2,046.26 | (?) not split per day (SAL-03.csv) | $204.16 | (?) not split per day (SAL-03.csv) | 10/11/2026 $859.70 | $204.16 | none | $208.16 | $0.00 | (?) no bank CSV |
| 10/10/2026 | $1,693.17 | (?) not split per day (SAL-03.csv) | $98.47 | (?) not split per day (SAL-03.csv) | none | $98.47 | none | $98.48 | $0.00 | (?) no bank CSV |
| 10/11/2026 | $1,317.13 | (?) not split per day (SAL-03.csv) | $23.66 | (?) not split per day (SAL-03.csv) | none | $23.66 | none | $23.87 | $0.00 | (?) no bank CSV |

## Net sales

| Date | Toast net sales | R365 DSS net sales | Delta |
|---|---|---|---|
| 09/28/2026 | $1,576.60 | $1,576.60 | $0.00 |
| 09/29/2026 | $1,698.33 | $1,698.33 | $0.00 |
| 09/30/2026 | $1,711.28 | $1,711.28 | $0.00 |
| 10/01/2026 | $1,876.07 | $1,876.07 | $0.00 |
| 10/02/2026 | $2,500.00 | $2,500.00 | $0.00 |
| 10/03/2026 | $1,784.50 | $1,784.50 | $0.00 |
| 10/04/2026 | $1,400.61 | $1,400.61 | $0.00 |
| 10/05/2026 | $1,936.29 | $1,936.29 | $0.00 |
| 10/06/2026 | $1,745.26 | $1,745.26 | $0.00 |
| 10/07/2026 | $1,904.10 | $1,904.10 | $0.00 |
| 10/08/2026 | $1,908.04 | $1,908.04 | $0.00 |
| 10/09/2026 | $2,046.26 | $2,046.26 | $0.00 |
| 10/10/2026 | $1,693.17 | $1,693.17 | $0.00 |
| 10/11/2026 | $1,317.13 | $1,317.13 | $0.00 |

### Net sales differences

none

## Payouts

| Payout date | Amount | Card | Fees | External | Sales day | Capture |
|---|---|---|---|---|---|---|
| 09/28/2026 | $795.16 | $887.63 | $0.00 | -$92.47 | unmatched | PAY-16.txt |
| 09/29/2026 | $809.95 | $925.97 | $0.00 | -$116.02 | unmatched | PAY-15.txt |
| 09/30/2026 | $680.87 | $755.11 | $0.00 | -$74.24 | 09/28/2026 | PAY-14.txt |
| 10/01/2026 | $842.33 | $842.33 | $0.00 | $0.00 | 09/29/2026 | PAY-13.txt |
| 10/02/2026 | $740.47 | $791.46 | $0.00 | -$50.99 | 09/30/2026 | PAY-12.txt |
| 10/03/2026 | $726.72 | $781.16 | $0.00 | -$54.44 | 10/01/2026 | PAY-11.txt |
| 10/04/2026 | $1,302.29 | $1,378.69 | $0.00 | -$76.40 | 10/02/2026 | PAY-10.txt |
| 10/05/2026 | $548.74 | $630.40 | $0.00 | -$81.66 | 10/03/2026 | PAY-09.txt |
| 10/06/2026 | $503.28 | $553.36 | $0.00 | -$50.08 | 10/04/2026 | PAY-08.txt |
| 10/07/2026 | $908.86 | $943.72 | $0.00 | -$34.86 | 10/05/2026 | PAY-07.txt |
| 10/08/2026 | $929.19 | $929.19 | $0.00 | $0.00 | 10/06/2026 | PAY-06.txt |
| 10/09/2026 | $898.63 | $981.26 | $0.00 | -$82.63 | 10/07/2026 | PAY-05.txt |
| 10/10/2026 | $970.09 | $1,085.66 | $0.00 | -$115.57 | 10/08/2026 | PAY-04.txt |
| 10/11/2026 | $859.70 | $962.66 | $0.00 | -$102.96 | 10/09/2026 | PAY-03.txt |

Unmatched payouts cover sales days **before** 09/28/2026: settled 09/28 covers 09/26 (`PAY-16.txt` / `PAY-01.csv` sales period start 09/26/2026 14:34:42); settled 09/29 covers 09/27 (`PAY-15.txt`). Sales days 10/10 and 10/11 have no payout in this overview (data as of Oct 11, `PAY-01.txt`).

## Payout totals

Payout overview **card** total for 09/28–10/11: **$12,448.60** (`PAY-01.txt`, `PAY-01.csv` Payments sum). Fees $0.00, External **−$932.32**, payout total **$11,516.28** (`PAY-01.txt`). Not the audit month-to-date $8,917.23 / −$546.63 / $8,370.60.

Sum of **Card** on rows whose Sales day is not `unmatched`: **$10,635.00**. Unmatched count: **2**. Those two figures differ because two payouts in the range cover 09/26 and 09/27.

## External

Payout overview **External (not settled by Toast)** for 09/28–10/11: **−$932.32** (`PAY-01.txt`, `PAY-01.csv` External column sum $932.32 subtracted from card).

On each payout detail the External line expands to one type, **Amex Direct** (American Express card sales Amex pays directly; Toast does not settle them). Example: 10/11 payout, Payments $102.96, Refunds $0.00, Net $102.96 (`EXT-01.txt`, `PAY-03.txt`). Payouts settled 10/08 and 10/01 show no External expander (`PAY-06.txt`, `PAY-13.txt`). Every expanded payout in `PAY-03.txt`–`PAY-16.txt` that has an External amount is Amex Direct only (`EXT-01.txt`).

Days **External/other** is not a per-day number (Sales summary did not split tenders by day). The period Other tender on `SAL-03.csv` is **$14,007.20**, which is not equal to −$932.32 and is not forced equal. Toast names DoorDash Payment, UberEats Payment, and GrubHub Payment on that Other line; they are not the Payout External type.

## Rules

**Payout ↔ sales day:** a payout is matched to exactly one sales day: the local restaurant day of the payout detail’s Time period (the same window as `PAY-01.csv` Sales period start/end, shown local on screen and about four hours later in the CSV, `PAY-02.txt`). If that day is not in 09/28–10/11, the payout is `unmatched`.

**Expected cash:** Toast Total cash payments minus Pay Out on Cash Drawer History for that day. Pay Out was $0.00 every day, so expected cash equals Total cash payments. Starting cash $250.00 stays in the drawer and is not subtracted here. Card payout amounts are not subtracted.

Examples from this capture:

1. Payout settled **10/11/2026 $859.70** covers sales **10/09/2026** (Time period Fri 10/9/26 11:26 AM–7:53 PM; card $962.66, External −$102.96 Amex Direct) (`PAY-03.txt`).
2. Payout settled **10/10/2026 $970.09** covers sales **10/08/2026** (`PAY-01.csv` sales period 10/08/2026 14:01:24–10/09/2026 00:37:10 UTC-style = local 10/08; card $1,085.66) (`PAY-04.txt`).
3. Expected cash **09/28/2026**: Total cash payments **$133.89** minus Pay Out **$0.00** = **$133.89**. Cash In +$50.00 and Cash Out −$50.00 are not Pay Out (`CDR-03.txt`, `CDR-17.csv`).

## Who owns what

| Setting | Owner | Capture |
|---|---|---|
| Toast payout group name (Firehouse Subs Management Group / 00122 - Cary 1 on the location picker) | unknown | PAY-01.txt |
| External (not settled by Toast); expander type Amex Direct | unknown | EXT-01.txt |
| Cash drawer (legacy Drawer History / Cash Activity Audit; starting cash $250.00; Pay Out $0.00) | unknown | CDR-03.txt |
| Toast cash deposit / cash-out record (none; Actual Deposit N/A) | unknown | TDP-02-missing.txt |
| R365 DSS Deposits fields (Deposit #1, Total Deposit, bill counts, Total Cash / Coin / Check, Unpaid Cash Tips) | unknown | DSS-03.txt |
| Over/Short formula as shown (top card 00.00 on 10/05; formula not on screen) | unknown | DSS-03.txt |
| Status / Complete control (label: UNLOCK on a Completed locked day; no Complete button seen; not clicked) | unknown | DSS-02.txt |
| Completed CARY 1 day 10/05 (who/when completed (?); Total Deposit $68.89; Over/Short 00.00) | unknown | DSS-02.txt |

No Brand / franchise / “managed by” / Created by / Modified by label was on these Toast report or R365 DSS screens (`PAY-01.txt`, `DSS-02.txt`). UNLOCK and SAVE were not clicked (`DSS-02.txt`, `DSS-03.txt`).

## Deviations

- The PC session could not see the owner’s named tab group and used its own tab group in the same signed-in Chrome profile (`DSS-04-missing.txt`).
- A Toast cookie-consent dialog was dismissed with its close button; no consent option was chosen (`DSS-04-missing.txt`).
- The DSS list was filtered to CARY 1 but not by date, so `DSS-01.csv` holds all **364** CARY 1 days. The 14 days are the newest 14 rows in that export (`DSS-01.txt`).
- Payout details after 10/11 were reached by stepping the **date arrows** on the payout detail page instead of opening each list row (`PAY-04.txt`–`PAY-16.txt`, `DSS-04-missing.txt`). The 10/11 payout was opened from the list (`PAY-03.txt`). Details were closed with Close.
- Expanding Deposits on the **10/05** CARY 1 day made **Save** clickable (`DSS-03.txt`). Save was **not** clicked. Closing the panel raised Save Changes? (CANCEL / NO / YES). The agent clicked none of those (`DSS-04-missing.txt`). The owner closed the dialog with **NO**. Nothing was saved, unlocked, completed, or edited.
