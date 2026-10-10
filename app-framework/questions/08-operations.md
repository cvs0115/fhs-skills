# Bank 8 · Operations and support (O)

Used in: [12 Operate and handoff](../playbook/12-operate-handoff.md). O4 and O5 also shape
[05 Architecture and data](../playbook/05-architecture-data.md); O12 is asked at every
[11 Release](../playbook/11-release.md).
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (O1–O5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| O1 ★ | Who supports it after go-live, and who gets alerted? | An unowned system rots. | A named team or person plus a fallback **(Rec)** · The user for now | always |
| O2 ★ | How are collector or job failures detected and alerted, and to whom? | Silent failures show stale data as truth. | A job-failure alert plus a stale-data banner in the UI **(Rec)** · Manual checks | always |
| O3 ★ | Should there be an in-app diagnostics page (last run, per-source status, row counts, errors)? | It is the first stop for support and analysts. | Yes, admin-visible, linked from the "as of" stamps **(Rec)** · Logs only | always |
| O4 ★ | What time budget and job limits apply (max runtime, parallel jobs, API quotas)? | It stops runaway jobs and platform throttling. | A per-run time budget below the platform limit, plus a call cap; fail soft **(Rec)** · Unlimited | always, if there is a scheduled job |
| O5 ★ | What is the retry policy (what is retried, backoff, when to give up)? | Transient errors shouldn't fail a night; permanent ones shouldn't loop. | Retry 429 and 5xx with exponential backoff and jitter, 3 tries, then mark the source failed **(Rec)** | always, if there are API calls |
| O6 | Which runbooks are needed (rotate secret, rerun job, redeploy, restore data)? | Support can act without the Builder. | The top 4 runbooks in the handoff docs **(Rec)** · None | if production-bound |
| O7 | What is logged, and for how long (without secrets or personal data)? | Logs are needed to debug but can leak. | Structured logs with runId, no secrets or personal data, platform retention **(Rec)** | always (quick) |
| O8 | Is there a freshness SLO (e.g. data under 26 h old on 95% of days)? | It turns "is it working?" into a measurement. | A freshness SLO on the snapshot **(Rec)** · None | if production-bound |
| O9 | How are platform changes (apps, scopes, data entities) inventoried for support? | Support needs to know what exists. | Platform Inventory kept current **(Rec)** | always (quick) |
| O10 | What is the recovery plan if data is corrupted or a deploy wipes something? | Uninstalls and redeploys can drop resources. | Snapshot or export before destructive deploys, plus a restore runbook **(Rec)** · Rebuild from source | if deploys are destructive |
| O11 | How do users report problems or request changes? | It closes the feedback loop. | A link on the diagnostics page to the owner or channel **(Rec)** · Ad hoc | if there are users beyond the builder |
| O12 | Are known bugs deliberately deferred, and where are they tracked? | Deferred items get lost. | On the Board with a date and the reason **(Rec)** | at every release |

**Close the bank:** write the runbooks and support contacts into the Handoff
([templates/handoff.md](../templates/handoff.md)).
