# Plan · count-lines-122-01 · Sort the 108 not-bought counted items: slow, substituted or dead

Drafted by Cursor Grok 4.6 High from docs/briefs/count-lines-122-01.md.

2026-10-11. Runs only after the plan review is APPROVE and the PC clone is refreshed. Don't build from it until `docs/reviews/count-lines-122-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/count-lines-122-01.md`, its capture task `docs/prompts/count-lines-122-01-capture.md`, and its test plan `docs/tests/count-lines-122-01.md` together.
Don't add scope.

- Hub project: `projects/r365-inventory` (F2 follow-up, before F4) · Phase: plan page https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK · Spec: `docs/specs/count-lines-122.md` · Decisions that bind it: 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, restricted key; 2026-10-11 owner: next job is the 108 items; Cary 1 buys only from Cheney
- Research to rely on: `docs/research/invoices-122.md` (Item last receipt: the 108 `none in 8 weeks` rows; Mapping by invoice: the R365 item on every line), `docs/research/items-122.md` (Item table: cost, unit, Cheney link). Facts marked `(?)` stay unverified unless this capture shows them.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture

Capture does not start until the owner is signed in to R365 in Chrome on the PC, store **CARY 1**. Runbook row 9 (PC clone `C:\fhs\fhs-skills`, restricted key, alias) is already done. `browser-02` stays parked. Toast is not touched. The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-lines-122.zip` into `/srv/fhs-build/reports/count-lines-122-captures/`. Step 1 (no browser) reads the existing F3 folder `/srv/fhs-build/reports/invoices-122-captures/`; do not recapture it.

## Verdict

No build (verify-only). Research note and `tech-stack.md` lines only — no skill, no script, no R365 change.

## What changes, in plain words

108 counted items at Cary 1 had no Cheney receipt in the last 8 weeks. This check does not change R365. On the PC we export each approved weekly count back to 08/01/2026 and look up older purchases (item purchase history if R365 shows dates, otherwise older Cheney invoices). A note on the server then puts each of the 108 in one group: still bought, just not lately; bought under another Cheney item; looks dead; or can't tell.

## Files the researcher may edit (in its clone)

- `docs/research/count-lines-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the R365 part (`## Store 122 audit (2026-10-11)` / R365 inventory facts): where count history and item purchase history live. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/count-lines-122-01.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\count-lines-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/count-lines-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/count-lines-122-captures/`. Step 1 also reads `/srv/fhs-build/reports/invoices-122-captures/` (already unzipped from F3). Tester report: `/srv/fhs-build/reports/count-lines-122-01-test.md`. 10/04 quantity check uses the existing F2 file `/srv/fhs-build/reports/items-122-captures/CNT-03.csv`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

R365 (`https://fhs4021089.restaurant365.com/`) only, **read-only**, on the owner's PC, owner signed in. Toast not touched. Each R365 click still needs the owner's yes at the time (this plan's yes is view / filter / scroll / export only).

Allowed and forbidden actions as `invoices-122-01`, plus the count- and item-only extras below:

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening count, item and invoice detail pages to read, changing on-screen filters or date ranges, taking screenshots, saving page text.
- **Forbidden:** Save, Submit, Approve, Complete, Post, Import, Re-import, Map/assign an item, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, changing a cost/unit/GL, removing an item from a template, or any button that changes status, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. Do not open an In Progress count for editing (if opened by accident, leave with Cancel or Back, never Save). Open Approved counts read-only for Item Details. Do not open Ad hoc report (it needs a save).
- **Exports** (download a CSV or PDF of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\count-lines-122\` with the other captures. An export never changes data. If a count's Item Details grid or an invoice line grid has a read-only export button, use it instead of scrolling and say so.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

Three sources, in this order. Source 1 is not a PC capture. Capture areas 2–3 are listed in `docs/prompts/count-lines-122-01-capture.md` with file names. Known starts (confirm; unknown `(?)`): Inventory → Inventory counts `/react/inventory/inventory` (Item Details export as `CNT-03.csv` in items-122; 10/04 was `?countId=3`); Inventory → Items `/react/inventory/purchase-items` and item detail `?purchaseItemId=` (ItemCost / Settings in items-122 `ITM-05`..`ITM-12`); Accounting → Vendors `/react/accounting/legacy/Vendors` → Cheney Brothers, Inc. → Transactions; Accounting → AP transactions `/react/accounting/ap-transactions?tab=transactions`; invoice/credit-memo forms `#/form/APInvoiceForm/{id}` and `#/form/APCreditMemoForm/{id}` (`docs/research/items-122.md` CNT/ITM paths; `docs/research/invoices-122.md` INV paths).

1. **No browser (Researcher, after unzip):** from the invoices-122 captures, list every R365 item on a Cheney line 08/14–10/09/2026 that is **not** one of the 207 count names. Pair each with a likely count name among the 108 (same product words, size or category); mark pairs `(?)` unless the item numbers or item detail tie them. These are "other Cheney item" candidates.
2. `CNT-*` — **PC capture, count history:** Inventory counts list for CARY 1, then Item Details export (same export as items-122 `CNT-03.csv`) for each **Approved** CARY 1 count dated on or after 08/01/2026 (≈10 counts). Quantity per item per week. Do not open In Progress counts (including 09/28) for editing. Include the 10/04/2026 count so its quantities can be checked against items-122 `CNT-03.csv`. Record each count's date, status, and list total.
3. `ITM-*` then maybe `TXN-*` / `INV-*` — **PC capture, older purchases:** first open 3 of the 108 items' detail pages and save any purchase-history or last-cost view. If one exists with dates, use that view for all 108 and **skip invoices**. Else list CARY 1 Cheney invoices 05/15–08/13/2026 (header count first: Transactions tab and/or AP transactions export). If that count is **≤45**, open each view-only as in invoices-122-01 (invoice and credit-memo forms on that list; scroll the line grid until 1–N of N, or export if offered). If more than 45, **stop and ask the owner**; do not open those invoices.

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (time, URL, action = view/filter/scroll/export). Count detail, item detail (`purchaseItemId=`), and invoice detail pages (`invoiceId=` / AP forms) are allowed as **view** only.

## Owner steps

1. Sign in to R365 in Chrome and pick **CARY 1** where a store picker exists.
2. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\count-lines-122\`, and send the zip with `send-report.ps1` as `count-lines-122.zip` (agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`. If capture stops at the >45-invoice gate, answer before anything else is opened.
3. After merge, confirm nothing changed in R365 (no count, item, template, or invoice status changed by the capture). That post-merge case is not a merge gate.

## Done-check (real outcome)

1. `docs/research/count-lines-122.md` has a row for each of the 108 names (copied exactly from invoices-122 Item last receipt `none in 8 weeks`): group (slow mover / other Cheney item / looks dead / can't tell), last Cheney receipt found and its source, quantity on each captured count, $ on 10/04, capture file. No extra or missing names.
2. Group rules: **slow mover** = a Cheney receipt of that item before 08/14; **other Cheney item** = a paired non-count item with a receipt 08/14–10/09 and the pairing evidence; **looks dead** = no receipt in the history captured and qty 0 on every captured count; **can't tell** = anything else, with what's missing. When more than one could apply, assign in this order: **other Cheney item** → **slow mover** → **looks dead** → **can't tell**. State the earliest date the history reached.
3. Count history: number of approved counts captured and their dates; each export's total = that count's list total ±$1.
4. P1: for each "other Cheney item", the count line's current Cheney vendor item (from items-122) vs the item bought now.
5. Plain-words summary for the owner: "N still bought, just not lately", "N bought under another Cheney item", "N look dead ($X on the 10/04 count)", "N can't tell".

## Where it runs

- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Files under `C:\fhs\reports\count-lines-122\`. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK).
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture is read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/count-lines-122-01` via `scripts/build.sh prepare docs/plans/count-lines-122-01.md count-lines-122-01 --role research`. `prepare` clones `main` at the commit that holds this plan, its task file, the capture task (`docs/prompts/count-lines-122-01-capture.md`, which the PC clone also needs), the test plan and the APPROVE review; the researcher creates `feat/count-lines-122-01` in that clone per the task. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/count-lines-122.zip` into `/srv/fhs-build/reports/count-lines-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/count-lines-122-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/count-lines-122-01.md`, `docs/prompts/count-lines-122-01-capture.md`, `docs/tests/count-lines-122-01.md` and that review to `main` before prepare. A missing capture file on `main` blocks PC capture (capture is before `prepare`; `prepare` does not require that file). Refresh the PC clone at `C:\fhs\fhs-skills` from that `main` before capture so it has the approved capture task.
2. Gate: owner signed in to R365 in Chrome on the PC, store CARY 1.
3. Capture on the PC from `docs/prompts/count-lines-122-01-capture.md` (count history, then older purchases); zip; `send-report.ps1` to `/root/fhs-skills/inbox/count-lines-122.zip`.
4. `build.sh prepare docs/plans/count-lines-122-01.md count-lines-122-01 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/count-lines-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files plus `/srv/fhs-build/reports/invoices-122-captures/` (step 1) and `docs/research/invoices-122.md` / `docs/research/items-122.md`; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them. The 108 names come from invoices-122; cost, unit, Cheney link and 10/04 $ come from items-122.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect count-lines-122-01 --role research`.
9. `review.sh --diff feat/count-lines-122-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/count-lines-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- 108 names = the `none in 8 weeks` names in `docs/research/invoices-122.md`; each in exactly one group.
- Each count export total = its count's list total ±$1; 10/04 quantities agree with items-122 `CNT-03.csv`.
- Every "looks dead" row: qty 0 on every captured count and no receipt in the stated history range.
- Every "other Cheney item" row cites the paired item, its receipt date and the capture.
- Tester picks 5 items (at least one per non-empty group) and confirms them against the captures.
- `pages.csv`: only view/filter/scroll/export actions; no save/approve/complete/create/edit/map URL or click. Count, item and invoice detail pages are allowed as **view** only.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Post-merge (owner): nothing changed in R365.

Researcher and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in R365, Toast and ADP. No count is approved or completed, no item/cost/unit/GL/vendor-item link is changed, and no line is removed from the count template. Franchise-owned settings are not edited. The 99 items Cary 1 did buy in 8 weeks, store 878 / CAMDEN SQUARE, F4 recipes, Cheney's own website or order guide, the F2 problem list ($0 cost, missing Cheney links, unit mismatches), and a reusable checker script stay out of scope. Payroll is unchanged. `browser-02` stays parked. Fixes are a later plan, each with the owner's OK.
