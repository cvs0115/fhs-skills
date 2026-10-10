# Review · framework-setup-02

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not start until the blocking test and merge-gate conflicts are fixed and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The merge gate is impossible to satisfy. The new `CLAUDE.md` workflow requires every test to pass before merge, but test cases T18–T19 explicitly run only after merge and must remain BLOCKED beforehand. Separate pre-merge acceptance from post-merge verification.
- Done-check 5 cannot pass because `build.sh prepare` requires a committed `docs/tests/zz-buildtest-01.md`, but the setup creates and commits only the temporary plan, prompt and approving review. Add the required test plan and its cleanup.
- Test T2 depends on `docs/reviews/browser-01-r1.md`, which is not included in the bootstrap commit and therefore will not be present in the builder clone. Commit and name that dependency or use a committed fixture.

## Minors

- The planned `README.md` description mentions task files but omits the new `docs/tests/` test plans.
