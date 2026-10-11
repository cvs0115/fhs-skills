# Brief · framework-setup-04 · Grok drafts, Composer reviews, writers fix minors

2026-10-11. Written by Claude. This one is planned by Claude (the drafter can't review-route its own enabling change);
from framework-setup-05 on, the Drafter turns briefs into plans.

- Spec: `docs/specs/framework-setup.md` · Hub project: `projects/fhs-framework` · Binding decisions: hub log 2026-10-11 "Token savings" (three entries), 2026-10-10 included Cursor models
- Rules: `CLAUDE.md` "Roles", "Token budget"

## Problem and decision

Claude's session tokens go mostly to long sessions, writing full plans and handling every review round. The owner chose (2026-10-11):
Cursor Grok 4.6 High drafts the plan, task file and test plan from Claude's brief; Composer 2.5 reviews Grok drafts; minor-only fix
rounds go back to the writer's model. Today `review.sh` only reviews plans written by Claude (always to Grok Extra High), and nothing
runs the Drafter. Add `--writer grok` for plan reviews, a guard keyed on a `Drafted by Cursor Grok` line so a Grok draft can't be reviewed as Claude's (or the reverse), and `scripts/draft.sh`
to draft and to fix minors.

## Files the builder may edit / must not edit

- may: `scripts/review.sh`, `scripts/lib/guards.sh`, `scripts/draft.sh` (new), `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/*` (new fixtures only)
- must not: the served tree `/root/fhs-skills`, `skills/`, `shared/config.json`, `docs/` (Claude owns docs), `scripts/build.sh`

## Live systems touched

None.

## Done-check (real outcome)

After merge, the next real plan (framework-setup-05 or the reworked store-audit-122) is drafted by `scripts/draft.sh` from its brief, and
its review header names `composer-2.5`.

## Where it runs and which tree is live

Server (dev-lxc-1) only. `scripts/` on `main` in `/root/fhs-skills` is the trusted copy Ops runs; merging is the release. Skills are untouched.
