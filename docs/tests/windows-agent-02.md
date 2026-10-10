# Test plan · windows-agent-02

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one PASS, FAIL or BLOCKED.
> Don't fix anything. If something fails, that's the result.
> Hand-off: "Run the test plan in docs/tests/windows-agent-02.md".

## What's being tested

- The `pre-receive` hook accepts only fast-forward `feat/win-*` pushes. It's the exact tested research text.
- The SSH gate allows only its listed commands, with fixed arguments.
- The two PowerShell scripts meet their static safety rules.
- After the merge: the real hook on the server, the real PC clone, the test push, the first mirror refresh, and the first report transfer.

Plan: `docs/plans/windows-agent-02.md` · Builder report: `/srv/fhs-build/reports/windows-agent-02.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/windows-agent-02` on `feat/windows-agent-02`, as `fhsbuild`; throwaway repos only under `T=$(mktemp -d -t wa02test-XXXX)` | run commands; edit nothing in the repo |
| ops | root on the server, run by the Ops agent | the output is pasted to you; you judge it |
| desktop | the owner's Windows PC, run by the owner (or a Claude Code session the owner starts, normal permissions, never bypassed) | the owner pastes the PowerShell output; you judge it |
| owner | the owner answers or confirms | record it verbatim |

No browser cases: nothing here uses a web page.

## Preconditions

- The builder report exists. Set `W=/srv/fhs-build/windows-agent-02` and `T=$(mktemp -d -t wa02test-XXXX)`. Delete `$T` at the end.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `cd $W && bash scripts/tests/test_windows_agent.sh; echo exit=$?` | every line PASS (H1–H10, G1–G16, S1–S6), `exit=0` | full output |
| T2 | shell | Independent hook check, **without** using the builder's harness: in `$T` make `server` (`git init -b main`, one commit; `main` checked out), copy `$W/scripts/git-hooks/pre-receive` into `server/.git/hooks/`, `chmod +x`, clone it to `pc`. From `pc`, push `feat/win-a` (new), then `main` (after a new commit), `feat/x`, a force-push of `feat/win-a` after `--amend`, and `git push origin --delete feat/win-a` | the first push is accepted; the other four are refused with `pre-receive hook declined` and a `refused:` line | commands + output |
| T3 | shell | `cmp $W/scripts/git-hooks/pre-receive <(sed -n '/^```sh$/,/^```$/p' $W/docs/research/windows-agent.md \| sed '1d;$d') && echo SAME` | `SAME` | output |
| T4 | shell | Independent gate check: `FHS_GATE_REPO=$T/repo FHS_GATE_INBOX=$T/inbox SSH_ORIGINAL_COMMAND='bash -i' bash $W/scripts/windows/ssh-gate.sh; echo exit=$?`, then the same with `"sha256sum $T/inbox/a b"`, with `"scp -t $T/inbox/.."`, and with `"git-upload-pack '$T/other'"` | each prints `refused` and `exit=1` | output |
| T5 | shell | Read `ssh-gate.sh` | no `eval`, no `sh -c`, no `bash -c`; each `exec` uses arguments from regex captures or fixed paths, never `$SSH_ORIGINAL_COMMAND` itself | quoted lines |
| T6 | shell | `grep -n 'Remove-Item' $W/scripts/windows/*.ps1; grep -n "Read-Host" $W/scripts/windows/refresh-mirror.ps1; grep -n -- "-ne 'YES'" $W/scripts/windows/refresh-mirror.ps1; grep -c 'Get-FileHash -Algorithm SHA256' $W/scripts/windows/*.ps1; LC_ALL=C grep -nP '[^\x00-\x7F]' $W/scripts/windows/*.ps1; grep -nP '\t' $W/scripts/windows/*.ps1` | no `Remove-Item`; one `Read-Host` and one `-ne 'YES'`; a count of at least 1 per file; no non-ASCII or tab | output |
| T7 | shell | Read `refresh-mirror.ps1` | parameters `-Clone`, `-MirrorRoot`, `-DryRun` with the plan's defaults; `-DryRun` exits before `Read-Host`; it refuses a `MirrorRoot` inside `Clone`; only `fhs-*` folders are walked; it prints `matched=` and `unmatched=` | quoted lines |
| T8 | shell | Read `send-report.ps1` | `-Name` validated with `^[A-Za-z0-9._-]{1,120}$` and `.`/`..` refused; `-SshHost` parameter (default `dev-lxc-1`); `scp -O` used; existence check before `scp` (exit 2); `$LASTEXITCODE` checked after each native command; case-insensitive hash compare; `MATCH` exits 0, `MISMATCH` exits 1 | quoted lines |
| T9 | shell | Read `docs/runbooks/windows-agent.md` | covers C1–C6, D1–D5, G1, rollback for each, the zip-before-refresh step, and the Claude Code guidance: `claude --permission-mode plan` to look, a normal session to do, no permission bypass unless approved; agent jobs use the `dev-lxc-1-agent` alias. It must not mention a Cursor agent on the PC | section list |
| T10 | shell | `git -C $W diff --name-only main...HEAD`; `git -C $W diff --check main...HEAD`; `git -C $W status --short`; `git -C $W ls-files -s scripts/git-hooks/pre-receive scripts/windows/ssh-gate.sh scripts/tests/test_windows_agent.sh` | only the six allowed files; no whitespace errors; clean; mode `100755` for the three | output |
| T11 | shell | `rm -rf "$T"; test -e "$T" && echo LEFT \|\| echo GONE` | `GONE` | output |

## Post-merge verification (not a gate; a failure opens a fix plan; the desktop tools aren't in use until P3–P5 pass)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P0 | owner | The PC checklist C1–C6 answers, as recorded on the hub | all answered; the clone folder named | verbatim answers |
| P1 | ops | After S1: `ls -l /root/fhs-skills/.git/hooks/pre-receive; cmp /root/fhs-skills/.git/hooks/pre-receive /root/fhs-skills/scripts/git-hooks/pre-receive && echo SAME`; after S2: `ls -ld /root/fhs-skills/inbox` | executable, `SAME`; inbox exists, mode `drwx------` | pasted output |
| P2 | desktop | D1: `git --version`; `git config --get core.sshCommand` (or the installer choice); `git clone dev-lxc-1:/root/fhs-skills <C6 folder>`; `git -C <folder> log -1 --format=%h` | clone succeeds without a password prompt; the hash equals server `git -C /root/fhs-skills rev-parse --short main` (Ops pastes it) | pasted output (both sides) |
| P3 | desktop + ops | D3: from the PC, push `feat/win-hello` (one file `docs/zz-win-hello.md`), then try `main`, `feat/other`, a force-push, a delete. Ops: `git -C /root/fhs-skills branch --list 'feat/win-*'`, then deletes it and shows `git status --short` | `feat/win-hello` accepted and listed on the server; the other four refused with `refused:`; after the delete: no `feat/win-*`, status clean | pasted output (both sides) |
| P4 | desktop + ops | D4: the owner zips `C:\Users\mayur\.claude\skills`; `refresh-mirror.ps1 -DryRun`; then a real run, typing `YES`. Then the owner pastes `Get-FileHash` lists (relative paths) of the PC clone's `skills\fhs-*` and of `C:\Users\mayur\.claude\skills\fhs-*`, plus `git -C C:\fhs\fhs-skills rev-parse --short HEAD`; Ops pastes `git -C /root/fhs-skills rev-parse --short main` | the script prints `unmatched=0`; every clone path appears in the mirror with an equal hash; the clone HEAD equals server main; any extra Windows-only files are listed, not deleted | pasted output (both sides) |
| P5 | desktop + ops | D5: `send-report.ps1 -Path <a real week-folder file> -Name <regex-safe name, e.g. 122_<start>_<end>_hours.txt>`; Ops: `sha256sum /root/fhs-skills/inbox/<name>; git -C /root/fhs-skills status --short` | the script prints `MATCH`; the hashes are equal; the status doesn't list the inbox file | pasted output |
| P6 | desktop + ops | G1 (required): through the `dev-lxc-1-agent` alias, `git fetch`, push `feat/win-gate-check`, `ssh dev-lxc-1-agent id`, then `send-report.ps1 -SshHost dev-lxc-1-agent ...`; Ops deletes `feat/win-gate-check` | fetch and push work; `id` prints `refused`; send-report prints `MATCH`; the branch is gone afterwards | pasted output |

Mark P0–P6 BLOCKED (owner / ops / desktop) until their output is pasted to you. Write them to
`/srv/fhs-build/reports/windows-agent-02-postmerge.md`.

## Results

Write `/srv/fhs-build/reports/windows-agent-02-test.md`:

```text
Test plan: windows-agent-02 · Branch: feat/windows-agent-02 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge. Use sudo, SSH anywhere, or install a hook outside `$T`.
