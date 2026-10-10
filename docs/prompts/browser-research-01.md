# Agent task · browser-research-01 · research

> **For the coding agent (Grok 4.7 High in cursor-agent).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan by GPT-5.6 (`docs/reviews/browser-research-01.md` must say APPROVE).
> Hand-off: the owner tells you "Do the task in docs/prompts/browser-research-01.md".

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN). The server (Ubuntu, an LXC container named dev-lxc-1) needs one browser that:
the owner can watch and sign in to from their PC through an SSH tunnel; Claude Code and cursor-agent
can both drive through Playwright MCP; keeps logins across restarts; doesn't run as root; and
listens only on localhost. **This task is research only.** You find out how, test what you safely
can without installing anything system-wide, and write it down. Someone else writes the build plan from your note.

## Where you work

- Workspace: `/srv/fhs-build/browser-research-01`, your own clone. Before editing: `git checkout -b feat/browser-research-01`
- First, save a baseline: `{ ss -ltn; echo ---; dpkg -l | awk '{print $2}'; echo ---; ls ~/.cache/ms-playwright 2>&1; } > /srv/fhs-build/reports/browser-research-01-before.txt`
- You run as user `fhsbuild` (no sudo). You may use `npx --yes <pkg> --help`, which downloads into
  your own `~/.npm`. Nothing may be left running when you finish.

## Read first

1. `CLAUDE.md` · 2. `docs/plans/browser-research-01.md` · 3. `docs/specs/browser.md`
4. `docs/research/access-browser-windows.md` (what is already known) · 5. `docs/reviews/browser-01-r1.md` (why the first design was rejected)

## Questions to answer (one section each in your note)

1. **Playwright MCP.** Exact npm package name and current version. From its real `--help` output
   (paste it): the flags for an HTTP/SSE listening port and host, a persistent user-data directory,
   headed vs headless, a browser executable path, and allowed/blocked origins. Does one server
   process accept two MCP clients at once, and does it share one browser between them? (Cite docs
   or source code.) The exact version to pin.
2. **Browser binary.** Which Chromium build Playwright uses, where it installs per user, its size,
   and the system libraries it needs (`npx playwright install --dry-run chromium` or its docs).
   Which of those libraries are missing on this host (`ldconfig -p` / `dpkg -l`, read only).
3. **Sandbox in LXC.** Can Chromium's sandbox work here as a non-root user? Check read-only:
   `/proc/self/status` (NoNewPrivs, Seccomp), `/proc/sys/kernel/unprivileged_userns_clone` if present,
   `cat /proc/1/environ` is not allowed, so skip it. Say what each value means for `--no-sandbox`, with sources.
4. **Owner viewer.** Packages for Xvfb + x11vnc + noVNC/websockify on this Ubuntu version
   (`lsb_release -a`, `apt-cache policy <pkg>`, read only): names, versions, sizes. How to bind
   x11vnc and websockify to 127.0.0.1 only, and set a VNC password from a file. Any lighter
   alternative (e.g. a Chromium remote-debugging viewer) with trade-offs.
5. **MCP registration.** The exact way to register an HTTP MCP server in Claude Code (a `claude mcp add`
   form for user scope) and in cursor-agent (`~/.cursor/mcp.json` shape). Cite docs or `--help` output.
6. **Locking.** Is there any built-in way to make Playwright MCP refuse a second client while one is
   active (a flag or a single-client mode)? If not, list two ways to enforce it at the access path
   (e.g. a localhost proxy that allows one session) with their trade-offs. Don't build either.
7. **Running unprivileged.** A systemd unit sketch (text only, in the note) that runs the browser and
   MCP as a dedicated user, with hardening options (`ProtectSystem`, `ProtectHome`, `NoNewPrivileges`,
   `PrivateTmp`, `ReadWritePaths` for the profile). Note which options may not work inside LXC, with sources.
8. **Sites.** For `fhs4021089.restaurant365.com`, `www.toasttab.com` and `online.adp.com`: which other
   domains the login pages load or redirect to (from public page source with `curl -sI` / `curl -s`, no login).
   This is the starting allow-list.

## You may edit only

- `skills/fhs-skills/references/tech-stack.md`: append one section `## Server browser (research <today>)`, with one line per
  **confirmed** fact and a pointer to the note's section. Change nothing else in that file.
- Your report `/srv/fhs-build/reports/browser-research-01.md` and the baseline `browser-research-01-before.txt` next to it (outside the repo).
- `docs/research/browser-stack.md` (new). Start it with the header line
  `# Research · browser · Server browser stack` and the date, then sections 1–8, then "Summary: recommended stack, pinned versions, open `(?)` items".

## You must not

- Install apt packages, use sudo, start long-running processes, open ports, or edit any other file.
- Visit any page that needs a login, or submit any form.
- Guess. Every claim gets a source: the command plus its real output, or a URL. Unconfirmed → `(?)` and what would confirm it.

## Tests (run every one, record the real output)

1. `grep -c '^## ' docs/research/browser-stack.md` → at least 9 (sections 1–8 + Summary)
2. `git diff --name-only main...HEAD` → only `docs/research/browser-stack.md` and `skills/fhs-skills/references/tech-stack.md`
3. `{ ss -ltn; echo ---; dpkg -l | awk '{print $2}'; echo ---; ls ~/.cache/ms-playwright 2>&1; } | diff /srv/fhs-build/reports/browser-research-01-before.txt -` → no differences
4. `pgrep -u fhsbuild -af 'playwright|chrom|Xvfb|x11vnc|websockify|mcp'` → no output
5. `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md` → only added lines, all in the one new section

## When done

1. Commit on `feat/browser-research-01`, ending the message with `Co-Authored-By: Grok 4.7 High (cursor-agent)`.
2. Write your report to `/srv/fhs-build/reports/browser-research-01.md`:

```text
Task: browser-research-01 · Branch: feat/browser-research-01 · Commits: <hashes>
Files changed: <list>
Tests: <n>/5 passed. For each: command, trimmed output, pass/fail
Open (?) items: <list>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
