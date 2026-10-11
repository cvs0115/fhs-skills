# fhs-skills: working rules for Claude

The door file for building and changing fhs skills. Adapted (lean) from `app-framework/` on
2026-10-10. Stable rules live here; live state lives in the FHS Skills Hub. One fact, one home.
Owner rules for *running* the skills (passwords, money, one yes per change) live in
`skills/fhs-skills/SKILL.md` "Rules" and apply here too. Don't restate them.

## The project in one paragraph

- **What:** Claude skills that run and set up the owner's Firehouse Subs back office: Toast POS,
  Restaurant365 (R365), ADP RUN, NCR/Aloha, Dropbox reports.
- **Who:** the owner, a business owner and not IT or accounting. Plain words, short steps, one choice at a time.
- **Stores:** 122 Cary 1 (Toast + R365), 878 Camden Square (NCR until it moves). Facts in `shared/config.json`.
- **Stack:** skill folders (`SKILL.md` + `references/` + `scripts/*.py`), Python 3, local git (no remote).
- **Checks:** `python3 -m py_compile skills/*/scripts/*.py` · real-data check named in each plan.

## Where things live

| Thing | Home |
|---|---|
| Board (projects, step, waiting on) | Hub db `projects/*` https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc |
| Questions for the owner | Hub db `questions/*` |
| Decision Log | Hub db `log/<YYYY-MM>`, kind `decision` (plus the plan page `notes/<YYYY-MM>`) |
| Per-project phases | that project's plan page db `phases/*` (URLs in `skills/fhs-skills/references/artifacts.md`) |
| Spec per skill or project | `docs/specs/<slug>.md` (form: `docs/templates/spec.md`) |
| Research findings (what a system really does) | `docs/research/<slug>-<topic>.md` |
| Written plans | `docs/plans/<slug>-<nn>.md` (form: `docs/templates/plan.md`) |
| Task files for coding agents | `docs/prompts/<plan>.md` (form: `docs/templates/prompt.md`) |
| Test plans for tester agents | `docs/tests/<plan>.md` (form: `docs/templates/test-plan.md`) |
| Review verdicts | `docs/reviews/<plan-file-name>[-diff].md` (form: `docs/templates/review.md`) |
| Agent reports | `/srv/fhs-build/reports/<name>.md` and `<name>-test.md` (not in git) |
| System facts (menus, paths, owners) | `skills/fhs-skills/references/tech-stack.md` |
| Store facts and owner rules | `shared/config.json` |
| The framework itself (reference, don't edit) | `app-framework/` |

## The loop (lean)

| Change | Path |
|---|---|
| Tweak (typo, one fact in a reference) | edit, commit, log if it is a decision |
| Bug in a skill or script | note: symptom, expected, cause, proof → plan → review → build → verify |
| New skill, new playbook phase, new script | spec → research → plan → review → build → verify on real data |
| Vague idea | start at the spec; ask the owner the must-asks (`app-framework/questions/01-kickoff.md` K1–K5) |

1. **Spec.** Problem, today's way, who runs it, done-when, out of scope. Unknowns marked `[NEEDS CLARIFICATION]`.
2. **Research before design.** Look at what Toast, R365, ADP and the reports really do, read-only,
   with the owner signed in. Write findings to `docs/research/` and new facts to `tech-stack.md`
   the same turn. Mark anything unverified `(?)`. No options menu built on a guessed capability:
   ask for a screenshot, report or export instead.
3. **Written plan** before any non-trivial build. It names the files, the done-check, the served
   tree and what stays. It does not authorize the build by itself.
4. **Cross-model review.** `scripts/review.sh docs/plans/<file>.md` (a plan) or
   `scripts/review.sh --diff feat/<name>` (a branch, run inside its worktree) runs cursor-agent read-only on a
   non-Claude model and writes the verdict to `docs/reviews/`. APPROVE builds. APPROVE AFTER
   FIXES or REJECT goes back to the writer, and the fix is reviewed again. Review the plan
   before the build and the diff before the merge. A missing or wrong served tree is a major.
   An approved plan may end with no build.
5. **Build** by a Composer agent from the task file (research by a Cursor Grok agent), in its own clone (`scripts/build.sh prepare`), never in `/root/fhs-skills` (see Served trees).
6. **Verify by the real outcome.** Run it against a real week folder or a real R365 or Toast
   screen and compare the numbers. A clean run or a written file proves nothing. The writer
   doesn't grade its own work.
7. **Merge, then report and stop.** One step per turn. Update the hub and plan page the same turn.

## Served trees (where a change goes live)

- **Server sessions:** `/root/.claude/skills/fhs-*` are symlinks to `/root/fhs-skills/skills/`.
  Whatever is checked out in `/root/fhs-skills` on `main` is live immediately. So:
  - builds happen in `/srv/fhs-build/<name>` clones owned by fhsbuild; reviews use temporary worktrees under `/root/fhs-skills-wt/`;
  - merging into `main` is the release for server sessions;
  - never leave `/root/fhs-skills` on a feature branch or with half-done edits under `skills/`.
- **Windows desktop (runtime only):** development happens only on dev-lxc-1. Skills that need desktop-only apps (Dropbox,
  NCR downloads, other Windows software) are deployed to the desktop as a copy of reviewed `main`. Every plan names where its
  skill runs (server, desktop or both).
- **Windows sessions (payroll):** the Windows copy is a mirror and stays live until it is
  refreshed. A refresh is its own OK from the owner, and so is any change to a running payroll.
- **Scheduled runs** (later, server move plan): enabling a schedule is a separate OK.

## Asking the owner

- Ask only when the owner must act or choose. Use the question pane: 1–4 questions on one
  topic, recommended option first and marked "(Recommended)", worded so it makes sense without the chat.
- Don't ask what the hub, config, tech-stack, specs, research or memory already answer. State it
  as an assumption instead.
- Log each answer the same turn in the hub `log` (kind `decision`): what was chosen, the options,
  who chose. Defaults taken without asking are logged as assumptions.
- A conflict with an earlier decision is a question: quote both and ask
  (`app-framework/questions/09-change-conflicts.md`). Never route around it.

## Roles

| Role | Who | Writes |
|---|---|---|
| Planner | Claude | specs, briefs (`docs/briefs/<plan>.md`), the runbook, hub; reads verdicts and report summaries; no code, no ops |
| Drafter | `agent -p --mode ask --model cursor-grok-4.6-high`, read-only, stdout redirected to the target file | plan, task file and test plan from Claude's brief and the templates |
| Ops | `agent --model composer-2.5` as root (owner-approved commands, or headless when the owner delegates approval to Claude), from `docs/prompts/ops-*.md` | commits docs and reviews, creates the user, clones, fetches, runs `build.sh`/`review.sh`, runs root-only test cases, merges after an APPROVE |
| Reviewer | `scripts/review.sh`, read-only (`--mode plan`): Claude's plans and Composer's code → `cursor-grok-4.6-xhigh`; Grok's research and Grok-drafted plans → `composer-2.5`. Never the writer's family. | one verdict file |
| Builder and Tester | `agent --model composer-2.5 --force`, as user `fhsbuild` in `/srv/fhs-build/<name>` | commits on `feat/<name>` in its clone; a report outside the repo |
| Researcher | `agent --model cursor-grok-4.6-high --force` as `fhsbuild`, with a research prompt; writes only its research note | `docs/research/<file>` in its clone |
| Tester | a fresh `composer-2.5` session (never the builder's), from `docs/tests/<plan>.md`; shell, Playwright (server browser) or Chrome on the Windows PC | a results file outside the repo |

- Claude writes the spec and a one-page brief (`docs/briefs/<plan>.md`, form `docs/templates/brief.md`). The Drafter (Cursor Grok High)
  turns the brief into the plan, task file (form `docs/templates/prompt.md`) and test plan (form `docs/templates/test-plan.md`). Claude
  checks them against the brief by grep and section reads, not full reads, and doesn't write code or scripts (owner, 2026-10-11).
  Until framework-setup-04 lets `review.sh` send a Grok-drafted plan to Composer, Claude writes plans itself.
- A fresh Composer session (never the builder's) runs the test plan. Browser tests use the server's Playwright browser when it exists, otherwise Chrome on the Windows PC.
- Once a plan is APPROVE, commit its plan, task file, test plan and review to `main` before `scripts/build.sh prepare` (prepare checks them in the committed tree).
- Models (owner decision 2026-10-10: included Cursor models only): Composer 2.5 builds, tests and runs ops; Cursor Grok 4.6 High researches and drafts plans from Claude's briefs (2026-10-11);
  Cursor Grok 4.6 Extra High reviews Claude's plans and Composer's code; Composer 2.5 reviews Grok's research and drafts. No other models are used.
- Each task file is handed to its agent (Composer, or Cursor Grok for research) running as `fhsbuild` in the clone that `scripts/build.sh prepare` made.
- Read-only agent work (reviews, pre-checks, analysis, quick questions) runs with `agent --mode plan` (or `--mode ask`): fewer tokens and
  no edits (owner, 2026-10-10). Only Builders, Testers, Researchers and Ops run in normal mode.
- No builder-written code runs as root until a diff review of it is APPROVE.
- **Fix rounds (owner, 2026-10-11):** for APPROVE AFTER FIXES with only minor findings, the writer's own model fixes them (Composer for code,
  Grok for drafts and research) and the review runs again. Claude steps in only for a major, a REJECT, or a 3rd round of the same subject.
- **Claude runs the agents (owner, 2026-10-11):** Claude starts reviewers, Drafters, Builders and Testers headless (`-p`) with Bash
  `run_in_background` and waits for the notification. It never polls or tails logs. It reads only the verdict line, the findings list, or a
  report's `## Summary`. The fhsbuild sandbox, the stop rules and "no code as root before APPROVE" stay the same.
- The Ops agent commits every review file to `main` right after it's written (docs only). Before a new review of the same
  subject, the earlier file is renamed `<name>-rN.md`, so every verdict is kept.
- After the builder's report: `scripts/build.sh collect <name>`; the tester runs the test plan; then `scripts/review.sh --diff feat/<name>`
  (the reviewer reads both reports); merge on APPROVE with every pre-merge test PASS. Post-merge cases are verified after the merge; a failure opens a fix plan.
- Base prompts for other roles are in `app-framework/agents/`. Substitute `main` for `develop` and the hub db for `docs/board.md`/`docs/decisions.md`.

## Token budget (Claude's session)

Each Claude call re-reads the whole session, so a long session costs far more than its last step.
- One step per session: after a merge or a hand-off, update the hub and runbook, then the owner starts a fresh session (`/clear`). The hub holds the state.
- Read narrowly: `grep`, `sed -n` ranges and `tail -20`, never `cat` of plans, reports or logs. Large hub docs go through `out_dir`.
- To understand a long file (a report, research, a big diff), ask `agent -p --mode ask --model composer-2.5` (or Grok for a Composer-written file) for a 10-line answer.
- Pipe noisy commands through `| tail` or `>/dev/null`. Batch independent calls in one turn.

## Repo rules

- Commit small, one concern each. Commit messages end with the attribution line from the system prompt.
- No secrets in git. `.env` (owner fills it in) holds them. Check for secrets before every commit.
- No remote yet. Pushing anywhere, copying to Windows or Dropbox, and publishing artifacts each need an OK.
- New skill: name `fhs-<topic>`, read `shared/config.json`, never copy store facts into the skill,
  add it to the library table in `skills/fhs-skills/SKILL.md`, the hub `skills` collection and the
  symlinks in `/root/.claude/skills/`.

## Project-specific rules

<!-- Add rules learned while building, each with a one-line why. Keep this file under 200 lines. -->
- R365 settings may be franchise-owned. Research says who owns a setting before a plan changes it. Why: corporate may push the item list and recipes.
