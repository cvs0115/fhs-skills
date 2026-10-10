# Plan · browser-01 · A browser on the server that the owner can see and agents can drive

> **DRAFT, superseded.** Don't build from this. Review r1 sent it back. The build plan gets rewritten after `docs/plans/browser-research-01.md` produces its research note. Kept for the record.

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/` holds an APPROVE for this file.

- Hub project: `projects/server-move` (server move plan https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG).
- Research: `docs/research/access-browser-windows.md`
- Decisions that bind it: hub log 2026-10-10 (server browser the owner can see; builders = grok-4.7-high).
  Owner rules: agents never type usernames or passwords, never click anything that moves money or
  submits, and every Toast/R365/ADP change needs a yes at the time (`skills/fhs-skills/SKILL.md`).

## Verdict

Build, in two stages. Stage A is research (read-only, no installs). Stage B is the install, which
needs the owner's OK for each package and service because it changes the server.

## What changes, in plain words

The server gets one Chromium browser on a virtual screen. You watch it and sign in through a web
page, reached over an SSH tunnel from your PC. Claude and the cursor-agents control that same
browser through a Playwright connection. Logins stay saved between restarts, so you only sign in
again when a site logs you out.

## Design

```
owner PC ──ssh -L 6080──▶ dev-lxc-1: noVNC :6080 (localhost only) ──▶ x11vnc ──▶ Xvfb :99
                                                                        │
Claude Code ─┐                                                   Chromium (headed, :99)
             ├─ MCP over HTTP (localhost:8931) ─▶ Playwright MCP ─────────┘
cursor-agent ┘                                    profile: /root/.fhs-browser/profile (0700, not in git)
```

- One browser, one profile, shared by every agent. Only one agent drives it at a time:
  `scripts/browser-lock.sh` takes a lock file with the holder's name, and agents check it before
  they use the browser (rule in CLAUDE.md).
- Everything listens on `127.0.0.1` only. The owner reaches noVNC with
  `ssh -L 6080:localhost:6080 dev-lxc-1`, then opens http://localhost:6080. No port is opened to
  the LAN or the internet. VNC has a password in `.env` (`FHS_VNC_PASSWORD`), filled in by the owner.
- Four systemd units: `fhs-xvfb`, `fhs-x11vnc`, `fhs-novnc`, `fhs-browser-mcp`. Each restarts on
  failure, and they start at boot only after the owner's OK.
- MCP is registered for Claude Code (user scope, `~/.claude.json`) and for cursor-agent
  (`~/.cursor/mcp.json`), both pointing at `http://127.0.0.1:8931/mcp` `(?)`.
- The profile holds live session cookies for Toast, R365 and ADP, so treat it like a secret:
  root-only, never copied, never in git, backups, logs or reports. A clean sign-out is
  `rm -rf /root/.fhs-browser/profile`, and only after the owner's OK.

## Stage A · research (read-only)

Write `docs/research/browser-stack.md` with sources:
1. Playwright MCP package name, version, and the flags for an HTTP port, a persistent profile, a
   headed display, and an allowed-origins list (from `npx @playwright/mcp@latest --help`, a
   read-only run).
2. Whether Chromium runs in this LXC as root without `--no-sandbox`. Check the container config
   (`/proc/self/status`, nesting) by reading only. If it needs `--no-sandbox`, record the risk:
   the browser then only visits the three allowed origins.
3. The apt packages needed (x11vnc, novnc, websockify, fonts) and their disk size.
4. How to register an HTTP MCP server in Claude Code and in cursor-agent (docs or `--help`).
5. The allowed origins: `*.toasttab.com`, `*.restaurant365.com`, `*.adp.com`, plus the login
   domains each one redirects to (seen during the first sign-in, and added to the list).

## Stage B · install (each item OK'd by the owner at the time)

## Files the builder may edit

- `scripts/browser/` (new): `install.sh` (prints each step and asks before running it),
  `fhs-*.service` unit files, `browser-lock.sh`, `status.sh` (units up? lock holder? profile age?)
- `docs/runbooks/browser.md` (new): how the owner connects, signs in, signs out, restarts, and what to do when a site asks for MFA
- `CLAUDE.md`: a "Browser" section (lock first; snapshot before you click; never type into password fields; owner rules apply)
- `skills/fhs-skills/references/tech-stack.md`, `skills/fhs-payroll-adp/references/browser-recipes.md`:
  the "browser pane" now means the server browser. **These are skill files**, so they go live on merge.
- `.env.example`: `FHS_VNC_PASSWORD=`; `.gitignore`: nothing new (the profile is outside the repo)

## Files the builder must not edit

- The served tree `/root/fhs-skills` directly; `shared/config.json`; `.env` (the owner fills it in)
- System files outside `/etc/systemd/system/fhs-*.service`, and only after the OK

## Live systems touched

- **The server:** apt packages, Chromium download (~150 MB `(?)`), four systemd units, two MCP
  registrations. Each is a separate OK. Rollback is in the runbook (disable the units, remove the
  packages, remove the MCP entries).
- **Toast, R365, ADP:** only what the owner does when signing in. Agents just open the login pages.

## Done-check (real outcome)

1. From the owner's PC: the tunnel plus http://localhost:6080 shows Chromium on the virtual screen (owner confirms).
2. `ss -ltnp` shows 6080, 5900 and 8931 bound to `127.0.0.1` only.
3. A Claude session calls the MCP: navigate to the Toast login URL (`memory/login-urls.md`) and
   take a snapshot. The page title matches what the owner sees in noVNC.
4. cursor-agent (grok-4.7-high, `--mode ask`) does the same through `~/.cursor/mcp.json`.
5. The owner signs in to R365 in noVNC. `systemctl restart fhs-browser-mcp`, then the agent opens
   the R365 home page still signed in.
6. While Claude holds the lock, a second agent that tries the browser is refused by `browser-lock.sh`.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`. The two reference files above go live for
  server sessions on merge, so merge only after done-checks 1–5 pass.
- **Windows mirror:** the reference wording changes there only on a mirror refresh (separate OK). Until
  then Windows payroll keeps using Claude in Chrome on the PC.
- **Live before merge:** the services may be running from the worktree's scripts, but no skill
  points at them yet.

## Where the builder works

- Worktree `/root/fhs-skills-wt/browser-01` · branch `feat/browser-01` · cut from `main` after
  framework-setup-02 merges · builder: grok-4.7-high via `scripts/build.sh`
- The installs (Stage B) run as root on the server, so the builder writes `install.sh`, and the
  coordinator runs it step by step with the owner's OK for each step. The builder doesn't run installs.

## Open questions (hub `questions/`)

- What ADP and R365 do on a new-device login (MFA by text or email?). The owner handles it in noVNC.

## What stays

Owner signs in. No credentials are stored by agents. No money or submit clicks. Windows payroll is
unchanged until a mirror refresh.
