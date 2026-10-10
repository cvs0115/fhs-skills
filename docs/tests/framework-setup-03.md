# Test plan · framework-setup-03

> **For the tester agent (Grok 4.7 High in cursor-agent, a fresh session, not the builder).** Run every case, record real evidence,
> and judge PASS, FAIL or BLOCKED. Don't fix anything. Hand-off: "Run the test plan in docs/tests/framework-setup-03.md".

## What's being tested

`review.sh` picks Grok 4.7 Extra High for plan reviews and Claude Sonnet 5 for diff reviews, refuses anything else per mode, ignores
`REVIEW_MODEL`, names the right writer in each prompt, and has no GPT left. Plan: `docs/plans/framework-setup-03.md`.

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
| T3 | shell | `REVIEW_PLAN_MODEL=claude-sonnet-5-thinking-high FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-03.md; echo exit=$?`, then the same with `gpt-5.6-sol-high` | `exit=2` both | output |
| T4 | shell | `REVIEW_DIFF_MODEL=grok-4.7-xhigh` and `=gpt-5.6-sol-high`, each with `FHS_REPO=$W bash scripts/review.sh --check-only --diff main` (or the `--check-only` form the script documents for diff mode) | `exit=2` both | output |
| T5 | shell | `REVIEW_MODEL=whatever FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-03.md 2>&1; echo exit=$?` | a warning that `REVIEW_MODEL` is ignored, and `exit=0` | output |
| T6 | shell | `grep -n 'The writer is' scripts/review.sh` | the plan prompt says the writer is Claude and the reviewer is Grok; the diff prompt says the writer is Grok and the reviewer is Claude | output |
| T7 | shell | `grep -c 'gpt-5.6' scripts/review.sh scripts/lib/guards.sh` | `0` and `0` | output |
| T8 | shell | `grep -n -i 'reviewer' CLAUDE.md docs/RUNBOOK.md \| grep -i -E 'grok-4.7-xhigh\|Extra High\|Sonnet'` | both files name the new pairing; `grep -c 'GPT' docs/RUNBOOK.md` → 0 | output |
| T9 | shell | `git diff --name-only main...HEAD`; `git diff --check main...HEAD`; `git status --short` | only allowed files; no whitespace errors; clean | output |
| T10 | ops | Ops runs the branch's `scripts/review.sh docs/plans/framework-setup-03.md` from a root worktree of the branch (done-check 2), then `bash scripts/lib/verdict.sh <that review file>` | the review header names `grok-4.7-xhigh`; verdict.sh prints one of APPROVE / APPROVE AFTER FIXES / REJECT (not NONE) | pasted output |

Mark T10 BLOCKED (ops) until its output is pasted to you.

## Post-merge verification (not a gate)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P1 | ops | The final review's file header (Sequence step 7) | names `claude-sonnet-5-thinking-high` | pasted line |

## Results

Write `/srv/fhs-build/reports/framework-setup-03-test.md` (Totals and Verdict as in the template). Edit nothing in the repo.
