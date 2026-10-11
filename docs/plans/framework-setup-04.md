# Plan · framework-setup-04 · Grok drafts, Composer reviews, writers fix minors

2026-10-11. Plan only, not approved. Don't build from it until `docs/reviews/` holds an APPROVE for this file.

- Hub project: `projects/framework` · Brief: `docs/briefs/framework-setup-04.md`
- Spec: `docs/specs/framework-setup.md` · Decisions that bind it: hub log 2026-10-11 "Token savings" (drafting, fix rounds, running agents);
  2026-10-10 included Cursor models only; reviewer never the writer's family.

## Verdict

Build.

## What changes, in plain words

Claude stops writing full plans. A Cursor Grok agent drafts them from Claude's one-page brief, and Composer reviews those drafts, so no
model grades its own family. When a review asks only for small fixes, the same Grok agent makes them. Claude steps in only for a
major problem, a rejection, or a third round. This saves Claude tokens and leaves every safety gate in place.

## Design

1. **`scripts/lib/guards.sh` `check_reviewer plan <writer> <model>`:** writer `claude` → allowed `cursor-grok-4.6-xhigh` (as today);
   writer `grok` → allowed `composer-2.5`; any other writer → exit 2 with the existing message style.
2. **`scripts/review.sh` plan mode:**
   - Accept `--writer claude|grok` for plans (default `claude`). Diff mode is unchanged (`composer|grok`, default `composer`). Update `usage`.
   - Default model: claude → `cursor-grok-4.6-xhigh`, grok → `composer-2.5`; `REVIEW_MODEL` still overrides and still goes through `check_reviewer`.
   - **Drafter guard:** a plan whose first 10 lines contain `Drafted by Cursor Grok` is Grok's. Writer `claude` (given or default) on
     such a plan → exit 2, `plan was drafted by Grok; use --writer grok`. Writer `grok` on a plan without the line → exit 2,
     `plan has no "Drafted by Cursor Grok" line; it is Claude's`. Runs in `--check-only` too. (A brief alone doesn't decide it:
     Claude also writes briefs for plans it writes itself, like this one.)
   - `writer_line` uses the chosen writer. When the writer is `grok`, the prompt also tells the reviewer to read
     `docs/briefs/<name>.md` and `docs/tests/<name>.md` (if present) and to treat a draft that adds scope, files or live changes the
     brief doesn't name as a major.
3. **`scripts/draft.sh` (new, sources `lib/guards.sh` and `lib/verdict.sh`, same style as `review.sh`):**
   - `draft.sh [--check-only] <name>`: needs `docs/briefs/<name>.md`, else exit 2. Refuses (exit 3) if any of
     `docs/plans/<name>.md`, `docs/prompts/<name>.md`, `docs/tests/<name>.md` exists. Runs three read-only calls, in order:
     `cursor-agent -p --mode ask --trust --model cursor-grok-4.6-high --output-format text "<prompt>" > <file>.tmp`, then `mv`:
     the plan (form `docs/templates/plan.md`, from the brief), then the task file (form `docs/templates/prompt.md`, from the brief and
     the new plan), then the test plan (form `docs/templates/test-plan.md`). Each prompt says: follow CLAUDE.md, add no scope beyond the
     brief, return only the file's markdown, put the line `Drafted by Cursor Grok 4.6 High from docs/briefs/<name>.md.` within the plan's first 10 lines. The `--trust`
     flag matches `review.sh`. If a call fails, remove its `.tmp`, leave files already written, exit 1.
     Prints one line per file: `wrote <path> (<n> lines)`. `DRAFT_MODEL` may override only with `cursor-grok-4.6-high`; else exit 2.
   - `draft.sh [--check-only] --fix <name>`: needs `docs/reviews/<name>.md` and the three files. Refuses with exit 3 and a reason
     line when: the verdict (`verdict` from `lib/verdict.sh`) isn't `APPROVE AFTER FIXES`; the `## Majors` section has any `- ` bullet
     other than one reading `None`/`none` (any case, optional trailing period); or `docs/reviews/<name>-r2.md` exists (this would be
     round 3). Reason lines start `CLAUDE:` so the caller knows Claude takes it. Otherwise it rewrites each of the three files with one
     Grok call ("apply only the review's Minors; change nothing else"), `.tmp` then `mv`, and prints `git diff --stat` for them.
   - `--check-only` does every check and prints `OK` without calling `cursor-agent`.
   - It never runs git commands that change state, and it writes only those three paths.
4. **Tests in `scripts/tests/test_framework.sh`** (check-only, no network, temp `FHS_REPO` like the existing cases):
   plan with the Drafted-by line + `--writer grok` → 0 and message names `composer-2.5`; grok + `REVIEW_MODEL=cursor-grok-4.6-xhigh` → 2; claude +
   `REVIEW_MODEL=composer-2.5` → 2; `--writer other` on a plan → 2; Drafted-by plan + no `--writer` → 2; plain plan + `--writer grok` → 2;
   diff cases unchanged; `draft.sh` no brief → 2; existing plan → 3; ok → `OK`; bad `DRAFT_MODEL` → 2; `--fix` with APPROVE → 3,
   REJECT → 3, AFTER FIXES + a major → 3, AFTER FIXES + `- None.` → OK, with `-r2.md` present → 3. New fixtures under `scripts/tests/fixtures/`.

## Files the builder may edit

- `scripts/review.sh`, `scripts/lib/guards.sh`, `scripts/draft.sh` (new), `scripts/tests/test_framework.sh`, new files in `scripts/tests/fixtures/`

## Files the builder must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `skills/`, `shared/config.json`, `docs/`, `scripts/build.sh`, `scripts/lib/verdict.sh`, `scripts/windows/`, `scripts/git-hooks/`.

## Live systems touched

None. No Toast, R365, ADP, NCR, Dropbox, Windows mirror or payroll.

## Done-check (real outcome)

1. `bash scripts/tests/test_framework.sh` in the clone: every line PASS, exit 0.
2. Real model routing (Ops, root, after the diff review is APPROVE): from a worktree of the branch,
   `scripts/review.sh --check-only docs/plans/framework-setup-04.md` prints `OK` (Claude wrote it), and
   `scripts/review.sh --check-only --writer grok docs/plans/framework-setup-04.md` exits 2 (no Drafted-by line).
3. Post-merge real run: Claude writes the next brief, and `scripts/draft.sh <next>` writes three files whose first lines are the
   template headings. `scripts/review.sh --writer grok docs/plans/<next>.md` writes a review whose header names `composer-2.5`.

## Where it runs

Server (dev-lxc-1) only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`. `scripts/` isn't loaded by skill sessions; Ops runs the `main` copy, so the merge is the release.
- **Windows mirror:** not affected.
- **Live before merge:** today's `review.sh` (plans → Grok Extra High only) and no `draft.sh`.

## Where the builder works

- Clone `/srv/fhs-build/framework-setup-04` (from `scripts/build.sh prepare ... --role build`) · branch `feat/framework-setup-04` · cut from
  the `main` commit that holds this plan, its task file, test plan and APPROVE review.

## Sequence

1. Review this plan: `scripts/review.sh docs/plans/framework-setup-04.md` (Claude-written: the current review.sh is right for it).
2. Commit the review; `build.sh prepare --role build`; Builder (Composer 2.5); fresh Tester; `build.sh collect`;
   `review.sh --diff feat/framework-setup-04 --writer composer`; done-check 2; merge on APPROVE with all pre-merge cases PASS.
3. After the merge, Claude updates `docs/prompts/ops-cycle.md` (plan review uses `--writer grok` when the plan has the Drafted-by line; minor-fix loop
   via `draft.sh --fix` for plans and a Composer fix task for diffs), the runbook and the hub.

## What stays

Diff review routing, the verdict parser, `build.sh`, the fhsbuild sandbox, every stop rule, and "no builder code runs as root before a
diff APPROVE". Plans Claude writes still go to `cursor-grok-4.6-xhigh`.
