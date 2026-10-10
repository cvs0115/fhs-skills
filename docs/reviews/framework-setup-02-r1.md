# Review · framework-setup-02

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not start until the blocking process and verification gaps below are fixed and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The approval gate cannot accept the required review form. `build.sh` requires a verdict line exactly equal to `APPROVE`, while `docs/templates/review.md` requires `APPROVE. <sentence>`. Parse the Verdict section’s status token unambiguously and test all three verdicts.
- The model guards do not enforce the logged owner decision. `BUILD_MODEL` may currently be any non-Claude/non-GPT model, and `REVIEW_MODEL` may be any non-Claude/non-Grok model. Require the chosen `grok-4.7-high` builder and `gpt-5.6-sol-high` reviewer, or explicitly revise the logged decision first.
- Served-tree protection is not established. The plan runs a root agent with `--force` while sandbox confinement remains unverified, and checking afterward cannot prevent damage to `/root/fhs-skills`. Verify confinement before design approval or include enforceable OS-level write isolation in this plan.
- The report behavior contradicts the done-check. Every run writes `docs/builds/<name>.md`, but the throwaway branch is expected to contain only `docs/builds/zz-hello.md`. Define whether reports are committed or external, add the report path to the allowed files, and make the expected diff and clean-tree checks match.
- The bootstrap sequence is incomplete. It requires the not-yet-created `docs/templates/brief.md`, and a branch cut from `main` may omit the plan and approving review, leaving the diff reviewer unable to check the implementation against them. Specify an existing bootstrap brief and ensure the approved plan and review are available in the build and diff-review checkout.

## Minors

- The throwaway test also needs a named approving-review fixture and explicit cleanup of the plan, review, worktree, branch, and report.
