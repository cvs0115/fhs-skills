# Spec · store-audit-122 · What R365 and Toast already do for store 122 (function F1)

2026-10-10 · Hub project: `projects/r365-inventory` (Phase 0) · Parent spec: `docs/specs/store-migration.md` (function F1)

## Problem and today

- **Problem:** the build order (F2–F13) assumes much of 122's back office is missing, but some of it may already be set up in R365 or
  Toast, by the owner or by the franchise. Rebuilding what exists wastes time and can break franchise-owned settings.
- **Today:** nobody has looked. The R365 inventory Phase 0 audit has been waiting on "owner signs in to R365 in the browser pane".
  Only labor and tips (payroll) are known to work.

## Who runs it

- **The owner** signs in to R365 and Toast once in the server browser (noVNC), and answers what the screens can't show.
- **The Researcher** (`cursor-grok-4.6-high`) reads screens through the server Playwright MCP, read-only, and writes the audit note.
- **The Tester** (`composer-2.5`, a fresh session) re-checks a sample. **The Reviewer** of the research is `composer-2.5`.

## Done when

1. `docs/research/store-audit-122.md` has one row per function F2–F13 for store 122. Each row has a status (in place / partial /
   missing / can't tell), evidence (an R365 or Toast menu path plus a screenshot file), and an owner (owner / franchise / R365 support).
2. It also covers: licensed and visible R365 modules, Toast → R365 integration health (last sales and labor import date), and who owns
   each setting.
3. Every "in place" or "partial" claim has a screenshot. 5 claims, picked by the tester, re-check the same.
4. `tech-stack.md` gains one section of confirmed facts, added lines only.
5. Nothing in R365 or Toast was changed.

## In scope

- P0: F2–F13 status for 122; licensed modules; integration health; setting ownership.
- P1: answers to hub q1–q5 where the screens show them (distributor, current counting, item scope, corporate recipes, food cost target).

## Out of scope (parked)

- Any change in R365 or Toast (each fix becomes its own plan).
- Store 878 / CAMDEN SQUARE (later, in the migration).
- ADP (not part of F2–F13).

## Systems and data

| Data | Source of truth | How the researcher gets it | Verified? |
|---|---|---|---|
| R365 setup for CARY 1 | R365 `https://fhs4021089.restaurant365.com/` | server browser via MCP, owner signed in | no → this audit |
| Toast setup for 122 (restaurant ID 366968) | Toast Web `https://www.toasttab.com/restaurants/admin/` | server browser via MCP, owner signed in | no → this audit |
| Server browser | `browser-02` (planned) | Playwright MCP on localhost | no → depends on browser-02 |

## Owner rules that bind it

- Never type a username or password. The owner signs in (`skills/fhs-skills/SKILL.md`).
- Look first, change second. This audit only looks.
- Never click anything that saves, submits, approves, maps, pays or sends.
- Franchise-owned settings: record who owns them. Don't touch them.
- 2026-10-10: build each function at 122 first. A function found in place gets a verify-only plan, not a rebuild.

## Open questions

- Exports: **allowed** (owner, 2026-10-10). The auditor may download read-only report exports (CSV/PDF) into `/srv/fhs-build/reports/store-audit-122-exports/` without asking each time.
- Hub q1–q5 (distributor and invoice method, current counting, item scope, corporate recipes and items, target food cost %), where the screens can't answer.
