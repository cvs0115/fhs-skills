---
name: fhs-payroll-adp
description: Part of the fhs-skills library. Run biweekly payroll for the owner's Firehouse Subs stores (122 Cary 1, 878 Camden Square, and any store in the shared fhs-skills config) on either POS - NCR/Aloha or Toast + R365 - pull hours and tips from the reports in the store's Dropbox week folder, check for discrepancies (auto clock-outs, shared logins, missing shifts, hours that disagree between systems, tip payouts that don't follow the rule), calculate ADP figures (regular hours, OT, CC tips, Miguel's over-100-hour bonus), enter them in ADP RUN, and verify the Preview before the owner approves. Use this whenever the user mentions running payroll, doing payroll for a store or "all stores", the pay period / week folder, Toast or R365 labor or tip reports, NCR Time Clock Detail or Tip Income, ADP RUN entry, or tips/hours discrepancies - even if they don't say "skill".
---

# Firehouse Subs payroll: reports → checks → ADP RUN

The owner runs biweekly payroll for several Firehouse Subs stores. This skill turns the reports
for each store into a checked, paste-ready ADP RUN entry, then helps enter and verify it.
The owner always does the final **Approve** in ADP - payroll moves real money, so never click
Approve/Submit yourself, even if asked; say why and hand it back.

Everything store-specific (names, shared logins, who is excluded, salaried bonus rules, store
hours, R365 tip-rule jobs, which POS the store is on) lives in the shared fhs-skills config:
`C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\fhs-skills\config.json` (the scripts read it
automatically). Read it at the start of every run - the rules there came from the owner and override
anything you'd assume. Other fhs skills use the same file, so keep store facts there, not in this skill.

## Key facts (learned the hard way - keep them in mind)

- **Pay periods**: two weeks, Monday-Sunday, anchored on Mon 9/21/2026. All stores share the same periods.
  Payroll is due in ADP by 5:00 PM ET on the day after the period's check-processing date - ADP shows a banner.
- **Working folder** = the store's Dropbox week folder:
  `...\CMVK Food Services\Locations\<store 5 digits>\<year>\<MM MON>\Week <ISO week of the period's last Sunday>`
  (e.g. 122, 9/21-10/4/2026 → `00122\2026\10 OCT\Week 40`). The owner downloads reports there;
  the extracts, ADP entry file, discrepancy report and concerns note are saved there too.
- **Source of truth**: R365 for Toast/R365 stores (Toast must be kept aligned as a cross-check);
  NCR reports for NCR days (878 through 10/20/2026). 878 moved to Toast + R365 on 10/21/2026, so a
  pay period that spans the cut-over (10/19-11/1/2026) uses NCR files for 10/19-10/20 and R365 for 10/21 on.
  Tips for 10/19-10/20 come from NCR Tip Income, not R365 (R365 has no distribution for those days).
  See `docs/research/tip-automation-878.md`.
- **Data comes from files the owner downloads**, not from scraping. Browser pulling is a fallback
  only (see `references/browser-recipes.md`) - it's slow and fragile.
- **Never enter usernames/passwords.** Open the login page and let the owner sign in.
- Changing data in Toast/R365/ADP (fixing a punch, editing a tip rule, adding a shift) needs a clear
  yes from the owner for that specific change. Propose the exact change, wait, then do it and verify.

## Workflow (one store at a time, pause between stores)

When asked to "run payroll" for one store or all stores, process stores in the order given
(default: the order in config.json), finishing each one through ADP Preview before starting the next.

### 1. Set up the period and folder
```
py "<skill>/scripts/period.py" <store> [as-of YYYY-MM-DD]
```
Prints the pay period, Toast date strings, the file prefix (`<store>_<start>_<end>`) and the week
folder (created if missing). Use the last completed period unless the owner names another.
Confirm the period with the owner if it's at all ambiguous (e.g. running late).

### 2. Make sure the reports are in the folder
List the folder. Required reports depend on `pos` in config:

| pos | Reports the owner downloads into the week folder |
|---|---|
| `toast_r365` | R365 **Labor Payroll Review** (PDF; Detail view preferred - it has shifts and per-shift charge tips), R365 **Tip Automation Distributions Report** (PDF) if the manager approved tips, Toast **Labor Summary** or **Time Entries** export (cross-check + shift tips) |
| `ncr` | NCR **3.01 Time Clock Detail**, **Tip Income**, **Tips Breakout** (and Breakout W1/W2 if made) |

If something is missing, tell the owner exactly which report and date range to download, and wait.
Offer the browser fallback only if they'd rather you pull it.

### 3. Extract into the standard files
Read each report carefully and write the pipe-delimited files described in
`references/extract-formats.md` (`_hours`, `_shifts`, `_totals`, and `_tips` / `_crosscheck_hours`
when available). For `toast_r365` stores, also write `_tip_sources.txt` and `_tip_contributors.txt`
(see `extract-formats.md`) so the R365 tip-contributor check can run. Copy names exactly as the
source shows them; the script matches names loosely across systems. Always fill `_totals.txt` from
the report's own grand totals - the script compares your extraction against them, which is how
misreads get caught.

### 4. Calculate and check
From the week folder:
```
py "<skill>/scripts/payroll.py" <prefix>
```
It writes `<prefix>_adp_entry.csv` and `<prefix>_discrepancy_report.html`. Show the report to the
owner (SendUserFile with display=render) and summarize: totals, every High issue, and the Medium
ones that look real. If the script reports extraction totals don't match, re-read the report before
showing anything.

How tips are decided (the script does this; know it so you can explain it):
- `_tips.txt` present (R365 Tip Automation Distributions, or NCR Tip Income "Tip Share Earned") → those
  amounts go to ADP. When shift-level tips exist, the script also recomputes the R365 daily rule and
  flags anyone whose payout differs by more than $1 - this is how we check the manager approved tips
  correctly. The owner wants R365 tips used **and** independently validated.
- No `_tips.txt` (e.g. R365 days not calculated/approved yet) → the daily rule is used: each day's tips
  split by hours among the tip receiver jobs; tips not tied to a shift (kiosk) split by period hours.
- The total paid out must equal tips actually collected (Labor Summary / report total) to the cent.
  Toast's Pooled Tips report rounds each share and can be a few cents high - don't use its total.

**Discrepancy checks the script runs** (the owner wants these flagged, never silently decided):

| Severity | Check |
|---|---|
| High | Extracted hours don't match the report's grand totals (re-read before anything else) |
| High | Hours differ between systems (R365 vs Toast) / person in one system but not the other |
| High | Shift detail doesn't add up to the hours report |
| High | Likely auto clock-out (e.g. 2:00 AM), very long shift (>12 h), missing clock-out, overlapping shifts |
| High | Punch with no hours counted (in/out times but 0 paid) |
| High | Shared login has hours or tips; tips not fully paid out to the cent |
| High | Tip source missing from R365 contributors (Toast card tips that day, no matching contributor in R365) |
| High | Fixed-100-hr employee under 100 hours |
| Medium | Clock-in before open / clock-out after close (store hours ± buffer) |
| Medium | **Stayed after everyone else left** - after close, still on the clock 15+ min after the last coworker |
| Medium | **Repeated pattern** - same person, same flag 3+ times: one line listing the dates |
| Medium | Very short shift (<0.75 h), shift much longer than the person's usual, overtime (except fixed-100) |
| Medium | Tip payout differs from the tip rule by more than $1 (manager approval check) |
| Medium | Tip contributor check not run (`_tip_sources.txt` or `_tip_contributors.txt` missing while `_tips.txt` is present) |
| Info | Excluded people with hours, kiosk/non-employee tips, missing employee IDs |

When presenting flags, give **dates and times** (owners act on specifics: "Eleanor 10/4 out 10:40 PM,
16 min after Alonda"), and group repeats per person. Thresholds live in config `checks`.

### 5. Resolve discrepancies with the owner
Walk the owner through the issues and decide each one. Typical fixes from past runs:
- **Auto clock-out** (e.g. out at 2:00 AM) → ask the real out time; fix it in the source system
  (and Toast, so they agree).
- **Hours differ between systems** → find the missing/extra shift (e.g. a shift in R365 that never
  reached Toast) and fix the system that's wrong.
- **Shared logins** (Cashier1/Cashier2) → never paid; their tips go to real employees. Remind the
  owner staff should clock in under their own names.
- **Punch with no hours counted**, missing clock-out, overlap, very short shift → confirm with owner.
After any fix, re-download/re-extract the affected report and rerun step 4 until the High list is clean
or every remaining item is explicitly accepted by the owner.

### 6. Save every source report and list saved file names in run notes (required before ADP entry)
Export every source report used for this run into the store's Dropbox week folder, including
reports you read in the browser (see `references/browser-recipes.md` for R365 PDF export). Use clear
filenames with the period dates, e.g. `Labor Payroll Review (Detail) 10-05 to 10-18.pdf` and
`Tip Automation Distributions Report 10-05 to 10-18.pdf`. **List each saved file by name in your
reply to the owner** as part of the run notes so they can find the files later. Do not start ADP
entry until this is done.

### 7. Present the ADP entry
Give a paste-ready table in **ADP's employee order** (ADP sorts by last name) and **ADP's column
order: Regular Hours, Overtime Hours, CC Tips, Bonus**. Include zero rows for active ADP employees
with no hours, and a TOTAL row. Apply the store's `adp_notes` (e.g. salaried Miguel = 80 hours on
the salary line plus the bonus; Kevin on one line; Mayuri's salary needs nothing).

### 8. Enter in ADP RUN and verify
Follow `references/adp-entry.md`. In short: the owner signs in; open the store's company →
Run payroll for the right pay period; enter by clicking each cell directly (Tab is unreliable);
never refresh the page (it wipes unsaved entries - use "Finish later" to save); read the grid back
and compare every line and the totals to the table. Then the owner clicks **Preview payroll**; read
the Preview and check each gross = rate × hours + tips (+ bonus, + salary). Report "clear to approve"
or the exact lines to fix. The owner clicks **Approve**.

### 9. Write the concerns note, then move on
Save `<prefix>_concerns.md` in the week folder: what was fixed this run, what's still open, and
follow-ups (e.g. R365 tip days not approved, settings to change, people to talk to). Copy the list
of saved source-report file names from step 6 into the note. Then ask whether to continue with the
next store.

## Store-specific rules you'll see in the shared config.json
- `shared_logins`, `exclude_from_payroll`, `non_employee_accounts` (kiosk tips are real tips - split them)
- `fixed_100_hour_employees` + `biweekly_salary`: salary covers 100 hrs per period; bonus =
  (hours − 100) × salary/100; ADP gets 80 hrs on the salary line. Only flag if under 100 hrs.
- `tip_receiver_jobs`: must mirror the store's R365 tip rule receivers (Cashier is deliberately excluded).
- `checks`: store hours with buffers, auto clock-out times, tolerances.
When the owner tells you a new rule ("X is seasonal", "don't split Y", "Z gets tips"), update
config.json so the next run knows it, and tell them you did.

## Reference files
- `references/extract-formats.md` - the standard files and how to read each report into them
- `references/adp-entry.md` - ADP RUN grid entry and Preview verification, step by step
- `references/browser-recipes.md` - fallback: pulling Toast / R365 data in the browser pane,
  R365 report pop-up workaround, Toast time-entry fixes, R365 Tip Automation
