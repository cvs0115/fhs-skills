# Review · framework-setup-03

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not proceed until the model-role and hand-off contradictions are corrected and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- `docs/specs/framework-setup.md` still assigns builds and fresh test runs to Grok, contradicting the binding Composer decision, `CLAUDE.md`, and this plan. Include the spec in the pre-build documentation transition and update its current workflow.
- The research workflow remains unsafe. `docs/prompts/ops-cycle.md` instructs Ops to run `build.sh prepare` without `--role $ROLE` and diff review without `--writer $WRITER`; `build.sh collect` will also continue printing a reviewer command without `--writer`. For research, these commands select the wrong builder or a Grok reviewer for Grok-written work. Align the executable instructions and collect hand-off, and name the required changes in the plan and task.
- The planned `build.sh prepare` hand-off does not require `--force`, although `CLAUDE.md` and `docs/RUNBOOK.md` require Builder, Tester, and Researcher agents to run with it. Require `--force` in both role-specific `Start agent:` lines and verify it in the tests.

## Minors

- None.
