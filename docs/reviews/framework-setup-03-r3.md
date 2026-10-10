# Review · framework-setup-03

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The build may not proceed until the workflow and scope contradictions are fixed and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The documentation timing contradicts itself. The heading says Claude’s workflow-doc edits are committed before the build, while the body and sequence put them after the merge. The latter would make this build use Composer while the operative `CLAUDE.md` and `docs/prompts/ops-cycle.md` still require Grok. Define one transition that keeps the rules and actual hand-offs aligned throughout this build.
- The generic research workflow is incomplete. Require `ops-cycle.md` to pass `--role research` to `build.sh prepare` and `--writer grok` to every research diff review. Otherwise research defaults to the Composer path and can select a Grok reviewer for Grok-written work, violating the binding different-family rule. Align `build.sh collect` guidance as well.
- The included-model gate says its result will be written into this plan after approval. That would alter the reviewed plan before `build.sh prepare` without reviewing the altered version. Record the confirmation before approval, or keep the immutable evidence outside the approved plan.
- Test T8 permits new files under `scripts/tests/fixtures/`, but neither the plan nor task file allows the builder to edit them. Remove that allowance or name the exact fixture files in both documents.

## Minors

- “GPT and Sonnet are no longer used anywhere” overstates the defined cleanup, which intentionally leaves historical plans, reviews, tests, and research unchanged. Limit the claim to current workflow instructions.
