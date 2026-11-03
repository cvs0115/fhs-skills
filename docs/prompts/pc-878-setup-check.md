# PC task · 878 setup facts for the payroll skill (read-only)

For the Claude session on the owner's Windows PC. The owner is signed in to Toast and R365. **Read only: do not click Save,
Approve, Unlock or Delete anywhere, and never type a password.** Plain words in the answer. Mark anything you could not confirm `(?)`.

Why: store 878 Camden Square moved to Toast + R365 on 10/21/2026 and the payroll skill dropped NCR. Its `shared/config.json`
entry is missing a few facts, listed below. Do not edit `config.json`; report back and the server session will.

## Find these (878 only)

1. **Kiosk account.** The exact name R365 prints for 878's kiosk in Labor Details / Tip Distributions for 10/21 to 10/31
   (Cary's is `KIOSK KIOSK - 550`). Also how Toast shows it (employee list or time entries). Give every spelling you see.
2. **Other shared or non-person accounts at 878.** Any login that is not one person (like Cary's `Cashier1 Cashier1`,
   `Cashier2 Cashier2`, `Cary NC`). List name and job for each, and whether it has hours or tips in 10/21 to 10/31.
3. **Toast location name** for 878 as Toast prints it (Cary's is `00122 - Cary 1`) and the **restaurant group id** in the
   Toast report URL (Cary's is a long number in the address after `restaurantGroupId` or similar). Copy only the id, not the whole URL.
4. **10/19 and 10/20 in R365.** Does R365 Labor Payroll Review show any hours for 878 on 10/19 or 10/20 (imported from NCR)?
   Yes or no, and the total if yes. This decides whether those two days could be counted twice.
5. **Shifts that cross the cut-over.** Any 878 punch that starts on 10/20 and ends on or after 10/21? List name, in, out.
6. **Report availability.** Which 878 reports for 10/21 to 11/1 already sit in the Dropbox week folder
   (path `...\Locations\00878\2026\...\Week <n>`; the last Sunday of the period is 11/1, so ISO week 44). File names only.

## Check, don't change (for the owner)

7. **Git on this PC.** Run `git status` and `git log --oneline -3` in the PC copy of fhs-skills and report them.
   Do **not** pull, push or reset. The server pushed `main` to https://github.com/cvs0115/fhs-skills; the PC mirror refresh needs the owner's OK.
8. **Open owner items** (do not do them; just say whether each is done): Toni Langley changed to hourly in ADP;
   R365 tip distributions for 10/21 to 10/27 approved.

## Answer format

A short list numbered 1 to 8 with the facts. No screenshots of pay data in the chat; names and numbers are enough.
Paste it to the server session, which will update `config.json` (own OK) and `docs/research/tip-automation-878.md`.
