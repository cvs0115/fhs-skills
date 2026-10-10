# Plan · framework-setup-03 · Included Cursor models only: Composer builds, Cursor Grok reviews (drop GPT, Sonnet, grok-4.7)

2026-10-10 (r2, rewritten after the owner's model decision). Plan only, not approved. Don't build from it until
`docs/reviews/framework-setup-03.md` holds an APPROVE. The reviewer checks this plan, its task file
`docs/prompts/framework-setup-03.md`, and its test plan `docs/tests/framework-setup-03.md` together.

- Hub project: none (library process). Spec: `docs/specs/framework-setup.md`.
- Decision that binds it (owner, 2026-10-10): stay inside the included Cursor models (Cursor Grok and Composer). "Where high intelligence
  is needed use the Grok models; where we need someone to test or build use Composer." Rule kept: the reviewer is never the writer's family.
- Research: `agent models` lists `cursor-grok-4.6-xhigh`, `cursor-grok-4.6-high` and `composer-2.5`.

## Pre-build gate: included models confirmed

The owner confirmed on 2026-10-10, before this revision went to review, that `composer-2.5`, `cursor-grok-4.6-high` and
`cursor-grok-4.6-xhigh` are all included models. The evidence lives outside this plan, in the hub `log` (kind `decision`, 2026-10-10,
"included models confirmed"). This plan only points to it.

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
Grok's research goes to Composer. The current workflow instructions no longer use GPT or Sonnet. Historical plans, reviews and research stay as written. `build.sh prepare` prints the right model for the hand-off:
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
- `scripts/build.sh`: `prepare` takes `--role build|research` (default `build`).
  - The hand-off uses `--model composer-2.5` for `build` and `--model cursor-grok-4.6-high` for `research`, always with `--force`
    (`sudo -u fhsbuild -H $FHS_BUILD_ROOT/.local/bin/agent --model <m> --force --workspace $FHS_BUILD_ROOT/<name>`), and prints `Start agent:` instead of `Start Grok:` (r5 major 3).
  - `collect` also takes `--role build|research` (default `build`), and its `Next:` line becomes
    `Next: scripts/review.sh --diff feat/<name> --writer composer` for build or `... --writer grok` for research (r5 major 2).
  - **`--check-only` output changes (r2 major 4):** after its checks pass, it prints `OK: ready to prepare <name> from <base>` and then the same
    two hand-off lines (`Start agent: ...`, `Tell it: ...`), and exits 0. A real run prints the clone output, then the same two lines.
  - The existing exact-output test for `--check-only` changes to expect the three lines.
  - Nothing else changes.
- `scripts/tests/test_framework.sh`: replace the GPT model cases with:
  - plan default → ok; plan with `composer-2.5` → 2; plan with `gpt-5.6-sol-high` → 2
  - diff default (writer composer) → ok with `cursor-grok-4.6-xhigh`; diff writer composer + `composer-2.5` → 2
  - diff writer grok → ok with `composer-2.5`; diff writer grok + `cursor-grok-4.6-xhigh` → 2
  - `--writer other` → 2
  - `prepare --check-only` hand-off for `--role build` names `composer-2.5`, and for `--role research` names `cursor-grok-4.6-high`; both contain `--force`
  - `collect` with `--role research` prints `--writer grok` in its `Next:` line, and the default prints `--writer composer`
  - `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → 0

## Docs transition (done by Claude before this build, r3 major 1)

So the rules and the hand-offs match during this build too, Claude updated the workflow docs **before** the build, in commit
`17ddc4b` on `main`:
- `CLAUDE.md`: Roles and loop step 5
- `docs/RUNBOOK.md`: the agent table
- `docs/templates/prompt.md` and `test-plan.md`
- `docs/prompts/ops-cycle.md`: Composer Ops and Builder/Tester wording; the executable commands in A.3, C and D carry `--role $ROLE` and
  `--writer $WRITER`; the research path (`--role research`, `--writer grok`)
- `docs/specs/framework-setup.md`: the model change recorded beside the old text
- the "Historical" notes on `ops-00` and `ops-01`

Those docs state that `review.sh` still runs GPT-5.6 until this plan merges. So this build is run by Composer (Builder, Tester, Ops)
under rules that already say so. After the merge, Claude removes only that "until framework-setup-03 merges" sentence (done-check 5).

## Files the builder must not edit

Everything not listed under "Files the builder may edit", in particular `skills/**`, `shared/**`, `docs/**`, `CLAUDE.md`, `scripts/lib/verdict.sh`.

## Live systems touched

None.

## Done-check (real outcome)

1. The builder's and the tester's suite runs pass.
2. **Real plan review with the new reviewer:** first Ops renames the existing `docs/reviews/framework-setup-03.md` to the next free
   `framework-setup-03-rN.md` and commits that on main (r4 major 2). Then it runs the branch's `review.sh docs/plans/framework-setup-03.md` from a root worktree of the
   branch, and renames and commits the new file as the next `-rN` too, so no verdict is overwritten. The review header names `cursor-grok-4.6-xhigh`, and the verdict must be **APPROVE** (r2 major 1). APPROVE AFTER FIXES or REJECT goes
   back to Claude to fix the plan, under the normal loop, before the final review.
3. **Real diff review with the new reviewer:** the final review runs the branch's `review.sh --diff feat/framework-setup-03` (writer `composer`).
   The header names `cursor-grok-4.6-xhigh`, and it must be APPROVE to merge.
4. After the merge: `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → all 0.
5. After the merge, Claude removes the "until framework-setup-03 merges" sentences. Then
   `grep -n -i "grok-4.7\|gpt-5.6\|sonnet\|Start Grok\|tester agents (Grok)" CLAUDE.md docs/RUNBOOK.md docs/templates/*.md docs/prompts/ops-cycle.md` → no output,
   and the two historical ops files carry the "Historical" note.

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
