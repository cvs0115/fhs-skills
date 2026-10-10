# Agent task · windows-agent-02 · build

> **For the coding agent (Composer 2.5 via `agent`), as `fhsbuild`.** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan (`docs/reviews/windows-agent-02.md`: APPROVE).
> Hand-off: `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/windows-agent-02`,
> then "Do the task in docs/prompts/windows-agent-02.md".

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office. Development happens only on this server. Some jobs
run on the owner's Windows desktop, because Dropbox and the Windows copy of the skills live there. You build the server-side guard and the
desktop tools for those jobs:
- a git `pre-receive` hook that accepts only `feat/win-*` fast-forward pushes
- the required SSH forced-command gate (owner, 2026-10-10)
- two PowerShell scripts: a mirror refresh and a report transfer
- a bash test harness
- a runbook

You can't run PowerShell here (there's no `pwsh`). Its scripts are checked statically here and run on the desktop after the merge.

## Where you work

- Workspace: `/srv/fhs-build/windows-agent-02`, your own clone. First: `git checkout -b feat/windows-agent-02`.
- You run as `fhsbuild`. You can't reach `/root`, and you don't need it. Throwaway repos go only under `mktemp -d`. Delete them when done.

## Read first

1. `CLAUDE.md`
2. `docs/plans/windows-agent-02.md`. Its "Files the builder may edit" section is the spec. If this file and the plan disagree, stop and report it.
3. `docs/research/windows-agent.md`: §3 (the hook text and push matrix), §4 (the mirror script), §5 (report transfer), §6 (risks)
4. `docs/specs/windows-agent.md`

## Steps

1. **Hook.** Create `scripts/git-hooks/pre-receive` with exactly the bytes of the ```` ```sh ```` block in research §3. Use:
   `sed -n '/^```sh$/,/^```$/p' docs/research/windows-agent.md | sed '1d;$d' > scripts/git-hooks/pre-receive`, then
   `chmod +x` and `git add --chmod=+x`. Don't edit it.
2. **`scripts/windows/refresh-mirror.ps1`.** Start from the research §4 script and apply exactly the plan's changes:
   - `param([string]$Clone='C:\fhs\fhs-skills', [string]$MirrorRoot='C:\Users\mayur\.claude\skills', [switch]$DryRun)`
   - the `-DryRun` exit
   - refuse when `$MirrorRoot` resolves inside `$Clone`
   - no `Remove-Item`, only `fhs-*`, ASCII only, no BOM, no tabs
   
   Keep the three lists, the `YES` prompt (`if ($answer -ne 'YES')`), the copy, the re-hash, and `matched=`/`unmatched=`.
3. **`scripts/windows/send-report.ps1`.** As specified in the plan:
   - `-Path` (required), `-Name` (validated `^[A-Za-z0-9._-]{1,120}$`, refuse `.` and `..`, default the file's own name), `-SshHost` (default `dev-lxc-1`)
   - the existence check first (exit 2 if the target exists)
   - `scp -O` (the classic `scp -t` remote form the gate allows) to `<SshHost>`, then `Get-FileHash -Algorithm SHA256` and remote `sha256sum` via `ssh <SshHost>`
   - a case-insensitive compare: `MATCH` exits 0, `MISMATCH` exits 1
   - check `$LASTEXITCODE` after every native command
   - ASCII only, no tabs
4. **`scripts/windows/ssh-gate.sh`.** Bash, `set -euo pipefail`. Read `$SSH_ORIGINAL_COMMAND`, and allow only the forms the plan lists.
   - Parse with `[[ =~ ]]` against fixed regexes, then `exec` the allowed program with **fixed** arguments built from the matched parts.
     Never `eval`, never `sh -c`, never pass the raw string through.
   - Repo path: `${FHS_GATE_REPO:-/root/fhs-skills}`. Inbox: `${FHS_GATE_INBOX:-/root/fhs-skills/inbox}`. A name must match
     `^[A-Za-z0-9._-]{1,120}$` and must not be `.` or `..`.
   - Anything else: print `refused` to stderr and exit 1. Executable.
5. **`scripts/tests/test_windows_agent.sh`.** Bash. Each case prints `PASS <id>` or `FAIL <id>: <detail>`. Exit 1 on any failure.
   - **Hook matrix (H1–H10):** run against a `mktemp -d` non-bare server repo (`git init -b main`, one commit, `main` checked out),
     with the hook copied from `scripts/git-hooks/pre-receive`, and a clone of it. Set `GIT_AUTHOR_*`/`GIT_COMMITTER_*` env; write no
     global git config.
     - H1: new `feat/win-hello` accepted
     - H2: fast-forward accepted
     - H3: `main` refused
     - H4: `feat/other` refused
     - H5: force-push refused
     - H6: delete refused
     - H7: `feat/win-Upper_Case` refused
     - H8: `feat/win-` refused
     - H9: refs afterwards are only `main` and `feat/win-hello`, and `feat/win-hello` is still at the fast-forward commit
     - H10: the server branch is still `main`
     - Each refusal must show the hook's `refused:` text.
   - **Gate matrix (G1–G16):** set `FHS_GATE_REPO`/`FHS_GATE_INBOX` to `mktemp -d` paths. Put stub executables named `git-upload-pack`,
     `git-receive-pack`, `scp`, `test`, `sha256sum` first on `PATH`. Each stub prints `STUB <name> <args>` and exits 0.
     - Accepted, and the stub prints the expected fixed args:
       - G1–G3: upload-pack with the quoted, trailing-slash and bare repo forms
       - G4–G5: receive-pack with the quoted and bare forms
       - G6: `scp -t <inbox>/r.md`
       - G7: `test ! -e <inbox>/r.md`
       - G8: `sha256sum <inbox>/r.md`
     - Refused with exit 1 and no `STUB` output:
       - G9: `bash`
       - G10: `sh -c id`
       - G11: `git-receive-pack '/etc'`
       - G12: `scp -t <inbox>/../x`
       - G13: `scp -f <inbox>/a`
       - G14: `sha256sum /etc/shadow`
       - G15: empty or unset
       - G16: `sha256sum <inbox>/a;id`, and separately `sha256sum <inbox>/$(id)`
   - **Static checks (S1–S6):**
     - S1: no `Remove-Item` in either `.ps1`
     - S2: refresh-mirror has `Read-Host` and `-ne 'YES'`
     - S3: both have `Get-FileHash -Algorithm SHA256`
     - S4: both are ASCII only (`LC_ALL=C grep -nP '[^\x00-\x7F]'` finds nothing)
     - S5: no tabs, no BOM
     - S6: `bash -n` on `ssh-gate.sh` and the test file
   - Delete every `mktemp -d` directory on exit (`trap`).
6. **`docs/runbooks/windows-agent.md`.** Plain words, for the owner, in this order:
   - what this is
   - the PC checklist C1–C6, and where to answer them (the hub)
   - D1 Git (choose "Use external OpenSSH", or `git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe`), and the clone
   - D2 no install: Claude Code is already on the PC; confirm Claude in Chrome; add the `dev-lxc-1-agent` SSH alias using the restricted key
   - how to start a PC agent (Claude Code): `claude --permission-mode plan` to look (read-only); a normal session to do, where it asks before each command; never bypass permissions unless the owner approved that run; agent jobs use the `dev-lxc-1-agent` alias
   - D3 the test push, then asking Ops to delete the test branch
   - D4: zip `C:\Users\mayur\.claude\skills` first, then `refresh-mirror.ps1 -DryRun`, then the real run
   - D5 `send-report.ps1`
   - G1, the required restricted key (generate `fhs_agent_ed25519` on the PC; Ops adds the gated line)
   - rollback for each
   - the CRLF note from research §4

## You may edit only

`scripts/git-hooks/pre-receive`, `scripts/windows/refresh-mirror.ps1`, `scripts/windows/send-report.ps1`, `scripts/windows/ssh-gate.sh`,
`scripts/tests/test_windows_agent.sh`, `docs/runbooks/windows-agent.md` (all new). Outside the repo, only your report
`/srv/fhs-build/reports/windows-agent-02.md`.

## You must not

- Edit any other file. Install the hook anywhere except a `mktemp -d` test repo. Touch `/root`, use sudo, or change git config.
- Run anything over SSH, push, merge, or commit to `main`.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_windows_agent.sh; echo exit=$?` → every line PASS (H1–H10, G1–G16, S1–S6), `exit=0`
2. `cmp scripts/git-hooks/pre-receive <(sed -n '/^```sh$/,/^```$/p' docs/research/windows-agent.md | sed '1d;$d') && echo SAME` → `SAME`
3. `git ls-files -s scripts/git-hooks/pre-receive scripts/windows/ssh-gate.sh scripts/tests/test_windows_agent.sh` → mode `100755` for all three
4. `git diff --name-only main...HEAD` → only the six files above
5. `git diff --check main...HEAD` and `git status --short` → no output
6. `ls -d /tmp/tmp.* 2>/dev/null | xargs -r stat -c '%U %n' | grep -c fhsbuild` → `0` (or only directories older than your run; name them)

## When done

1. Commit on `feat/windows-agent-02` with `git -c user.name="Surati" -c user.email="chirag.surati.78@gmail.com" commit`. The message ends
   with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write `/srv/fhs-build/reports/windows-agent-02.md`:

```text
Task: windows-agent-02 · Branch: feat/windows-agent-02 · Commits: <hashes>
Files changed: <list>
Tests: <n>/6 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.

## Review r3 minors (apply these too; from `docs/reviews/windows-agent-02.md`, APPROVE)

1. `send-report.ps1`: use `<SshHost>` for **all three** remote calls (the existence check, the `scp -O`, and `sha256sum`). The default stays `dev-lxc-1`.
2. The runbook's D4 success means every clone `skills\fhs-*` path is in the mirror with the same hash. Windows-only extras are listed and not
   deleted. The printed `unmatched` count may equal the number of extras.
3. The runbook's order: generate the `fhs_agent_ed25519` key → Ops adds the gated `authorized_keys` line → add the `dev-lxc-1-agent` alias → D1–D5.
4. The runbook's D5 example passes a regex-safe `-Name` (e.g. `122_2026-09-21_2026-10-04_hours.txt`). The default `-Name` is the source file's leaf name.
5. Gate tests: add a refused case `test ! -e /etc/x`.
6. Follow this task's Claude Code outline for the PC agent. Ignore research §7's mention of installing Cursor on the PC.
