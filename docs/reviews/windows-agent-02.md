# Review · windows-agent-02

2026-10-10 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: plan

## Verdict

APPROVE. The build may go ahead once this review is on `main`.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

r2’s blockers are fixed: T9 matches Claude Code (C3); G1 is required in the plan, task, and P6; proof uses `dev-lxc-1-agent`; `scp -O` and `-SshHost` are specified. Spec, merged research, named files, served tree (`/root/fhs-skills` on `main`, hook only at S1, Windows mirror only at D4, builder clone `/srv/fhs-build/windows-agent-02`), no Toast/R365/ADP edits, and real-data post-merge checks (PC push, hash refresh, week-folder `MATCH`) all hold. Prerequisites `windows-research-01` and `framework-setup-03` are already on `main`.

## Minors

- In [docs/plans/windows-agent-02.md](docs/plans/windows-agent-02.md) “Files the builder may edit”, `send-report.ps1` still shows `ssh dev-lxc-1` for the existence check and `sha256sum`. Treat those as `ssh <SshHost>` (default stays `dev-lxc-1`) so that section matches task step 3 and done-check 9 / P6. Close: implement `-SshHost` on scp and both ssh calls; do not stop.
- Done-check 7 / P4 ask for `unmatched=0` and Windows-only files. Research §4 counts extras as unmatched and then prints `Still only on Windows`. Close: a good D4 is every clone `skills\fhs-*` path present in the mirror with the same `Get-FileHash`; extras listed and not deleted; the printed `unmatched` may equal that extra count.
- Sequence §8 does G1 before D1–D5 (needed: D2’s `IdentityFile` is the G1 key). The live-systems table and the task runbook outline still put G1 last. Write the runbook as generate key → Ops gate line → alias `dev-lxc-1-agent` → D1–D5.
- Default `-Name` must be the source file’s leaf name (`Hours Details.pdf` as `-Name` fails the regex). D5 already passes a regex-safe `-Name`; keep that in the runbook.
- Gate refuse list includes `test ! -e /etc/x`; G9–G16 omit it. Harmless if the allow-list is exact; add the case or drop it from the plan list.
- Research §7 still says to install Cursor on the PC. T9 forbids a Cursor agent in the runbook; follow the task’s Claude Code outline, not that summary.
