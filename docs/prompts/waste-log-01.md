# Agent task · waste-log-01 · research

> **For the coding agent (Cursor Grok 4.6 High via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Drafted by Cursor Grok 4.6 High from `docs/briefs/waste-log-01.md`, to be run only after its plan review (`docs/reviews/waste-log-01.md`) is APPROVE on `main`.
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model cursor-grok-4.6-high --force --workspace /srv/fhs-build/waste-log-01`
> and tell it "Do the task in docs/prompts/waste-log-01.md". Start only after Ops has copied and unzipped `/root/fhs-skills/inbox/waste-log-122.zip` into `/srv/fhs-build/reports/waste-log-122-captures/`. Do not run `docs/prompts/waste-log-01-capture.md`. No new capture.

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). Store 122 (Cary 1) is moving waste off a manager sheet typed
into R365 and onto the Toast POS. This task is verify-only F6: from PC captures plus one
owner/manager POS test already done, record what the POS waste button and void/waste reasons really
are, who sets those reasons (franchise vs owner), where Toast Food waste reporting shows item,
reason and $, and whether that Toast waste reaches the R365 waste log (integration or not / not yet)
and AvT. You never open a browser. Nothing in Toast or R365 is changed by you. A weekly "sheet vs
R365" skill comes later from the note. Capture is already done.

## Where you work

- Workspace: `/srv/fhs-build/waste-log-01`, your own clone of the repo. Work only here.
- Branch: create `feat/waste-log-01` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.
- This job's captures (read only, outside the repo, already unzipped): `/srv/fhs-build/reports/waste-log-122-captures/`.
  `pages.csv` plus `POS-*`, `TWR-*`, `VDR-*`, `WL-*`, `ACC-*`, `AVT-*`. Names are `<area>-<nn>.png` / `.txt` (and allowed exports; a POS phone photo `.jpg` is fine). `pages.csv` columns: time, URL, action = view/filter/scroll/export/close. `POS-*` has no `pages.csv` URL (physical POS); the steps note names the button and the $.
  Areas: `POS` (owner/manager at the Cary 1 Toast terminal: waste-button screenshot, one test waste item / reason / $, then voided or marked test as Toast actually offered — or what the POS showed if there is no waste button), `TWR` (Toast Food waste reporting, restaurant **00122 - Cary 1**, after the test: same item, reason and **$**, report name, path, date filter), `VDR` (Toast void/waste reasons: the list and the setup page if found, who can add/edit, or the menus searched), `WL` (R365 Inventory → Waste, **CARY 1**, after the test: the list, **WL-000002** detail, the blank new-log form read then Cancel/Close never Save), `ACC` (R365 item waste accounts: the WL-000002 item if named, plus **one** other CARY 1 food item; not the 551-item grid), `AVT` (R365 AvT Location Summary, view only: **Variance includes waste**, and whether this test waste is listed).

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/waste-log-01.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `docs/specs/waste-log.md`
4. `docs/prompts/waste-log-01-capture.md` (record of the completed capture's file-name pattern. Do not run it.)
5. `docs/research/store-audit-122.md` F6 only (R365 one log **WL-000002**, 09/28/2026, 1 item, **$0.92**, Approved; Toast Food waste this month **$0** / 0 items; void-reason setup page not found `(?)`). Facts marked `(?)` stay unverified unless this capture shows them. F6 is expected size only, not this check's POS-test or integration evidence.
6. `skills/fhs-skills/references/tech-stack.md` (append lines later in the Toast and R365 parts of `## Store 122 audit (2026-10-11)`; do not treat the F6 waste bullet as this check's POS-test evidence)

## Steps

1. `git switch feat/waste-log-01` if that branch already exists, else `git switch -c feat/waste-log-01`.
2. Confirm `/srv/fhs-build/reports/waste-log-122-captures/` exists and contains `pages.csv`, at least one `POS-*` file, at least one `TWR-*` file, and at least one `WL-*` file. List this job's capture files. If any of those confirms fail, stop and write the report with that reason. `VDR-*`, `ACC-*`, and `AVT-*` are expected. If the capture stopped at the R365 new-log-form gate (could not close without saving) or a login/MFA stop, a `*-missing.txt` (or equivalent stop note) is expected; do not stop for that — finish the note and use `(?)` where those files are missing.
3. **Hard rule: this job's capture folder and `docs/research/store-audit-122.md` F6 only. Never open a browser.** Do not use Playwright MCP, Chrome DevTools MCP, Cursor's built-in browser, or any other browser tool. Do not visit R365, Toast, or ADP. Do not `curl` those hosts. Do not type credentials. Read `pages.csv` and the capture files; do not edit them. Do not start a new PC capture. Do not recapture F2–F5 or F8–F13. Do not recapture F6 from the store-audit zip. Do not read `/srv/fhs-build/reports/store-audit-122-captures/`, `/srv/fhs-build/reports/recipes-122-captures/`, `/srv/fhs-build/reports/items-122-captures/`, `/srv/fhs-build/reports/invoices-122-captures/`, `/srv/fhs-build/reports/count-lines-122-captures/`, `/srv/fhs-build/reports/count-sheet-122-captures/`, or `/srv/fhs-build/reports/cash-122-captures/` as this check's evidence. Do not re-audit food-cost totals. Do not open ADP, CAMDEN SQUARE, or the manager's old waste sheet. Do not tap or drive the POS.
4. From those files only, write `docs/research/waste-log-122.md`. Start with `# Research · waste-log-122 · Cary 1: Toast POS waste, Food waste reporting, R365 log and AvT` and the date. Then:

   1. **`## Summary for the owner`** — plain words, **≤6 lines**: the POS button name (or no button), whether the test row appeared in Toast Food waste reporting with the same item, reason and $, who sets Toast reasons (or `(?)`), and whether that Toast waste showed in the R365 waste list and on AvT. Do not recommend a skill, a manager guide, or an AvT product change.

   2. **`## How cells were filled`** — which POS/TWR/VDR/WL/ACC/AVT files, that `POS-*` is owner/manager at the terminal (no URL), the test item / reason / $, whether Toast offered void or mark-as-test (record which, from the POS steps note), the TWR report name / path / date filter, and whether the R365 new-log form was closed with Cancel/Close or the capture stopped. No empty explanation of a column you then leave blank.

   3. **`## Test entry`** — two data rows, columns in this order:

      | Source | Button or report | Item | Reason | $ | Capture |

      - Row 1 **Source** is exactly `POS`. **Button or report** is the waste-button name as shown on the terminal, or `(?)` plus what the POS showed if there is no waste button. **Item**, **Reason**, **$** are the one test waste, or `(?)` if there was no button / no test entry. **Capture** is a `POS-*` screenshot (png/jpg) and/or the steps note. Cite the real file that shows the button (or the no-button screen).
      - Row 2 **Source** is exactly `Toast Food waste reporting`. **Button or report** is the report name and path as shown (`TWR-*`), plus the date filter used. **Item**, **Reason**, **$** are the test row on that report, or `(?)` plus what was filtered if the test row is missing. **Capture** is a `TWR-*` file.
      - No empty cells. If a capture does not show a value, write `(?) <reason>` or `not shown (<file>)` in that cell.
      - Then this line exactly, filled from those two rows: `same_item_reason_dollar: yes` when POS Item, Reason and $ equal the TWR Item, Reason and $; `same_item_reason_dollar: no` when a test entry exists and they differ; `same_item_reason_dollar: (?) no button` when there was no waste button (both the button and the report row stay `(?)` and this line says so); `same_item_reason_dollar: (?) TWR row missing` when a test entry exists but TWR has no matching row.

   4. **`## Toast reasons`** — answer each question with `seen` + capture file, or `(?)` + what is missing. Do not click and do not infer a click. F6 "void-reason setup page not found" stays unverified unless this capture shows the page (or still does not). Then:

      | Q | Answer | Capture |

      - **(a)** What void/waste reasons are on the list? Answer is `seen: <the labels exactly as written>` or `seen: not shown`, or `(?): <what's missing>`.
      - **(b)** Who can add/edit those reasons: owner, franchise, or can't tell from the screen? Answer is `seen: owner`, `seen: franchise`, `seen: can't tell`, or `(?): <what's missing>` (menus searched if still not in Toast nav).

   5. **`## R365 waste log`** — same `seen` / `(?)` rule. Then:

      | Q | Answer | Capture |

      - **(c)** After the test, does the CARY 1 waste list show a **new** log for that Toast waste, or still only **WL-000002**? Answer is `seen: new log <number>` (integration, or not yet named as such — say what the list shows), `seen: still only WL-000002` (not / not yet), or `(?): <what's missing>`. A new log that arrived by itself from Toast is a finding, not an agent write.
      - **(d)** **WL-000002** detail: item, reason, cost, account as shown, or `(?): <what's missing>`.
      - **(e)** Blank new-log form: field labels seen (reasons, items, cost source, accounts). Closed with Cancel/Close, never Save. Answer is `seen: opened, closed without save` plus the field labels, or `(?): <what's missing>` (including if the capture stopped because it could not close without saving).

   6. **`## Cost and accounts`** — from `WL-*` / `ACC-*` only. Columns:

      | Item | Cost source | Waste account | Capture |

      - One row for the item on **WL-000002** if that log names an item; if it does not, one row with Item `(?)` item not named on `WL-*`.
      - One row for **one** other CARY 1 food item (`ACC-*`). Do not recapture the 551-item grid. Do not copy F2 grid accounts unless this job's `ACC-*` shows them.
      - **Cost source** and **Waste account** as shown on item detail (and the items-grid waste-account column if `ACC-*` shows it), or `not shown (<file>)`, or `(?) <reason>`.
      - No empty cells.

   7. **`## AvT`** — same `seen` / `(?)` rule. Then:

      | Q | Answer | Capture |

      - **(f)** **Variance includes waste** as shown on AvT Location Summary. Answer is `seen: Yes`, `seen: No`, `seen: <the label exactly as written>`, or `(?): <what's missing>`.
      - **(g)** Is this test waste listed there? Answer is `seen: yes`, `seen: no`, or `(?): <what's missing>` (if the test cannot show on AvT yet, `(?)` plus what is missing). Do not treat AvT Analysis / ToCount as this evidence.

   8. **`## Who owns what`** — one row per setting seen on these screens. Columns:

      | Setting | Owner | Capture |

      - **Owner** is exactly one of `owner` / `franchise` / `R365` / `Toast` / `unknown`. From **these** screens (greyed control, brand / location-group / "managed by" label, Created by / Modified by). If this capture does not show it, `unknown`. Do not copy F6 "owner" unless this capture still shows it.
      - Include at least: POS waste button (or none); Toast void/waste reasons; Toast Food waste reporting; R365 waste log; waste accounts; AvT **Variance includes waste**.
      - Every row that is not `unknown` with `(?)` names a capture file that exists in this job's folder.

   9. **`## Deviations`** — every misclick from `pages.csv` or `*.txt` (as in recipes-122-01), or `none`. Not a new allowed action. If opening the R365 new-log form made Save clickable, record that Save was **not** clicked.

5. Match rows to files using the capture task's names (POS/TWR/VDR/WL/ACC/AVT) and `pages.csv`. Cite the real file name under this job's captures folder (e.g. `POS-01.jpg`, `TWR-01.txt`, `WL-02.png`). Every `seen` cell, every Test-entry Capture, every Cost-and-accounts row, and every Who-owns-what row that is not `unknown` with `(?)` must name a capture file that exists there. Typical paths (confirm from the files; unknown `(?)`):

   | Area | Where | Take from it |
   |---|---|---|
   | POS | Cary 1 Toast terminal (not the PC). No URL | button name; test item, reason, $; void vs mark-as-test as offered; or what the POS showed if no button |
   | TWR | Toast Menus → Food waste reporting (audit `F6-02`). Restaurant **00122 - Cary 1** | report name, path, date filter; test row item, reason, $ — or empty/wrong total and the filter used |
   | VDR | Toast void/waste-reason list and setup page `(?)` until this capture | reason labels; who can add/edit; or menus searched |
   | WL | R365 Inventory → Waste `/react/inventory/waste-logs?activeTab=wasteLogs` (audit `F6-01`). **CARY 1** | list after the test; **WL-000002** detail; blank new-log form fields, then Cancel/Close |
   | ACC | R365 Inventory → Items `/react/inventory/purchase-items` and item detail (audit F2 as a start only; do not recapture the 551-item grid) | cost source and waste account for the WL-000002 item if named, plus **one** other CARY 1 food item |
   | AVT | R365 Actual vs Theoretical Location Summary (audit `F7-02`). View only. Do not click Run on AvT Analysis | **Variance includes waste**; whether this test waste is listed |

   Do not copy POS-test numbers, a new R365 log, or Food-waste totals from `docs/research/store-audit-122.md` or `tech-stack.md` unless this capture shows them. Verified audit facts you may use as expected size only: one R365 log **WL-000002**, 09/28/2026, 1 item, **$0.92**, Approved; Toast Food waste this month **$0** / 0 items; void-reason page not found `(?)`. If this capture's R365 list is no longer only WL-000002, or Toast Food waste is no longer $0, use this capture. Audit facts marked `(?)` stay unverified unless this capture shows them.

6. Append to `skills/fhs-skills/references/tech-stack.md` under the existing `## Store 122 audit (2026-10-11)` (Toast and R365 facts): added lines only, **POS waste / void-reason** facts, **Toast Food waste reporting** facts, and **whether Toast waste reaches R365 and AvT**, each with a pointer to `docs/research/waste-log-122.md`. No new top-level `##` section. Change no other line. Do not guess a path the files do not show. Do not rewrite the existing F6 waste bullet (WL-000002, $0.92, Toast food waste this month $0).

7. If this job's `pages.csv` has an action other than view/filter/scroll/export/close, or a URL whose path looks like save / submit / approve / complete / post / create / new / add / edit / delete / import / map / sync / run / send / pay, record it in the report's deviations. Toast Food waste reporting and void-reason URLs are allowed as `view`, `filter`, `export`, or `close` (a path may contain `void`; viewing VDR is allowed; a Void **click** on Toast Web is not). R365 `waste-logs`, `purchase-items`, item-detail, and AvT Location Summary URLs are allowed as `view`, `filter`, `export`, or `close`. A `create` / `new` URL is allowed only for that one blank R365 new-waste-log form whose action is `view` or `close`, closed without save. `POS-*` is not in `pages.csv`. Do not edit `pages.csv`. Do not hide it.

## You may edit only

- `docs/research/waste-log-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md` (added lines only, in `## Store 122 audit (2026-10-11)`)
- Outside the repo, only `/srv/fhs-build/reports/waste-log-01.md` (report)

## You must not

- Edit any file not listed above, including `shared/config.json`, any other file under `skills/`, or `docs/` other than the note.
- Edit, move, or delete anything under `/srv/fhs-build/reports/waste-log-122-captures/`.
- Touch the served tree `/root/fhs-skills`. Push, merge, or commit to `main`.
- Open a browser, or open Toast, R365 or ADP. Log in to anything or type a password.
- Click or instruct Save, Submit, Approve, Complete, Post, Create, New, Add, Edit, Delete, Import, Map, Sync, Run (any job, including AvT Analysis), Send, Pay, Void (on Toast Web), any persistent toggle or checkbox, any settings page edit. No user or permission changes. Do not open Ad hoc report. Do not enter waste in R365. Do not tap or drive the POS.
- Run `docs/prompts/waste-log-01-capture.md` or start a new capture.
- Write a checker script, a manager guide, a weekly "was waste logged" skill (spec P1), or an AvT product change (spec P2). Recapture F2–F5 or F8–F13. Recapture the 551-item grid. Re-audit food-cost totals. Open store 878 / CAMDEN SQUARE / NCR, ADP, or the manager's old waste sheet. Touch payroll or `browser-02`.
- Install packages or change system settings.

## Tests (run every one, record the real output)

Working directory: the clone. This job's captures: `/srv/fhs-build/reports/waste-log-122-captures`.

1. Headings `## Summary for the owner`, `## How cells were filled`, `## Test entry`, `## Toast reasons`, `## R365 waste log`, `## Cost and accounts`, `## AvT`, `## Who owns what`, and `## Deviations` exist. Data rows under `## Test entry` = **2**. Sources are `POS` and `Toast Food waste reporting`. Every data row has 6 cells; none empty. Every Capture cell names a file that exists in the captures folder, or starts with `(?)`, or is `not shown (<file>)`. The line `same_item_reason_dollar:` is present. Command: a `python3 -c` that prints `headings_ok=<0|1> rows=<n> empty_cells=<n> missing_captures=<n> same_line=<0|1>`. Pass if `headings_ok == 1`, `rows == 2`, `empty_cells == missing_captures == 0`, `same_line == 1`.
2. Test entry match. A `POS-*` screenshot exists (`POS-*.png` or `POS-*.jpg`). If `same_item_reason_dollar` is `(?) no button`, the POS **Button or report** cell contains `(?)` and the TWR Item/Reason/$ cells contain `(?)`. If it is `yes`, POS Item, Reason and $ equal TWR Item, Reason and $ (same text after stripping `$` / commas for the money cell). If it is `no` or `(?) TWR row missing`, record that in the report's deviations; this test fails. Print `pos_shot=<0|1> match=<yes|no|no_button|twr_missing> item_eq=<0|1> reason_eq=<0|1> dollar_eq=<0|1>`. Pass if `pos_shot == 1` and (`match == yes` with all three `*_eq == 1`, or `match == no_button`).
3. Under `## Toast reasons`, rows (a) and (b) exist. (b)'s Answer is `seen: owner`, `seen: franchise`, `seen: can't tell`, or starts with `(?)`. Every Answer that starts with `seen` names a capture file that exists (`ls -l` each unique name). Every Answer that starts with `(?)` names what is missing (non-empty after `(?)`). Print `q_rows=<n> seen_missing_file=<n> empty_unknown=<n> b_ok=<0|1>`. Pass if `q_rows == 2`, `seen_missing_file == empty_unknown == 0`, `b_ok == 1`.
4. Under `## R365 waste log`, rows (c), (d), and (e) exist. Under `## AvT`, rows (f) and (g) exist. Under `## Cost and accounts`, at least **1** data row; every data row has 4 cells; none empty. Every `seen` / Capture cell that is not `(?)` names a file that exists. Print `r365_rows=<n> avt_rows=<n> acc_rows=<n> empty_acc=<n> seen_missing_file=<n>`. Pass if `r365_rows == 3`, `avt_rows == 2`, `acc_rows >= 1`, `empty_acc == seen_missing_file == 0`.
5. Under `## Who owns what`, every Owner cell is `owner`, `franchise`, `R365`, `Toast`, or `unknown`. Every row that is not `unknown` names a capture file that exists (`ls -l` each unique name). Print `own_rows=<n> bad_owner=<n> missing_captures=<n>`. Pass if `own_rows >= 1`, `bad_owner == missing_captures == 0`.
6. This job's `pages.csv`: header `time,URL,action`; unique `action` values in data rows are only `view`, `filter`, `scroll`, `export`, `close`; no URL path matching `save|submit|approve|complete|post|create|new|add|edit|delete|import|map|sync|run|send|pay` (case-insensitive), except Toast Food waste / void-reason URLs and R365 `waste-logs` / `purchase-items` / item-detail / AvT Location Summary URLs whose action is `view`, `filter`, `export`, or `close`, and that one blank R365 new-waste-log form (`create`/`new` URL) whose action is `view` or `close`. Print the unique actions and any matching URLs (allowed exceptions listed separately).
7. After the commit: `git diff --name-only main...HEAD` → only `docs/research/waste-log-122.md` and `skills/fhs-skills/references/tech-stack.md`
8. After the commit: `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md | grep '^-[^-]'` → no output (added lines only). Same diff has no `^+## ` line (no new top-level section). `git status --short` → empty

## When done

1. Commit on `feat/waste-log-01`. End the message with `Co-Authored-By: Cursor Grok 4.6 High (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/waste-log-01.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: waste-log-01 · Branch: feat/waste-log-01 · Commits: <hashes>
Files changed: <list>
Browser opened: no
Captures used: <list or count>
Forbidden actions taken: none | <list>
Tests: <n>/8 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
