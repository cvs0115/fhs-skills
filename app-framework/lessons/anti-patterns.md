# Anti-patterns

Things that went wrong on a previous app, made generic. Each row: what happened, what it cost, and
the rule that prevents it (see `lessons/rules-and-why.md` for the full reasoning).

## Working with the user

| # | Anti-pattern: what happened | Consequence | Rule that prevents it |
|---|---|---|---|
| 1 | Building before planning and asking: straight to edits on small UI asks | Corrected three times; rework | Plan and ask first, every time |
| 2 | Chaining several pages or steps in one turn | Mistakes hidden in a big batch; hard review | One step or page per turn, then stop |
| 3 | Re-asking for facts the user already gave | Lost trust ("I've sent this multiple times") | Read docs and memory first; write new facts down the same turn |
| 4 | Declaring the docs wrong after one live test | Two rounds of wrong conclusions about permissions | When docs and live disagree, check for a confound, then ask |
| 5 | An options menu built on a guessed capability | User steered toward invented options; the real answer was a flag on an existing endpoint | Don't design on a guess; ask for a reference |
| 6 | Quietly working around a recorded rule and its test | Silent rule drift; broken trust | A rule change is a question; record it beside the old rule |
| 7 | Over-generalizing a narrow instruction ("no breakdown" became "no KPIs") | Useful content removed | Apply the instruction's exact scope; ask if unsure |
| 8 | Domain-hostile wording ("reclaim", "under-utilized") | Copy that works against the business | Vocabulary list and framing rule in the Persona Sheet |

## Data and integration

| # | Anti-pattern: what happened | Consequence | Rule that prevents it |
|---|---|---|---|
| 9 | Keying maps and drill-downs by display name | Two same-named items merged; child totals didn't match the parent | Key by id; name is only a label |
| 10 | One request with no paging | Results silently cut at 200 | Always page; test full page then short page |
| 11 | Testing app-identity questions with a personal browser token | Dead-end investigation | Test as the identity that will run the code |
| 12 | Assuming a broad scope covers every endpoint | Missing scope chased as a role problem | Check each endpoint's own documented scope |
| 13 | Demo-only data shapes (fields the real system can't produce) | Misleading demo; false expectations | Demo data real-shaped; demo-data audit test |
| 14 | Undecided data rule (live vs snapshot) | Several turns of redesign; inconsistent numbers | Decide the refresh model early; one sync feeds every page |
| 15 | Retention constants copied into several places | Windows off by a day between areas | One module for the constants plus a parity test |
| 16 | Config baked in at build time | A redeploy to a new location broke the app; looked like an auth failure | Runtime-injected config |
| 17 | Starting many jobs at once | Shared credential fetch timed out | Batch inside one job with bounded parallelism |
| 18 | A time budget longer than the platform's job limit | Job killed mid-run | Deadline with a margin; don't start a slice that won't finish |
| 19 | Logging per-item errors at Info | Job "Successful" with every source failed | Per-item Warning, total failure Error, fault the job |
| 20 | Watching that the schedule exists, not that it ran | Job silently never ran for 12 days | Monitor real runs; stale-data banner |

## Access and security

| # | Anti-pattern: what happened | Consequence | Rule that prevents it |
|---|---|---|---|
| 21 | Importing identities (groups) by name | Orphan records; nobody got any role | Import by id; check platform ids = provider ids |
| 22 | Leaving throwaway apps behind, or adding permanent ones per feature | Long "persistent 403" investigation; forgotten debug apps | Fixed number of identities; delete throwaway ones at once and record them |
| 23 | Replacing a scope list without reading it first | The update replaces the whole list, so existing scopes are dropped | Read the list; send all existing scopes plus the new one |
| 24 | Granting a user-facing write scope without checking the store's default grants | Every user could have written every row; reverted the same day | Check default grants before any write path |
| 25 | Direct user grants or shared roles | Unauditable access; roles can't be told apart | Groups only; one dedicated role per group per level |

## Building with agents

| # | Anti-pattern: what happened | Consequence | Rule that prevents it |
|---|---|---|---|
| 26 | Parallel Builders in one working tree | Committed each other's half-done work | One worktree per Builder |
| 27 | A scripted merge without a marker check | Conflict markers committed | Grep for `<<<<<<<` before every merge commit |
| 28 | Hand-resolving stylesheet conflicts without a check | Unclosed media query; the desktop layout broke | Brace-depth-0 test on stylesheets |
| 29 | A type-check that checks nothing | A real type error hid through several "clean" rounds | Use the build's real check; confirm it covers files |
| 30 | Running another agent's scratch files | An agent acted on another agent's half-done script | Unique scratch prefix; never run others' files |
| 31 | Restarting agents after a session limit | Lost context; redone work | Check worktree state and resume |
| 32 | Two testers on one browser profile | Sessions clashed | One persistent profile per tester |
| 33 | Wall-clock timing asserts under parallel load | Flaky suite | CPU time, best of two, guard at about 3× |

## Releasing

| # | Anti-pattern: what happened | Consequence | Rule that prevents it |
|---|---|---|---|
| 34 | Trusting a green status | A gate refused the test job before it did anything; it still showed Successful | Read logs for evidence of the real effect |
| 35 | Trusting version numbers for a deploy | A stale build shipped three times under new versions | Verify by served content hash vs local build |
| 36 | Deploying without capturing config | Config reset to empty; a secret wiped | Capture before upload; restore after |
| 37 | Untracking a resource to "protect" it | The next upgrade deleted it | Keep it tracked; re-enter the secret after deploy |
| 38 | Bumping the version from a local file | Collided with a version pushed another way | Query the live version first |
| 39 | Letting the Handoff drift from shipped state | Handoff named a deleted app and the wrong runtime | Update Inventory and Handoff on every live change; sync from `main` after deploy |
