# 00 · Setup

**Goal:** a repo where agents can work safely in parallel from day one: branches, worktrees,
permissions, hooks, memory, and an empty Board and Decision Log.
**Owner:** Coordinator · **Approver:** the user

## When to run / skip

- **Run** once per app, before any other phase. `/new-app` runs it for you.
- **Re-run** a step when you add a new stack layer (a second service, a new test runner).
- **Skip** nothing here. A tweak to an existing app skips this phase only because it already ran.

## Inputs

- An empty folder, or an existing repo to adopt.
- This framework: `CLAUDE.md`, `.claude/`, `templates/`, `agents/`.
- The stack, if known (K6). If not, set up the generic parts now and add the build commands after
  [05 Architecture and data](05-architecture-data.md).

## Steps

1. **Lay out three areas.** Only the source is in git.

   | Area | In git? | Holds |
   |---|---|---|
   | `app/` (or the repo root) | yes | code, tests, `docs/`, `CLAUDE.md`, `.claude/` |
   | `handoff/` | no (gitignored) | a snapshot of the **shipped** state, plus its Handoff log |
   | `archive/` | no (gitignored) | superseded scratch, kept for reference only |

2. **Create the docs skeleton** from `templates/`:

   | File | From template | Artifact |
   |---|---|---|
   | `docs/board.md` | [board.md](../templates/board.md) | Board |
   | `docs/decisions.md` | [decision-log.md](../templates/decision-log.md) | Decision Log |
   | `docs/personas.md` | [persona-sheet.md](../templates/persona-sheet.md) | Persona Sheet |
   | `docs/prd.md` (or `docs/specs/<feature>.md`) | [prd.md](../templates/prd.md) | PRD |
   | `docs/adr/NNNN-title.md` | [adr.md](../templates/adr.md) | ADR |
   | `docs/briefs/<topic>.md` | [decision-brief.md](../templates/decision-brief.md) | Decision Brief |
   | `docs/platform-inventory.md` | [platform-inventory.md](../templates/platform-inventory.md) | Platform Inventory |
   | `docs/release-checklist.md` | [release-checklist.md](../templates/release-checklist.md) | Release Checklist |
   | `handoff/HANDOFF.md` | [handoff.md](../templates/handoff.md) | Handoff |

   Also create `docs/architecture.md` (facts about data sources, identities and flows) and
   `docs/completed-work.md` (finished detail moved off the Board).

3. **Set up branches.**
   - `main` = what is deployed. It moves only after a verified deploy, and gets a tag `v<version>`.
   - `develop` = integration. Builders branch from it; the Coordinator merges into it.
   - Never commit to `main` directly. The handoff snapshot syncs from `main` only.
   - A pure web app with continuous deploys may choose trunk-based instead (L3). Log the choice.

4. **Set up worktrees.** One worktree per Builder, branched from `develop`. List gitignored files
   each worktree needs (env files) in `.worktreeinclude`. Builders run a clean install in each.

5. **Copy `CLAUDE.md`** to the repo root and fill the placeholders: app name, build, type-check
   and test commands, the naming convention, the three areas. Keep it under 200 lines.

6. **Wire `.claude/`:** agent definitions from [agents/](../agents/), `/new-app` and other
   commands, settings. Then set:
   - **Deny rules** for secret files, `handoff/`, `archive/`, force-push and pushes to `main`.
   - **Ask rules** for deploys, pushes and platform CLI writes.
   - **Sandbox** on, if available.
   - **Hooks:** format after edit; block edits to protected paths; a Stop hook that runs the
     type-check and tests.

7. **Pick the naming convention.** `<App> - <Type> - <Item>` for every platform artifact, and
   `<App>_<Type>_<Item>` where spaces aren't allowed. Choose a general app name that can outgrow
   the first scope.

8. **Set up memory.** The Board, Decision Log and `docs/architecture.md` are the project's memory.
   Agent auto-memory may point at them but must not replace them.

9. **Add a CI skeleton** (or a local script if there is no CI): type-check, lint, tests, build,
   secret scan. Run it on the empty app.

10. **Make the first commit** on `develop` and log the setup choices as D-001 onward.

## Questions to ask

Bank: [questions/07-planning-delivery.md](../questions/07-planning-delivery.md). Its must-asks
are **L1, L2, L3, L4, L5**. At setup, ask **L3** (release flow), **L4** (what needs an OK) and
**L5** (Board). L1 and L2 wait for [08 Plan and tasks](08-plan-tasks.md). Ask K6 (stack) here if
`/new-app` didn't cover it. Follow [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

Board · Decision Log · empty Persona Sheet, PRD, Platform Inventory, Release Checklist and
Handoff · `CLAUDE.md` · `.claude/` settings, hooks and agents · CI skeleton.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): does all of it.
- [Verifier](../agents/verifier.md): optional, confirms hooks fire and CI runs green.

## Gate / definition of done

- [ ] Hooks and CI run green on the empty app.
- [ ] A test edit to a protected path is blocked by a hook or deny rule.
- [ ] `main` and `develop` exist; `handoff/` and `archive/` are gitignored.
- [ ] Board and Decision Log exist; setup decisions are logged.
- [ ] `CLAUDE.md` is under 200 lines and names the real commands.

## Rules and anti-patterns

- **Enforce with hooks and permissions; let `CLAUDE.md` advise.** Why: prose instructions are
  advisory and get skipped; hooks always run.
  Practice: https://code.claude.com/docs/en/best-practices · https://code.claude.com/docs/en/permissions
- **Keep `CLAUDE.md` short; test each line.** Why: adherence drops as the file grows. Ask "would
  removing this line cause a mistake?" Practice: https://code.claude.com/docs/en/memory
- **Deny rules on Bash are not a security boundary.** Why: commands can be rephrased; use the
  sandbox for real isolation. Practice: https://www.anthropic.com/engineering/claude-code-sandboxing
- **Worktrees are mandatory for parallel Builders.** Why: Builders in one folder committed each
  other's half-done changes. Lesson: r1 §2 (parallel Builders in one tree).
  Practice: https://code.claude.com/docs/en/worktrees
- **`main` means deployed.** Why: undeployed work landed on `main` and nobody could tell what was
  live. Lesson: r1 §1.16.
- **Keep dev, shipped snapshot and scratch apart.** Why: a handoff folder edited directly drifts
  from what is really deployed. Lesson: r1 §1.18.
- **Name everything with one convention.** Why: people must be able to find every role, asset and
  data entity that belongs to the app. Lesson: r1 §1.14.
- **Choose a general app name early.** Why: a name tied to the first feature forced a rename and a
  full redeploy later. Lesson: r1 §1.14.
- **Anti-pattern: a type-check that checks nothing.** Put the *real* build-mode type-check in the
  Stop hook and CI, and confirm it reports a file count above zero. Lesson: r1 §6 (type-check).

See also [lessons/rules-and-why.md](../lessons/rules-and-why.md).
