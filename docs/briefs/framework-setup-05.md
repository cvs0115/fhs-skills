# Brief · framework-setup-05 · review.sh fails loudly on an empty or verdict-less review

2026-10-22. Written by Claude for the Drafter (Cursor Grok 4.6 High). The Drafter turns this into
`docs/plans/framework-setup-05.md` (form `docs/templates/plan.md`), `docs/prompts/framework-setup-05.md` and
`docs/tests/framework-setup-05.md`. Don't add scope.

- Spec: `docs/specs/framework-setup.md` · Hub project: `projects/fhs-framework` · Binding decisions: CLAUDE.md loop step 4 (APPROVE gates every build and merge)
- Evidence: 2026-10-22, two of four `scripts/review.sh --diff feat/payroll-adp-01 --writer composer` runs exited 0 but wrote a
  1-line empty `docs/reviews/payroll-adp-01-diff.md`; the script printed verdict `NONE`.

## Problem and decision (3–5 lines)

`scripts/review.sh` runs `cursor-agent ... > "$OUT_TMP"` then `mv "$OUT_TMP" "$OUT"` with no check, in both the `--diff` branch
(around line 176) and the plan branch (around line 233). An empty reply or a reply without a parseable `## Verdict` becomes a saved
review and exit 0, which can pass for a review or waste a round. Decision: after each `cursor-agent` call, keep the reply only if
`cursor-agent` exited 0, the temp file has non-blank content, and `verdict "$OUT_TMP"` (from `scripts/lib/verdict.sh`, unchanged)
is not `NONE`. Otherwise retry the call once automatically; if the retry also fails, delete the temp file, leave nothing new in
`docs/reviews/` (an earlier `$OUT` is not touched), print to stderr `review.sh: reviewer returned no verdict (empty or malformed output) after 2 tries`
with the model and subject name, and exit 5 (a new code; 2 and 4 keep their meanings). Put the call-check-retry in one shared
function used by both branches so they can't drift. The `--diff` worktree cleanup trap must still run on the failure path.

## Files the builder may edit / must not edit

- may: `scripts/review.sh`, `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/*` (new fixtures only)
- must not: the served tree `/root/fhs-skills`, `skills/`, `shared/config.json`, `docs/` (Claude owns docs), `scripts/lib/verdict.sh`,
  `scripts/draft.sh`, `scripts/build.sh`

## Live systems touched

None.

## Done-check (real outcome)

After merge, the next real `scripts/review.sh` run in any lane writes a review whose verdict line is APPROVE, APPROVE AFTER FIXES or
REJECT; and a run with `cursor-agent` stubbed (PATH shim) to print nothing exits 5 with no new file in `docs/reviews/`.

## Where it runs and which tree is live

Server (dev-lxc-1) only. `scripts/` on `main` in `/root/fhs-skills` is the trusted copy Ops runs; merging is the release.
Skills and the Windows copy are untouched.

## Tests the test plan must include

Use a PATH shim for `cursor-agent` (no real model calls) in a throwaway repo or the clone, for both the plan and `--diff` branches:
- stub prints nothing, exit 0 → exit 5, stderr names the failure, no `$OUT` and no `$OUT.tmp` left; stub called exactly 2 times.
- stub prints `# Review · x` with no `## Verdict` → same as above.
- stub prints a review with `## Verdict` then `MAYBE` → same as above.
- stub exits non-zero → same as above.
- stub fails the first call, returns a valid `APPROVE` review on the second → exit 0, file written, prints `APPROVE`.
- valid review on the first call → exit 0, written once, stub called once (no extra call).
- an older `$OUT` already exists and both tries fail → the older file is byte-for-byte unchanged.
- `--diff` failure path → the temporary worktree under `/root/fhs-skills-wt/` (or the test's equivalent) is removed.
- the existing `scripts/tests/test_framework.sh` cases still pass; `bash -n scripts/review.sh` and `shellcheck` (if installed) are clean.

## Report format

Builder and tester reports start with `## Summary` (≤5 lines: result, tests passed/failed, anything stopped). Claude reads only that section.
