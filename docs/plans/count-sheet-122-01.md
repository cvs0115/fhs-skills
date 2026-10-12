# Plan · count-sheet-122-01 · Who owns the Cary 1 count sheet, the owner's tick list, how store runs could reach R365

Drafted by Cursor Grok 4.6 High from docs/briefs/count-sheet-122-01.md.

2026-10-12. Plan only, not approved. Don't build from it until `docs/reviews/count-sheet-122-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/count-sheet-122-01.md`, its capture task `docs/prompts/count-sheet-122-01-capture.md`, and its test plan `docs/tests/count-sheet-122-01.md` together.
Don't add scope. The hide itself is count-sheet-122-02, planned later from this note.

- Hub project: `projects/r365-inventory` (F2 fix) · Phase: plan page https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK · Spec: `docs/specs/count-sheet-122.md` · Decisions that bind it: 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, restricted key; 2026-10-12T10:00 hide the 45, check ownership first, OK per change; 2026-10-12T10:01 the 32 can't-tell lines are store runs; 2026-10-12 owner ticks the 45 list before any hide
- Research to rely on: `docs/research/count-lines-122.md` (Item table, group "looks dead": the 45 names, 10/04 qty, last receipt), `docs/research/store-audit-122.md` F5 (templates: creator R365 DSS User, modifier R365 10/06/2026, CAMDEN twin with 207 items). Facts marked `(?)` stay unverified unless this capture shows them.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture

Capture does not start until the owner is signed in to R365 in Chrome on the PC, store **CARY 1**. Runbook row 9 (PC clone `C:\fhs\fhs-skills`, restricted key, alias) is already done. `browser-02` stays parked. Toast is not touched. The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-sheet-122.zip` into `/srv/fhs-build/reports/count-sheet-122-captures/`. Step 1 (no browser) reads `docs/research/count-lines-122.md`; do not recapture count-lines or invoices-122.

## Verdict

No build (verify-only). Research note and `tech-stack.md` lines only — no skill, no script, no R365 change.

## What changes, in plain words

45 lines on the Cary 1 weekly count look unused. This check does not change R365 and does not hide anything. It writes a tick list for the owner (Keep? left blank), then on the PC we look at who owns the count sheet and whether this login can take a line off, and we look at how R365 would record a Costco or grocery buy that has no invoice. The owner fills Keep? after the merge; Claude records it. The hide is a later plan.

## Files the researcher may edit (in its clone)

- `docs/research/count-sheet-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the R365 part (`## Store 122 audit (2026-10-11)` / R365 inventory facts): who owns count templates, and where a no-invoice purchase can be recorded. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/count-sheet-122-01.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\count-sheet-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/count-sheet-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/count-sheet-122-captures/`. Tester report: `/srv/fhs-build/reports/count-sheet-122-01-test.md`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

R365 (`https://fhs4021089.restaurant365.com/`) only, **read-only**, on the owner's PC, owner signed in. Toast not touched. Each R365 click still needs the owner's yes at the time (this plan's yes is view / filter / scroll / export, plus opening a detail page or one blank form to read it, then Cancel or Close).

Allowed and forbidden actions as `count-lines-122-01`, plus the template- and store-run extras below:

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening a blank form to read its fields then Cancel or Close, changing on-screen filters or date ranges, taking screenshots, saving page text.
- **Forbidden:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create (other than opening the one blank AP-invoice form), New, Add (other than that same blank form), Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, Inactivate, Remove from template, changing a cost/unit/GL, or any button that changes status, or any toggle and checkbox that persists, or an Edit-mode toggle that locks a record. No settings pages edited. No user or permission changes. Do not open an In Progress count for editing. Do not open Ad hoc report (it needs a save).
- **Blank form:** open the new-AP-invoice form only to read its fields. Leave with Cancel or Close, never Save. If it cannot be closed without saving, **stop and ask the owner**. Do not type into the form except as needed to leave it.
- **Exports** (download a CSV or PDF of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\count-sheet-122\` with the other captures. An export never changes data.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

Three parts, in this order. Parts 2–3 are listed in `docs/prompts/count-sheet-122-01-capture.md` with file names. Known starts (confirm; unknown `(?)`): Inventory → Inventory counts → gear → templates `/react/inventory/inventory/settings` then **CARY 1 - FHS Weekly Inventory** `?templateId=` (items-122 TPL); Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=`; Accounting → Vendors `/react/accounting/legacy/Vendors`; Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; invoice form `#/form/APInvoiceForm` (blank/new path `(?)`). Menu paths for expense, receipt, or credit-card screens are unknown `(?)` until this capture.

1. **No browser (Researcher, after unzip):** `## Tick list` — exactly the 45 Item-table rows in `docs/research/count-lines-122.md` whose Group is **looks dead**. Columns: Name (copied exactly), category (the name prefix, e.g. BEV, CLEAN, PAPER FD, PAPER NF, NON REV, DAIRY, COUNT, Catering, CO2, or `P-`), 10/04 qty, last Cheney receipt, `Keep?` left blank. No extras, no gaps. The owner fills `Keep?` after the merge; do not fill it here.
2. `TPL-*` then `ITM-*` — **PC capture, template ownership.** Open **CARY 1 - FHS Weekly Inventory** detail. Capture the item list, every button and menu shown (as text, not clicked: label, enabled or greyed), the created/modified fields, any location or brand field, and any history or audit tab (open the tab if shown; view only). Open the **CAMDEN SQUARE - FHS Weekly Inventory** header only, to see if it is the same record or a copy (compare `templateId` / URL, created/modified, item count). Do not change CAMDEN's template and do not capture its full item list. For these 3 of the 45 only — **BEV APPLE JUICE ALL**, **CLEAN MOP HEAD**, **PAPER FD SM SALAD BOWL** — open item detail and capture any per-location or count-template setting (for example Inactive, or "count at location").
3. `VND-*` / `APF-*` / `EXP-*` / `TXN-*` — **PC capture, store runs (P1).** In R365 Accounting, search Vendors for Costco, Sam's, Walmart, Food Lion, Harris Teeter, "store" and "petty" (search / filter only; do not create a vendor). Open the new-AP-invoice form only to read its fields, and close it without saving. Look under every menu for a screen whose title or labels are expense, receipt, or credit-card; open and capture each one found; if none, capture the menus searched. Do not reopen F2–F13. Filter AP transactions for CARY 1 by any non-Cheney vendor since 05/15/2026 and record the count (expected 0). Do not open those rows unless needed to read the count.

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (header exactly `time,URL,action`; action = view / filter / scroll / export). Template detail (`templateId=`), item detail (`purchaseItemId=`), vendor list, AP list, and the blank AP-invoice form are allowed as **view** only. A blank-form open is `view` and must be closed with Cancel or Close. A `create` / `new` URL is allowed only for that one blank-form open that was closed without save.

## Owner steps

1. Sign in to R365 in Chrome and pick **CARY 1** where a store picker exists.
2. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\count-sheet-122\`, and send the zip with `send-report.ps1` as `count-sheet-122.zip` (agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`. If the blank AP form cannot be closed without saving, or a login / MFA prompt appears, stop and answer before anything else is opened.
3. After merge, fill `Keep?` on the 45-line tick list, and confirm nothing changed in R365 (template still 207 items; no new vendor or AP draft). Claude records the ticks. Those post-merge cases are not a merge gate.

## Done-check (real outcome)

1. `## Tick list` has exactly the 45 "looks dead" names from `docs/research/count-lines-122.md` (no extras, no gaps), with blank `Keep?`.
2. `## Template ownership` answers each question with `seen` + capture file, or `(?)` + what is missing: (a) can the owner's role remove an item or mark it inactive for CARY 1 (control shown and enabled, not clicked); (b) is CAMDEN SQUARE's template the same record or a separate copy; (c) any sign of a brand/R365 push (location group, "managed by", modified-by history).
3. `## Store runs` lists only ways seen on a screen, each with its capture. It also gives the count of CARY 1 non-Cheney AP rows since 05/15/2026 (expected 0).
4. Plain-words summary for the owner, ≤6 lines: who owns the sheet, whether the owner can hide lines, the store-run options seen.

## Where it runs

- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Files under `C:\fhs\reports\count-sheet-122\`. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK).
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files plus `docs/research/count-lines-122.md` and `docs/research/store-audit-122.md` F5 only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture is read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/count-sheet-122-01` via `scripts/build.sh prepare docs/plans/count-sheet-122-01.md count-sheet-122-01 --role research`. `prepare` clones `main` at the commit that holds this plan, its task file, the capture task (`docs/prompts/count-sheet-122-01-capture.md`, which the PC clone also needs), the test plan and the APPROVE review; the researcher creates `feat/count-sheet-122-01` in that clone per the task. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-sheet-122.zip` into `/srv/fhs-build/reports/count-sheet-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/count-sheet-122-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/count-sheet-122-01.md`, `docs/prompts/count-sheet-122-01-capture.md`, `docs/tests/count-sheet-122-01.md` and that review to `main` before prepare. A missing capture file on `main` blocks PC capture (capture is before `prepare`; `prepare` does not require that file). Refresh the PC clone at `C:\fhs\fhs-skills` from that `main` before capture so it has the approved capture task.
2. Gate: owner signed in to R365 in Chrome on the PC, store CARY 1.
3. Capture on the PC from `docs/prompts/count-sheet-122-01-capture.md` (template ownership, then store runs); zip; `send-report.ps1` to `/root/fhs-skills/inbox/count-sheet-122.zip`.
4. `build.sh prepare docs/plans/count-sheet-122-01.md count-sheet-122-01 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/count-sheet-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files plus `docs/research/count-lines-122.md` and `docs/research/store-audit-122.md` F5; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them. The 45 names, 10/04 qty and last Cheney receipt come from count-lines-122.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect count-sheet-122-01 --role research`.
9. `review.sh --diff feat/count-sheet-122-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/count-sheet-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Tick list names = the 45 "looks dead" names in `docs/research/count-lines-122.md`; `Keep?` blank on all 45.
- Each ownership answer cites a capture file that exists and shows what the answer says. Each `(?)` names what is missing.
- Each store-run option cites a capture that shows it. No option is named without a capture.
- `pages.csv`: only view/filter/scroll/export actions and blank-form opens closed with Cancel/Close; no save/submit/approve/create/delete/remove/inactivate click or URL (the one blank AP-invoice form, action `view`, closed without save, is the only `create`/`new` URL allowed).
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Post-merge (owner): nothing changed in R365 (template still 207 items; no new vendor or AP draft).

Researcher and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in R365, Toast and ADP. No line is hidden or removed from the count template, no item is inactivated, no vendor is added, and no AP invoice or draft is saved. Franchise-owned settings are not edited. The 31 slow movers and the 32 can't-tell lines stay on the sheet. $0.00 costs, collecting Costco or grocery receipts, and bank or card statements stay out of scope. Store 878 / CAMDEN SQUARE's template is header-read only (not changed). The hide itself is count-sheet-122-02, one OK per change. Payroll is unchanged. `browser-02` stays parked. The Windows mirror is unchanged.
