# Ops task · ops-00 · Finish planning: review framework-setup-02, then commit the planning docs

> **For the Ops agent (Grok 4.7 High in cursor-agent, running as root, WITHOUT `--force`).** The owner
> approves every command you run. Show each command before you run it. This file is your whole
> assignment. You don't see the planner's conversation.
> Start: `agent --model grok-4.7-high --workspace /root/fhs-skills`, then tell it "Do the task in docs/prompts/ops-00-finish-planning.md".

## Context

`/root/fhs-skills` is the master repo of Claude skills for a Firehouse Subs owner's back office. Its `main`
checkout is **live**: server Claude sessions load `skills/` from it through symlinks. Claude (the planner) has
written plans, task files and test plans under `docs/`, still uncommitted. One plan, `framework-setup-02`,
still needs its GPT-5.6 review. You run that review. If it passes, you commit the planning docs.

## Read first

`CLAUDE.md`, then `docs/RUNBOOK.md` (you are row 1).

## Steps

1. Check the starting state:
   `cd /root/fhs-skills && git branch --show-current && git status --short | grep -v '^??' ; git status --short | grep -c '^??'`
   Expect: branch `main`, the only tracked change is ` M docs/specs/framework-setup.md`, and some untracked files (all under `docs/`).
   If anything outside `docs/` shows up, stop and report it.
2. Remove the stray file from an interrupted review: `rm -f docs/reviews/framework-setup-02.md.tmp`
3. Run the review (about 2 minutes, read-only, GPT-5.6 through cursor-agent):
   `./scripts/review.sh docs/plans/framework-setup-02.md`
   It writes `docs/reviews/framework-setup-02.md` and prints a verdict.
4. Read the verdict line: `sed -n '/^## Verdict/,/^## /p' docs/reviews/framework-setup-02.md | head -5`
   - **APPROVE** → go to step 5.
   - **APPROVE AFTER FIXES** or **REJECT** → don't commit anything. Write the report (below) with the review path, and stop.
     The owner sends it to Claude, who fixes the plan. Before the next run, rename the review:
     `mv docs/reviews/framework-setup-02.md docs/reviews/framework-setup-02-r7.md` (next time `-r8`, and so on).
5. Secret check over everything you're about to commit (expect no output):
   `grep -rnIE '(api[_-]?key|secret|token|password)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_/+-]{12,}' docs/ || true`
   If it prints anything, stop and report the lines.
6. Stage only `docs/`, never a `.tmp`:
   `git add docs/ && git reset -q -- $(git diff --cached --name-only | grep '\.tmp$') 2>/dev/null; git diff --cached --name-only | grep -v '^docs/' ; git diff --cached --name-only | grep -c '\.tmp$'`
   Expect: no lines outside `docs/`, and a `.tmp` count of `0`.
7. Commit:
   ```
   git commit -m "Plans, task files and test plans: framework-setup-02, browser and windows research, runbook

   Written by Claude (planner); framework-setup-02 reviewed APPROVE by GPT-5.6 (docs/reviews/framework-setup-02.md).

   Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
   Co-Authored-By: Grok 4.7 High (cursor-agent, ops)"
   ```
8. Check: `git status --short` → empty. `git log --oneline -1` → your commit, on `main`.
   `ls -l /root/.claude/skills/` → `fhs-payroll-adp` and `fhs-skills` still point into `/root/fhs-skills/skills/`.

## You must not

- Edit any file's content. You only delete the one `.tmp`, run the review, stage, and commit.
- Touch anything outside `docs/` in the commit. Push anywhere (there's no remote). Use `--force` anything.
- Fix a plan yourself if the review isn't APPROVE.

## Report

Write `/root/fhs-skills-ops-00.md` (outside the repo; `/srv/fhs-build` doesn't exist yet):

```text
Ops: ops-00 · Date: <date>
Review verdict: <APPROVE | APPROVE AFTER FIXES | REJECT> · Review file: docs/reviews/framework-setup-02[-rN].md
Commit: <hash or "none">
Checks: step 1 <ok/issue> · step 5 <clean/lines> · step 6 <ok/issue> · step 8 <ok/issue>
Next: <"RUNBOOK row 2" or "send the review to Claude">
```
