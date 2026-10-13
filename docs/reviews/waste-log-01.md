# Review · waste-log-01

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. The research-only package matches the brief and spec P0, served-tree and lane rules are correct, live touch is limited to the listed owner/manager POS test plus read-only PC capture, and the done-check uses real captures; commit the plan bundle and run the gate/capture sequence.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- (none)

## Minors

- **`docs/prompts/waste-log-01.md` Test 1** still prints only a subset of T1 metrics in its `python3 -c` line; pass rules for Test 1 alone do not cover `q_rows` / `own_rows` (Tests 3–5 do). The sentence “passing Tests 1–5 here must not leave T1 failing” is the real gate—fine, but the “same thresholds as merge test T1” phrase on Test 1 alone is slightly overstated.
- **`docs/prompts/waste-log-01-capture.md` § You must not** (“never-click list”) does not repeat the Create/New/Add exception; it lives on the Hard rules bullet above. Low risk because Hard rules say “read twice,” but a one-line “except the blank R365 new-log form” cross-reference would match the plan wording.
- **`docs/specs/waste-log.md`** hub “to create” and the older sheet→R365 note vs 2026-10-13 Toast-POS direction remain; the plan follows the brief—optional spec cleanup when the hub card exists, not blocking this lane.
