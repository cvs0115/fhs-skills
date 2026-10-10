# Test plan · store-audit-122-01

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).** This file is your whole assignment. Run every
> case, record real evidence, and judge PASS, FAIL or BLOCKED. Don't fix anything.
> Hand-off: "Run the test plan in docs/tests/store-audit-122-01.md".

## What's being tested

That the audit note `docs/research/store-audit-122.md` is complete and true, that every "in place" or "partial" claim has its
screenshot, that 5 claims re-check the same in the live systems (read-only), that `tech-stack.md` only gained lines, and that nothing in
R365 or Toast was changed. Plan: `docs/plans/store-audit-122-01.md` · Researcher report: `/srv/fhs-build/reports/store-audit-122-01.md`.

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/store-audit-122-01` on `feat/store-audit-122-01`, as `fhsbuild` | read files; run commands; edit nothing |
| browser-server | the server Playwright MCP browser, with the owner already signed in | read-only; snapshot before each click |
| owner | the owner answers, and you write down exactly what they say | — |

Browser rules: never type credentials; navigation and report viewing only; never click Save, Submit, Approve, Post, Import, Map, Edit,
Delete, Create, New, Add, Sync, Run, Send, Email or Pay. If a login or MFA prompt appears, mark the case BLOCKED (owner). Screenshots go to
`/srv/fhs-build/reports/store-audit-122-shots/test-<case>.png`.

## Preconditions

- The researcher report exists. The owner has said they're signed in to R365 and Toast in the server browser.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `grep -E '^\| (M0\|F([2-9]\|1[0-3])\|I1) ' docs/research/store-audit-122.md` | 14 rows: M0, F2–F13, I1. Each has a status from {in place, partial, missing, can't tell}, evidence (system → path, and a screenshot name or "none"), and an owner from {owner, franchise, R365 support, unknown} | output + any row missing a field |
| T2 | shell | For each row with status "in place" or "partial", `ls -l /srv/fhs-build/reports/store-audit-122-shots/<file>` | every named file exists and is a PNG over 10 KB | output |
| T3 | shell | Check that sections "Who owns what", "Answers to q1–q5" and "Open (?) items" exist, and that every unconfirmed menu path is marked `(?)` | present | quotes |
| T4 | browser-server | Pick 5 rows: at least 2 "in place" or "partial", at least 1 "missing", and the I1 integration row. For each, open the cited path read-only and compare with the note's status and numbers | same status, and the numbers within the note's stated date | screenshot per case + a comparison line |
| T5 | shell | `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'` and `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep -c '^+## '` | no removed lines; exactly 1 new section heading; each added fact matches a "confirmed" item in the note | output |
| T6 | shell | `git diff --name-only main...HEAD`; `git status --short` | only the note and `tech-stack.md`; clean | output |
| T7 | shell | Read the researcher report's "Pages visited" and "Forbidden actions taken" | "Forbidden actions taken: none"; no visited page is an edit, new, import or mapping action URL | quotes |
| T8 | shell | If the researcher agent's MCP or tool log is readable (e.g. under `/srv/fhs-build/.cursor/` for this workspace), grep it for click targets named Save, Submit, Approve, Post, Import, Map, Delete, Create, Sync | no such click. If no log is readable, mark BLOCKED (no log), not FAIL | output |

## Owner cases (BLOCKED until the owner answers; they don't gate the merge, they feed the plans)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| O1 | owner | Ask the owner: "Did anything change in R365 or Toast during the audit (new items, mappings, settings)?" | "no" | the owner's words |
| O2 | owner | For each "can't tell (owner)" row and each unanswered q1–q5, record the owner's answer | answered | the owner's words |

## Results

Write `/srv/fhs-build/reports/store-audit-122-01-test.md`:

```text
Test plan: store-audit-122-01 · Branch: feat/store-audit-122-01 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix the note. Take any forbidden browser action. Type credentials.
