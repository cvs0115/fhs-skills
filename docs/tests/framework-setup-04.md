# Test plan · framework-setup-04

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the builder).** Run every case, record real evidence, and judge
> PASS, FAIL or BLOCKED. Don't fix anything. Hand-off: "Run the test plan in docs/tests/framework-setup-04.md".

## What's being tested

`review.sh` routes a plan to `composer-2.5` when Grok drafted it (`--writer grok`), refuses a Grok-drafted plan reviewed as Claude's (and the reverse), and keeps
diff routing as it was. `scripts/draft.sh` checks its inputs and refuses fix rounds that belong to Claude. Plan: `docs/plans/framework-setup-04.md`.

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/framework-setup-04` on `feat/framework-setup-04`, as `fhsbuild`; temp repos under `mktemp -d` | run commands; edit nothing in the clone |
| ops | root, run by the Ops agent; output pasted to you | you judge it |

No case calls a model for real. Every `review.sh` and `draft.sh` call below uses `--check-only`.

## Preconditions

- `/srv/fhs-build/reports/framework-setup-04.md` exists and its Summary says done.
- For T3–T9: a temp repo `T=$(mktemp -d)` set up as the suite does (git init, `docs/{plans,prompts,tests,reviews,briefs,templates}`), a
  fixture plan `docs/plans/zz-04.md`; run with `FHS_REPO=$T`.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `bash scripts/tests/test_framework.sh; echo exit=$?` | every line PASS, `exit=0`; the new cases from plan Design 4 are present by name | output |
| T2 | shell | `for f in scripts/review.sh scripts/lib/guards.sh scripts/draft.sh; do bash -n $f && echo ok; done; test -x scripts/draft.sh && echo exec` | three `ok`, `exec` | output |
| T3 | shell | Plain plan (no Drafted-by line): `review.sh --check-only docs/plans/zz-04.md` → ?; `--writer claude` → ?; `--writer grok` → ?; `--writer other` → ? | `0`, `0`, `2`, `2` | output with `exit=` |
| T4 | shell | Pairing guard (grok on the zz-06 Drafted-by plan from T5, claude on zz-04): `--writer grok` with `REVIEW_MODEL=cursor-grok-4.6-xhigh`; `--writer claude` with `REVIEW_MODEL=composer-2.5` | `2` both | output |
| T5 | shell | Copy the fixture to `docs/plans/zz-06.md` with `Drafted by Cursor Grok 4.6 High from docs/briefs/zz-06.md.` as line 3. No `--writer` → ?; `--writer claude` → ?; `--writer grok` → ?; same file with the line moved to line 12, `--writer grok` → ? | `2` (message says use `--writer grok`), `2`, `0`, `2` | output |
| T6 | shell | Diff unchanged: `--check-only --diff feat/zz` (default), `--writer grok --diff feat/zz`, `REVIEW_MODEL=composer-2.5 ... --diff feat/zz` | `0`, `0`, `2` | output |
| T7 | shell | `draft.sh --check-only zz-05` (no brief) → ?; with brief only → ?; then create `docs/plans/zz-05.md` → ?; `DRAFT_MODEL=composer-2.5` with brief only → ? | `2`, `OK`/`0`, `3`, `2` | output |
| T8 | shell | `--fix` gates on `zz-04` (plan, prompt, test files present) with review fixtures: APPROVE → ?; REJECT → ?; AFTER FIXES + one major → ?; AFTER FIXES + `- None.` → ?; same plus `docs/reviews/zz-04-r2.md` → ? | `3`, `3`, `3`, `OK`/`0`, `3`; each `3` prints a line starting `CLAUDE:` | output |
| T9 | shell | `grep -n 'cursor-agent' scripts/draft.sh` and `grep -n 'git ' scripts/draft.sh` | every `cursor-agent` call has `--mode ask` and `--model` from the guarded variable, and output goes to a `.tmp` file; no state-changing git commands (`git diff --stat` only) | output |
| T10 | shell | `git diff --name-only main...HEAD`; `git diff --check main...HEAD`; `git status --short` | only the plan's allowed files; no whitespace errors; clean | output |
| T11 | ops | Ops, after the diff review is APPROVE, from a root worktree of the branch: `scripts/review.sh --check-only docs/plans/framework-setup-04.md; echo exit=$?` then `scripts/review.sh --check-only --writer grok docs/plans/framework-setup-04.md; echo exit=$?` | `OK` `exit=0`, then `exit=2` (no Drafted-by line) | pasted output |
| T12 | shell | Real Grok draft (review minor 1): `review.sh --check-only docs/plans/store-audit-122-02.md; echo exit=$?`, then with `--writer grok`. Also `draft.sh --check-only --fix framework-setup-04` (Claude's plan) | `exit=2`, then `OK` `exit=0`; the `--fix` call exits 3 with a `CLAUDE:` line (review minor 2, or no AFTER FIXES verdict) | output |

Mark T11 BLOCKED (ops) until its output is pasted to you.

## Post-merge verification (not a gate; a failure opens a fix plan)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P1 | ops | `scripts/draft.sh <next plan>` on the next real brief | three `wrote ... (n lines)` lines; each file starts with its template heading | pasted output |
| P2 | ops | `scripts/review.sh --writer grok docs/plans/<next>.md`, then `head -3` of the review | header names `composer-2.5` | pasted lines |

## Results

Write `/srv/fhs-build/reports/framework-setup-04-test.md` (outside the repo), starting with `## Summary`, then the format in
`docs/templates/test-plan.md` "Results". Edit nothing in the repo.
