# Plan · <ROW_ID> <TITLE>

<DATE>. Plan only. This file is not approved. Do not build from it. Do not brief a builder. Do not cut a worktree.

## Verdict

<Build, or no build.>

If the row is already true, or a code change is not worth it, say no builder and name no files to edit. An empty builder seat is not a reason to invent the change.

## Files a later builder may edit

Only these, and only inside the worktree named below:

- `<path>`

## Files a later builder must not edit

- The checkout the running app serves
- The Board and the Decision Log
- `<paths owned by another row>`

## Done-check

<The test, command, or reading that proves the row. Name the evidence, not a status word.>

## Which tree is live

- **Served tree:** <the checkout the dev server or the user-facing process reads>
- **Crash tree:** <the checkout a process restart loads>
- **Live before merge:** <what the user still sees until a reviewed merge, and until any separate restart>

A missing or wrong tree is a review major.

A reviewed merge is live only for the process that loads that tree. A restart, enabling a schedule, and cutting over a behavior are each a separate OK.

## Where a later builder would work

Only after a review verdict of APPROVE, and only after a brief. This plan does not create the worktree.

- Worktree: `<path>`
- Branch: `<branch>`
- Cut from: `<integration branch at the commit named in the brief>`
- Commit only in that worktree. Do not merge. Do not edit the served tree.

The brief restates the files, the served tree, and the crash tree. The builder follows the brief when an older sentence here still says no builder.

## What stays

<The behavior, labels, and locks this row does not change.>
