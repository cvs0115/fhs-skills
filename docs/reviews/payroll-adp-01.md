# Review · payroll-adp-01

2026-10-22 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The plan, task file, and test plan match the brief and CLAUDE.md; the builder may proceed after this review is committed to `main` with the plan, prompt, and test plan.

## Majors

- None.

## Minors

- In [docs/plans/payroll-adp-01.md](docs/plans/payroll-adp-01.md) design §2, the kiosk skip list is shorthand and omits two issue titles the task and T1 expect: `Clock-out after store hours` and `Shift much longer than usual`. The task file list is authoritative; no plan edit required if the builder follows the prompt.
- Design §3 vs task step 6: a date wholly missing from `_tip_contributors` is one High in the plan prose but “each Card Tips > 0 line” in the task (multiple Highs possible). Fixtures use a single line; align implementation with the task.
- PDF gate: if the builder stops at step 3, contributor fixtures and T2–T4 will fail until the PDF confirms per-day contributors—consistent with the test plan’s “still run every case” note; ensure the builder report Summary says **stopped** so Ops does not merge.
- New contributor issues do not specify the `employee` column on stdout/HTML; use the Toast **Source** (or the same pattern as other non-person checks) so T2 parsing stays stable.
- `cfg["pos"]` is not read in `payroll.py` today; the builder must gate the new check on `pos` from merged store config (`toast_r365` vs `ncr`) as the task states—already implied, worth one explicit line in the builder report.
