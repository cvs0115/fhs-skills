# Test plan · store-audit-122-02

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the researcher).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/store-audit-122-02.md".

## What's being tested

The audit note is complete and backed by the PC captures: twelve F-rows (F2–F13) plus Licensed modules, Toast → R365 integration, and Who owns what; every row has status, evidence, and owner; every "in place"/"partial" claim names a capture file that exists; five tester-picked claims match those captures; `pages.csv` has no forbidden action; `tech-stack.md` only gained one section of added lines. Post-merge (not a gate): nothing in R365 or Toast changed, and the five pages still match.
Plan: `docs/plans/store-audit-122-02.md` · Researcher report: `/srv/fhs-build/reports/store-audit-122-02.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/store-audit-122-02` on branch `feat/store-audit-122-02`, as `fhsbuild` | read the note, `tech-stack.md`, and the captures folder; run commands; edit nothing in the repo |
| owner | the owner answers; a fresh PC Claude session (Claude Code + Claude in Chrome) re-captures the five T3 pages | write down exactly what they report |

No browser cases for the tester. Check the clone and `/srv/fhs-build/reports/store-audit-122-captures/` only. `browser-02` stays parked. Never open R365, Toast, or ADP.

Browser rules (P2 recapture only, owner's PC): the owner is already signed in; nobody types a username or password. Read and navigate only. Never click save, submit, approve, pay, send or delete. If a page asks for a login or MFA, mark P2 BLOCKED (owner) and move on.

## Preconditions

- Researcher report `/srv/fhs-build/reports/store-audit-122-02.md` exists.
- Captures are unzipped at `/srv/fhs-build/reports/store-audit-122-captures/` and include `pages.csv`. If that folder is missing, empty, or has no `pages.csv`, mark T2–T4 BLOCKED (captures missing).
- You are in `/srv/fhs-build/store-audit-122-02` on `feat/store-audit-122-02` as `fhsbuild`.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| T1 | shell | In the clone: `grep -cE '^\| F([2-9]\|1[0-3]) ' docs/research/store-audit-122.md`; `grep -E '^## (Licensed modules\|Toast → R365 integration\|Who owns what)' docs/research/store-audit-122.md`; read the summary table and those three sections | 12 F-rows (F2–F13, one each). The three section headings exist. Every F-row and each of those three sections has a status from {in place, partial, missing, can't tell}, evidence (menu path + capture file, or "none"), and an owner from {owner, franchise, R365 support, unknown}. The integration section names last sales import date and last labor import date (a date or can't tell) | commands + matching lines; any row missing a field |
| T2 | shell | List every capture file the note cites (`*.png`, `*.txt`, and any named export). For each: `ls -l /srv/fhs-build/reports/store-audit-122-captures/<file>`. Then check every summary row with status "in place" or "partial" | every cited file exists in that folder; every "in place"/"partial" row names at least one file that exists (not "none") | `ls` output; any missing name |
| T3 | shell | Pick 5 claims from the note. For each, open the cited capture under `/srv/fhs-build/reports/store-audit-122-captures/` (screenshot, page text, or export) and compare the note's status and numbers | each claim matches its capture | the 5 IDs, capture file per claim, and a comparison line each |
| T4 | shell | Read `/srv/fhs-build/reports/store-audit-122-captures/pages.csv` (columns: time, URL, action). List unique `action` values. Check each URL | every data row's action is exactly `view`, `filter`, or `export`. No URL is a save, submit, post, or approve path. No URL is an edit, new, import, or mapping action URL (a write; -01 T7). Viewing a mapping or import-status page is allowed | unique actions; matching URLs or "none" |
| T5 | shell | `git diff --name-only main...HEAD`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep '^-[^-]'`; `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md \| grep -c '^+## '` | only `docs/research/store-audit-122.md` and `skills/fhs-skills/references/tech-stack.md` (any order); `grep '^-[^-]'` prints nothing; exactly 1 new `##` heading | commands + trimmed output |

## Post-merge verification (not a gate; a failure opens a fix plan)

Pre-merge T1–T5 are the merge gate. Mark P1–P2 BLOCKED until the owner answers, then fill them in.

| ID | Env | Steps | Expected | Evidence to record |
|---|---|---|---|---|
| P1 | owner | Ask the owner: "Did anything change in R365 or Toast during the audit (new items, mappings, settings)?" | "no" | the owner's words |
| P2 | owner | A fresh PC Claude session (read-only, owner already signed in) re-captures the five T3 pages. Compare each to the T3 claim | they still match | the 5 IDs, new capture names, and a comparison line each |

## Results

Write `/srv/fhs-build/reports/store-audit-122-02-test.md` (outside the repo):

```text
## Summary
<≤5 lines: the Verdict line, Totals, and the IDs that failed or are blocked. Claude reads only this section.>

Test plan: store-audit-122-02 · Branch: feat/store-audit-122-02 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence (trimmed output or screenshot path) | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Push or merge.
- Open a browser, or open Toast, R365 or ADP. Type credentials.
- Click anything that changes data: Save, Submit, Approve, Post, Import, Map, Edit, Delete, Create, New, Add, Sync, Run, Send, Email, Pay, or Print-to-vendor.
- Edit, move, or delete anything under `/srv/fhs-build/reports/store-audit-122-captures/`.
