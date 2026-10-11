# Review · invoices-122-01-diff

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE. Merge `feat/invoices-122-01` into `main` after pre-merge tests; P1 stays post-merge (owner confirmation that R365 was unchanged).

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- (none)

## Minors

- Cheney vendor **Transactions** tab had no export (`TXN-02-missing.txt`). Done-check 1 in [docs/plans/invoices-122-01.md](docs/plans/invoices-122-01.md) names the tab export as the count source; the note instead uses filtered F2 `INV-01.csv` plus cross-check to `TXN-01.txt` (25 rows). Captures folder has no `TXN-*.csv`. Builder test 1 reports `txn_rows=not_csv`; tester T1 still ties 25 table rows to the filtered AP export. Acceptable for merge because the on-screen Transactions capture matches the invoice set; capture task gap is documented in the report deviations.
- **Approver** on approved rows cites `Kimberly Helou (INV-01.csv)` from the F2 AP header export, not the invoice forms (forms lack approver; task text prefers `not shown (<INV file>)` when the capture omits it). Does not change the three owner-summary bullets or mapping/receipt tables.
- **`Match` = `name only`:** [docs/prompts/invoices-122-01.md](docs/prompts/invoices-122-01.md) defines it when the name matches but the **number does not**; [docs/research/invoices-122.md](docs/research/invoices-122.md) defines it when the template Name has **no 7-digit code** (50 rows). Automated tests count `name_only=50` but do not enforce the task wording; last-receipt dates and capture cites were spot-checked on T4.
- `pages.csv` actions are only `filter` and `view` (no `scroll`/`export`); line evidence is full grid text in `INV-01.txt`–`INV-25.txt`. Consistent with builder/tester T5 and the report.
- Diff scope matches the approved plan: one commit (`bf1d4f9`), only [docs/research/invoices-122.md](docs/research/invoices-122.md) (new) and two added bullets under `## Store 122 audit (2026-10-11)` in [skills/fhs-skills/references/tech-stack.md](skills/fhs-skills/references/tech-stack.md) (no deletions). Served tree release path is merge to `/root/fhs-skills` `main` per [CLAUDE.md](CLAUDE.md); work stayed in the build clone. No skill/script edits, no `shared/config.json`, Toast/ADP untouched; builder reports no forbidden R365 actions. Aligns with [docs/specs/electronic-invoices.md](docs/specs/electronic-invoices.md) verify-only F3 scope. Pre-merge gate: tester T1–T7 PASS; P1 BLOCKED as planned. Builder 8/8 self-tests match the diff constraints (file list, clean `git status`, tech-stack additions only).
