# App Framework v2

A reusable way to build apps with Claude Code and a small team of sub-agents. It works for any
stack and any platform. This is v2: every phase, question bank, template, lesson, and platform
note from v1, plus a tighter build loop. v2 adds a written plan before a builder, a cross-model
review before approval and before merge, a close with no builder when the row is already true,
and a cap of two builders inside a queue of five agents. It does not drop UiPath, the PRD
phases, or the verifier. `CLAUDE.md` is the door (stable rules). The Board holds live state.
It gives you:

- a **playbook**: 13 phases, each with steps, questions, artifacts and a gate;
- **question banks**: what to ask the user in each phase, with a recommended answer first;
- **agent prompts**: ready-to-paste roles with guardrails and a report format;
- **templates**: the Board, Decision Log, PRD, ADR, a blank plan, a blank review verdict, and the other artifacts;
- **lessons**: each rule with the incident behind it.

It is built from a real two-week build (`research/r1-project-lessons.md`), current practice with
sources (`research/r2-external-practices.md`) and planning questions (`research/r3-question-banks.md`).
In the playbook, "Lesson: r1 §x.y" points at r1; "Practice:" gives the source URL.

## Principles

1. **Plan before building.** Before a builder starts, a planner writes a plan file (files, done-check, what stays). A one-line fix, a docs edit, or a scratch script may stay a one-line plan. Ask in batches of 1–4, recommended option first, and only when the user must act or choose. Log every answer.
2. **Scale the process to the change.** A tweak is still a one-line plan; a feature runs spec → written plan → review → tasks.
3. **Ground everything in real data.** Validate APIs live. Demo data uses only fields the system really produces.
4. **Verification is separate from the writer.** A reviewer from a different model family reviews every plan and every builder diff before approval and before merge. The Verifier still checks the real outcome after merge: logs, content hash, ids.
5. **Parallel work stays inside the cap.** Two builders, on files that do not overlap. The queue is five agents; the other seats are plans and reviews. An approved plan may end with no builder. One Coordinator merges and decides.
6. **Nothing outward-facing without an explicit OK:** deploys, pushes, access widening, deletes.
7. **The Board and the Decision Log are the project's memory.** `CLAUDE.md` advises; hooks and permissions enforce.

## The phases

| # | Phase | Goal | Artifacts | Owner role | Gate |
|---|---|---|---|---|---|
| 00 | [Setup](playbook/00-setup.md) | A repo where agents can work safely in parallel | Board, Decision Log, `CLAUDE.md`, hooks, CI skeleton | Coordinator | Hooks and CI green on the empty app |
| 01 | [Discovery](playbook/01-discovery.md) | Agree problem, users, success, deadline, non-goals | PRD (problem, metrics, non-goals) | Coordinator | K1–K5 answered; summary confirmed |
| 02 | [Personas and value](playbook/02-personas-value.md) | Who reads it, what worries them, what words we use | Persona Sheet | Coordinator | Concerns marked with data availability; vocabulary set |
| 03 | [Requirements](playbook/03-requirements.md) | What and why, testable | PRD (stories, criteria, P0/P1/P2) | Coordinator | Every P0 has testable criteria; nothing left to clarify |
| 04 | [Research spikes](playbook/04-research-spikes.md) | Validate every source and limit before design | Research notes, Decision Brief | Researcher | Each assumption verified or a named risk |
| 05 | [Architecture and data](playbook/05-architecture-data.md) | Single writer, ids, retention, job limits | ADR, architecture doc, contracts | Coordinator | ADRs accepted; contracts exist |
| 06 | [Security and access](playbook/06-security-access.md) | Least privilege, groups only, secrets in place | Platform Inventory, ADR | Coordinator | Every grant auditable; secret scan clean |
| 07 | [UI](playbook/07-ui.md) | Verdict-first pages, states, widths, demo mode | Page inventory, page plans | Coordinator | Key numbers agreed per page; a11y and widths pass |
| 08 | [Plan and tasks](playbook/08-plan-tasks.md) | Small tasks with owners, files and checks | Board rows, agent prompts | Coordinator | Disjoint files; a done-check per task; user OK |
| 09 | [Build](playbook/09-build.md) | Merged, tested code, one step at a time | Code, tests, Builder reports | Builder (Coordinator merges) | Done-check green; full suite green after merge |
| 10 | [Verify](playbook/10-verify.md) | Independent proof against the PRD | Verification report, screenshots | Verifier, GUI Tester | SHIP verdict with evidence |
| 11 | [Release](playbook/11-release.md) | What runs is what we built; config survived | Release Checklist, tag | Release Manager | Served hash = local hash; job logs prove the effect |
| 12 | [Operate and handoff](playbook/12-operate-handoff.md) | Someone else can run and support it | Handoff, Platform Inventory, runbooks | Docs Writer | Inventory matches read-back; handoff synced from `main` |

The user approves product choices and irreversible actions. The reviewer approves plans and diffs. Question banks: [questions/](questions/00-etiquette.md). Plan form: [templates/plan.md](templates/plan.md). Verdict form: [templates/review-verdict.md](templates/review-verdict.md).

## The agent roles

| Role | Does | Never |
|---|---|---|
| [Coordinator](agents/coordinator.md) | Plans with the user; owns the Board, Decision Log and docs; starts agents; merges; runs platform changes after an OK | Deploys; decides for the user outside a delegated window; grades a plan it wrote |
| [Planner](agents/planner.md) | Writes one plan file: files, done-check, what stays | Edits app source; starts a builder; claims approval |
| [Reviewer](agents/reviewer.md) | Different model family; one verdict on a plan or a diff (APPROVE, APPROVE AFTER FIXES, REJECT) | Edits anything; reviews its own model family |
| [Builder](agents/builder.md) | One approved task in its own worktree, not the tree the running app serves; reports with commits and tests | Starts without APPROVE; edits the served checkout, docs, or the Board; merges; runs platform CLI; deploys |
| [GUI Tester](agents/gui-tester.md) | Scripted browser sweeps at three widths, personas × pages, demo and live; SHIP verdict | Types passwords; shares a browser profile; writes on live |
| [Researcher](agents/researcher.md) | Read-only checks of APIs, docs and data, with sources, written to files | Writes anywhere outside its notes |
| [Docs Writer](agents/docs-writer.md) | Handoff, runbooks, demo scripts, briefs | Edits anything but its target doc |
| [Verifier](agents/verifier.md) | Real type-check, full suite, adversarial review, spec ↔ code converge, after-deploy checks | Grades its own work; fixes code |
| [Release Manager](agents/release-manager.md) | Runs the Release Checklist: capture, build, upload, verify by hash and logs | Deploys (the user does); pushes without an OK |

Keep it small: one Coordinator, two Builders, planners and reviewers in the other seats, one
Verifier, 1–2 GUI Testers while Builders work, Researchers as needed. Count who is running. The
queue is five. Do not invent work to fill it.

## Start a new app in 10 minutes

1. **Copy the starter files** into the new repo: `CLAUDE.md`, `.claude/`, `templates/`.
2. **Fill `CLAUDE.md`'s placeholders:** app name, build, type-check and test commands.
3. **Open Claude Code in the repo and run `/new-app`.**
4. **Answer the kick-off questions** (K1–K5, then K6 stack): problem, users, success metrics,
   deadline, out of scope. They come in small batches with a recommended answer first.
5. **Check what was created:** `docs/board.md` with the first rows, `docs/decisions.md` with your
   answers, the PRD's first sections, `main` and `develop` branches, hooks and CI.
6. **Confirm the phase summary.** The Coordinator moves on to [02 Personas and value](playbook/02-personas-value.md).

## Scale the process to the change

| Change | Path | Example |
|---|---|---|
| **Tweak** (one-sentence diff) | one-line plan → [09 Build](playbook/09-build.md) → quick [10 Verify](playbook/10-verify.md) | Rename a column heading |
| **Bug** | bug-assess note (symptom, expected, cause, proof) → [09 Build](playbook/09-build.md) → [10 Verify](playbook/10-verify.md) | A total doesn't match its parts |
| **Feature** | [03 Spec](playbook/03-requirements.md) → written plan → cross-model review → [09 Build](playbook/09-build.md) → [10 Verify](playbook/10-verify.md) (+ 04–07 when it adds a source, store, identity or page) | A new detail page |
| **Vague idea or new app** | Start at [01 Discovery](playbook/01-discovery.md) and run every phase | "We should show usage somehow" |

Server-side changes are not live until [11 Release](playbook/11-release.md) proves them. A
restart is its own OK: a reviewed merge is not live while the server process still loads the
previous tree. Enabling a schedule and cutting over a behavior are separate OKs. Every path
still plans first, and every conflict with an earlier decision goes to
[bank 9](questions/09-change-conflicts.md).

## Where things are

```
README.md            this page
CLAUDE.md            starter rules to copy into a new app
playbook/            00-setup … 12-operate-handoff
questions/           00-etiquette + one bank per topic (K, V, Q, D, S, G, L, O, C)
agents/              one prompt per role, including planner and reviewer
templates/           board, decision-log, decision-brief, persona-sheet, prd, adr,
                     platform-inventory, handoff, release-checklist, agent-prompt,
                     gui-test-script
platforms/           optional platform add-ons (the core stays generic); UiPath: uipath-framework.md (Top 20 first),
                     uipath-development-practices.md, uipath-cli-sdk-api.md + questions/platform-uipath.md
lessons/             rules-and-why, anti-patterns, session-2026-09-28 (the ten-rule loop)
research/            the three source reports
```
