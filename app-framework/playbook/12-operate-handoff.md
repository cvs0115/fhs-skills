# 12 · Operate and handoff

**Goal:** the app can be run, diagnosed and supported by someone who didn't build it. What is
deployed, what exists on the platform, and what changed and why are all written down and current.
**Owner:** Docs Writer (Handoff, runbooks) · Coordinator (Platform Inventory) · **Approver:** the user

## When to run / skip

- **Run** after every verified release, and once in depth before a handoff to another team.
- **Run the inventory part** after *any* live platform change, released or not.
- **Skip the handoff part** for a throwaway demo (K8) with no handoff target (K11).

## Inputs

- The release just verified in [11 Release](11-release.md), `main` at its tag.
- Platform Inventory, architecture doc, Decision Log, Board (deferred bugs).

## Steps

1. **Diagnostics page** (O3), admin-visible, linked from every "as of" stamp:
   - last run per job and mode: start, end, status, run id;
   - per-source status and last good data time;
   - row counts per dataset and tier;
   - recent errors (no secrets, no personal data);
   - a link to the owner or support channel (O11).
2. **Alerts** (O2): a job-failure alert to a named owner; a stale-data banner in the UI when data
   is older than the freshness SLO (O8). Alert on symptoms. Every alert has an action.
3. **Monitor that jobs ran**, not just that triggers exist.
4. **Logs** (O7): structured, with run id; no secrets or personal data; platform retention.
5. **Runbooks** (O6), the top four at least: rotate a secret, rerun a job, redeploy, restore data.
   Each: when to use, steps, how to check it worked, who to call.
6. **Recovery plan** (O10): export or snapshot before any destructive deploy; a restore runbook.
7. **Platform Inventory** (O9): every app, scope, role, group, credential (name only), config
   asset, data entity, trigger and schedule, with ids and a dated change log. Read it back from the
   platform with the CLI; don't write it from memory.
8. **Handoff folder:** sync from `main` only, right after a verified deploy. Never edit it
   directly. Archive the previous snapshot.
9. **Handoff log** (`HANDOFF.md`): what changed and why, per release, dated; install steps
   including any resources created by hand; known gotchas; deferred bugs with reasons.
10. **Check the Handoff against reality:** every app, runtime and resource it names exists; nothing
    deleted is still listed.
11. **Retro:** what went wrong, what rule prevents it. Add the rule to
    [lessons/rules-and-why.md](../lessons/rules-and-why.md) and, if it must always hold, to a hook
    or a test, not only to `CLAUDE.md`.

## Questions to ask

Bank: [questions/08-operations.md](../questions/08-operations.md). Must-asks:
**O1, O2, O3, O4, O5**. Then O6–O12 as triggered. Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- Handoff: change log, install steps, runbooks, gotchas, support contacts
  ([templates/handoff.md](../templates/handoff.md)).
- Platform Inventory, current and read back ([templates/platform-inventory.md](../templates/platform-inventory.md)).
- Diagnostics page and alert list (in the app and the architecture doc).
- Retro notes feeding [lessons/](../lessons/) and `CLAUDE.md`.

## Agent roles involved

- [Docs Writer](../agents/docs-writer.md): writes the Handoff and runbooks; only its target docs.
- [Coordinator](../agents/coordinator.md): keeps the Platform Inventory; runs CLI read-backs.
- [Verifier](../agents/verifier.md): checks the Handoff names only things that exist.
- [Release Manager](../agents/release-manager.md): syncs the handoff snapshot from `main`.

## Gate / definition of done

- [ ] O1–O5 answered and logged.
- [ ] Diagnostics page shows last run, per-source status, row counts and errors.
- [ ] Failure alert and stale-data banner both tested once.
- [ ] Top four runbooks written and dry-run by someone other than their author.
- [ ] Platform Inventory matches a fresh CLI read-back.
- [ ] Handoff synced from `main` and its log updated for this release.

## Rules and anti-patterns

- **Record every live platform change in the inventory and the handoff, the same turn.** Why: an
  install must reproduce the exact setup and access must stay auditable. Lesson: r1 §1.15.
- **Run the CLI yourself to read state back.** Why: asking the user to run commands wastes their
  time and invites transcription errors. Lesson: r1 §1.15.
- **The handoff reflects shipped state only.** Why: a handoff named a deleted app and the wrong
  runtime after it drifted. Lesson: r1 §7 (handoff drift), §1.18.
- **Monitor that the job actually ran.** Why: a trigger on the wrong runtime silently never ran for
  12 days. Lesson: r1 §4 (make failure loud).
- **Failure must be loud.** Why: a job ended "Successful" with every item failed. Lesson: r1 §4.
- **Alert on symptoms; every alert actionable.** Why: noisy alerts get ignored. Practice:
  https://sre.google/sre-book/monitoring-distributed-systems/
- **Traces, metrics and logs from day one.** Why: you can't operate what you can't see. Practice:
  https://opentelemetry.io/docs/concepts/signals/
- **Deferred bugs have a date and a reason on the Board.** Why: deferred items get lost. Lesson:
  r1 §2 (loose ends).
- **Feed every incident back into a rule.** Why: the Kanban practice of improving collaboratively
  and evolving experimentally. Practice: https://kanban.university/kanban-guide/
- **Anti-pattern: secrets in runbooks or logs.** Name credentials only; values stay in the
  credential store. Lesson: r1 §1.19.
