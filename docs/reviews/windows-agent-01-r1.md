# Review · windows-agent-01

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not proceed until the required spec and research precede a revised, re-reviewed plan.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- No subject spec exists, and the plan places research after design. `CLAUDE.md` requires new scripts to follow spec → research → plan → review → build. Complete the spec and `docs/research/windows-agent.md`, then revise and re-review the Stage B design using those verified findings.
- “Files the builder may edit” omits `docs/research/windows-agent.md` and the `docs/builds/windows-agent-01.md` report that `scripts/build.sh` will create. Every edited file must be authorized explicitly.
- “Live before merge: nothing changes” is incorrect. The done-check requires Windows installations and a clone, installation of `/root/fhs-skills/.git/hooks/pre-receive`, server branches, and a transferred report before merge. State these pre-merge live changes and their owner approvals accurately.
- The mirror-refresh done-check is only a dry run against an undefined `<last-mirrored>` revision. It does not prove that the script correctly updates the live Windows skills. After a separate owner OK, run a real refresh and compare the resulting mirror contents or hashes with server `main`.

## Minors

- The diagram calls the server repository “bare” even though `/root/fhs-skills` is a checked-out, non-bare repository.
- Add cleanup for the `feat/win-hello` test branch and its test file.
