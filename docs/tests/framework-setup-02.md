# Test plan · framework-setup-02

> **For the tester agent (Grok 4.7 High in cursor-agent, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/framework-setup-02.md".

## What's being tested

The build tooling: `scripts/lib/verdict.sh` reads review verdicts correctly; `scripts/build.sh`
refuses to prepare a build without an APPROVE'd plan, task file and test plan, refuses bad input,
and needs root for real work; `scripts/review.sh` accepts only the GPT-5.6 Sol reviewer and cleans
up its temporary worktree; the builder user can't touch the live repo; `CLAUDE.md` describes the
new roles. You test independently of the builder's own test script (T1 runs it, the rest don't rely on it).

Plan: `docs/plans/framework-setup-02.md` · Builder report: `/srv/fhs-build/reports/framework-setup-02.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/framework-setup-02` on `feat/framework-setup-02`, as `fhsbuild` | run commands; temp files only under `mktemp -d`; edit nothing in the repo |
| ops | root on the server, run by the Ops agent (owner approves each command) | the owner pastes you its output; you judge it |

No browser cases: this change has no web page or site interaction.

## Preconditions

- The builder report exists and says 5/5 tests passed.
- `git -C /srv/fhs-build/framework-setup-02 branch --show-current` → `feat/framework-setup-02`
- Set `W=/srv/fhs-build/framework-setup-02` and `TMP=$(mktemp -d -t fs02test-XXXX)`. Delete `$TMP` at the end.

## Pre-merge cases (the merge gate)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `cd $W && bash scripts/tests/test_framework.sh; echo exit=$?` | every line `PASS`, `exit=0` | full output |
| T2 | shell | `for f in framework-setup-01-r1 framework-setup-diff-r1 browser-01-r1 framework-setup-02; do echo "$f: $(bash scripts/lib/verdict.sh docs/reviews/$f.md)"; done` | `APPROVE AFTER FIXES`, `APPROVE AFTER FIXES`, `REJECT`, `APPROVE` (real committed reviews) | output |
| T3 | shell | Write `$TMP/a.md` containing `## Verdict`, an empty line, `REJECT. x`, then a second `## Verdict` followed by `APPROVE. y`. Run `bash scripts/lib/verdict.sh $TMP/a.md` | `REJECT` (the first Verdict section wins) | file + output |
| T4 | shell | Write `$TMP/b.md` with `## Verdict` and then only blank lines. Run verdict on it, and on `$TMP/missing.md` | `NONE` and `NONE`, both exit 0 | output + `echo $?` |
| T5 | shell | `FHS_REPO=$W FHS_BUILD_ROOT=$TMP/br bash scripts/build.sh prepare docs/plans/framework-setup-02.md fs02-check --check-only; echo exit=$?` | `OK: ready to prepare fs02-check from main`, `exit=0` (main holds this plan's plan, task, test plan and APPROVE review) | output |
| T6 | shell | Same as T5 but with `docs/plans/browser-01.md` and name `b01-check` | `exit=3`, and names the first missing required file (`build.sh` checks plan → task file → test plan → review in that order; for `browser-01` the task file is missing first). Corrected 2026-10-10: the original expectation ("names the review") contradicted the task file's check order | output |
| T7 | shell | Same as T5 but with name `Bad_Name` | `exit=2` | output |
| T8 | shell | `FHS_REPO=$W FHS_BUILD_ROOT=$TMP/br bash scripts/build.sh prepare docs/plans/framework-setup-02.md fs02-real; echo exit=$?; ls $TMP/br 2>&1` | `exit=5` (not root), no `fs02-real` directory | output |
| T9 | shell | `FHS_BUILD_ROOT=$TMP/br bash scripts/build.sh collect nothing-here; echo exit=$?` | `exit=3` | output |
| T10 | shell | `for m in grok-4.7-high claude-x gpt-5.6-sol-xhigh; do REVIEW_MODEL=$m FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-02.md; echo "$m exit=$?"; done; FHS_REPO=$W bash scripts/review.sh --check-only docs/plans/framework-setup-02.md; echo "default exit=$?"` | the three overrides `exit=2`; default `exit=0` | output |
| T11 | shell | `touch /root/fhs-skills/x; echo exit=$?; ls /root; echo exit=$?` | both fail with `Permission denied` (non-zero exit) | output |
| T12 | shell | `bash scripts/build.sh; echo exit=$?` and `bash scripts/build.sh frobnicate; echo exit=$?` | usage text, `exit=2` both times | output |
| T13 | shell | `wc -l < CLAUDE.md`; `grep -n '^## Roles' CLAUDE.md`; `grep -c 'docs/prompts/' CLAUDE.md`; `grep -c 'docs/tests/' CLAUDE.md`; `grep -n '^## Subagents' CLAUDE.md` | under 200; Roles found; both counts ≥ 1; no Subagents section | output |
| T14 | shell | `git diff --name-only main...HEAD` | only: `scripts/lib/verdict.sh`, `scripts/lib/guards.sh`, `scripts/build.sh`, `scripts/review.sh`, `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/*`, `CLAUDE.md`, `README.md` | output |
| T15 | shell | `git status --short` and `git log --format='%h %s%n%b' main..HEAD \| grep -c 'Co-Authored-By: Grok'` | status empty; count ≥ 1 | output |
| T16 | ops | After the real diff review: `git -C /root/fhs-skills worktree list` | no `review-*` entry | pasted output |
| T17 | ops | Forced failure, with both reports present: `PATH=/usr/bin:/bin /root/fhs-skills-wt/fs02-run/scripts/review.sh --diff feat/framework-setup-02; echo exit=$?; git -C /root/fhs-skills worktree list; ls /root/fhs-skills/docs/reviews/*.tmp 2>&1` | non-zero exit (cursor-agent not found); no `review-*` worktree; no `.tmp` file | pasted output |
| T17b | ops | `mv` the tester report aside, run `/root/fhs-skills-wt/fs02-run/scripts/review.sh --diff feat/framework-setup-02; echo exit=$?`, then move it back | `exit=3`, says the tester report is missing; no worktree created | pasted output |

### End-to-end run (still pre-merge. The Ops agent runs these with the branch's scripts from `/root/fhs-skills-wt/fs02-run`, and you record them)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T18 | ops | The end-to-end zz-buildtest run from the plan's done-check 5 (`FHS_REPO=/root/fhs-skills /root/fhs-skills-wt/fs02-run/scripts/build.sh prepare ... --base zz-buildtest`, the owner starts Grok with the zz task, then `collect zz-buildtest`) | `git diff --stat zz-buildtest...feat/zz-buildtest` shows only `docs/zz-hello.md`; `/root/fhs-skills` status clean and `main` hash unchanged; report exists | pasted output |
| T19 | ops | The cleanup from done-check 5 | no `/srv/fhs-build/zz-buildtest`, no `zz-base` worktree, no `zz-buildtest` or `feat/zz-buildtest` branch, no zz report | pasted output |

All of T1–T19 are pre-merge and gate the merge. First write a provisional results file with T1–T15 and T16–T19 BLOCKED (ops).
The Ops agent runs T16–T19 only after the code review of the branch is APPROVE (plan, "Sequence" step 4), then pastes the output
to you, and you update the results file to final.

## Results

Write `/srv/fhs-build/reports/framework-setup-02-test.md`:

```text
Test plan: framework-setup-02 · Branch: feat/framework-setup-02 at <commit> · Tester: grok-4.7-high (fresh session)
| ID | Result | Evidence (trimmed output) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

Then `rm -rf "$TMP"` and confirm it's gone.

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge. Use sudo.
- Run `scripts/review.sh` without `--check-only`, or call cursor-agent yourself.
