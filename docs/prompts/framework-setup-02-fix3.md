# Agent task · framework-setup-02 · fix round 3 (build)

> **For the coding agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** A fix round on `feat/framework-setup-02` (at `e30d46f`), under the
> approved plan `docs/plans/framework-setup-02.md`. Hand-off: "Do the task in /srv/fhs-build/reports/framework-setup-02-fix3.md".

## Context

The final review `docs/reviews/framework-setup-02-diff-r5.md` (APPROVE AFTER FIXES) found that `scripts/lib/verdict.sh` accepts a
malformed token that merely starts with `APPROVE` (e.g. `APPROVED.`) as `APPROVE`, so `build.sh prepare` could pass without an exact
verdict. The planner's round-1 task file said "starts with". That was too loose, and this task replaces that rule.

## Where you work

`/srv/fhs-build/framework-setup-02`, the existing branch `feat/framework-setup-02`.

## Steps

1. In `scripts/lib/verdict.sh`, on the first non-empty line after `## Verdict`: remove leading spaces, then remove one leading `**` if present.
   The result must match exactly one of these, checked in this order:
   - `APPROVE AFTER FIXES` followed by optional `**`, then `.` or end of line → `APPROVE AFTER FIXES`
   - `REJECT` followed by optional `**`, then `.` or end of line → `REJECT`
   - `APPROVE` followed by optional `**`, then `.` or end of line → `APPROVE`
   - anything else → `NONE`
   Keep "first `## Verdict` section wins", "missing file → NONE" and "always exit 0".
2. Add fixtures and cases to `scripts/tests/test_framework.sh`:
   - `review-approved-typo.md` (`APPROVED. text`) → `NONE`
   - `review-approve-nodot.md` (`APPROVE`) → `APPROVE`
   - `review-approvex.md` (`APPROVEX. text`) → `NONE`
   - `review-reject-typo.md` (`REJECTED. text`) → `NONE`
   - and `build.sh prepare --check-only` with the `APPROVED.` fixture as the review → exit 3.
   The existing bold and normal fixtures must still pass.

## You may edit only

- `scripts/lib/verdict.sh`, `scripts/tests/test_framework.sh`, new files `scripts/tests/fixtures/review-approved-typo.md`,
  `review-approve-nodot.md`, `review-approvex.md`, `review-reject-typo.md`

## You must not

- Edit anything else, change git config, push, merge, or use sudo.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS, `exit=0`
2. `bash -n scripts/lib/verdict.sh scripts/tests/test_framework.sh` → no output
3. `git diff --check main...HEAD` → no output
4. `git diff --name-only main...HEAD` → the 12 files from round 1 plus the 4 new fixtures
5. `git status --short` → empty

## When done

Commit `verdict.sh: exact verdict tokens only (fix r5 review)`, ending with `Co-Authored-By: Grok 4.7 High (cursor-agent)` (same one-shot
author). Append a "Fix round 3" section to `/srv/fhs-build/reports/framework-setup-02.md`. If a step can't be done exactly as written, stop and say why.
