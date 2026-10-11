# Brief · store-audit-122-02 · 122 store audit, captured on the owner's PC

2026-10-11. Written by Claude for the Drafter (Cursor Grok 4.6 High). Replaces `docs/plans/store-audit-122-01.md` (server-browser
version, never approved; keep it as history). Reuse its read-only rules, forbidden-action list, rows F2–F13 and done-check shape.
Don't add scope.

- Spec: `docs/specs/store-audit-122.md` (its "server browser" wording is superseded by the decisions below; Claude updates the spec after the review)
- Hub project: `projects/r365-inventory` (Phase 0) · Binding decisions (hub log): 2026-10-10T17:00 desktop first, browser-02 parked;
  2026-10-10T17:01 Claude Code + Claude in Chrome is the PC browser agent; 2026-10-10T17:30 PC jobs run in Claude Code, no Cursor agent
  on the PC, restricted key; 2026-10-10T16:02 read-only exports allowed; 2026-10-10T16:03 audit first, then ask q1–q5
- Research to rely on: `docs/research/windows-agent.md`, `docs/runbooks/windows-agent.md` (`send-report.ps1`, `inbox/`)

## Problem and decision (3–5 lines)

Same audit as -01: what R365 and Toast already do for store 122, function by function, read-only. What changes is who looks and where.
**Capture** runs on the owner's PC: a Claude Code session with Claude in Chrome, where the owner is already signed in, follows a capture
task file and saves screenshots, page text and allowed exports under `C:\fhs\reports\store-audit-122\`, zips them, and sends the zip with
`send-report.ps1` to the server `inbox/`. **Ops** (root) copies the zip into `/srv/fhs-build/reports/store-audit-122-captures/` and
unzips it there for `fhsbuild`. **The Researcher** (Grok, `fhsbuild`, `ROLE=research`) writes the note from those files only; it never
opens a browser. **The Tester** (fresh Composer) checks the note against the captures. **Diff review**: `composer-2.5` (`--writer grok`).

## Files the builder may edit / must not edit

- may (Researcher, in its clone): `docs/research/store-audit-122.md` (new), `skills/fhs-skills/references/tech-stack.md` (one new section, added lines only)
- must not: the served tree `/root/fhs-skills`, `shared/config.json`, any other file under `skills/`, `docs/` other than the note

## Files Claude/Drafter produce (docs, not the builder)

- `docs/plans/store-audit-122-02.md`, `docs/prompts/store-audit-122-02.md` (Researcher), `docs/tests/store-audit-122-02.md`
- `docs/prompts/store-audit-122-02-capture.md`: the PC capture task for Claude Code + Claude in Chrome (form `docs/templates/prompt.md`,
  "test"-style read-only). Lists, per F2–F13 plus licensed modules, integration health and setting ownership, the R365/Toast pages to
  open, what to capture, file names `<area>-<nn>.png` / `.txt`, and the page log `pages.csv` (time, URL, action = view/filter/export).

## Live systems touched

R365 (`https://fhs4021089.restaurant365.com/`) and Toast Web (restaurant 366968): **read-only**, on the owner's PC, owner signed in.
Allowed and forbidden actions exactly as -01 "Live systems touched". Claude in Chrome never types credentials; a login or MFA prompt
means stop and ask the owner.

## Done-check (real outcome)

1. The note has rows F2–F13 (12), plus "Licensed modules", "Toast → R365 integration" (last sales and labor import dates) and "Who owns
   what". Each row: status (in place / partial / missing / can't tell), evidence (menu path + capture file), owner.
2. Every "in place"/"partial" row names a capture file that exists in the captures folder.
3. The tester picks 5 claims and confirms each against its capture (screenshot or page text), and checks `pages.csv` has no forbidden action.
4. `tech-stack.md` diff: added lines only, one section.
5. Post-merge (not a gate): the owner confirms nothing changed in R365 or Toast; a fresh PC Claude session re-captures the 5 tester-picked
   pages and they still match.

## Where it runs and which tree is live

Capture: owner's Windows PC (Claude Code + Claude in Chrome), from the PC clone `C:\fhs\fhs-skills` (read-only use of the task file).
Note, tests, review: server. Served tree `/root/fhs-skills` on `main`: on merge, the `tech-stack.md` section becomes visible to server
sessions. Windows mirror unchanged (refresh is a separate OK). Gate before capture: windows-agent PC steps done (clone, restricted key)
and the owner signed in to R365 and Toast in Chrome (runbook rows 9–10).

## Tests the test plan must include

- Note structure: 12 F-rows + 3 sections; every row has status, evidence, owner.
- Every cited capture file exists; every "in place"/"partial" has one.
- 5 tester-picked claims match their captures.
- `pages.csv`: no action outside view/filter/export; no URL with save/submit/post/approve paths (?)(list from -01).
- `git diff --name-only main...HEAD` = the note + `tech-stack.md`; `tech-stack.md` diff has no `-` lines.
- Owner case (post-merge): nothing changed.

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
