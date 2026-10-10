# R3 — Question banks for planning with the user

Purpose: the coordinator agent picks from these banks to plan **before** building. Each bank is
a checklist, not a script. Ask only what the docs, code, board and decision log do not already
answer.

**How to read the tables**

- **★ = must-ask.** Each bank has exactly 5. Ask them before the phase counts as planned.
- **Options:** the first option, marked **(Rec)**, is the default we recommend and the one
  offered first. Say "Other" when the list might not cover the answer.
- **Ask when:** `always`, or the condition that triggers the question. If the condition does not
  hold, skip the question and write the default down as an assumption.
- IDs (K1, P3, …) are stable, so decisions can point back to them (`answers K3`).

Sources behind the practices: INVEST / Given-When-Then acceptance criteria (Agile Alliance),
MoSCoW prioritisation (DSDM), ISO/IEC 25010 quality characteristics for non-functional
requirements, Google SRE book (SLOs, error budgets, alerting on symptoms), OWASP ASVS 4 and
OWASP Threat Modeling Cheat Sheet (STRIDE), WCAG 2.2 AA, Twelve-Factor App (config/secrets,
dev/prod parity), Nygard ADRs (decision log), SemVer and Keep a Changelog.

---

## 0. Question etiquette (applies to every bank)

1. **Batch size is 1–4 questions**, all on one topic. Wait for the answers, record them, then
   send the next batch. Never send a wall of 20.
2. **Put the recommended option first**, label it `(Recommended)`, and give a one-line reason.
   Keep the options mutually exclusive, 2–4 of them, and add "Other" when it fits.
3. **Don't ask what is already written down.** First read the docs, the code, the board, the
   decision log, memory and the API references. If they answer it, *state* the answer as an
   assumption ("I'm assuming X, per docs/architecture.md") rather than asking.
4. **Ground the question in evidence.** Don't build a menu on a capability you only guessed at.
   Validate APIs live or against their docs first. If you can't, make the first question "can
   you give me the reference or HAR for X?"
5. **Always ask before destructive or access-widening actions.** That covers deletes, uninstalls,
   overwrites, force-push, schema drops, new scopes or roles, new external apps, publishing
   outside dev, and sharing data. A general "go ahead" earlier doesn't cover them. Ask each time
   and name the blast radius.
6. **Pure "what is X?" questions get a direct answer.** No question batch is needed.
7. **Record every answer** in the decision log (section 10) the same turn, with the date, the
   bank ID and who answered.
8. **Conflicts are questions, not overrides.** If an answer contradicts an earlier decision,
   switch to bank 9. Don't silently apply the newer answer.
9. **Order within a phase:** must-asks first, then the questions whose answers change the most
   downstream work, then the nice-to-haves. Stop when the rest can safely use their defaults.
10. **Close each phase** with a short summary: decisions, assumptions taken as defaults, open
    questions. Ask for one confirm ("Anything wrong here?").

---

## 1. Kick-off & goals

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| K1 ★ | What problem are we solving, and what happens today without the app? | It anchors scope. Without the "today" baseline, value can't be shown. | Free text; offer a one-line problem statement for them to correct **(Rec)** | always |
| K2 ★ | Who are the primary users, and who is the audience for demos or sign-off? | Users drive the design. The audience drives the demo narrative. They're often different people. | Internal ops/analysts **(Rec)** · Customer end users · Execs/buyers · Mixed | always |
| K3 ★ | How will we know it worked? Name 1–3 success metrics. | It turns "done" into something you can measure and shapes what data we need. | Time saved per task **(Rec)** · Decision quality/visibility · Cost avoided · Adoption count | always |
| K4 ★ | Is there a hard deadline or demo date, and what must work by then? | It sets phasing and whether demo/preview data is needed. | Demo milestone, then iterate **(Rec)** · Fixed go-live date · No deadline | always |
| K5 ★ | What is explicitly out of scope for this version? | Stops scope creep. Parked items go on the board as Planned. | List now, park on board **(Rec)** · Decide per feature later | always |
| K6 | What are the platform and tech constraints (required stack, hosting, existing tenant or org)? | Stops us designing on a platform we can't deploy to. | Use the existing platform/tenant **(Rec)** · New environment · Undecided | unless docs state it |
| K7 | What's the budget or cost ceiling (licences, API calls, compute)? | It limits polling frequency, storage and paid services. | Stay within existing licences **(Rec)** · Small new spend OK · Defined budget | if paid services or heavy API use are likely |
| K8 | Is this a one-off, a proof of concept, or a long-lived product? | It sets how much to spend on ops, tests and handoff. | POC that can grow into a product **(Rec)** · Throwaway demo · Production product | always (quick) |
| K9 | Who decides priorities and signs off, and who else has to be consulted? | One decider avoids conflicting instructions. | The user decides alone **(Rec)** · Named stakeholder group | if more than one stakeholder is mentioned |
| K10 | Is there an existing tool or reference product to match or beat? | It gives a value benchmark and a feature floor. | Name a reference and list its value props **(Rec)** · None | always (quick) |
| K11 | What's the handoff target: who runs it after us, and where is it delivered? | It shapes docs, packaging and the folder or repo layout from day one. | Customer team via a handoff folder **(Rec)** · The user's own team · Us | if it's customer-facing or long-lived |
| K12 | Is there anything politically sensitive about the framing or the data (e.g. cost cutting vs growth)? | Wording can sink adoption. It sets the tone rule early. | Growth/opportunity framing **(Rec)** · Neutral/factual · Cost/savings framing | if the data is about people, cost or utilisation |

---

## 2. Personas & value

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| V1 ★ | Which personas use it? Confirm the list and a one-line description of each. | Every page gets reviewed against these personas. | Analyst + Business owner + Prod support + Finance **(Rec)** · Custom list | always |
| V2 ★ | For each persona, what are the top 3 jobs or questions they bring to the app? | Jobs drive page inventory and key numbers. | Draft per persona and have the user correct it **(Rec)** · User supplies them | always |
| V3 ★ | What would each persona find *concerning* (what should jump out at them)? | It defines alerts, highlights, sort orders and "needs attention" panels. | Draft per persona (e.g. at capacity, failing, idle, overspend) **(Rec)** · User supplies | always |
| V4 ★ | What tone and wording rules apply (framing, banned words, verdict labels)? | It keeps copy consistent across every page and every agent. | Growth framing with positive verdicts **(Rec)** · Neutral · Customer's glossary | always |
| V5 ★ | Should the UI change per persona: a persona switch, separate views, or one view for all? | It's a big effect on layout and component design. | One page with a persona switch that reorders and highlights **(Rec)** · Separate pages per persona · Single view | always |
| V6 | Which persona is the primary one (who wins when layouts conflict)? | Breaks design ties. | The analyst/specialist **(Rec)** · Business owner · Exec | if there are 2 or more personas |
| V7 | Write the value stories: "As <persona>, I can <do> so that <outcome>." Which 3 matter most? | Value stories become the P0 list and the demo script. | Draft top 3 per persona **(Rec)** · User writes them | always |
| V8 | What does each persona do *next* after seeing a concerning item (drill down, open the source system, export, notify)? | It defines cross-links and actions. A dead-end insight isn't worth much. | Drill down, then link to the source system **(Rec)** · Export · In-app action | always |
| V9 | Which domain terms must match official names exactly (product names, licence types, units)? | Terms that don't match cause trust and support problems. | Use the vendor's official names; the full name in headings **(Rec)** · Customer's terms | if there's a vendor or customer domain |
| V10 | Is there a fixed ordering convention (cost order, severity order)? | It keeps lists, legends and charts consistent everywhere. | Most-to-least costly/severe **(Rec)** · Alphabetical · By volume | if there are categories |
| V11 | Which personas must *not* see certain data or actions? | It feeds RBAC (bank 5) and hides admin-only controls. | Admin-only actions hidden from others **(Rec)** · Everyone sees everything | if there are admin or write actions |
| V12 | How technical is each persona? Do they need definitions or tooltips on every metric? | It sets how much help text to write and how dense the numbers are. | Tooltips on every metric with plain-language definitions **(Rec)** · Expert UI, minimal help | always (quick) |

---

## 3. Requirements

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| Q1 ★ | Confirm the feature list and priority: P0 (must be in v1), P1 (next), P2 (later). | It's the backbone of phasing and the board. | Coordinator drafts from V7, user reorders **(Rec)** · User supplies | always |
| Q2 ★ | What are the acceptance criteria for each P0 (Given/When/Then, testable)? | It defines done and feeds browser sweeps and tests. | Draft 2–4 per P0 for the user to confirm **(Rec)** · User writes them | always |
| Q3 ★ | How fresh does the data need to be per page (live, hourly, nightly)? | It's the single biggest driver of architecture and API cost. | Nightly snapshot, plus a manual admin refresh **(Rec)** · Hourly · Live | always |
| Q4 ★ | Which environments exist, and where does each stage deploy (dev, test, prod)? | Stops accidental deploys to the wrong tenant and sets promotion steps. | Dev only now, prod via handoff **(Rec)** · Dev → Test → Prod · Single env | always |
| Q5 ★ | What's the expected scale (users, tenants or orgs, records per day, history length)? | It sizes storage, paging and query design. | Give orders of magnitude **(Rec)** · Unknown, so measure live first | always |
| Q6 | What are the page-load and performance targets? | It sets budgets for queries and bundle size. | Landing under 3 s, drill-down under 2 s on a warm cache **(Rec)** · Best effort | if there's large data or a slow API |
| Q7 | What's the availability expectation (business hours vs 24×7), and what's acceptable downtime? | It decides monitoring depth and the retry and fallback design. | Business-hours best effort **(Rec)** · 24×7 with an SLO · None | if it's production-bound |
| Q8 | Which browsers and devices must be supported? | It sets the test matrix and responsive widths. | Current Chrome/Edge, desktop first, usable on a phone **(Rec)** · Mobile first · Specific list | always (quick) |
| Q9 | Are there export or reporting needs (CSV, PDF, scheduled email)? | They're easy to forget and change the data shape. | CSV export of every table **(Rec)** · PDF · None | always (quick) |
| Q10 | Is there any localisation, time zone or currency requirement? | Dates and period boundaries break quietly. | Show the user's local time and store UTC **(Rec)** · Fixed tenant time zone · Multi-language | if there are multi-region users |
| Q11 | Are there compliance or regulatory constraints (HIPAA, SOC 2, GDPR, data residency)? | They can veto storage locations or kinds of data. | None beyond org policy **(Rec)** · Named regime | if there's customer data or a regulated industry |
| Q12 | Which requirements are "demo only" and which are "real"? | Stops demo shortcuts from leaking into prod. | Demo data behind an explicit flag **(Rec)** · No demo mode | if K4 has a demo |
| Q13 | Is there a feature-flag or gradual-rollout need? | It lets unfinished features ship dark. | No flags, ship when done **(Rec)** · Flags per feature | if there are multiple parallel features |

---

## 4. Data architecture

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| D1 ★ | Which source systems or APIs feed each metric? (The coordinator lists the candidates, **validated live or from docs**, including alternative endpoints.) | Designing on an unvalidated API is the most common cause of rework. | Validated endpoint per metric, with alternatives noted **(Rec)** · User supplies a reference or HAR | always |
| D2 ★ | What's the refresh model: a scheduled collector writing a snapshot, or live calls from the UI? | It sets the backend shape, cost, rate-limit exposure and freshness. | One nightly collector feeds every page, plus an admin "refresh now" **(Rec)** · Live per page · Hybrid | always |
| D3 ★ | Which entity is the source of truth for each dataset, and who is the **single writer**? | Several writers cause races and clobbered data. | One collector writes, the UI only reads **(Rec)** · UI also writes (config only) | always |
| D4 ★ | What's the stable id for every entity? Do display names ever collide or change? | Keying by name is a latent collision bug. Always key by id and keep the name as a label. | Key by the source system's immutable id **(Rec)** · Composite key · Surrogate | always |
| D5 ★ | What history and retention is needed (tiers, how far back)? | It drives storage size, trend charts and cleanup jobs. | Tiered: 120 d daily → weekly to 6 mo → monthly, current + previous term **(Rec)** · Keep everything · Latest only | always |
| D6 | Where is it stored (platform data service, database, files), and why? | It fixes the query model, limits and the access model. | The platform's native data store **(Rec)** · External DB · Files/blob | unless docs state it |
| D7 | What volumes and API rate limits apply (calls per run, 429 behaviour, paging)? | It sets the batching, backoff and time budget of the collector. | Measure live: count calls, add backoff and a budget **(Rec)** · Assume generous limits | always, if an API is polled |
| D8 | Is a backfill of past data needed, and can the source provide it? | Some APIs lose history (deleted or renamed items), so capture early. | Backfill what the API retains, then snapshot forward **(Rec)** · Start empty | if trends are in P0 |
| D9 | How will schemas evolve (add-only columns, versioned payloads, migrations)? | Breaking changes wipe data or break older UIs. | Add-only fields plus a schema version field; reviewed payloads in the repo **(Rec)** · Migrations | always (quick) |
| D10 | Does any dataset contain PII or sensitive data? How is it minimised or masked? | It's a legal and security gate that affects storage and roles. | Store the minimum and mask in the UI by role **(Rec)** · No PII · Full PII with controls | if there's user or person data |
| D11 | Which audit fields go on every record (collectedAt, runId, source, writer)? | It enables diagnostics, dedupe and "how stale is this?" labels. | collectedAt + runId + sourceEndpoint on every row **(Rec)** · Minimal | always (quick) |
| D12 | How are deleted or renamed source items handled (keep, flag, drop)? | History shouldn't vanish when the source forgets. | Keep with a status flag (active/deleted), last name as label **(Rec)** · Drop | if the source can delete or rename |
| D13 | Is app configuration (thresholds, mappings) data or code, and where does it live? | Config in the data store can change without a redeploy. | Data store, admin-editable **(Rec)** · Assets/env vars · Code constants | if there are tunables |
| D14 | How are partial runs handled (some sources fail)? | It avoids half-written snapshots showing as truth. | Write per-source status and keep the last good data, flagged **(Rec)** · All-or-nothing | if there are several sources |
| D15 | Can demo or preview data be real-shaped (only fields the collector actually produces)? | Unreal demo data sets false expectations. | Real-shaped, made-up values only **(Rec)** · Anonymised copy of real data | if Q12 is yes |

---

## 5. Integration & access / security

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| S1 ★ | What's the auth model: user-delegated sign-in for the UI, app or service identity for background jobs? | It decides the token flow and what each caller can see. | UI uses user PKCE, collector uses an app (client-credential) identity **(Rec)** · All app · All user | always |
| S2 ★ | Which exact scopes does each identity need (least privilege, checked against each endpoint's documented scope)? | Broad scopes widen access. A missing scope looks like an RBAC problem. | Per-endpoint minimum scope list for review **(Rec)** · Broad admin scope | always |
| S3 ★ | Which roles and groups get access? Confirm the model: groups only, one role per group per level, no shared roles. | Stops privilege sprawl and keeps it auditable. | Local groups hold the roles, with directory groups nested in them **(Rec)** · Direct user grants | always |
| S4 ★ | Where do secrets live, who rotates them, and what happens after a deploy? | Leaked or overwritten secrets are the top ops incident. | Platform credential store, tracked in the package, user rotates after deploy **(Rec)** · Env/secret manager | always |
| S5 ★ | Where do writes happen, and who is allowed to write? | Least-privilege writes and the single writer (D3). | Collector identity only, with admin-only config edits **(Rec)** · Any signed-in user | always |
| S6 | How many external apps or identities may exist in total? Can we add new ones? | App sprawl creates untracked access. | Keep the existing ones and only add scopes; throwaway test apps get deleted **(Rec)** · New app per feature | if a new identity seems needed |
| S7 | What are the tenant or org boundaries? Can one deployment read several tenants? | Cross-tenant reads are an access-widening decision. | One org, several tenants read by the collector only **(Rec)** · Single tenant · Multi-org | if there are multi-tenant sources |
| S8 | What must be audited (who changed config, who triggered a refresh, access logs)? | It's needed for support and compliance. | Log admin actions with user + time **(Rec)** · Platform audit only | if there are write or admin actions |
| S9 | Quick STRIDE pass: spoofing, tampering, repudiation, info disclosure, DoS, elevation. Any concerns beyond the defaults? | A cheap early threat model catches the design flaws. | Coordinator drafts one line per letter, user confirms **(Rec)** · Full threat model | always (quick) |
| S10 | For testing APIs, may we use a throwaway app-scope client (deleted afterwards)? | It avoids testing with personal delegated tokens. | Yes: throwaway app, then delete and record it **(Rec)** · Use the existing app | before any live API validation |
| S11 | Where is each platform change recorded (apps, scopes, assets, roles, entities)? | An inventory avoids orphaned access. | Platform inventory doc + handoff log, same turn **(Rec)** | always (quick) |
| S12 | Is data egress allowed (exports, email, third-party services)? | Exports are data sharing. | Exports only for authorised roles, no third parties **(Rec)** · Unrestricted | if Q9 or notifications are in scope |
| S13 | Are there network constraints (IP allow-lists, CORS, redirect URIs)? | These cause deploy-day surprises. | Register the redirect URIs for each environment up front **(Rec)** · None | if there's a web app with OAuth |

---

## 6. GUI / interface

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| G1 ★ | Confirm the navigation and page inventory (landing pages, then detail pages, in order). | It's the build plan for the UI and one step per turn. | Coordinator drafts a sitemap from V2 **(Rec)** · User supplies | always |
| G2 ★ | What are the 3–5 key numbers or verdicts at the top of each page? | They're the page's reason to exist. Everything else supports them. | Draft per page per persona **(Rec)** · User supplies | always, per page |
| G3 ★ | Which drill-downs and cross-links are needed (landing → detail → source system)? | Dead ends kill analyst value. Links need ids (D4). | Every entity name links to its detail page and to the source system **(Rec)** · Detail only | always |
| G4 ★ | Should there be a demo or preview mode with realistic data, and how is it marked? | It enables demos before live data and safe screenshots. | Explicit toggle plus a visible "Demo data" badge, real-shaped (D15) **(Rec)** · None | always |
| G5 ★ | What are the responsive targets and the accessibility level? | Layouts break at mid widths, and accessibility is hard to retrofit. | 1280 / 900 / 420 px, WCAG 2.2 AA (contrast, keyboard, labels) **(Rec)** · Desktop only | always |
| G6 | What should the empty, loading, error and stale states say, and should they offer retry? | These are most of what users see on a bad day. | Skeletons, a plain-language empty state with next step, error with retry, "as of <time>" stamp **(Rec)** | always (quick) |
| G7 | Are there brand colours or a palette? Should category colours stay stable across pages? | Consistency builds trust, and unstable colours mislead. | Official brand palette, one colour function per category **(Rec)** · Neutral palette | always (quick) |
| G8 | Chart or table for each block, and which chart types? | Chart overuse hides the numbers. | Table first, with charts only for trends/shares **(Rec)** · Chart-heavy | per page |
| G9 | Which filters persist across pages (time range, tenant, unit), and in the URL? | Shareable, bookmarkable views help support. | Global filters in the URL query string **(Rec)** · Per-page only | if there are multiple filters |
| G10 | What time ranges are offered by default? | They must match the retention tiers (D5) and business periods. | Licence/business period + 7/30/90 d **(Rec)** · Custom picker | if there are trends |
| G11 | Are admin-only controls (refresh now, config) hidden or disabled for others? | Visible-but-forbidden controls cause confusion. | Hidden for non-admins **(Rec)** · Disabled with a tooltip | if there are admin actions |
| G12 | Do we need a guided tour or help panel for demos and onboarding? | It speeds adoption and makes demos repeatable. | A short tour per persona, matched to the demo script **(Rec)** · None | if K4 has a demo |
| G13 | What must each page tell the analyst about data freshness and gaps? | Silent staleness is worse than no data. | "As of" timestamp + source status link to the diagnostics page **(Rec)** | always (quick) |
| G14 | How is the persona switch placed and remembered? | It affects the header on small screens. | Header selector, remembered per browser **(Rec)** · Profile setting | if V5 = switch |

---

## 7. Planning & delivery

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| L1 ★ | What's the phasing: which slice ships first end to end? | A thin vertical slice proves data, auth and deploy early. | Data + one landing page end to end, then page by page **(Rec)** · Backend first · UI with demo data first | always |
| L2 ★ | What's the definition of done for a piece of work? | It gives one bar for every agent and turn. | Type check + unit tests + browser sweep at 3 widths + persona review + docs/board updated **(Rec)** · Lighter for POC | always |
| L3 ★ | What's the release flow: branching, tags, and how deploy is verified? | Stops shipping the wrong build and lets you roll back. | main = deployed (tag v<ver>), develop = integration; verify by the served build's content hash **(Rec)** · Trunk-based | always |
| L4 ★ | What needs the user's explicit OK (push, deploy, uninstall, scope change)? | Destructive and access-widening steps are gated (etiquette 5). | Push/deploy/uninstall/scope changes each need an OK with a commit list and secret scan **(Rec)** | always |
| L5 ★ | How is work tracked (board columns, where it lives), and how often is it updated? | A shared board keeps parallel agents and the user in sync. | Board in the repo docs: Next up · Planned · Waiting on user · Done, updated every request **(Rec)** · External tracker | always |
| L6 | What can run in parallel, and how many builders? | Too many builders cause merge conflicts. | Coordinator + at most 2 worktree builders + a build/check manager + read-only research **(Rec)** · Single agent | if there are 2 or more independent pieces |
| L7 | Should each builder get its own git worktree and branch, and how do they merge? | Isolation stops agents clobbering each other. | A worktree per builder, merged to develop by the coordinator after checks **(Rec)** · Shared tree | if L6 has more than one builder |
| L8 | What's the test strategy per layer? | It catches the right bugs at the right cost. | Build-mode type check (not a no-op), domain unit tests, integration against dev, browser sweeps **(Rec)** | always (quick) |
| L9 | How many pages or steps per turn before stopping for questions? | It paces the review with the user. | One page or roadmap step per turn, then stop **(Rec)** · Batch several | always (quick) |
| L10 | Does frontend-only work need a deploy, or is localhost enough? | It avoids needless deploys. | Localhost for UI-only, real deploy for backend/platform changes **(Rec)** | if there's a web UI |
| L11 | What's checked before every deploy (live version, assets, credentials inventory)? | Deploys can overwrite live config. | Capture live version + assets before; restore and test the credential after **(Rec)** | if deploys can overwrite config |
| L12 | What's the handoff package and log (what's copied, when, and the changelog)? | The handoff should reflect only shipped state. | Sync the handoff folder only after a verified deploy, and update its log **(Rec)** | if K11 is a handoff |
| L13 | What versioning scheme? | It links tags, packages and the changelog. | Date-based or SemVer, bumped from the live version **(Rec)** | always (quick) |

---

## 8. Operations & support

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| O1 ★ | Who supports it after go-live, and who gets alerted? | An unowned system rots. | Named team/person + a fallback **(Rec)** · The user for now | always |
| O2 ★ | How are collector or job failures detected and alerted (and to whom)? | Silent failures show stale data as truth. | Job-failure alert + a stale-data banner in the UI **(Rec)** · Manual checks | always |
| O3 ★ | Should there be an in-app diagnostics page (last run, per-source status, row counts, errors)? | It's the first stop for support and analysts. | Yes, admin-visible, linked from the "as of" stamps **(Rec)** · Logs only | always |
| O4 ★ | What time budget and job limits apply (max runtime, parallel jobs, API quotas)? | Stops runaway jobs and platform throttling. | Per-run time budget + a call cap, fail soft **(Rec)** · Unlimited | always, if there's a scheduled job |
| O5 ★ | What's the retry policy (what's retried, backoff, when it gives up)? | Transient errors shouldn't fail a night. Permanent ones shouldn't loop. | Retry 429/5xx with exponential backoff, 3 tries, then mark the source failed **(Rec)** | always, if there are API calls |
| O6 | Which runbooks are needed (rotate secret, rerun job, redeploy, restore data)? | Support can act without the builder. | The top 4 runbooks in the handoff docs **(Rec)** · None | if production-bound |
| O7 | What's logged, and for how long (without secrets or PII)? | Logs are needed to debug but can leak. | Structured logs with runId, no secrets or PII, platform retention **(Rec)** | always (quick) |
| O8 | Is there an SLO for freshness (e.g. data under 26 h old 95% of days)? | It turns "is it working" into something you can measure. | Freshness SLO on the snapshot **(Rec)** · None | if production-bound |
| O9 | How are platform changes (apps, scopes, entities) inventoried for support? | Support needs to know what exists. | Platform inventory doc kept current **(Rec)** | always (quick) |
| O10 | What's the recovery plan if data is corrupted or a deploy wipes something? | Uninstalls and redeploys can drop resources. | Snapshot or export before destructive deploys + a restore runbook **(Rec)** · Rebuild from source | if deploys are destructive |
| O11 | How do users report problems or request changes? | It closes the feedback loop. | A link on the diagnostics page to the owner or channel **(Rec)** · Ad hoc | if there are users beyond the builder |
| O12 | Are there known bugs deliberately deferred, and where are they tracked? | Deferred items get lost. | On the board with a date and the reason **(Rec)** | at every release |

---

## 9. Change / rule conflicts

Use this bank when new input contradicts an earlier decision, rule, memory or doc. Don't
override quietly. Quote both sides.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| C1 ★ | "On <date> we decided X (D-nnn). This new request implies Y. Which applies?" | Makes the conflict visible and puts the choice with the user. | Keep X and treat Y as an exception **(Rec when Y is one-off)** · Replace X with Y · Both, scoped | always, on conflict |
| C2 ★ | Is the change for this item only, or a new standing rule? | Stops one-off exceptions from becoming rules, and the reverse. | This item only **(Rec)** · New standing rule | always, on conflict |
| C3 ★ | What should happen to work already built under the old rule (retrofit now, later, or leave it)? | Rule changes create hidden debt. | Put retrofit on the board as Planned **(Rec)** · Retrofit now · Leave it | if built work is affected |
| C4 ★ | What changed that prompted this (new info, a stakeholder, a failed assumption)? | The reason is recorded with the decision and helps future conflicts. | Free text **(Rec)** | always, on conflict |
| C5 ★ | Does this change widen access, delete data or alter a deployed system? | That triggers the destructive/access gate (etiquette 5). | Needs an explicit OK before acting **(Rec)** | always, on conflict |
| C6 | Which docs, memory and agent instructions must be updated to match? | Stale rules in docs get re-applied by other agents. | Coordinator lists them and updates them in the same turn **(Rec)** | if C2 = new rule |
| C7 | Does this conflict with a vendor or platform constraint (not just our preference)? | Some "rules" are hard limits, and those need evidence, not a vote. | Verify against docs or live, then ask **(Rec)** | if it touches platform behaviour |

**Recording a rule change:** keep the old decision and mark it `Superseded by D-mmm (date)`. Add
the new decision with `Supersedes D-nnn` and the reason (C4). Never delete the old one.

---

## 10. Decision log format

One entry per answered question or batch. It lives in the project docs (for example
`docs/decisions.md`, or the Decisions section of the implementation-status board). Append only.

```markdown
### D-012 · 2026-09-26 · Refresh model
- Bank/Q: D2 (Data architecture)
- Decision: One nightly collector (01:00) feeds all pages; admin-only "Refresh now".
- Options offered: Nightly+manual (Recommended) · Live per page · Hybrid
- Chosen by: user (chat) · Status: Active
- Reason: API rate limits; freshness of <26 h is enough for all personas (Q3).
- Consequences: UI never calls source APIs; diagnostics page shows last run.
- Supersedes: — · Superseded by: —
- Assumptions (defaults taken, not asked): D7 measure limits live.
```

Rules:
- The date is absolute (YYYY-MM-DD) and the ID is sequential.
- `Status` is one of Active · Superseded · Reverted · Exception (scoped).
- Defaults taken without asking are logged as **Assumptions**, so the user can challenge them later.
- The phase summary (etiquette 10) links the D-IDs it covers.
