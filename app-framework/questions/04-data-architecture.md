# Bank 4 · Data architecture (D)

Used in: [04 Research spikes](../playbook/04-research-spikes.md) (evidence for D1, D2, D4, D7, D8)
and [05 Architecture and data](../playbook/05-architecture-data.md).
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (D1–D5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| D1 ★ | Which source systems or APIs feed each metric? (The Coordinator lists the candidates, **validated live or from docs**, including alternative endpoints.) | Designing on an unvalidated API is the most common cause of rework. | A validated endpoint per metric, alternatives noted **(Rec)** · User supplies a reference or recorded trace (HAR) | always |
| D2 ★ | What is the refresh model: a scheduled collector writing a snapshot, or live calls from the UI? | It sets the backend shape, cost, rate-limit exposure and freshness. | One nightly collector feeds every page, plus an admin "refresh now" **(Rec)** · Live per page · Hybrid | always |
| D3 ★ | Which store is the source of truth for each dataset, and who is the **single writer**? | Several writers cause races and clobbered data. | One collector writes, the UI only reads **(Rec)** · The UI also writes (config only) | always |
| D4 ★ | What is the stable id for every entity? Do display names ever collide or change? | Keying by name is a latent collision bug. Key by id and keep the name as a label. | The source system's immutable id **(Rec)** · Composite key · Surrogate key | always |
| D5 ★ | What history and retention is needed (tiers, how far back)? | It drives storage size, trend charts and cleanup jobs. | Tiered: ~120 d daily → weekly to ~6 mo → monthly; current + previous business term **(Rec)** · Keep everything · Latest only | always |
| D6 | Where is it stored (the platform's data service, a database, files), and why? | It fixes the query model, limits and the access model. | The platform's native data store **(Rec)** · External database · Files or blob storage | unless the docs state it |
| D7 | What volumes and API rate limits apply (calls per run, 429 behavior, paging)? | They set the collector's batching, backoff and time budget. | Measure live: count calls, add backoff and a budget **(Rec)** · Assume generous limits | always, if an API is polled |
| D8 | Is a backfill of past data needed, and can the source provide it? | Some APIs lose history (deleted or renamed items), so capture early. | Backfill what the API keeps, then snapshot forward **(Rec)** · Start empty | if trends are P0 |
| D9 | How will schemas evolve (add-only fields, versioned payloads, migrations)? | Breaking changes wipe data or break older UIs. | Add-only fields plus a schema-version field; reviewed payloads in the repo **(Rec)** · Migrations | always (quick) |
| D10 | Does any dataset hold personal or sensitive data? How is it minimized or masked? | It is a legal and security gate that affects storage and roles. | Store the minimum and mask in the UI by role **(Rec)** · No personal data · Full data with controls | if there is user or person data |
| D11 | Which audit fields go on every record (collectedAt, runId, source, writer)? | They enable diagnostics, dedupe and "how stale is this?" labels. | collectedAt + runId + sourceEndpoint on every row **(Rec)** · Minimal | always (quick) |
| D12 | How are deleted or renamed source items handled (keep, flag, drop)? | History shouldn't vanish when the source forgets it. | Keep with a status flag (active/deleted) and the last name as label **(Rec)** · Drop | if the source can delete or rename |
| D13 | Is app configuration (thresholds, mappings) data or code, and where does it live? | Config in the data store can change without a redeploy. | Data store, admin-editable **(Rec)** · Deployment assets or env vars · Code constants | if there are tunables |
| D14 | How are partial runs handled when some sources fail? | It avoids half-written snapshots being shown as truth. | Per-source status, keep the last good data and flag it **(Rec)** · All or nothing | if there are several sources |
| D15 | Can demo or preview data be real-shaped (only fields the collector really produces)? | Unreal demo data sets false expectations. | Real-shaped, with made-up values only **(Rec)** · Anonymized copy of real data | if Q12 is yes |

**Close the bank:** record the data model and the refresh and retention choices as ADRs
([templates/adr.md](../templates/adr.md)).
