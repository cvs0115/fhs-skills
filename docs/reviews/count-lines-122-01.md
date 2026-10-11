# Review · count-lines-122-01

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The plan, researcher task, capture task (read with the plan), test plan, brief, and spec agree on verify-only research, the served-tree and clone rules, R365 read-only PC capture, and a capture-backed done-check; Ops may commit the bundle and proceed to the owner gate and capture.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- [`docs/prompts/count-lines-122-01.md`](docs/prompts/count-lines-122-01.md) begins with a drafter meta line (`The only minor that applies to this researcher task is Tests vs T1…`) before the `# Agent task` header. Delete that line before commit so the hand-off file matches other task prompts and does not look like a waived review instruction.
- Plan done-check §2 defines **looks dead** as no receipt in captured history plus qty 0 on every count; the researcher task §4.5 step 3 also requires that purchase history **actually covers** the stated range (otherwise **can't tell**). [`docs/tests/count-lines-122-01.md`](docs/tests/count-lines-122-01.md) T3 does not assert coverage—only qty and `none in captured history`. Optional: add the same coverage sentence to the plan done-check so plan, task, and tester expectations stay aligned (behavior is already correct in the task).
- [`docs/plans/count-lines-122-01.md`](docs/plans/count-lines-122-01.md) §Where the researcher works still says the researcher “creates `feat/count-lines-122-01` in that clone per the task” while `prepare` only clones `main`; same wording as [`docs/plans/invoices-122-01.md`](docs/plans/invoices-122-01.md)—no change required unless you want one clarifying phrase (“branch created in clone, not by `prepare`”).
