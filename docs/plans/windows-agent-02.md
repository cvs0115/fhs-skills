# Plan · windows-agent-02 · A coding agent on the Windows desktop for desktop-only steps

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/windows-agent-02.md` holds an APPROVE.
The reviewer checks this plan, its task file `docs/prompts/windows-agent-02.md`, and its test plan `docs/tests/windows-agent-02.md` together.
It replaces the draft `docs/plans/windows-agent-01.md` (APPROVE AFTER FIXES in `docs/reviews/windows-agent-01-r1.md`).

- Hub project: `projects/server-move` (https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG).
- Spec: `docs/specs/windows-agent.md`. Research: `docs/research/windows-agent.md`, on branch `feat/windows-research-01` (tested ALL PASS).
  **Prerequisite:** that branch is merged first, so the note and its `tech-stack.md` facts are on `main`.
- Also a prerequisite: framework-setup-03 is merged (`build.sh prepare --role`, `review.sh --writer`, included models).
- Decisions that bind it (hub log 2026-10-10):
  - an agent on the Windows desktop; PC → server only, no server → PC link
  - development only on dev-lxc-1; runtime may be the desktop
  - included Cursor models only (Composer 2.5 builds, tests and runs ops; Cursor Grok 4.6 Extra High reviews Composer's code)
  - the server repo is the only master (2026-10-09); reports never go in git
- `ROLE=build`, `WRITER=composer`.

## Verdict

Build.

## What changes, in plain words

Your Windows PC gets a few small, checked tools for the jobs that only work there:
- **Pushing work back.** A PC agent can push its work back to the server, but only on branches named `feat/win-…`. The server refuses
  everything else: `main`, other names, rewriting history, deleting.
- **Refreshing the skill copy.** A refresh script makes the Windows copy of the skills match the server's reviewed `main`. It shows you
  the differences first, copies only after you type `YES`, never deletes Windows-only files, and proves the result by hash.
- **Sending reports.** A send script copies a named report from your Dropbox to the server's `inbox/` and proves the copy by hash.
- **A tighter key for the agent.** A required server-side gate (owner, 2026-10-10) lets the PC agent's SSH key do only those three things (git fetch and
  push, copy into `inbox/`, hash a file there). The agent then can't run arbitrary root commands. It's required (owner, 2026-10-10). Agent jobs connect through the `dev-lxc-1-agent` alias,
  which uses that key, and the owner's own `dev-lxc-1` alias stays unrestricted for the owner.

## How this plan answers the windows-agent-01 review (r1)

| r1 major | Answer here |
|---|---|
| No spec, research after design | The spec exists (`docs/specs/windows-agent.md`). The research is done and tested ALL PASS, and its merge is a prerequisite. The design below uses its verified findings (hook text, push matrix, mirror script, scp + hash) |
| Not every edited file named | "Files the builder may edit" lists every repo file and the one outside-repo report path |
| "Live before merge: nothing changes" was wrong | "Live systems touched" splits it: before the merge, nothing live changes. Everything live (hook install, PC installs, clone, first refresh, first transfer) comes **after** the merge, each with its own owner OK, listed |
| Mirror check was only a dry run | Post-merge D4 is a **real** refresh (after your OK), with hash comparison of every `fhs-*` file against server `main`. Nothing on the desktop counts as live until it passes |
| Minor: "bare" repo; test-branch cleanup | The server repo is non-bare (research §3). Every test branch and test file has a cleanup case |

## Pre-build gate: your PC checklist (answered 2026-10-10)

The owner answered the research checklist on 2026-10-10 (r2 revision; evidence is on the hub `log`, and the answers are recorded in
`docs/research/windows-agent.md`):

| ID | Question | Answer |
|---|---|---|
| C1 | `ssh dev-lxc-1` without a password? Which user? | **Yes.** Key login works; `ssh dev-lxc-1 "hostname; whoami"` → `dev-lxc-1`, `root`. Windows OpenSSH 9.5 at `C:\WINDOWS\System32\OpenSSH\ssh.exe` |
| C2 | Git on the PC? OK to install? | **Not installed. OK to install** Git for Windows (`winget install --id Git.Git -e`, using the Windows OpenSSH) |
| C3 | Which agent runs PC jobs? | **Claude Code** (already installed; payroll runs there). Owner: "most users would have Claude". No Cursor agent on the PC |
| C4 | Dropbox root | `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services` (confirmed) |
| C5 | `C:\Users\mayur\.claude\skills` lists `fhs-*`? | **Yes:** `fhs-payroll-adp`, `fhs-skills` |
| C6 | Documents → OneDrive? Clone folder? | Clone folder **`C:\fhs\fhs-skills`** (outside OneDrive and Dropbox). The OneDrive redirect is `(?)` (probably yes, per an old note) and doesn't matter for the clone |
| G1 | Restricted SSH key for the PC agent? | **Yes: required, not optional** (owner, 2026-10-10) |
| S1/S2 | Ops installs the hook and creates `inbox/`? | **Yes**, after code review APPROVE + tests ALL PASS (owner, 2026-10-10) |

## Where it runs

- **Server (dev-lxc-1):** the `pre-receive` hook (installed in `/root/fhs-skills/.git/hooks/`) and the SSH gate (required). Everything is
  authored and tested here.
- **Windows desktop:** `scripts/windows/refresh-mirror.ps1` and `scripts/windows/send-report.ps1`, run from the PC clone.
  - Windows apps needed: Git for Windows (using Windows OpenSSH), Windows OpenSSH `ssh`/`scp`, PowerShell 5.1 or later, Dropbox (for
    report files), and **Claude Code** for agent-run jobs (Claude in Chrome for browser tasks).
  - Deploying a skill to the desktop is a mirror refresh, a separate owner OK each time.

## Files the builder may edit (in its clone)

- `scripts/git-hooks/pre-receive` (new): the hook from research §3, **byte for byte**, kept executable (`git update-index --chmod=+x`).
- `scripts/windows/refresh-mirror.ps1` (new): the research §4 script, with these changes:
  - `-Clone` and `-MirrorRoot` become parameters with the defaults `C:\fhs\fhs-skills` and `C:\Users\mayur\.claude\skills`, so the C5
    and C6 answers don't need an edit.
  - A `-DryRun` switch prints the three lists and exits 0 without asking or copying.
  - The script never calls `Remove-Item`, never touches anything that isn't `fhs-*`, and refuses to run if `-MirrorRoot` is inside the clone.
  - It stays ASCII, with no BOM, so PowerShell 5.1 reads it correctly.
- `scripts/windows/send-report.ps1` (new):
  - Parameters `-Path <file>` (required), `-Name <target file name>` (default: the file's own name, validated `^[A-Za-z0-9._-]{1,120}$`, and
    not `.` or `..`), and `-SshHost` (default `dev-lxc-1`; agent jobs pass `dev-lxc-1-agent`).
  - Runs `scp -O <Path> <SshHost>:/root/fhs-skills/inbox/<Name>`. The `-O` forces the classic `scp -t` remote command the gate allows; OpenSSH
    9.5 would default to SFTP. Then `Get-FileHash -Algorithm SHA256` locally and
    `ssh dev-lxc-1 "sha256sum /root/fhs-skills/inbox/<Name>"`.
  - Compares the two case-insensitively and prints `MATCH` (exit 0) or `MISMATCH` (exit 1). It never overwrites an existing inbox file:
    it checks first with `ssh dev-lxc-1 "test ! -e /root/fhs-skills/inbox/<Name>"` and exits 2 if the file exists.
- `scripts/windows/ssh-gate.sh` (new, server side, bash): a forced-command gate for the dedicated PC-agent SSH key (required). It reads
  `$SSH_ORIGINAL_COMMAND` and allows exactly these:
  - `git-upload-pack '/root/fhs-skills'`, and the same with `/root/fhs-skills/` or without quotes
  - `git-receive-pack '/root/fhs-skills'`, same forms
  - `scp -t /root/fhs-skills/inbox/<name>`, where the name matches `^[A-Za-z0-9._-]{1,120}$` and isn't `.` or `..`
  - `test ! -e /root/fhs-skills/inbox/<name>`
  - `sha256sum /root/fhs-skills/inbox/<name>`
  
  It `exec`s the allowed command with fixed arguments (never through `sh -c` on the raw string). Anything else prints `refused` and
  exits 1. `FHS_GATE_REPO` and `FHS_GATE_INBOX` env overrides exist **for tests only**, and the tests set them to `mktemp -d` paths.
- `scripts/tests/test_windows_agent.sh` (new, bash, runs as `fhsbuild` in `mktemp -d` only). Two matrices:
  - **(a) The hook push matrix** from research §3, against a throwaway non-bare server repo with `main` checked out and the hook from
    `scripts/git-hooks/pre-receive` installed: new `feat/win-hello` accepted; fast-forward accepted; `main` refused; `feat/other`
    refused; force-push refused; delete refused; `feat/win-Upper_Case` refused; `feat/win-` refused; refs afterwards = only `main` +
    `feat/win-hello`; the server still on `main`.
  - **(b) The gate matrix:** each allowed command form is accepted, and these are refused: `bash`, `sh -c id`,
    `git-receive-pack '/etc'`, `scp -t /root/fhs-skills/inbox/../x`, `scp -f /root/fhs-skills/inbox/a`, `sha256sum /etc/shadow`,
    `test ! -e /etc/x`, an empty command, and a command with `;` or `$(`.
  - For accepted cases the gate is run with the real binaries replaced by stubs on `PATH` that echo their argv, so the test sees what
    would be exec'd without running it.
  - Plus static checks on the two `.ps1` files: no `Remove-Item`; `Read-Host` followed by an exact `-ne 'YES'` check in
    refresh-mirror; `Get-FileHash` with `-Algorithm SHA256` present in both (other arguments such as `-LiteralPath` allowed); no tab characters; ASCII only.
- `docs/runbooks/windows-agent.md` (new): the owner's steps, in order.
  - PC setup D1–D3, with the C1–C6 answers they need.
  - Starting a PC agent (Claude Code): `claude --permission-mode plan` to look (read-only), a normal session to do, where it asks before
    each command. Never use permission bypass unless the owner approved that run. Agent jobs use the restricted key through the SSH alias
    `dev-lxc-1-agent` (G1). The owner's own `dev-lxc-1` alias stays for the owner.
  - Running a refresh (dry run first) and sending a report.
  - Turning the SSH gate on and off.
  - Rollback: remove the hook, remove the gate key line, delete the PC clone.
- Outside the repo, only: the report `/srv/fhs-build/reports/windows-agent-02.md`.

## Files the builder must not edit

Everything else, in particular `skills/**`, `shared/**`, `docs/plans/**`, `docs/reviews/**`, `docs/prompts/**`, `docs/tests/**`, `CLAUDE.md`,
`scripts/build.sh`, `scripts/review.sh`, `scripts/lib/**`, `.gitignore`, `.env*`. The builder never touches `/root`, any `.git/hooks`
outside its `mktemp -d`, or the PC.

## Live systems touched

**Before the merge:** nothing live. The builder and tester work only in `/srv/fhs-build/windows-agent-02` and `mktemp -d`. No hook is
installed, nothing changes on the PC, and no SSH key changes.

**After the merge**, each item is a separate owner OK, run in this order and recorded in the hub `log`:

| Step | What | Who | Needs | Rollback |
|---|---|---|---|---|
| S1 | Install the hook: `install -m 755 /root/fhs-skills/scripts/git-hooks/pre-receive /root/fhs-skills/.git/hooks/pre-receive` (from merged `main`, a stable path) | Ops (root) | merge + owner OK | `rm /root/fhs-skills/.git/hooks/pre-receive` |
| S2 | `install -d -m 700 /root/fhs-skills/inbox` if it doesn't exist (it's gitignored) | Ops | owner OK | leave it, it's empty |
| D1 | Install Git for Windows (external OpenSSH) and clone `git clone dev-lxc-1:/root/fhs-skills <C6 folder>` | Owner on the PC | C1, C2, C6 | delete the folder |
| D2 | No install: Claude Code is already on the PC. Confirm Claude in Chrome is set up for browser tasks, and add the `dev-lxc-1-agent` SSH alias (`Host dev-lxc-1-agent`, `HostName` = dev-lxc-1's address, `User root`, `IdentityFile ~/.ssh/fhs_agent_ed25519`) | Owner on the PC | C3, G1 | remove the alias |
| D3 | Push a test branch `feat/win-hello` with one file `docs/zz-win-hello.md` from the PC; see it on the server; then Ops deletes it server-side (`git -C /root/fhs-skills branch -D feat/win-hello`; the hook only applies to pushes) | Owner + Ops | S1, D1 | same delete |
| D4 | First real mirror refresh: `refresh-mirror.ps1 -DryRun`, then a real run, typing `YES` | Owner on the PC | D1, C5, owner OK | the script never deletes. To undo, restore the previous Windows copy from its backup (the runbook says to zip `C:\Users\mayur\.claude\skills` first) |
| D5 | First report transfer: `send-report.ps1 -Path <a real week-folder report>` | Owner on the PC | C1, C4, S2 | `rm /root/fhs-skills/inbox/<name>` (Ops) |
| G1 (required, owner OK 2026-10-10) | Generate `fhs_agent_ed25519` on the PC (`ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\fhs_agent_ed25519`). Then turn on the SSH gate: a dedicated key for the PC agent in root's `authorized_keys` with `command="/root/fhs-skills/scripts/windows/ssh-gate.sh",no-pty,no-port-forwarding,no-agent-forwarding,no-X11-forwarding` | Owner decides; Ops installs | owner OK | remove that one line |

Nothing touches Toast, R365, ADP or payroll. The payroll skills on Windows change only when D4 runs.

## Done-check (real outcome)

**Merge gate (all before the merge):**
1. The builder's and a fresh tester's runs of `bash scripts/tests/test_windows_agent.sh` pass: the hook matrix and the gate matrix,
   with real `git` against throwaway repos.
2. `git diff --name-only main...feat/windows-agent-02` lists only the files under "Files the builder may edit".
3. `cmp scripts/git-hooks/pre-receive <(sed -n '/^```sh$/,/^```$/p' docs/research/windows-agent.md | sed '1d;$d')` → no difference
   (the hook is the tested research text).
4. Code review (Cursor Grok 4.6 Extra High, `--writer composer`) is APPROVE before any of the branch's files is used as root.

**Post-merge verification** (not a gate; a failure opens a fix plan; the desktop tools aren't "in use" until D3–D5 pass):
5. S1: `ls -l /root/fhs-skills/.git/hooks/pre-receive` is executable, and `cmp` against `scripts/git-hooks/pre-receive` shows no difference.
6. D3 from the real PC: `feat/win-hello` accepted. A push to `main`, to `feat/other`, a force-push and a delete are each refused with the
   hook's `refused:` message. Afterwards the server branch is deleted, and `git -C /root/fhs-skills status --short` is clean.
7. D4: after the real refresh, the script prints `unmatched=0` plus any Windows-only files. The independent check compares the same pair the
   script compares, the **PC clone's** `skills\fhs-*` vs the mirror, both hashed on the PC with `Get-FileHash` (so `core.autocrlf` can't cause
   false mismatches): same relative paths and hashes. Ops separately confirms the PC clone's `HEAD` equals server `main`.
8. D5: `send-report.ps1 -Path <file> -Name <regex-safe name, e.g. 122_2026-09-21_2026-10-04_hours.txt>` prints `MATCH`, and Ops sees the file in `/root/fhs-skills/inbox/` with the same `sha256sum`. `git status --short`
   doesn't show it (gitignored).
9. G1 (required): through the gated alias, `git fetch dev-lxc-1-agent:...` and a `feat/win-*` push work, `ssh dev-lxc-1-agent id` prints
   `refused`, and `send-report.ps1 -SshHost dev-lxc-1-agent ...` prints `MATCH`.

## Sequence

1. Prerequisites merged (windows-research-01, framework-setup-03).
2. Ops: `build.sh prepare docs/plans/windows-agent-02.md windows-agent-02 --role build`.
3. Builder (`composer-2.5`, `fhsbuild`) builds.
4. A fresh Tester (`composer-2.5`) runs the shell cases.
5. Ops: `build.sh collect windows-agent-02 --role build`.
6. Code review gate: `review.sh --diff feat/windows-agent-02 --writer composer`, which must APPROVE.
7. Merge (no root-run pre-merge cases: the hook and gate only run in `mktemp -d` before the merge).
8. Post-merge S1–S2 (Ops, owner OK), then G1, then D1–D5 (the C answers are in). Results go to
   `/srv/fhs-build/reports/windows-agent-02-postmerge.md`, and the Tester records them.

Every review file is committed to main as the next `-rN` / `-diff-rN`, renamed before any new review of the same subject.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`. This plan changes no `skills/` file. The hook goes live only at S1, after the
  merge and an OK. Before S1, `receive.denyCurrentBranch` (default `refuse`) still blocks pushes to `main`, but not other names
  (research §3).
- **Windows mirror:** unchanged until D4.
- **Builder tree:** `/srv/fhs-build/windows-agent-02`.

## Where the builder works

`/srv/fhs-build/windows-agent-02`, branch `feat/windows-agent-02`, cut from `main` by `build.sh prepare`.

## What stays

The server repo is the only master, and no one pushes `main` from the PC. Payroll on Windows is unchanged until an approved refresh.
Reports never go in git. The server never connects to the PC. Toast, R365 and ADP aren't touched.
