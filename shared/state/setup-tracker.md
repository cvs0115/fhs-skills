# Setup tracker (backup copy)

Source of truth is the FHS Skills Hub artifact: https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc
Refresh this file from the hub at the end of every session. Status: not started / in progress / waiting on owner / done.

| Project | Store | Status | Current step | Waiting on |
|---|---|---|---|---|
| Payroll automation | 122, 878 | done (running biweekly) | - | - |
| R365 inventory + food cost | 122 | in progress | Phase 0 audit | Owner to sign in to R365 in browser pane |
| Electronic invoices | 122 | not started | - | Distributor name, how invoices arrive |
| R365 scheduling | 122 | not started | - | - |
| 878 move NCR → Toast/R365 | 878 | not started | - | Date from owner/franchise |
| 878 basic COGS (spreadsheet) | 878 | not started | - | - |

## Decisions log
- 2026-10-08: Created the Firehouse tech stack agent. Payroll stays in its own skill; this one routes to it.
  Inventory setup starts with store 122, weekly count on period-end Sunday.

## Open questions for the owner
1. Main distributor(s), and do invoices come on paper, by email, or electronically?
2. Do you count inventory now? How often, paper or spreadsheet?
3. "Other consumption": track paper, chemicals and smallwares too, or food only?
4. Does Firehouse corporate supply recipes/item lists in R365?
5. Target food cost % (franchise benchmark)?
