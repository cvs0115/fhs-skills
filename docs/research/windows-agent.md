# Research · windows-agent · Windows agent setup

2026-10-10. Research only. Nothing was installed on the PC, and nothing was changed in `/root/fhs-skills`. Sources are a URL or a command run here. Anything not checked is marked `(?)`.

## 1. cursor-agent on Windows

**Confirmed.** Cursor's install page gives a Windows PowerShell command, separate from the macOS/Linux/WSL command. Source: [Cursor CLI](https://cursor.com/docs/cli/overview) and [Installation](https://cursor.com/docs/cli/installation).

```powershell
irm 'https://cursor.com/install?win32=true' | iex
agent --version
```

The docs call the program `agent`. On this Linux host both names exist (`command -v cursor-agent` → `/srv/fhs-build/.local/bin/cursor-agent`, and `command -v agent` → `/srv/fhs-build/.local/bin/agent`). `(?)` whether the Windows installer also puts a `cursor-agent` command on PATH. That was not run on the PC.

**Confirmed.** Sign-in, from [Authentication](https://cursor.com/docs/cli/reference/authentication):

1. `agent login` opens the default browser and stores credentials locally.
2. If the browser does not open, the docs say `NO_OPEN_BROWSER=1 agent login` and then open the printed URL. `(?)` that spelling is the bash form. It was not run in PowerShell.
3. `agent status` shows whether the login worked.
4. For a script, the docs also allow `CURSOR_API_KEY` or `agent --api-key`. A key does not belong in this repo.

**Confirmed.** These flags are global options in [Parameters](https://cursor.com/docs/cli/reference/parameters). The page does not say they are missing on Windows.

| Flag | What the docs say | Also written at |
|---|---|---|
| `--mode` | `plan` or `ask`. Agent is the default when no mode is set. | [Overview](https://cursor.com/docs/cli/overview): Ask is "Read-only exploration without making changes". [Using Agent in CLI](https://cursor.com/docs/cli/using): Ask mode searches and answers "without editing files". |
| `--sandbox` | `enabled` or `disabled`. | [Overview](https://cursor.com/docs/cli/overview): `/sandbox` or `--sandbox`, and network access is toggled from a menu. Settings persist. |
| `--workspace` | Workspace directory to use. | [Using Agent in CLI](https://cursor.com/docs/cli/using): combine `--workspace <path>` for an explicit repository root; otherwise the CLI uses the current directory. |
| `-p` / `--print` | Print to the console for scripts. "Has access to all tools, including write and shell." | [Overview](https://cursor.com/docs/cli/overview) and [Using Agent in CLI](https://cursor.com/docs/cli/using). The using page also says "Cursor has full write access in non-interactive mode." |

The same four flags are on this host's CLI (`cursor-agent --help`, version `2026.10.01-e373342` from `cursor-agent about`). That run was Linux, not Windows.

`(?)` the Windows build was not started here, so this note does not claim a Windows process accepted the flags. The claim is that the current CLI docs list them for the Windows install as well as the others.

## 2. Git for Windows over SSH

**Confirmed.** Windows OpenSSH reads the per-user config file the owner already uses. [OpenSSH Server Configuration for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh-server-configuration) says the client reads, in order: `-F` if passed, then `%userprofile%\.ssh\config`, then `%programdata%\ssh\ssh_config`. For `C:\Users\mayur` that user file is `C:\Users\mayur\.ssh\config`. The same page shows a `Host` block (`HostName`, `User`, and the rest of the client options).

**Confirmed.** Git for Windows does not automatically promise to use that file. Its installer page "Choosing the SSH executable" has "Use bundled OpenSSH" ("This uses ssh.exe that comes with Git") and "Use external OpenSSH" ("This uses an external ssh.exe. Git will not install its own OpenSSH (and related) binaries but use them as found on the PATH"). The saved default when there is no previous choice is bundled OpenSSH. Source: [installer/install.iss](https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss) (`CreateRadioButton` captions for `GS_OpenSSH` and `GS_ExternalOpenSSH`, and `ReplayChoice('SSH Option','OpenSSH')`). The choice page is created when `ssh.exe` is already on PATH or a PuTTY session exists.

Use **Use external OpenSSH** so `git` and the owner's `ssh dev-lxc-1` call the same Windows `ssh.exe`, which reads `%userprofile%\.ssh\config`. Windows' own client lives at `C:\Windows\System32\OpenSSH` ([Windows Terminal SSH](https://learn.microsoft.com/en-us/windows/terminal/tutorials/ssh)).

If Git is already installed with the bundled client, point Git at Windows OpenSSH without reinstalling. Local `git config --help` says `core.sshCommand` replaces `ssh` for fetch and push, and `GIT_SSH_COMMAND` overrides it. The same text is in [Git for Windows core.adoc](https://github.com/git-for-windows/git/blob/main/Documentation/config/core.adoc). The form recorded by Git for Windows maintainers is forward slashes ([git-for-windows/git#1981](https://github.com/git-for-windows/git/issues/1981)):

```text
git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe
```

`(?)` bundled `ssh.exe` and a `HOME` variable that is not the user profile. This research did not run Git for Windows. Do not rely on the bundled client for the existing alias.

**Confirmed.** Non-interactive auth is a key plus the agent, then `BatchMode`. [Key-based authentication in OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement) says `ssh-keygen` writes the key under `C:\Users\<username>\.ssh\`, and an elevated PowerShell can start the agent and load the key:

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ecdsa
```

Those three lines were not run here. `man ssh_config` on this host says `BatchMode yes` disables user interaction such as password prompts and host-key questions (argument `yes` or `no`, default `no`). Microsoft tells you to use that ssh_config manual for client options and does not list `BatchMode` among the server options Windows lacks. `(?)` `BatchMode` was not tried against the PC's `ssh.exe`.

A `Host dev-lxc-1` block in `C:\Users\mayur\.ssh\config` is what makes the short name work. Keep the `HostName` and `User` that already work for `ssh`. Add `IdentityFile` and `IdentitiesOnly yes` if the key is not the default name. Add `BatchMode yes` only after a normal `ssh dev-lxc-1 true` already succeeds, so a missing key fails instead of sitting on a prompt. `(?)` the PC file was not read. The task says the server user is root; the checklist below is where that login gets confirmed.

**Confirmed.** The clone command, not run from the PC:

```text
git clone dev-lxc-1:/root/fhs-skills
```

`git clone --help` on this host (git 2.43.0) calls `[user@]host.xz:path/to/repo.git/` the scp-like ssh syntax, recognized when there is no slash before the first colon. There is no `user@` in the command, so the user is whatever `Host dev-lxc-1` sets. The path is the absolute path `/root/fhs-skills`. `CLAUDE.md` in this repo says that path, with `main` checked out, is the tree server sessions run. This user cannot see it: `ls -ld /root/fhs-skills` prints `ls: cannot access '/root/fhs-skills': Permission denied`. `(?)` the live branch and `receive.denyCurrentBranch` on that path were not re-read.

What root and that path mean for a push: `git help githooks` on this host says the `pre-receive` hook is invoked by `git-receive-pack` when it reacts to `git push`. `man git-receive-pack` says that command is what updates the repository from a push, and that the user does not run it directly. Over the ssh URL from `git clone --help`, that remote program runs as the SSH login, in `/root/fhs-skills`. If that login is root, the hook runs as root and can update refs in the live non-bare repo. It does not by itself change the files checked out on `main`. Section 3's throwaway repo stayed on `main` after the accepted `feat/win-hello` push. `CLAUDE.md` says a merge to `main` is what server sessions then run. The hook does not see an ordinary `ssh dev-lxc-1 <command>`: `git help githooks` ties `pre-receive` to `git-receive-pack` only.

`(?)` the folder on the PC where the clone should live. It must not be `C:\Users\mayur\.claude\skills` (that path is the payroll copy, not the git checkout).

## 3. Push rules, proven

Throwaway root: `/tmp/winres-ZMIt` (removed after this note was saved; see Appendix). Git 2.43.0, user `fhsbuild`. No `git config` was written. Commit names came from `GIT_AUTHOR_*` and `GIT_COMMITTER_*`. Transport was a local path, not SSH. The hook and `receive.denyCurrentBranch` run in `receive-pack` either way.

Server: `git init -b main` in `$T/server`, one empty commit, then `README`. `git rev-parse --is-bare-repository` printed `false`. `git branch --show-current` printed `main`. `git config --get receive.denyCurrentBranch` printed nothing and exited 1 (`UNSET`).

**Confirmed.** Unset means refuse. `git config --help` on this host:

```text
receive.denyCurrentBranch
    If set to true or "refuse", git-receive-pack will deny a ref update
    to the currently checked out branch of a non-bare repository. ...
    Defaults to "refuse".
```

Push of a new commit on `main` from `$T/pc`, hook not installed yet:

```text
remote: error: refusing to update checked out branch: refs/heads/main
remote: error: By default, updating the current branch in a non-bare repository
remote: is denied, because it will make the index and work tree inconsistent
remote: with what you pushed, and will require 'git reset --hard' to match
remote: the work tree to HEAD.
remote:
remote: You can set the 'receive.denyCurrentBranch' configuration variable
remote: to 'ignore' or 'warn' in the remote repository to allow pushing into
remote: its current branch; however, this is not recommended unless you
remote: arranged to update its work tree to match what you pushed in some
remote: other way.
remote:
remote: To squelch this message and still keep the default behaviour, set
remote: 'receive.denyCurrentBranch' configuration variable to 'refuse'.
To /tmp/winres-ZMIt/server
 ! [remote rejected] main -> main (branch is currently checked out)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_main_nohook_exit=1
```

The hook was then copied to `$T/server/.git/hooks/pre-receive` and marked executable (`ls -l` showed `-rwxr-xr-x`, 688 bytes). `pre-receive` runs before the deny-current-branch check: once this hook is in place, a push of `main` is refused by the hook (output below), so the default message above is what you get only when the hook is absent.

Complete hook file. Copy this block only, then `chmod +x`:

```sh
#!/bin/sh
# pre-receive: allow only fast-forward updates of refs/heads/feat/win-[a-z0-9-]+
zero=0000000000000000000000000000000000000000
while read -r oldrev newrev refname; do
  printf '%s\n' "$refname" | LC_ALL=C grep -Eq '^refs/heads/feat/win-[a-z0-9-]+$'
  if [ "$?" -ne 0 ]; then
    echo "refused: $refname does not match refs/heads/feat/win-[a-z0-9-]+" >&2
    exit 1
  fi
  if [ "$newrev" = "$zero" ]; then
    echo "refused: delete of $refname is not allowed" >&2
    exit 1
  fi
  if [ "$oldrev" != "$zero" ]; then
    if ! git merge-base --is-ancestor "$oldrev" "$newrev"; then
      echo "refused: non-fast-forward update of $refname" >&2
      exit 1
    fi
  fi
done
exit 0
```

**Confirmed.** Results after the hook was installed. A new branch `feat/win-hello` was accepted, and a second commit on it was accepted (fast-forward):

```text
To /tmp/winres-ZMIt/server
 * [new branch]      feat/win-hello -> feat/win-hello
push_win_hello_exit=0
To /tmp/winres-ZMIt/server
   5e2c576..97510fe  feat/win-hello -> feat/win-hello
push_ff_exit=0
```

Push `main` (the client was 1 commit ahead of `origin/main`):

```text
remote: refused: refs/heads/main does not match refs/heads/feat/win-[a-z0-9-]+
To /tmp/winres-ZMIt/server
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_main_hook_exit=1
```

Push `feat/other`:

```text
remote: refused: refs/heads/feat/other does not match refs/heads/feat/win-[a-z0-9-]+
To /tmp/winres-ZMIt/server
 ! [remote rejected] feat/other -> feat/other (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_other_exit=1
```

Force-push `feat/win-hello` after `git commit --amend` (`git push --force origin feat/win-hello`):

```text
remote: refused: non-fast-forward update of refs/heads/feat/win-hello
To /tmp/winres-ZMIt/server
 ! [remote rejected] feat/win-hello -> feat/win-hello (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_force_exit=1
```

Delete `feat/win-hello` (`git push origin --delete feat/win-hello`):

```text
remote: refused: delete of refs/heads/feat/win-hello is not allowed
To /tmp/winres-ZMIt/server
 ! [remote rejected] feat/win-hello (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_delete_exit=1
```

Push `feat/win-Upper_Case` (uppercase and underscore, outside `[a-z0-9-]`):

```text
remote: refused: refs/heads/feat/win-Upper_Case does not match refs/heads/feat/win-[a-z0-9-]+
To /tmp/winres-ZMIt/server
 ! [remote rejected] feat/win-Upper_Case -> feat/win-Upper_Case (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_upper_exit=1
```

Push `feat/win-` (nothing after the hyphen; the pattern requires one or more of `[a-z0-9-]`):

```text
remote: refused: refs/heads/feat/win- does not match refs/heads/feat/win-[a-z0-9-]+
To /tmp/winres-ZMIt/server
 ! [remote rejected] feat/win- -> feat/win- (pre-receive hook declined)
error: failed to push some refs to '/tmp/winres-ZMIt/server'
push_empty_suffix_exit=1
```

After those refusals, `git -C $T/server for-each-ref refs/heads` listed only `refs/heads/feat/win-hello` at `97510fecfb304bd7976b5a2fa8a01a0b7cc99069` and `refs/heads/main` at `68c022b88dfa6130dbe9620918ade5c31d21fe2c`. `git branch --show-current` on the server was still `main`. The delete did not remove `feat/win-hello` (`git rev-parse --verify refs/heads/feat/win-hello` printed the same `97510fe…` id).

This research did not install the hook in `/root/fhs-skills` or in this clone.

## 4. Mirror refresh

Text only. This script was not run.

**Confirmed.** Git for Windows' line-ending page defaults to "Checkout Windows-style, commit Unix-style line endings", which sets `core.autocrlf` to `true` (`ReplayChoice('CRLF Option','CRLFAlways')` in the same [install.iss](https://github.com/git-for-windows/build-extra/blob/main/installer/install.iss)). The installer text says Git converts LF to CRLF when checking out text files. Hashes below are of the working tree after `git pull`, so they follow that checkout, not the blob stored on the server. `(?)` the owner's real `core.autocrlf` if Git is already installed. A first compare may list every text file when the current Windows copy is still LF.

The script hashes `skills\fhs-*` in the PC clone and `C:\Users\mayur\.claude\skills\fhs-*`. It prints three lists (only on the server, hash differs, only on Windows). It copies only after `Read-Host` returns `YES`. It then hashes both trees again and prints `matched` and `unmatched`. Paths that exist only under the Windows skills folder are printed and are not deleted: the script never calls `Remove-Item`. `$Clone` is a placeholder `(?)`.

```powershell
$ErrorActionPreference = 'Stop'
$Clone = 'C:\Users\mayur\src\fhs-skills'
$MirrorRoot = 'C:\Users\mayur\.claude\skills'
$SourceRoot = Join-Path $Clone 'skills'

git -C $Clone checkout main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
git -C $Clone pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

function Get-FhsHashes([string]$Root) {
    $map = @{}
    if (-not (Test-Path -LiteralPath $Root)) { return $map }
    Get-ChildItem -LiteralPath $Root -Force -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like 'fhs-*' } |
        ForEach-Object {
            Get-ChildItem -LiteralPath $_.FullName -Recurse -Force -File
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($Root.Length).TrimStart('\')
            $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
            $map[$rel] = $hash
        }
    return $map
}

$src = Get-FhsHashes $SourceRoot
$dst = Get-FhsHashes $MirrorRoot
$onlyServer = @()
$different = @()
$onlyWindows = @()
foreach ($rel in $src.Keys) {
    if (-not $dst.ContainsKey($rel)) { $onlyServer += $rel }
    elseif ($dst[$rel] -ne $src[$rel]) { $different += $rel }
}
foreach ($rel in $dst.Keys) {
    if (-not $src.ContainsKey($rel)) { $onlyWindows += $rel }
}

Write-Output 'Only on server (would be copied):'
$onlyServer | Sort-Object | ForEach-Object { Write-Output $_ }
Write-Output 'Different hash (would be copied over):'
$different | Sort-Object | ForEach-Object { Write-Output $_ }
Write-Output 'Only on Windows (reported, not deleted):'
$onlyWindows | Sort-Object | ForEach-Object { Write-Output $_ }

$answer = Read-Host 'Type YES to copy server files onto the Windows skill folders'
if ($answer -ne 'YES') {
    Write-Output 'Stopped. Nothing copied.'
    exit 1
}

foreach ($rel in ($onlyServer + $different)) {
    $from = Join-Path $SourceRoot $rel
    $to = Join-Path $MirrorRoot $rel
    $parent = Split-Path -Parent $to
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
    Copy-Item -LiteralPath $from -Destination $to -Force
}

$srcAfter = Get-FhsHashes $SourceRoot
$dstAfter = Get-FhsHashes $MirrorRoot
$matched = 0
$unmatched = 0
$seen = @{}
foreach ($rel in $srcAfter.Keys) {
    $seen[$rel] = $true
    if ($dstAfter.ContainsKey($rel) -and $dstAfter[$rel] -eq $srcAfter[$rel]) { $matched++ }
    else { $unmatched++ }
}
foreach ($rel in $dstAfter.Keys) {
    if (-not $seen.ContainsKey($rel)) {
        $unmatched++
        Write-Output "Still only on Windows: $rel"
    }
}
Write-Output "matched=$matched"
Write-Output "unmatched=$unmatched"
```

`Get-FileHash -Algorithm SHA256` is the Windows hash. Docs: [Get-FileHash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash). Default algorithm is SHA256. Not run here.

## 5. Report transfer

Not run. No `scp` and no `ssh` from this research.

**Confirmed.** `inbox/` is ignored in this clone:

```text
$ git check-ignore -v inbox/example-report.md
.gitignore:2:inbox/	inbox/example-report.md
```

A file copied to `inbox/` does not show up as a normal git change. `(?)` whether the directory `/root/fhs-skills/inbox` already exists. This user cannot list `/root/fhs-skills` (section 2).

**Confirmed.** Windows OpenSSH includes `scp` ([key management](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement) calls it the OpenSSH `scp` utility). `man scp` on this host says `scp` copies files between hosts and "uses the SFTP protocol over a ssh(1) connection", and `-F` selects the ssh config file. With no `-F`, that is the same user config as section 2, so the alias `dev-lxc-1` is the host name to pass. `(?)` not run from PowerShell.

```powershell
$local = 'C:\path\to\report.md'
scp $local dev-lxc-1:/root/fhs-skills/inbox/report.md
Get-FileHash -Algorithm SHA256 -LiteralPath $local
ssh dev-lxc-1 "sha256sum /root/fhs-skills/inbox/report.md"
```

**Confirmed.** Compare the two hex strings case-insensitively. [Get-FileHash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash) example 1 shows an uppercase `Hash` (`3CBCFDDEC145E3382D592266BE193E5BE53443138EE6AB6CA09FF20DF609E268`). On this server, `sha256sum` is `/usr/bin/sha256sum`, `sha256sum (GNU coreutils) 9.4`, and it prints lowercase. Command: `printf 'abc\n' > /tmp/winres-ZMIt/sample.txt && sha256sum /tmp/winres-ZMIt/sample.txt` printed `edeaaff3f1774ad2888673770c6d64097e391bc362d7d6fb34982ddf0efd18cb  /tmp/winres-ZMIt/sample.txt`.

`$local` is whatever named report the job was given. `(?)` the real Dropbox path is a checklist blank. The expected root in the task is `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services`.

## 6. Risks

**Confirmed.** An agent started with `--force` (alias `--yolo`) will "Force allow commands unless explicitly denied" ([Parameters](https://cursor.com/docs/cli/reference/parameters)). [Permissions](https://cursor.com/docs/cli/reference/permissions) say deny rules take precedence over allow rules, and that print mode can use write and shell tools, with `--force` controlling what runs without prompts. [Using Agent in CLI](https://cursor.com/docs/cli/using) says that before a terminal command, the CLI otherwise asks for approval (`y` or `n`).

A `--force` session can therefore run a shell as the Windows user without a per-command yes. `docs/specs/windows-agent.md` names the Dropbox week folders and `C:\Users\mayur\.claude\skills` (the payroll copy) as data that user can reach. `(?)` this research did not log in on the PC, so it did not watch a `--force` session touch those paths. If `ssh dev-lxc-1` logs in as root, the same shell can run a remote command as root. The `pre-receive` hook does not see those commands (section 2). `(?)` the PC login was not tested.

**Confirmed.** Limits that the docs do describe:

- `--workspace <dir>` sets the repository root. It defaults to the current directory ([Using Agent in CLI](https://cursor.com/docs/cli/using)). Start the agent in the clone, not in the user profile.
- Permission globs: relative paths stay in the workspace; absolute paths can name files outside it. Deny wins ([Permissions](https://cursor.com/docs/cli/reference/permissions)).
- `--sandbox enabled|disabled` is a global flag ([Parameters](https://cursor.com/docs/cli/reference/parameters)). `agent sandbox run` is "workspace read/write", and its `--network` default is false (same page).
- Config key `sandbox.readBoundary` is `system` (default) or `workspace`. `sandbox.networkAccess` is a separate string. Windows config file: `$env:USERPROFILE\.cursor\cli-config.json` ([Configuration](https://cursor.com/docs/cli/reference/configuration)). The default read boundary is the whole system, so turning the sandbox on does not by itself hide the rest of the PC from reads.
- Ask mode does not edit files (section 1). `(?)` whether Ask mode on Windows will still run a read-only shell command. This note treats Ask as the mode for jobs that must not change anything.

`(?)` `--sandbox enabled` was not executed on Windows, and it was not executed on this Linux host either. The flag is documented. What the Windows process actually blocks was not observed.

Recommendation, from those docs:

- `--mode ask` for jobs that only look: list a Dropbox week folder, list `fhs-*` under the skills folder, read a report, explain a diff. Ask mode is not the mode for `git push`, the mirror copy, or `scp`.
- Agent mode, without `--force`, for clone, branch, and push of `feat/win-*`, and for walking through the mirror script or an `scp`. The CLI asks before each command. The mirror script still has its own `YES` prompt. That is the right default while the owner is at the PC.
- `--force` is for a headless run (`-p`) that must not stop on prompts, and only after the owner has already approved that run. It is a poor fit for the first mirror refresh and for any job that can write the live skills folder or send a file to the server, because it can run a command the script did not ask for. Deny rules for `Remove-Item` on the skills folder and for `ssh` remote commands other than `git-receive-pack` / `sha256sum` are the extra limit if a later plan uses `--force`. Those deny rules were not tested here.

## Owner checklist (PC side)

Blanks were for the owner. **Answered 2026-10-10** (recorded by Claude after the merge, per post-merge P1):

- `ssh dev-lxc-1 true` works without a password prompt: **yes** (lands as `root` on `dev-lxc-1`; Windows OpenSSH 9.5)
- `where git` output: **not installed** · OK to install Git for Windows: **yes**
- OK to install cursor-agent on the PC: **not needed**; the PC agent is **Claude Code** (owner: most users have Claude)
- Dropbox root path: **`C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services`** (confirmed)
- `C:\Users\mayur\.claude\skills` exists and lists `fhs-*`: **yes** (`fhs-payroll-adp`, `fhs-skills`)
- Is Documents redirected to OneDrive: `(?)` (the command printed nothing; probably yes, per an old note). The clone goes to `C:\fhs\fhs-skills` either way

## Summary: recommended setup, open (?) items

Recommended setup, once the owner has said yes to Git and to Cursor on the PC:

1. Install Git for Windows and choose **Use external OpenSSH** (section 2). Install Cursor with `irm 'https://cursor.com/install?win32=true' | iex`, then `agent login` (section 1).
2. Confirm `ssh dev-lxc-1 true` does not prompt. Then add `BatchMode yes` to that host block. Load a passphrase-protected key with `ssh-agent` (section 2).
3. `git clone dev-lxc-1:/root/fhs-skills` into a new folder, not into `C:\Users\mayur\.claude\skills`.
4. The Windows agent pushes only `feat/win-<lowercase-digits-hyphens>`. The hook in section 3 allows a fast-forward of that name and refuses `main`, any other name, a force-push, and a delete. Installing that hook on the server is a later plan. Until then, `receive.denyCurrentBranch` still refuses a push that updates the checked-out branch (section 3), and it does not refuse `feat/other`.
5. Mirror refresh is the script in section 4, after its own `YES`, and it does not delete Windows-only files. Each refresh is a separate owner OK.
6. A named report is `scp`'d to `dev-lxc-1:/root/fhs-skills/inbox/` and the `Get-FileHash` and `sha256sum` values are compared case-insensitively (section 5). `inbox/` stays out of git.
7. Looking at the PC is `--mode ask`. Doing the git or the copy is agent mode without `--force`, unless the owner has already approved a headless run (section 6).

Open `(?)` items:

- The PC `~/.ssh/config` `Host dev-lxc-1` lines (`User`, `HostName`, `IdentityFile`) were not read. The task says the login is root.
- `ssh dev-lxc-1 true` without a password, `where git`, install OK, Dropbox path, the skills folder, and OneDrive Documents are the checklist blanks.
- Whether the Windows installer creates a command named `cursor-agent` as well as `agent`.
- Whether `--sandbox enabled` on Windows enforces workspace writes and blocks network the way the parameter page describes for `agent sandbox run`.
- The PC directory for the clone, and the owner's real `core.autocrlf` if Git is already installed.
- Whether `/root/fhs-skills/inbox` exists. `fhsbuild` cannot list `/root/fhs-skills`.
- `BatchMode` and the PowerShell form of `NO_OPEN_BROWSER` were not run on the PC.

## Appendix

Throwaway directory: `/tmp/winres-ZMIt`. Created with `mktemp -d -t winres-XXXX`. It held `server/` (non-bare, `main` checked out), `pc/` (the clone), `pre-receive`, and `sample.txt`. It is deleted at the end of this task. Test 4 checks that the path is gone.
