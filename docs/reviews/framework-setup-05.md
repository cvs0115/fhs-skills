# Review · framework-setup-05

2026-10-22 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The plan, task file, and test plan stay within the brief, match CLAUDE.md on served tree and review gates, and the done-check is appropriate for a scripts-only change.

## Majors

None.

## Minors

- Exit code 5 already means prepare-as-non-root in `scripts/build.sh`; after this change it also means verdict-less reviewer output in `scripts/review.sh`. Callers distinguish by script, but adding exit 5 to the `review.sh` header/usage comment during implementation would help Ops.
- New PATH-shim `--diff` cases in `scripts/tests/test_framework.sh` must remove `$parent/fhs-skills-wt/review-zz` before each run because `review-diff-existing-dir` leaves that path in place; the plan says so, but it is easy to miss when wiring tests.
- Done-check item 2 (next real `review.sh` after merge) is inherently post-merge; the test plan correctly gates P1/P2 on owner-reported evidence rather than treating them as pre-merge failures.
