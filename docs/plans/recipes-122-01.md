# Plan · recipes-122-01 · Cary 1 items sold last week → R365 recipe mapped or not, cost present or $0

Drafted by Cursor Grok 4.6 High from docs/briefs/recipes-122-01.md.

2026-10-12. Plan only, not approved. Don't build from it until `docs/reviews/recipes-122-01.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/recipes-122-01.md`, its capture task `docs/prompts/recipes-122-01-capture.md`, and its test plan `docs/tests/recipes-122-01.md` together.
Don't add scope. A fix plan or support request comes later from the note.

- Hub project: `projects/r365-inventory` (F4, verify-only) · Phase: plan page https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK · Spec: `docs/specs/recipes-122.md` · Decisions that bind it: 2026-10-10T16:02 read-only exports allowed; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, restricted key; 2026-10-12T10:00 no R365 change without an OK per change; 2026-10-12 assumption: week 10/05–10/11/2026 (fallback 09/28–10/04)
- Research to rely on: `docs/research/store-audit-122.md` F4 (2,331 recipes, 64,670 menu items, $0.00 Estimated Cost, Toast target "Firehouse Subs Group - 435 groups, 1 location"); `skills/fhs-skills/references/tech-stack.md` R365 Recipes line (400120 recipe $1.1858 vs menu item $0.00; the Recipe filter can't select blank). Facts marked `(?)` stay unverified unless this capture shows them.
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture

Capture does not start until the owner is signed in to **Toast and R365** in Chrome on the PC, store **CARY 1** / restaurant **00122 - Cary 1**. Runbook row 9 (PC clone `C:\fhs\fhs-skills`, restricted key, alias) is already done. `browser-02` stays parked. The Researcher never opens a browser. The Researcher starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/recipes-122.zip` into `/srv/fhs-build/reports/recipes-122-captures/`.

## Verdict

No build (verify-only). Research note and `tech-stack.md` lines only — no skill, no script, no Toast or R365 change.

## What changes, in plain words

This check does not change Toast or R365. On the PC we export last week's Cary 1 item and modifier sales, and we export R365 menu items and recipes (or filter those grids to the names that sold). A note on the server lists each sold row as mapped or unmapped, and whether the recipe has a cost or $0.00. A later plan or a support request can be written from that note.

## Files the researcher may edit (in its clone)

- `docs/research/recipes-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: added lines only, in the Toast and R365 parts: the sales export path, and where POS mapping lives. No new top-level section. No other lines changed.
- Outside the repo, only `/srv/fhs-build/reports/recipes-122-01.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\recipes-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/recipes-122.zip`; Ops copy and unzip at `/srv/fhs-build/reports/recipes-122-captures/`. Tester report: `/srv/fhs-build/reports/recipes-122-01-test.md`.

## Files the researcher must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `shared/config.json`
- Any other file under `skills/` (except the added `tech-stack.md` lines above)
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

Toast (`https://www.toasttab.com/restaurants/admin/reports/home`, restaurant **00122 - Cary 1**) and R365 (`https://fhs4021089.restaurant365.com/`) only, **read-only**, on the owner's PC, owner signed in. Each click still needs the owner's yes at the time (this plan's yes is view / filter / scroll / export, plus opening a detail page to read it then Close).

Allowed and forbidden actions as `count-sheet-122-01`, minus that plan's blank-form and store-run extras, plus the Toast/recipe extras below:

- **Allowed:** view, filter, scroll, export/download. Navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text. Open a detail page to read it, then Close.
- **Forbidden:** Save, Create, Edit, Map/assign, Update recipe costs, Publish, Delete, any status button, any menu or price change, Submit, Approve, Post, Import, New, Add, Sync, Run (any job), or any toggle and checkbox that persists. No settings pages edited. No user or permission changes. Do not click **Update recipe costs**.
- **Exports** (download a CSV or XLSX of a report or grid): allowed without asking (owner, 2026-10-10). Read-only exports only, saved under `C:\fhs\reports\recipes-122\` with the other captures. An export never changes data. If a full Menu Items or Recipes export is too big, filter by the sold names from the Toast export instead.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

Week: last complete Mon–Sun **10/05–10/11/2026**. If R365 sales for that week are not posted yet, use **09/28–10/04/2026** (the 10/04 count week) and say which. The note uses one week for Toast and R365.

Three parts, in this order. Parts 1–2 are listed in `docs/prompts/recipes-122-01-capture.md` with file names. Known starts (confirm; unknown `(?)`): Toast Reports (product mix or item/modifier selection details; report name and path `(?)` until this capture); R365 Menu Items `/react/inventory/legacy/MenuItems`; R365 Recipes `/react/inventory/recipe-items`.

1. `SAL-*` — **PC capture, Toast.** Export sales by item and by modifier option for restaurant **00122 - Cary 1** for the week (CSV/XLSX). Record the report name and path seen. Also capture the week's net sales total.
2. `MNU-*` / `RCP-*` / `MAP-*` — **PC capture, R365.** Export Menu Items and Recipes with name, POS id/code, recipe, and cost columns. If the full export is too big, filter by the sold names from step 1. Capture any POS-item mapping, "unmapped", or sales-by-menu-item screen R365 shows, plus what the menu item says its POS or location is. Open a recipe or menu-item detail only to read it, then Close. Do not click **Update recipe costs**.
3. **No browser (Researcher, after unzip):** join sold rows to R365 by POS code first (the six-digit number, e.g. 400120), then exact name. Mark each mapped/unmapped, recipe cost present / `$0.00` / `(?)`. No fuzzy matches counted as mapped; list them as `(?) possible`.

Capture files: `<area>-<nn>.png` / `.txt` (and allowed exports), plus `pages.csv` (header exactly `time,URL,action`; action = view / filter / scroll / export / close). Menu-item and recipe detail pages are allowed as **view** only and must be closed with Close.

## Owner steps

1. Sign in to Toast and R365 in Chrome. Pick restaurant **00122 - Cary 1** in Toast and store **CARY 1** in R365 where a store picker exists.
2. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\recipes-122\`, and send the zip with `send-report.ps1` as `recipes-122.zip` (agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`. If a login / MFA prompt appears, stop and answer before anything else is opened.
3. After merge, confirm nothing changed in Toast or R365 (recipe 400120 still $1.1858 or its later system cost; no new mapping). That post-merge case is not a merge gate.

## Done-check (real outcome)

1. `## Sold items` table: Type (item/modifier), Toast name, POS code if shown, qty, net sales, R365 recipe or `unmapped`, recipe cost. Row qty and net sales sum to the Toast export totals for the week (within $1); the note shows both sums.
2. `## Totals`: rows, unmapped, $0-cost, `(?) possible`, and the % of week net sales on unmapped or $0-cost rows.
3. `## How mapping works`: each fact `seen` + capture, or `(?)` + what is missing (where mapping lives; Toast or other POS; why menu items show $0.00 while recipes have cost).
4. Plain-words summary for the owner, ≤6 lines.

## Where it runs

- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`. Files under `C:\fhs\reports\recipes-122\`. Deploying a desktop skills mirror is not this plan (a refresh is a separate OK).
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files plus `docs/research/store-audit-122.md` F4 and the R365 Recipes line in `skills/fhs-skills/references/tech-stack.md` only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge only the note and the `tech-stack.md` lines become visible.
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture is read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/recipes-122-01` via `scripts/build.sh prepare docs/plans/recipes-122-01.md recipes-122-01 --role research`. `prepare` clones `main` at the commit that holds this plan, its task file, the capture task (`docs/prompts/recipes-122-01-capture.md`, which the PC clone also needs), the test plan and the APPROVE review; the researcher creates `feat/recipes-122-01` in that clone per the task. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped `/root/fhs-skills/inbox/recipes-122.zip` into `/srv/fhs-build/reports/recipes-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/recipes-122-01.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/recipes-122-01.md`, `docs/prompts/recipes-122-01-capture.md`, `docs/tests/recipes-122-01.md` and that review to `main` before prepare. A missing capture file on `main` blocks PC capture (capture is before `prepare`; `prepare` does not require that file). Refresh the PC clone at `C:\fhs\fhs-skills` from that `main` before capture so it has the approved capture task.
2. Gate: owner signed in to Toast and R365 in Chrome on the PC, restaurant 00122 - Cary 1 / store CARY 1.
3. Capture on the PC from `docs/prompts/recipes-122-01-capture.md` (Toast sales, then R365 menu items and recipes); zip; `send-report.ps1` to `/root/fhs-skills/inbox/recipes-122.zip`.
4. `build.sh prepare docs/plans/recipes-122-01.md recipes-122-01 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/recipes-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files plus `docs/research/store-audit-122.md` F4 and the R365 Recipes line in `tech-stack.md`; it never opens a browser. Audit facts marked `(?)` stay unverified unless this capture shows them. Join by POS code first, then exact name; fuzzy matches are `(?) possible`, not mapped.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect recipes-122-01 --role research`.
9. `review.sh --diff feat/recipes-122-01 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/recipes-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Sum of table qty and net sales = Toast export totals (within $1), recomputed by the tester from the export file.
- 10 random table rows checked against the R365 exports: mapping and cost match. Every `mapped` row has an exact code or name match.
- Each `## How mapping works` answer cites a capture file that exists; each `(?)` names what is missing.
- `pages.csv`: only view/filter/scroll/export/close actions; no save/create/edit/map/update-costs/publish/delete click or URL.
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Post-merge (owner): nothing changed in Toast or R365 (recipe 400120 still $1.1858 or its later system cost; no new mapping).

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## What stays

Everything in Toast, R365 and ADP. No mapping, recipe edit, cost update, menu edit, or price change. Franchise-owned settings are not edited. Store 878 / CAMDEN SQUARE (NCR), recipes that did not sell, the F2 item-cost problems, and food cost % (F7) stay out of scope. Payroll is unchanged. `browser-02` stays parked. The Windows mirror is unchanged. A fix plan or support request is a later plan, each with the owner's OK.
