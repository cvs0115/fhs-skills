# Plan · windows-research-01 · Research the Windows agent setup (read-only)

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/windows-research-01.md` holds an APPROVE.
The reviewer checks this plan and its task file `docs/prompts/windows-research-01.md` together.

- Hub project: `projects/server-move` · Spec: `docs/specs/windows-agent.md`
- Replaces: `docs/plans/windows-agent-01.md` (draft, APPROVE AFTER FIXES in `docs/reviews/windows-agent-01-r1.md`). The build plan is rewritten after this research.
- Decisions that bind it: hub log 2026-10-10 (agent on Windows; PC → server only; Claude plans, Grok builds and tests, GPT-5.6 reviews).
- Depends on: framework-setup-02 merged.

## Verdict

Build (a research note only, no code).

## What changes, in plain words

A Grok agent on the server works out how a Windows agent would get the repo, push its work back
safely, and refresh the Windows skill copy. It proves the git push rules with throwaway repos on
the server, and writes a checklist of things only you can check on the PC.

## Files the builder may edit

- `docs/research/windows-agent.md` (new)
- `skills/fhs-skills/references/tech-stack.md`: append one section `## Windows agent (research 2026-10-xx)` with only the
  facts the note marks confirmed, each one line with a pointer to the note's section. Nothing else in the file changes.
- Outside the repo, only these files in `/srv/fhs-build/reports/`: `windows-research-01.md` (report) and `windows-research-01-test.md` (the tester's).

## Files the builder must not edit

- Everything else, inside or outside the clone, except the files listed above. Throwaway repos go only under `mktemp -d` and are deleted at the end.

## Live systems touched

None. Nothing on the PC (it can't reach it), no hook installed in `/root/fhs-skills`.

## Done-check (real outcome)

1. The research note answers every question in the task file, each with its source.
2. The push-rule experiment is in the note as commands and real output: a push to `main` is refused,
   `feat/other` is refused, `feat/win-hello` is accepted. Run against a throwaway non-bare repo with the proposed `pre-receive` hook.
3. The owner checklist (PC-side checks) is in the note, with blanks for the owner's answers.
4. `git diff --name-only main...feat/windows-research-01` shows only the note and `tech-stack.md`. No temp directory is left behind.
5. **After the merge (not a gate):** the owner answers the checklist on the PC. Claude records the answers in the note and commits
   them (a docs edit), and they feed the build plan.

## Test plan

`docs/tests/windows-research-01.md`, run by a fresh Grok session that didn't do the research. Every case must PASS before the merge.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. On merge, the new `tech-stack.md` section is visible to server sessions (reference text only). **Windows mirror:** untouched until a refresh.
- **Builder tree:** `/srv/fhs-build/windows-research-01`.

## Where the builder works

- `/srv/fhs-build/windows-research-01` · branch `feat/windows-research-01` · user `fhsbuild` · grok-4.7-high · started by the owner

## What stays

Everything. The Windows copy and payroll are unchanged.
