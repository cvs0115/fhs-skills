# <APP_NAME> · Board

The live queue. Stable rules live in the door file (`CLAUDE.md`). This page does not restate them.

The Coordinator updates it the same turn an agent starts, finishes, or a decision is logged. Planners, reviewers, builders, and testers never edit it.

**Priority:** **P0** blocks the release · **P1** ships if ready · **P2** after.

**Ask:** only when the user must act or choose. That request is a question pane, recommendation first, worded so they can answer without the chat. This page is not where you ask. If nothing needs the user, Waiting stays empty and work continues.

**Agents:** every turn, count who is running. If fewer than five, start the next rows below that do not share files and do not need the user. Builder seats stay two. The other seats are plans and reviews. Do not invent a row to fill the count.

**WIP:** <N> rows, matching the table below.

**Trees:** served `<CHECKOUT>` · crash `<CHECKOUT>` · work branch `<BRANCH>` at `<COMMIT>`

**Last gate:** <YYYY-MM-DD> · <what was proved, with the count> · do not cite a stale run

The header is the count, the trees, and the last gate. Running work lives in the WIP table. Finished work lives in Completed. Do not append a narrative to the header.

## How a row moves

1. A Next row whose files are free, and that does not need the user, goes to a planner. The plan uses [plan.md](plan.md).
2. A reviewer from another model family returns [review-verdict.md](review-verdict.md).
3. **APPROVE** and the plan says build, a builder seat is free, and the files are free: a builder starts in its own worktree. It does not edit the served tree.
4. **APPROVE** and the plan says no builder: move the row to Completed the same turn.
5. **APPROVE AFTER FIXES** or **REJECT**: the writer revises. The row stays in WIP. Do not build.
6. The diff review says merge: the Coordinator merges. If the running process does not load that tree, the row goes to **Not live yet**, not to Completed.
7. Before the turn ends, the WIP count in the header matches the table. Every owner link is a real id. No placeholders.

## WIP

| Pri | Item | Owner | Files | Done means |
|---|---|---|---|---|
| P0 | <ROW_ID> <item> | Planner writing | `<paths>` | Plan file. No builder until APPROVE |
| P0 | <ROW_ID> <item> | Reviewer reading the plan | `<paths>` | APPROVE, or send it back |
| P1 | <ROW_ID> <item> | Builder · `<worktree>` | `<paths>` | Commit on that branch. Served tree stays as it is |
| P1 | <ROW_ID> <item> | Reviewer reading the diff | `<paths>` | Merge, or send it back |
| P2 | <ROW_ID> <item> | — | — | Approved. No builder. Already true |

Done means is the next gate. The Files cell is the lock: the next row may not take those paths while this owner is running.

## Next

Ordered. The top row starts when a seat frees and its files are free.

| Pri | Item | Depends on | Files | Notes |
|---|---|---|---|---|
| P0 | <ROW_ID> <item> | <ROW_ID or none> | `<paths>` | Plan first. Needs the user: no |
| P1 | <ROW_ID> <item> | reviewed merge is not live | `<paths>` | Restart is a separate OK |
| P2 | <ROW_ID> <item> | — | `<paths>` | |

### Not live yet

On the work branch. The running process has not loaded it.

- P0 <item> — `<COMMIT>` on `<BRANCH>`. Live after <restart, schedule, or cutover>. Each is its own OK.

## Waiting on the user

Empty when nothing needs them. A gap in a plan is a review finding, not a row here.

| Pri | What they must do | Recommendation first |
|---|---|---|
| P0 | <OK to restart onto `<COMMIT>`> | Wait (Recommended) · Restart |

## Loose ends

Open points found inside a finished row. They do not stay buried in Completed.

| Pri | Loose end | From row | Why it waits |
|---|---|---|---|
| P2 | <item> | <ROW_ID> | <reason> |

## Completed

Newest first. One line. The detail lives in `docs/completed-work.md`.

- <YYYY-MM-DD> · P0 · <ROW_ID> <what shipped> · `<COMMIT>` · <live, or not loaded until a restart>
- <YYYY-MM-DD> · P2 · <ROW_ID> <what was already true> · no builder
