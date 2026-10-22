# Test plan · framework-setup-05

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/framework-setup-05.md".

## What's being tested

`review.sh` keeps a reviewer reply only when `cursor-agent` exited 0, the temp file has non-blank content, and `verdict` is not `NONE`. It retries that call once; if both tries fail it exits 5, writes no new file under `docs/reviews/`, and leaves an older review file unchanged. This proves the plan's done-check: the suite passes; a PATH-shim run whose stub prints nothing exits 5 with no new review file; after merge, the next real `review.sh` writes APPROVE, APPROVE AFTER FIXES or REJECT.
Plan: `docs/plans/framework-setup-05.md` · Builder report: `/srv/fhs-build/reports/framework-setup-05.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/framework-setup-05` on branch `feat/framework-setup-05`, as `fhsbuild`; throwaway repos under `mktemp -d` | run commands; edit nothing in the clone |
| browser-server | not used | no web page |
| browser-windows | not used | no web page |
| owner | Ops pastes post-merge output; you judge it | write down exactly what they report |

No browser cases. Never call the real `cursor-agent` or `agent`. Every `review.sh` run that would reach the agent uses a PATH shim you control (T1 is the suite, which must shim itself).

Browser rules (every browser case): the owner signs in, and you never type a username or password.
Read and navigate only. Never click save, submit, approve, pay, send or delete. Save a screenshot
for each check to `/srv/fhs-build/reports/framework-setup-05-shots/<case-id>.png` (Windows:
`C:\fhs\reports\framework-setup-05-shots\`). If a page asks for a login or MFA, mark the case BLOCKED (owner)
and move on.

## Preconditions

- Builder report `/srv/fhs-build/reports/framework-setup-05.md` exists. You are in `/srv/fhs-build/framework-setup-05` on `feat/framework-setup-05` as `fhsbuild`. Set `CLONE=/srv/fhs-build/framework-setup-05` and `FIX=$CLONE/scripts/tests/fixtures`.
- T1–T2 and T10 run from `$CLONE`. T3–T9 run against a throwaway git repo via `FHS_REPO`, never against `/root/fhs-skills`. Delete the throwaway at the end.
- **Throwaway (once, reuse for T3–T9):** `TMP=$(mktemp -d -t fs05-XXXX)`; `REPO=$TMP/repo`; `BR=$TMP/build`; `BIN=$TMP/bin`; `CALLS=$TMP/calls`. `mkdir -p "$REPO/docs/plans" "$REPO/docs/reviews" "$BR/reports" "$BIN"`. `git -C "$REPO" init -b main`; set `user.email`, `user.name`, `commit.gpgsign false`. Write `printf '# Plan zz-01\n' > "$REPO/docs/plans/zz-01.md"` (no "Drafted by Cursor Grok" line). Commit. `git -C "$REPO" branch feat/zz`. Write `$BR/reports/zz.md` and `$BR/reports/zz-test.md` (any text). Worktree path is `$TMP/fhs-skills-wt/review-zz`. Before every `--diff` run: remove that path if it exists (`rm -rf`) and `git -C "$REPO" worktree prune`.
- **PATH shim:** write `$BIN/cursor-agent` (executable) that appends one line to `$CALLS` then follows `STUB_MODE`: `empty` prints nothing and exits 0; `noverdict` prints `# Review · x` and exits 0; `maybe` prints `# Review · x`, `## Verdict`, `MAYBE` and exits 0; `nonzero` exits 1; `retry-ok` on call 1 prints nothing and exits 0, on call 2 cats `$FIX/review-approve.md` and exits 0; `first-ok` cats `$FIX/review-approve.md` and exits 0. Before each run: `rm -f "$CALLS" "$REPO/docs/reviews/zz-01.md" "$REPO/docs/reviews/zz-01.md.tmp" "$REPO/docs/reviews/zz-diff.md" "$REPO/docs/reviews/zz-diff.md.tmp"` (T9 keeps the older `$OUT` instead of deleting it). Confirm `command -v cursor-agent` is `$BIN/cursor-agent` under `PATH="$BIN:$PATH"`.
- **Run line:** `env -u REVIEW_MODEL FHS_REPO="$REPO" FHS_BUILD_ROOT="$BR" PATH="$BIN:$PATH" STUB_MODE=<mode> bash "$CLONE/scripts/review.sh"` then either `docs/plans/zz-01.md` (plan) or `--diff feat/zz` (`--diff`). Capture stdout, stderr, and exit. Plan `$OUT` is `$REPO/docs/reviews/zz-01.md`; `--diff` `$OUT` is `$REPO/docs/reviews/zz-diff.md`. `$OUT.tmp` is that path plus `.tmp`.
- **fail-pack** (T3–T6 and T9): exit 5; stderr contains exactly `review.sh: reviewer returned no verdict (empty or malformed output) after 2 tries` and also names model `cursor-grok-4.6-xhigh` and the subject (`zz-01` for plan, `zz-diff` for `--diff`); no `$OUT.tmp`; stub called exactly 2 times (`wc -l` of `$CALLS` is 2); for `--diff`, `$TMP/fhs-skills-wt/review-zz` is gone and `git -C "$REPO" worktree list` has no `review-`. T3–T6: `$OUT` is absent. T9: `$OUT` is byte-for-byte the seeded older file.
- **ok-pack** (T7–T8): exit 0; stdout contains `Review written: docs/reviews/<zz-01|zz-diff>.md` and `APPROVE`; `$OUT` exists; `bash "$CLONE/scripts/lib/verdict.sh" "$OUT"` prints `APPROVE`.
- If a step would call the real `cursor-agent`, kill it and FAIL that case. Do not install `shellcheck`.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | From `$CLONE`: `bash scripts/tests/test_framework.sh; echo exit=$?` | every line PASS, no FAIL, `exit=0`. Existing cases still pass. Suite includes PATH-shim `review.sh` runs (not `--check-only` only) | command + full output |
| T2 | shell | From `$CLONE`: `bash -n scripts/review.sh`; then `command -v shellcheck >/dev/null && shellcheck scripts/review.sh || echo 'shellcheck not installed'` | `bash -n` prints nothing, exit 0. `shellcheck` is clean, or the skip line | both commands + output |
| T3 | shell | `STUB_MODE=empty`. Plan run, then `--diff` run. Count shim calls each time | fail-pack both; no `$OUT` | both exits, stderr, `calls=`, `ls` of `docs/reviews` |
| T4 | shell | `STUB_MODE=noverdict`. Plan run, then `--diff` run | fail-pack both; no `$OUT` | both exits, stderr, `calls=`, `ls` |
| T5 | shell | `STUB_MODE=maybe`. Plan run, then `--diff` run | fail-pack both; no `$OUT` | both exits, stderr, `calls=`, `ls` |
| T6 | shell | `STUB_MODE=nonzero`. Plan run, then `--diff` run | fail-pack both; no `$OUT` | both exits, stderr, `calls=`, `ls` |
| T7 | shell | `STUB_MODE=retry-ok`. Plan run, then `--diff` run | ok-pack both; stub called exactly 2 times each; prints `APPROVE` | both exits, stdout, `calls=`, verdict |
| T8 | shell | `STUB_MODE=first-ok`. Plan run, then `--diff` run | ok-pack both; stub called exactly 1 time each (no extra call); `$OUT` written once | both exits, stdout, `calls=`, verdict |
| T9 | shell | Seed `$OUT` with a unique marker file (copy to `$TMP/older.bak`). `STUB_MODE=empty`. Plan run (`zz-01.md`), then seed and run `--diff` (`zz-diff.md`). `cmp` each `$OUT` to its bak | fail-pack both; each older `$OUT` is byte-for-byte unchanged (`cmp` silent, exit 0) | both exits, stderr, `cmp`, marker text |
| T10 | shell | From `$CLONE`: `git diff --name-only main...HEAD`; `git diff --check main...HEAD`; `git status --short` | only `scripts/review.sh`, `scripts/tests/test_framework.sh`, and new files under `scripts/tests/fixtures/`; no `scripts/lib/verdict.sh`, `scripts/draft.sh`, `scripts/build.sh`, `skills/`, `shared/`, or `docs/`; no whitespace errors; status clean | path list + check + status |

## Post-merge verification (not a gate; a failure opens a fix plan)

Mark P1 and P2 BLOCKED (owner) until Ops pastes the output. Do not run them against live `docs/reviews/` without a throwaway `FHS_REPO`.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | The next real `scripts/review.sh` run in any lane after merge (no shim). `bash scripts/lib/verdict.sh` on the file it wrote | verdict is APPROVE, APPROVE AFTER FIXES or REJECT (not NONE); a review file was written | pasted verdict line + `verdict.sh` output |
| P2 | owner | On merged `main`, PATH-shim `cursor-agent` that prints nothing and exits 0; `FHS_REPO` a throwaway repo as in T3; run plan-mode `scripts/review.sh` | exit 5; stderr names the failure; no new file in that repo's `docs/reviews/` | pasted exit, stderr, `ls` of throwaway `docs/reviews` |

## Results

Write `/srv/fhs-build/reports/framework-setup-05-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: framework-setup-05 · Branch: feat/framework-setup-05 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

Then `rm -rf "$TMP"` and confirm it's gone.

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Type credentials, or click anything that changes data in Toast, R365, ADP or any site.
- Call the real `cursor-agent` or `agent`. Run `review.sh` without a PATH shim except T1 (the suite). Touch `/root/fhs-skills`.
