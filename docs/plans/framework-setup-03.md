# Plan · framework-setup-03 · Included Cursor models only: Composer builds, Cursor Grok reviews (drop GPT, Sonnet, grok-4.7)

2026-10-10 (r2, rewritten after the owner's model decision). Plan only, not approved. Don't build from it until
`docs/reviews/framework-setup-03.md` holds an APPROVE. The reviewer checks this plan, its task file
`docs/prompts/framework-setup-03.md`, and its test plan `docs/tests/framework-setup-03.md` together.

- Hub project: none (library process). Spec: `docs/specs/framework-setup.md`.
- Decision that binds it (owner, 2026-10-10): stay inside the included Cursor models (Cursor Grok and Composer). "Where high intelligence
  is needed use the Grok models; where we need someone to test or build use Composer." Rule kept: the reviewer is never the writer's family.
- Research: `agent models` lists `cursor-grok-4.6-xhigh`, `cursor-grok-4.6-high` and `composer-2.5`.

## Pre-build gate: included models confirmed (r2 major 3)

Before the build starts, the owner confirms in the Cursor dashboard that `composer-2.5`, `cursor-grok-4.6-high` and
`cursor-grok-4.6-xhigh` are included models (the "Cursor Models · Includes Cursor Grok and Composer" allowance). Claude records the answer
verbatim, with the date, in the hub `log` (kind `decision`) and here, under "Gate record". If any of them isn't included, this plan stops and
gets revised.

**Gate record:** _pending owner confirmation_

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
- `scripts/build.sh`: `prepare` takes `--role build|research` (default `build`).
  - The hand-off uses `--model composer-2.5` for `build` and `--model cursor-grok-4.6-high` for `research`, and prints `Start agent:` instead of `Start Grok:`.
  - **`--check-only` output changes (r2 major 4):** after its checks pass, it prints `OK: ready to prepare <name> from <base>` and then the same
    two hand-off lines (`Start agent: ...`, `Tell it: ...`), and exits 0. A real run prints the clone output, then the same two lines.
  - The existing exact-output test for `--check-only` changes to expect the three lines.
  - Nothing else changes.
- `scripts/tests/test_framework.sh`: replace the GPT model cases with:
  - plan default → ok; plan with `composer-2.5` → 2; plan with `gpt-5.6-sol-high` → 2
  - diff default (writer composer) → ok with `cursor-grok-4.6-xhigh`; diff writer composer + `composer-2.5` → 2
  - diff writer grok → ok with `composer-2.5`; diff writer grok + `cursor-grok-4.6-xhigh` → 2
  - `--writer other` → 2
  - `prepare --check-only` hand-off for `--role build` names `composer-2.5`, and for `--role research` names `cursor-grok-4.6-high`
  - `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → 0

## Files Claude edits directly (docs, committed to main before the build, not by the builder)

Right after the merge, in one docs commit, Claude replaces every old-model instruction (r2 major 2). The full list, from
`grep -n -i "grok-4.7|gpt|sonnet|Start Grok"` on 2026-10-10:
- `CLAUDE.md`:
  - Roles rows Ops / Reviewer / Builder and Tester / Tester (lines 94–98) → Ops `composer-2.5`, Reviewer per the model map, Builder `composer-2.5`, Tester `composer-2.5` (fresh session), Researcher `cursor-grok-4.6-high`
  - line 104 "a Grok 4.7 High agent" → "a Composer 2.5 agent (Cursor Grok 4.6 High for research)"
- `docs/RUNBOOK.md`: agent table lines 11–14, and the "Why GPT reviews" paragraph (line 16), rewritten for the model map.
- `docs/templates/prompt.md`:
  - lines 3, 5 and 6: agent name, reviewer name, hand-off model
  - line 47: the commit trailer becomes `Co-Authored-By: <model> (cursor agent)`, with the model named in each task file
- `docs/templates/test-plan.md`: lines 3 and 49 (Tester = `composer-2.5`).
- `docs/prompts/ops-cycle.md`:
  - lines 3 and 5: Ops = `composer-2.5`
  - line 13 and the line-68 heading: "the reviews" instead of "GPT-5.6"
  - line 51: Builder model from `build.sh`'s hand-off
  - lines 88 and 119: the trailers
- `docs/prompts/ops-00-finish-planning.md` and `ops-01-bootstrap.md`: history (both rows are done). Leave the text as written, and add a
  one-line note at the top: "Historical: run before framework-setup-03. Models now per CLAUDE.md Roles."
- Memory notes (`agent-handoff-workflow.md`): the model roster.

Done-check 5 proves the list was applied.

## Files the builder must not edit

Everything not listed under "Files the builder may edit", in particular `skills/**`, `shared/**`, `docs/**`, `CLAUDE.md`, `scripts/lib/verdict.sh`.

## Live systems touched

None.

## Done-check (real outcome)

1. The builder's and the tester's suite runs pass.
2. **Real plan review with the new reviewer:** Ops runs the branch's `review.sh docs/plans/framework-setup-03.md` from a root worktree of the
   branch. The review header names `cursor-grok-4.6-xhigh`, and the verdict must be **APPROVE** (r2 major 1). APPROVE AFTER FIXES or REJECT goes
   back to Claude to fix the plan, under the normal loop, before the final review.
3. **Real diff review with the new reviewer:** the final review runs the branch's `review.sh --diff feat/framework-setup-03` (writer `composer`).
   The header names `cursor-grok-4.6-xhigh`, and it must be APPROVE to merge.
4. After the merge: `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` → all 0.
5. After Claude's docs commit: `grep -n -i "grok-4.7\|gpt-5.6\|sonnet\|Start Grok" CLAUDE.md docs/RUNBOOK.md docs/templates/*.md docs/prompts/ops-cycle.md` → no output.
   The two historical ops files carry the "Historical" note.

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
