# Review · invoices-122-01

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan (with `docs/prompts/invoices-122-01.md`, `docs/prompts/invoices-122-01-capture.md`, and `docs/tests/invoices-122-01.md` as named in the plan header)

## Verdict

APPROVE. Ops may commit the plan bundle to `main`, then run capture, prepare, research, test, and diff review per the sequence.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- [`docs/tests/invoices-122-01.md`](docs/tests/invoices-122-01.md) has no pre-merge case for plan done-check items 3, 5, and 6 (`## Mapping totals` / `### Unmapped lines` completeness, `## P1`, and the three `## Summary for the owner` lines). T4 spot-checks mapping on three invoices only; the researcher self-tests in the task file partially cover mapping/summary. Consider a shell case or explicit T4 note that those sections must exist and tie to the invoice table.
- Same test plan: the “Browser rules” block under “Where you test” still requires screenshots under `invoices-122-01-shots`, while the table says browser envs are not used and “No browser cases for the tester.” Trim or label that block as N/A to avoid a tester opening R365.
- [`docs/prompts/invoices-122-01.md`](docs/prompts/invoices-122-01.md) step 1 always runs `git switch -c feat/invoices-122-01`; a resumed session on an existing feature branch will fail. One line to `git switch feat/invoices-122-01` when the branch already exists (same pattern as items-122-01).
- Pre-merge T6 matches the task’s diff checks but not task test 8 (`git status --short` empty). Optional alignment so the tester records a clean tree before merge.

**Cross-check (no finding):** Served tree (`/root/fhs-skills` on `main`, symlinks), researcher clone (`/srv/fhs-build/invoices-122-01`, `--role research`), capture → inbox → Ops unzip path, editable files (`docs/research/invoices-122.md`, added `tech-stack.md` lines under existing `## Store 122 audit (2026-10-11)`), R365 read-only on PC with Toast untouched, and real-data done-check against captures all match [docs/briefs/invoices-122-01.md](docs/briefs/invoices-122-01.md), [docs/specs/electronic-invoices.md](docs/specs/electronic-invoices.md), CLAUDE.md, and owner rules in `skills/fhs-skills/SKILL.md`. Credit memos, TXN count as source of truth, and virtualized grid scroll/export behavior are consistent across plan, capture task, researcher task, and brief.
