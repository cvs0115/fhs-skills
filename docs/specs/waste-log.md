# Spec · waste-log · Waste log (F6)

2026-10-13 · Hub project: `projects/waste-log` (to create) · Plan page: none yet

## Problem and today

- **Problem:** nearly no waste is recorded, so food cost can't explain where product went. Actual vs theoretical (F7) will show a gap with no cause.
- **Today (122, audit 2026-10-11):** R365 has one waste log ever (WL-000002, 09/28/2026, 1 item, $0.92, Approved). Toast food waste this month is $0 / 0 items. Waste Create is enabled for this login. The owner owns this function (O1). Toast void/waste reason setup page not found `(?)`.

## Who runs it

- Store manager logs waste when it happens; the owner (or Claude, read-only) checks weekly: "Was waste logged, and is it plausible?"

## Done when (measurable)

1. [NEEDS CLARIFICATION] Waste is logged at 122 for 2 weeks running, with a normal-range check agreed with the owner.
2. The skill states, in plain words, where each kind of waste goes (R365 waste log vs Toast void reason) and the steps for the manager.

## In scope

- P0: research how waste really works in R365 (waste log fields, reasons, accounts, cost source) and Toast (void reasons, food waste report). Read-only.
- P1: a short manager guide and a weekly "was waste logged" check in `fhs-skills` (Phase 5).
- P2: waste feeds AvT ("Variance includes waste").

## Out of scope

- Changing R365 items or accounts (franchise / support owned). Entering waste for the manager.

## Systems and data

| Data | Source of truth | How Claude gets it | Verified? |
|---|---|---|---|
| Waste logs | R365 Inventory → Waste | PC capture, read-only | partly (F6-01) |
| Food waste / voids | Toast Menus → Food waste reporting | PC capture | partly (F6-02); reason setup `(?)` |
| 878 waste | NCR | unknown | `(?)` |

## Owner rules that bind it

- Read-only research first; one yes per change (`skills/fhs-skills/SKILL.md` Rules).

## Open questions

- [NEEDS CLARIFICATION] Does the manager currently track waste on paper or anywhere else?
- [NEEDS CLARIFICATION] Is the target waste log in R365, Toast voids, or both?
