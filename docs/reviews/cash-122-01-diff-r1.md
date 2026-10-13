# Review · cash-122-01-diff

2026-10-13 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE. `feat/cash-122-01` may merge to `main`: only the approved research note and six appended `tech-stack.md` bullets; captures-grounded 14-day join; pre-merge T1–T7 pass per `/srv/fhs-build/reports/cash-122-01-test.md`; no forbidden live writes; served tree unchanged until merge.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- None.

## Minors

- [docs/plans/cash-122-01.md](docs/plans/cash-122-01.md) done-check item 2 and [docs/tests/cash-122-01.md](docs/tests/cash-122-01.md) T3 steps say the sum of matched **Card** must equal the Payout overview **card** total for 09/28–10/11; this capture has two payouts settled in-range whose sales days are 09/26 and 09/27, so overview $12,448.60 and matched-card sum $10,635.00 correctly differ ([docs/research/cash-122.md](docs/research/cash-122.md) `## Payout totals`). T3’s expected line (`overview_card` / `matched_card_sum` / `card_delta=0`) matches the researcher task’s relaxed `totals_ok` (note vs captures), not the steps text—tighten plan done-check and T3 steps on `main` so the gate matches reality (e.g. matched + unmatched card = overview).
- `## Who owns what` is all `unknown` because the captures lack franchise/brand/Created-by labels; acceptable for this read-only pass; a later walk may fill rows when labels appear.
- [docs/plans/cash-122-01.md](docs/plans/cash-122-01.md) header still says “Plan only, not approved”; `docs/reviews/cash-122-01.md` is APPROVE—cosmetic only.
- Post-merge P1 remains BLOCKED until the owner confirms nothing changed in Toast/R365 (tester report); not a merge gate.
