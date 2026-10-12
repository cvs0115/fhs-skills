# Review · recipes-122-01

2026-10-12 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The redrafted verify-only research cycle matches the brief’s 2026-10-12 capture addendum, served-tree and clone rules, read-only live-system boundaries, and real-data done-checks; Ops may commit the plan bundle and run `prepare` after unzip.

## Majors

- (none)

## Minors

- [docs/prompts/recipes-122-01-capture.md](docs/prompts/recipes-122-01-capture.md) still reads as an active PC hand-off (“Runs only after…”, full Steps) while the plan pre-start gate says capture is complete and forbids re-run; add a short “record only / do not run” banner at the top so it cannot be mistaken for the next step.
- The same capture file still describes MNU/RCP filtering and columns around POS id/code; research join is name-key only per the addendum—harmless for this cycle if capture is not re-run, but stale vs plan § Join.
- [scripts/build.sh](scripts/build.sh) `prepare` does not require `docs/prompts/recipes-122-01-capture.md` on `main`; plan sequence step 1 does—Ops must commit that file with the bundle or the clone will lack the filename record the task lists in “Read first.”
- Researcher self-test 4 and test plan T5 flag URL paths containing `update` (case-insensitive); [docs/prompts/recipes-122-01-capture.md](docs/prompts/recipes-122-01-capture.md) test 4 uses the longer forbidden-segment list—if `pages.csv` trips false positives, align exceptions with capture test 4 (MenuItems / recipe-items `view`/`close` already documented).
- Capture “must not” still cites `C:\Users\mayur\.claude\skills` ([docs/reviews/recipes-122-01-r1.md](docs/reviews/recipes-122-01-r1.md) carryover); a generic owner skills path would age better.
- [docs/RUNBOOK.md](docs/RUNBOOK.md) row 17 still orders a new PC capture after r1; the plan says capture is already in `inbox/recipes-122.zip`—Ops should follow the plan sequence, not the stale runbook line.
