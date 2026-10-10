# Review · windows-agent-02

2026-10-10 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: plan

## Verdict

APPROVE. The build may go ahead once this review is on `main` and the plan’s named prerequisite `feat/windows-research-01` is merged (`framework-setup-03` already is).

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- Post-merge P4 / done-check 7’s extra Ops command hashes server blobs (`sha256sum` under `/root/fhs-skills/skills`). Research §4 confirmed Git for Windows defaults `core.autocrlf=true`, so those hashes will not equal Windows `Get-FileHash` for text files even when the refresh is correct. The script already compares the right trees (PC clone working tree vs the mirror). Use that pair for the independent check; keep `unmatched=0` as the proof.
- `docs/specs/windows-agent.md` “Who runs it” still names Grok 4.7 High, which the 2026-10-10 included-models decision forbids. The plan cites included models and does not tell the builder to use Grok 4.7, but the builder is told to read that spec while writing the runbook. Name `composer-2.5` for PC agent-run jobs (and `--mode ask` to look) in the runbook outline so the spec line is not copied.
- The gate’s filename regex `^[A-Za-z0-9._-]{1,120}$` matches `.` and `..`. `scp -t /root/fhs-skills/inbox/..` would target the repo root. The task and T4 already refuse those names; say the same in the plan so the two files agree.
- Research §5: this host’s `scp` uses SFTP, not legacy `scp -t`. G1’s allow-list is `scp -t …`. Windows client behavior is `(?)`. If G1 is turned on, `send-report.ps1` should force legacy SCP (`scp -O`) so D5 can still match the gate, or leave G1 off until P6 proves it.
- D5 uses `-Path <a real week-folder report>` with default `-Name` equal to the file’s own name. Typical Dropbox PDF names have spaces and will fail the name regex. The runbook should pass a regex-safe `-Name` (or choose an extracted `<store>_<dates>_*.csv`).
