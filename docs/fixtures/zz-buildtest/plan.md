# Plan · zz-buildtest-01 · Throwaway end-to-end test (fixture)

2026-10-10. Test fixture for framework-setup-02 case T18. Lives only on branch `zz-buildtest`.

## Verdict

Build.

## Files the builder may edit

- `docs/zz-hello.md` (new, one line)

## Files the builder must not edit

- Everything else.

## Live systems touched

None.

## Done-check (real outcome)

`git diff --name-only zz-buildtest...feat/zz-buildtest` shows only `docs/zz-hello.md`.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. Never touched; this branch is never merged.
- **Builder tree:** `/srv/fhs-build/zz-buildtest`.

## What stays

Everything.
