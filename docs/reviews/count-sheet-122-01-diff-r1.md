# Review · count-sheet-122-01-diff

2026-10-12 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE. The branch may merge to `main`; only the approved research note and two appended `tech-stack.md` bullets change the served tree, pre-merge tests T1–T5 passed, and capture evidence supports the ownership and store-run conclusions without contradicting owner rules or the plan.

## Majors

- (none)

## Minors

- **Template ownership Capture column:** For (a) and (c), the Capture column is only `TPL-02.txt` while the Answer text also cites `ITM-02.txt`, `ITM-03.txt`, and `ITM-01.txt`. T2 passes because those names appear in the Answer; aligning the Capture column with every file cited would match the task table literally.
- **TPL-02 nuance:** The capture records the template name field and Publish as enabled/editable, while the note correctly centers on no Remove-from-template / Inactivate and greyed item Active/SAVE. A short clause that “editable header fields” were not tested as a hide path would avoid a reader inferring full template edit rights from the capture alone.
- **Kebab menus:** (a) notes header/grid kebab menus were not opened on `TPL-02.txt`; acceptable for “not shown” on named controls, but a hide action could theoretically live only in an unopened menu.
- **tech-stack overlap:** New bullets restate F5-style template facts (creator, modifier, 207 items) already on line 106; the plan asked for explicit ownership and store-run pointers—overlap is intentional, not wrong.
- **pages.csv:** UTF-8 BOM and no `scroll` rows (only `view`, `filter`, `export`) are documented in the builder report; within plan allowances.
- **P1:** Post-merge owner confirmation (template still 207 items; no new vendor or AP draft) remains BLOCKED per test plan—not a merge gate.

**Cross-checks (for the record):** `git diff main...feat/count-sheet-122-01` touches only [`docs/research/count-sheet-122.md`](docs/research/count-sheet-122.md) and [`skills/fhs-skills/references/tech-stack.md`](skills/fhs-skills/references/tech-stack.md) (additions only under `## Store 122 audit (2026-10-11)`). Builder 7/7 and tester T1–T5 PASS align with [`docs/plans/count-sheet-122-01.md`](docs/plans/count-sheet-122-01.md) scope (verify-only, no R365 change, Keep? blank). Spot-checks: `ITM-03.txt` / `ITM-02.txt` support greyed Active/SAVE and no remove-from-template on Templates; `APF-01.txt` and `pages.csv` line 26 support blank AP form opened as `view` and closed without save; live-system list matches plan (R365 read-only capture only, Toast untouched).
