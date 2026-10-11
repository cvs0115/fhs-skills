# Plan · invoices-122-01 · Verify 122's Cheney invoices: lines, mapping, approval, last receipt

Drafted by Cursor Grok 4.6 High from docs/briefs/invoices-122-01.md.

2026-10-11. Plan only, not approved. Don't build from it until `docs/reviews/invoices-122-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/invoices-122-01.md`, its capture task `docs/prompts/invoices-122-01-capture.md`, and its test plan `docs/tests/invoices-122-01.md` together.
Don't add scope.

- Hub project: `projects/electronic-invoices` (F3) · Phase: none yet · Spec: `docs/specs/electronic-invoices.md` · Decisions that bind it: 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, restricted key; q1 (owner) Cheney by R365 Import; 2026-10-11 receipt recency and unmapped lines moved here from F2
- Research to rely on: `docs/research/store-audit-122.md` (F3), `docs/research/items-122.md` (207-item table, "Moved to F3", INV page paths). Facts marked `(?)` stay unverified unless this capture shows them. F2 INV files have no line detail; this capture's invoice pages are the source.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture

Capture does not start until the owner is signed in to R365 in Chrome on the PC, store **CARY 1**. Runbook row 9 (PC clone `C:\fhs\fhs-skills`, restricted key, alias) is already done. `browser-02` stays parked. Toast is not touched. The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/invoices-122.zip` into `/srv/fhs-build/reports/invoices-122-captures/`.

## Verdict

No build (verify-only: F3 is already in place). Research note and `tech-stack.md` lines only — no skill, no script, no R365 change.

## What changes, in plain words

Your PC capture opens every CARY 1 Cheney invoice and credit memo from 08/14–10/09/2026, view only, and saves the line grid (scroll until the footer reads 1–N of N, or export if the page offers it). It also saves the Cheney vendor Transactions tab so the count matches. A note on the server lists each invoice (approval, lines, mapped vs unmapped) and each of the 207 counted items' last Cheney receipt in those 8 weeks. Nothing in R365 is changed; fixing gaps is a later plan.

## Files the researcher may edit (in its clone)

- `docs/research/invoices-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the R365 part (Store 122 audit / R365 inventory facts): where invoice line detail lives and how to read it. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/invoices-122-01.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\invoices-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/invoices-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/invoices-122-captures/`. Tester report: `/srv/fhs-build/reports/invoices-122-01-test.md`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

R365 (`https://fhs4021089.restaurant365.com/`) only, **read-only**, on the owner's PC, owner signed in. Toast not touched. Each R365 click still needs the owner's yes at the time (this plan's yes is view / filter / scroll / export only).

Allowed and forbidden actions as `items-122-01`, plus the invoice-only extras below:

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening invoice detail pages (`invoiceId=`) to read, changing on-screen filters or date ranges, taking screenshots, saving page text.
- **Forbidden:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a GL, or any button that changes status, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes.
- **Exports** (download a CSV or PDF of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\invoices-122\` with the other captures. An export never changes data. If the invoice line grid has a read-only export button, use it instead of scrolling and say so.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

F2 proved R365's reports have **no invoice line detail** (`INV-04/05-missing.txt`), and the F2 header export shows **20** CARY 1 Cheney invoices in range (`INV-03.txt`). That is under the spec's ~40 limit, so no owner question. The capture opens each CARY 1 Cheney invoice and credit memo dated 08/14–10/09/2026, view only, and saves its page text. The invoice line grid is virtualized: scroll it until the lines read equal the footer "1 - N of N Items" and record N (or export if offered). Also save the Cheney vendor **Transactions** tab export for CARY 1 (the count to match) and, where the invoice page shows them, approval date and approver.

Two capture areas, listed in `docs/prompts/invoices-122-01-capture.md` with file names. Known starts (confirm; unknown `(?)`): Accounting → Vendors `/react/accounting/legacy/Vendors` → Cheney Brothers, Inc. → Transactions; Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; Inventory → Invoices `/react/inventory/invoices`; invoice detail `invoiceId=` (`docs/research/items-122.md` INV paths; `docs/research/store-audit-122.md` F3).

1. `TXN-*` — Cheney vendor Transactions tab for CARY 1, 08/14–10/09/2026 (export = the count to match)
2. `INV-*` — each CARY 1 Cheney invoice and credit memo in that range (`invoiceId=`, view only): header, footer N, lines, mapping/GL, approval status, approval date + approver if shown

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (time, URL, action = view/filter/scroll/export). Invoice detail pages (`invoiceId=`) are allowed as **view** only.

## Owner steps

1. Sign in to R365 in Chrome and pick **CARY 1** where a store picker exists.
2. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\invoices-122\`, and send the zip with `send-report.ps1` as `invoices-122.zip` (agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`.
3. After merge, confirm nothing changed in R365 (no invoice status changed by the capture). That post-merge case is not a merge gate.

## Done-check (real outcome)

1. `docs/research/invoices-122.md` lists every CARY 1 Cheney invoice and credit memo 08/14–10/09/2026: number, date, total, approval status, approval date + approver (or "not shown"), line count N, capture file. Count = the Transactions tab export count for CARY 1.
2. Per invoice, lines sum to the total within $0.01; mismatches listed (a grid read short of N is a capture gap, not a mismatch).
3. Every line: mapped (R365 item name) or unmapped (GL only / no item), with GL. Totals: lines, mapped, unmapped, unmapped $.
4. Each of the **207** counted items (from `docs/research/items-122.md`) gets its last Cheney receipt date in range, or "none in 8 weeks". Match on the R365 item name/number shown on the line; say how many matched by name only.
5. P1 section: approval wait (invoice date → approval date) where shown; who appears to own vendor-item mapping (owner / franchise / R365 support / can't tell), from the screens.
6. Plain-words summary for the owner: "N invoices waiting for approval", "N Cheney lines not tied to an item ($X)", "N counted items not bought in 8 weeks".

## Where it runs

- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK).
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture is read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/invoices-122-01` via `scripts/build.sh prepare docs/plans/invoices-122-01.md invoices-122-01 --role research`, branch `feat/invoices-122-01`, cut from the `main` commit that holds this plan, its task file, the capture task (`docs/prompts/invoices-122-01-capture.md`, which the PC clone also needs), the test plan and the APPROVE review. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/invoices-122.zip` into `/srv/fhs-build/reports/invoices-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/invoices-122-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/invoices-122-01.md`, `docs/prompts/invoices-122-01-capture.md`, `docs/tests/invoices-122-01.md` and that review to `main` before prepare.
2. Gate: owner signed in to R365 in Chrome on the PC, store CARY 1.
3. Capture on the PC from `docs/prompts/invoices-122-01-capture.md`; zip; `send-report.ps1` to `/root/fhs-skills/inbox/invoices-122.zip`.
4. `build.sh prepare docs/plans/invoices-122-01.md invoices-122-01 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/invoices-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files only; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them. The 207 names come from `docs/research/items-122.md`; last-receipt and unmapped-line evidence come from this capture, not F2 INV files.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect invoices-122-01 --role research`.
9. `review.sh --diff feat/invoices-122-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/invoices-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Invoice count = Transactions tab count for CARY 1 in range; no duplicate numbers.
- Every invoice: lines read = footer N, or listed as a capture gap.
- Line sums = invoice totals ±$0.01 (except listed mismatches/gaps).
- 207 items present, each with a date or "none in 8 weeks"; no duplicates.
- Tester picks 3 invoices (at least 1 with an unmapped line if any) and confirms header, lines and mapping against the captures.
- `pages.csv`: only view/filter/scroll/export actions; no save/approve/complete/create/map URL or click. Invoice detail pages (`invoiceId=`) are allowed as **view** only.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Post-merge (owner): nothing changed in R365 (no invoice status changed by the capture).

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in R365, Toast and ADP. No invoice is approved, edited, mapped, re-imported, or status-changed. Franchise-owned settings are not edited. Other vendors, store 878 / CAMDEN SQUARE, AP payments and checks, the F2 problem list ($0 cost, missing Cheney links, unit mismatches), and a reusable invoice checker script stay out of scope. Payroll is unchanged. `browser-02` stays parked. Fixes are a later plan, each with the owner's OK.
