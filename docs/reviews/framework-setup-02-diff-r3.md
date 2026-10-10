# Review · framework-setup-02-diff

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The branch must be fixed and reviewed again before privileged testing or merge.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- `scripts/review.sh` can delete a pre-existing review directory or registered worktree. It installs the cleanup trap before `git worktree add`; if that command fails because `$WT` already exists, the trap forcibly removes the worktree and then runs `rm -rf "$WT"`. Refuse an existing path and track whether this invocation successfully created the worktree before removing it. Add a failure-path test with a pre-existing directory.
- `scripts/build.sh collect` does not print the report as required by the approved plan and task. It only echoes the report’s pathname. Print the report contents before the required `Next:` line and test that output.

## Minors

- `scripts/tests/fixtures/review-reject.md` contains trailing whitespace, causing `git diff --check` to fail.
