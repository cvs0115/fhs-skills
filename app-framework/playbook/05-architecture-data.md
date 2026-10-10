# 05 · Architecture and data

**Goal:** a small, written design that data mistakes can't sneak through: who writes what, where
it lives, how it is keyed, how long it is kept, and how jobs stay inside platform limits.
**Owner:** Coordinator (plan mode) · **Approver:** the user

## When to run / skip

- **Run** for a new app, a new data source, a new stored dataset, or a new job.
- **Light version** for a feature that reuses existing stores: update the data model and add an
  ADR only if a hard-to-reverse choice is made.
- **Skip** for UI-only work that reads existing data.

## Inputs

- PRD (freshness Q3, scale Q5, environments Q4).
- Research notes and `docs/architecture.md` (validated sources, limits).
- Persona needs for history (how far back each persona looks).

## Steps

1. **Draw C4 levels 1–2**: the system in context, then its containers (web app, job or
   collector, data store, external APIs, identity service). Add components only where it helps.
2. **Choose the refresh model** (D2). Default: **one scheduled sync is the single source.**
   - Pages read only the snapshot and show "Data as of …".
   - One admin-only "Refresh now" runs the same sync. Nobody else gets an on-demand refresh.
   - Offer only pre-computed ranges.
   - When someone needs live status, link to the source system's console.
3. **Name the single writer** for every dataset (D3). Default: the collector (app identity).
   User writes (config) go through a role-checked server-side job that writes a history row.
4. **Key every entity by its stable id** (D4). Use a composite id where needed. Keep the display
   name only as a label ("latest name wins").
5. **Store only what you can't read cheaply.** Store history and aggregates. Never store raw
   events. Current state one call can answer is read live or linked out.
6. **Set tiered retention** (D5), sized from persona needs. A good default:
   - daily detail for ~120 days, weekly to ~6 months, then monthly (e.g. 13 months rolling);
   - re-read the last few days each run for late data;
   - freeze a week or month a few days after it closes; sum months from days, never from weeks;
   - cap top-N plus "Other" in the summarized tiers;
   - define the constants **once**, in one module, with a parity test.
7. **Plan pruning:** delete only after that period's summaries are frozen; run a dry run for
   about a week first.
8. **Make jobs idempotent and resumable.** Recompute a slice; never add to it. Save progress per
   slice. Record a failing item and let the others continue. Count an event on its real start day.
9. **Fit the platform's job limits** (O4). If a serverless job is killed at ~15 minutes, set a
   deadline with margin; don't start a slice the slowest slice so far wouldn't finish. Process
   newest data first, least recently updated item first. Chain follow-up jobs with a signed token.
10. **Batch inside one job; don't start many jobs.** Bounded parallelism inside the job (e.g. 6),
    credentials fetched once per job.
11. **Make failure loud.** Per-item errors at Warning, a step that fails for everything at Error,
    and fault the job at the end if anything failed. Monitor that the job *ran*.
12. **Retries:** 429 and 5xx with exponential backoff and jitter; idempotency keys on writes (O5).
13. **Audit fields on every row** (D11): collectedAt, runId, source, writer. Plus a schema-version
    field; add-only changes (D9).
14. **Config lives in the data store, deployment values in assets** (D13). Assets have size limits
    and deploys can reset them.
15. **Inject runtime config** (e.g. a meta tag or runtime env), not build-time constants, for
    anything that changes per environment or location.
16. **Write contracts first:** a typed schema or OpenAPI file plus a JSON example of each record,
    in `contracts/`, so front and back end can be built in parallel.
17. **Write an observability plan:** logs, metrics, traces; the golden signals; a diagnostics page.
18. **Record each hard-to-reverse choice as an ADR.** Log the answers. Close the phase.

## Pattern: privileged backend as the app's own API

Use it when the browser app needs something its signed-in user can't be given directly:
org-wide reads, a third-party admin API, or a trusted write.

**Shape**

| Part | Rule |
|---|---|
| Browser app | Signs in the user with narrow user permissions. Never holds a broad credential. |
| Backend job or service | Runs under its own app (service) identity with the broader rights. |
| Call | The browser starts it with a **mode** plus a **JSON input** that matches a contract in `contracts/`. |
| Result | Comes back through the job's outputs or the data store the browser can read. |
| Server-side checks | Who asked and their roles (from the platform, not from the input), input validation, an audit row (who, what, when, run id). |
| Credential | Stays in the backend's credential store. Never sent to, logged for, or derivable by the browser. |

**Trade-offs**

- **Latency and cost per call:** each call may start a job. Fine for admin actions and nightly
  syncs; wrong for every page load.
- **Platform job limits:** runtime caps (e.g. a serverless job killed at ~15 minutes) mean time
  budgets with margin, resumable slices and chained follow-up jobs.
- **Concurrency:** many simultaneous starts can throttle the platform or time out credential
  fetches. Queue or batch; allow one run per mode at a time where it matters.
- **More moving parts:** the mode list, the contract and the role rules must be versioned and
  tested like any API.

**When to switch to direct writes instead:** small, user-owned writes (a user's own preference, a
note on an item they own) may go straight to the data store, **if** the store's own role checks
can be the boundary: default grants checked, a role per group, rows scoped to the user, and an
audit field on each row. Record the switch in an ADR. Keep collected data on the single writer.

A platform-specific version of this pattern: [platforms/uipath-framework.md](../platforms/uipath-framework.md).
Security side: [06 Security and access](06-security-access.md).

## Questions to ask

Bank: [questions/04-data-architecture.md](../questions/04-data-architecture.md). Must-asks:
**D1, D2, D3, D4, D5**. Then D6, D9, D11, D13, D14 as triggered. Also O4 and O5 from
[08-operations.md](../questions/08-operations.md). Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- `docs/architecture.md`: C4 L1–L2, data flow, data model (entities, ids, owner, retention,
  sensitivity, source of truth, versioning).
- ADRs for refresh model, store, single writer, retention ([templates/adr.md](../templates/adr.md)).
- `contracts/` with schemas and example records.
- Observability plan (a section of the architecture doc).
- Decision Log entries.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): designs in plan mode, writes the docs and ADRs.
- [Researcher](../agents/researcher.md): answers open questions with evidence.
- [Verifier](../agents/verifier.md): optional fresh-context review of the design against the PRD.

## Gate / definition of done

- [ ] D1–D5 answered, logged, and captured in ADRs.
- [ ] Every dataset has one writer, a stable id key, a retention rule and audit fields.
- [ ] Job time budget is below the platform limit, with margin.
- [ ] Contracts exist for every record two Builders share.
- [ ] Retention constants live in one place.
- [ ] Simplicity check: every extra project, service or layer is justified in an ADR.

## Rules and anti-patterns

- **Key by id, never by display name.** Why: two production items had the same name, so maps
  merged their data and a child total stopped matching its parent. Lesson: r1 §1.10.
- **One writer per dataset.** Why: several writers race and clobber data. Lesson: r1 §4 (single writer).
- **Decide the data rule early.** Why: it took several rounds (live, cheap live, snapshot only)
  and each round meant rework. Lesson: r1 §4.
- **A time budget below the platform's job limit.** Why: a 30-minute budget ran into a ~15-minute
  limit and the job was killed mid-item. Lesson: r1 §4 (time budgets).
- **Don't start many jobs at once.** Why: concurrent starts timed out the credential fetch.
  Lesson: r1 §4 (batch inside a job).
- **Fail loudly.** Why: a job ended "Successful" with every item failed, because errors were
  logged at Info; a trigger on the wrong runtime silently never ran for 12 days. Lesson: r1 §4.
- **Define retention constants once.** Why: a review found them in 4 places, off by a day.
  Lesson: r1 §4.
- **Parse inputs defensively.** Why: omitted optional arguments arrived as a literal null, not the
  default. Lesson: r1 §4.
- **Runtime config, not build-time.** Why: a baked-in location id broke the app after a redeploy
  and looked like an auth failure. Lesson: r1 §4.
- **Broad rights live in a backend, not the browser.** Why: the user's token stays narrow and the
  backend can check roles, validate and audit every privileged call. Lesson: r1 §4 (single writer,
  role-checked config job). Practice: https://csrc.nist.gov/glossary/term/least_privilege
- **Don't force one storage pattern on every area.** Why: a pattern that suits one area can hurt
  another. Lesson: r1 §4.
- **Idempotency keys and backoff with jitter.** Why: retries and scheduled reruns become safe.
  Practice: https://stripe.com/blog/idempotency
- **C4 levels 1–2 are enough.** Why: a cheap shared map for people and agents. Practice:
  https://c4model.com/
- **ADRs for hard-to-reverse decisions, with considered options.** Why: they stop agents
  re-arguing settled choices. Practice: https://adr.github.io/madr/ ·
  https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- **Alert on symptoms; watch the golden signals.** Why: you can't operate what you can't see.
  Practice: https://sre.google/sre-book/monitoring-distributed-systems/
