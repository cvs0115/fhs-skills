# Review · waste-log-01

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The research-only package matches the brief, served-tree rules, and a real-data done-check, and `docs/prompts/waste-log-01-capture.md` is present after r1; fix the capture hard-rules clash with the plan on opening the R365 blank waste-log form, then commit and run capture.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- **`docs/prompts/waste-log-01-capture.md` hard rules vs plan on the R365 new-log form.** The plan allows **Create / New / Add** only to open the one blank waste-log form, then Cancel/Close (`docs/plans/waste-log-01.md` lines 50–53, 63). The capture task says **Never click:** … **Create, New, Add** … with no carve-out (`docs/prompts/waste-log-01-capture.md` lines 35–37), while WL still requires opening that form (line 63). An agent that follows line 36 literally cannot complete WL (e) or matches `pages.csv` rules that allow a `new`/`create` URL for that form (line 47). Align the capture **Never click** bullet with the plan’s parenthetical (same pattern as plan § Live systems).

## Minors

- **`docs/prompts/waste-log-01.md` embedded self-tests still looser than merge gate T1** (`docs/tests/waste-log-01.md` T1): Test 1 does not check `summary_lines <= 6`, the six required `## Who owns what` rows, or `deviations_ok`; Test 5 passes with `own_rows >= 1` instead of `own_rows >= 6`. A researcher “8/8 passed” report can still fail T1—fold T1 criteria into Tests 1/5 or cross-reference T1 explicitly.
- **Capture PC self-test 4** (`waste-log-01-capture.md` line 85) does not mirror plan/T3 URL rules (`create|new|add|edit|map` and Toast/R365 view exceptions); tighten so a passing capture self-test is closer to T3.
- **Capture never-click list** omits **Map** while the plan forbids it (`docs/plans/waste-log-01.md` line 51); add for parity with peer capture tasks.
- **`docs/specs/waste-log.md`** still says hub “to create” and mixes the older sheet→R365 note with the 2026-10-13 Toast-POS direction; the plan follows the brief—optional spec header/decision cleanup when the hub card exists (not blocking this plan).
