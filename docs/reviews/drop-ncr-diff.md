VERDICT: APPROVE AFTER FIXES

878 as `toast_r365` does not crash `payroll.py`. The script still only *requires* `_hours.txt` (and uses `_shifts` / `_totals` if present). What *changes* for 878:

- `_tip_sources.txt` and `_tip_contributors.txt` become expected whenever `_tips.txt` exists. Missing either is a Medium “Tip contributor check not run”; both present turns on High “Tip source missing from R365 contributors”.
- `_crosscheck_hours.txt` is still optional in code (no file → hours-between-systems is skipped). extract-formats already marks it for Toast/R365 stores, so a 878 run should now write it.
- `toast_location` is unused by `payroll.py`. `toast_restaurant_group_id` is only the browser-fallback URL. `r365_tip_rule` is unused by the script. The field the script actually uses for the tip-rule check is `tip_receiver_jobs`.

**major** `shared/config.json:14` / `shared/config.json:59` — 878 now runs the R365 tip-rule check against Cary’s default receivers. `daily_rule_tips` is not gated on `pos`; it runs whenever shift Charge Tips exist (`payroll.py:473`). Defaults are Shift Leader / Team Member / ASM - Hourly / Bev Attend. Camden Square receivers are Shift Leader / Team Member / GM - Hourly / GM - Salary / ASM - Hourly. Toni Langley will look like “payout vs rule $0”, and everyone else’s rule share will be wrong. ADP still follows `_tips.txt`, but the Medium “Tip payout differs from the tip rule” check (`payroll.py:374`) will misfire. This commit added unused `r365_tip_rule: "Camden Square"` (`shared/config.json:64`) and skipped the override `SKILL.md:156` says must mirror the store’s rule.

**major** `skills/fhs-payroll-adp/references/extract-formats.md:40` / `skills/fhs-payroll-adp/SKILL.md:27` — For 10/19–11/1, R365 has no tip days on 10/19–10/20 by design. extract-formats still says: if any day is missing, do not write `_tips.txt` and let the daily rule run. SKILL.md only says “tell the owner those two days are entered in ADP by hand.” It never says to date-filter reports/extracts to 10/21–11/1, or that the script’s ADP table is Toast days only. An agent following both will drop `_tips.txt` for the whole period (Toast days paid from the already-wrong daily rule) and/or extract the full `period.py` range and also hand-enter NCR (double-count if R365 imported those hours). Same window: `_tip_sources` for 10/19–10/20 with card tips > 0 and no R365 contributor is a High misfire (`payroll.py:167`).

**minor** `skills/fhs-skills/SKILL.md:3` — Front-door YAML still lists NCR/Aloha as a live system to run. The library table was updated; this trigger text was not.

**minor** `skills/fhs-skills/references/tech-stack.md:22` — Data-flow still sends NCR Time Clock Detail / Tip Income into the payroll skill. That path was removed. The history rows (`tech-stack.md:12`, `tech-stack.md:39`) are still true; this line is not.

**minor** `skills/fhs-payroll-adp/SKILL.md:30` — “The NCR version is in git history before the Drop NCR support commit” is not owner language and tells the agent to go looking in git during payroll. The hand-entry sentence on `SKILL.md:29` is clear; this line is not. Step 2 still says reports “depend on `pos`” with only one row (`SKILL.md:51`).

**minor** `shared/config.json:62` — JSON is valid. 878 matches 122 on `pos`, `r365_location`, `r365_tip_rule`, and `adp_company`. It is missing 122’s `toast_location` and `toast_restaurant_group_id` (commented, so a file-based run is fine; browser fallback for 878 cannot build the Toast URL in `browser-recipes.md:9`). It also inherits empty `shared_logins` / `non_employee_accounts` / `exclude_from_payroll`, so Cashier2 or KIOSK - 550 in an R365 hours file would be paid at 878 and skipped at 122. Not a script crash; not consistent with 122’s toast_r365 shape.
