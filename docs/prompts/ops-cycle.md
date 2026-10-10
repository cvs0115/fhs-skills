# Ops task · ops-cycle · Take one approved plan from clone to merge

> **For the Ops agent (Grok 4.7 High via `agent`, running as root, WITHOUT `--force`).** The owner approves
> every command you run. Show each command before you run it. This file is your whole assignment.
> Start: `agent --model grok-4.7-high --workspace /root/fhs-skills`, then tell it
> "Do the task in docs/prompts/ops-cycle.md for plan <PLAN>" (e.g. `framework-setup-02`).

## Context

`/root/fhs-skills` is the master repo. Its `main` checkout is **live**: server Claude sessions load `skills/`
from it. Builder and tester agents (Grok) run as the locked-down user `fhsbuild` in their own clone under
`/srv/fhs-build/`. They can't touch `/root`. You do the root-side steps around them: prepare the clone,
collect the branch, run the GPT-5.6 reviews, run any root-only test cases, and merge. **No code written by a
builder runs as root until a diff review of it is APPROVE** (section D before E).

Set at the start, and reuse: `PLAN=<plan name>` and `NAME=$PLAN` (the clone and branch name; `feat/$NAME`).
`R=/root/fhs-skills` · `B=/srv/fhs-build` · `AGENT=/srv/fhs-build/.local/bin/agent`

## Read first

`CLAUDE.md`, `docs/RUNBOOK.md`, `docs/plans/$PLAN.md` (especially "Sequence" if it has one), `docs/tests/$PLAN.md`.

## Stop rule (applies to every section)

Any of these means stop: a verdict that isn't APPROVE, a test FAIL, an expected output that doesn't match, or
anything touching `$R/skills` before G. Write `$B/reports/$NAME-ops.md` (the format at the bottom) and tell the
owner to send it to Claude. Don't fix code, plans or tests yourself.

## A · Prepare the clone

1. Gate: on `main`, the plan, task file, test plan and review are committed, and the review is APPROVE:
   ```
   cd $R && git status --short && for f in docs/plans docs/prompts docs/tests docs/reviews; do git cat-file -e main:$f/$PLAN.md && echo "ok $f"; done
   git show main:docs/reviews/$PLAN.md | sed -n '/^## Verdict/,/^## /p' | sed -n '3p'
   ```
   Expect: status empty, four `ok` lines, and a verdict line starting `APPROVE.` (not `APPROVE AFTER FIXES`).
2. Refuse if it already exists: `test -e $B/$NAME && echo EXISTS; git -C $R rev-parse --verify -q feat/$NAME && echo BRANCH-EXISTS` → no output.
3. If `$R/scripts/build.sh` exists on `main` (after framework-setup-02 is merged):
   `$R/scripts/build.sh prepare docs/plans/$PLAN.md $NAME` and skip to B.
   Otherwise (framework-setup-02 itself), do it by hand:
   ```
   git clone --no-hardlinks --branch main $R $B/$NAME
   chown -R fhsbuild:fhsbuild $B/$NAME
   sudo -u fhsbuild git -C $B/$NAME log --oneline -1
   ```
   Expect: the same hash as `git -C $R rev-parse --short main`.

## B · Hand-offs for the owner (you don't run the agents)

Tell the owner, word for word, and wait for each one to finish:
1. **Builder:** run `sudo -u fhsbuild -H $AGENT --model grok-4.7-high --force --workspace $B/$NAME`
   and tell it: `Do the task in docs/prompts/$PLAN.md`
   Done when `$B/reports/$NAME.md` exists. Check: `cat $B/reports/$NAME.md`. Stop if it reports failed tests or "stopped".
2. **Tester (a new session, not the builder's):** run the same command again, and tell it:
   `Run the test plan in docs/tests/$PLAN.md`
   Done when `$B/reports/$NAME-test.md` exists. If the test plan has `ops` rows, they'll be BLOCKED (ops) for now. That's expected.
   Stop if any non-ops row is FAIL or BLOCKED.

## C · Collect the branch (plain fetch, no branch code runs)

```
git -C $R -c safe.directory=$B/$NAME fetch $B/$NAME feat/$NAME:feat/$NAME
git -C $R log --oneline main..feat/$NAME
git -C $R diff --name-only main...feat/$NAME
```
Check the file list against the plan's "Files the builder may edit". Stop on anything extra.

## D · Code review gate (GPT-5.6, using the trusted `review.sh` already on `main`)

Pick the next free review number N (`-diff-r1` first, then `-diff-r2`…): `ls $R/docs/reviews/ | grep "^$NAME-diff"`.

- If `main` has the new review.sh (it has `--check-only`: `grep -q -- '--check-only' $R/scripts/review.sh && echo NEW`):
  `cd $R && scripts/review.sh --diff feat/$NAME` → writes `docs/reviews/$NAME-diff.md`.
- Otherwise (old review.sh), it must run from inside a checkout of the branch:
  ```
  git -C $R worktree add --detach /root/fhs-skills-wt/review-$NAME feat/$NAME
  cd /root/fhs-skills-wt/review-$NAME && $R/scripts/review.sh --diff feat/$NAME
  cp docs/reviews/$NAME-diff.md $R/docs/reviews/$NAME-diff.md
  cd $R && git worktree remove --force /root/fhs-skills-wt/review-$NAME
  ```
  Tell the reviewer nothing extra. It reads the plan, which names the two report paths.

Then keep it and commit it (docs only):
```
cd $R && mv docs/reviews/$NAME-diff.md docs/reviews/$NAME-diff-rN.md
git add docs/reviews/$NAME-diff-rN.md && git commit -m "Diff review rN for $NAME

Co-Authored-By: Grok 4.7 High (agent, ops)"
sed -n '/^## Verdict/,/^## /p' docs/reviews/$NAME-diff-rN.md | sed -n '3p'
```
Not APPROVE → stop (the stop rule). The builder fixes it in a new round, starting again at B.1 with the same clone.

## E · Root-only test cases (only after D is APPROVE)

If `docs/tests/$PLAN.md` has rows with Env `ops`, run exactly those commands now, in order, with the owner
approving each one. Copy each output verbatim to the owner, who pastes it to the tester session ("Here is the ops
output for T16…"). The tester updates `$B/reports/$NAME-test.md` to final.
**framework-setup-02 only:**
- The rows need a root worktree of the reviewed branch:
  `git -C $R worktree add --detach /root/fhs-skills-wt/fs02-run feat/framework-setup-02`.
- T18 needs the fixture branch: `git -C $R worktree add -b zz-buildtest /root/fhs-skills-wt/zz-base main`, then copy the
  files listed in `docs/fixtures/zz-buildtest/README.md` to their paths in that worktree, and commit them there.
- Run T18 and T19 exactly as written in the test plan.
- Remove `fs02-run` when done.
Then check: `cat $B/reports/$NAME-test.md | grep -E '^Verdict'` → `ALL PASS`.

## F · Final review

Only if E ran or the branch changed after D. Repeat D, with the next N. Then use the branch's own `review.sh`,
since it was approved in D: run it from the `fs02-run`-style worktree, or from `$R` once it's merged. It must be APPROVE.
If E didn't run and the branch didn't change, D's APPROVE is the final review.

## G · Merge

```
cd $R && git status --short                      # expect empty
git merge --no-ff feat/$NAME -m "Merge $NAME (reviewed: docs/reviews/$NAME-diff-rN.md; tests: ALL PASS)

Co-Authored-By: Grok 4.7 High (agent, builder)"
git status --short                               # expect empty
ls -l /root/.claude/skills/                      # both fhs-* links resolve into $R/skills
python3 -m py_compile skills/*/scripts/*.py && echo COMPILE-OK
```

## H · Clean up

```
git -C $R branch -d feat/$NAME
rm -rf $B/$NAME
git -C $R worktree list                          # no review-*, fs02-run or zz-base entries left
```
Reports in `$B/reports/` stay.

## You must not

- Run anything as `fhsbuild` except the commands written here. Start builder or tester agents yourself (the owner does).
- Edit code, plans, tests or reviews. Merge without D (and F if needed) APPROVE and the tests at ALL PASS.
- Push anywhere, force anything, or touch the Windows copy, Dropbox, Toast, R365 or ADP.

## Report

Write `$B/reports/$NAME-ops.md`:

```text
Ops: ops-cycle · Plan: <PLAN> · Date: <date>
A prepare: <ok/issue> · B builder report: <ok/issue> · B tester report: <ok/issue>
C files: <list> · D review: <file> <verdict> · E ops cases: <ids + PASS/FAIL or n/a>
F review: <file> <verdict or n/a> · G merge: <hash> · H cleanup: <ok>
Next: <RUNBOOK row n | send to Claude: reason>
```
