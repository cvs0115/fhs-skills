# Test plan · <plan-name>

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the one that built it).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/<plan-name>.md".

## What's being tested

<Plain words: what the change should do, and the plan's done-check this proves.>
Plan: `docs/plans/<plan-name>.md` · Builder report: `/srv/fhs-build/reports/<name>.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/<name>` on branch `feat/<name>`, as `fhsbuild` | run commands; edit nothing in the repo |
| browser-server | the server's Playwright MCP browser (only once `browser-01` is live) | MCP tools; snapshot before each click |
| browser-windows | Chrome on the owner's Windows PC, via Playwright/cursor-agent on the PC (fallback until browser-server exists) | same rules |
| owner | the owner does it and tells you the result | write down exactly what they report |

Browser rules (every browser case): the owner signs in, and you never type a username or password.
Read and navigate only. Never click save, submit, approve, pay, send or delete. Save a screenshot
for each check to `/srv/fhs-build/reports/<name>-shots/<case-id>.png` (Windows:
`C:\fhs\reports\<name>-shots\`). If a page asks for a login or MFA, mark the case BLOCKED (owner)
and move on.

## Preconditions

- <e.g. builder report exists; branch checked out; owner signed in to R365>

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | `<command>` | `<result>` | command + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | <env> | <steps> | <result> | <evidence> |

## Results

Write `/srv/fhs-build/reports/<name>-test.md` (outside the repo):

```text
Test plan: <plan-name> · Branch: feat/<name> at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Type credentials, or click anything that changes data in Toast, R365, ADP or any site.
