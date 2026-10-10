# Test plan · windows-research-01

> **For the tester agent (Grok 4.7 High in cursor-agent, a fresh session, not the one that did the research).**
> This file is your whole assignment. Run every case, record real evidence, and judge each one
> PASS, FAIL or BLOCKED. Don't fix anything. If something fails, that's the result.
> Hand-off: the owner tells you "Run the test plan in docs/tests/windows-research-01.md".

## What's being tested

That the research note `docs/research/windows-agent.md` is complete and true. The key claim, that the
proposed `pre-receive` hook accepts only `feat/win-*` pushes, is re-proven by you from the hook text
in the note, in your own throwaway repos. The PC-side checks are the owner's. The mirror refresh
and report transfer get tested on the PC later, in the build plan's test plan.

Plan: `docs/plans/windows-research-01.md` · Researcher report: `/srv/fhs-build/reports/windows-research-01.md`

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/windows-research-01` on `feat/windows-research-01`, as `fhsbuild` | read the note; throwaway repos only in `T=$(mktemp -d -t winres-test-XXXX)` |

## Preconditions

- The researcher report exists. Make `$T`, and delete it at the end.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | List the note's `## ` headings | sections 1–6, Owner checklist, Summary | output |
| T2 | shell | Check every claim in sections 1, 2, 5 and 6 for a source (URL or command + output) or a `(?)` | no unsourced claim | per-section yes/no + quotes |
| T3 | shell | Copy the `pre-receive` hook text **exactly as written in the note** into `$T/server/.git/hooks/pre-receive` of a new non-bare repo with `main` checked out and one commit. Clone it to `$T/pc`. | the hook installs and is executable | commands + `ls -l` |
| T4 | shell | From `$T/pc`: push a new `feat/win-hello` | accepted | output |
| T5 | shell | Push `main` (after a new commit) | refused | output |
| T6 | shell | Push `feat/other` | refused | output |
| T7 | shell | Rewrite `feat/win-hello` and force-push | refused | output |
| T8 | shell | `git push origin --delete feat/win-hello` | refused | output |
| T9 | shell | Push `feat/win-Upper_Case` | refused (the pattern allows only `[a-z0-9-]`) | output |
| T10 | shell | Read section 4 (mirror refresh). Check that it hashes both sides, lists differences, asks before copying, re-hashes after, and reports Windows-only files without deleting them | all five present | quotes |
| T11 | shell | Read section 1. Check the Windows install command and flags have Cursor docs URLs | yes, or `(?)` with a reason | quotes |
| T12 | shell | Check the Owner checklist section is present with every blank still empty (the researcher must not answer them) | all six items present, all blank | quotes |
| T13 | shell | `git diff --name-only main...HEAD`, and `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md` | only the note and `tech-stack.md`; the tech-stack diff is added lines only, in one new section, matching facts the note marks confirmed | output |
| T14 | shell | `rm -rf "$T"; test -e "$T" && echo LEFT \|\| echo GONE` | `GONE` | output |

## Post-merge verification (not a gate)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P1 | owner | The owner fills in the checklist on the PC; Claude records the answers in the note | every blank answered | the committed note |

## Results

Write `/srv/fhs-build/reports/windows-research-01-test.md`:

```text
Test plan: windows-research-01 · Branch: feat/windows-research-01 at <commit> · Tester: grok-4.7-high (fresh session)
| ID | Result | Evidence | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix the note. Use sudo. SSH anywhere or contact the PC.
- Install a hook anywhere outside `$T`.
