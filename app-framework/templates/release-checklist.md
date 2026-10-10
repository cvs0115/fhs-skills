# <APP_NAME> · Release Checklist · v<VERSION> to <ENV>

Copy to `docs/release-checklist.md`, fill the commands once, then tick one copy per release (keep
the ticked copy with the release notes). Every tick carries its evidence. `/release` walks this list.
**OK** marks a stop: nothing past it happens without the user's explicit OK for that step.

**Commands for this app:** build `<BUILD_CMD>` · type-check `<TYPECHECK_CMD>` · tests `<TEST_CMD>` ·
secret scan `bash hooks/secret-scan.sh --range <LAST_TAG>..develop` · live version `<VERSION_QUERY>` ·
config export `<CONFIG_EXPORT_CMD>` · served hash `<HASH_CMD>`

## Before

- [ ] The Board shows what the release carries. Everything is merged on `develop`. GUI Testers say
      SHIP and the Verifier says PASS for the last wave. Evidence: <rows, verdict links>
- [ ] Real type-check (build mode, checks more than zero files), the full suite, a conflict-marker
      grep and brace balance: all clean. Evidence: `typecheck clean (N files), tests N/N`
- [ ] Fresh production build from source (no stale committed build output). Local content hash:
      `<HASH>`
- [ ] **Live** version queried: `<CURRENT>`. New version `<VERSION>` is strictly greater.
- [ ] **Live config captured** into `<SCRATCH>/release-<VERSION>-config/`: config values, schedule
      inputs, role assignments. Secret **names** only.
- [ ] Live release definition downloaded and not reverted. Sources overlaid, platform-owned files
      kept, platform-side config lines (for example sign-in scopes) synced, everything diffed.
- [ ] No live resource untracked from the release unit (untracking deletes it on upgrade).
- [ ] Commit list since `<LAST_TAG>` shown. Secret scan and large-file check clean.
- [ ] Release notes drafted (what changed, per persona; known issues).

**OK 1** — upload release unit `<VERSION>` to `<ENV>`. Blast radius: <what the upload replaces>

## Deploy

- [ ] The **whole** release unit uploaded (not separate components).
- [ ] Re-downloaded: holds our sources; content hash matches `<HASH>`.

**OK 2** — the **user** deploys (agents never do, unless the user says so for this release).

## After

- [ ] Deployment active at `<VERSION>`, and the **served content hash = the local hash** `<HASH>`.
- [ ] Secrets re-entered if the deploy reset them. A short **test job run, and its logs read**:
      evidence the credential was really used (not just a Successful status). Evidence: <log line>
- [ ] One job of each changed mode run; the data it wrote checked (records, counts, ids).
- [ ] Captured config restored or regenerated; each value re-checked against the capture.
- [ ] Identities checked: platform group keys = identity-provider ids; the access gate accepts each
      role; a lower role is refused admin actions.
- [ ] Verifier (scope: deploy) says PASS.
- [ ] Platform Inventory and the Handoff change log updated.
- [ ] `develop` merged to `main`; tag `v<VERSION>` created.

**OK 3** — push `main`, `develop` and tag `v<VERSION>`. Commit list and secret scan shown. Fast-forward
only, never force. (Agents never push `main`; the user runs that push or approves it outside the agent.)

- [ ] Pushed. Handoff snapshot synced from `main`; the old snapshot archived.
- [ ] Board: release rows moved to Completed with the version; "next morning check" row added.

## Next morning

- [ ] First scheduled run succeeded; chained follow-up jobs passed their gates.
- [ ] Destructive steps (pruning, cleanup) still in dry run if that was the plan.
- [ ] "Data as of" updated on the pages; the diagnostics page is green.
