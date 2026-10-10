# Runbook · what to run, in order

Claude writes the plans and these hand-off files. You run each row by starting an agent and telling it one
sentence. Do the rows in order, and don't start a row until the previous row's gate passes. If a gate fails,
send the named report to Claude.

**The command is `agent`** (Cursor's CLI; `cursor-agent` is the same program). Models:

| Who | Start it with | Model |
|---|---|---|
| **Ops** (root steps) | `agent --model composer-2.5 --workspace /root/fhs-skills` | Composer 2.5 |
| **Builder** (locked-down user, runs freely in its clone) | `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/<plan>` | Composer 2.5 |
| **Researcher** (same, for research tasks) | same, with `--model cursor-grok-4.6-high` | Cursor Grok 4.6 High |
| **Tester** (same command, a **new** session) | same as Builder | Composer 2.5 |
| **Reviewer** (started for you by `scripts/review.sh`, read-only) | — | Cursor Grok 4.6 Extra High for plans and Composer's code; Composer 2.5 for Grok's research |

All of these are your included Cursor models (owner, 2026-10-10). The reviewer is never the writer's model family, so nobody grades
their own work.

**Plan mode saves tokens:** any read-only agent task (reviews, pre-checks, "what would this change?", quick questions) runs with
`--mode plan` (or `--mode ask`). Only Builders, Testers, Researchers and Ops run in normal mode, because they write files or run commands.

## Where we are

**Status lives on the FHS Skills Hub** (https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc): projects, current step, what's
waiting on you, and every decision. This runbook is the **order of work**: which agent runs next, and what has to pass.
Claude keeps both current. Build order for the store functions: `docs/specs/store-migration.md`.

## Rows

| # | Status | Agent | Tell it | Gate before the next row |
|---|---|---|---|---|
| 1 | ✅ done | Ops | `Do the task in docs/prompts/ops-00-finish-planning.md` | planning docs committed |
| 2 | ✅ done | Ops + **you** (Cursor sign-in) | `Do the task in docs/prompts/ops-01-bootstrap.md` | `fhsbuild` signed in, isolated |
| 3 | ✅ merged `58d4d1d` | Ops / Builder / Tester | framework-setup-02: build tooling (`build.sh`, `review.sh`, verdict gate) | 20/20 tests, review APPROVE |
| 4 | ✅ merged `74fb39a` | Researcher / Tester | browser-research-01: how to run a server browser | 12/12, review APPROVE |
| 5 | ✅ merged `545863b` | Researcher / Tester | windows-research-01: how a PC agent works with the server | 14/14, review APPROVE |
| 6 | ✅ merged `b79e362` | Ops / Builder / Tester | framework-setup-03: included Cursor models only (Composer builds, Cursor Grok reviews) | 10/10, review APPROVE |
| 7 | ⏳ plan review | Claude → Builder → Ops | **browser-02**: the server browser you watch and sign in to (`docs/plans/browser-02.md`). Your G1–G4 answers recorded | plan APPROVE → build → tests → code review → Ops installs (your approved list) → merge |
| 8 | ⏳ waits on row 7 | **You** | Open the browser viewer (`ssh -L 6080:localhost:6080 dev-lxc-1`, then http://localhost:6080) and sign in to R365 and Toast | signed in |
| 9 | ⏳ plan review | Root agent captures → Researcher → Tester | **store-audit-122-01**: read-only audit of every 122 function in R365 + Toast (`docs/plans/store-audit-122-01.md`) | audit merged; it decides the next builds |
| 10 | ⏳ waits on **you** | **You**, on the Windows PC | Answer the 6-item PC checklist (Claude will ask in a question pane) | answers recorded |
| 11 | ✅ plan approved | Builder → Ops → you on the PC | **windows-agent-02**: the PC agent, push hook, mirror refresh, report transfer (`docs/plans/windows-agent-02.md`) | needs row 10; each PC step is your OK |
| 12+ | later | Claude plans each | store functions in order: items/vendors → e-invoices → recipes + menu mapping → counts → cash & deposits → food cost → daily flash → scheduling/OT → delivery → 878 migration. Each skips or shrinks based on the row 9 audit | per plan |

How every build row runs (Ops follows `docs/prompts/ops-cycle.md`): plan review → `build.sh prepare` → Builder → fresh Tester →
`build.sh collect` → code review → root-only checks → final review → merge. Agents and models: the table above.

## Good to know

- Rows 1–2 are one-time. Every plan after that is: Ops runs `ops-cycle.md`, and Ops tells you when to start the Builder and the Tester.
- Browser tests run through the server's browser once row 7 is done, or Chrome on your PC until then.
- Nothing so far has touched Toast, R365, ADP, the Windows skill copy, or payroll. Row 9 is the first to *read* R365 and Toast, and it never changes anything.
