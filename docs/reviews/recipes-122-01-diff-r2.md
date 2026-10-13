# Review · recipes-122-01-diff

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The research note and `tech-stack.md` additions match the approved plan’s scope and use real capture data, but the committed merge gate is not met: T5 / researcher self-test 5 fail on the branch while the tester report claims ALL PASS using a test-plan copy outside the repo.

## Majors

- **Pre-merge gate vs committed test plan:** [docs/tests/recipes-122-01.md](docs/tests/recipes-122-01.md) T5 and [docs/prompts/recipes-122-01.md](docs/prompts/recipes-122-01.md) self-test 5 require `create_hits=1` (only `RCP-02.txt` line 10). Grep of `Create` + `form/` on the captures yields **2** hits (`RCP-01.txt:10`, `RCP-02.txt:10`). The builder report correctly records **7/8** (test 5 fail). The tester report’s ALL PASS relies on `/srv/fhs-build/reports/recipes-122-01-test-plan-corrected.md`, which is **not** in `git diff main...feat/recipes-122-01`. [docs/plans/recipes-122-01.md](docs/plans/recipes-122-01.md) requires every pre-merge case PASS before merge; that condition is not satisfied on the committed artifacts.

## Minors

- Align T5 and researcher self-test 5 with the capture reality (one misclick, duplicate note on line 10 of both `RCP-01.txt` and `RCP-02.txt`; expect `create_hits=2`, `rcp01_rcp02_line10=1`, `deviations_ok=1`) in `docs/tests/recipes-122-01.md` and `docs/prompts/recipes-122-01.md` on `main`, then re-run the tester from the committed test plan and refresh `/srv/fhs-build/reports/recipes-122-01-test.md`.
- `## Deviations` already documents the duplicate `RCP-01.txt` line 10; after the test-plan fix, ensure T5’s “names that file and line” wording still matches (both files are fine).
- Sold-items source omits 13 `Deferred=true` SAL-03 rows (documented in the note); tie-out to 1,294 / $12,550.25 is consistent with tester T2—methodology is acceptable but worth one line in a future plan if deferred sales are in scope.
- F4 example recipe 400120: export `AvgCost` **1.1732** in the note vs audit **Current cost $1.1858** in [skills/fhs-skills/references/tech-stack.md](skills/fhs-skills/references/tech-stack.md)—correctly scoped as “expected size only” / separate cost fields; no tech-stack line was rewritten.
- P1 post-merge remains BLOCKED (owner confirmation); not a merge gate.
- Branch diff is exactly `docs/research/recipes-122.md` (new) and two added bullets in `skills/fhs-skills/references/tech-stack.md` (additions only); served-tree rule on merge is correct. No live Toast/R365 changes in the diff; capture deviation (+ Create / blank RecipeItemForm) is documented. Done-check sections (124 rows, totals, five join examples, MAP-03 / `AvgCost` / Q(a–c)) match the plan and spec intent for verify-only F4.
