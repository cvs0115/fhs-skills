# Review · payroll-adp-01-diff

2026-10-22 · Reviewer model: cursor-grok-4.6-xhigh (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The merge may not go ahead until `extract-formats.md` maps `_tip_contributors` Contributor from the Daily Rules - Contributors column that holds the tip-rule name (`KIOSK USER`), not Employee Name (`KIOSK KIOSK - 550`).

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- **Wrong PDF column for Contributor, so the real-data done-check cannot pass if extracts follow the docs.** The builder used the correct report section (**Daily Rules - Contributors** on `Tip Automation Distributions Report 10-05 to 10-18.pdf`; not guessed). On that table, Employee Name is the kiosk account `KIOSK KIOSK - 550`; the tip-rule name `KIOSK USER` is a different column (same place `Cashier` appears on Cashier2 rows). Net Sales is the dollar column on that page; Card Tips sit on the overflow pages. [`extract-formats.md`](skills/fhs-payroll-adp/references/extract-formats.md) still says Date Worked → Date, **Employee Name → Contributor**, Basis Value → Amount. [`_tip_sources`](skills/fhs-payroll-adp/references/extract-formats.md) is correctly told to put `KIOSK USER` in the last column. `key("KIOSK USER")` is `kiosk user`; `key("KIOSK KIOSK - 550")` is `kiosk kiosk`. The check in [`payroll.py`](skills/fhs-payroll-adp/scripts/payroll.py) compares those keys, so a skill run that copies Employee Name into `_tip_contributors` will High every kiosk day even after the owner’s refresh. That breaks plan P1 (Week 42: contributor check passes every day). Fixtures already use `KIOSK USER` on both files, which is why T2–T4 and the tester report stay green. Fix the mapping (and a one-line note that Employee Name is the kiosk account, not the match key). Amount is unused by the check; it does not have to be perfect for this major to close.

## Minors

- [`browser-recipes.md`](skills/fhs-payroll-adp/references/browser-recipes.md) export path omits choosing **PDF** after the Export icon (plan and `memory/save-source-reports.md`: Export → PDF → Page Scaling "Adjust 100%" → EXPORT).
- Amount mapped to “Basis Value” does not match the PDF: the $ column on that page is **Net Sales**; Card Tips are on the overflow pages. Unused by the High check.
- Commits `7455497` and `9687b00` reshape SKILL.md for T6’s grep window. Step 6’s body already requires listing saved files in the concerns note before ADP; the heading tweak is test-shaped, not a missing step.
- [`payroll.py`](skills/fhs-payroll-adp/scripts/payroll.py) module docstring still omits `_tip_sources.txt` / `_tip_contributors.txt`.
- Served tree, live systems, allowed-file set, kiosk skip, NCR silence, ADP math, and pre-merge T1–T8 match the approved plan. Tester: PASS 8 · FAIL 0 · BLOCKED P1, P2 (owner refresh) at `9687b00`; `extra=0`; no PDF in git. Spec: none.
