# Agent task · framework-setup-04 · build

> **For the Builder (Composer 2.5 via `agent --force`, as `fhsbuild`).** This file is your whole assignment.
> Hand-off: "Do the task in docs/prompts/framework-setup-04.md".

## Context

`scripts/review.sh` reviews plans only as Claude-written (reviewer Cursor Grok 4.6 Extra High). The owner decided on 2026-10-11 that
Cursor Grok 4.6 High drafts plans from Claude's briefs, Composer 2.5 reviews those drafts, and Grok fixes minor-only review findings.
You add plan-writer routing, a drafter guard, and `scripts/draft.sh`.

## Where you work

`/srv/fhs-build/framework-setup-04`, branch `feat/framework-setup-04` (create it from the checked-out `main`). Nowhere else.

## Read first

1. `CLAUDE.md` ("Roles", "Token budget")
2. `docs/plans/framework-setup-04.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `scripts/review.sh`, `scripts/lib/guards.sh`, `scripts/lib/verdict.sh`, `scripts/tests/test_framework.sh`

## Steps

1. `git switch -c feat/framework-setup-04`.
2. `guards.sh`: plan writer `grok` → allowed `composer-2.5` (plan "Design" 1).
3. `review.sh`: `--writer claude|grok` for plans, default models, drafter guard, writer line, and the extra read list for Grok drafts (Design 2).
4. `scripts/draft.sh`: draft and `--fix` modes, `--check-only`, `DRAFT_MODEL` guard, exit codes and output exactly as in Design 3. `chmod +x`.
5. Tests and fixtures (Design 4). Keep every existing case.
5b. Apply every bullet in `docs/reviews/framework-setup-04.md` "## Minors" (part of this task; the review is APPROVE).
6. `bash -n` each changed script; run the suite.

## You may edit only

`scripts/review.sh`, `scripts/lib/guards.sh`, `scripts/draft.sh` (new), `scripts/tests/test_framework.sh`, new files under `scripts/tests/fixtures/`.

## You must not

- Edit `docs/`, `skills/`, `shared/`, `scripts/build.sh`, `scripts/lib/verdict.sh`, or anything outside your clone.
- Call `cursor-agent` or `agent` for real (tests use `--check-only` only). Push, merge, or touch `/root`.

## Tests (run every one, record the real output)

1. `for f in scripts/review.sh scripts/lib/guards.sh scripts/draft.sh; do bash -n "$f" && echo "ok $f"; done`
2. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS, `exit=0`
3. `git diff --name-only main...HEAD` → only the allowed files

## When done

1. Commit on `feat/framework-setup-04`. End the message with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/framework-setup-04.md` (outside the repo), starting with `## Summary`
   (≤5 lines), then the fields in `docs/templates/prompt.md` "When done".

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
