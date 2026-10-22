# Agent task · framework-setup-05 · build

> **For the coding agent (Composer 2.5 via `agent`; Cursor Grok 4.6 High for research tasks).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan (`docs/reviews/framework-setup-05.md`: APPROVE).
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/framework-setup-05`
> and tell it "Do the task in docs/prompts/framework-setup-05.md".

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). `scripts/review.sh` today saves whatever `cursor-agent` prints and exits 0, even when the reply is empty or has no real verdict (printed `NONE`). This task makes the script keep a reply only when it has a real verdict, retry the reviewer once, and otherwise exit 5 with no new file under `docs/reviews/`.

## Where you work

- Workspace: `/srv/fhs-build/framework-setup-05`, your own clone of the repo. Work only here.
- Branch: create `feat/framework-setup-05` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/framework-setup-05.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. `scripts/review.sh`, `scripts/lib/verdict.sh` (read only; do not edit it), `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/review-approve.md`

## Steps

1. `git switch -c feat/framework-setup-05`.
2. In `scripts/review.sh`, add one shared function named `run_reviewer`. Both the `--diff` branch (today the `cursor-agent` / `mv` at line 176) and the plan branch (today around line 233) call it, so the two paths cannot drift. Each branch still builds its prompt as it does today. Diff still passes `--workspace "$WT"`; plan still `cd "$REPO"` before the call. `--check-only`, writer routing, the drafter guard, models, and the prompt text do not change. `scripts/lib/verdict.sh` is not edited; the function calls `verdict` from it.
3. Keep the reply only if all three are true after a `cursor-agent` call: the agent exited 0; the temp file `$OUT_TMP` exists and has non-blank content (at least one non-whitespace character); and `verdict "$OUT_TMP"` is not `NONE`. Then `mv "$OUT_TMP" "$OUT"`, print `Review written: ${OUT#"$REPO/"}`, and print `verdict "$OUT"` (same as today). Capture the agent's exit status so `set -euo pipefail` does not skip the retry when the agent is non-zero.
4. If the keep-check fails, run the same `cursor-agent` call one more time (two tries total). If the retry also fails: `rm -f "$OUT_TMP"`, leave nothing new in `docs/reviews/` (do not create `$OUT`; if `$OUT` already exists, do not write it — byte-for-byte unchanged), print to stderr exactly `review.sh: reviewer returned no verdict (empty or malformed output) after 2 tries` and also name `$MODEL` and `$NAME` on that stderr, and `exit 5`. Exit 2, 3 and 4 keep their meanings. On this failure path the `--diff` `trap cleanup_diff EXIT` must still run (worktree under the review path is removed). The function must not unset `CREATED` or `WT` or disable the trap. One automatic retry only.
5. In `scripts/tests/test_framework.sh`, keep every existing case. Add PATH-shim cases for `cursor-agent` (no real model calls) in the existing throwaway `FHS_REPO`. New fixtures only, under `scripts/tests/fixtures/` if a stub needs a file to cat; do not edit existing fixtures. Reuse `scripts/tests/fixtures/review-approve.md` for a valid `APPROVE` review. Each of the first seven bullets runs for plan mode and for `--diff`. `--diff` agent cases need the reports present and a missing worktree path (remove any leftover `$wt` from the existing-dir case first). Count shim calls.
   - stub prints nothing, exit 0 → exit 5, stderr names the failure (the sentence in step 4, plus model and `$NAME`), no `$OUT` and no `$OUT.tmp` left; stub called exactly 2 times.
   - stub prints `# Review · x` with no `## Verdict` → same as above.
   - stub prints a review with `## Verdict` then `MAYBE` → same as above.
   - stub exits non-zero → same as above.
   - stub fails the first call, returns a valid `APPROVE` review on the second → exit 0, file written, prints `APPROVE`.
   - valid review on the first call → exit 0, written once, stub called once (no extra call).
   - an older `$OUT` already exists and both tries fail → the older file is byte-for-byte unchanged.
   - `--diff` failure path → the temporary worktree under `/root/fhs-skills-wt/` (or the test's equivalent, `$parent/fhs-skills-wt/review-<short>`) is removed.
6. `bash -n scripts/review.sh`. If `shellcheck` is installed, run it on `scripts/review.sh` (do not install it). Run the suite.

## You may edit only

- `scripts/review.sh`
- `scripts/tests/test_framework.sh`
- `scripts/tests/fixtures/*` (new fixtures only)

## You must not

- Edit any file not listed above, or anything under `skills/`, `shared/`, `docs/plans/`, `docs/reviews/` or `docs/prompts/`.
- Edit `scripts/lib/verdict.sh`, `scripts/draft.sh`, or `scripts/build.sh`.
- Push, merge, or commit to `main`.
- Log in to anything, type a password, or open Toast, R365 or ADP.
- Install packages or change system settings, unless a step says so.
- Call the real `cursor-agent` or `agent`. Tests use a PATH shim only. Do not change `--check-only`, writer routing, the drafter guard, default models, `REVIEW_MODEL`, the review prompt text, exit 2 / 3 / 4, or the `--diff` worktree path and cleanup trap.

## Tests (run every one, record the real output)

1. `bash -n scripts/review.sh` → no output
2. `command -v shellcheck >/dev/null && shellcheck scripts/review.sh || echo 'shellcheck not installed'` → clean, or the skip line
3. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS, `exit=0` (includes a PATH-shim run whose stub prints nothing: exit 5, no new file in `docs/reviews/`)
4. `git diff --name-only main...HEAD` → only the allowed files

## When done

1. Commit on `feat/framework-setup-05`. End the message with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write your report to `/srv/fhs-build/reports/framework-setup-05.md` (outside the repo):

```text
## Summary
<≤5 lines: done or stopped, tests n/n, deviations. Claude reads only this section.>

Task: framework-setup-05 · Branch: feat/framework-setup-05 · Commits: <hashes>
Files changed: <list>
Tests: <n>/<n> passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
