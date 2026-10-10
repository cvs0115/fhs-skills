# Ops task · ops-01 · Bootstrap the locked-down builder user `fhsbuild`

> **For the Ops agent (Grok 4.7 High in cursor-agent, running as root, WITHOUT `--force`).** The owner
> approves every command you run. Show each command before you run it. This file is your whole assignment.
> Start: `agent --model grok-4.7-high --workspace /root/fhs-skills`, then tell it "Do the task in docs/prompts/ops-01-bootstrap.md".

## Context

Builder and tester agents (Grok, run with `--force`) must not be able to change the live skills in
`/root/fhs-skills`. They will run as a separate system user, `fhsbuild`, whose home is `/srv/fhs-build`. Since
`/root` is `drwx------`, that user can't read or write anything under `/root`. You create the user, install
cursor-agent for it, wait while the owner signs it in, and prove the isolation. The plan behind this is
`docs/plans/framework-setup-02.md`, section "Bootstrap setup".

## Preconditions

- `docs/RUNBOOK.md` row 1 is done: `git -C /root/fhs-skills log --oneline -1` shows the planning-docs commit.
- `id fhsbuild` → "no such user". If the user already exists, stop and report it. Don't modify an existing user.

## Steps

1. `stat -c '%A %U %n' /root` → `drwx------ root /root`. If not, stop and report it (the isolation depends on it).
2. Create the user:
   `useradd --system --create-home --home-dir /srv/fhs-build --shell /bin/bash fhsbuild && chmod 750 /srv/fhs-build`
3. Create the reports folder: `install -d -o fhsbuild -g fhsbuild -m 750 /srv/fhs-build/reports`
4. Show the cursor-agent installer before running it, so the owner can see what it does:
   `curl -fsSL https://cursor.com/install | head -40`
   The owner confirms it's Cursor's official installer. If the URL fails or looks wrong, stop and report it.
5. Install it for `fhsbuild` only (it installs under that user's home):
   `sudo -u fhsbuild -H bash -c 'curl -fsSL https://cursor.com/install | bash'`
   Then: `ls -l /srv/fhs-build/.local/bin/agent` → exists.
   If the installer asks for root or writes outside `/srv/fhs-build`, stop and report it. Don't re-run it as root.
6. **Pause for the owner.** Tell the owner to run this themselves in a terminal (it prints a URL to open in their browser):
   `sudo -u fhsbuild -H env NO_OPEN_BROWSER=1 /srv/fhs-build/.local/bin/agent login`
   Wait until the owner says it's done. Don't run it yourself, and never handle the login URL or any token.
7. Check the sign-in: `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent status` → "Logged in".
8. Check grok-4.7-high is available to that user:
   `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent models | grep -c '^grok-4.7-high '` → `1`
9. Prove the isolation. **Every one of these must FAIL** with "Permission denied":
   - `sudo -u fhsbuild touch /root/fhs-skills/x`
   - `sudo -u fhsbuild ls /root`
   - `sudo -u fhsbuild cat /root/.claude.json`
   - `sudo -u fhsbuild sudo -n true` (expect "a password is required" or "not in the sudoers file")
10. Check nothing changed in the live repo: `git -C /root/fhs-skills status --short` → empty.

## You must not

- Give `fhsbuild` sudo, a password, SSH keys, or membership in any group besides its own.
- Copy any file from `/root` (auth, config, keys) to `/srv/fhs-build`.
- Run the login for the owner, or read or store its URL or tokens.

## Rollback (only if the owner asks)

`userdel -r fhsbuild` (removes the user and `/srv/fhs-build`).

## Report

Write `/srv/fhs-build/reports/ops-01-bootstrap.md`, then `chown root:root` it (so builders can read but not change it):

```text
Ops: ops-01 · Date: <date>
Steps 1–10: <ok / issue> each, with the command output for 7, 8, 9 and 10
Next: "RUNBOOK row 3" or the issue to send to Claude
```
