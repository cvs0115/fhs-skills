# Review · framework-setup-02

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not start until the rule, dependency, and plan-to-prompt conflicts below are fixed and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The proposed clone-based build contradicts both active `CLAUDE.md` and `docs/specs/framework-setup.md`, which require builds in worktrees under `/root/fhs-skills-wt/`. The later builder edit to `CLAUDE.md` cannot authorize an earlier build in `/srv/fhs-build`. Record the owner-approved rule change and update the spec before bootstrap, or retain the required worktree model.
- Bootstrap step 5 commits only the plan, task file, and review. `docs/templates/prompt.md` is currently untracked, is excluded from builder edits, and therefore will not exist in the clone even though the planned `CLAUDE.md` and `README.md` changes reference it. Add it explicitly to the bootstrap commit.
- The plan and task file disagree on the approval gate. The plan requires `git ls-files` plus no uncommitted changes, while the task requires `git cat-file -e <base>:<path>`. Because the builder must stop when they disagree, this blocks execution. Make both require the files from the named base branch’s committed tree.

## Minors

- The task file says “If this file and the plan disagree”; use “If this task file and the plan disagree.”
- Add an explicit done-check that the temporary diff-review worktree is removed after both successful and failed reviews.
