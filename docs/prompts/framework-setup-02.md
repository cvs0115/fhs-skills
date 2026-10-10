# Agent task · framework-setup-02 · build

> **For the coding agent (Grok 4.7 High in cursor-agent).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan by GPT-5.6 (`docs/reviews/framework-setup-02.md` must say APPROVE).
> Hand-off: the owner tells you "Do the task in docs/prompts/framework-setup-02.md".

## Context

fhs-skills is a repo of Claude skills that run a Firehouse Subs owner's back office (Toast POS,
Restaurant365, ADP RUN, NCR, Dropbox). The repo's process: Claude writes a plan and a task file
like this one, GPT-5.6 reviews them, a Grok agent (you) builds and tests, GPT-5.6 reviews the
diff, and an Ops agent (root, every command approved by the owner) merges. Your job is to build the small shell tooling that enforces that
process: a review-verdict parser, guards, a `build.sh` that prepares a builder's clone and
collects its branch, review.sh updates, tests, and the rule text in `CLAUDE.md`.

## Where you work

- Workspace: `/srv/fhs-build/framework-setup-02`, your own clone. Work only here.
- Before your first edit: `git checkout -b feat/framework-setup-02`
- You run as user `fhsbuild`. You can't reach `/root`, and you don't need to. Every path below is
  relative to your workspace unless it says otherwise.

## Read first

1. `CLAUDE.md`
2. `docs/plans/framework-setup-02.md` (the approved plan. If this task file and the plan disagree, stop and report it.)
3. `scripts/review.sh` (the current script you'll change)
4. `docs/templates/review.md` (the review form your parser reads)

## Steps

### 1. `scripts/lib/verdict.sh` (new, bash, meant to be sourced)

Function `verdict <file>`: prints exactly one of `APPROVE`, `APPROVE AFTER FIXES`, `REJECT`, `NONE`,
and always returns 0.
- Find the first line that is exactly `## Verdict` (trailing spaces allowed). Take the first
  non-empty line after it.
- If that line starts with `APPROVE AFTER FIXES` → that. Else if it starts with `REJECT` → that.
  Else if it starts with `APPROVE` → that. Else `NONE`. Leading `**` or spaces are ignored.
- A missing file, no `## Verdict` heading, or no non-empty line after it → `NONE`.
- When run directly (`bash scripts/lib/verdict.sh <file>`), it prints the verdict.

### 2. `scripts/lib/guards.sh` (new, bash, meant to be sourced)

- `check_review_model <model>`: returns 0 only for exactly `gpt-5.6-sol-high`. Otherwise prints
  `review model must be gpt-5.6-sol-high (owner decision 2026-10-10), got: <model>` to stderr and returns 2.
- `check_name <name>`: returns 0 only if it matches `^[a-z0-9][a-z0-9-]{1,40}$`. Otherwise prints a message to stderr and returns 2.

### 3. `scripts/build.sh` (new, bash, `set -euo pipefail`, executable)

Settings from the environment, for testing: `FHS_REPO` (default `/root/fhs-skills`) and
`FHS_BUILD_ROOT` (default `/srv/fhs-build`). It sources both libs from its own directory.

`build.sh prepare <plan-path> <name> [--base <branch>] [--check-only]`
1. `<plan-path>` must be `docs/plans/<plan>.md`. `<plan>` is its basename without `.md`.
   `check_name <name>`. `--base` defaults to `main`.
2. In `$FHS_REPO` on branch `<base>`: each of `docs/plans/<plan>.md`, `docs/prompts/<plan>.md`,
   `docs/tests/<plan>.md` and `docs/reviews/<plan>.md` must exist in that branch's tree (`git -C "$FHS_REPO" cat-file -e "<base>:<path>"`).
   Otherwise exit 3 and name the missing file.
3. `verdict` of the review (read with `git show "<base>:docs/reviews/<plan>.md"` into a temp file)
   must be `APPROVE`. Otherwise exit 3 and print the verdict found.
4. Refuse (exit 4) if `$FHS_BUILD_ROOT/<name>` exists or `git -C "$FHS_REPO" rev-parse --verify -q "feat/<name>"` succeeds.
5. With `--check-only`, print `OK: ready to prepare <name> from <base>` and exit 0 here.
6. Otherwise it must run as root (`[[ $EUID -eq 0 ]]`, else exit 5):
   `git clone --no-hardlinks --branch "<base>" "$FHS_REPO" "$FHS_BUILD_ROOT/<name>"`,
   `mkdir -p "$FHS_BUILD_ROOT/reports"`, `chown -R fhsbuild: "$FHS_BUILD_ROOT/<name>" "$FHS_BUILD_ROOT/reports"`.
7. Print the hand-off, exactly these two lines with the values filled in:
   `Start Grok: sudo -u fhsbuild -H $FHS_BUILD_ROOT/.local/bin/agent --model grok-4.7-high --workspace $FHS_BUILD_ROOT/<name>`
   `Tell it: Do the task in docs/prompts/<plan>.md`

`build.sh collect <name>`
1. `check_name`. Refuse (exit 3) if `$FHS_BUILD_ROOT/reports/<name>.md` is missing.
2. `git -C "$FHS_REPO" -c safe.directory="$FHS_BUILD_ROOT/<name>" fetch "$FHS_BUILD_ROOT/<name>" "feat/<name>:feat/<name>"`
3. Print the report file, then the line `Next: scripts/review.sh --diff feat/<name>`.

With no arguments or unknown arguments, print usage and exit 2.

### 4. `scripts/review.sh` (change)

- Source `lib/guards.sh` and `lib/verdict.sh`. Replace the current Claude-name check with
  `check_review_model "$MODEL"` (default stays `gpt-5.6-sol-high`). Exit 2 if it fails.
- `REPO` becomes `${FHS_REPO:-/root/fhs-skills}`, not the current checkout's toplevel.
- Plan mode is unchanged: it reviews `docs/plans/<x>.md` in `$REPO`, and the reviewer also reads
  `docs/prompts/<x>.md` if it exists. Add that file to the "Subject" line.
- `--diff <branch>`: create a temporary worktree `$REPO/../fhs-skills-wt/review-<branch basename>`
  (`git -C "$REPO" worktree add --detach <path> <branch>`), run the reviewer with `--workspace <path>`,
  write the review to `$REPO/docs/reviews/<branch basename>-diff.md` (through a `.tmp` file, renamed at the end), and always
  remove the worktree **and the `.tmp` file** afterward (`trap ... EXIT`), even on failure.
- `--diff` first requires both reports, `${FHS_BUILD_ROOT:-/srv/fhs-build}/reports/<name>.md` (builder) and `<name>-test.md`
  (tester), where `<name>` is the branch basename without `feat/`. If either is missing, exit 3 before creating the worktree. Name both
  report paths in the reviewer prompt and tell it to check the reported test results against the diff. The prompt tells it to compare against `main` and against the
  plan and task file if the branch names them.
- The final verdict print uses `verdict "$OUT"`.
- Add `--check-only` (any mode): validate the arguments and the model, print `OK`, and exit 0 without calling cursor-agent.

### 5. `scripts/tests/test_framework.sh` (new) and `scripts/tests/fixtures/`

Plain bash, no frameworks. Each case prints `PASS <name>` or `FAIL <name>: <detail>`, and the script
exits 1 if any case fails. It builds a throwaway git repo under `mktemp -d` (with its own
`user.email`/`user.name` set) as `FHS_REPO`, and a temp dir as `FHS_BUILD_ROOT`. It never touches
`/root` or `/srv/fhs-build`.
Fixtures: `review-approve.md`, `review-approve-after-fixes.md`, `review-reject.md`, `review-none.md`
(no Verdict section), and `review-bold.md` (`**APPROVE AFTER FIXES**. text`).
Cases:
1. `verdict` gives each fixture's expected value, and a missing file gives `NONE`.
2. `build.sh prepare --check-only` on plan `zz-01`:
   - with an APPROVE review → exit 0;
   - APPROVE AFTER FIXES → exit 3; REJECT → exit 3; no review → exit 3; no task file → exit 3; no test plan → exit 3;
   - bad name `Bad_Name` → exit 2; an existing branch `feat/zz` → exit 4;
   - `--base side` where only branch `side` has the files → exit 0, while the same check on `main` → exit 3.
3. `build.sh prepare` without `--check-only`, as non-root → exit 5 and no directory created.
4. `build.sh collect zz` with no report → exit 3.
5. `REVIEW_MODEL=grok-4.7-high scripts/review.sh --check-only docs/plans/zz-01.md` → exit 2;
   `REVIEW_MODEL=claude-x` → exit 2; the default model → exit 0.
   `scripts/review.sh --diff feat/zz` with no reports in `$FHS_BUILD_ROOT/reports` → exit 3, and no worktree is created.
6. `bash -n` on `scripts/build.sh`, `scripts/review.sh`, `scripts/lib/*.sh`.

### 6. `CLAUDE.md` (change)

- Replace the whole "## Subagents" section with "## Roles", holding the role table from the plan's
  "Roles" section (copy it exactly) and these bullets:
  - Claude writes specs, plans, task files (`docs/prompts/<plan>.md`, form `docs/templates/prompt.md`) and test plans
    (`docs/tests/<plan>.md`, form `docs/templates/test-plan.md`). Claude doesn't write code or scripts.
  - A fresh Grok session (never the builder's) runs the test plan. Browser tests use the server's Playwright browser when it exists, otherwise Chrome on the Windows PC.
  - Once a plan is APPROVE, commit its plan, task file, test plan and review to `main` before `scripts/build.sh prepare` (prepare checks them in the committed tree).
  - The owner hands each task file to a Grok 4.7 High agent running as `fhsbuild` in the clone that `scripts/build.sh prepare` made.
  - No builder-written code runs as root until a diff review of it is APPROVE.
  - The Ops agent commits every review file to `main` right after it's written (docs only). Before a new review of the same
    subject, the earlier file is renamed `<name>-rN.md`, so every verdict is kept.
  - After the builder's report: `scripts/build.sh collect <name>`; the tester runs the test plan; then `scripts/review.sh --diff feat/<name>`
    (the reviewer reads both reports); merge on APPROVE with every pre-merge test PASS. Post-merge cases are verified after the merge; a failure opens a fix plan.
  - Base prompts for other roles are in `app-framework/agents/`. Substitute `main` for `develop` and the hub db for `docs/board.md`/`docs/decisions.md`.
- In "The loop (lean)", step 5 becomes: `**Build** by a Grok agent from the task file, in its own clone (`scripts/build.sh prepare`), never in `/root/fhs-skills` (see Served trees).`
- In "Served trees", replace the worktree bullet `build in a worktree: ...` with
  `builds happen in /srv/fhs-build/<name> clones owned by fhsbuild; reviews use temporary worktrees under /root/fhs-skills-wt/;`
- In "Where things live", add the row `| Task files for coding agents | docs/prompts/<plan>.md (form: docs/templates/prompt.md) |` after the "Written plans" row,
  the row `| Test plans for tester agents | docs/tests/<plan>.md (form: docs/templates/test-plan.md) |` after that,
  and the row `| Agent reports | /srv/fhs-build/reports/<name>.md and <name>-test.md (not in git) |` after "Review verdicts".
- Keep the file under 200 lines. Change nothing else.

### 7. `README.md` (change)

In the `docs/` row, change the text to: `Specs, research notes, plans, task files for coding agents (docs/prompts/), test plans for tester agents (docs/tests/), and review verdicts (forms in docs/templates/)`.

## You may edit only

- `scripts/lib/verdict.sh`, `scripts/lib/guards.sh`, `scripts/build.sh` (new)
- `scripts/review.sh`
- `scripts/tests/test_framework.sh`, `scripts/tests/fixtures/*` (new)
- `CLAUDE.md`, `README.md` (only the parts named above)

## You must not

- Edit any other file, including `skills/`, `shared/`, `artifacts/`, `memory/`, `app-framework/`,
  `docs/plans/`, `docs/reviews/`, `docs/prompts/`, `docs/templates/`, `.env*`.
- Run `scripts/review.sh` without `--check-only`, or call cursor-agent yourself.
- Push, merge, or commit to `main`. Log in to anything. Install packages. Use `sudo`.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_framework.sh` → every line `PASS`, exit 0
2. `bash -n scripts/build.sh scripts/review.sh scripts/lib/verdict.sh scripts/lib/guards.sh scripts/tests/test_framework.sh` → no output
3. `git diff --stat main...HEAD` → only the files in "You may edit only"
4. `wc -l CLAUDE.md` → under 200
5. `git status --short` → empty after your commit

## When done

1. Commit on `feat/framework-setup-02` (one or a few commits). End each message with
   `Co-Authored-By: Grok 4.7 High (cursor-agent)`.
2. Write your report to `/srv/fhs-build/reports/framework-setup-02.md`:

```text
Task: framework-setup-02 · Branch: feat/framework-setup-02 · Commits: <hashes>
Files changed: <list>
Tests: <n>/5 passed. For each: command, trimmed output, pass/fail
Deviations or open issues: <list, or none>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.
