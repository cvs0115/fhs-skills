# Question bank: UiPath platform (IDs `U*`)

Use with the generic banks (`questions/01`–`09`) whenever the app runs on UiPath Automation Cloud.
Same format and etiquette as [`research/r3-question-banks.md`](../research/r3-question-banks.md)
and [`00-etiquette.md`](00-etiquette.md): batches of 1–4, recommended option first, ask only what
the docs, inventory and decision log don't already answer, and log each answer with its ID.

- **★ = must-ask.** This bank has exactly 5. Ask them before the UiPath side counts as planned.
- **(Rec)** marks the recommended option, offered first. Details behind each recommendation are in
  [`platforms/uipath-framework.md`](../platforms/uipath-framework.md) (`FW §n`),
  [`uipath-development-practices.md`](../platforms/uipath-development-practices.md) (`DEV §n`) and
  [`uipath-cli-sdk-api.md`](../platforms/uipath-cli-sdk-api.md) (`API §n`).
- **Always ask before** creating or widening an external app scope, adding a role or group grant,
  creating or deleting an entity, a first data write, an upload, a deploy or an uninstall
  (etiquette rule 5), even when a question below was answered earlier.

---

## 1. Environment and architecture

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U1 ★ | Which org, tenant and folder is this built and deployed in, and is it a dev tenant or the customer's? | Scopes, default grants ("Everyone" roles), folders and the install steps all differ per tenant. Nothing gets created until this is known. | Dev tenant, one app folder under `Shared/<app>`, customer install later from the handoff **(Rec)** · Customer tenant directly · Several tenants (dev → test → prod via deploy configs) | always |
| U2 ★ | What must the app read or do that the signed-in user's own token can't (org-wide licensing, other tenants, Identity/audit, trusted writes)? | Decides whether you need the backend coded workflow as the app's own API (FW §2) or can stay browser-only. | Backend coded workflow with app scope for privileged reads and trusted writes; browser reads the results **(Rec)** · Browser-only with the user's token · Maestro / API workflow / Coded Function backend | always |
| U3 | Should pages read live APIs, or a nightly snapshot with "Data as of …"? | Cost, latency and serverless job count per page load. | Nightly sync feeds every page; admins get one "refresh now"; live status links to Orchestrator **(Rec)** · Live reads for current state, snapshot for history · Live everywhere | if the app shows data from APIs |
| U4 | Where does the app store collected data? | Snapshot assets reset on deploy and cap at ~1M chars; Data Fabric has roles, history and limits. | Data Fabric entities (tenant level), small pointers in assets **(Rec)** · Data Fabric folder-level entities · Assets only (tiny, disposable data) | if anything is stored |
| U5 | Tenant-level or folder-level entities? | Tenant-level entities are governed only by Data Fabric roles; folder-level also by Orchestrator folder permissions. | Tenant-level, access by Data Fabric per-entity roles per group **(Rec)** · Folder-level in the app folder | if U4 = Data Fabric |
| U6 | How long is history kept, at what detail? | Storage, Data Fabric daily quota, and what charts can show. | Tiered: daily 120 d, weekly to ~6 mo, monthly 13 mo; months frozen from dailies **(Rec)** · All detail for the license term · Only current state | if history is stored |
| U7 | Should small user-owned writes (settings, requests) go through backend jobs or directly to Data Fabric? | Direct writes are instant but need narrow Data Fabric roles and lose server-side validation. | Backend job writes first; move user-owned rows to direct writes after Data Fabric RBAC is narrowed **(Rec)** · Direct writes now · Backend only, always | if the app has user edits |

## 2. Identities and scopes

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U8 ★ | May we use exactly two permanent external apps (one user-scoped PKCE app for the web app, one app-scoped confidential app for the backend), reuse them if they exist, and create only throwaway test apps that we delete the same day? | Stale extra apps caused a multi-day 403 hunt; every scope change is access-widening. | Two permanent apps; add scopes to them; throwaway test apps deleted the same day **(Rec)** · Reuse an existing org app · One app per feature | always |
| U9 | Which scopes may the backend app hold, and may I add each one as a feature needs it (asking each time)? | Scope updates replace the whole list; each grant widens access. | Minimal per-feature scopes, full list sent on each update, asked per addition **(Rec)** · A pre-approved list now · Broad `OR.Default` | before the first backend build |
| U10 | Which user scopes may the web app request (e.g. OR.Jobs, OR.Execution.Read, OR.Assets.Read, OR.Users.Read, DataFabric.Data.Read)? Is any write scope allowed? | The `uipath.json` scope line must match; a user write scope inherits the tenant's Data Fabric defaults. | Read scopes + OR.Jobs only; no Data Fabric write **(Rec)** · Add DataFabric.Data.Write after Data Fabric roles are narrowed · Broad user scopes | before the first web build |
| U11 | Where does the backend's secret live, and who enters it after each deploy? | A deploy can wipe the credential; the secret must never enter the repo. | Tracked credential asset with a placeholder; the user enters the secret after deploy; a test job proves it **(Rec)** · External credential store (Azure Key Vault, CyberArk…) · Other | if there's a backend |

## 3. Access and RBAC

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U12 ★ | Which user groups and roles does the app have, and may we follow "one role per group, grants to groups only, roles on local groups with Entra/AD groups nested inside"? | Auditable access; the app and the backend both key off these roles. | Local groups Viewers / Power Users / Admins, one folder role each, a marker permission to tell them apart **(Rec)** · Viewers + Admins only · Reuse built-in roles | always |
| U13 | What may each role do (read, request, run refreshes, change settings, approve), and is the backend job the enforcement point? | The app only hides buttons; the job's role gate is the real check. | Hard-coded table per mode in the backend; app hides what's refused **(Rec)** · Data Fabric roles as the gate · App-side only (not recommended) | if there's more than one role |
| U14 | Do we have a test account per role (Viewer-only, Power User, Admin), and an Entra-nested member? | A developer's direct Folder Administrator role masks broken group grants. | Yes: one account per role plus one nested Entra member **(Rec)** · Only the developer's account (roles untested) · Borrow accounts per test | before access testing |
| U15 | Does the tenant's Data Fabric give "Everyone" Data Writer, and may we change that or restrict per entity? | With Everyone = Data Writer, any user write scope opens every entity. | Read the grants; for our entities give each group its own custom role; tenant defaults are the owner's decision **(Rec)** · Leave as is (known gap, recorded) · Remove Everyone's writer tenant-wide | if Data Fabric is used |
| U16 | Should the app detect org/tenant admins (e.g. to show "manage licenses" links)? | No token claim says "admin"; the options need a new scope and live tests. | Probe `identity_/api/Group/{orgId}` with the user token (PM.Group.Read user scope) after a non-admin test **(Rec)** · Backend publishes admin members nightly · Show to everyone with a note | if admin-only UI exists |

## 4. Jobs, triggers and the backend API

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U17 | Which runtime do jobs and the trigger use? | A trigger on the wrong runtime fires and creates no job, silently. | Serverless for app jobs and the trigger **(Rec)** · Unattended on a connected robot in the folder · Mixed | if there's a backend |
| U18 | When and how often does the scheduled sync run, and in which time zone? | Data freshness and cost; the trigger is created by hand after each fresh deploy. | Nightly ~1 AM in the owner's time zone **(Rec)** · Several times a day · On demand only | if there's a sync |
| U19 | What's the time budget per run, and may long work chain into follow-up runs? | Serverless stops at ~15 min; chaining needs OR.Jobs.Write and a verified marker. | ~13-min deadline per run, slices, chained follow-ups with an HMAC marker **(Rec)** · One long run on an unattended robot · Split by hand | if any mode can take > 10 min |
| U20 | How are backend failures surfaced to people? | Jobs logged at Info end green with nothing done. | Warn/Error logs, fault on all-fail, a Diagnostics page reading the last runs **(Rec)** · Orchestrator alerts only · Email/Teams webhook | if there's a backend |

## 5. Solution lifecycle and release

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U21 ★ | Who deploys, and which path do we use: Studio Web upload then the user deploys, or the CLI `pack → publish → deploy upgrade` chain after the user's OK? | Deploys reset assets and can wipe the credential; agents never deploy on their own. | Agent uploads the whole solution and verifies; **the user deploys**; agent runs the after-checks **(Rec)** · Agent runs the CLI chain after an explicit OK each time · CI pipeline (`uipath-aops`) | always |
| U22 | Is the solution the only release unit (no component pushes, no standalone `codedapp` deploy)? | Two app lineages for one path; component pushes drift from the solution. | Whole solution only; upgrade in place **(Rec)** · Components for interim checks, solution for releases · Standalone coded app (no solution) | if the app has more than one project |
| U23 | May we capture asset values before each upload and restore them after the deploy? | A deploy resets text assets to `{}`. | Yes: capture to the scratchpad, restore after the credential test **(Rec)** · Regenerate by running the sync after deploy · Accept blank pages until the next sync | before the first deploy |
| U24 | Which resources are created by hand after a fresh deploy (triggers, Data Fabric roles, group imports), and who does it? | Some resources can't be tracked in the solution; the install steps must list them. | Listed in the install steps with exact commands; the agent runs them after the user's OK **(Rec)** · The user does them in the UI · A setup script | before the first fresh deploy |
| U25 | Where is the platform inventory kept, and does the customer copy strip ids? | The handoff must reproduce the setup without leaking keys. | `docs/platform-inventory.md` tracked; handoff copy updated each sync; ids kept internal **(Rec)** · Handoff only · Not kept | always (quick) |

## 6. Development practices

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| U26 | May frontend-only changes be verified on localhost against the real tenant, with uploads only for backend, schema, trigger, asset or scope changes? | Saves deploys; the backend only runs inside Orchestrator. | Yes, classify each change first **(Rec)** · Upload every change · Local only until the end | if there's a web app |
| U27 | Is there a preview/demo mode with real-shaped fixtures, and must every fixture field be something the backend really produces? | Testing without tenant data; demos must not promise data the app can't deliver. | Yes, with a fixture audit test **(Rec)** · Demo values may be free-form · No demo mode | if there's a UI or a demo |
| U28 | May scripted GUI testers sign in with a named account and SSO button, in a persistent browser profile, and never click job-starting or write actions on the live tenant? | Safe unattended testing; sessionStorage token means a sign-in per run. | Yes, with a headed first sign-in by the user **(Rec)** · Manual testing only · Testers may run jobs on a test tenant | if GUI testers are used |
| U29 | Which UiPath identity may the agent use for live API checks: throwaway app-scope apps, the user's CLI login, or both? | A delegated token misleads about what the backend can do. | Throwaway app-scope apps for backend questions (deleted after); the CLI login for admin reads **(Rec)** · CLI login only · No live checks | before the first API spike |
| U30 | May agents run `uip` commands at all, and which ones need an OK each time? | Builders in worktrees shouldn't touch the tenant; read-only commands are safe. | Coordinator only; read-only commands freely; any create/update/delete/upload after an OK **(Rec)** · Any agent, read-only · User runs every command | always (quick) |
