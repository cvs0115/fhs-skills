# Plan · browser-research-01 · Research the server browser stack (read-only)

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/browser-research-01.md` holds an APPROVE.
The reviewer checks this plan and its task file `docs/prompts/browser-research-01.md` together.

- Hub project: `projects/server-move` · Spec: `docs/specs/browser.md`
- Replaces: `docs/plans/browser-01.md` (draft, REJECT in `docs/reviews/browser-01-r1.md`). The build plan is rewritten after this research.
- Decisions that bind it: hub log 2026-10-10 (server browser the owner can see; Claude plans, Grok builds and tests, GPT-5.6 reviews).
- Depends on: framework-setup-02 merged (the `fhsbuild` user and `build.sh` exist).

## Verdict

Build (a research note only, no code).

## What changes, in plain words

A Grok agent looks up and tests, without installing anything system-wide, how to run one browser
on the server that you can watch and sign in to, and that Claude and Grok can drive. It writes
its findings to one file. Claude then writes the real build plan from those findings.

## Files the builder may edit

- `docs/research/browser-stack.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: append one section `## Server browser (research 2026-10-xx)` with only the
  facts the note marks confirmed, each one line with a pointer to the note's section. Nothing else in the file changes.
- Outside the repo, only these files in `/srv/fhs-build/reports/`: `browser-research-01.md` (report), `browser-research-01-before.txt` (baseline: listeners, packages,
  browser cache), `browser-research-01-test.md` and `browser-research-01-test-before.txt` (the tester's).

## Files the builder must not edit

- Everything else, inside or outside the clone, except the files listed above. No changes outside its clone, apart from the npm cache in `fhsbuild`'s own home (`~/.npm`).

## Live systems touched

None that change anything. No apt installs, no services, no ports. Read-only, unauthenticated public HTTP requests to the
R365, Toast and ADP login pages (`curl -sI`/`curl -s`), to list the domains they load. `npx` package downloads to `fhsbuild`'s
own npm cache are allowed, to read `--help` output. They're run with `--yes`, and nothing is left running.

## Done-check (real outcome)

1. `docs/research/browser-stack.md` answers every question in the task file, each with its source:
   a command and its output, or a URL.
2. Every answer is either confirmed, or marked `(?)` with what's needed to confirm it.
3. `git diff --name-only main...feat/browser-research-01` shows only the note and `tech-stack.md`. The baseline taken at the start
   (listeners, installed packages, `~/.cache/ms-playwright`) matches the end state, and no fhsbuild process matches
   `playwright|chrom|Xvfb|x11vnc|websockify|mcp`.

## Test plan

`docs/tests/browser-research-01.md`, run by a fresh Grok session that didn't do the research. Every case must PASS before the merge.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. On merge, the new `tech-stack.md` section is visible to server sessions (reference text only).
- **Windows mirror:** unchanged. The new `tech-stack.md` section reaches Windows only through a mirror refresh, which is a separate owner OK.
- **Builder tree:** `/srv/fhs-build/browser-research-01`.

## Where the builder works

- Served-tree impact: on merge, `tech-stack.md` (a skill reference file) gains a section of confirmed facts. No skill behavior changes.
- `/srv/fhs-build/browser-research-01` · branch `feat/browser-research-01` · user `fhsbuild` · grok-4.7-high · started by the owner

## What stays

Everything. Browser work stays on Windows until a reviewed build plan ships.
