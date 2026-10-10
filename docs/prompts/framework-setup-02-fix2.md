# Agent task · framework-setup-02 · fix round 2 (build)

> **For the coding agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** A fix round on `feat/framework-setup-02`, under the
> approved plan `docs/plans/framework-setup-02.md`. Hand-off: "Do the task in /srv/fhs-build/reports/framework-setup-02-fix2.md".

## Context

The final GPT-5.6 review, `docs/reviews/framework-setup-02-diff-r3.md` on main (APPROVE AFTER FIXES), found two majors and one minor.
The root-only checks T16–T19 all passed.

## Where you work

`/srv/fhs-build/framework-setup-02`, the existing branch `feat/framework-setup-02` (now at `d4d83d2`).

## Steps

1. **`scripts/review.sh --diff`, safe cleanup.** Before installing the cleanup trap, refuse (exit 4, message
   `review worktree path already exists: <path>`) if the worktree path `$WT` already exists as a file, a directory, or a
   registered worktree (`git -C "$REPO" worktree list --porcelain` contains `worktree $WT`). Set a variable such as `CREATED=0`.
   Only after `git worktree add` succeeds, set `CREATED=1`. The cleanup function removes the worktree (and runs any `rm -rf`) only
   when `CREATED=1`. It removes the `.tmp` output file in either case.
2. **`scripts/build.sh collect`, print the report.** After a successful fetch, print a line `--- report: <path> ---`, then the report's
   contents (`cat "$report"`), then the existing `Next: scripts/review.sh --diff feat/<name>` line. Keep the fetch exactly as it is.
3. **Fixture whitespace.** Remove the trailing whitespace from `scripts/tests/fixtures/review-reject.md` without changing its verdict.
4. **Tests.** Add these to `scripts/tests/test_framework.sh` (all in temp dirs, never `/root` or `/srv/fhs-build`):
   - `review-diff-existing-dir`: create the worktree path that review.sh would use, as a directory holding a sentinel file. Put both
     reports in place, run `scripts/review.sh --diff feat/zz` → exit 4, and the sentinel file still exists.
   - `collect-prints-report`: make a temp git repo as `FHS_REPO`, and a temp "clone" under `FHS_BUILD_ROOT/zz` with a `feat/zz` branch
     and one commit. Put a report with a unique line in `FHS_BUILD_ROOT/reports/zz.md`. Run `build.sh collect zz` → exit 0; the output
     contains the unique line and the `Next:` line; and `feat/zz` exists in `FHS_REPO`.
   - `fixtures-no-trailing-ws`: `! grep -nE ' +$' scripts/tests/fixtures/*.md`.

## You may edit only

- `scripts/review.sh`, `scripts/build.sh`, `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/review-reject.md`

## You must not

- Edit anything else, change git config, push, merge, or use sudo.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS (now 27), `exit=0`
2. `bash -n scripts/build.sh scripts/review.sh scripts/tests/test_framework.sh` → no output
3. `git diff --check main...HEAD` → no output
4. `git diff --name-only main...HEAD` → still only the 12 files from round 1
5. `git status --short` → empty

## When done

Commit `review.sh: never remove a pre-existing worktree; build.sh collect prints the report; fixture whitespace (fix r3 review)` with
`Co-Authored-By: Grok 4.7 High (cursor-agent)` (same one-shot author as before). Append a "Fix round 2" section to
`/srv/fhs-build/reports/framework-setup-02.md`. If a step can't be done exactly as written, stop and say why in the report.
