# Plan · store-audit-122-02 · 122 store audit, captured on the owner's PC

Drafted by Cursor Grok 4.6 High from docs/briefs/store-audit-122-02.md.

2026-10-11. Plan only, not approved. Don't build from it until `docs/reviews/store-audit-122-02.md` holds an APPROVE for this file.
The reviewer checks this plan, its researcher task `docs/prompts/store-audit-122-02.md`, its capture task `docs/prompts/store-audit-122-02-capture.md`, and its test plan `docs/tests/store-audit-122-02.md` together.
It replaces `docs/plans/store-audit-122-01.md` (server-browser version, never approved; keep it as history). Reuse that plan's read-only rules, forbidden-action list, rows F2–F13 and done-check shape. Don't add scope.

- Hub project: `projects/r365-inventory` (Phase 0) · Spec: `docs/specs/store-audit-122.md` (its "server browser" wording is superseded by the decisions below; Claude updates the spec after the review)
- Research to rely on: `docs/research/windows-agent.md`, `docs/runbooks/windows-agent.md` (`send-report.ps1`, `inbox/`)
- Decisions that bind it (hub log): 2026-10-10T17:00 desktop first, browser-02 parked; 2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, no Cursor agent on the PC, restricted key; 2026-10-10T16:02 read-only exports allowed; 2026-10-10T16:03 audit first, then ask q1–q5; 2026-10-10 R365 inventory/food cost first, build at 122 first, F1 audits every function F2–F13, functions in place get verify-only plans
- `ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`)

## Pre-start gate: PC capture (runbook rows 9–10)

Capture does not start until:

1. **Row 9:** windows-agent PC steps done — clone at `C:\fhs\fhs-skills`, restricted key, `dev-lxc-1-agent` alias (`docs/runbooks/windows-agent.md`).
2. **Row 10:** the owner is signed in to R365 and Toast in Chrome (Claude in Chrome), store 122 (Cary 1, Toast restaurant 366968) where a store picker exists.

`browser-02` stays parked. The Researcher never opens a browser.

## Verdict

Build (a research note plus one `tech-stack.md` section, no code).

## What changes, in plain words

Same audit as -01: what R365 and Toast already do for store 122, function by function, read-only. Capture runs on your PC (Claude Code + Claude in Chrome, you already signed in), saves screenshots, page text and allowed exports, zips them, and sends the zip to the server inbox. Ops copies that zip for the researcher. A Grok agent on the server writes the note from those files only. Nothing in R365 or Toast is changed. The result decides which functions we build, which we only verify, and which belong to the franchise.

## Files the researcher may edit (in its clone)

- `docs/research/store-audit-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: one new section `## Store 122 audit (<date>)`, added lines only, confirmed facts only, each one line with a pointer to the audit note's section
- Outside the repo, only `/srv/fhs-build/reports/store-audit-122-02.md` (report)

Captures live outside the repo and are not edited by the researcher: `C:\fhs\reports\store-audit-122\` on the PC; zip via `scripts/windows/send-report.ps1` into `/root/fhs-skills/inbox/`; Ops copy and unzip at `/srv/fhs-build/reports/store-audit-122-captures/`. Tester report: `/srv/fhs-build/reports/store-audit-122-02-test.md`.

## Files the researcher must not edit

- The served tree `/root/fhs-skills`
- `shared/config.json`
- Any other file under `skills/`
- `docs/` other than the note
- Everything else, inside or outside the clone

## Live systems touched

R365 (`https://fhs4021089.restaurant365.com/`) and Toast Web (`https://www.toasttab.com/restaurants/admin/`, restaurant 366968): **read-only**, on the owner's PC, owner signed in. Allowed and forbidden actions exactly as -01:

- **Allowed:** navigation, opening list and detail pages, opening reports on screen, changing on-screen filters or date ranges, taking screenshots, saving page text.
- **Forbidden:** Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay, Print-to-vendor, Calculate, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes.
- **Exports** (download a CSV or PDF of a report): allowed without asking (owner, 2026-10-10). Read-only report exports only, saved under `C:\fhs\reports\store-audit-122\` with the other captures. An export never changes data.
- Claude in Chrome never types credentials. A login or MFA prompt means stop and ask the owner.

Capture files: `<area>-<nn>.png` / `.txt`, plus `pages.csv` (time, URL, action = view/filter/export). The capture task `docs/prompts/store-audit-122-02-capture.md` lists, per F2–F13 plus licensed modules, integration health and setting ownership, the R365/Toast pages to open, what to capture, and those file names.

## Owner steps

1. Finish runbook row 9 if it is not done (clone, restricted key, alias).
2. Sign in to R365 and Toast Web in Chrome and pick store 122 where a store picker exists (row 10).
3. On the PC, run the capture task (Claude Code + Claude in Chrome, read-only), zip `C:\fhs\reports\store-audit-122\`, and send the zip with `send-report.ps1` (name matching `^[A-Za-z0-9._-]{1,120}$`, e.g. `store-audit-122.zip`; agent jobs use `-SshHost dev-lxc-1-agent`) until it prints `MATCH`.
4. After the run, answer hub q1–q5 for any item the note marks "can't tell (owner)" (audit first, then ask; not a merge gate).

## Done-check (real outcome)

1. The note has rows F2–F13 (12), plus "Licensed modules", "Toast → R365 integration" (last sales and labor import dates) and "Who owns what". Each row: status (in place / partial / missing / can't tell), evidence (menu path + capture file), owner.
2. Every "in place"/"partial" row names a capture file that exists in `/srv/fhs-build/reports/store-audit-122-captures/`.
3. The tester picks 5 claims and confirms each against its capture (screenshot or page text), and checks `pages.csv` has no forbidden action.
4. `tech-stack.md` diff: added lines only, one section.
5. Post-merge (not a gate): the owner confirms nothing changed in R365 or Toast; a fresh PC Claude session re-captures the 5 tester-picked pages and they still match.

## Where it runs

- **Capture:** owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the capture task). Windows apps: Chrome with Claude in Chrome, PowerShell, `send-report.ps1`.
- **Note, tests, review:** server (dev-lxc-1). The Researcher (Grok, `fhsbuild`) writes from capture files only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`. On merge, the `tech-stack.md` section becomes visible to server sessions (reference text only).
- **Windows mirror:** unchanged. A refresh is a separate OK.
- **Live before merge:** capture is read-only on the PC; the note is not live until merge.

## Where the researcher works

`/srv/fhs-build/store-audit-122-02` via `scripts/build.sh prepare docs/plans/store-audit-122-02.md store-audit-122-02 --role research`, branch `feat/store-audit-122-02`, cut from the `main` commit that holds this plan, its task file, the capture task (`docs/prompts/store-audit-122-02-capture.md`, which the PC clone also needs), the test plan and the APPROVE review. Model `cursor-grok-4.6-high`, user `fhsbuild`. Starts only after Ops has copied and unzipped the inbox zip into `/srv/fhs-build/reports/store-audit-122-captures/`.

## Sequence

`ROLE=research`, `WRITER=grok` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh docs/plans/store-audit-122-02.md --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/store-audit-122-02.md`, `docs/prompts/store-audit-122-02-capture.md`, `docs/tests/store-audit-122-02.md` and that review to `main` before prepare.
2. Gate: runbook rows 9–10 (clone, restricted key; owner signed in to R365 and Toast in Chrome).
3. Capture on the PC from `docs/prompts/store-audit-122-02-capture.md`; zip; `send-report.ps1` to `/root/fhs-skills/inbox/`.
4. `build.sh prepare docs/plans/store-audit-122-02.md store-audit-122-02 --role research`.
5. **Ops copies the inbox zip into `/srv/fhs-build/reports/store-audit-122-captures/` and unzips it there for `fhsbuild`, before the Researcher starts.**
6. The Researcher (Cursor Grok 4.6 High) writes the note from those files only; it never opens a browser.
7. A fresh Composer tester (`composer-2.5`) tests against the captures (not a live browser).
8. `build.sh collect store-audit-122-02 --role research`.
9. `review.sh --diff feat/store-audit-122-02 --writer grok`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE.

Before any re-review, the earlier review file is renamed to the next `-rN` / `-diff-rN` and committed. No research code runs as root.

## Test plan

`docs/tests/store-audit-122-02.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers. Cases the test plan must include:

- Note structure: 12 F-rows + 3 sections; every row has status, evidence, owner.
- Every cited capture file exists; every "in place"/"partial" has one.
- 5 tester-picked claims match their captures.
- `pages.csv`: no action outside view/filter/export; no URL with save/submit/post/approve paths (forbidden-action list from Live systems touched / -01 T7: no edit, new, import or mapping action URL).
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines (`grep '^-[^-]'` empty).
- Owner case (post-merge): nothing changed; the 5 tester-picked pages re-captured on the PC still match.

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped).

## What stays

Everything in R365, Toast and ADP. Payroll is unchanged. `browser-02` stays parked. Store 878 is out of scope. The build order in `docs/specs/store-migration.md` stays as it is until the planner updates it from this audit. Hub q1–q5 are asked after the audit, not during capture.
