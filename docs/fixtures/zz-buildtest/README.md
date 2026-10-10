# Fixture · zz-buildtest (throwaway end-to-end test for framework-setup-02, case T18)

Not a real plan. The Ops agent copies these files onto the temporary branch `zz-buildtest` only:

| Fixture file | Copied to (on branch `zz-buildtest` only) |
|---|---|
| `plan.md` | `docs/plans/zz-buildtest-01.md` |
| `prompt.md` | `docs/prompts/zz-buildtest-01.md` |
| `test.md` | `docs/tests/zz-buildtest-01.md` |
| `review-fixture.md` | `docs/reviews/zz-buildtest-01.md` |

`review-fixture.md` is a **labelled test fixture**, not a GPT-5.6 review. It exists only so `build.sh prepare`
can be exercised end to end. The `zz-buildtest` branch is deleted afterward (T19), and none of these paths ever reach `main`.
