# Review · payroll-adp-02

2026-10-22 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The plan, task file, and test plan match the brief and the four payroll-adp-01 diff minors; served tree, file allowlists, live-system scope, and real-data done-check are stated correctly, so the docs may be committed and the build may proceed after sequence step 1.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- Done-check in [docs/plans/payroll-adp-02.md](docs/plans/payroll-adp-02.md) (line 53) says every High comes before every Medium and **Low**; severities in code and everywhere else are **Info** (`HIGH`, `MEDIUM`, `INFO` in `payroll.py`). Align wording with the brief and test plan.
- After the planned sort, `issues.insert(0, …)` for leftover tips still runs unchanged, so a “Tips not fully paid out” High can sit ahead of other Highs by employee order. That is pre-existing and explicitly kept; builders should not “fix” it while doing the contributor-order sort.
- Brief line 14 (“step numbers and headings otherwise stay”) is looser than the plan/task retitle of step 6’s heading; the retitle is required so step 6 no longer names the concerns note before ADP. Only step 6’s heading should change among step headings.
- T4 / task test 4 do not grep for “reply” or “run notes” in step 6; the task step 4 text carries that requirement. A builder who only satisfies T4 could still drift from the design—worth a quick human read of step 6 prose in the diff review, not a plan blocker.
