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

## Rows

| # | Agent | Tell it | Gate before the next row | If the gate fails, send Claude |
|---|---|---|---|---|
| 1 | Ops | `Do the task in docs/prompts/ops-00-finish-planning.md` | the review of framework-setup-02 is APPROVE, and the planning docs are committed on `main` | `/srv/fhs-build/reports/ops-00-finish-planning.md` and the review file it names |
| 2 | Ops | `Do the task in docs/prompts/ops-01-bootstrap.md`. **You** run the one login command it gives you | `fhsbuild` exists, it's signed in to Cursor, and every isolation check fails as it should | `/srv/fhs-build/reports/ops-01-bootstrap.md` |
| 3 | Ops | `Do the task in docs/prompts/ops-cycle.md for plan framework-setup-02`. It will tell you when to start the Builder and the Tester | merged on `main`, tests ALL PASS, diff review APPROVE | `/srv/fhs-build/reports/framework-setup-02-ops.md` (+ `-test.md`) |
| 3a | Builder (when Ops says) | `Do the task in docs/prompts/framework-setup-02.md` | its report exists in `/srv/fhs-build/reports/` | that report |
| 3b | Tester (when Ops says; new session) | `Run the test plan in docs/tests/framework-setup-02.md` | its results file exists. Ops-only rows wait for Ops | that results file |
| 4 | Ops | `Do the task in docs/prompts/ops-cycle.md for plan browser-research-01` | merged; tests ALL PASS | `/srv/fhs-build/reports/browser-research-01-ops.md` |
| 4a | Builder | `Do the task in docs/prompts/browser-research-01.md` | report exists | report |
| 4b | Tester (new session) | `Run the test plan in docs/tests/browser-research-01.md` | results exist | results |
| 5 | Ops | `Do the task in docs/prompts/ops-cycle.md for plan windows-research-01` | merged; tests ALL PASS | `/srv/fhs-build/reports/windows-research-01-ops.md` |
| 5a | Builder | `Do the task in docs/prompts/windows-research-01.md` | report exists | report |
| 5b | Tester (new session) | `Run the test plan in docs/tests/windows-research-01.md` | results exist | results |
| 5c | You, on the Windows PC | Fill in the "Owner checklist" in `docs/research/windows-agent.md`, and send the answers to Claude | — | — |
| 6 | Claude | "Rows 1–5 are done" | Claude writes the browser build plan, the Windows build plan, then the R365 inventory audit plan, each with a task file and a test plan, and adds them here as rows 7+ | — |

## Good to know

- Rows 1–2 are one-time. Every plan after that is: Ops runs `ops-cycle.md`, and Ops tells you when to start the Builder and the Tester.
- Browser tests in later plans run through Playwright on the server's browser once it exists (row 7+), or Chrome on your PC until then.
- Nothing in rows 1–5 touches Toast, R365, ADP, the Windows skill copy, or payroll.
