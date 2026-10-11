# Spec · cash-and-deposits · Daily cash and deposit check (fhs-cash-and-deposits)

2026-10-11 · Hub project: `projects/cash-and-deposits` · Plan page: https://claude.ai/artifact/YCyi9JzD9Gya12mkhwzMrT

Manager guide (draft, owner doc): https://claude.ai/code/artifact/272a1c26-db6b-458e-a789-3bc7364e4f6c. It becomes the skill's daily steps once walked on a real close.

Evidence so far: the 122 PC capture of 2026-10-11 (store-audit-122-02, files F8-01..F8-04, F9-01). The audit
note from that run is the reference once merged; this spec only uses what those captures show.

## Problem and today

- **Problem:** nobody can see, day by day, whether the money a store took in reached the bank. For 122 R365
  shows **Total Deposit $0.00** and a **negative Over/Short** on every day from 10/06 to 10/10/2026 (−$20.33 to
  −$208.16), the days stay **In Progress**, and R365 has **no bank reconciliations** at all.
- **Today:** Toast settles card payments to the bank daily, about 2 days after the sales day (October to date:
  card $8,917.23, payout $8,370.60, "External (not settled by Toast)" −$546.63). Toast tracks cash drawers per
  terminal (starting cash $250, cash payments, close-out). Cash deposits are not entered in R365, so cash
  shortages, missing deposits and third-party money (the −$546.63 line, DoorDash) go unnoticed until the bank
  statement or the P&L. Cost: blind spot on cash theft or loss, and R365 days never close.
- 10/05/2026 and earlier CARY 1 days show **Completed** in R365. How they were completed with $0 deposits is unknown.

## Who runs it

- The owner (or the store manager) once a day or once a week: "Did yesterday's money make it to the bank?"
  Claude answers per day: sales, card payout expected and received, cash expected and deposited, over/short, and
  what to fix, in plain words.
- Later a scheduled run (server move plan); enabling it is its own OK.

## Done when (measurable)

1. For 122, for 2 full weeks running: every day's card payout in Toast is matched to its sales day, and every
   day's expected cash deposit is shown next to what was actually deposited, with each difference over $5 listed.
2. The R365 daily sales days for those 2 weeks show the real deposit (not $0.00) and the owner or manager can mark them Completed.
3. The owner confirms on a real bank statement that the skill's "received" numbers match the bank, to the cent, for at least 5 days.

## In scope

- **P0:** 122 daily check: Toast sales and tenders → expected card payout and expected cash → compare with
  Toast payouts and the cash deposit record → list differences. Read-only in Toast and R365.
- **P1:** entering the daily deposit in R365 Daily Sales Summary (a write: needs the owner's yes per the Rules
  in `skills/fhs-skills/SKILL.md`), and explaining the −$546.63 "External" line (third-party delivery or other tenders).
- **P2:** 878 Camden Square, on NCR until it moves (`docs/specs/store-migration.md`: build at 122 first); bank
  reconciliation in R365; weekly summary for the daily flash (`projects/daily-flash`).

## Out of scope (parked on the hub)

- Third-party delivery payout matching in depth (delivery function, runbook row 12+).
- Labor dollars at $0 (staff with no pay rate in R365): a separate fix, found by the same audit.
- Moving money, paying anything, or changing bank settings. Never.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Daily sales, tenders | Toast | Toast Reports (Sales summary, Payments) screen or export | screen yes (F9-02, 2026-10-11); export `(?)` |
| Card payouts | Toast | Reports → Payments → Payout overview, one payout per day | screen yes (F8-02, F8-03) |
| Cash drawers | Toast | Reports → Cash & loss management → Cash drawer overview | screen yes, today only (F8-04) |
| Cash deposit made | each shift's deposit slip (Toast or paper `(?)`); the bank statement | slip photo or entry `(?)`; statement download by the owner | owner answer 2026-10-11; format `(?)` |
| Deposit recorded | R365 Daily Sales Summary → Deposits | screen | yes, all $0.00 (F9-01) |
| Bank statement | the bank (owner's account) | owner downloads CSV or PDF | owner answer 2026-10-11 |
| Payout bank account owner | Toast payouts settle under "Firehouse Subs Management Group" | screen | name seen; who owns the account `(?)` |

## Owner rules that bind it

- No passwords typed by Claude; one yes per change; money never moved (`skills/fhs-skills/SKILL.md` "Rules").
- Build at 122 first, then copy to 878 (spec `store-migration.md`, 2026-10-10).
- R365 settings may be franchise-owned: research says who owns a setting before a plan changes it (CLAUDE.md).

## Answers (owner, 2026-10-11)

- Cash: each **shift** counts its own drawer and does its own deposit slip, in Toast (associate). A manager takes the cash to the bank **every day**. The manager closes the day in R365. (Refined by the owner the same day; confirm with the manager on the first walk-through.)
- R365 days are closed by the owner or the manager (not the franchise or a bookkeeper). Bank reconciliation is not done in R365 today.
- Deposits are recorded **in R365 Daily Sales Summary** from now on, each entry with the owner's yes until the owner says otherwise.
- The 122 bank account is the **owner's**, and the owner can download statements (CSV or PDF).

## Open questions

- `(?)` What is the −$546.63 "External (not settled by Toast)" line? Research from Toast reports, no owner question.
- `(?)` Why Toast payouts show "Firehouse Subs Management Group" when the account is the owner's (likely the Toast group name only). Research.
- `(?)` How the R365 days up to 10/05/2026 were completed with $0 deposits. Ask the manager during research, not a design question.
