# Agent task · framework-setup-03 · build

> **For the coding agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** This file is your whole assignment.
> Approved plan: `docs/plans/framework-setup-03.md` (read it; if this file and the plan disagree, stop and report it).
> Hand-off: "Do the task in docs/prompts/framework-setup-03.md".

## Context

fhs-skills is a repo of Claude skills for a Firehouse Subs owner's back office. Its review script `scripts/review.sh` currently
uses GPT-5.6 for every review. The owner chose: plans (written by Claude) are reviewed by `grok-4.7-xhigh`; code diffs (written by
Grok) are reviewed by `claude-sonnet-5-thinking-high`. The reviewer is never the writer's model family.

## Where you work

`/srv/fhs-build/framework-setup-03`, user `fhsbuild`. First: `git checkout -b feat/framework-setup-03`.

## Read first

`CLAUDE.md`, `docs/plans/framework-setup-03.md`, `scripts/review.sh`, `scripts/lib/guards.sh`, `scripts/tests/test_framework.sh`, `docs/RUNBOOK.md`.

## Steps

Do exactly what the plan's "Files the builder may edit" section says, file by file. Keep every other behavior of `review.sh` unchanged
(arguments, worktree safety, report checks, output file names, `--check-only`, verdict printing).

## You may edit only

`scripts/lib/guards.sh`, `scripts/review.sh`, `scripts/tests/test_framework.sh`, `CLAUDE.md` (Roles reviewer row and loop step 4 only),
`docs/RUNBOOK.md` (Reviewer row and the "Why … reviews" paragraph only), `docs/templates/review.md` (model hint only, if it names GPT).

## You must not

Edit anything else. Run `review.sh` without `--check-only`, or call cursor-agent / agent yourself. Push, merge, use sudo, change git config.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS, `exit=0`
2. `bash -n scripts/review.sh scripts/lib/guards.sh scripts/tests/test_framework.sh` → no output
3. `grep -c 'gpt-5.6' scripts/review.sh scripts/lib/guards.sh` → `0` for both
4. `git diff --name-only main...HEAD` → only allowed files
5. `git diff --check main...HEAD` and `git status --short` → no output

## When done

Commit (one-shot author as in earlier rounds: `git -c user.name="Surati" -c user.email="chirag.surati.78@gmail.com" commit ...`) with
the message ending in `Co-Authored-By: Grok 4.7 High (cursor-agent)` as the last line. Write `/srv/fhs-build/reports/framework-setup-03.md`:

```text
Task: framework-setup-03 · Branch: feat/framework-setup-03 · Commits: <hashes>
Files changed: <list>
Tests: <n>/5 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list or none>
```

If a step can't be done exactly as written, stop, report why, and don't work around it.
