# Plan · framework-setup-02 · Grok builds and tests from Claude's prompts; GPT-5.6 reviews

2026-10-10 (revised after reviews framework-setup-02-r1 to -r6). Plan only, not approved. Don't build from it
until `docs/reviews/framework-setup-02.md` holds an APPROVE. The reviewer checks this plan
**and its prompt** `docs/prompts/framework-setup-02.md` together.

- Hub project: none (library process). Spec: `docs/specs/framework-setup.md` (P1 roles).
- Research: `docs/research/access-browser-windows.md`, `docs/research/framework-setup-review-tool.md`
- Decisions that bind it (hub log, owner, 2026-10-10): lean process; the hub is the Board; the
  reviewer is GPT-5.6 Sol; **builders are cursor-agent on grok-4.7-high**; **Claude plans and writes
  the prompts, and the Grok agents build and test**.

## Verdict

Build.

## What changes, in plain words

From now on, Claude's output for each change is a reviewed plan plus a task file (`docs/prompts/<plan>.md`)
that the owner hands to a Grok coding agent. Grok builds and tests from that file alone. It runs as its own restricted user in its own copy of the
repo, so it physically can't change the live skills. GPT-5.6 reviews the plan and prompt before
the build, and Grok's change before the merge.

## Roles

| Role | Who | Writes |
|---|---|---|
| Planner | Claude | specs, plans, task files (`docs/prompts/`), test plans (`docs/tests/`), the runbook, hub; no code, no ops |
| Ops | cursor-agent `grok-4.7-high` as root, **without `--force`** (the owner approves every command), from `docs/prompts/ops-*.md` | commits docs and reviews, creates the user, clones, fetches, runs `build.sh`/`review.sh`, runs root-only test cases, merges after an APPROVE |
| Reviewer | cursor-agent `gpt-5.6-sol-high`, `--mode plan`, as root, read-only | one verdict file |
| Builder and Tester | cursor-agent `grok-4.7-high`, `--force`, as user `fhsbuild` in `/srv/fhs-build/<name>` | commits on `feat/<name>` in its clone; a report outside the repo |
| Researcher | the same Grok setup, with a research prompt; writes only its research note | `docs/research/<file>` in its clone |
| Tester | a fresh Grok 4.7 High session (never the builder's), from `docs/tests/<plan>.md`; shell, Playwright (server browser) or Chrome on the Windows PC | a results file outside the repo |

Claude doesn't write code or scripts. Family rule: Claude's plans and prompts → GPT reviews them.
Grok's diffs → GPT reviews them. Grok runs the tests named in the prompt, and GPT checks the
reported results against the diff.

## Isolation (fixes r1 major 3)

- New system user `fhsbuild`: no sudo, home `/srv/fhs-build`, shell `/bin/bash`. `/root` is
  `drwx------`, so `fhsbuild` can't read or write `/root/fhs-skills` or `/root/.claude`.
- Each build gets a **clone**, not a worktree:
  `git clone --no-hardlinks /root/fhs-skills /srv/fhs-build/<name>`, done by root, then `chown -R fhsbuild:`.
  A clone has no link back into `/root/fhs-skills/.git`.
- After the build, root pulls only the branch back:
  `git -C /root/fhs-skills -c safe.directory=/srv/fhs-build/<name> fetch /srv/fhs-build/<name> feat/<name>:feat/<name>`.
  No hooks from the clone run on the root side.
- `fhsbuild` gets its own cursor-agent install and sign-in. The owner runs the login. No auth files
  are copied from root.

## Bootstrap setup (operations, not code). The Ops agent runs these from `docs/prompts/ops-01-bootstrap.md`, each command approved by the owner

1. `useradd --system --create-home --home-dir /srv/fhs-build --shell /bin/bash fhsbuild && chmod 750 /srv/fhs-build`
2. Install cursor-agent for `fhsbuild`: `sudo -u fhsbuild -H bash -c 'curl https://cursor.com/install -fsS | bash'` `(?)`.
   The installer URL is checked against Cursor's docs before it runs.
3. The owner signs it in: `sudo -u fhsbuild -H env NO_OPEN_BROWSER=1 /srv/fhs-build/.local/bin/agent login`, then opens the printed URL.
4. Check: `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent status` shows logged in, and
   `sudo -u fhsbuild touch /root/fhs-skills/x` fails with "Permission denied".
5. Commit to `main`: `docs/{plans,prompts,tests,reviews,specs,research,templates}/*.md` and the `.gitkeep` files (never `*.tmp`).
   That's every plan, task file, test plan and review (including `docs/reviews/browser-01-r1.md`), the specs, the research, and the
   forms `docs/templates/prompt.md` and `docs/templates/test-plan.md`, so the clone contains them (fixes r1 major 5, r2 major 2, r3 major 3). The owner's decision to build in `fhsbuild` clones rather than worktrees is logged on the hub
   and noted in `docs/specs/framework-setup.md` before this step (r2 major 1).
6. Create the clone for this build by hand (the same commands `build.sh prepare` will run). The owner starts Grok as `fhsbuild`
   in it and tells it: "Do the task in docs/prompts/framework-setup-02.md".

If step 2 or 3 can't be done (the installer needs root, or the login can't be done for a second
user), stop and ask the owner. Don't fall back to running Grok as root.

## Files the builder may edit (in its clone)

- `scripts/lib/verdict.sh` (new): `verdict <review.md>` prints exactly `APPROVE`,
  `APPROVE AFTER FIXES`, `REJECT` or `NONE`. It reads the first non-empty line after `## Verdict`,
  takes the leading token before the first `.`, and matches `APPROVE AFTER FIXES` before `APPROVE`
  (fixes r1 major 1).
- `scripts/lib/guards.sh` (new): `check_review_model` (only exactly `gpt-5.6-sol-high`) and
  `check_name` (`^[a-z0-9][a-z0-9-]{1,40}$`) (fixes r1 major 2). The builder model `grok-4.7-high` is
  pinned in each task file's header and the hand-off line that `build.sh prepare` prints. Changing either model is a new
  owner decision plus an edit.
- `scripts/build.sh` (new), run by root. It doesn't start the agent; the owner hands the agent its task file.
  - `scripts/build.sh prepare docs/plans/<plan>.md <name> [--base <branch>]`:
    1. guards; the plan, task file, test plan and review must exist in the base branch's committed tree
       (`git cat-file -e <base>:<path>`), and `verdict` of the committed review must be `APPROVE`
    2. refuses if `/srv/fhs-build/<name>` or branch `feat/<name>` already exists
    3. clones the base branch to `/srv/fhs-build/<name>`, `chown -R fhsbuild:`
    4. prints the hand-off: "Start Grok as fhsbuild in /srv/fhs-build/<name>
       (`sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model grok-4.7-high --workspace /srv/fhs-build/<name>`)
       and tell it: Do the task in docs/prompts/<plan>.md"
  - `scripts/build.sh collect <name>`: refuses if `/srv/fhs-build/reports/<name>.md` is missing; fetches
    `feat/<name>` into `/root/fhs-skills`; prints the report and the next step (`scripts/review.sh --diff feat/<name>`)
  - `--check-only` with `prepare` runs steps 1–2 only (used by the tests)
- `scripts/review.sh`: use `guards.sh` and `verdict.sh`. `--diff` reviews run in a temporary worktree
  of the branch under `/root/fhs-skills-wt/review-<name>` (root, read-only review). They require the builder report
  `/srv/fhs-build/reports/<name>.md` and the tester report `<name>-test.md`, and pass both to the reviewer. A `trap` removes the
  worktree and the `.tmp` output on success and on failure.
- `scripts/tests/test_framework.sh` (new) and `scripts/tests/fixtures/` (new; fix round 3 adds four verdict-typo fixtures): fixture reviews for
  all three verdicts and a missing verdict; fixture plans with and without an APPROVE.
- `CLAUDE.md`: the "Subagents" section becomes "Roles" (the table above). Loop step 5 = `scripts/build.sh`.
  Claude writes plans and prompts, not code. Add the prompt form `docs/templates/prompt.md` to "Where things live".
- `README.md`: the docs row mentions `docs/prompts/`.

Reports never go in the repo (fixes r1 major 4). They live at `/srv/fhs-build/reports/<name>.md`.

## Files the builder must not edit

- `skills/**`, `shared/**`, `artifacts/**`, `memory/**`, `.env*`, `app-framework/**`, `docs/plans/**`,
  `docs/reviews/**`, `docs/prompts/**`, `docs/templates/**`

## Live systems touched

- **Server:** new user `fhsbuild`, its home `/srv/fhs-build`, its cursor-agent install and sign-in
  (bootstrap steps 1–3, each OK'd). Rollback: `userdel -r fhsbuild`.
- No Toast, R365 or ADP.

## Sequence (no builder-written code runs as root before a code review APPROVE)

1. Grok builds as `fhsbuild` and runs its own tests. Report: `/srv/fhs-build/reports/framework-setup-02.md`.
2. A fresh Grok tester runs T1–T15 as `fhsbuild` and writes a **provisional** results file
   `/srv/fhs-build/reports/framework-setup-02-test.md` (T16–T19 BLOCKED).
3. Root fetches the branch with plain `git fetch` (no branch code runs):
   `git -C /root/fhs-skills -c safe.directory=/srv/fhs-build/framework-setup-02 fetch /srv/fhs-build/framework-setup-02 feat/framework-setup-02:feat/framework-setup-02`
4. **Code review gate:** `scripts/review.sh --diff feat/framework-setup-02`, run with the **trusted `review.sh` already on `main`**
   (not the branch's). It writes `docs/reviews/framework-setup-02-diff.md`. The Ops agent renames it to `framework-setup-02-diff-r1.md`
   and commits it to `main` right away (docs only), so `/root/fhs-skills` is clean again and the approval is kept. It must be APPROVE.
   Otherwise Grok fixes and steps 1–4 repeat, with the next review kept as `-diff-r2`, `-r3`, and so on.
5. Only after that APPROVE, the Ops agent runs T16–T19 as root with the branch's scripts from `/root/fhs-skills-wt/fs02-run`,
   with the owner's OK. T16 refers to the step-4 review. T17, T17b, T18 and T19 run here.
6. The tester updates the results file with T16–T19 (from the pasted output) to a final ALL PASS.
7. **Final review:** `review.sh --diff` again, with the branch's reviewed `review.sh` (it now exists and was approved in step 4),
   reading both reports. It writes `docs/reviews/framework-setup-02-diff.md`, which the Ops agent commits to `main` right away
   (the `-rN` files stay as the record). It must be APPROVE. If the branch changed after step 4, step 4 repeats first.
8. Merge into `main`, then check `/root/fhs-skills` is clean on `main` and the `/root/.claude/skills/fhs-*` links resolve.

## Done-check (real outcome)

Grok runs 1–3 in its clone and reports the output:
1. `bash scripts/tests/test_framework.sh` covers each verdict fixture parsed correctly, a missing
   verdict giving `NONE`, `build.sh prepare --check-only` refusing a plan whose review is `APPROVE AFTER FIXES`,
   a REJECT review, a missing review, a missing task file, a bad name and an existing branch, and accepting
   an APPROVE fixture with `--base`. `review.sh` refuses `REVIEW_MODEL=grok-4.7-high` and `REVIEW_MODEL=claude-x`. All pass.
2. `bash -n` on every changed script.
3. `git diff --stat main...feat/framework-setup-02` lists only the allowed files.

The Ops agent, before the merge, with the owner approving each command, using the branch's scripts from a root worktree
`/root/fhs-skills-wt/fs02-run` of `feat/framework-setup-02` (`FHS_REPO=/root/fhs-skills`):
4. Isolation: `sudo -u fhsbuild touch /root/fhs-skills/x` fails, and `sudo -u fhsbuild ls /root` fails.
5. End to end: Claude has written plan `zz-buildtest-01` (add `docs/zz-hello.md` with one line), its task file, its test plan
   and a labelled APPROVE fixture review in `docs/fixtures/zz-buildtest/`. The Ops agent copies them to their normal `docs/` paths and commits them on a temporary branch `zz-buildtest`
   checked out in `/root/fhs-skills-wt/zz-base`. `build.sh prepare docs/plans/zz-buildtest-01.md zz-buildtest --base zz-buildtest`;
   the owner starts Grok as `fhsbuild` with "Do the task in docs/prompts/zz-buildtest-01.md"; then `build.sh collect zz-buildtest`.
   Expected: `git diff --stat zz-buildtest...feat/zz-buildtest` shows only `docs/zz-hello.md`;
   `git -C /root/fhs-skills status` is clean and its `main` hash is unchanged; the report exists in
   `/srv/fhs-build/reports/`.
   **Cleanup:** remove `/srv/fhs-build/zz-buildtest`, the `zz-base` worktree, branches `zz-buildtest`
   and `feat/zz-buildtest`, and the report. The zz plan, task file, test plan and review exist only on `zz-buildtest`, so they go with it. `main` never contains the zz files.
6. An independent Grok tester (a fresh session, not the builder) runs `docs/tests/framework-setup-02.md`: every case PASS
   (T18–T19 are the end-to-end run in 5, recorded by the tester from the Ops agent's output). Results in
   `/srv/fhs-build/reports/framework-setup-02-test.md`.
7. After every diff review, successful or failed, `git -C /root/fhs-skills worktree list` shows no `review-*` worktree, and
   `docs/reviews/` has no `*.tmp` file.
8. The diff review of `feat/framework-setup-02` is APPROVE before the merge.

**Merge gate** = done-checks 1–8, all before the merge. After the merge: `/root/fhs-skills` is clean on `main`, and both
`/root/.claude/skills/fhs-*` links still resolve.

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, through `/root/.claude/skills/fhs-*`.
  Nothing under `skills/` changes. The new roles and scripts take effect on merge.
- **Builder tree:** `/srv/fhs-build/<name>`, owned by `fhsbuild`, never loaded by any session.
- **Windows mirror:** not affected.
- **Live before merge:** the `fhsbuild` user exists (bootstrap). Otherwise sessions see today's rules.

## Where the builder works

- `/srv/fhs-build/framework-setup-02` (clone of `main` after step 5) · branch `feat/framework-setup-02`
- Task file: `docs/prompts/framework-setup-02.md` · Model: grok-4.7-high · User: `fhsbuild` · started by the owner

## What stays

Plan-before-build, the hub as Board and Decision Log, the owner rules in `skills/fhs-skills/SKILL.md`,
every live-system change needing the owner's yes at the time, and reports kept out of git.
