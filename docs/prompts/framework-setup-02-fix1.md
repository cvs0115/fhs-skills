# Agent task · framework-setup-02 · fix round 1 (build)

> **For the coding agent (Grok 4.7 High in cursor-agent), as `fhsbuild`.** This file is your whole assignment.
> It's a fix round on the same branch, under the same approved plan `docs/plans/framework-setup-02.md`.
> Hand-off: "Do the task in docs/prompts/framework-setup-02-fix1.md". Read it from `/srv/fhs-build/reports/framework-setup-02-fix1.md`
> if your clone doesn't have it.

## Context

The Ops agent's end-to-end test (test plan case T18) found a bug in `scripts/build.sh collect`. As root, it fetches
`feat/<name>` from the fhsbuild-owned clone with `git -C "$FHS_REPO" -c safe.directory="$FHS_BUILD_ROOT/<name>" fetch ...`.
Git 2.43 refused with "dubious ownership" of `$FHS_BUILD_ROOT/<name>/.git`. Two causes: the ownership check is applied to
the `.git` directory, and a `-c safe.directory` on the outer git doesn't reach the `git upload-pack` process that reads the clone.

Evidence: `/srv/fhs-build/reports/framework-setup-02-ops-E.md`, sections "T18" and "T18 diagnostics".

## Where you work

- Workspace: `/srv/fhs-build/framework-setup-02`, on the existing branch `feat/framework-setup-02` (don't create a new branch).

## Steps

1. In `scripts/build.sh` `collect`, make the fetch work when root fetches from a clone owned by another user, **without changing any
   global or system git config** and without `safe.directory='*'`. Use:
   ```
   git -C "$FHS_REPO" fetch \
     --upload-pack="git -c safe.directory=$FHS_BUILD_ROOT/$name -c safe.directory=$FHS_BUILD_ROOT/$name/.git upload-pack" \
     "$FHS_BUILD_ROOT/$name" "feat/$name:feat/$name"
   ```
   Keep the existing checks (name guard, the report must exist) and output lines unchanged.
2. In `scripts/tests/test_framework.sh`, add one case `collect-uses-upload-pack-safe-dir`: it checks that `scripts/build.sh`
   contains `--upload-pack=` with both the `$FHS_BUILD_ROOT/$name` and `$FHS_BUILD_ROOT/$name/.git` safe.directory values,
   and no `safe.directory='*'` or `safe.directory=*`. (The real cross-user fetch can only be proven by root. Ops re-runs T18 for that.)

## You may edit only

- `scripts/build.sh` (the `collect` fetch only)
- `scripts/tests/test_framework.sh` (the one new case)

## You must not

- Edit anything else. Change git config (global, system or repo). Push, merge, use sudo.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_framework.sh; echo exit=$?` → every line PASS (now 24), `exit=0`
2. `bash -n scripts/build.sh scripts/tests/test_framework.sh` → no output
3. `git diff --name-only HEAD~1..HEAD` (after your commit) → only `scripts/build.sh` and `scripts/tests/test_framework.sh`
4. `git diff --name-only main...HEAD` → still only the 12 files from round 1
5. `git status --short` → empty

## When done

1. Commit on `feat/framework-setup-02` with message `build.sh collect: pass safe.directory to upload-pack (fix T18)` and the line
   `Co-Authored-By: Grok 4.7 High (cursor-agent)`. Use the same one-shot author as round 1 (`git -c user.name=... -c user.email=...`).
2. Append a "Fix round 1" section to `/srv/fhs-build/reports/framework-setup-02.md`: commit hash, files changed, tests n/5 with output.

If a step can't be done exactly as written, stop, write the reason in the report, and don't work around it.
