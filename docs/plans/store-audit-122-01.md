# Plan · store-audit-122-01 · Read-only audit of R365 and Toast for store 122 (research)

2026-10-10. Plan only, not approved. Don't start from it until `docs/reviews/store-audit-122-01.md` holds an APPROVE.
The reviewer checks this plan, its task file `docs/prompts/store-audit-122-01.md`, and its test plan `docs/tests/store-audit-122-01.md` together.

- Hub project: `projects/r365-inventory` (Phase 0) · Spec: `docs/specs/store-audit-122.md` · Parent: `docs/specs/store-migration.md` (F1)
- Decisions that bind it (hub log, 2026-10-10): R365 inventory/food cost first; build at 122 first; F1 audits every function F2–F13, and
  functions in place get verify-only plans; included Cursor models (researcher `cursor-grok-4.6-high`, research reviewer `composer-2.5`,
  tester and ops `composer-2.5`).
- **Depends on:** `browser-02` merged (the server browser with Playwright MCP and noVNC), and the owner signed in to R365 and Toast in it.

## Verdict

Build (a research note plus one `tech-stack.md` section, no code).

## What changes, in plain words

A research agent looks through R365 and Toast for store 122 in the server browser, after you sign in. For each back-office function
it records whether it's already set up, half set up, or missing, with a screenshot and who owns it. It changes nothing. The result decides
which functions we build, which we only verify, and which belong to the franchise.

## Where it runs

Server (dev-lxc-1), through the server browser (Playwright MCP). No Windows desktop part.

## Files the researcher may edit (in its clone)

- `docs/research/store-audit-122.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: one new section `## Store 122 audit (<date>)`, added lines only, confirmed facts
  only, each one line with a pointer to the audit note's section.
- Outside the repo, only: `/srv/fhs-build/reports/store-audit-122-01.md` (report), `/srv/fhs-build/reports/store-audit-122-shots/*.png`
  (screenshots), `/srv/fhs-build/reports/store-audit-122-01-test.md` (tester's results).

## Files the researcher must not edit

- Everything else, inside or outside the clone.

## Live systems touched

- **R365 and Toast: read-only.** Allowed: navigation, opening list and detail pages, opening reports on screen, changing on-screen filters
  or date ranges, taking screenshots.
- **Forbidden:** Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run (any job), Send, Email, Pay,
  Print-to-vendor, or any toggle and checkbox that persists. No settings pages edited. No user or permission changes.
- **Exports** (download a CSV or PDF of a report): allowed without asking (owner, 2026-10-10). Read-only report exports only, saved to `/srv/fhs-build/reports/store-audit-122-exports/`. An export never changes data.
- If a page asks to sign in again or for MFA, stop that item. The owner signs in, and the agent never types credentials.

## Owner steps

1. Sign in to R365 (`https://fhs4021089.restaurant365.com/`) and Toast Web (`https://www.toasttab.com/restaurants/admin/`) in the
   server browser through noVNC, and pick store 122 (Cary 1, Toast restaurant 366968) where a store picker exists.
2. After the run, answer hub q1–q5 for any item the note marks "can't tell (owner)".

## Done-check (real outcome)

1. `docs/research/store-audit-122.md` has every row F2–F13 (12 rows), plus "Licensed modules", "Toast → R365 integration" and
   "Who owns what" sections. Each row has a status, evidence (a menu path plus a screenshot file name) and an owner.
2. Every "in place" and "partial" row names a screenshot that exists under `/srv/fhs-build/reports/store-audit-122-shots/`.
3. A fresh Composer tester re-checks 5 claims in the server browser, read-only, and gets the same result.
4. The `tech-stack.md` diff is added lines only, in one new section.
5. No write action: the researcher's report lists every page visited, none is a forbidden action, and the owner confirms nothing changed.

## Test plan

`docs/tests/store-audit-122-01.md`, run by a fresh `composer-2.5` session. Every pre-merge case must PASS. Owner cases are BLOCKED until the owner answers.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. On merge, the new `tech-stack.md` section is visible to server sessions (reference text only).
- **Windows mirror:** unchanged. The section reaches Windows only through a mirror refresh, a separate owner OK.
- **Builder tree:** `/srv/fhs-build/store-audit-122-01`.

## Where the researcher works

`/srv/fhs-build/store-audit-122-01` via `scripts/build.sh prepare docs/plans/store-audit-122-01.md store-audit-122-01 --role research`,
branch `feat/store-audit-122-01`, model `cursor-grok-4.6-high`, user `fhsbuild`, started after the owner has signed in.

## What stays

Everything in R365, Toast and ADP. Payroll is unchanged. The build order in `docs/specs/store-migration.md` stays as it is until the
planner updates it from this audit.
