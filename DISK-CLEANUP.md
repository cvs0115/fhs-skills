# Disk cleanup follow-up (fhs-skills)

Written 2026-10-21 after the dev box hit 92% disk and VS Code Remote-SSH failed. It is now 77%. Cause: scratch installs, leftover dev servers and merged worktrees never cleaned up.

**When the user asks you to continue or clean up: read this file first, re-measure each item (sizes may have changed), do the safe items, and ask before anything marked "ask".** Update the Status section when you finish something.

## Rules
1. Do not run a fresh `npm install` / `pip install` for a throwaway check. Symlink the project's existing `node_modules` / `.venv`, or reuse one shared scratch install.
2. Any server you start (`next dev`, `uvicorn`, `streamlit`, ...) gets its PID recorded and is stopped before you report done.
3. When a branch is merged and its worktree is clean, run `git worktree remove <path>`. Never remove one with uncommitted work or an unmerged branch.
4. Run `df -h /` at session start and before reporting done. Above 80%, stop and tell the user.
5. Never delete real data (`data/`, `*.db`, `uploads/`, `ohlcv_cache/`, `.env*`) without the user's say-so. List it and ask.
6. Delete only paths you created this session. Use explicit paths, never globs over `/root` or `/tmp`.
7. Use `/bin/rm` (plain `rm` is not found in the user's shell).

Facts below were measured on 2026-10-21 (sizes, worktree counts). "Check" means not yet verified.

## This project
- `inbox/` 32 MB. Check whether it holds processed files. Master copy; Windows mirror is refreshed from here, so do not delete tracked files.
- `fhs-skills-wt` is an empty worktree folder; leave it unless the repo no longer uses it.

## Status
- [ ] Not started. Tick items and date them here as they are done.
