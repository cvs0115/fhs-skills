# Spec · browser · A browser on the server that the owner can see and agents can drive

2026-10-10 · Hub project: `projects/server-move` · Plan page: https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG

## Problem and today

- **Problem:** server agents (Claude, Grok) can't open Toast, R365 or ADP. Two projects are blocked on
  "owner to sign in in the browser pane" (`r365-inventory`, `cash-and-deposits`), and a browser pane exists only in Windows Claude sessions.
- **Today:** browser steps happen in a Windows Claude session (Claude in Chrome), with the owner signing in.

## Who runs it

- The owner signs in and watches. Claude (and, later, Grok agents in a reviewed plan) read pages and
  click through read-only steps. Every change in Toast, R365 or ADP still needs the owner's yes at the time.

## Done when

1. The owner opens a web page from their PC and sees the server's browser, then signs in to R365 there.
2. A Claude session on the server reads the R365 home page in that browser through a tool connection.
3. The login survives a restart of the browser service.
4. Nothing new is reachable from the LAN or the internet. Everything is localhost plus an SSH tunnel.
5. The browser doesn't run as root.

## In scope

- P0: one browser, viewer for the owner, tool connection for Claude Code, R365 + Toast.
- P1: the same connection for cursor-agent (Grok); ADP.
- P2: a control that stops two agents driving the browser at once.

## Out of scope (parked)

- Agents typing credentials (never). Scheduled unattended browser runs (later plan, separate OK).

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Browser control | Playwright MCP `(?)` | MCP over localhost | no → research |
| Owner view | noVNC + x11vnc + Xvfb `(?)` | SSH tunnel | no → research |
| Logins | site cookies in a protected profile | browser profile | no → research |

## Owner rules that bind it

- Agents never enter usernames or passwords. No money or submit clicks. One yes per live change (`skills/fhs-skills/SKILL.md`).
- 2026-10-10: server browser the owner can see. Claude plans, Grok builds and tests, GPT-5.6 reviews.

## Open questions

- [NEEDS CLARIFICATION] What do R365, Toast and ADP do on a login from a new device or IP (MFA by text or email)? Answered at the first sign-in.
