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
| 6b | ✅ merged `b7b80c0` | Claude runs Builder / Tester headless | framework-setup-04: Grok drafts plans from Claude's briefs (`scripts/draft.sh`), Composer reviews them (`review.sh --writer grok`), writers fix minors | 10/10 + T11/T12, review APPROVE |
| 7 | ⏸ parked | — | **browser-02** server browser: parked (owner, 2026-10-10: desktop first). Returns only when an unattended job needs it | — |
| 8 | ✅ done | **You**, on the Windows PC | PC checklist answered; Git working; `git ls-remote dev-lxc-1:/root/fhs-skills HEAD` OK | — |
| 9 | ✅ done | Builder → Ops → **you** | **windows-agent-02**: push hook, `inbox/`, PC clone, restricted key, alias, gated key in place. D3 test push PASS, D5 proven, D4 mirror refresh PASS 2026-10-11 (1 file, `matched=11 unmatched=0`, backup `C:\fhs\backups\skills-2026-10-11.zip`). PC needs `powershell -ExecutionPolicy Bypass -File …` for these scripts | — |
| 10 | ✅ done (used by row 11) | **You**, on the PC | Make sure Claude in Chrome is set up and you're signed in to R365 and Toast in that Chrome | signed in |
| 11 | ✅ done: merged `dd20dd4`, post-merge P1–P2 PASS | Claude Code + Claude in Chrome on your PC captures → Researcher (Cursor Grok High) → Tester | **store-audit-122-02**: read-only audit of every 122 function in R365 + Toast. Note `docs/research/store-audit-122.md`. Post-merge: P1 (owner: nothing changed during the audit), P2 (PC recapture of 5 pages); 6 review minors done as one docs tweak (F3/F4 stay **in place**) | ✅ P1 PASS, P2 PASS 5/5 (owner's PC session, 2026-10-11); minors done |
| 12 | ✅ merged `6bcd0e8` 2026-10-11: tests T1–T6 ALL PASS, diff review r1 APPROVE (Composer). Post-merge P1 PASS (owner: nothing changed in R365). Results: sum $7,461.73 (Δ 0.00); 102 $0-cost, 3 no Cheney link, 7 unit mismatch → `docs/research/items-122.md` | Ops → Researcher (Grok) → Tester | **items-122-01** (F2, verify-only): 207 counted items' cost, units, Cheney vendor item linked + unit (`ITM-02.csv`). Receipt recency and unmapped invoice lines moved to F3 | sum of count lines = $7,461.73 ±$1; problem list |
| 13 | ✅ done: merged `a587474` 2026-10-11: tests T1–T7 ALL PASS, diff review r1 APPROVE (Composer). Post-merge P1 PASS (owner: nothing changed in R365 during the capture) | You (PC capture) → Ops → Researcher (Grok) → Tester | **invoices-122-01** (F3, verify-only): 25 CARY 1 Cheney rows 08/14–10/09 (20 invoices, 5 credit memos; count from F2 AP export, no Transactions export). Results: 3 unapproved; 0 unmapped lines; 108 of 207 counted items not bought from Cheney in 8 weeks; approval dates not shown → `docs/research/invoices-122.md` | count 25 = AP export; lines = footers; owner summary |
| 14 | ✅ merged `60841c2` 2026-10-11: tests T1–T7 ALL PASS, diff review r1 APPROVE (Composer). Post-merge P1 PASS (owner, 2026-10-12: "I don't believe anything changed" in R365). Results: 31 slow mover, 0 other Cheney item, 45 looks dead, 32 can't tell; history back to 05/15 (37 older invoices); only 1 Approved count since 08/01 → `docs/research/count-lines-122.md` | You (PC capture) → Ops → Researcher (Grok) → Tester | **count-lines-122-01** (F2 follow-up, verify-only): sort the 108 counted items with no Cheney receipt in 8 weeks into slow mover / other Cheney item / looks dead / can't tell. Owner: Cary 1 buys only from Cheney. Spec `docs/specs/count-lines-122.md`, brief `docs/briefs/count-lines-122-01.md` | 108 rows, one group each; count exports = list totals |
| 15 | next (you): plan `docs/plans/count-sheet-122-01.md` review r1 APPROVE (Composer, 3 minors left as notes) 2026-10-12. On the PC first `git -C C:\fhs\fhs-skills pull --ff-only origin main` (clone must show the task file), then run the PC capture `docs/prompts/count-sheet-122-01-capture.md` (read-only), then Ops unzip + `build.sh prepare` | Claude (spec + brief) → Grok drafts → review → You (PC capture) → Ops → Researcher (Grok) → Tester | **count-sheet-122-01** (F2 fix, verify-only): the owner's tick list for the 45 looks-dead lines (owner chose 2026-10-12 to tick it before any hide); who owns the CARY 1 count template and whether the owner can hide lines; ways R365 shows to record store-run (Costco/grocery) buys. The hide itself is count-sheet-122-02, one OK per change | tick list = 45 names; each ownership answer has a capture or `(?)`; read-only pages.csv |
| 16+ | later | Claude plans each | store functions in order: items/vendors → e-invoices → recipes + menu mapping → counts → cash & deposits → food cost → daily flash → scheduling/OT → delivery → 878 migration. Each skips or shrinks based on the row 9 audit | per plan |

How every build row runs (Ops follows `docs/prompts/ops-cycle.md`): plan review → `build.sh prepare` → Builder → fresh Tester →
`build.sh collect` → code review → root-only checks → final review → merge. Agents and models: the table above.

## Good to know

- Rows 1–2 are one-time. Every plan after that is: Ops runs `ops-cycle.md`, and Ops tells you when to start the Builder and the Tester.
- Browser work runs on your PC with **Claude Code + Claude in Chrome** (the default for anyone using these skills). The Cursor agent + Playwright is optional for long runs.
- Nothing so far has touched Toast, R365, ADP, the Windows skill copy, or payroll. Row 11 is the first to *read* R365 and Toast, and it never changes anything.
