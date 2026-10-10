# Plan · windows-agent-01 · A cursor-agent on the Windows PC for Windows-only steps

> **DRAFT, superseded.** Don't build from this. Review r1 sent it back. The build plan gets rewritten after `docs/plans/windows-research-01.md` produces its research note. Kept for the record.

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/` holds an APPROVE for this file.

- Hub project: `projects/server-move` (server move plan https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG).
- Research: `docs/research/access-browser-windows.md`
- Decisions that bind it: hub log 2026-10-10 (agent on Windows; no server → PC link; builders =
  grok-4.7-high). Earlier: the server repo is the master, and Windows is a mirror with no git (2026-10-09).

## Verdict

Build, in two stages. Stage A is research. Stage B is setup on the PC, which the owner does
themselves (installs and sign-ins on the PC).

## What changes, in plain words

Your Windows PC gets its own cursor-agent for the jobs that only work there: reading the Dropbox
week folders, refreshing the Windows copy of the skills, and anything NCR leaves only on the PC.
The PC reaches the server over the SSH connection you already use. The server never reaches into
the PC. Work moves in one direction: the PC pulls plans from the server repo and pushes results
back as a branch for review.

## Design

```
Windows PC                                        dev-lxc-1
cursor-agent (grok-4.7-high) ── git over ssh ──▶  /root/fhs-skills (bare pull/push of feat/win-* only)
   reads:  Dropbox\CMVK Food Services\...         coordinator (Claude) reviews + merges
   writes: C:\fhs\fhs-skills (clone), its branch
```

- **Git for Windows** installed by the owner. Clone with
  `git clone dev-lxc-1:/root/fhs-skills C:\fhs\fhs-skills` over the existing SSH alias.
- The Windows agent works only in `C:\fhs\fhs-skills` on `feat/win-<task>` branches and pushes
  only those. It never pushes `main`. A server-side `pre-receive` hook in `/root/fhs-skills/.git/hooks/`
  refuses any push to `main` and any branch not named `feat/win-*` `(?)`. The checked-out
  `main` in a non-bare repo also refuses a push to itself by default.
- **Windows jobs and how they run:**
  | Job | How |
  |---|---|
  | Mirror refresh (server `main` → `C:\Users\mayur\.claude\skills\fhs-*`) | `scripts/windows/refresh-mirror.ps1`. The owner OKs each run (it changes live Windows payroll). It prints a diff first, then copies. |
  | Week-folder reports for a server job | The agent copies the named files from Dropbox into the clone's `inbox/` (gitignored) and `scp`s them to the server's `inbox/`. Reports are never committed. |
  | Any other Windows-only step | a plan names it; the Windows agent runs it from that plan |
- **Briefs** are the same plan files in `docs/plans/`, after an APPROVE. The owner starts the Windows
  agent with the plan's path: `cursor-agent --model grok-4.7-high` in `C:\fhs\fhs-skills`.
- The Windows agent never types passwords and never touches ADP, Toast or R365. Browser work
  happens in the server browser (`docs/plans/browser-01.md`).

## Stage A · research (read-only)

Write `docs/research/windows-agent.md`:
1. The cursor-agent installer and sign-in on Windows, and whether `--sandbox` and `--mode` exist there.
2. Whether the PC's SSH alias to dev-lxc-1 works from a non-interactive git (key, not password). The owner runs `ssh dev-lxc-1 true` on the PC.
3. Git push rules for a non-bare repo (`receive.denyCurrentBranch`), and a `pre-receive` hook that limits branch names.
4. The exact Windows paths: the Dropbox root, `.claude\skills`, and whether OneDrive redirects Documents.

## Files the builder may edit

- `scripts/windows/refresh-mirror.ps1` (new), `scripts/windows/send-reports.ps1` (new)
- `scripts/git-hooks/pre-receive` (new; installed into `.git/hooks/` by the coordinator after the owner's OK)
- `docs/runbooks/windows-agent.md` (new): the owner's setup steps and how to start a job
- `CLAUDE.md`: a "Windows agent" section (one-way, `feat/win-*` only, mirror refresh = separate OK)
- `skills/fhs-skills/SKILL.md` "Master copy" paragraph: how the mirror is refreshed now. **Skill
  file**, so it goes live on merge.

## Files the builder must not edit

- The served tree directly; `shared/config.json`; `.env`; anything on the PC outside `C:\fhs\` (except
  through `refresh-mirror.ps1` when the owner runs it)

## Live systems touched

- **Owner's PC:** Git for Windows and cursor-agent installs and the clone (the owner does them).
- **Server:** a `pre-receive` hook in the repo (OK at install).
- **Windows payroll:** only through a mirror refresh, OK'd each run.

## Done-check (real outcome)

1. On the PC, `git clone` succeeds and `git log -1` matches the server's `main` hash.
2. On the PC, a test branch `feat/win-hello` with one file pushes to the server and shows in `git branch` there.
   A push to `main` and a push to `feat/other` are both refused.
3. A `refresh-mirror.ps1` dry run lists the files that would change, and they match
   `git diff --stat <last-mirrored>..main -- skills/` on the server.
4. The Windows agent copies one named report from a real week folder to the server's `inbox/`, and
   `sha256sum` matches on both sides.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`. The SKILL.md paragraph goes live on merge.
- **Windows mirror:** stays exactly as it is until the first OK'd `refresh-mirror.ps1` run.
- **Live before merge:** nothing changes for either side.

## Where the builder works

- Server worktree `/root/fhs-skills-wt/windows-agent-01` · branch `feat/windows-agent-01` · cut from
  `main` after framework-setup-02 merges · builder grok-4.7-high via `scripts/build.sh`. The
  PowerShell scripts are written on the server and tested on the PC by the owner (done-checks 1–4).

## What stays

The server repo is the only master. Windows has no `main` edits. Payroll runs on Windows unchanged
until a refresh. Reports are never in git.
