Confirmed `scp -O -LiteralPath` is rejected by OpenSSH (`unknown option -- L`). That breaks the plan’s send-report success path; the rest of the diff matches the allowed files, hook text, and pre-merge tests.

# Review · windows-agent-02-diff

2026-10-10 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The merge may not go ahead until `send-report.ps1` invokes native `scp` with the plan’s argv.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- [`scripts/windows/send-report.ps1`](scripts/windows/send-report.ps1) line 37 runs `scp -O -LiteralPath $Path "${SshHost}:${remoteInbox}"`. `-LiteralPath` is a PowerShell cmdlet parameter (`Get-FileHash`, `Copy-Item`, `Test-Path` in the same branch). Native OpenSSH `scp` does not have it. On this host `scp -O -LiteralPath …` prints `scp: unknown option -- L` and does not copy. C1 is Windows OpenSSH 9.5, same option set. The plan and task require `scp -O <Path> <SshHost>:/root/fhs-skills/inbox/<Name>` so the remote command is the gate’s `scp -t` form. D5 / done-check 8 / P5 / P6 `MATCH` cannot happen until `-LiteralPath` is removed from the `scp` call (keep it on `Get-FileHash` / `Test-Path`). Pre-merge T8 only *read* for `scp -O`, so tester T8 PASS and builder 6/6 do not cover this. Other merge-gate items hold: `git diff --name-only main...feat/windows-agent-02` is the six named files; hook `cmp` vs research §3 is `SAME`; modes `100755` on the hook, gate, and harness; tester T1–T11 ALL PASS at `7876c50` (those six files unchanged at `d1e073e`); P0–P6 correctly not run; served tree is `/root/fhs-skills` on `main` with no `skills/` edits; hook/gate/PC live only after merge + owner OK (S1–G1, D1–D5); no Toast/R365/ADP; inbox stays gitignored.

## Minors

- Same script: `$ErrorActionPreference = 'Stop'` plus `Write-Error` may never reach `exit 2` when the remote file exists, and any non-zero `ssh` (connection error, gate `refused`) is labeled “Remote file already exists.”
- Runbook D3 says “a small file under `docs/`”; plan D3 and test P3 name `docs/zz-win-hello.md`.
