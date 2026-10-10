# App Framework: outline (draft for review, 2026-09-26)

A reusable, stack-agnostic way to build apps with Claude Code and sub-agents. Built from
`research/r1-project-lessons.md` (what we learned), `research/r2-external-practices.md` (current
practice, 65 sources) and `research/r3-question-banks.md` (questions per phase).

```
app-framework/
  README.md                 1-page overview for people: the phases, the roles, how to start a new app
  CLAUDE.md                 starter rules to copy into a new app (under 200 lines)
  playbook/
    00-setup.md             repo layout, branches (main = deployed, develop = integration), worktrees, permissions/hooks, memory
    01-discovery.md         goals, audience, deadline/demo, constraints, out of scope
    02-personas-value.md    persona sheet, per-persona "what's concerning", value stories, domain language
    03-requirements.md      lean PRD, user stories + acceptance criteria, P0/P1/P2, definition of done
    04-research-spikes.md   validate every data source live before designing; check alternatives; ask when docs and live disagree
    05-architecture-data.md single writer, snapshot vs live, retention tiers, key by id, idempotent jobs, time budgets, audit fields
    06-security-access.md   user vs app identity, least privilege, groups-only roles, secrets, default grants, threat-model quick pass
    07-ui.md                page inventory, landing vs detail, persona switch, states, widths, accessibility, demo mode with real-shaped data
    08-plan-tasks.md        board, task split for parallel agents, shared contracts first, decision log
    09-build.md             coordinator + builders in worktrees, merge + full test per builder, one step at a time
    10-verify.md            real type-check, suite, layout tests, scripted browser sweeps, persona x page review, independent verifier
    11-release.md           release checklist: capture state, upload, verify by content hash, read job logs, tag, secret scan, push after OK
    12-operate-handoff.md   diagnostics page, runbooks, platform inventory, handoff log
  agents/                   ready-to-paste prompts with guardrails and a report format
    coordinator.md  planner.md  reviewer.md  builder.md  gui-tester.md  researcher.md  docs-writer.md  verifier.md  release-manager.md
  questions/                question banks (from r3), one file per phase, 5 must-ask each, recommended option first
  templates/
    board.md  decision-log.md  decision-brief.md  persona-sheet.md  prd.md  adr.md
    platform-inventory.md  handoff.md  release-checklist.md  agent-prompt.md
  lessons/
    rules-and-why.md        each working rule with the reason behind it
    anti-patterns.md        ~30 incidents: what happened, the rule that prevents it
    session-2026-09-28.md   the ten-rule build loop (points from rules-and-why.md)
  platforms/
    uipath-framework.md     add-on for UiPath apps: architecture options, identities and scopes, RBAC, Data Fabric,
                            jobs, solution lifecycle, release and inventory checklists, gotchas (user, 2026-09-26)
  questions/platform-uipath.md  UiPath-specific question bank (IDs U*)
  research/                 the source reports (r1-r3 generic, r4 UiPath)
```

**Principles that run through every phase**
1. Plan and ask before building; batches of 1–4 questions, recommended option first; log every answer.
2. Scale the process to the change: a small tweak goes straight to build; a new feature runs spec → plan → tasks.
3. Ground everything in real data: validate APIs live, demo data only from fields the system really produces.
4. Verification is separate from the builder, and it checks the real outcome: logs, content hash, ids. A green status alone doesn't count.
5. Parallel agents only on independent files: 2–3 builders in worktrees, one coordinator owns the board, merges and decisions.
6. Nothing outward-facing without an explicit OK: deploys, pushes, access widening, destructive changes.
7. The board and the decision log are the memory of the project; CLAUDE.md advises, hooks and permissions enforce.
