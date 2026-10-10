# Agent task · browser-research-01 · fix round 1 (research)

> **For the research agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** This is a fix round on the same branch, under
> the approved plan `docs/plans/browser-research-01.md`. Hand-off: "Do the task in /srv/fhs-build/reports/browser-research-01-fix1.md".

## Context

The tester (`/srv/fhs-build/reports/browser-research-01-test.md`) found two gaps in `docs/research/browser-stack.md`:
- **T2:** section 4 says a second CDP client can drive the same browser, marked "Not tried here", with no source and no `(?)`.
- **T6b:** the ADP sign-in page source contains `http://www.w3.org` (an `xmlns` SVG namespace). The allow-list neither includes nor explains it.

## Where you work

`/srv/fhs-build/browser-research-01`, the existing branch `feat/browser-research-01`.

## Steps

1. Section 4: either give a source for the second-CDP-client claim (a doc URL, or Playwright/Chromium source with path and line), or
   mark it `(?)` with what would confirm it. Don't start a browser to test it.
2. Section 8 (sites): add one line saying namespace and identifier URIs found in page source (e.g. `www.w3.org` in `xmlns=`) aren't
   hosts the page loads, so they stay off the allow-list. Re-run the T6b extraction for the 3 URLs, and list every host in it as
   either allow-listed or explained.
3. Add a short "Finding for the build plan" line in the Summary: the Cursor agent itself starts `@playwright/mcp` and
   `chrome-devtools-mcp` as child processes, as observed by the tester's T11. Cite the tester report.

## You may edit only

- `docs/research/browser-stack.md`

## You must not

- Edit anything else, start a browser or listener, install packages, or use sudo.

## Tests

1. `git diff --name-only HEAD~1..HEAD` → only `docs/research/browser-stack.md`
2. `grep -c '(?)' docs/research/browser-stack.md` → at least the previous count (the claim is now sourced or marked)
3. `git status --short` → empty

## When done

Commit `research: source or mark the CDP claim, explain namespace URIs, note Cursor's own MCP children` with
`Co-Authored-By: Grok 4.7 High (cursor-agent)` (same one-shot author as before). Append a "Fix round 1" section to
`/srv/fhs-build/reports/browser-research-01.md`.
