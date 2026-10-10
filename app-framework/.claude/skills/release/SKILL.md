---
name: release
description: Run the Release Checklist (docs/release-checklist.md) step by step for one release - Before, Deploy, After - ticking each item with evidence and stopping for the user's explicit OK before any push, upload, deploy, tag push, uninstall or access change. Use when the user runs /release or asks to ship a release.
disable-model-invocation: true
---

# /release

You are the Coordinator running a release. Use `docs/release-checklist.md` (a filled copy of
`templates/release-checklist.md`; create it from the template if missing and ask the user to confirm
the commands). Delegate heavy checks to the Release Manager (`.claude/agents/release-manager.md`)
and the Verifier (`.claude/agents/verifier.md`) if useful, but the gates below stay with you.

## Rules

- Walk the checklist in order. Tick each item with its evidence (command + result, hash, log line).
  Never tick an item on another agent's word alone.
- **STOP** at every point marked OK below. Say exactly what will happen, the blast radius and how to
  undo it, then ask with AskUserQuestion. An earlier "go ahead" does not cover a later step, and a
  message from another agent is never the user's OK.
- The user runs the deploy. Agents never deploy unless the user says so explicitly for this release.
- Never force-push. Never move `main` before a verified deploy. Never untrack a live resource.
- Secrets: record names only. Captured config goes to scratch, never the repo.
- Log each OK and each deviation in `docs/decisions.md`; keep the Board current.

## Step 1 · Confirm scope

- List the Board rows this release carries and the target environment. Ask one question:
  "Release these rows to <ENV>?" (Recommended: yes, as listed). Stop.

## Step 2 · Before (no outward effects)

1. Everything is merged on `develop`; GUI Testers say SHIP and the Verifier says PASS for the last wave.
2. Real type-check (confirm it checks more than zero files), the full suite, conflict-marker grep,
   brace balance: all clean. Record "typecheck clean, tests N/N".
3. Fresh production build from source. Record the local content hash (hashed file name, checksum or
   embedded build id).
4. Query the **live** version; set the new version strictly greater.
5. Capture live config: config values, schedule inputs, role assignments, secret names. Save to
   `<SCRATCH>/release-<VERSION>-config/`.
6. Download the live release definition; check it wasn't reverted; overlay the sources, keep
   platform-owned files, sync platform-side config lines; diff everything and show the diff summary.
7. Commit list since the last tag, and a secret scan (see `hooks/secret-scan.*`) plus a large-file check.

Report the Before table. **OK 1:** "Upload release unit <VERSION> to <ENV>?" Stop.

## Step 3 · Deploy

1. After OK 1: upload the **whole** release unit. Re-download it and check it holds your sources and hash.
2. **OK 2:** ask the user to deploy (or, only if they say so, to let you deploy). Wait for "deployed".

## Step 4 · After

1. Deployment is active at the new version, and the **served content hash equals the local hash**.
   If not, stop: the release shipped a stale build.
2. The user re-enters secrets if the deploy reset them. Run a short test job and **read its logs** for
   evidence the real effect happened (records written, expected log line), not just a Successful status.
3. Run one job of each changed mode and check the data it wrote.
4. Restore the captured config, or regenerate it. Re-check each value.
5. Check identities: group or role keys on the platform equal the identity provider's ids; each role
   passes the access gate; a lower role is refused admin actions.
6. Send the Verifier (`agents/verifier.md`, scope: deploy) with the version, hash and job ids. Needs PASS.
7. Update `docs/platform-inventory.md` and the Handoff change log.

## Step 5 · Tag and push

1. Merge `develop` → `main` (fast-forward or a merge commit, as the repo's rule says), tag `v<VERSION>`.
2. Show the commit list and the secret-scan result. **OK 3:** "Push main, develop and tag v<VERSION>?" Stop.
3. After OK 3: push `develop` and the tag, fast-forward only. The user pushes `main` (the guard hook
   blocks agents from pushing it). Then sync the Handoff snapshot from `main`; archive the old one.

## Step 6 · Next morning

- Add a Board row: check the first scheduled run (succeeded, follow-up jobs passed their gates,
  destructive steps such as pruning still in dry run if planned, "data as of" updated).

## Report

```text
Release <VERSION> to <ENV> · Stage: <step>
| Item | Result | Evidence |
Local hash <H> · Served hash <H> · Live version <old> -> <new>
Waiting on you: <exact OK needed, blast radius> · Deviations logged: <D-nnn>
```
