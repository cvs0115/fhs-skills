# Runbook · Windows agent tools

## What this is

Your Windows PC can do a few back-office jobs that only work there: push small git branches back to the server, refresh the copy of the skills that payroll uses, and send a report file to the server inbox. The server refuses unsafe git pushes. A separate SSH key for agent jobs can only run git, copy into inbox, and hash a file there—not arbitrary commands.

## PC checklist (answer on the hub)

Before you run the steps below, these were confirmed on 2026-10-10. If anything changed, update the hub.

| ID | What |
|---|---|
| C1 | `ssh dev-lxc-1` works without a password (you land as root on dev-lxc-1). Windows OpenSSH is at `C:\Windows\System32\OpenSSH\ssh.exe`. |
| C2 | Git for Windows: install with **Use external OpenSSH** (or set `core.sshCommand` to that `ssh.exe`). |
| C3 | PC agent is **Claude Code** (already installed). Use Claude in Chrome for browser tasks. |
| C4 | Dropbox root: `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services`. |
| C5 | Skills mirror folder `C:\Users\mayur\.claude\skills` has `fhs-*` folders. |
| C6 | Git clone lives at `C:\fhs\fhs-skills` (not inside Dropbox or the skills mirror). |

## Setup order (do this first)

1. **G1 — restricted key:** On the PC, generate `fhs_agent_ed25519`:
   `ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\fhs_agent_ed25519`
2. **Ops** adds one line to root's `authorized_keys` on dev-lxc-1 with
   `command="/root/fhs-skills/scripts/windows/ssh-gate.sh",no-pty,no-port-forwarding,no-agent-forwarding,no-X11-forwarding`
   and the public key.
3. **SSH alias** in `C:\Users\mayur\.ssh\config`:
   `Host dev-lxc-1-agent` with `HostName` (same as dev-lxc-1), `User root`, `IdentityFile ~/.ssh/fhs_agent_ed25519`.
4. Then **D1–D5** below.

## D1 — Git clone

Install Git for Windows if needed (`winget install --id Git.Git -e`). Choose **Use external OpenSSH**, or run:

`git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe`

Clone:

`git clone dev-lxc-1:/root/fhs-skills C:\fhs\fhs-skills`

**Rollback:** delete `C:\fhs\fhs-skills`.

## D2 — Claude Code on the PC

No extra install: Claude Code is already there. Confirm Claude in Chrome for browser work. The `dev-lxc-1-agent` alias (above) is for agent jobs that must use the restricted key.

**Starting a PC agent (Claude Code):**

- To look only (read-only): `claude --permission-mode plan`
- To do work: a normal session; Claude asks before each command.
- Do not bypass permissions unless you already approved that run.
- Agent jobs that touch the server should use the `dev-lxc-1-agent` host (restricted key). Your own `dev-lxc-1` alias stays for you.

**Rollback:** remove the `dev-lxc-1-agent` block from SSH config.

## D3 — Test push

From the clone, create branch `feat/win-hello`, add `docs/zz-win-hello.md`, push. Confirm on the server. Ask Ops to delete the test branch server-side when done.

**Rollback:** Ops deletes the branch; your local branch can be deleted locally.

## D4 — Mirror refresh

1. Zip a backup of `C:\Users\mayur\.claude\skills` first.
2. From the clone: `powershell -File scripts\windows\refresh-mirror.ps1 -DryRun` — read the three lists.
3. Run without `-DryRun`, type `YES` only if the lists look right.

**Success:** Every `skills\fhs-*` file in the clone appears in the mirror with the same SHA256 hash. Windows-only extras are listed under "Only on Windows" and are **not** deleted. After a good run, `unmatched=0` for clone paths; `unmatched` may equal the number of Windows-only extras (each extra counts in `unmatched` and is listed as "Still only on Windows").

**Rollback:** restore the zip backup of `.claude\skills`.

## D5 — Send a report

From the clone (or with paths you trust):

`powershell -File scripts\windows\send-report.ps1 -Path "C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\...\122_2026-09-21_2026-10-04_hours.txt" -Name 122_2026-09-21_2026-10-04_hours.txt`

`-Name` must be a safe file name (letters, digits, `.`, `_`, `-` only). If you omit `-Name`, the script uses the source file's leaf name. Agent jobs can pass `-SshHost dev-lxc-1-agent`. You should see `MATCH`.

**Rollback:** ask Ops to remove the file from `/root/fhs-skills/inbox/`.

## G1 — SSH gate (required)

The restricted key and gate script are required for agent SSH. Owner generates the key; Ops installs the gated `authorized_keys` line (see Setup order).

**Rollback:** Ops removes that one `authorized_keys` line.

## Server hook (Ops, after merge)

Ops installs `scripts/git-hooks/pre-receive` into `/root/fhs-skills/.git/hooks/pre-receive` when you say OK.

**Rollback:** Ops removes that hook file.

## Line endings (CRLF)

Git for Windows often checks out text files with CRLF while the server tree uses LF. The mirror script compares hashes on the PC after `git pull`, so both sides use the same line endings for the clone vs mirror compare. If a dry run shows every text file as "different hash", check `core.autocrlf` before you type `YES`.
