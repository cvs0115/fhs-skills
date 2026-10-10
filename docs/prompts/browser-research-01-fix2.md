# Agent task · browser-research-01 · fix round 2 (research)

> **For the research agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** A fix round on `feat/browser-research-01`, under the
> approved plan `docs/plans/browser-research-01.md`. Hand-off: "Do the task in /srv/fhs-build/reports/browser-research-01-fix2.md".

## Context

The GPT-5.6 diff review `docs/reviews/browser-research-01-diff-r1.md` (on main) found these content issues. Its process issue,
the test-plan corrections, has been fixed in the plan by the planner.

## Where you work

`/srv/fhs-build/browser-research-01`, the existing branch `feat/browser-research-01` (at `1fe6d98`).

## Steps

1. **`skills/fhs-skills/references/tech-stack.md`, the contradiction.** Your section says every client launches its own browser
   unless `--shared-browser-context` is set, while the note says `--isolated` shares one browser with separate contexts. Re-read the
   real `npx --yes @playwright/mcp@0.0.83 --help` output and the package source, and make **both** files say the same, sourced thing:
   what happens by default, with `--isolated`, and with `--shared-browser-context`, for two HTTP clients.
2. **Section 7, a concrete topology.** Replace the one-unit sketch with a runnable topology (text only, not installed): one systemd unit
   per long-running process (Xvfb, x11vnc, websockify/noVNC, Playwright MCP). For each: `User=`, `ExecStart=` with the exact command
   and flags (bound to `127.0.0.1`), `After=`/`Requires=` ordering, `Restart=`, and the hardening options from your earlier section,
   with the LXC caveats. Update the Summary to match.
3. **Commit trailer.** Make your commit message **end** with exactly `Co-Authored-By: Grok 4.7 High (cursor-agent)`, with no other
   trailer after it.

## You may edit only

- `docs/research/browser-stack.md`, `skills/fhs-skills/references/tech-stack.md` (your one research section only)

## You must not

- Start, install, or enable anything. Use sudo. Edit any other file. Rewrite earlier commits.

## Tests

1. `git diff --name-only main...HEAD` → only the two files above
2. `git log -1 --format=%B | tail -1` → `Co-Authored-By: Grok 4.7 High (cursor-agent)`
3. `grep -c 'ExecStart=' docs/research/browser-stack.md` → at least 4
4. `git status --short` → empty

## When done

Commit `research: reconcile browser-sharing flags, concrete unit topology`. Append a "Fix round 2" section to
`/srv/fhs-build/reports/browser-research-01.md`.
