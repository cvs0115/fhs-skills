# Review · framework-setup-diff

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The branch must not merge until the majors are fixed and re-reviewed.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- No plan or spec exists for this non-trivial, 85-file change. This violates the new-script workflow in `CLAUDE.md` and leaves the authorized files, real-outcome check, and preserved behavior undefined.
- `CLAUDE.md` directs subagents to `app-framework/agents/`, whose prompts require `develop`, `docs/board.md`, and `docs/decisions.md`. This repo has no `develop` branch and uses `main` plus Hub databases. Using those prompts would contradict the FHS workflow and update the wrong state.
- `CLAUDE.md` documents `scripts/review.sh <plan-or-branch>`, but branch reviews require `scripts/review.sh --diff <branch>`. Following the door-file instruction makes the required review gate fail.

## Minors

- `git diff --check` reports trailing whitespace throughout six imported Markdown files: `app-framework/.claude/skills/new-app/SKILL.md`, `OUTLINE.md`, `README.md`, `playbook/06-security-access.md`, `playbook/08-plan-tasks.md`, and `questions/07-planning-delivery.md`.
