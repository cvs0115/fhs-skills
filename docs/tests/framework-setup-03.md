# Test plan · framework-setup-03

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the builder).** Run every case, record real evidence, and judge
> PASS, FAIL or BLOCKED. Don't fix anything. Hand-off: "Run the test plan in docs/tests/framework-setup-03.md".

## What's being tested

`review.sh` picks the reviewer from the writer: Claude's plans and Composer's code go to `cursor-grok-4.6-xhigh`, and Grok's research
goes to `composer-2.5`. It refuses any other pairing, names the writer correctly in each prompt, and no GPT, Sonnet or grok-4.7 is left.
`build.sh prepare` prints the right hand-off model per role. Plan: `docs/plans/framework-setup-03.md`.

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/framework-setup-03` on `feat/framework-setup-03`, as `fhsbuild`; temp files under `mktemp -d` | run commands; edit nothing |
| ops | root, run by the Ops agent; output pasted to you | you judge it |

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `bash scripts/tests/test_framework.sh; echo exit=$?` | every line PASS, `exit=0` | output |
| T2 | shell | `W=$PWD; FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-03.md; echo exit=$?` | `OK`, `exit=0` | output |
| T3 | shell | `REVIEW_MODEL=composer-2.5`, then `REVIEW_MODEL=gpt-5.6-sol-high`, each with `FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-03.md; echo exit=$?` | `exit=2` both | output |
| T4 | shell | Diff mode, using the `--check-only` form the script documents: writer `composer` with the default model → exit 0; writer `composer` with `REVIEW_MODEL=composer-2.5` → 2; writer `grok` with the default model → exit 0; writer `grok` with `REVIEW_MODEL=cursor-grok-4.6-xhigh` → 2; `--writer other` → 2 | as stated | output |
| T5 | shell | `grep -n 'The writer is' scripts/review.sh` | the prompt text names the writer per case (Claude / Composer / Grok) and says the reviewer is a different family | output |
| T6 | shell | `grep -c 'gpt-5.6\|sonnet\|grok-4.7' scripts/review.sh scripts/lib/guards.sh scripts/build.sh` | `0` for each | output |
| T7 | shell | Make a temp repo as `FHS_REPO` with an APPROVE'd fixture plan (as the suite does). Run `build.sh prepare ... --check-only` with `--role build` and with `--role research`, plus a non-check-only run as non-root to see the hand-off text, or the hand-off function's output if the script exposes it | the hand-off names `composer-2.5` for build and `cursor-grok-4.6-high` for research, and says `Start agent:` | output |
| T8 | shell | `git diff --name-only main...HEAD`; `git diff --check main...HEAD`; `git status --short` | only `scripts/lib/guards.sh`, `scripts/review.sh`, `scripts/build.sh`, `scripts/tests/test_framework.sh` (plus new fixtures under `scripts/tests/fixtures/` if any); no whitespace errors; clean | output |
| T9 | ops | Ops runs the branch's `scripts/review.sh docs/plans/framework-setup-03.md` from a root worktree of the branch (done-check 2), then `bash scripts/lib/verdict.sh <that review file>` | the review header names `cursor-grok-4.6-xhigh`; verdict.sh prints APPROVE, APPROVE AFTER FIXES or REJECT (not NONE) | pasted output |

Mark T9 BLOCKED (ops) until its output is pasted to you.

## Post-merge verification (not a gate)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P1 | ops | The final review's header (Sequence step 7) | names `cursor-grok-4.6-xhigh` | pasted line |

## Results

Write `/srv/fhs-build/reports/framework-setup-03-test.md` (Totals and Verdict as in `docs/templates/test-plan.md`). Edit nothing in the repo.
