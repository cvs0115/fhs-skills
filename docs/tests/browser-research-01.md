# Test plan · browser-research-01

> **For the tester agent (Grok 4.7 High in cursor-agent, a fresh session, not the one that did the research).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/browser-research-01.md".

## What's being tested

That the research note `docs/research/browser-stack.md` is complete and true: every question from
`docs/prompts/browser-research-01.md` is answered with a source, and the claims you can re-check
hold when you re-run them. Also that the research left nothing running or installed. The browser
itself is tested later, in the build plan's test plan (with Playwright on the server, or Chrome on the Windows PC as the fallback).

Plan: `docs/plans/browser-research-01.md` · Researcher report: `/srv/fhs-build/reports/browser-research-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/browser-research-01` on `feat/browser-research-01`, as `fhsbuild` | read the note; re-run its read-only commands; `npx --yes <pkg> --help` allowed; nothing left running |

No browser cases: nothing is built yet. Don't visit any page that needs a login.

## Preconditions

- The researcher report and `/srv/fhs-build/reports/browser-research-01-before.txt` exist. Save your own baseline the same way:
  `{ ss -ltn; echo ---; dpkg -l | awk '{print $2}'; echo ---; ls ~/.cache/ms-playwright 2>&1; } > /srv/fhs-build/reports/browser-research-01-test-before.txt`

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | List the `## ` headings of the note | sections for questions 1–8 and a Summary | output |
| T2 | shell | For each of the 8 sections, check that every claim has a source (a command with output, or a URL) or is marked `(?)` with what would confirm it | no unsourced claim; list any you find | per-section yes/no + quotes of unsourced lines |
| T3 | shell | Re-run the Playwright MCP `--help` with the exact package and version the note pins | the flags the note names (port/host, user-data dir, headed, executable path, origins) appear in the output | output excerpt per flag |
| T4 | shell | Re-run the note's sandbox checks (`/proc/self/status` lines, userns file) | same values as the note | output |
| T5 | shell | Re-run 3 of the note's `apt-cache policy` checks (x11vnc, novnc or websockify, xvfb) | the versions match the note | output |
| T6 | shell | Re-run the note's `curl -sI` for each of the 3 login URLs | the status and redirect hosts match the note's allow-list section | output |
| T6b | shell | For each of the 3 login URLs, follow the redirects and extract the hosts from the final page source: `curl -sL <url> \| grep -oE 'https?://[a-zA-Z0-9.-]+' \| sort -u` | every host here is in the note's allow-list, or the note explains why it's left out | output + any missing host |
| T7 | shell | Check the note's MCP-registration claims against the cited docs (open the URLs, read only) | the Claude Code and cursor-agent registration forms match the docs | URL + quoted line |
| T8 | shell | Check the Summary: does it name a pinned MCP version, a browser build, a viewer stack, a non-root plan, and an access-path lock option? | all five present | quotes |
| T9 | shell | `git status --short` (expect empty), `git diff --name-only main...HEAD`, and `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md` | only the note and `tech-stack.md`; the tech-stack diff is added lines only, in one new section, and each line matches a fact the note marks confirmed | output + any mismatch |
| T10 | shell | Compare the researcher's baseline with the current state: `{ ss -ltn; echo ---; dpkg -l \| awk '{print $2}'; echo ---; ls ~/.cache/ms-playwright 2>&1; } \| diff /srv/fhs-build/reports/browser-research-01-before.txt -` | the package list and `~/.cache/ms-playwright` sections show no difference. In the `ss` section, ignore root-owned localhost ports: other agents (Cursor workers) run in parallel and open them. Corrected 2026-10-10 | output |
| T11 | shell | At your end: the package and browser-cache parts of the same diff against your own `-test-before.txt`, and `pgrep -u fhsbuild -af 'playwright\|chrom\|Xvfb\|x11vnc\|websockify\|@playwright/mcp'` (Cursor's own built-in MCP helpers don't match this) | no package or cache difference; no output. Corrected 2026-10-10: the old pattern `mcp` matched Cursor's own processes | output |

## Results

Write `/srv/fhs-build/reports/browser-research-01-test.md`:

```text
Test plan: browser-research-01 · Branch: feat/browser-research-01 at <commit> · Tester: grok-4.7-high (fresh session)
| ID | Result | Evidence | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix the note. Install packages, use sudo, start services or listeners.
- Visit a page that needs a login, or submit any form.
