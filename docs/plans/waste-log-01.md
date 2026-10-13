# Plan · waste-log-01 · Cary 1: Toast POS waste, Food waste reporting, R365 log and AvT

Drafted by Cursor Grok 4.6 High from docs/briefs/waste-log-01.md.

2026-10-13. Plan only, not approved. Don't build from it until `docs/reviews/waste-log-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/waste-log-01.md`, its capture task `docs/prompts/waste-log-01-capture.md`, and its test plan `docs/tests/waste-log-01.md` together.
Don't add scope.

- Hub project: `projects/waste-log` · Phase: none yet · Spec: `docs/specs/waste-log.md` · Decisions that bind it: owner 2026-10-13 associates record waste in Toast at the POS (a waste button, `(?)`); the old manager sheet → R365 process is being replaced; 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 and 17:30 PC jobs run in Claude Code + Claude in Chrome; 2026-10-12T10:00 no R365 change without an OK per change; 2026-10-13 parallel lanes (CLAUDE.md)
- Research to rely on: `docs/research/store-audit-122.md` F6 (R365 one log **WL-000002**, 09/28/2026, 1 item, **$0.92**, Approved; Toast Food waste this month **$0** / 0 items; void-reason setup page not found `(?)`). Facts marked `(?)` stay unverified unless this capture shows them.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture

Capture does not start until the owner is signed in to **Toast** and **R365** in Chrome on the PC, Toast restaurant **00122 - Cary 1**, R365 store **CARY 1**, and the owner/manager is ready at the Cary 1 POS to make the one test waste entry (operational follow-up #1; drafting does not wait, capture does). Runbook row 9 (PC clone `C:\fhs\fhs-skills`, restricted key, alias) is already done. `browser-02` stays parked. **Must not share the PC with another lane's capture at the same time.** The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/waste-log-122.zip` into `/srv/fhs-build/reports/waste-log-122-captures/`. Do not recapture F2–F5 or F8–F13. Do not open ADP, CAMDEN SQUARE, or the manager's old waste sheet.

## Verdict

No build (research only). Research note and `tech-stack.md` lines only — no skill, no script. The capture agent does not change Toast or R365. The owner/manager makes one test waste entry on the POS (voided or marked test as Toast allows). A weekly "sheet vs R365" skill comes later from the note, with the owner's OK.

## What changes, in plain words

Associates will log waste on the Toast POS, not on a manager sheet typed into R365. This check finds out what that POS waste button and the void/waste reasons really are, who sets the reasons (franchise or you), where Toast Food waste reporting shows them, and whether that waste shows up in R365's waste log and in AvT. You (or the manager) make one test waste on the POS so we can see it in the Toast report with the same item, reason and $. A note on the server records what the screens show. Nothing else in Toast or R365 is changed.

## Files the researcher may edit

- `docs/research/waste-log-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the Toast and R365 parts (`## Store 122 audit (2026-10-11)` / those waste facts): POS waste / void-reason facts, Toast Food waste reporting facts, and whether Toast waste reaches R365 and AvT. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/waste-log-01.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\waste-log-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/waste-log-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/waste-log-122-captures/`. Tester report: `/srv/fhs-build/reports/waste-log-01-test.md`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any skill script; any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Capture files (read, never edited)
- Everything else, inside or outside the clone

## Live systems touched

None by the agent. Toast (`https://www.toasttab.com/restaurants/admin/`, restaurant **00122 - Cary 1**) and R365 (`https://fhs4021089.restaurant365.com/`, **CARY 1**) are **read-only** on the owner's PC, owner signed in. Each click still needs the owner's yes at the time (this plan's yes is view / filter / scroll / export, plus opening list/detail pages and one blank R365 new-waste-log form to read it, then Cancel or Close).

The only write is the owner/manager's **one test waste entry on the Cary 1 Toast POS**, then voided or marked test as Toast allows. The capture agent does not tap the POS and does not Save on R365.

Allowed and forbidden actions as `cash-122-01` / `count-sheet-122-01`, plus the waste-only extras below:

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text. Open WL-000002, item detail (waste account fields), AvT Location Summary, and the R365 new-waste-log form to read them, then Close / Cancel.
- **Forbidden:** Save, Submit, Approve, Complete, Post, Create (other than opening the one blank R365 new-waste-log form), New, Add (other than that same blank form), Edit, Delete, Import, Map, Sync, Run, Send, Pay, Void (on Toast Web), any persistent toggle or checkbox, any settings page edit. No user or permission changes. Do not open Ad hoc report (it needs a save). Do not enter waste in R365. Do not tap or drive the POS.
- **Blank form:** open the R365 new-waste-log form only to read its fields (reasons, items, cost source, accounts). Leave with Cancel or Close, never Save. If it cannot be closed without saving, **stop and ask the owner**. Do not type into the form except as needed to leave it.
- **Exports** (download a CSV or PDF of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\waste-log-122\` with the other captures. An export never changes data.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.
- Any misclick goes in the report as a deviation (`## Deviations` in the note; not a new allowed action).

Six parts, in this order. Parts 2–6 are listed in `docs/prompts/waste-log-01-capture.md` with file names. Known starts (confirm; unknown `(?)`): Toast Menus → Food waste reporting (audit `F6-02`); R365 Inventory → Waste `/react/inventory/waste-logs?activeTab=wasteLogs` (audit `F6-01`); R365 Inventory → Items `/react/inventory/purchase-items` (waste/donation account columns, audit F2); R365 Actual vs Theoretical Location Summary (parameter **Variance includes waste**, audit `F7-02`). Toast void/waste-reason setup page and the POS waste-button name are `(?)` until this capture. Do not reopen F2–F5 or F8–F13 except the AvT Location Summary parameter and whether this test waste is listed there. Do not re-audit food-cost totals.

1. `POS-*` — **Owner/manager at the Cary 1 Toast POS (not the PC agent).** Screenshot of the waste button (name as shown). One test waste entry: item, reason, **$**. Then void it or mark it test as Toast allows; record which of those Toast actually offered. Drop the screenshot and a short steps note into `C:\fhs\reports\waste-log-122\` (phone photo is fine). If there is no waste button, capture what the POS showed instead and stop the test entry; the report and R365 checks still run, and the button stays `(?)`.
2. `TWR-*` — **PC capture, Toast Food waste reporting (00122 - Cary 1), after the test entry.** Same item, reason and **$** as `POS-*`. Record the report name, path, and date filter used. If the test row is missing, capture the empty/wrong total and mark `(?)` with what was filtered.
3. `VDR-*` — **PC capture, Toast void/waste reasons.** The reason list and the setup page if found (who can add/edit: owner, franchise, or can't tell from the screen). If still not in Toast nav, capture the menus searched and keep `(?)`.
4. `WL-*` — **PC capture, R365 Inventory → Waste (CARY 1), after the test entry.** The list (does a new log appear for the test, or still only WL-000002?). Open **WL-000002** detail (fields, item, reason, cost, account). Open the **new-log form**, read fields, Cancel/Close, never Save.
5. `ACC-*` — **PC capture, R365 item waste accounts.** From item detail (and the items-grid waste-account column if shown): where a wasted item's cost and waste account come from. Use the item on WL-000002 if named, plus **one** other CARY 1 food item. Do not recapture the 551-item grid.
6. `AVT-*` — **PC capture, R365 AvT Location Summary, view only.** The **Variance includes waste** setting as shown, and whether this test waste is listed. Do not click Run on AvT Analysis if it still wants ToCount. If the test cannot show on AvT yet, `(?)` plus what is missing.

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (header exactly `time,URL,action`; action = view / filter / scroll / export / close). WL-000002, item detail, AvT, and the blank new-log form are **view** only and must be closed with Cancel/Close (`close`). A `create` / `new` URL is allowed only for that one blank-form open that was closed without save. `POS-*` has no `pages.csv` URL (physical POS); the steps note names the button and the $.

**Join (Researcher, after unzip).** Answer from these files plus `docs/research/store-audit-122.md` F6 only. Audit facts marked `(?)` stay unverified unless this capture shows them. The note states: (a) POS button name and steps, or `(?)`; (b) who sets Toast reasons (franchise vs owner), or `(?)`; (c) where Food waste reporting shows item, reason and $ — the test row's $ equals the POS $; (d) whether that Toast waste appears as an R365 waste log (integration, or not / not yet); (e) whether it reaches AvT (Variance includes waste, and the test row if shown). Cost source and waste accounts from `WL-*` / `ACC-*`. Who owns each setting seen.

## Owner steps

1. Sign in to Toast and R365 in Chrome and pick **00122 - Cary 1** / **CARY 1** where a store picker exists. No other lane may use the PC for capture at the same time.
2. At the Cary 1 POS, screenshot the waste button, make **one** test waste (item, reason, $), then void it or mark it test as Toast allows. Put the screenshot, a short steps note (void vs mark as test) and the item / reason / $ into `C:\fhs\reports\waste-log-122\`. If Toast has no waste button, stop the entry and say so.
3. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\waste-log-122\`, and send the zip with `send-report.ps1` as `waste-log-122.zip` (agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`. If the R365 new-log form cannot be closed without saving, or a login / MFA prompt appears, stop and answer before anything else is opened.
4. After merge, confirm nothing else changed: no R365 waste log **saved by the capture** (a new log that arrived by itself from Toast is a finding, not an agent write); the new-log form was not saved; Toast has only that one owner/manager test waste (voided or marked test as allowed). That post-merge case is not a merge gate.

## Done-check (real outcome)

1. `docs/research/waste-log-122.md` exists. Every claim cites a capture file that exists, or is marked `(?)` with what is missing.
2. Test entry: POS button name and steps (with a screenshot in `POS-*`) → Toast Food waste reporting (`TWR-*`) shows the same item, reason and **$**. If there was no button, both the button and the report row are `(?)` and the note says so.
3. The note answers who sets Toast void/waste reasons (franchise vs owner) from `VDR-*`, or `(?)`.
4. The note answers whether the test Toast waste appears in the R365 waste list (`WL-*`) and on AvT (`AVT-*`), or `(?)` plus what is missing. R365 new-log form was opened and not saved.
5. `## Deviations`: every misclick, as in recipes-122-01, or "none".
6. Plain-words summary for the owner, ≤6 lines.

## Where it runs

- **POS test:** Cary 1 Toast terminal, owner/manager. Not a Windows app and not the capture agent.
- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Files under `C:\fhs\reports\waste-log-122\`. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK). Must not share the PC with another lane's capture at the same time.
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files plus `docs/research/store-audit-122.md` F6 only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. Untouched until the merge of the note; no skill changes. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** POS test and read-only PC capture only; the note is not live until merge. Sessions still get current `main`.

## Where the builder works

`/srv/fhs-build/waste-log-01` via `scripts/build.sh prepare docs/plans/waste-log-01.md waste-log-01 --role research`. `prepare` clones `main` at the commit that holds this plan, its task file, the capture task (`docs/prompts/waste-log-01-capture.md`, which the PC clone also needs), the test plan and the APPROVE review; the researcher creates `feat/waste-log-01` in that clone per the task. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/waste-log-122.zip` into `/srv/fhs-build/reports/waste-log-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/waste-log-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/waste-log-01.md`, `docs/prompts/waste-log-01-capture.md`, `docs/tests/waste-log-01.md` and that review to `main` before prepare. A missing capture file on `main` blocks PC capture (capture is before `prepare`; `prepare` does not require that file). Refresh the PC clone at `C:\fhs\fhs-skills` from that `main` before capture so it has the approved capture task.
2. Gate: owner signed in to Toast and R365 in Chrome on the PC, 00122 / CARY 1; owner/manager ready at the POS for the one test waste; no other lane using the PC for capture.
3. Owner/manager POS test (`POS-*`), then capture on the PC from `docs/prompts/waste-log-01-capture.md` (Toast report and reasons, then R365 waste list/detail/form, item accounts, AvT); zip; `send-report.ps1` to `/root/fhs-skills/inbox/waste-log-122.zip`.
4. `build.sh prepare docs/plans/waste-log-01.md waste-log-01 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/waste-log-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files plus `docs/research/store-audit-122.md` F6; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect waste-log-01 --role research`.
9. `review.sh --diff feat/waste-log-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/waste-log-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Note exists. Every claim cites a capture file that exists, or is marked `(?)` with what is missing.
- Test entry: POS button name and steps with a screenshot (`POS-*`) → Toast Food waste reporting (`TWR-*`) shows the same item, reason and **$**. Tester reads those files; does not open Toast.
- `pages.csv`: only view/filter/scroll/export/close actions; no forbidden click or URL (Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Map, Sync, Run, Send, Pay, Void). The one R365 new-log form, action `view` / `close`, closed without save, is the only `create`/`new` URL allowed. `POS-*` is owner/manager at the terminal (no URL).
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty) and adds only waste / Food-waste / R365-and-AvT facts.
- Post-merge (owner): no R365 or Toast record changed by the capture beyond the one owner/manager test waste (voided or marked test as Toast allows). A new R365 log that arrived by itself from Toast is recorded as a finding, not a capture write.

Researcher and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in Toast, R365 and ADP except the one owner/manager test waste on the POS. No R365 waste log is typed or saved. No item, account, reason list, or franchise-owned setting is edited. Store 878 / NCR, the manager's old sheet, the weekly "was waste logged" skill (spec P1), and wiring waste into AvT as a product change (spec P2) stay out of scope. Payroll is unchanged. `browser-02` stays parked. The Windows mirror is unchanged. A later plan may write the skill or change a setting, each with the owner's OK.
