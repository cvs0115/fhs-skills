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
| Review verdicts | `docs/reviews/<plan-file-name>[-diff].md` (form: `docs/templates/review.md`) |
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
5. **Build** on a branch in a worktree, never in `/root/fhs-skills` itself (see Served trees).
6. **Verify by the real outcome.** Run it against a real week folder or a real R365 or Toast
   screen and compare the numbers. A clean run or a written file proves nothing. The writer
   doesn't grade its own work.
7. **Merge, then report and stop.** One step per turn. Update the hub and plan page the same turn.

## Served trees (where a change goes live)

- **Server sessions:** `/root/.claude/skills/fhs-*` are symlinks to `/root/fhs-skills/skills/`.
  Whatever is checked out in `/root/fhs-skills` on `main` is live immediately. So:
  - build in a worktree: `git worktree add /root/fhs-skills-wt/<name> -b feat/<name> main`;
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

## Subagents

- Researcher (read-only), Planner (writes one plan file), Builder (one worktree branch), Verifier
  (fresh context, reports only). Reviewer = `scripts/review.sh`. Base prompts are in
  `app-framework/agents/`. Substitute before you use one: `main`, not `develop`. The hub db, not
  `docs/board.md` or `docs/decisions.md`. Worktrees under `/root/fhs-skills-wt/`. A builder never
  edits the hub.
- Build in series for now: one builder at a time. Two builders only if they share no files.
- Every brief names this file, the hub project, the decisions that bind it, the output path and
  the report to return. Subagents don't see the chat.

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
