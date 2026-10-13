# Review · waste-log-01

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. PC capture and the commit-before-capture sequence cannot run until `docs/prompts/waste-log-01-capture.md` exists and matches the plan; after that fix (and minor task/test alignment below), the package is ready to commit and capture.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- **`docs/prompts/waste-log-01-capture.md` is missing** from the repo while the plan, sequence step 1, PC hand-off, and reviewer scope all require it (`docs/plans/waste-log-01.md` lines 6–7, 57–66, 106–108). Peer lanes (`cash-122-01`, `count-sheet-122-01`, etc.) ship a `*-capture.md` alongside the researcher prompt. Without it, the owner cannot run capture from `C:\fhs\fhs-skills`, and the researcher’s “Read first” item 4 references a file that is not on `main`. Draft it from plan parts 2–6 (TWR, VDR, WL, ACC, AVT), `pages.csv` rules, and the cash/count-sheet capture templates; POS remains owner-only per plan part 1.

## Minors

- **`docs/prompts/waste-log-01.md` self-tests are weaker than merge gate T1** in `docs/tests/waste-log-01.md`: embedded Tests 1 and 5 pass with `own_rows >= 1` and do not check `summary_lines <= 6`, the six required `## Who owns what` settings rows, or `deviations_ok`. Align researcher Tests 1/5 (or fold T1 criteria in) so a “8/8 passed” report cannot still fail T1 at merge.
- **Owner steps (plan § Owner steps, item 2):** say to drop screenshot and item/reason/$ into the folder; plan part 1 also expects a short **steps note** (void vs mark-as-test). Add “steps note” to owner step 2 so capture matches `POS-*` evidence the task and T2 expect.
- **Spec housekeeping (not a plan scope add):** `docs/specs/waste-log.md` still says hub project “to create” and has tension between the 2026-10-13 Toast-POS direction and the older sheet→R365 answer; the plan follows the brief/decision. No change required for this review unless the writer wants the spec header updated when the hub card exists.
