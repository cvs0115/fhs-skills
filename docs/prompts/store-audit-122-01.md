# Agent task · store-audit-122-01 · research

> **For the research agent (Cursor Grok 4.6 High via `agent`), as `fhsbuild`.** This file is your whole assignment.
> Approved plan: `docs/plans/store-audit-122-01.md`. If this task file and the plan disagree, stop and report it.
> Hand-off: "Do the task in docs/prompts/store-audit-122-01.md". Start only after the owner says they're signed in.

## Context

fhs-skills runs a Firehouse Subs owner's back office. Store 122 (Cary 1) uses Toast POS for front of house and Restaurant365 (R365,
through the Firehouse franchise) for back office. R365 is known to handle labor and tips for payroll. Nobody has checked what else is
set up. You audit store 122 **read-only** and record, for each back-office function, whether it's in place, partial, missing, or can't
tell, with evidence and who owns it. The planner uses your note to decide what to build, verify or leave to the franchise.

## Where you work

- Workspace `/srv/fhs-build/store-audit-122-01`. First: `git checkout -b feat/store-audit-122-01`.
- Browser: the server Playwright MCP (already registered for your agent). The owner has signed in to R365 and Toast in it.
- Screenshots go to `/srv/fhs-build/reports/store-audit-122-shots/` (create it), named `<ID>-<system>-<short-page>.png`,
  e.g. `F4-r365-menu-item-mapping.png`, `F8-toast-deposits.png`.

## Read first

`CLAUDE.md`, `docs/plans/store-audit-122-01.md`, `docs/specs/store-audit-122.md`, `docs/specs/store-migration.md` (the F0–F13 catalog),
`skills/fhs-skills/references/tech-stack.md`, `skills/fhs-skills/references/r365-inventory-setup.md` (Phase 0 checklist).

## Hard rules (read twice)

- **Read-only.** Navigate, open pages and reports, change on-screen filters and dates, take snapshots and screenshots. Nothing else.
- **Never click:** Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run, Send, Email, Pay, or any
  toggle or checkbox that persists. If you open an edit form by accident, leave it with Cancel or Back, never Save.
- **Never type credentials.** If a login or MFA prompt appears, stop that item, mark it "can't tell (login)", and continue with the next.
- **Exports allowed:** you may download read-only report exports (CSV/PDF) into `/srv/fhs-build/reports/store-audit-122-exports/` (owner OK, 2026-10-10). Never use an "export" or "sync" that sends data somewhere else.
- Snapshot the page before every click, and only click navigation links, tabs, menu items and report "view" buttons.
- Record every page you visit (system, menu path, URL path without query secrets) in your report's "Pages visited" list.

## Checklist (R365 menu paths are typical; confirm the real path and mark unknown ones `(?)`)

| ID | Function | Where to look in R365 | Where to look in Toast | What counts as "in place" |
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

Also note anything that answers hub q1–q5: main distributor and invoice method; whether counts happen today; food only or also paper and
chemicals; corporate-provided recipes or items; any food cost target shown.

## Output: `docs/research/store-audit-122.md`

Start with `# Research · store-audit-122 · What R365 and Toast already do for store 122` and the date, then:

1. **Summary table:** one row per M0, F2–F13, I1:

   | ID | Function | Status (in place / partial / missing / can't tell) | Evidence (system → menu path; screenshot file) | Owner (owner / franchise / R365 support / unknown) | Note |

2. **One section per row** with the details (counts, dates, sample items, what's missing). Write numbers, not adjectives.
3. **Who owns what:** a list of settings that look franchise-managed.
4. **Answers to q1–q5** found on screen, or "can't tell (owner)".
5. **Open `(?)` items:** menu paths you couldn't confirm, and pages blocked by login or permissions.

## Also edit

`skills/fhs-skills/references/tech-stack.md`: append one section `## Store 122 audit (<date>)` with one line per **confirmed** fact and a
pointer to the note's section. Change nothing else in that file.

## You may edit only

- `docs/research/store-audit-122.md` (new), and `skills/fhs-skills/references/tech-stack.md` (the one new section)
- Outside the repo: `/srv/fhs-build/reports/store-audit-122-01.md` and `/srv/fhs-build/reports/store-audit-122-shots/*.png`

## You must not

- Do any forbidden action listed above. Edit any other file. Use sudo. Push or merge. Type credentials.

## Tests (run every one, record the real output)

1. `grep -cE '^\| (M0|F([2-9]|1[0-3])|I1) ' docs/research/store-audit-122.md` → `14` (summary rows)
2. For every summary row with status "in place" or "partial", its screenshot file exists: list them with `ls -l`
3. `git diff --name-only main...HEAD` → only the note and `tech-stack.md`
4. `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only)
5. `git status --short` → empty

## When done

1. Commit on `feat/store-audit-122-01`, ending the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write `/srv/fhs-build/reports/store-audit-122-01.md`:

```text
Task: store-audit-122-01 · Branch: feat/store-audit-122-01 · Commits: <hashes>
Files changed: <list> · Screenshots: <count>
Pages visited: <system → menu path, one per line>
Forbidden actions taken: none | <list>
Tests: <n>/5 passed. For each: command, trimmed output, pass/fail
Open (?) items: <list>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
