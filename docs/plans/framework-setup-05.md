# Plan · framework-setup-05 · review.sh fails loudly on an empty or verdict-less review

Drafted by Cursor Grok 4.6 High from docs/briefs/framework-setup-05.md.

2026-10-22. Plan only, not approved. Don't build from it until `docs/reviews/framework-setup-05.md` holds an APPROVE for this file.
The reviewer checks this plan, its task file `docs/prompts/framework-setup-05.md`, and its test plan `docs/tests/framework-setup-05.md` together. Don't add scope.

- Hub project: `projects/fhs-framework` · Spec: `docs/specs/framework-setup.md` · Decisions that bind it: CLAUDE.md loop step 4 (APPROVE gates every build and merge); evidence 2026-10-22, two of four `scripts/review.sh --diff feat/payroll-adp-01 --writer composer` runs exited 0 but wrote a 1-line empty `docs/reviews/payroll-adp-01-diff.md` (printed verdict `NONE`)
- `ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`)

## Verdict

Build.

## What changes, in plain words

A review that comes back empty or without a real APPROVE, APPROVE AFTER FIXES, or REJECT is no longer saved as the review. The script tries the reviewer once more; if that is still empty or not a real verdict, it stops with an error and writes no new file under `docs/reviews/`. An earlier review file is left as it was.

## Design (already chosen; do not invent another)

1. **One shared function** in `scripts/review.sh` (name it `run_reviewer`), used by both the `--diff` branch (today around the `cursor-agent` / `mv` at line 176) and the plan branch (today around line 233), so the two paths cannot drift. Each branch still builds its prompt as it does today. Diff still passes `--workspace "$WT"`; plan still `cd "$REPO"` before the call. `--check-only`, writer routing, the drafter guard, models, and the prompt text do not change. `scripts/lib/verdict.sh` is not edited; the function calls `verdict` from it.

2. **Keep the reply only if all three are true** after a `cursor-agent` call: the agent exited 0; the temp file `$OUT_TMP` exists and has non-blank content (at least one non-whitespace character); and `verdict "$OUT_TMP"` is not `NONE`. Then `mv "$OUT_TMP" "$OUT"`, print `Review written: ${OUT#"$REPO/"}`, and print `verdict "$OUT"` (same as today). Capture the agent's exit status so `set -euo pipefail` does not skip the retry when the agent is non-zero.

3. **Retry once, then fail.** If the keep-check fails, run the same `cursor-agent` call one more time (two tries total). If the retry also fails: `rm -f "$OUT_TMP"`, leave nothing new in `docs/reviews/` (do not create `$OUT`; if `$OUT` already exists, do not write it — byte-for-byte unchanged), print to stderr exactly `review.sh: reviewer returned no verdict (empty or malformed output) after 2 tries` and also name `$MODEL` and `$NAME` on that stderr, and `exit 5`. Exit 2, 3 and 4 keep their meanings. On this failure path the `--diff` `trap cleanup_diff EXIT` must still run (worktree under the review path is removed). The function must not unset `CREATED` or `WT` or disable the trap.

4. **Tests** in `scripts/tests/test_framework.sh` (PATH shim for `cursor-agent`, no real model calls, throwaway `FHS_REPO` like the existing cases). Keep every existing case. New fixtures only, under `scripts/tests/fixtures/` if a stub needs a file to cat; do not edit existing fixtures. Each of the first seven bullets runs for plan mode and for `--diff`. `--diff` agent cases need the reports present and a missing worktree path (remove any leftover `$wt` from the existing-dir case first). Count shim calls.

   - stub prints nothing, exit 0 → exit 5, stderr names the failure (the sentence above, plus model and `$NAME`), no `$OUT` and no `$OUT.tmp` left; stub called exactly 2 times.
   - stub prints `# Review · x` with no `## Verdict` → same as above.
   - stub prints a review with `## Verdict` then `MAYBE` → same as above.
   - stub exits non-zero → same as above.
   - stub fails the first call, returns a valid `APPROVE` review on the second → exit 0, file written, prints `APPROVE`.
   - valid review on the first call → exit 0, written once, stub called once (no extra call).
   - an older `$OUT` already exists and both tries fail → the older file is byte-for-byte unchanged.
   - `--diff` failure path → the temporary worktree under `/root/fhs-skills-wt/` (or the test's equivalent, `$parent/fhs-skills-wt/review-<short>`) is removed.
   - existing `scripts/tests/test_framework.sh` cases still pass; `bash -n scripts/review.sh` and `shellcheck` (if installed) are clean.

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.

## Files the builder may edit

- `scripts/review.sh`
- `scripts/tests/test_framework.sh`
- `scripts/tests/fixtures/*` (new fixtures only)

## Files the builder must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the clone below.
- `skills/`, `shared/config.json`, `docs/` (Claude owns docs)
- `scripts/lib/verdict.sh`, `scripts/draft.sh`, `scripts/build.sh`

## Live systems touched

None. No Toast, R365, ADP, NCR, Dropbox, Windows mirror or payroll.

## Done-check (real outcome)

1. `bash scripts/tests/test_framework.sh` in the clone: every line PASS, exit 0. A PATH-shim run of `scripts/review.sh` whose stub prints nothing exits 5 and leaves no new file in `docs/reviews/`.
2. After merge, the next real `scripts/review.sh` run in any lane writes a review whose verdict line is APPROVE, APPROVE AFTER FIXES or REJECT.

## Where it runs

Server (dev-lxc-1) only.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`. `scripts/` on `main` is the trusted copy Ops runs; merging is the release. Skills are untouched.
- **Windows mirror:** not affected.
- **Live before merge:** today's `review.sh` (empty or verdict-less agent output can still be saved and exit 0).

## Where the builder works

- Clone `/srv/fhs-build/framework-setup-05` (from `scripts/build.sh prepare docs/plans/framework-setup-05.md framework-setup-05 --role build`) · branch `feat/framework-setup-05` · cut from the `main` commit that holds this plan, its task file, test plan and APPROVE review. Model `composer-2.5`, user `fhsbuild`.

## Sequence

`ROLE=build`, `WRITER=composer` (`docs/prompts/ops-cycle.md`):

1. Plan review: `scripts/review.sh --writer grok docs/plans/framework-setup-05.md`. The reviewer is `composer-2.5`, never Grok. It must be APPROVE. Commit the plan, `docs/prompts/framework-setup-05.md`, `docs/tests/framework-setup-05.md` and that review to `main` before prepare.
2. `build.sh prepare docs/plans/framework-setup-05.md framework-setup-05 --role build`; Builder (Composer 2.5); fresh Tester; `build.sh collect framework-setup-05`; `review.sh --diff feat/framework-setup-05 --writer composer`. Merge on APPROVE with every pre-merge test PASS. No builder-written code runs as root until the diff review is APPROVE.

## What stays

`--check-only`, writer routing, the drafter guard, default models, `REVIEW_MODEL`, the review prompt text, `build.sh`, `draft.sh`, the verdict parser and its three tokens, exit 2 / 3 / 4, the `--diff` worktree path and cleanup trap, the fhsbuild sandbox, and "no builder code runs as root before a diff APPROVE". One automatic retry only. No skill, config, Windows, or live-system change.
