# Review · windows-agent-02

2026-10-10 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not proceed until the merge-gate test and the required SSH-gate proof match owner C3/G1 and the plan’s own Claude Code / `dev-lxc-1-agent` design.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- Pre-merge T9 in `docs/tests/windows-agent-02.md` still requires the runbook to contain Cursor `--mode ask` / no `--force`. Owner C3, the plan, and the task say the PC agent is Claude Code (`claude --permission-mode plan` to look; a normal session to do; never bypass permissions unless that run was approved; no Cursor agent on the PC). T9 is a merge-gate case: a runbook that follows the plan will fail T9, or the builder will copy Cursor flags that contradict C3. Change T9 (and the test plan’s “without `--force`” desktop line) to the Claude Code flags so the three files agree.

- Owner G1 is **required, not optional**. The task already says that. The plan’s plain-words section still says “You decide whether to turn it on,” done-check 9 and test P6 still say “only if turned on,” and the builder is told to stop if the plan and task disagree. Make G1 required in all three files (install-time owner OK stays). The proof must use the gated alias: done-check 9 / P6’s `ssh dev-lxc-1 id` will not print `refused` while the owner’s `dev-lxc-1` alias stays unrestricted, which D2 says it must. Use `ssh dev-lxc-1-agent id`. `send-report.ps1` as specified talks to `dev-lxc-1` with plain `scp`; that path never hits the gate, and OpenSSH 9.5 (C1) defaults to SFTP rather than the gate’s `scp -t`. For agent-run D5/P6, point ssh/scp at `dev-lxc-1-agent` and use `scp -O` so the remote command is the `scp -t` form the gate allows.

## Minors

- Done-check 7 / P4’s extra Ops `sha256sum` of `/root/fhs-skills/skills` will not match Windows `Get-FileHash` for text files when Git for Windows uses `core.autocrlf=true` (research §4). The script already compares the right trees (PC clone working tree vs the mirror). Use that pair for the independent check; keep `unmatched=0` as the proof.

- The gate filename regex `^[A-Za-z0-9._-]{1,120}$` matches `.` and `..`. The task and T4 already refuse those names; say the same in the plan so the two files agree.

- D5 uses `-Path <a real week-folder report>` with default `-Name` equal to the file’s own name. Downloaded PDFs often have spaces and will fail the name regex. The runbook should pass a regex-safe `-Name`, or use an extract file such as `122_*_hours.txt`.

- `docs/specs/windows-agent.md` still says the PC agent is “cursor-agent (Grok 4.7 High)” and still has the Git / cursor-agent `[NEEDS CLARIFICATION]`. The builder is told to read that spec while writing the runbook. The task already names Claude Code; keep that, and do not copy the spec’s Grok 4.7 line.
