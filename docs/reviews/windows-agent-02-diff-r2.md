# Review · windows-agent-02-diff

2026-10-10 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: diff

## Verdict

APPROVE. The merge may go ahead: r1’s `scp -LiteralPath` major is fixed, and the branch still matches the approved plan.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

r1 (`docs/reviews/windows-agent-02-diff-r1.md`) blocked merge because `scp -O -LiteralPath` is `unknown option -- L` on this host (and on Windows OpenSSH 9.5). At `1cd8c98`, [`scripts/windows/send-report.ps1`](scripts/windows/send-report.ps1) is `scp -O $Path "${SshHost}:${remoteInbox}"`; `-LiteralPath` stays only on `Get-FileHash` / `Test-Path`. The existence check captures ssh output and uses `Write-Host` plus `exit 2` (file exists) / `exit 3` (other ssh/gate failure). Runbook D3 names `docs/zz-win-hello.md`. Harness S7–S8 lock the scp argv.

`git diff --name-only main...feat/windows-agent-02` is exactly the six files the plan named. Hook `cmp` vs research §3 is `SAME`. Modes `100755` on the hook, gate, and harness. Tester T1–T11 ALL PASS at `1cd8c98`; P0–P6 correctly not run. Served tree is `/root/fhs-skills` on `main` with no `skills/` edits; hook, gate, and PC tools go live only after merge plus owner OK (S1–S2, G1, D1–D5). No Toast/R365/ADP. `inbox/` stays gitignored. Gate has no `eval` / `sh -c` / `bash -c`; each `exec` uses `$repo` or `"$inbox/$name"` from `BASH_REMATCH`, never `$SSH_ORIGINAL_COMMAND`. All three remote calls use `$SshHost`.

## Minors

- `$ErrorActionPreference = 'Stop'` plus `ssh … 2>&1 | ForEach-Object` can still turn native stderr into a terminating error on some PowerShell versions; the new exit 2/3 branches themselves match the fix task.
- MirrorRoot-inside-Clone uses `StartsWith` without a trailing-separator bound (`C:\fhs\fhs-skills` would also match `C:\fhs\fhs-skills-extra`). The planned defaults do not collide.
- Post-merge P4 in [`docs/tests/windows-agent-02.md`](docs/tests/windows-agent-02.md) still asks for printed `unmatched=0`; the runbook (plan-review r3) treats Windows-only extras as unmatched. After merge, judge D4 by clone-vs-mirror hashes and listed extras, not the printed count alone.
