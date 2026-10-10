# Agent task · zz-buildtest-01 · build (test fixture)

> **For the coding agent (Grok 4.7 High in cursor-agent).** This file is your whole assignment.
> A throwaway task that checks the build pipeline works end to end.
> Hand-off: the owner tells you "Do the task in docs/prompts/zz-buildtest-01.md".

## Where you work

- Workspace: `/srv/fhs-build/zz-buildtest`. Before editing: `git checkout -b feat/zz-buildtest`
- User `fhsbuild`.

## Steps

1. Create `docs/zz-hello.md` containing exactly one line: `hello from grok`

## You may edit only

- `docs/zz-hello.md`

## You must not

- Edit any other file, push, merge, use sudo, or log in to anything.

## Tests

1. `cat docs/zz-hello.md` → `hello from grok`
2. `git diff --name-only zz-buildtest...HEAD` → `docs/zz-hello.md` only (after the commit)

## When done

1. Commit on `feat/zz-buildtest` with message `zz: hello` and the line `Co-Authored-By: Grok 4.7 High (cursor-agent)`.
2. Write `/srv/fhs-build/reports/zz-buildtest.md`:

```text
Task: zz-buildtest-01 · Branch: feat/zz-buildtest · Commits: <hash>
Files changed: docs/zz-hello.md
Tests: <n>/2 passed. For each: command, output, pass/fail
```
