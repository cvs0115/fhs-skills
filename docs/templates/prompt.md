# Agent task · <plan-name> · <build | research | test>

> **For the coding agent (Grok 4.7 High in cursor-agent).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan by GPT-5.6 (`docs/reviews/<plan-name>.md`: APPROVE).
> Hand-off (see docs/RUNBOOK.md): start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model grok-4.7-high --force --workspace /srv/fhs-build/<name>`
> and tell it "Do the task in docs/prompts/<plan-name>.md".

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). <One paragraph: what this task is for, in plain words.>

## Where you work

- Workspace: `/srv/fhs-build/<name>`, your own clone of the repo. Work only here.
- Branch: create `feat/<name>` from the current `main` in this clone before your first edit.
- You run as user `fhsbuild`. You can't reach `/root`, and you shouldn't try.

## Read first

1. `CLAUDE.md` (the repo rules)
2. `docs/plans/<plan-name>.md` (the approved plan. If this file and the plan disagree, stop and report it.)
3. <other files>

## Steps

1. <exact file, exact behavior>

## You may edit only

- `<path>`

## You must not

- Edit any file not listed above, or anything under `skills/`, `shared/`, `docs/plans/`, `docs/reviews/` or `docs/prompts/`.
- Push, merge, or commit to `main`.
- Log in to anything, type a password, or open Toast, R365 or ADP.
- Install packages or change system settings, unless a step says so.

## Tests (run every one, record the real output)

1. `<command>` → expect `<result>`

## When done

1. Commit on `feat/<name>`. End the message with `Co-Authored-By: Grok 4.7 High (cursor-agent)`.
2. Write your report to `/srv/fhs-build/reports/<name>.md` (outside the repo):

```text
Task: <plan-name> · Branch: feat/<name> · Commits: <hashes>
Files changed: <list>
Tests: <n>/<n> passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
