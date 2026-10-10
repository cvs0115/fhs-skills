# Agent task · windows-agent-02 · fix round 1 (build)

> **For the coding agent (Composer 2.5 via `agent`), as `fhsbuild`.** A fix round on `feat/windows-agent-02` (at `d1e073e`), under the approved
> plan `docs/plans/windows-agent-02.md`. Hand-off: "Do the task in /srv/fhs-build/reports/windows-agent-02-fix1.md".

## Context

Code review `docs/reviews/windows-agent-02-diff-r1.md` (APPROVE AFTER FIXES) found that `scripts/windows/send-report.ps1` runs
`scp -O -LiteralPath $Path ...`. `-LiteralPath` is a PowerShell cmdlet parameter, and native OpenSSH `scp` rejects it ("unknown option -- L"),
so no report would ever copy. The tester's static check didn't catch it.

## Steps

1. **`send-report.ps1`, the scp call:** invoke native scp exactly as the plan says: `scp -O $Path "${SshHost}:${remoteInbox}"`. Pass `$Path` as
   one argument. PowerShell quotes it if it has spaces. Keep `-LiteralPath` on `Get-FileHash` and `Test-Path`, never on native commands.
   Check `$LASTEXITCODE` after it.
2. **`send-report.ps1`, the existence check (review minor):** run `ssh $SshHost "test ! -e <remote file>"`, capture its output and
   `$LASTEXITCODE`, and decide:
   - exit 0 → continue
   - exit 1 with empty output → print `Remote file already exists: <name>` and `exit 2`
   - anything else (exit 255 = connection error, or output `refused` from the gate) → print `SSH check failed (exit <n>): <output>` and `exit 3`

   Don't rely on `Write-Error` under `$ErrorActionPreference = 'Stop'` to reach these exits. Use `Write-Host` (or `[Console]::Error.WriteLine`)
   and then an explicit `exit`.
3. **Runbook D3 (review minor):** name the test file exactly `docs/zz-win-hello.md`, as in the plan and test P3.
4. **Test harness** `scripts/tests/test_windows_agent.sh`, add static checks:
   - S7: no native command line in either `.ps1` passes a cmdlet-only parameter. Specifically, no line containing `scp ` or `ssh ` also
     contains `-LiteralPath`.
   - S8: `send-report.ps1` contains `exit 2` and `exit 3`, and an `scp -O` line with no `-LiteralPath`.

## You may edit only

`scripts/windows/send-report.ps1`, `docs/runbooks/windows-agent.md` (D3 file name only), `scripts/tests/test_windows_agent.sh` (S7, S8).

## You must not

Edit anything else, change git config, push, merge, or use sudo.

## Tests

1. `bash scripts/tests/test_windows_agent.sh; echo exit=$?` → all PASS, `exit=0`
2. `grep -n 'scp ' scripts/windows/send-report.ps1` → the `scp -O` line has no `-LiteralPath`
3. `git diff --name-only HEAD~1..HEAD` → only the three files above
4. `git diff --check main...HEAD` and `git status --short` → no output

## When done

Commit `send-report.ps1: native scp argv, explicit exit codes; runbook D3 name; static checks S7–S8 (fix r1 review)`, ending with
`Co-Authored-By: Composer 2.5 (cursor agent)` (one-shot author as before). Append a "Fix round 1" section to `/srv/fhs-build/reports/windows-agent-02.md`.
