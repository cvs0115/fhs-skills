# 11 · Release

**Goal:** the verified build is what really runs in the target environment, live config survived
the deploy, and the repo, tags, Platform Inventory and Handoff match it. Proven by content hash
and job logs, not by version numbers or green statuses.
**Owner:** Release Manager · **Approver:** the user (every push and every deploy)

## When to run / skip

- **Run** for every change that needs a real deploy: server-side code, jobs, schemas, triggers,
  config assets, identity or scope changes.
- **Skip the deploy** for UI-only work checked on the local dev server; it rides the next release.
- **Never skip** the capture-before and verify-after steps when a deploy happens.

## Inputs

- `develop` with a SHIP / GO verdict from [10 Verify](10-verify.md).
- The Board (what this release carries), the "Next release" list, the Platform Inventory.
- The Release Checklist ([templates/release-checklist.md](../templates/release-checklist.md)).

## Steps

**Before**

1. **Confirm scope:** the Board lists what ships; everything is merged on `develop`; Verifier and
   GUI Testers say GO.
2. **Re-run the gates:** real type-check, all suites, conflict-marker grep, brace balance, secret
   scan. Record the gate line.
3. **Fresh production build from source.** Record the content hash of the local bundle (hashed
   file name, checksum or embedded build id). Never ship a committed build folder.
4. **Query the live version.** Make the new version strictly greater (L13). Don't trust a local
   file that computes "next".
5. **Capture live config** into the scratchpad: config asset values, trigger inputs, role
   assignments, schedules. Note credential **names** only, never values.
6. **Download the live release definition.** Check that it wasn't reverted. Overlay your sources,
   keep platform-owned files, sync platform-side config (e.g. sign-in scope files), and diff
   everything.
7. **Show the user** the commit list, the diff summary and the plan. Get an explicit OK.

**Deploy**

8. **Upload the whole release unit** (the package or bundle), not its pieces. Re-download it and
   check the sources and hash.
9. **The user deploys.** Agents never deploy.

**After**

10. **Deployment is active at the new version, and served content hash = local hash.**
11. **Re-enter secrets** (the user). Run a short **test job and read its logs** for evidence the
    credential was really used, not just a "Successful" status.
12. **Run one job per changed mode** and check the data it wrote (row counts, run id, as-of time).
13. **Restore the captured config**, or regenerate it. Diff against the capture.
14. **Check identities:** group keys = identity-provider ids; the access gate accepts each role;
    a viewer test is refused.
15. **Record:** update the Platform Inventory and the Handoff change log (dated, with ids).
16. **Merge `develop` → `main`**, tag `v<version>`. Push only after the commit list, a secret scan
    and the user's OK. Fast-forward only, never force.
17. **Sync the handoff snapshot from `main`** ([12](12-operate-handoff.md)); archive the old one.
18. **Next scheduled run:** check it succeeded, chained jobs passed the gate, pruning is still in
    dry run if it should be, and the as-of time moved.
19. **List deferred bugs** on the Board with date and reason (O12). Note the DORA-style numbers:
    lead time, deploy frequency, failure rate, recovery time.

## Questions to ask

Bank: [questions/07-planning-delivery.md](../questions/07-planning-delivery.md). Must-asks:
**L1, L2, L3, L4, L5**. At release, **L3** (flow and verification) and **L4** (what needs an OK)
apply every time; then L11 (pre-deploy capture), L12 (handoff), L13 (version). Ask **O12** from
[08-operations.md](../questions/08-operations.md). Rules: [00-etiquette.md](../questions/00-etiquette.md)
(rule 5: destructive steps need their own OK, each time).

## Artifacts produced

- Completed Release Checklist ([templates/release-checklist.md](../templates/release-checklist.md)).
- Tag `v<version>` on `main`; change log entry.
- Updated Platform Inventory ([templates/platform-inventory.md](../templates/platform-inventory.md))
  and Handoff log ([templates/handoff.md](../templates/handoff.md)).
- Config capture (scratchpad, not in git).

## Agent roles involved

- [Release Manager](../agents/release-manager.md): runs the checklist, captures, uploads, verifies.
- [Verifier](../agents/verifier.md): independent after-deploy check (hash, job logs, data).
- [Coordinator](../agents/coordinator.md): gets the user's OKs, merges to `main`, updates docs.
- The **user**: approves, deploys, re-enters secrets.

## Gate / definition of done

- [ ] Served content hash equals the local build hash.
- [ ] A test job's logs show the credential and the real effect (records written).
- [ ] Captured config restored and diffed.
- [ ] Identity and role checks pass, including a refused viewer.
- [ ] `main` tagged; push done after OK; handoff synced from `main`.
- [ ] Inventory and Handoff updated in the same turn.

## Rules and anti-patterns

- **Verify by content hash, not version.** Why: the version went up three times while the served
  bundle stayed byte-identical; a stale committed build folder was being repackaged. Lesson: r1 §5.4.
- **A green status isn't proof.** Why: a test job said "Successful" but an access gate had refused
  it before the credential was used. Read the logs. Lesson: r1 §5.1.
- **Deploys reset config.** Why: a deploy reset config values to `{}` and wiped a secret. Capture
  before, restore after. Lesson: r1 §5.3.
- **Untracking a resource deletes it on the next upgrade.** Why: a credential untracked "for
  safety" was deleted. Keep it tracked; re-enter the secret. Lesson: r1 §1.22, §5.7.
- **Check the live version first.** Why: the release tool computed the next version from a
  drifted local file and collided. Lesson: r1 §5.6.
- **Ship the whole unit.** Why: component pushes let parts drift out of sync. Lesson: r1 §1.21.
- **Re-download after upload.** Why: the platform copy can be reverted or miss files. Lesson: r1 §5.9.
- **Sync platform-side config files.** Why: sign-in scopes lived in a file the overlay never copied.
  Lesson: r1 §5.5.
- **Some resources can't be packaged.** Why: a trigger created an unfixable duplicate pair. Create
  them by hand and list them in the install steps. Lesson: r1 §5.8.
- **Push only after a commit list, a secret scan and an OK.** Why: a push is outward-facing and
  irreversible. Lesson: r1 §1.17.
- **SemVer or date versions, tagged.** Why: ties tags, packages and the change log. Practice:
  https://semver.org/
- **Short-lived branches, releasable trunk.** Why: less merge pain with parallel agents; git-flow
  suits only explicitly versioned software. Practice: https://trunkbaseddevelopment.com/ ·
  https://nvie.com/posts/a-successful-git-branching-model/
- **Track delivery metrics.** Why: they show whether the process helps. Practice:
  https://dora.dev/guides/dora-metrics/
- **Side-effecting workflows are user-invoked only.** Why: a model shouldn't decide to deploy.
  Practice: https://code.claude.com/docs/en/skills (`disable-model-invocation`).
