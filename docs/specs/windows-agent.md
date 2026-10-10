# Spec · windows-agent · A coding agent on the Windows PC for Windows-only steps

2026-10-10 · Hub project: `projects/server-move` · Plan page: https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG

## Problem and today

- **Problem:** some work only exists on the Windows PC: the Dropbox week folders (payroll reports,
  NCR downloads), and the Windows copy of the skills that payroll runs from. Server agents can't reach it.
- **Today:** the owner works in Windows Claude sessions, and the Windows skill copy is refreshed by hand.

## Development vs runtime (owner, 2026-10-10)

- **Development** happens only on dev-lxc-1 (plans, Grok builds, tests, reviews, the master repo).
- **Runtime** can be the server **or the owner's Windows desktop**: some apps (Dropbox, NCR downloads, other desktop software) only
  live on the desktop. A skill that needs them is **deployed** to `C:\Users\mayur\.claude\skills\` as a copy of the reviewed
  server `main`. Each deploy is the mirror refresh, a separate owner OK.
- Every plan says where its skill runs (server, desktop, or both) and, for desktop, which Windows apps it needs.

## Who runs it

- The owner starts a cursor-agent (Grok 4.7 High) on the PC and hands it a task file, the same way as on the server.

## Done when

1. The PC has a clone of the server repo, kept current over the SSH alias the owner already uses (PC → server only).
2. The Windows agent can push a `feat/win-*` branch to the server, and can't push `main` or other branch names.
3. A mirror refresh makes the Windows `fhs-*` skill folders match server `main` exactly (hash check). Each refresh is OK'd by the owner.
4. A named report moves from a Dropbox week folder to the server's `inbox/` with matching hashes.

## In scope

- P0: clone + branch push rules; mirror refresh script; report transfer.
- P1: a runbook the owner follows to start a Windows job.

## Out of scope (parked)

- A server → PC connection (the owner chose not to). Browser work (the server browser handles it).
- Dropbox sync on the server (server move plan phase 7, separate).

## Systems and data

| Data | Source of truth | How the agent gets it | Verified? |
|---|---|---|---|
| Repo | `/root/fhs-skills` on the server | git over the SSH alias `dev-lxc-1` | no → research |
| Reports | Dropbox `CMVK Food Services\Locations\...` on the PC | local files | path known (config.json); access unverified |
| Windows skills | `C:\Users\mayur\.claude\skills\fhs-*` | local files | path from memory notes |

## Owner rules that bind it

- The server repo is the only master. Windows never edits `main` (2026-10-09). Reports never go in git.
- A mirror refresh changes live Windows payroll: a separate OK each time.

## Open questions

- [NEEDS CLARIFICATION] Is Git for Windows OK to install on the PC? Is cursor-agent? (asked before Stage B)
