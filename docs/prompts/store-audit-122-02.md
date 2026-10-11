# Agent task · store-audit-122-02 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan (`docs/reviews/store-audit-122-02.md`: APPROVE).
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/store-audit-122-02`
> and tell it "Do the task in docs/prompts/store-audit-122-02.md". Start only after Ops has copied and unzipped the inbox zip into `/srv/fhs-build/reports/store-audit-122-captures/`.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) uses Toast and R365. Labor and tips already
work for payroll. This task is the read-only F1 audit: from PC captures only, record what R365 and
Toast already do for each back-office function F2–F13, plus licensed modules, Toast → R365
integration (last sales and labor import dates), and who owns each setting. You never open a
browser. The planner uses the note to decide what to build, verify, or leave to the franchise.

## Where you work

- Workspace: `/srv/fhs-build/store-audit-122-02`, your own clone of the repo. Work only here.
- Branch: create `feat/store-audit-122-02` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- Captures (read only, outside the repo, already unzipped for you): `/srv/fhs-build/reports/store-audit-122-captures/`.
  File names are `<area>-<nn>.png` / `.txt` (and allowed report exports), plus `pages.csv` (time, URL, action = view/filter/export).

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/store-audit-122-02.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/store-audit-122.md`
4. `docs/specs/store-migration.md` (the F2–F13 catalog)
5. `docs/prompts/store-audit-122-02-capture.md` (expected capture names and pages)
6. `skills/fhs-skills/references/tech-stack.md` (append one section later; do not treat its existing "Store 122 screen check" as this audit's evidence)

## Steps

1. `git switch -c feat/store-audit-122-02`.
2. Confirm the captures folder exists and contains `pages.csv`. List the files. If the folder is missing, empty, or has no `pages.csv`, stop and write the report with that reason.
3. **Hard rule: captures folder only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them.
4. From those files only, write `docs/research/store-audit-122.md`. Start with `# Research · store-audit-122 · What R365 and Toast already do for store 122` and the date, then:

   1. **Summary table** — one row each for M0 (Licensed modules), F2–F13, I1 (Toast → R365 integration), O1 (Who owns what):

      | ID | Function | Status (in place / partial / missing / can't tell) | Evidence (system → menu path; capture file) | Owner (owner / franchise / R365 support / unknown) | Note |

   2. **One section per F-row (F2–F13)** with the details (counts, dates, sample items, what's missing). Write numbers, not adjectives. Unconfirmed menu paths: `(?)`.
   3. **`## Licensed modules`** — status, evidence (menu path + capture file), owner, then what is visible and what the owner's role can open.
   4. **`## Toast → R365 integration`** — status, evidence, owner, **last sales import date**, **last labor import date**, and any errors shown.
   5. **`## Who owns what`** — status, evidence, owner, then settings that look franchise-managed.

   Status comes only from the captures. If a row has no usable capture, status is `can't tell` and evidence names what is missing. Do not copy numbers from the existing tech-stack screen check unless the capture shows them. If a capture answers hub q1–q5 (distributor and invoice method; whether counts happen today; food only or also paper and chemicals; corporate-provided recipes or items; food cost target), put it in that row's Note. Do not ask the owner.

5. Match each row to capture files using the capture task's names and `pages.csv`. Cite the real file name under the captures folder (e.g. `F4-01.png`). Every `in place` / `partial` row must name a capture file that exists there.
6. Typical paths the captures should show (confirm from the files; unknown ones `(?)`). What counts as "in place":

   | ID | Function | Where the capture should show (R365) | Where the capture should show (Toast) | What counts as "in place" |
   |---|---|---|---|---|
   | M0 | Licensed / visible modules | top menu and app switcher (Operations, Inventory, Purchasing, AP, Accounting, Scheduling, Labor) `(?)` | — | list what's visible and what the owner's role can open |
   | F2 | Items, units, vendors | Inventory → Items (count, sample 10 high-dollar items: purchase unit, count unit, conversions, cost, GL) `(?)`; Purchasing → Vendors | — | items exist with units and costs; vendors listed |
   | F3 | Electronic invoices | AP → AP Invoices (last 60 days: count, source EDI/email/manual); Vendors → integration/EDI flag `(?)`; invoice email-capture address `(?)` | — | invoices arrive by EDI or email capture |
   | F4 | Recipes and menu mapping | Inventory → Recipes (count); POS / Menu Item Mapping page (count of unmapped items with sales) `(?)` | Menu → items and modifiers (count) | recipes exist and Toast items are mapped |
   | F5 | Inventory counts | Inventory → Storage Locations; Count Templates; past counts (last date) `(?)` | — | locations and templates exist; a count posted in the last 30 days |
   | F6 | Waste log | Inventory → Waste `(?)` | Void/waste reasons in Toast setup `(?)` | waste entries in the last 30 days |
   | F7 | Food cost reporting | Reports: Actual vs Theoretical, Theoretical Food Cost, COGS, P&L (open with last week's dates) `(?)` | — | reports return numbers, not empty |
   | F8 | Cash and deposits | Accounting → Bank / Deposits, cash reconciliation `(?)` | Reports → Payments, Deposits, Cash management / drawer reports `(?)` | deposits are recorded and reconciled |
   | F9 | Daily flash | Reports / Dashboards: daily sales and labor flash `(?)`; any scheduled report emails | Reports → Sales summary; scheduled email reports `(?)` | a daily report exists and is sent |
   | F10 | Scheduling and overtime | Scheduling module (schedules published? OT alerts?) `(?)` | Toast Scheduling (in use?) `(?)` | schedules are made in the system; OT alerts exist |
   | F11 | Tips automation | Labor → Tip Automation rules for CARY 1 `(?)` | Tip settings | rules exist (known to work for payroll; just confirm) |
   | F12 | Payroll reports | Labor → Labor Payroll Review, Tip Automation Distributions `(?)` | Labor → Time entries | reports exist (known; confirm) |
   | F13 | Delivery reconciliation | AP or Accounting: third-party delivery deposits `(?)` | Integrations: DoorDash, Uber Eats, Grubhub, ezCater, first-party online ordering `(?)` | channels flow into Toast, and their payouts are reconciled |
   | I1 | Toast → R365 integration | POS integration / sales import page for CARY 1: last sales import date, last labor import date, errors `(?)` | Integrations → R365 `(?)` | daily import with a recent date and no errors |
   | O1 | Who owns what | for each F row: is the setting editable by the owner's role, greyed out, or labelled franchise/corporate? | same | record owner / franchise / R365 support |

7. Append to `skills/fhs-skills/references/tech-stack.md` one section `## Store 122 audit (<date>)`: one line per **confirmed** fact and a pointer to the note's section. Added lines only. Change nothing else in that file.
8. If `pages.csv` has an action other than view/filter/export, record it in the report's deviations. Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/store-audit-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (the one new section, added lines only)
- Outside the repo, only `/srv/fhs-build/reports/store-audit-122-02.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/store-audit-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, or any toggle and checkbox that persists.
- Install packages or change system settings.

## Tests (run every one, record the real output)

1. `grep -cE '^\| F([2-9]|1[0-3]) ' docs/research/store-audit-122.md` → `12`
2. `grep -E '^## (Licensed modules|Toast → R365 integration|Who owns what)' docs/research/store-audit-122.md` → those three headings
3. Every summary-table row has a status from {in place, partial, missing, can't tell}, evidence (menu path + capture file or "none"), and an owner from {owner, franchise, R365 support, unknown}. Print the table rows to prove it.
4. For every summary row with status `in place` or `partial`, `ls -l /srv/fhs-build/reports/store-audit-122-captures/<file>` → the named file exists. Every capture file the note cites exists in that folder.
5. After the commit: `git diff --name-only main...HEAD` → only `docs/research/store-audit-122.md` and `skills/fhs-skills/references/tech-stack.md`
6. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
7. After the commit: `git status --short` → empty

## When done

1. Commit on `feat/store-audit-122-02`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/store-audit-122-02.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: store-audit-122-02 · Branch: feat/store-audit-122-02 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/7 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
