# Spec · framework-setup · How fhs skills get built

2026-10-10 · Hub project: none (library process) · Plan: `docs/plans/framework-setup-01.md`

## Problem and today

- **Problem:** skill changes are planned in chat, checked by the same model that wrote them, and
  tracked only on the hub. Nothing written down says how a change is planned, reviewed or proven.
- **Today:** the owner asks, Claude edits the skill in place (live right away through the
  symlinks), then reports.

## Who runs it

- Claude sessions in `/root/fhs-skills`. The owner chooses and approves. They read plain-language
  plans and verdicts, not code.

## Done when

1. Every non-trivial skill change from here on has a plan file and a non-Claude review verdict in `docs/`.
2. No build happens in the served checkout (`/root/fhs-skills`): ~~builds happen in worktrees under `/root/fhs-skills-wt/`.~~
   **Changed 2026-10-10 (owner):** builds are done by Grok agents running as the unprivileged user `fhsbuild`, in clones under
   `/srv/fhs-build/<name>`. Claude writes the plan, the task file (`docs/prompts/`) and the test plan (`docs/tests/`). A fresh Grok session runs the tests.
   **Changed 2026-10-10 (owner, included Cursor models):** ~~Grok builds and tests~~ → Composer 2.5 builds, tests and runs ops; Cursor Grok 4.6 High
   researches; Cursor Grok 4.6 Extra High reviews Claude's plans and Composer's code; Composer 2.5 reviews Grok's research.
3. The first project run this way (R365 inventory/food cost) reaches its Phase 0 audit summary
   with a spec, a research note and a reviewed plan.

## In scope

- P0: door file `CLAUDE.md`; spec, plan and review forms; `scripts/review.sh`; framework reference copy.
- P1: subagent prompt substitutions (main, hub db, worktree path).

## Out of scope (parked)

- Hooks and permission enforcement from `app-framework/hooks` (later, if the lean loop slips).
- Moving the Board or Decision Log out of the hub (the owner chose to keep the hub, 2026-10-10).
- A remote git host, CI, Windows mirror automation (server move plan).

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Review verdicts | `docs/reviews/` | `scripts/review.sh` → cursor-agent | yes, 2026-10-10 (`docs/research/framework-setup-review-tool.md`) |
| Board, decisions | Hub db | ArtifactData | yes (existing) |

## Owner rules that bind it

- 2026-10-10: lean process, hub stays the Board, reviewer = cursor-agent non-Claude, first project R365 inventory.
- Existing: plan and ask before coding (owner memory note); no secrets in git; one yes per live change.
