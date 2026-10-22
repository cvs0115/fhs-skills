# Review · payroll-adp-01-diff

2026-10-22 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: diff

## Verdict

APPROVE. Merge of `feat/payroll-adp-01` may go ahead: the diff matches the approved plan and task, stays in the named files, and pre-merge T1–T8 PASS with evidence that matches the code and fixtures. Post-merge P1–P2 stay BLOCKED until the owner OKs a Windows mirror refresh and pastes the real Week 42 / Week 40 runs.

## Majors

- None.

## Minors

- Contributor issues are `extend`ed onto the already-sorted `find_issues` list in [`skills/fhs-payroll-adp/scripts/payroll.py`](skills/fhs-payroll-adp/scripts/payroll.py), so a High contributor line can print after Medium shift lines in stdout and the HTML report.
- The NCR fixture’s tip files already match, so T4 (`ncr_msg=0`) would still pass if the High check ran on `ncr`. The `pos != toast_r365` gate in code is correct; the fixture just does not prove it.
- [`skills/fhs-payroll-adp/SKILL.md`](skills/fhs-payroll-adp/SKILL.md) step 6 requires listing saved reports in the concerns note before ADP entry; step 9 still writes `_concerns.md` after ADP. An agent should record the file list in step 6 and copy it into the note in step 9.
- [`skills/fhs-payroll-adp/references/extract-formats.md`](skills/fhs-payroll-adp/references/extract-formats.md) says `_tip_sources.txt` is one line per source per day with card tips **> 0**, while `contributor-ok` includes a $0 line that the script correctly ignores.
