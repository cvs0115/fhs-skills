# 08 · Plan and tasks

**Goal:** turn the agreed requirements and design into small tasks on the Board, each with an
owner, a file area, a dependency order and a done-check, so Builders can work in parallel
without colliding.
**Owner:** Coordinator · **Approver:** the user (the plan and the first slice)

## When to run / skip

- **Run** for every feature and every page.
- **Light version** for a bug or tweak: one Board row with its done-check, then build.
- **Never skip the Board row.** Every piece of work has one.

## Inputs

- PRD (requirement IDs, P0/P1/P2, acceptance criteria), architecture doc, contracts, page plans.
- Current Board and Decision Log.

## Steps

1. **Pick the first slice** (L1): a thin vertical slice end to end, e.g. data + one landing page
   + deploy. Then page by page.
2. **Split into tasks.** Each task:
   - traces to a requirement ID;
   - names the files or area it may touch (and the "don't touch" list);
   - has a **done-check** (the test, build, or screenshot that proves it);
   - is small enough for one session.
3. **Write a plan file** before any builder brief, unless the change is trivial (a one-line fix,
   a docs edit, or a scratch script, which may stay a one-line plan). A spec counts as a plan.
   The plan names the files, the done-check, and what stays. It does not authorize code by itself.
4. **Review gate.** A reviewer from a different model family than the writer reviews the plan.
   Verdicts are APPROVE, APPROVE AFTER FIXES, or REJECT. A major sends the writer back. Do not
   brief a builder from REJECT, or from APPROVE AFTER FIXES, until the fix is reviewed again and
   approved.
5. **No-builder close.** If the row is already true, or a code change is not worth it, the plan
   says so. The coordinator closes the row. An empty builder seat is not a reason to invent the
   change.
6. **Order by dependency.** Mark which tasks can run in parallel: only tasks on **separate files
   or areas**.
7. **Contracts first when two Builders share a feature.** Fix the shared contract (a JSON example
   of each record) before either starts. Give wiring that touches hot shared files (router,
   global stylesheet, nav) to one Builder, last.
8. **Set WIP limits** (L6): two builders. The agent queue is five; the other seats are plans and
   reviews. Verify ≤ 2.
9. **Agree the definition of done** (L2). Default: real type-check clean, full test suite green
   with new tests named, browser sweep at 3 widths, persona review, docs and Board updated.
10. **Sort each task:** does it need a real deploy (server-side, job, schema, platform config) or
    is the local dev server enough (UI-only)? Server-side items go on a "Next release" list.
    Name the tree the running app serves and the tree a crash reloads.
11. **Write the Board rows** from [templates/board.md](../templates/board.md):
   - **WIP:** priority, item, owner, files, the next gate in "done means."
   - **Next:** ordered, with the files each row will touch.
   - **Not live yet:** merged, not loaded by the running process.
   - **Waiting on the user:** only an act or a choice. Empty when nothing needs them.
   - **Completed:** newest first, one line. Detail moves to `docs/completed-work.md`.
   - **Loose ends:** open points found inside finished rows.
   Every row has P0 / P1 / P2. The header count matches the WIP table.
12. **Keep a machine-readable feature list** if sessions will be long: each item starts
    `passes: false`; only the Verifier flips it.
13. **Write each Builder's prompt** from [templates/agent-prompt.md](../templates/agent-prompt.md),
    and only after APPROVE: objective, context (plan file, rules, patterns), boundaries,
    done-check, report format. The brief names the door file, the row, the decisions that bind
    it, the output path, and the message to return.
14. **Ask the user only when they must act or choose,** in a question pane. Do not build from a
    plan that is not APPROVE. A row that needs no builder closes here.

## Questions to ask

Bank: [questions/07-planning-delivery.md](../questions/07-planning-delivery.md). Must-asks:
**L1, L2, L3, L4, L5** (L3–L5 are usually settled in [00 Setup](00-setup.md); confirm them).
Then L6–L10. Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- Board rows with priority, owner, file area, done-check ([templates/board.md](../templates/board.md)).
- One plan file per non-trivial row ([templates/plan.md](../templates/plan.md)), then a review verdict ([templates/review-verdict.md](../templates/review-verdict.md)).
- Builder prompts ([templates/agent-prompt.md](../templates/agent-prompt.md)).
- Optional feature-list JSON and progress log.
- Decision Log entries.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): plans, owns the Board, writes prompts. Builders never
  edit the Board.
- [Researcher](../agents/researcher.md): fills any gap found while splitting tasks.

## Gate / definition of done

- [ ] L1–L5 answered and logged.
- [ ] Every task traces to a requirement ID and has a done-check.
- [ ] Parallel tasks touch disjoint files; hot shared files have one owner.
- [ ] Shared contracts exist before parallel work starts.
- [ ] A plan file names the files, the done-check, and what stays.
- [ ] Cross-model review is APPROVE, or the row closed with no builder.
- [ ] WIP limits set (two builders, queue of five); the Board shows who does what.
- [ ] The user was asked only where they must act or choose.

## Rules and anti-patterns

- **Track all work on one Board, updated every request.** Why: parallel agents and the user need
  one source of truth; it is the project's memory. Lesson: r1 §1.24.
  Practice: https://kanban.university/kanban-guide/
- **Parallel only on separate files.** Why: coding is rarely parallel; shared files cause
  overwrites. Lesson: r1 §2 (agent count). Practice:
  https://www.anthropic.com/engineering/multi-agent-research-system
- **Two builders, queue of five.** Why: coordination cost grows faster than output, and the
  other seats are plans and reviews. Practice: https://code.claude.com/docs/en/agent-teams
- **Contracts first.** Why: neither Builder waits for the other. Lesson: r1 §2 (contracts first).
  Practice: https://github.com/github/spec-kit
- **Every task names its check.** Why: the loop closes without a human in it. Practice:
  https://code.claude.com/docs/en/best-practices
- **A feature list plus a progress file.** Why: long-running agents lose state and declare victory
  early. Practice: https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- **Delegation needs objective, output format, tools, boundaries.** Why: vague prompts duplicate
  work. Practice: https://www.anthropic.com/engineering/multi-agent-research-system
- **Know which changes need a real deploy.** Why: server-side work isn't done until it is deployed
  and checked. Lesson: r1 §1.20.
- **Keep the Board short.** Why: finished detail buried open points; a "Loose ends" table catches
  them. Lesson: r1 §2 (the board).
- **Anti-pattern: skipping the plan for a "small" change.** Plan in one line and ask one question;
  that is still a plan. Lesson: r1 §1.1.
