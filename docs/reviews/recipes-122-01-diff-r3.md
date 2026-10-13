# Review · recipes-122-01-diff

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE. `feat/recipes-122-01` (0cddda0) may merge to `main`: the diff is limited to the research note and two added `tech-stack.md` bullets, the done-check is grounded in week 10/05–10/11 captures, and pre-merge T1–T6 pass on `main` at 679c227 with the corrected T5/self-test 5 per `/srv/fhs-build/reports/recipes-122-01-test.md`.

## Majors

- (none)

## Minors

- Prior diff review r2 ([docs/reviews/recipes-122-01-diff-r2.md](docs/reviews/recipes-122-01-diff-r2.md)) blocked on T5 expecting `create_hits=1`; `main` commit 679c227 and the fresh tester run align T5 and [docs/prompts/recipes-122-01.md](docs/prompts/recipes-122-01.md) self-test 5 with two line-10 hits (`RCP-01.txt`, `RCP-02.txt`). The builder report still shows 7/8 from the earlier self-test wording—historical only; merge gate is the committed test plan plus tester report.
- [docs/research/recipes-122.md](docs/research/recipes-122.md) `## Deviations` documents the duplicate RecipeItemForm note and other “+ Create” button mentions in capture text; `pages.csv` stays clean.
- Sold-items tie-out omits 13 `Deferred=true` SAL-03 rows (documented); methodology matches T2 and the plan’s SAL-03 row source.
- Many “mapped” kiosk (`RK*`) rows attach only to sub-paper recipes (`SM Sub Paper - 1003488`, etc.)—a capture finding, not a join error; full subs stay `unmapped` because this export has no size/modifier columns and keys are `<Item>` only.
- F4 recipe 400120: note cites export `AvgCost` **1.1732** vs audit **Current cost $1.1858** in [skills/fhs-skills/references/tech-stack.md](skills/fhs-skills/references/tech-stack.md), scoped as expected-size / different fields; existing Recipes bullet was not rewritten.
- P1 post-merge (owner confirms Toast/R365 unchanged) remains BLOCKED in the tester report; not a merge gate.
