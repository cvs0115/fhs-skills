# Review · count-lines-122-01

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The plan, researcher task, capture task (checked with the plan), test plan, brief, and spec align on verify-only research, served-tree rules, R365 read-only scope, and a capture-backed done-check; Ops may commit the bundle and run capture after the owner gate.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- [`docs/plans/count-lines-122-01.md`](docs/plans/count-lines-122-01.md) done-check §2 lists group definitions but not assignment order when more than one could apply; [`docs/prompts/count-lines-122-01.md`](docs/prompts/count-lines-122-01.md) §4.5 step 2 fixes priority (`other Cheney item` → `slow mover` → `looks dead` → `can't tell`). Add the same ordered rules to the plan so plan and task cannot diverge.
- Plan §Sequence step 1 commits [`docs/prompts/count-lines-122-01-capture.md`](docs/prompts/count-lines-122-01-capture.md), but `scripts/build.sh prepare` only requires plan, researcher prompt, tests, and review on `main` (not the capture prompt). Either extend the prepare gate or state explicitly in Sequence that a missing capture file on `main` blocks PC capture before `prepare`.
- Plan §Test plan / report line still says “Builder and tester reports”; this job is research (`ROLE=research`) — say Researcher and tester for consistency with [`docs/prompts/ops-cycle.md`](docs/prompts/ops-cycle.md).
- [`docs/prompts/count-lines-122-01-capture.md`](docs/prompts/count-lines-122-01-capture.md) header still says “Plan only, not approved”; strip or replace when committing after APPROVE (same pattern as other Grok capture tasks).
- After step 1 lands on `main`, the PC clone at `C:\fhs\fhs-skills` needs a refresh before capture so it has the approved capture task; add one line to Owner steps or Sequence (mirrors invoices-122-01 practice).
- Researcher §Tests in the task file check `summary_sum == 108` but not `group_mismatch` / `empty_cells` / `headings_ok` that [`docs/tests/count-lines-122-01.md`](docs/tests/count-lines-122-01.md) T1 requires; optional alignment so the researcher catches tester failures earlier.
- Plan §Where the researcher works ties `feat/count-lines-122-01` to `prepare`; `prepare` only clones `main` — the feature branch is created in the clone per the task. Wording tweak only (`invoices-122-01` uses the same phrase).
