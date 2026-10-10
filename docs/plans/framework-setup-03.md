# Plan · framework-setup-03 · Reviewers: Grok 4.7 Extra High for plans, Claude Sonnet 5 for code (drop GPT-5.6)

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/framework-setup-03.md` holds an APPROVE.
The reviewer checks this plan, its task file `docs/prompts/framework-setup-03.md`, and its test plan `docs/tests/framework-setup-03.md` together.

- Hub project: none (library process). Spec: `docs/specs/framework-setup.md`.
- Decisions that bind it (hub log 2026-10-10): "Reviewers change: Grok 4.7 Extra High reviews Claude's plans; Claude Sonnet 5 (in Cursor)
  reviews Grok's code. GPT-5.6 is dropped." Rule kept: the reviewer is never the writer's model family.
- Research: `agent models` lists `grok-4.7-xhigh` ("Grok 4.7 Extra High") and `claude-sonnet-5-thinking-high` ("Claude Sonnet 5 1M Thinking").

## Verdict

Build.

## What changes, in plain words

`scripts/review.sh` picks the reviewer by what it's reviewing. Plans, written by Claude, are reviewed by Grok 4.7 Extra High. Code
diffs, written by Grok, are reviewed by Claude Sonnet 5. GPT is no longer used. The reviewer prompt names the right writer for each
case (the diff prompt wrongly said "the writer is Claude").

## Where it runs

Server (dev-lxc-1) only. No Windows desktop part.

## Files the builder may edit

- `scripts/lib/guards.sh`: replace `check_review_model <model>` with `check_review_model <mode> <model>`. Mode `plan` accepts only
  `grok-4.7-xhigh`. Mode `diff` accepts only `claude-sonnet-5-thinking-high`. Anything else exits 2 with a message naming the
  allowed model and "owner decision 2026-10-10 (reviewer is never the writer's family)".
- `scripts/review.sh`: plan mode uses `${REVIEW_PLAN_MODEL:-grok-4.7-xhigh}`. Diff mode uses `${REVIEW_DIFF_MODEL:-claude-sonnet-5-thinking-high}`.
  `REVIEW_MODEL` is no longer read; if it's set, print a warning that it's ignored. The plan prompt says "The writer is Claude
  (Anthropic). You are <model> (xAI Grok)". The diff prompt says "The writer is Grok (xAI). You are <model> (Anthropic Claude)".
  `--check-only` validates per mode. Everything else stays as it is.
- `scripts/tests/test_framework.sh`: replace the GPT model cases with: plan default → ok; plan `claude-sonnet-5-thinking-high` → 2;
  plan `gpt-5.6-sol-high` → 2; diff default → ok; diff `grok-4.7-xhigh` → 2; diff `gpt-5.6-sol-high` → 2; `REVIEW_MODEL=x` prints the
  ignored warning; and a check that `review.sh` contains no `gpt-5.6` string.
- `CLAUDE.md`: the Reviewer row in Roles, and loop step 4 wording: "Grok 4.7 Extra High reviews plans; Claude Sonnet 5 reviews diffs".
- `docs/RUNBOOK.md`: the Reviewer row of the agent table, and the "Why GPT reviews" paragraph rewritten for the new pairing.
- `docs/templates/review.md`: the first line's model hint, if it names GPT.

## Files the builder must not edit

- `skills/**`, `shared/**`, `memory/**`, `.env*`, `app-framework/**`, `docs/plans/**`, `docs/reviews/**`, `docs/prompts/**`, `docs/tests/**`,
  `scripts/build.sh`, `scripts/lib/verdict.sh`

## Live systems touched

None. cursor-agent runs under the existing sign-ins.

## Done-check (real outcome)

1. The builder's and the tester's suite runs pass (the new model cases included).
2. **Real plan review with the new reviewer:** Ops runs the branch's `review.sh docs/plans/framework-setup-03.md` from a worktree of the branch.
   It writes a review whose header names `grok-4.7-xhigh` and whose verdict line is parsed by `verdict.sh` (APPROVE, AAF or REJECT; any
   one proves the path works).
3. **Real diff review with the new reviewer:** the final review (Sequence step 7) runs the branch's `review.sh --diff feat/framework-setup-03`.
   Its header names `claude-sonnet-5-thinking-high`, and it must be APPROVE to merge.
4. After the merge: `grep -c 'gpt-5.6' scripts/review.sh scripts/lib/guards.sh` → 0 0.

## Sequence

1. Builder (Grok, `fhsbuild`) builds. 2. A fresh Tester runs `docs/tests/framework-setup-03.md` shell cases. 3. Ops collects (`build.sh collect`).
4. **Code review gate:** main's `review.sh` (still GPT) reviews the diff and must APPROVE before any branch code runs as root.
5. Ops runs done-check 2 as root with the branch's scripts. 6. The Tester records it.
7. **Final review** with the branch's `review.sh` (Sonnet), which must APPROVE. 8. Merge, then done-check 4. Every review file is committed to main as
   `-rN` / `-diff-rN`.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. No skill changes; the new reviewers apply from the merge on.
- **Builder tree:** `/srv/fhs-build/framework-setup-03`. **Windows mirror:** not affected.

## Where the builder works

`/srv/fhs-build/framework-setup-03` via `scripts/build.sh prepare docs/plans/framework-setup-03.md framework-setup-03`, branch `feat/framework-setup-03`.

## What stays

The verdict parser, build.sh, the review flow and file names, `--check-only`, the worktree safety, the rule that the reviewer is never the writer's family.
