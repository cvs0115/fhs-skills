# UiPath platform add-on

How to build a UiPath app with this framework. The core playbook (`playbook/00`–`12`) stays the
process. This add-on adds what is specific to UiPath Automation Cloud: architecture options,
identities and scopes, RBAC, Data Fabric, jobs, the solution lifecycle, and the checklists and
gotchas that cost us days.

Everything here is written as a **best practice**: a short imperative rule, then **why** (what we
saw, the incident), then **check** (how to prove it). Sources are in
[`research/r4-uipath.md`](../research/r4-uipath.md); the evidence keys in brackets (`[F3]`, `[S12]`)
point there.

**Companion files**

| File | What it holds |
|---|---|
| [`uipath-cli-sdk-api.md`](uipath-cli-sdk-api.md) | UiPath skills map, `uip` CLI commands and gotchas, TypeScript SDK, API endpoint catalog |
| [`uipath-development-practices.md`](uipath-development-practices.md) | The day-to-day dev loops: Coded Web App, coded-workflow backend, Studio Web vs local, assets, testing, access during dev |
| [`../questions/platform-uipath.md`](../questions/platform-uipath.md) | UiPath question bank (IDs `U*`, 5 must-ask) |
| [`../research/r4-uipath.md`](../research/r4-uipath.md) | Source notes with citations |

**Placeholders used throughout:** `<App>` = the app's display name, `<app>` = its code-safe
kebab name, `{baseUrl}` = `https://api.uipath.com` (or your environment's `api.*` host), `{org}`,
`{tenant}`. No real org, tenant, id, key or secret appears in this file; keep it that way when you
copy it into a project.

---

## Contents

1. [Top 20 UiPath best practices](#1-top-20-uipath-best-practices)
2. [Featured pattern: the backend coded workflow as the app's own API](#2-featured-pattern-the-backend-coded-workflow-as-the-apps-own-api)
3. [Architecture](#3-architecture)
4. [Identities and scopes](#4-identities-and-scopes)
5. [RBAC](#5-rbac)
6. [Naming convention](#6-naming-convention)
7. [Data Fabric](#7-data-fabric)
8. [Jobs and collectors](#8-jobs-and-collectors)
9. [Coded Web Apps](#9-coded-web-apps)
10. [Solutions and Studio Web](#10-solutions-and-studio-web)
11. [Release checklist (UiPath)](#11-release-checklist-uipath)
12. [Platform inventory checklist](#12-platform-inventory-checklist)
13. [Testing (UiPath-specific)](#13-testing-uipath-specific)
14. [Platform findings](#14-platform-findings)
15. [Gotchas table](#15-gotchas-table)
16. [Building UiPath apps with coding agents](#16-building-uipath-apps-with-coding-agents)

---

## 1. Top 20 UiPath best practices

One line each; the link goes to the detail.

| # | Practice | Area |
|---|---|---|
| 1 | **Put privileged work behind a backend coded workflow that runs with application scope; the browser starts it as a job and reads its output.** It is your app's own API. | [§2](#2-featured-pattern-the-backend-coded-workflow-as-the-apps-own-api) |
| 2 | **Keep exactly two permanent external apps:** one user-scoped PKCE app for the web app, one app-scoped confidential app for the backend. Add scopes to these; delete throwaway test apps the same day. | [§4.1](#41-exactly-two-permanent-external-apps) |
| 3 | **`get` before every scope or redirect update; the update replaces the whole list.** | [§4.2](#42-scope-changes) |
| 4 | **Check each endpoint's own scope in the tenant's Swagger before diagnosing RBAC.** App-scope callers need the right scope, not a role. | [§4.3](#43-per-endpoint-scopes) |
| 5 | **Import directory groups by Identity id, never by name; verify the Orchestrator group Key equals the Identity id.** | [§5.2](#52-import-groups-by-identity-id) |
| 6 | **One role per group, grants to groups only, roles on local groups; nest Entra groups inside them.** | [§5.1](#51-the-rbac-model) |
| 7 | **Test access with a real Viewer account.** A direct Folder Administrator assignment on the developer masks every broken group grant. | [§5.4](#54-folder-administrator-masks-group-problems) |
| 8 | **Name every artifact `<App> - <Type> - <Item>`** (code-safe twin `<App>_<Type>_<Item>`). | [§6](#6-naming-convention) |
| 9 | **Check Data Fabric's default grants before granting any user write scope:** "Everyone" may already hold tenant-wide Data Writer. | [§7.2](#72-data-fabric-access) |
| 10 | **Treat the serverless job limit (~15 min) as a hard deadline:** budget to ~13 min, save progress per slice, chain follow-up runs. | [§8.2](#82-time-budgets-and-chaining) |
| 11 | **Log failures at Warn/Error, fault the job when every unit of work fails, and read the logs after every "Successful" run you rely on.** Errors logged at Info, a refusal, or an all-tenants failure all end green. | [§8.4](#84-logging-and-refusals) |
| 12 | **Start jobs one at a time and batch work inside a job;** concurrent starts time out reading the credential asset. Retry the credential read with backoff. | [§8.3](#83-concurrency-and-the-credential-asset) |
| 13 | **Give time triggers the Serverless runtime** (unless the folder has a connected unattended robot); a wrong runtime type fires and creates no job, silently. | [§8.5](#85-triggers) |
| 14 | **Ship the whole solution with `uip solution upload`, never components;** never run `uip codedapp deploy` on an app that lives in a solution. | [§10.1](#101-one-release-unit-one-lineage) |
| 15 | **Download fresh, overlay source plus a fresh `dist/`, upload, re-download and diff.** Studio Web can revert, and it serves the committed `dist/` as-is. | [§10.2](#102-the-upload-workflow) |
| 16 | **Sync the Studio Web `uipath.json` scope line on every upload;** the deployed app's sign-in scope comes from it, and the overlay doesn't copy it. | [§10.3](#103-files-studio-web-owns) |
| 17 | **Capture asset values before every deploy, keep the credential asset tracked, and test the credential with a job after it.** A deploy resets assets and can wipe the secret; untracking a resource deletes it on the next upgrade. | [§10.4](#104-deploys-reset-assets) |
| 18 | **Verify a deploy by the served bundle's content hash, never by version number.** | [§11](#11-release-checklist-uipath) |
| 19 | **Drive UiPath through the `uip` CLI and skills: the human runs `uip login`, the agent checks `uip login status`, uses `--output json`, never reads `~/.uipath/.auth` or hand-rolls REST where a command exists, and judges success by reading the artifact back.** | [§16](#16-building-uipath-apps-with-coding-agents) |
| 20 | **Upgrade CLI, tools and skills together, and enforce approval for `publish`, `deploy`, `upload` and `login` in permission rules, not only in prose.** Skills drifted from the CLI and called commands that no longer existed. | [§16](#16-building-uipath-apps-with-coding-agents) |

Two more that nearly made the list: **page every list call** (a fixed `skip=0` silently cut a
result at 200; the SDK returns one page by default) [§14](#14-platform-findings), and **key every
map by id, not display name** (two folders shared a name) [§7.4](#74-keys-and-ids).

Coding-agent practices are in [§16](#16-building-uipath-apps-with-coding-agents), from
[`research/r5-uipath-coding-agents.md`](../research/r5-uipath-coding-agents.md).

---

## 2. Featured pattern: the backend coded workflow as the app's own API

**Rule: the Coded Web App signs the user in with a narrow user scope and can do only what that user
may. Anything that needs broader or org-wide rights, or a trusted write, goes through one backend
coded workflow running under the app-scope external app. The browser "calls" it by starting a job
and reads the result.** [F1–F3, S1]

### 2.1 Why

- A signed-in viewer's token can't read the Licensing API, Identity or the org audit log, and in
  Orchestrator it sees only the tenants and folders the user is assigned to. Collection and
  privileged reads can't live in the browser. [ADW §1]
- Some endpoints don't answer browser calls from the portal host (CORS 405), and some portal
  routes need a portal session. A server-side job sidesteps both. [ARCH, HO]
- The browser must never hold the app credential. The job reads it from a credential asset users
  can't read.
- The job runs with nobody signed in too (nightly trigger), so the same code serves both.

### 2.2 Shape

```text
Browser (Coded Web App, PKCE user token: e.g. OR.Jobs, OR.Execution.Read, OR.Assets.Read, DataFabric.Data.Read)
  | start job: process = <app>-backend, folder = app folder, input = { Mode, ...JSON args, CorrelationId }
  | poll job state -> read output argument "Output" (JSON string)  or  read Data Fabric rows / a snapshot asset
  v
Backend coded workflow (C#, one Execute entry point, many modes)
  | reads the credential asset (retry with backoff) -> client-credentials token (app scope)
  | run gate: who started this job? (job record -> StartingUser / trigger / chain marker) -> roles on the app folder
  | dispatch on Mode -> validate input -> do the work within a time budget
  | write collected data (Data Fabric, snapshot assets) as the app identity; return { ok, reason?, code?, ... }
```

- **One entry point, many modes.** Examples of modes a collector ends up with: a nightly sync; one
  snapshot per area; history backfills that chain; roll-up and pruning; a config write; a
  request/approve flow. The `Mode` argument selects one.
- **Inputs:** plain strings, with JSON arrays/objects as strings (`FolderIdsJson`,
  `ChangeRequestJson`), a `CorrelationId`, and a run token for chained runs.
- **Outputs:** a single `Output` string argument holding JSON, or rows in Data Fabric the app reads
  next. Job output fields have platform size limits (see §14), so large results go to Data
  Fabric.

### 2.3 How to design one

| Design element | Practice |
|---|---|
| **Mode registry** | Keep every mode in one table: name, inputs, output shape, required role, time budget, what it writes. Unknown or empty mode → the strictest rule, never "allow". |
| **Contract per mode** | Document input/output as types on both sides (C# records, TypeScript types). Parse every optional input defensively: **omitted arguments arrive as `null`, not the C# default** [F21]. |
| **Server-side role policy per mode** | A hard-coded table (for example `RunPolicy.For(mode)` → roles that may start it by hand). The app only hides buttons; the job is the gate. |
| **Who started it** | Read the running job's own record: `CreatorUser`, `StartingScheduleId`, `StartingTriggerId`, folder. Trigger/schedule → allowed. Signed-in user → look up their roles on the app folder with `Folders/GetAllRolesForUser(username=…)?type=User`, which **includes group-derived roles** [F11]. Robot, other external app, no creator, job can't identify itself → refuse. A failed Orchestrator read **faults** the job; it never silently allows. |
| **Chained runs** | A follow-up run the backend starts itself carries a marker: an HMAC over the issue time keyed with the backend's own secret, valid for about an hour. A plain flag could be copied by any user with Jobs.Create. The marker only counts when the creator is not a signed-in user. |
| **Trusted writes** | Validate against one settings registry (ranges, types), write the row plus an audit row, record who started it. Server-set Data Fabric audit fields (`CreatedBy`/`UpdatedBy`) show the app identity, so store the starting user yourself. |
| **Idempotency** | Upsert by a unique record key; re-running a mode rewrites the same rows. Re-read the last few days each night for late data. |
| **Visible refusals** | A refusal ends the job **Successful** with output `{ ok:false, reason, code:"forbidden" }` and a **Warn** log line. The app must read the output and show the reason; it must not report "done". |
| **Tests** | Unit-test the policy table and the gate classification (schedule, chain marker valid/expired/replayed by a user, user with/without role, robot, unknown). Test the marker's HMAC and expiry. |

### 2.4 Trade-offs

| Cost | Detail | Mitigation |
|---|---|---|
| Latency | Measured 3–40 s per small run (median ~18 s) plus 0–2 s queue and polling | Snapshot-first pages; one job covers many items |
| Money | One serverless job per call (Robot Units per minute, by machine size) | Nightly sync feeds pages; admins get one "refresh now" |
| Time limit | ~15 min per serverless job | Time budget, slices, chaining (§8.2) |
| Concurrency | Concurrent starts timed out reading the credential asset | Start one at a time; batch inputs |
| Validation drift | Rules in C# and TypeScript | One registry source, shared fixtures |

**When to move off it:** small user-owned writes (settings, SLA windows, requests) can move to
direct Data Fabric saves from the browser, gated by Data Fabric entity/field roles, while
collection and privileged reads stay in the backend. See §3.3. [ADW]

---

## 3. Architecture

### 3.1 Reference options

| Option | Use when | Watch out |
|---|---|---|
| **A. Coded Web App + backend coded workflow + Data Fabric** (the reference) | The app shows data the user's own token can't read (licensing, cross-tenant, Identity, audit), or needs trusted writes | Job latency, serverless limit, credential handling (§2) |
| B. Coded Web App only, SDK calls with the user token | Every read is in the user's own tenant and folders, and every write is something the user may do anyway | The user's permissions apply; cross-tenant and org APIs are out of reach |
| C. Coded Web App + direct Data Fabric reads/writes + backend for collection | Collection is scheduled; user edits are small and owned by users | Needs Data Fabric roles as the security boundary (§7.2) |
| D. Maestro / Flow / API workflow / Coded Functions as the backend | Long-running orchestration, HITL, or a real HTTP endpoint for the app | Out of scope here; see the `uipath-maestro-*`, `uipath-api-workflow`, `uipath-functions` skills |

### 3.2 Live vs snapshot

**Rule: decide per data need, and write the decision down.** [mem:feedback_prefer_live_cheap_apis]

- **Store** history and aggregates the APIs can't give cheaply (job roll-ups over 90 days, license
  terms). Use tiered retention (for example daily 120 days, weekly to ~6 months, monthly after)
  and freeze months from dailies, never from weeks.
- **Read live** current state that one call answers for the selected scope, when the user's token
  can read it.
- Our final rule: **one nightly sync feeds every page**; pages say "Data as of …"; only admins get
  "refresh snapshot now"; for live operational status, **link to Orchestrator** instead of reading
  it in the app.
- Small snapshots can live in a Text asset, but Text assets cap at about 1M characters; move
  anything growing into Data Fabric.

### 3.3 App-direct Data Fabric writes vs collector jobs

| | Collector job per action | Browser writes Data Fabric directly |
|---|---|---|
| Latency | 5–40 s + polling | < 1 s |
| Cost | A serverless job per click | A few Data Fabric calls |
| Validation | Server-side, can't be bypassed through the app | TypeScript, bypassable with any token; Data Fabric field constraints and read-side checks are the backstop |
| Security | Role gate in the job | Data Fabric per-entity / per-field / record-owner roles |
| Audit | Writer-supplied "changed by" | Server-set `CreatedBy`/`UpdatedBy` (can't be forged) |
| Precondition | None | Remove "Everyone" Data Writer (or restrict per entity) first; add `DataFabric.Data.Write` user scope only after |

**Practice:** keep collection and privileged reads in the backend; move only user-owned rows
(settings, SLA windows, requests, append-only history) to direct writes, after the Data Fabric RBAC
is narrowed. Make history append-only (Create + Read, no Edit/Delete for any user role). [ADW]

---

## 4. Identities and scopes

### 4.1 Exactly two permanent external apps

**Rule: one user-scoped non-confidential app (PKCE) for the web app, one app-scoped confidential
app (client credentials) for the backend. New capabilities add scopes to one of these two. Only
throwaway test apps beyond that, deleted the same day.**

- **Why:** stale leftover registrations caused a multi-day persistent-403 hunt: the credential
  asset pointed at an old app with the wrong scopes. Two debug apps were found days after the
  session that made them. [mem:feedback_two_external_apps_only, INV]
- **Name them** `<App> - External App - Web App` / `- Collector` (state the user/app model).
- **Register redirect URIs with and without the trailing slash** for localhost and the hosted app
  URL. [S-skill coded-apps oauth-client-setup]
- **Check:** `uip admin external-apps list` shows exactly the two, plus nothing named "temp".

### 4.2 Scope changes

**Rule: `uip admin external-apps get <id>` first, then `update` with every existing scope plus the
new one (and `--redirect-uri` unchanged for the PKCE app). The update replaces the list.**

- **Why:** the update is a replace, not a merge; dropping a scope breaks every mode that needs it.
- **Also:** a client-credentials token request fails with **HTTP 400** if *any* requested scope is
  not granted. `OR.Execution` does not satisfy `OR.Execution.Read`; they are separate grants.
  Request each feature's scopes on **its own token** so one missing grant fails one mode, not all.
  [F6]
- **The web app's runtime scope is the `scope` line in `uipath.json`** (injected into the deployed
  app as the `uipath:scope` meta tag). Granting a scope on the external app is not enough; the app
  must request it. [F17]
- **Check:** `get` after the update; mint a token with the full scope list; run each mode once.

### 4.3 Per-endpoint scopes

**Rule: read the endpoint's own required scope in the tenant's OpenAPI spec
(`{baseUrl}/{org}/{tenant}/orchestrator_/openapi/public.json`, each operation's `description`)
before concluding "needs a role".**

- **Why:** two rounds of wrong "needs an RBAC grant" conclusions came from testing Folders and
  Users with only `OR.Execution`. With `OR.Folders.Read` / `OR.Users.Read` they returned 200 with
  zero role assignments. For app-scope callers the permission column of "permissions per
  endpoint" did not apply. [F4, F5]
- Use only the `automation-cloud` doc variants for a cloud tenant; `standalone` docs describe a
  different model.
- **Check:** `uip admin scopes list` for the catalog (Type 2 = usable as user **and** app scope).

### 4.4 Test with throwaway app-scope apps

**Rule: to learn what the backend can do, create a throwaway app-scope app with only the scopes
under test, check it has zero role assignments, mint a token, call the endpoint, then delete the
app and any temp files.** Never generalize from a delegated/browser token: it carries the human's
broad folder access. [mem:feedback_prefer_app_scope_over_delegated]

- A cross-folder Jobs query from a browser HAR looked like a URL trick; it was the human's own
  access. With a zero-access app token the same call 400s "A folder is required". [F8]

---

## 5. RBAC

### 5.1 The RBAC model

**Rule: every role belongs to exactly one group; grant to groups only, never to users; attach roles
only to the app's local groups; customers nest their Entra ID / AD groups inside those local
groups.** [mem:feedback_rbac_no_shared_roles]

- Groups: `<App> - Group - Viewers` / `- Power Users` / `- Admins`, each with its own folder role
  `<App> - Role - Viewer` / `- Power User` / `- Admin`, even when two roles are identical today.
- **Make the roles differ by a marker permission** so the app can tell them apart from
  `Users/GetCurrentPermissions` for the app folder (for example Logs.View on Power User and Admin
  only). A viewer's token has no group claim and can't list its groups. [F12]
- Least privilege: Viewer = Apps.View, Assets.View, Processes.View, Jobs.View, and Jobs.Create only
  while the app starts jobs for them.
- `AppVersions.View` is a tenant permission, not a folder one. `EntityRecords.*` / `EntitySchema.*`
  are folder permissions, so Orchestrator roles can't govern **tenant-level** entities; use Data
  Fabric roles for those. [F14]
- **Orchestrator ignores role renames** (PUT with a new name returns 200 and changes nothing). To
  rename: create, reassign, delete. [F15]

### 5.2 Import groups by Identity id

**Rule: import a directory group by its Identity id; then verify the Orchestrator DirectoryGroup
`Key` equals the Identity group id before assigning roles.**

- **Why:** groups imported **by name** created orphan Orchestrator records with newly generated
  keys that pointed at no Identity group. Every assignment looked right, but no member ever got a
  role. Signing out/in did not help (it isn't the membership cache). [F9, RG]
- **How:** `uip or users import --directory-id <identity-group-id> --type DirectoryGroup`, then
  assign the role. If that returns HTTP 500 (it did for us), use Orchestrator
  `POST /odata/Folders/UiPath.Server.Configuration.OData.AssignDomainUser` with the group's
  Identity id, the domain and the role; or import first and `roles assign` second (the one-step
  import with a folder assignment also returned 500).
- **Check (read-only):** `GET /odata/Users?$filter=Type eq 'DirectoryGroup'&$select=UserName,Key`
  vs `GET identity_/api/Group/{orgId}`. Then `GetAllRolesForUser(username='<member>')?type=User`
  shows the app role on the app folder with `Users[].Type = DirectoryGroup, IsInherited = true`.

### 5.3 Membership timing and nesting

- Group membership changes apply at the user's **next login**, or within **1 hour** for an active
  session. [S9]
- Identity's data calls (`User.groupIDs`, `Group` members, `CheckMembers`) show **direct local
  membership only**; members of an Entra group nested in a local group don't appear there.
  Orchestrator's own role resolution (`GetAllRolesForUser`, `GetCurrentPermissions`) is the check
  that matters; still **test once with a nested Entra group** before relying on it. [F13, AC]

### 5.4 Folder Administrator masks group problems

**Rule: test every role with a dedicated account that holds only that group membership.**

- **Why:** the developer was a direct Folder Administrator on the app folder. They passed every
  check through that role while all three group grants were broken. A direct user assignment also
  breaks the groups-only rule for a customer install. Folder roles inherit down to subfolders and
  can't be removed below. [RG, S10]
- **Check:** `uip or users list-in-folder --folder-key <key> --include-inherited`; flag any
  DirectoryUser row.

### 5.5 Detecting org or tenant admins

- Tokens carry **no admin, role or group claim**. `GetCurrentPermissions` over-reports if a broad
  group (for example "Everyone") holds Orchestrator Administrator in the tenant. `GetCurrentUser`
  RolesList shows direct roles only. The PDP `geteffectiveaccess` is 403 for apps and has no
  external-app scope. [AC]
- Best option found: with the user's own token, `GET identity_/api/Group/{orgId}` once per session
  (200 = org admin, 403 = not); needs the **PM.Group.Read user scope**. Unverified for non-admins
  and Entra-only admins; test before relying on it. Explicit Tenant Administrator holders are
  readable only from the PAP (`pap_/api/userroleassignments`) with an app token. [AC]
- Licensing roles: **License Viewer** (org or tenant) = read-only licensing pages; **License
  Administrator** (org) = same licensing rights as an org admin. [S8]

---

## 6. Naming convention

**Rule: name every artifact the app owns `<App> - <Type> - <Item>`; where spaces or dashes aren't
allowed, use the code-safe twin `<App>_<Type>_<Item>` with the same words.** `<Type>` ∈ Asset,
Entity, Trigger, Group, Role, External App. [mem:feedback_naming_convention]

| Artifact | Example |
|---|---|
| Solution / web app / backend process | `<app>` / `<app>-frontend` / `<app>-backend` (technical names, kebab) |
| Folder | `Shared/<app>` |
| Asset | `<App> - Asset - Collector Credential`, `<App> - Asset - Snapshot` |
| Entity (logical / display) | `<App>_Entity_Data` / `<App> - Entity - Data` |
| Trigger | `<App> - Trigger - Daily Sync` |
| Group / role | `<App> - Group - Viewers` / `<App> - Role - Viewer` |
| External app | `<App> - External App - Web App`, `<App> - External App - Collector` |

- **Why:** anyone browsing Assets, Roles, Entities or External Apps sees at once what belongs to the
  app, and audits read cleanly.
- Data Fabric **entity logical names are immutable** (letters, digits, underscores); only the
  display name and description can change. Field names: letters and digits only. Reserved field
  names: `Id`, `CreatedBy`, `CreateTime`, `UpdatedBy`, `UpdateTime`, `RecordOwner` (we had to use
  `ChangedBy`). [S-skill DF Rule 4]
- A rename of linked artifacts (assets named in code, trigger inputs, entity names in both apps)
  ships as **one coordinated change at a deploy**. Verify the artifact type accepts spaces and
  dashes before relying on it.

---

## 7. Data Fabric

### 7.1 Entities, fields, choice sets, files

- **Tenant-level vs folder-level entity** is a decision (U-bank). Tenant-level entities are
  governed only by Data Fabric roles; folder-level ones also by Orchestrator folder permissions.
- **Schema changes via reviewed payload files** in the repo (`deployment/data-fabric/*.json`),
  applied with `uip df entities create/update`, previewed and approved first. `addFields` entries
  use `name`, not `fieldName`. [INV]
- **Avoid the UI-broken types** (`INTEGER`, `BIG_INTEGER`, `FLOAT`, `DOUBLE`, `UUID`, `DATETIME`);
  they're accepted by the API but render broken in the UI. [S-skill DF Rule 12b]
- **Long text:** `MULTILINE_TEXT` returned a 10,000-char value in full from a query;
  `MULTILINE_MAX` returns only a preview from list/query (full only via `get`), and echoing a
  preview back in an update destroys the content. Split big payloads into ≤10k parts with a
  `Part`/`PartCount`. [F24, S-skill DF Rule 21]
- **Choice sets:** values are immutable integer `NumberId`s, not labels; filter and write with the
  ids.
- **FILE fields:** never put a FILE key in `records insert/update/import`; it is **silently
  stripped and the call returns Success**. Use `uip df files upload/download/delete` (or the SDK
  file calls). [S-skill DF Rule 6]
- Entity descriptions are limited to 512 characters; a corrupted character in a stored description
  made an update return 500 until the description was re-sent clean. [F25]

### 7.2 Data Fabric access

**Rule: before granting any user a Data Fabric write scope, read the tenant's Data Fabric role
assignments. If "Everyone" holds Data Writer, the user scope `DataFabric.Data.Write` lets every
signed-in user write every entity.**

- Documented default: "Everyone" gets **Data Reader** (organization users can read data). We found
  a tenant where "Everyone" also held **Data Writer**, tenant-wide. The Web App's write scope was
  added and reverted the same day. [S5, INV]
- System roles: Administrator (permissions only, no data), Designer (schema), Data Writer (all
  entities read/write), Data Reader (all entities read). Custom roles add **per-entity**
  Create/Read/Edit/Delete, **per-field** access (field RBAC on), and **record-owner** levels
  ("Edit/Delete own"). Grant to groups, one custom role per group. [S5]
- User-scoped Data Fabric scopes are "restricted to user's permissions"; app-scope writes by the
  backend are the only writer of collected data.
- `uip df` has no access commands; entity access is set in the Data Fabric UI (Manage Access).
  Record every grant in the inventory.

### 7.3 Server-set fields and limits

- `CreatedBy` / `UpdatedBy` / `RecordOwner` are principal ids set by the server, plus `CreateTime`
  / `UpdateTime`; not writable. They make a stronger audit trail than a writer-supplied field, but
  a backend write shows the backend's identity. [ADW, S-skill SDK DF]
- A duplicate unique-key insert returns **HTTP 400** ("Value uniqueness violation … 2627"), **not
  409**. [F24]
- Limits: **5,000 API calls/min per tenant**; a daily call quota per Data Fabric unit; a query
  reads up to 1,000 records per call; batch writes ~1,000 rows per call. Budget the nightly writes
  against the daily quota. [S6, S7]
- Rows come back under a lowercase `value` next to `totalRecordCount`; empty fields are omitted.

### 7.4 Keys and ids

**Rule: key every map, grouping and drill-down by the real id; keep the name only as a label.**

- **Why:** two production folders shared one display name; name-keyed code merged them.
  [mem:feedback_always_key_by_id_not_name]
- Id spaces differ: the Licensing `folderKey` is the Orchestrator folder **Key** (GUID) while many
  OData calls use the numeric folder **Id**; the Licensing `processKey` is the Orchestrator
  **Release.Key**. Some APIs return GUIDs uppercase and others lowercase: **join
  case-insensitively**. [F19]

---

## 8. Jobs and collectors

### 8.1 Entry point

- The coded workflow's `Execute(...)` signature **is** the job's argument contract. Optional
  arguments arrive as `null` when omitted (the deployed schema marks them required); parse
  defensively. [F21]
- Folder-scoped calls need `X-UIPATH-OrganizationUnitId` (numeric id) or `X-UIPATH-FolderKey`
  (GUID). Prefer the key: it survives a redeploy into a recreated folder.

### 8.2 Time budgets and chaining

**Rule: serverless jobs end at about 15 minutes ("reached the time limit"). Work to a ~13-minute
deadline, check the time left before each slice, save progress per slice, and let the next run
resume (or chain a follow-up run).** [S2, F22]

- **Why:** a 30-minute backfill budget ran inside a 15-minute job; the job was killed mid-tenant and
  that tenant got nothing.
- Order work newest-first and breadth-first (every tenant's last 30 days before anyone's older
  data) so a cut-off run still leaves useful data.
- Chained runs need `OR.Jobs.Write` on the backend app and a verifiable marker (§2.3).

### 8.3 Concurrency and the credential asset

**Rule: start jobs one at a time; batch items inside one job with bounded parallelism (~6); retry
the credential read with backoff.**

- **Why:** concurrent job starts timed out in the robot's own `GetRobotCredential` ("Asset
  Operation Timeout"), faulting ~3% of serverless jobs 2–4 s in, before any of our code ran. A
  2 s / 4 s / 8 s retry cleared it. [F23]
- Orchestrator rate-limits: `GET /odata/Jobs` is limited per tenant per minute and bursts return
  **429 with `Retry-After`**; honor it. Per-folder loops over hundreds of folders take minutes.
  [S3, F7]

### 8.4 Logging and refusals

**Rule: log per-item failures at Warn, whole-step failures at Error, and fault the job when a step
fails for every item. After any run you rely on, read its logs, not just its state.**

- **Why:** a backfill ended **Successful** with every tenant failing (12× token 400), because the
  collector logged its own errors at Info. A credential test job ended Successful because the run
  gate had refused it before the credential was used. [CW #4, r1 §5.1]
- `uip or jobs logs <job-key> --level Warning` (the folder is inferred from the job key; there is
  no `--folder-key`).
- Never log tokens, secrets, response bodies or credential values.

### 8.5 Triggers

**Rule: give time triggers the Serverless runtime unless the folder has a connected unattended
robot, and check the next morning that the trigger created a job.**

- **Why:** a time trigger on the Unattended runtime in a folder with no connected unattended robot
  fired for weeks and created **no job**, and nothing reported it. [F20]
- **Don't track triggers as solution resources:** `resources add --kind Trigger` created a
  duplicate process/package pair the CLI couldn't remove. Create them with `uip or triggers
  create` after each fresh deploy, and list the command and inputs in the install steps. [HO]
- `triggers update` can't change input arguments: recreate the trigger. `triggers create` derives
  the folder from `--release-key`. For time zone we had to pass a Windows id
  (`Eastern Standard Time`) though the CLI help says IANA: test in your tenant. [F20]
- Reading triggers: `GET /odata/ProcessSchedules` per folder (`OR.Jobs.Read`); time triggers are
  `QueueDefinitionId eq null`; `StartProcessNextOccurrence` is computed for you.

---

## 9. Coded Web Apps

Short list; the full dev loop is in
[`uipath-development-practices.md`](uipath-development-practices.md#1-coded-web-app-dev-loop).

- **Base URL is the `api.*` host** (`https://api.uipath.com`), not `cloud.uipath.com`. CORS works on
  `api.*` for Orchestrator, Data Fabric, `identity_`, `orgaudit_`, `license_`, `lease_`; the old
  "Licensing has no CORS" finding was the **portal host**. [F16]
- **Runtime config comes from meta tags** the platform injects (`uipath:scope`,
  `uipath:folder-key`, `uipath:client-id` …). Read the folder from `uipath:folder-key` so a redeploy
  to a new folder needs no rebuild; keep `.env` values as the localhost fallback only. `VITE_*`
  values are baked at build time. [F17, HO]
- Compute `redirectUri` from `window.location` (origin + path) instead of a baked value.
- `vite.config.ts` uses `base: './'`; import static assets through the bundler; build runtime URLs
  with `getAppBase()`. [S-skill coded-apps]
- The SDK keeps the token in **sessionStorage**; each new tab or test run signs in again.
- Open apps need **Apps.View** on the folder the app is deployed in.

---

## 10. Solutions and Studio Web

### 10.1 One release unit, one lineage

**Rule: ship the whole solution. Never run `uip codedapp pack/publish/deploy` on an app that is an
AppV2 project in a solution.**

- **Why:** a standalone `codedapp` registration and the solution's AppV2 app were two separate
  lineages for the same path; the standalone one never owned the live URL, and forcing it would
  have created a duplicate app. `uip codedapp validate --path-name <path>` shows which app holds a
  path. [F18]
- Upgrade existing deployments in place; don't deploy a new folder or app.

### 10.2 The upload workflow

1. `uip solution download <solution-id> --destination <scratch> --extract` into a scratch folder,
   never the repo.
2. **Check it wasn't reverted** (project names, assets, recent code). Studio Web had silently gone
   back to an old pre-rename version once. If reverted: stop and ask. [F26]
3. Build fresh (`npm run build`), overlay app `src/` + **fresh `dist/`** + build config, and the
   backend source folders. Keep Studio Web's `project.json`, `project.uiproj`, `uipath.json`,
   `.codedworkflows/`, `.local/` (but sync the `uipath.json` scope line, §10.3).
4. `diff -rq` every overlaid folder.
5. `uip solution resources refresh` (from the solution folder; it takes no path argument, use
   `--solution-folder`), then `uip solution upload .`. Confirm `Action: Overwritten` and
   `SnapshotCreated: true` (a restorable pre-overwrite snapshot).
6. **Re-download and diff** again; check the `dist/index.html` script hash.
7. Deploy: the user deploys from Studio Web, or the CLI chain `uip solution pack . -v <ver> -n
   <package-name>` → `publish` → `deploy upgrade <deployment-key> --version <ver>` (in-place,
   keeps config). Pass `-n` explicitly (pack defaults to the folder name); the version must exceed
   the live `LatestVersion`.

`upload` alone updates only Studio Web's design-time copy; nothing runs until a deploy. `upload`
lands in the **Cloud workspace** tab, not Local.

### 10.3 Files Studio Web owns

- **`uipath.json`'s `scope` line becomes the deployed app's sign-in scope.** The overlay keeps
  Studio Web's file, so sync that one line on every upload. Missing it shipped an app without a
  scope it needed. [F17]
- Studio Web computes the next version from the local `project.json`; check the live Orchestrator
  version before bumping. [mem:feedback_check_version_before_push]
- `.uipx` `Projects[].Id` is the DesignId, not the Studio Web project id that `codedapp push/pull`
  need (that one is in `upload`'s response `Data.Response.Projects[].Id`). [HO]
- Never hand-edit `resources/solution_folder/`; `projects import` copies `node_modules`, `.env`,
  caches and `.uipath/` verbatim: clean them before upload.

### 10.4 Deploys reset assets

**Rule: capture every text asset's value before an upload; after the deploy, test the credential
with a short job; then restore the captured values (or regenerate them).**

- **Why:** a deploy reset both snapshot assets to `{}` and, on some deploys, overwrote the
  credential asset so every job failed with "Token acquisition failed with HTTP 400" until the
  secret was re-entered. Orchestrator never returns a credential's secret, so only a job proves
  it. [F27]
- **Keep the credential asset tracked** in the solution. Untracking it to "protect" it made the next
  upgrade **delete** it. Treat untracking any live resource as a delete. [F28]
- New assets: create them in the personal workspace (`uip or assets create`), import into the
  downloaded solution (`uip solution resources add --source remote --kind Asset --name … --cloud-key
  …`), upload; the user deploys. App settings belong in a Data Fabric configuration entity, not
  assets. [mem:feedback_solution_assets_via_workspace]
- A credential asset can point at the wrong external app, and you can't read it back. When a scope
  fix doesn't take effect, test which app the running credential really is. [F10]
- `uip or assets update --name` 400s on credential assets ("user name cannot be null"); rename in
  the UI.

---

## 11. Release checklist (UiPath)

Extends the generic [`templates/release-checklist.md`](../templates/release-checklist.md).

*Before*
- [ ] Everything merged on `develop`; real type-check (`tsc -b`), all suites, conflict-marker grep.
- [ ] Live version queried (`uip solution deploy list --limit 200 --output-filter …`); new version strictly greater.
- [ ] Captured: text asset values (scratchpad), trigger name/cron/runtime/inputs, folder role assignments, external app scopes and redirects. Credential: name only.
- [ ] Fresh Studio Web download; not reverted.
- [ ] Fresh `npm run build`; local `dist/index.html` bundle hash recorded.
- [ ] Overlay src + dist + backend; `uipath.json` scope line synced; `diff -rq` clean.
- [ ] `resources refresh`; credential still tracked; no trigger tracked.

*Upload and deploy*
- [ ] `uip solution upload .` → Overwritten + SnapshotCreated; re-download and diff.
- [ ] **The user deploys** (or approves the `pack → publish → deploy upgrade` chain). Agents never deploy on their own.

*After*
- [ ] Deployment `Active` at the new version; **served `index-<hash>.js` = local hash** (`curl` the app URL, grep the script tag).
- [ ] Credential re-entered if needed; a short test job **Successful and its logs show the token was acquired**.
- [ ] Captured asset values restored (or snapshots regenerated by a run).
- [ ] One run of each changed mode; data it wrote checked.
- [ ] Trigger exists, right runtime, right inputs; next morning, the scheduled run created a job.
- [ ] Group Keys = Identity ids; a Viewer test account is refused an admin action.
- [ ] Inventory + handoff change log updated; `develop` → `main`, tag `v<version>`, push after commit list + secret scan + user OK.

---

## 12. Platform inventory checklist

Keep `docs/platform-inventory.md` as the tracked source of truth (template:
[`templates/platform-inventory.md`](../templates/platform-inventory.md)); read live state back with
`uip` before writing it; copy it into the handoff at each sync. For the customer copy, strip ids.

| Section | Record |
|---|---|
| Folder | Path, key, numeric id; solution id; process name, version, release key; app URL |
| External apps | Name, id, type (PKCE / confidential), full scope list, redirect URIs |
| Assets | Name, type, key; who writes it; "deploy resets it" note; credential = name only |
| Triggers | Name, type, cron, time zone, runtime type, input arguments, enabled |
| Data Fabric | Entity logical + display name, id, level (tenant/folder), fields, who reads/writes; Data Fabric role grants per group, and the "Everyone" defaults |
| Identity | Local groups (Identity id **and** Orchestrator Key, must match), nested directory groups, members if relevant |
| Roles | Folder/tenant role name, key, permissions, the one group it's assigned to |
| Change log | Dated line per change: what, why, who approved, how verified |

---

## 13. Testing (UiPath-specific)

Generic browser testing (Playwright, widths, sweeps, persona × page) lives in
[`playbook/10-verify.md`](../playbook/10-verify.md),
[`agents/gui-tester.md`](../agents/gui-tester.md) and
[`templates/gui-test-script.md`](../templates/gui-test-script.md). UiPath adds:

- **Sign-in:** the app's "Sign in" button redirects to the UiPath login page; pick the tenant's IdP
  ("Continue with Microsoft" or the SSO button) and the agreed test account. Never type a password;
  on a password or MFA prompt, stop and ask the user to sign in once in a headed run, and reuse that
  persistent browser profile.
- **Tokens live in sessionStorage,** so every scripted run clicks Sign in again (the SSO session in
  the profile makes it silent).
- **Deployed app URL shape:** `https://{org-subdomain}.uipath.host/<app-path>/` (routing name from
  the deployment); localhost is `http://localhost:5173` against the real tenant.
- **Preview/demo mode** (`?demo`, `?preview=…`) with real-shaped fixtures, so testers and demos work
  without tenant data; fixtures may only contain fields the backend really produces.
- **Verify the served bundle hash** before testing a deploy; otherwise you test old code.
- **Never click actions that start backend jobs or write data on a live tenant** unless the test
  plan says so and the user approved it; use preview mode or read-only pages.
- **Role tests need real accounts** per group (§5.4); a developer account hides refusals.

---

## 14. Platform findings

What we observed on Automation Cloud, how we proved it, and what to do. "Live" = tested against a
real tenant with a throwaway app-scope token or the user's CLI token; "docs" = docs.uipath.com;
"unverified" = not proven. Full evidence per id in [`research/r4-uipath.md`](../research/r4-uipath.md).

### Identities & scopes

| Id | Finding | Proved by | Do |
|---|---|---|---|
| F4 | Each Orchestrator resource needs its own OAuth scope (`OR.Folders.Read`, `OR.Users.Read`, `OR.Jobs.Read`, `OR.Execution(.Read)`, `OR.Robots.Read`, `OR.Machines.Read`, `OR.Settings.Read`, `OR.License.Read`, `OR.Assets`) | Live, per-operation descriptions in the tenant OpenAPI spec | Look up each endpoint's scope; request only those |
| F5 | App-scope callers with the right scope need **no** folder or tenant role for Releases/Folders/Users/Jobs reads | Live: zero role assignments checked first, 200s | Don't create roles for the backend; fix the scope |
| F6 | A token request with any ungranted scope fails with 400; `OR.Execution` ≠ `OR.Execution.Read` | Live | One token per feature; grant exact names |
| F10 | A credential asset can silently target an old external app; its secret and username can't be read back | Live incident; fixed by re-entering the value | Test the credential with a job; delete stale apps |
| F12 | Tokens carry no role/group/admin claim; a viewer can't list its own groups | Live, decoded token (claims only) | Detect roles via `GetCurrentPermissions` on the app folder |
| F16 | CORS: `api.*` host allows `*` for Orchestrator, Data Fabric, `identity_`, `orgaudit_`, `license_`, `lease_`, `portal_` consumption routes; the portal host returns 405/403 on preflight | Live preflights | Always use the `api.*` base URL |
| F29 | Raw REST calls without a `User-Agent` header got a 403 HTML page | Live (urllib) | Set a User-Agent in scripts and HttpClients |
| F30 | `DataFabric.Data.Write`, `PM.License.Read`, `PM.User.Read`, `PM.Group.Read`, `PM.Audit.Read`, `OR.License.Read`, `OR.Settings.Read` exist as user **and** app scopes | `uip admin scopes list` | Check the catalog before designing a flow |

### RBAC & Identity

| Id | Finding | Proved by | Do |
|---|---|---|---|
| F9 | Importing a directory group by name created orphan DirectoryGroup records (Key ≠ Identity id); no member got roles | Live: Identity 404 for the Orchestrator keys; fixed by re-adding by id | Import by id; verify Key = id |
| F11 | `GetAllRolesForUser(username=…)?type=User` includes group-derived roles (`IsInherited=true`, `Type=DirectoryGroup`); `type` names the principal kind, not "direct only" | Live | Use it as the server-side role authority |
| F13 | Identity `groupIDs`, group members and `CheckMembers` show direct local membership only; nested Entra members don't appear | Live (0 hits among known Entra-nested users) + docs (Entra evaluated via Graph) | Don't build role checks on Identity membership data |
| F31 | A broad group (e.g. "everyone") can hold Orchestrator Administrator, so `GetCurrentPermissions` without a folder shows admin rights for every user | Live | Check permissions on the **app folder**, with a marker permission |
| F32 | PDP `geteffectiveaccess` returns 403 for app tokens and has no external-app scope; PAP `userroleassignments` works with an app token (exact scope undocumented) | Live | Use PAP from the backend for explicit Tenant Administrator holders |
| F33 | Identity `GET identity_/api/Group/{orgId}` with a user token: 200 for an org admin; non-admin 403 **unverified** | Live (admin only) | Test with a non-admin and an Entra-only admin first |
| F14 | `AppVersions.View` is tenant-level; `EntityRecords.*`/`EntitySchema.*` are folder permissions | Live, role editor | Tenant-level entities need Data Fabric roles |
| F15 | Orchestrator ignores role renames | Live (200, no change) | Create → reassign → delete |
| S9 | Group membership applies at next login or within 1 h | Docs | Ask testers to sign out/in after membership changes |

### Orchestrator data

| Id | Finding | Proved by | Do |
|---|---|---|---|
| F7 | `/odata/Jobs` per folder returns 429 under bursts; `Retry-After` is honored; docs: 100 req/min/tenant for non-automation GET Jobs, 1,000 for automation | Live + docs | Sequential per tenant, retry on 429, spacing ~400 ms |
| F8 | Releases/Jobs/Robots/Sessions are folder-scoped: 400 "A folder is required" without a folder header, even via the GUID URL form | Live | Loop per folder id; a zero-access app token sees no union |
| F34 | Jobs keeps `ProcessType` and an embedded Release snapshot after the Release is deleted or renamed; Releases shows only current state and exposes `IsProcessDeleted` | Live | Use Jobs as history fallback (bounded); Releases for Active/Inactive |
| F35 | Tenant-wide calls exist for some needs: `Sessions/GetMachineSessionRuntimes`, `LicensesRuntime`, `/odata/Machines`, `Folders`, `Users`; `Settings/GetLicense` gives per-tenant robot allocation (Allowed) and in-use (Used) | Live across tenants | Prefer tenant-wide functions over per-folder loops |
| F36 | Folder assignments: `GetRuntimesForFolder`, `GetMachinesForFolder` (returns every machine; filter `IsAssignedToFolder or IsInherited`), `GetUsersForFolder(includeInherited=true)` | Live | Filter server-side |
| F37 | `api/stats/GetLicenseStats` and `FoldersNavigation/GetFolderContext` are 403 for app tokens regardless of scope | Live | Don't build on them |
| F38 | One org-level token reaches each tenant's Orchestrator at `/{org}/{tenantName}/orchestrator_`; a user token only where the user is assigned | Live | One backend token for all tenants |
| F39 | Paging: a fixed `skip=0` silently cut results at the page size (200); the SDK returns one server-capped page from `getAll()` | Live incident + SDK docs | Loop `totalCount`/cursor; test the full-page-then-short-page case |
| S3 | Job output argument limit ~51,200 chars; `$top` max 100 on some OData queries | Docs (rate-limits page) | Put large results in Data Fabric |

### Licensing & Insights

| Id | Finding | Proved by | Do |
|---|---|---|---|
| F40 | Per-tenant license allocation is reachable with an app token at `portal_/api/consumption-dashboard/tenant-dashboard-summary-by-tenant`; `organization-dashboard` and other portal routes need a portal session | Live, 3× | Test each endpoint; never generalize from a URL prefix |
| F41 | `consumption-summary` `includeAllocation` returns only an org-wide figure | Docs + live | Don't use it for per-tenant allocation |
| F42 | `tenant-process-consumption-breakdown` with `aggregateByOwnership=false` = flat "by execution" rows; `true` nests sub-processes; the flag is a no-op on the folder breakdown; no owner field either way | Live HAR diff | Read the flag's meaning before inventing a feature |
| F43 | `tenant-consumption-breakdown` returns a day-by-day series for any range in one call, optionally scoped by `folderKeys` | Live | Replace day-by-day loops |
| F44 | Licensing date bodies use UTC **Unix seconds**; paths need the `/{orgName}/` segment | Live | Encode it in the client |
| F45 | Licensing endpoints with a user token return 403 at the gateway without PM.License; docs: licensing pages need org admin, License Administrator or License Viewer | Live + docs | Keep licensing reads in the backend |
| F46 | Insights has Robot Licenses dashboards but **no documented API**; only Real-Time Data Export | Docs + skill | Don't promise it as a data source |
| F47 | Some consumables shown in the portal (e.g. API calls, semantic selectors) are absent from `license-summary` | Live | Label them "not available" |

### Data Fabric

| Id | Finding | Proved by | Do |
|---|---|---|---|
| S5 | "Everyone" gets Data Reader by default; a tenant can also give it Data Writer | Docs + live | Read the grants before adding write scopes |
| F24 | Duplicate unique key → 400 (SQL 2627), not 409; MULTILINE_TEXT returns 10k chars in full | Live | Handle 400 as "exists" |
| S-DF6 | FILE values in record writes are stripped silently (Success) | Skill docs | Use the files API |
| ADW | `CreatedBy`/`UpdatedBy`/`RecordOwner` are server-set principal ids | Live rows + SDK docs | Use them as audit truth |
| S6 | 5,000 calls/min per tenant; daily quota per unit; query ≤ 1,000 records | Docs | Budget nightly writes |

### Jobs, triggers, deploys

| Id | Finding | Proved by | Do |
|---|---|---|---|
| S2 | Serverless jobs stop at 15 min | Docs + live kills | ~13-min budget, chain |
| F20 | A time trigger on the wrong runtime type fires and creates no job, with no alert | Live (no jobs for ~12 days) | Serverless runtime; next-morning check |
| F21 | Omitted optional entry-point arguments bind as `null` | Live | Parse defensively |
| F22 | Serverless small runs: 0–2 s queue, 3–40 s run; RU billed per minute by size | Live + docs | Snapshot-first UX |
| F23 | `GetRobotCredential` "Asset Operation Timeout" on ~3% of serverless jobs, worse with concurrent starts | Live (16 of 500 jobs) | Retry 2/4/8 s; sequential starts |
| F26 | Studio Web can revert a solution to an older version | Live | Download, check, then overlay |
| F27 | A deploy resets text assets to `{}` and may overwrite the credential | Live, several deploys | Capture → deploy → test → restore |
| F28 | Removing a resource from the solution deletes it on the next upgrade | Live incident | Never untrack live resources |
| F18 | Studio Web serves the committed `dist/`; it does not rebuild from `src/` | Live, 3 deploys same hash | Build and overlay `dist/` |

---

## 15. Gotchas table

| Incident | Rule |
|---|---|
| Groups imported by name; Keys didn't exist in Identity; nobody got a role for two days | Import by Identity id; verify Key = id |
| Developer passed every access check through a direct Folder Administrator role | Test with a Viewer-only account; groups only |
| Persistent 403s: the credential asset pointed at a stale external app | Two permanent apps; test the credential with a job |
| Scope "fix" didn't work: tested with `OR.Execution` only | Read each endpoint's scope in the tenant OpenAPI spec |
| Token 400 in every tenant: `OR.Execution.Read` requested, only `OR.Execution` granted | Grant exact scope names; one token per feature |
| Scope update dropped existing scopes | `get` first; send the full list |
| Deployed app lacked a scope: Studio Web `uipath.json` scope line not synced | Sync the scope line on every upload |
| Version bumped 3×, live bundle unchanged: stale committed `dist/` | Build and overlay `dist/`; verify by hash |
| Studio Web reverted to an old version | Download fresh and check before overlaying |
| Deploy reset snapshots to `{}` and wiped the credential secret | Capture, deploy, test with a job, restore |
| Untracked credential asset was deleted by the next upgrade | Keep it tracked; untracking = delete |
| Trigger tracked in the solution → undeletable duplicate process/package | Create triggers by hand after deploy |
| Trigger on Unattended with no robot never ran, silently | Serverless runtime; morning check |
| Backfill budget 30 min inside a 15-min job: killed mid-tenant | ~13-min deadline, slices, chaining |
| Job "Successful" with every tenant failing: errors logged at Info | Warn/Error levels; fault on all-fail |
| Test job "Successful" but the gate had refused it | Read logs; surface refusals in the app |
| Concurrent job starts timed out on the credential | Sequential starts, batch inputs, retry |
| Jobs per folder 429'd | Retry-After, sequential, spacing |
| Results cut at 200: fixed `skip=0` | Page by `totalCount`/cursor |
| Two folders with one name merged | Key by id |
| Stale baked folder id looked like an auth failure | Read `uipath:folder-key` at runtime |
| `tsc --noEmit` checked zero files for a whole session | `tsc -b` |
| `uip codedapp deploy` targeted a lineage that didn't own the URL | Solution-level deploy only |
| "Everyone" had Data Writer; a user write scope would open every entity | Read Data Fabric grants first |
| "Licensing has no CORS" was the portal host | Use `api.*` |
| Per-tenant allocation declared unreachable from 3 portal 403s | Test each endpoint, not the prefix |
| Optional workflow args arrived as `null` | Parse defensively |
| Credential rename via CLI 400'd | Rename in the UI |
| `users import --directory-id` → 500 | `AssignDomainUser`, or import then assign |
| Throwaway debug apps left for days | Delete test apps the same session; inventory check |

---

## 16. Building UiPath apps with coding agents

From [`research/r5-uipath-coding-agents.md`](../research/r5-uipath-coding-agents.md) (web and
local sources seen 2026-09-26; keys `[Un]`, `[L-*]` resolve there) plus our own practice. UiPath
now ships a first-party "coding agents" stack: the `uip` CLI + UiPath skills + your coding agent
(public preview 2026-07-08; platform operations GA August 2026; individual skills vary between
Stable, Preview and In-development) [U1][U3].

### 16.1 Toolchain

| Practice | Why | Check |
|---|---|---|
| **Install with `uip skills install --agent claude`; after every CLI bump run `uip tools update` and `uip skills update` together** | Host, tools and skills drift; skills once called `uip flow` / `uip case` when the commands were `uip maestro flow` / `case`; a CLI↔Studio IPC mismatch hung silently [U6][U13][U14] | Record `uip --version` and `uip tools list --output json` in the platform inventory |
| **Pin the CLI version in CI** | Makes laptop/CI drift visible [U31] | CI log shows the pinned version |
| **Check a skill's status before relying on it for a release step** | Coded-apps and review skills were still Preview [L-README][U34] | `skill-status.json` noted with a "last checked" date |
| **Prefer skills over MCP for UiPath work** | `uip mcp serve` exposes one `run_command` tool, an authenticated shell with no destructive safeguards; UiPath positions it as a fallback [U4][U5] | No `uip mcp` server in the project's MCP config unless the user asks |
| **Let the discovery agent write `project-context.md`/`AGENTS.md` for RPA projects; keep your own context for app repos** | Cheap fresh context; it skips non-RPA and empty projects [L-discovery] | — |

### 16.2 Identity for agents

- **The human runs `uip login` (in Claude Code: `! uip login`, or `--profile <env>`); the agent runs
  only `uip login status --output json`.** An agent-run login blocks on a browser callback nobody
  sees; `--no-browser` doesn't fix it; the callback port stays held for up to 5 minutes. [L-platform]
- **Use a named `--profile` per environment and pass it on every call;** a missing profile doesn't
  fall back, so there is no silent cross-tenant mistake. [L-platform][U11]
- **Use a dedicated least-privilege identity for agent work** (the agent acts as whoever is logged
  in), and an External App login for CI (`--client-id env.UIPATH_CLIENT_ID --client-secret
  env.UIPATH_CLIENT_SECRET`; setting the variables alone doesn't log in). [U7][U31]
- **Headless coded-app publish needs `OR.Default Apps.Read Apps.Write`**; granular OR scopes don't
  replace `OR.Default`. This is the CLI session's scope, separate from the app's runtime
  `uipath.json` scope. [L-coded-apps]
- **Never read, print or pass tokens from `~/.uipath/.auth`;** a skill bug (#334) once had agents
  `curl` with the cached token. [U12]
- These sit on top of §4: the app itself still has exactly two permanent external apps, and each
  endpoint needs its own scope.

### 16.3 CLI contract

- **Call `uip` with `--output json` and `--output-filter` (JMESPath on `Data`);** the envelope is
  `{ Result, Code, Data }`, `Result` values are stable within a major version, `Data` fields can
  change in minor releases, exit codes 0–4 and 130. [U9]
- **Judge success by `Data` and by reading the artifact back, not by exit code or `Result`.**
  `uip rpa run` puts the real verdict in `Data.errors` / `Data.output`; don't `| tail` it.
  [L-rpa][L-solution]
- **When unsure of a command, read `uip <cmd> --help --output json`; never guess flags.** [U2]
- **Ask the agent for outcomes, not command strings** ("deploy this solution to test"); it chains
  pack → publish → deploy. Approval still applies. [U2]

### 16.4 Deploy paths

| Situation | Path |
|---|---|
| Coded app inside a solution (AppV2) | `uip solution resources refresh → pack → publish → deploy run` (first time) / `deploy upgrade` (later); never `uip codedapp …` |
| Standalone coded app (no `.uipx`) | `uip codedapp pack → publish → deploy --folder-key <GUID>` (non-interactive; resolve the key with an exact name match; don't retry-loop a folder-key rejection; `UIPATH_FOLDER_KEY` env fallback) [U35] |
| Browser debugging in Studio Web | `uip solution upload` (not deployable) |
| Promote to another tenant | Same package, `uip login tenant set` + `--config-file` per environment |

"Deploy done" = CLI success, then **verify by the served content hash**, not by polling the URL
(activation lags minutes) or the version. [U16, §11]

### 16.5 API budgets

- **Poll jobs with `uip or jobs get <key>` (not rate limited), not repeated `jobs list`;**
  Jobs/QueueItems lists allow 100 req/min/tenant for non-automation callers; each `…/Export` 100
  per day per tenant. [U17][U18]
- Inside your own backend, the same limits apply: sequential per-folder loops with `Retry-After`
  (§8.3).

### 16.6 Permissions and guardrails

- **Install `/uipath:install-permissions` (Full, with rails) into project `settings.local.json`;
  keep `publish`, `deploy`, `upload`, `login` and `debug` on `ask`.** Only settings and hooks
  enforce; skill prose can be ignored by a model. [L-perms][U34]
- **Add a PreToolUse hook** that blocks `uip login` from the agent, `cat ~/.uipath/.auth` and
  `curl … uipath.com` (defence in depth for #334-style behaviour). [r5 §6.1]
- **Build or edit requests stop at the local build;** don't deploy unless asked. [U35]
- **Beware "approval theater":** an approval request must name the concrete diff, target tenant,
  folder and blast radius. [U34]
- **Our team rules:** builders in worktrees never run `uip`, never deploy, never edit the
  inventory; the coordinator makes platform changes after the user's OK and records them the same
  turn.

### 16.7 Troubleshoot and review

- **Send "why did X fail" to `uipath-troubleshoot`:** anchor on the exact job, folder and time
  window, keep raw CLI output, require runtime evidence, and get approval before any fix.
  [L-troubleshoot]
- **Run `uipath-review` (read-only) before each release,** next to `tsc -b`, the test suites and
  `uip rpa validate/build`: the reviewer is not the builder. [L-review]

### 16.8 SDK and app code with agents

- **Read the installed `node_modules/@uipath/uipath-typescript/dist/<subpath>/index.d.ts` before
  using any SDK method,** never the minified bundle; loop the cursor on every list. [L-coded-apps]
- **`base: './'`, `getAppBase()` for the router, assets through the bundler;** otherwise a blank
  page or 404s under the app sub-path after deploy (a forum thread reports it working only in the
  personal workspace). [U16][U40]
- **Keep secrets in a secret store or CI secrets, passed as `env.VAR`;** never in prompts, files or
  git. [U7][U11]

### 16.9 Known pitfalls (living list; see r5 §4 for sources)

| Pitfall | Rule |
|---|---|
| Agent ran `uip login` and hung | Human logs in; agent checks status |
| 403 on `external-apps create/update` retried in a loop | Stop, diagnose, reuse the existing app [U35] |
| `codedapp deploy --folder-key` rejected a valid key on a large account | Use the env fallback; don't loop [U35] |
| Outer `Result: Success` with a failed run | Read `Data` and the artifact |
| Skills calling commands that no longer exist | Update CLI, tools and skills together |
| Studio Web: a pushed coded app is read-only there; push/pull conflicts undocumented | Treat the repo as source of truth; download, overlay, upload (§10.2) |
| XAML text edits break namespaces/IdRefs | Prefer coded (`.cs`) workflows for agent-edited backends; validate with `uip rpa validate` |
