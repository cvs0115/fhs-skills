# Review · payroll-adp-01

2026-10-22 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The plan, brief alignment, served tree, live-system scope, and real-data done-check are sound; fix the pre-merge T8 / commit ordering conflict in the task and test plan before Ops commits the bundle and runs `build.sh prepare`.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- **T8 merge gate vs commit order.** [`docs/prompts/payroll-adp-01.md`](docs/prompts/payroll-adp-01.md) step 10 says run every test, then **When done** step 1 commits—but test 8 is labeled **After the commit** and uses `git diff --name-only main...HEAD`, which only sees commits, not the working tree. A builder following step 10 literally can pass T8 with `extra=0` while all changes are still uncommitted. [`docs/tests/payroll-adp-01.md`](docs/tests/payroll-adp-01.md) T8 adds the opposite problem: it tells the tester to run T8 **before** T1–T5, which still does not establish that `main...HEAD` contains the built work. Align all three: e.g. commit on `feat/payroll-adp-01` first (or re-run T8 only after commit), then T8; drop or rewrite the “before T1–T5” instruction so T8 is unambiguously post-commit.

## Minors

- **Kiosk skip list vs brief wording.** Brief and plan both say skip “all” per-shift checks for `non_employee_accounts`, but the plan/task enumerate specific issue titles and omit others the script can emit for shift rows (e.g. **Punch with no hours counted**, **Has shifts but missing from hours report**). T1 only asserts four kinds. Either extend the skip logic and tests to match “all per-shift” or narrow the brief/plan prose to the listed titles so nothing implies full coverage.
- **Plan `[NEEDS CLARIFICATION]` on R365 contributors section** is acceptable gating (PDF-first, stop if no per-day contributors); keep it in the plan until the builder confirms from the inbox PDF—no owner question needed at review time.
- **Optional extracts vs P1.** P1 expects zero Medium **Tip contributor check not run**, so real Week 42 folders need `_tip_sources.txt` and `_tip_contributors.txt` plus `_tips.txt`. SKILL step 3 already defers to `extract-formats.md`; after the table update, a one-line mention in step 3 (toast_r365: create the two optional tip files when running the contributor check) would make the post-merge done-check operable without adding scope beyond the brief’s two extracts.
- **T6 vs task test 6.** Test plan T6 uses a 400-character window and `Enter in ADP RUN` heading detection; the task uses “before ADP RUN entry heading.” Wording is aligned with current SKILL §7; no change required if both checks target the same heading text.
