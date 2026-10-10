# Plan · framework-setup-01 · Adopt app-framework v2 (lean) for building fhs skills

2026-10-10. Written after the first diff review (framework-setup-diff, APPROVE AFTER FIXES)
flagged that this change had no plan. It covers the branch `feat/framework-setup`.

- Hub project: none (library process change). Decisions that bind it, owner, 2026-10-10:
  first skill under the framework = R365 inventory/food cost; the Hub stays the Board and
  Decision Log; reviewer = cursor-agent on a non-Claude model; process = lean.

## Verdict

Build (already built on the branch, so this plan is checked against the diff).

## What changes, in plain words

The repo gets a rulebook for how fhs skills are built (`CLAUDE.md`), forms for specs, plans and
reviews, a script that has a non-Claude model review each plan and change, and a reference copy
of the app framework. No skill, script the skills run, config or live system changes.

## Files the builder may edit

- `CLAUDE.md` (new)
- `README.md` (folder table rows only)
- `docs/templates/{spec,plan,review}.md`, `docs/{specs,research,plans,reviews}/.gitkeep` (new)
- `docs/plans/framework-setup-01.md` (this file), `docs/reviews/framework-setup-diff*.md`
- `scripts/review.sh` (new). `scripts/.gitkeep` is removed because the folder is no longer empty.
- `app-framework/**` (new). It's an exact copy of `/root/trader-mayne/app-framework-v2` and is
  not edited, including its trailing whitespace, so it can be diffed against the source.

## Files the builder must not edit

- `skills/**`, `shared/**`, `artifacts/**`, `memory/**`, `.env*`, `.gitignore`
- Anything in the served checkout `/root/fhs-skills` before the merge

## Live systems touched

None. No Toast, R365, ADP, Dropbox or Windows changes. The hub decision-log entries are written
by the coordinator after the merge, as normal per-session upkeep (`skills/fhs-skills/references/artifacts.md`).

## Done-check (real outcome)

1. `git diff --stat main...feat/framework-setup -- skills shared artifacts memory` is empty.
2. `diff -rq /root/trader-mayne/app-framework-v2 app-framework` reports no differences.
3. `scripts/review.sh --diff feat/framework-setup` ran for real against cursor-agent
   (gpt-5.6-sol-high), wrote `docs/reviews/framework-setup-diff.md` and returned a verdict.
   The script refuses a Claude model (`REVIEW_MODEL=claude-x scripts/review.sh x` exits 2).
4. After the merge, `/root/fhs-skills` is on `main`, clean, and the `/root/.claude/skills/fhs-*`
   links still resolve.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, through `/root/.claude/skills/fhs-*`.
  This branch changes nothing under `skills/`, so the skills sessions load are the same before
  and after the merge. Only the build rules (`CLAUDE.md`) take effect, for new sessions in this repo.
- **Windows mirror:** not affected. Nothing here gets copied to Windows.
- **Live before merge:** sessions see `main` without `CLAUDE.md` or `docs/`.

## Where the builder works

- Worktree `/root/fhs-skills-wt/framework-setup` · branch `feat/framework-setup` · cut from `main` at `c24fb48`

## What stays

The skills, their rules (`skills/fhs-skills/SKILL.md`), `shared/config.json`, the hub and plan
page data shapes, payroll on Windows, and the artifacts as the source of truth for status.
