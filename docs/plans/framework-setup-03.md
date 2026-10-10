# Plan · framework-setup-03 · Included Cursor models only: Composer builds, Cursor Grok reviews (drop GPT, Sonnet, grok-4.7)

2026-10-10 (r2, rewritten after the owner's model decision). Plan only, not approved. Don't build from it until
`docs/reviews/framework-setup-03.md` holds an APPROVE. The reviewer checks this plan, its task file
`docs/prompts/framework-setup-03.md`, and its test plan `docs/tests/framework-setup-03.md` together.

- Hub project: none (library process). Spec: `docs/specs/framework-setup.md`.
- Decision that binds it (owner, 2026-10-10): stay inside the included Cursor models (Cursor Grok and Composer). "Where high intelligence
  is needed use the Grok models; where we need someone to test or build use Composer." Rule kept: the reviewer is never the writer's family.
- Research: `agent models` lists `cursor-grok-4.6-xhigh`, `cursor-grok-4.6-high` and `composer-2.5`. Whether these are all inside the
  included allowance is `(?)`; the owner checks the Cursor dashboard.

## Verdict

Build.

## Model map

| Work | Writer | Reviewer |
|---|---|---|
| Plans, task files, test plans | Claude (planner) | `cursor-grok-4.6-xhigh` |
| Code builds | `composer-2.5` (Builder) | `cursor-grok-4.6-xhigh` |
| Research notes | `cursor-grok-4.6-high` (Researcher) | `composer-2.5` |
| Test runs | `composer-2.5` (Tester, fresh session) | n/a: the results are judged by the diff reviewer |
| Ops steps | `composer-2.5` (Ops) | n/a |

## What changes, in plain words

`scripts/review.sh` chooses the reviewer from who wrote the work: Claude's plans and Composer's code go to Cursor Grok Extra High, and
Grok's research goes to Composer. GPT and Sonnet are no longer used anywhere. `build.sh prepare` prints the right model for the hand-off:
Composer for builds, Cursor Grok for research.

## Where it runs

Server (dev-lxc-1) only.

## Files the builder may edit

- `scripts/lib/guards.sh`: replace `check_review_model <model>` with `check_reviewer <mode> <writer> <model>`.
  - mode `plan` → writer must be `claude`, and the model must be `cursor-grok-4.6-xhigh`
  - mode `diff`, writer `composer` → model `cursor-grok-4.6-xhigh`
  - mode `diff`, writer `grok` → model `composer-2.5`
  - anything else → exit 2, with a message naming the allowed model and "owner decision 2026-10-10: included Cursor models; reviewer is never the writer's family"
- `scripts/review.sh`:
  - plan mode: writer `claude`, model `${REVIEW_MODEL:-cursor-grok-4.6-xhigh}`
  - diff mode: new option `--writer composer|grok` (default `composer`), model `${REVIEW_MODEL:-<the allowed reviewer for that writer>}`
  - `check_reviewer` validates before anything runs
  - the prompt names the writer and the reviewer correctly: "The writer is Claude (Anthropic) / Composer (Cursor) / Grok (xAI via Cursor). You are <model>, a different model family."
  - `--check-only` validates per mode and writer. Everything else stays as it is.
- `scripts/build.sh`: `prepare` takes `--role build|research` (default `build`). The printed hand-off uses `--model composer-2.5` for
  `build` and `--model cursor-grok-4.6-high` for `research`, and prints `Start agent:` instead of `Start Grok:`. Nothing else changes.
- `scripts/tests/test_framework.sh`: replace the GPT model cases with:
  - plan default → ok; plan with `composer-2.5` → 2; plan with `gpt-5.6-sol-high` → 2
  - diff default (writer composer) → ok with `cursor-grok-4.6-xhigh`; diff writer composer + `composer-2.5` → 2
  - diff writer grok → ok with `composer-2.5`; diff writer grok + `cursor-grok-4.6-xhigh` → 2
  - `--writer other` → 2
  - `prepare --check-only` hand-off for `--role build` names `composer-2.5`, and for `--role research` names `cursor-grok-4.6-high`
  - `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → 0

## Files Claude edits directly (docs, committed to main before the build, not by the builder)

`CLAUDE.md` (Roles table + loop step 4), `docs/RUNBOOK.md` (agent table and reviewer paragraph), `docs/templates/prompt.md` and
`test-plan.md` (agent headers and hand-off lines), `docs/prompts/ops-*.md` (start lines), memory notes. These carry no code.

## Files the builder must not edit

Everything not listed under "Files the builder may edit", in particular `skills/**`, `shared/**`, `docs/**`, `CLAUDE.md`, `scripts/lib/verdict.sh`.

## Live systems touched

None.

## Done-check (real outcome)

1. The builder's and the tester's suite runs pass.
2. **Real plan review with the new reviewer:** Ops runs the branch's `review.sh docs/plans/framework-setup-03.md` from a root worktree of the
   branch. The review header names `cursor-grok-4.6-xhigh`, and `verdict.sh` parses it (any of the three verdicts proves the path works).
3. **Real diff review with the new reviewer:** the final review runs the branch's `review.sh --diff feat/framework-setup-03` (writer `composer`).
   The header names `cursor-grok-4.6-xhigh`, and it must be APPROVE to merge.
4. After the merge: `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → all 0.

## Sequence

1. The Builder (`composer-2.5`, `fhsbuild`) builds. 2. A fresh Tester (`composer-2.5`) runs the shell cases. 3. Ops (`composer-2.5`) collects.
4. **Code review gate:** main's current `review.sh` (still GPT, its last use) reviews the diff and must APPROVE before branch code runs as root.
5. Ops runs done-check 2 as root with the branch's scripts. 6. The Tester records it. 7. **Final review** with the branch's `review.sh`
(Cursor Grok Extra High), which must APPROVE. 8. Merge, then done-check 4. Review files are committed to main as `-rN` / `-diff-rN`.
(This plan's own plan review, and the step-4 gate, are the last GPT runs. Everything after the merge uses included models.)

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. No skill changes; the new models apply from the merge on.
- **Builder tree:** `/srv/fhs-build/framework-setup-03`. **Windows mirror:** not affected.

## Where the builder works

`/srv/fhs-build/framework-setup-03` via `scripts/build.sh prepare docs/plans/framework-setup-03.md framework-setup-03`, branch `feat/framework-setup-03`.

## What stays

The verdict parser, the review flow and file names, `--check-only`, the worktree safety, the isolation of `fhsbuild`.
