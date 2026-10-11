# Review · framework-setup-04

2026-10-11 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: plan

## Verdict

APPROVE. The build may go ahead: the plan and task file match the 2026-10-11 token-savings rules, name the served tree correctly, and do not touch live systems.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- Done-check 2 / T11 (`--check-only` on this Claude-written plan → `OK`, then `--writer grok` → 2) already behaves that way on today's `review.sh`. Pre-merge proof of the new grok route is the suite plus a real Grok-drafted plan already in the tree: [`docs/plans/store-audit-122-02.md`](docs/plans/store-audit-122-02.md) (Drafted-by on line 3). Default on that file must be 2; `--writer grok` must be 0. Done-check 3 remains the post-merge real draft.
- `--fix` should also refuse (exit 3, `CLAUDE:`) when the plan has no Drafted-by line, so Grok cannot rewrite a Claude-written plan. Owner rule: the writer's own model fixes minors (Grok for drafts, Claude for Claude-written plans).
- Only the plan-generation prompt should require `Drafted by Cursor Grok 4.6 High from docs/briefs/<name>.md.` in the first 10 lines. The task and test-plan prompts should not. `--fix` must keep that line. The test-plan call should take the brief, the new plan, and the new task file, not the brief alone.
- Keep existing `--check-only` stdout as exact `OK` on paths the suite already asserts (`review-plan-default-message`, `review-diff-grok-message`). Name `composer-2.5` only on the new grok-plan success path so Design 4 does not force a global message change.
- Design 3 does not say `chmod +x`; the task and T2 do. Set the executable bit on `scripts/draft.sh`. Honor `FHS_REPO` the same way [`scripts/review.sh`](scripts/review.sh) does (`REPO="${FHS_REPO:-/root/fhs-skills}"`), or the temp-repo cases will not test the new script.
