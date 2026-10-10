# Agent task · browser-research-01 · fix round 3 (research)

> **For the research agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** A fix round on `feat/browser-research-01` (at `a1643e8`), under the
> approved plan `docs/plans/browser-research-01.md`. Hand-off: "Do the task in /srv/fhs-build/reports/browser-research-01-fix3.md".

## Context

Review `docs/reviews/browser-research-01-diff-r2.md` (APPROVE AFTER FIXES):
1. The note, its Summary, and your `tech-stack.md` section say Playwright MCP adds `--no-sandbox` unless `--sandbox` is passed. The
   tester found (from the 0.0.83 source) that this is true only for `--browser chromium` / Chrome for Testing. With no `--browser`,
   `validateBrowserConfig` uses channel `chrome` with `chromiumSandbox` on.
2. Your branch was cut from an older `main`, before the planner amended and re-approved the plan and test plan. The Ops agent has updated
   your clone's `main` to the current one.

## Where you work

`/srv/fhs-build/browser-research-01`, the existing branch `feat/browser-research-01`.

## Steps

1. `git merge --no-edit main` into `feat/browser-research-01`, using the same one-shot author as before (`git -c user.name=... -c user.email=...`).
   There should be no conflicts. Your two files aren't touched on `main`. If there is a conflict, stop and report it.
2. Correct the sandbox statement in all three places (note body, note Summary, your `tech-stack.md` section). Scope it: what happens with
   no `--browser`, with `--browser chromium`, and with `--sandbox`. Cite the 0.0.83 bundle (`validateBrowserConfig`, and the file and line from
   the unpacked package) as the source. Re-read the real code. Don't guess.

## You may edit only

- `docs/research/browser-stack.md`, `skills/fhs-skills/references/tech-stack.md` (your one section only); plus the merge commit itself

## You must not

- Start, install, or enable anything. Use sudo. Rewrite earlier commits. Edit any other file.

## Tests

1. `git diff --name-only main...HEAD` → only the two files above
2. `grep -n -- '--no-sandbox' docs/research/browser-stack.md skills/fhs-skills/references/tech-stack.md` → every hit is scoped to `--browser chromium`
3. `git log -1 --format=%B | tail -1` → `Co-Authored-By: Grok 4.7 High (cursor-agent)`
4. `git status --short` → empty

## When done

Commit `research: scope the sandbox default to --browser chromium` with that trailer as the last line. Append a "Fix round 3" section to
`/srv/fhs-build/reports/browser-research-01.md`.
