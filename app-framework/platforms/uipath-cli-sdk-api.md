# UiPath skills, CLI, SDK and API catalog

Companion to [`uipath-framework.md`](uipath-framework.md). Written as best practices: rule first,
then why, then how to check. Evidence keys (`[F12]`, `[S3]`) resolve in
[`research/r4-uipath.md`](../research/r4-uipath.md). No real org, tenant, id or secret appears here;
use `{baseUrl}` (`https://api.uipath.com`), `{org}`, `{tenant}`, `{orgId}`, `<key>`.

1. [UiPath skills map](#1-uipath-skills-map)
2. [The `uip` CLI](#2-the-uip-cli)
3. [TypeScript SDK (`@uipath/uipath-typescript`)](#3-typescript-sdk-uipathuipath-typescript)
4. [API endpoint catalog](#4-api-endpoint-catalog)
5. [Raw REST rules](#5-raw-rest-rules)

---

## 1. UiPath skills map

**Rule: load the matching skill before you touch a UiPath artifact or write code that calls a UiPath
API.** The skills carry field-tested rules (Data Fabric FILE stripping, pagination caps, AppV2 vs
standalone apps) that are easy to miss. Installed with `uip skills install`; in Claude Code they
appear as `uipath:<name>`.

| Skill | Covers | Load when |
|---|---|---|
| `uipath-platform` | Auth, Orchestrator (folders, assets, jobs, processes, users, roles, triggers), Data Fabric (`uip df`: entities, records, files, choice sets), Integration Service, licensing (`uip platform …`) | Before any code or command that hits Orchestrator, Data Fabric or licensing. Its `references/data-fabric/data-fabric.md` is a **must-read before any `uip df` command** |
| `uipath-solution` | `.uipx`, `uip solution init/pack/publish/deploy/upgrade/upload/download`, resources refresh/add/remove, deploy configs, failure diagnosis | Any solution packaging, upload or deploy |
| `uipath-coded-apps` | Coded Web / Action Apps, `@uipath/uipath-typescript`, PKCE external app setup, `uip codedapp`, SDK references (orchestrator, data-fabric, pagination, oauth-scopes) | Building the web app, adding an SDK call, OAuth/redirect problems |
| `uipath-rpa` | `.cs` coded workflows and `.xaml`, create/validate/run | Editing the backend coded workflow |
| `uipath-admin` | `uip admin`: Identity users/groups, external apps, scopes, custom roles, check-access, audit (`uip admin audit`) | External apps and scopes, group work, audit queries |
| `uipath-troubleshoot` | Root-cause investigation of faulted jobs, access loss, wrong results | "Why did X fail" questions; it owns evidence collection |
| `uipath-insights` | Job metrics, failure analysis via Insights | Aggregate job health; not for licensing dashboards (no API) |
| `uipath-review` | Read-only review of solutions, apps, workflows | Before a release, as an independent check |
| `uipath-planner` | PDD → SDD, multi-project task lists | New multi-project solutions |
| `uipath-feedback` | `uip feedback send` bug reports | Platform/CLI bugs (e.g. the name-based group import) |

Data Fabric and licensing are references inside `uipath-platform`
(`references/data-fabric/*`, `references/licensing/*`), not separate skills.

**Skill rules worth copying into the project CLAUDE.md** [S-skill]:
- Use the CLI, don't hand-roll REST, unless no command covers the task.
- Never run an interactive `uip login` from the agent's shell; the user runs `! uip login`.
- Never hand-edit `resources/solution_folder/`; run `resources refresh` before pack/upload.
- Never run `uip codedapp pack/publish/deploy` on an AppV2 project inside a solution.
- Read the installed SDK `.d.ts` before calling a method you haven't used; don't guess.
- Every SDK list call returns one page; loop the cursor.

---

## 2. The `uip` CLI

Install: `npm install -g @uipath/cli`; tools: `uip tools install @uipath/orchestrator-tool`,
`@uipath/codedapp-tool`, `@uipath/data-fabric-tool`. Output: `--output json` and `--output-filter
"<jmespath on Data>"`. **Never redirect stderr** (errors and confirmations go there).

### 2.1 Auth

| Practice | Why / check |
|---|---|
| **The user runs `uip login`** (browser OAuth); the agent checks `uip login status --output json` | An agent-run login blocks on a callback nobody sees |
| Switch tenant with `uip login tenant set <tenant>`; keep separate logins with `--profile <name>` | Commands silently target the active tenant |
| The CLI token is a first-party user token: good for admin reads and changes, **not** a stand-in for the backend's app scope or the web app's PKCE scope | It has scopes neither of your apps has (and lacks some, e.g. PM.License) [F45] |

### 2.2 Commands we actually used

| Task | Command | Gotchas |
|---|---|---|
| Download Studio Web solution | `uip solution download <solution-id> --destination <scratch> --extract` | Without `--destination` the `.uis` lands in the shell's cwd |
| Sync resources | `uip solution resources refresh` (optionally `--solution-folder <path>`) | Takes **no positional path**; run it in the solution folder |
| Upload to Studio Web | `uip solution upload .` | Same SolutionId → overwrites in place with a snapshot; `--force` wipes cloud history; upload ≠ deploy |
| Pack / publish / upgrade | `uip solution pack . <out> -v <ver> -n <package-name>` → `uip solution publish <zip>` → `uip solution deploy upgrade <deployment-key> --version <ver>` | Pass `-n` (defaults to folder name); version > live `LatestVersion` |
| Find the deployment | `uip solution deploy list --limit 200 --output-filter "[?FolderKey=='<key>']"` | `--output-filter` needs an explicit `--limit`; the key changes if the deployment is recreated |
| Import a remote asset into the solution | `uip solution resources add --source remote --kind Asset --name "<name>" --cloud-key <key>` | Safe for assets; **not** for triggers (undeletable duplicates) |
| Start a job | `uip or jobs start <process-key> --input-arguments '<json>' --wait-for-completion --timeout <s>` | `<process-key>` is the release key from `processes list`; `--input-file` uploads a **file** as the job's InputFile (use it for large inputs; `--input-arguments` auto-offloads above 10K chars) |
| Read job logs | `uip or jobs logs <job-key> --level Warning` | **No `--folder-key`**: the folder is inferred from the job key |
| Entry-point schema | `uip or packages entry-points …` | Shows the arguments the deployed package really takes |
| Folder users | `uip or users list-in-folder --folder-key <key> --include-inherited` | Without the flag, inherited assignments are hidden |
| Import a group | `uip or users import --directory-id <identity-id> --type DirectoryGroup` | Returned HTTP 500 for groups for us; name-based import created orphans. Fallback: REST `AssignDomainUser` (§4.2). The one-step import with `--folder-key --role-keys` also 500'd: import first, then assign |
| Role permissions | `uip or roles update <role-key> --add-permissions Assets.View,Jobs.View` (`--remove-permissions`) | Reads, applies, saves; a rename via PUT is ignored |
| Assets | `uip or assets list --folder-key <key> --all-fields` (value included) · `assets create` · `assets update` | `get` omits the value; `get-asset-value` needs `--folder-key`; `update --name` 400s on credential assets |
| Triggers | `uip or triggers create --type time --name … --release-key … --cron "0 0 1 * * ?" --time-zone … --runtime-type Serverless` | Folder comes from `--release-key`; `update` can't change inputs (recreate); we needed a Windows time-zone id though help says IANA |
| External apps | `uip admin external-apps get <id>` → `update <id> --app-scope "…"` / `--user-scope "…" --redirect-uri "…"` · `create` · `delete` | **Replaces** the scope and redirect lists; `create` shows the secret once |
| Scope catalog | `uip admin scopes list` | Type 2 = usable as user and app scope |
| Data Fabric | `uip df entities list/get/create/update`, `uip df records list/query/insert/update/delete`, `uip df files upload/download/delete`, `uip df choice-sets …` | Read the skill's Data Fabric rules first; `addFields` uses `name`; `records update` needs `Id`; FILE fields only via `files`; lists default to tenant-level entities; schema changes need an approved preview |
| Which app holds a path | `uip codedapp validate --path-name <path>` | Use before any `codedapp` command |
| Bug reports | `uip feedback send` | For platform bugs you can reproduce |

### 2.3 CLI best practices

- **Verify after every mutation** by reading the artifact back (`get`, `list`, re-download); exit
  codes and "Success" can hide partial state.
- **Destructive commands take `--yes`** and never prompt; ask the user first and name the blast
  radius.
- **Check `--help` when a flag in a doc doesn't work;** the CLI moves fast (e.g. `solution new` →
  `init`, `project` → `projects`).

---

## 3. TypeScript SDK (`@uipath/uipath-typescript`)

The reference app pinned `1.7.x`. Docs: <https://uipath.github.io/uipath-typescript/>.

### 3.1 Initialization and auth

```ts
import { UiPath } from '@uipath/uipath-typescript';
import { Assets } from '@uipath/uipath-typescript/assets';
import { Entities } from '@uipath/uipath-typescript/entities';
import { Jobs } from '@uipath/uipath-typescript/jobs';
import { Processes } from '@uipath/uipath-typescript/processes';
import config from '../uipath.json';

const sdk = new UiPath({ ...config, redirectUri: `${location.origin}${location.pathname}` });
await sdk.initialize();                 // PKCE redirect on first load; web apps only
const services = { assets: new Assets(sdk), entities: new Entities(sdk), jobs: new Jobs(sdk), processes: new Processes(sdk) };
```

| Practice | Why / check |
|---|---|
| **Compute `redirectUri` from `window.location`** | A value from `uipath.json` is baked at build time and sent the deployed app back to localhost |
| **The deployed app's scope is `uipath.json#scope`**, injected as `<meta name="uipath:scope">`; every SDK call's scope must be listed there **and** granted on the external app | A missing scope fails with 401/403 on first call [F17] |
| Run a `checking → needsSignIn → ready` state machine; try a silent sign-in, show a retryable Sign-in button on `invalid_grant` | An auth code can already be redeemed by the portal shell |
| The token is in **sessionStorage**; never copy it into logs or localStorage | Each tab signs in again; tests click Sign in every run |
| Never call `sdk.initialize()` in a Coded **Action** App | It starts a PKCE redirect inside Action Center's iframe [S-skill] |
| Base URL is the `api.*` host | `cloud.*` breaks API calls |

### 3.2 Runtime config

- Read the folder from `<meta name="uipath:folder-key">` (injected at deploy); fall back to
  `VITE_ORCHESTRATOR_FOLDER_KEY` / `_ID` only on localhost. Pass the folder to SDK calls; the key
  wins over a baked numeric id. [HO]
- `VITE_*` values are **baked at build time**; a stale one produced "Folder does not exist or the
  user does not have access" (wrong folder) and a 404 on StartJobs (wrong process name). Validate
  required bindings at startup and fail with a clear message.

### 3.3 Calls we used

| Need | SDK call | Notes |
|---|---|---|
| Start the backend job | `processes.start({ processName, inputArguments: JSON.stringify(args), reference }, folder)` | Needs `OR.Jobs` (user) and Jobs.Create on the folder; returns the job key and folder id |
| Poll | `jobs.getById(key, folderId)` every ~2 s until a final state | Job reads take the numeric folder id; set a timeout |
| Read output | `jobs.getOutput(key, folderId)` → `outputs.Output` (a JSON string) | Parse and check for `{ ok:false, reason }` refusals before reporting success |
| Read a snapshot asset | `assets.getByName(name, folder)` | Needs `OR.Assets.Read` and Assets.View; mind the ~1M char Text limit |
| Query Data Fabric | `entities.queryRecords({ name }, { filterGroup: { logicalOperator: 0, queryFilters }, pageSize, cursor })` | Loop `hasNextPage`/`nextCursor`; text fields take `=`/`in`, no range operators |
| Records by entity id | `entities.getAllRecords(id, …)` | Address by bound id or by name consistently |
| Write Data Fabric | `insertRecord` / `updateRecord` / `deleteRecords` | Only with `DataFabric.Data.Write` and narrow Data Fabric roles (see framework §3.3) |
| Access level | Raw `GET {orgName}/{tenantName}/orchestrator_/odata/Users/UiPath.Server.Configuration.OData.GetCurrentPermissions` with the SDK token and the folder header | Needs `OR.Users.Read` user scope; cache once per session; any failure → "unknown" |

**Pagination rule:** every list call returns **one page**, even with no options (`getAll()` gets a
server-capped page in a `NonPaginatedResponse`). Loop the cursor; use `totalCount` for counts.
[S-skill pagination]

---

## 4. API endpoint catalog

"Who" = which identity can call it: **App** (client credentials, app scope), **User** (PKCE token
with the user's own permissions), **Admin** (needs an org/tenant admin or licensing role).
Status: ✅ used and working · ⚠ works with caveats · ❌ dead end for that identity · ❓ unverified.

### 4.1 Auth

| Endpoint | Purpose | Who / scope | Status, gotchas |
|---|---|---|---|
| `POST {baseUrl}/{org}/identity_/connect/token` (form-urlencoded, `grant_type=client_credentials`) | App token | App; space-separated scopes | ✅ 400 if any requested scope isn't granted [F6] |
| `GET identity_/connect/userinfo` | Claims of the user token | User | ✅ no role/group/admin claims [F12] |

### 4.2 Orchestrator (`{baseUrl}/{org}/{tenant}/orchestrator_`)

Folder-scoped calls need `X-UIPATH-OrganizationUnitId: <numeric id>` or `X-UIPATH-FolderKey: <guid>`.

| Endpoint | Purpose | Scope (App) | Who | Status, gotchas |
|---|---|---|---|---|
| `openapi/public.json` | Per-operation scope and permission | any valid token | App/User | ✅ the authority for scopes [F4] |
| `GET /odata/Folders` (`$select=Id,Key,DisplayName`) | Folder directory; map GUID Key ↔ numeric Id | `OR.Folders.Read` | App (no role), User (own folders) | ✅ tenant-wide |
| `GET /odata/Users` (`$filter=Type eq 'DirectoryGroup'`) | Users/groups; group Key check | `OR.Users.Read` | App, Admin user | ✅ Key must equal the Identity id [F9] |
| `GET /odata/Releases` | Current processes: `ProcessType`, `IsProcessDeleted`, `Key` | `OR.Execution(.Read)` | App | ✅ folder-scoped; current state only [F34] |
| `GET /odata/Jobs` (`$expand=Release,Robot`) | Job history, durable ProcessType | `OR.Jobs.Read` | App | ⚠ folder-scoped; 429 under bursts (docs: 100/min/tenant non-automation) [F7, S3] |
| `GET /odata/Jobs?$filter=Key eq <guid>&$expand=CreatorUser` | Who started the running job | `OR.Jobs.Read` | App | ✅ the run gate's input |
| `POST /odata/Jobs/UiPath.Server.Configuration.OData.StartJobs` | Start a job (backend chains) | `OR.Jobs.Write` | App/User | ✅ 404 = wrong process name in the folder |
| `GET /odata/ProcessSchedules` | Triggers; `QueueDefinitionId eq null` = time triggers | `OR.Jobs.Read` + Schedules.View (user) | App ❓ (CLI ✅) | ⚠ `StartProcessNextOccurrence` computed |
| `GET /odata/Folders/UiPath.Server.Configuration.OData.GetAllRolesForUser(username='…',skip=0,take=100)?type=User` | A user's roles per folder, **including group-derived** | `OR.Folders.Read` | App | ✅ server-side role authority [F11] |
| `GET …/Folders/…GetUsersForFolder(key=<id>,includeInherited=true)` | Folder principals and roles | `OR.Folders.Read` | App | ✅ |
| `GET …/Folders/…GetMachinesForFolder(key=<id>)` | Every machine with `IsAssignedToFolder`/`IsInherited` | `OR.Folders.Read`/`OR.Machines.Read` | App | ✅ filter server-side |
| `GET …/Machines/…GetRuntimesForFolder(folderId=<id>)` | Runtime slots per type | `OR.Machines.Read` | App | ✅ |
| `POST /odata/Folders/UiPath.Server.Configuration.OData.AssignDomainUser` | Add a directory user/group to a folder by Identity id with roles | `OR.Folders` (write) | Admin | ✅ our fix for orphan groups |
| `DELETE /odata/Users(<id>)` | Remove an (orphan) user/group record | `OR.Users` (write) | Admin | ✅ drops its folder assignments; ask first |
| `GET /odata/Users/UiPath.Server.Configuration.OData.GetCurrentPermissions` | Signed-in user's permissions (folder header = app folder) | `OR.Users.Read` (user) | User | ⚠ without a folder it shows tenant perms, over-reports if a broad group is admin [F31] |
| `GET /odata/Users/…GetCurrentUserExtended` | Current user; `RolesList` | `OR.Users.Read` | User | ❌ direct roles only |
| `GET /odata/Settings/UiPath.Server.Configuration.OData.GetLicense` | Per-tenant robot license Allowed / Used, expiry | `OR.Settings.Read` | App | ✅ 403 from a plain browser user without tenant rights |
| `GET /odata/LicensesRuntime/…GetLicensesRuntime(robotType='Unattended')` | Licensed machines per type | `OR.License.Read` | App | ✅ tenant-wide |
| `GET /odata/Sessions/UiPath.Server.Configuration.OData.GetMachineSessionRuntimes` | Sessions per machine | `OR.Robots.Read` | App | ✅ tenant-wide; plain `/odata/Sessions` and `/odata/Robots` need a folder |
| `GET /odata/Machines` | Machines | `OR.Machines.Read` | App | ✅ |
| `GET /odata/Assets/…GetFiltered?$filter=Name eq '…'` / `PUT /odata/Assets(<id>)` | Read / write a snapshot asset | `OR.Assets.Read` / `OR.Assets` | App/User | ✅ Text ~1M chars; separate token for asset writes |
| `GET /odata/PersonalWorkspaces` | Owner of personal workspaces | `OR.Folders.Read` | App | ❓ found, not used |
| `GET api/stats/GetLicenseStats` | Robot usage chart | — | ❌ 403 for App (needs a user role) [F37] |
| `GET api/FoldersNavigation/GetFolderContext` | Folder tree picker | — | ❌ 403 for App; "OAuth not supported" [F37] |

### 4.3 Licensing (`{baseUrl}/{orgName}/…`; dates are UTC **Unix seconds**)

| Endpoint | Purpose | Scope | Who | Status, gotchas |
|---|---|---|---|---|
| `GET license_/api/account/{orgId}/license-summary` | Org bundle totals, robots totals | `PM.License.Read` | App | ✅ no admin gate for app tokens; User 403 without PM.License [F45] |
| `POST lease_/api/usage/{orgId}/tenants/consumption-summary` | Tenant consumption per unit; `includeAllocation` = org figure only | `PM.License.Read` | App | ✅ [F41] |
| `POST lease_/api/usage/{orgId}/tenants/consumption-by-folder` | One total per folder per range (`tenantId` in the **body**) | `PM.License.Read` | App | ✅ no date bucketing |
| `POST lease_/api/usage/{orgId}/tenants/daily-consumption-by-service` | Per-day per-service | `PM.License.Read` | App | ✅ |
| `POST lease_/api/usage/{orgId}/tenants/consumption-by-process` | Per-process totals | `PM.License.Read` | App | ✅ page it |
| `GET lease_/api/user-usage/{orgId}/users?top=&skip=` | Named-user license usage, org-wide | `PM.License.Read` | App | ✅ no tenant dimension |
| `POST portal_/api/consumption-dashboard/tenant-dashboard-summary-by-tenant` | Per-tenant allocation | `PM.License.Read` + `OR.License.Read` | App | ✅ the only per-tenant allocation source [F40] |
| `POST portal_/…/tenant-consumption-breakdown` | Day-by-day series for any range; `folderKeys` scope | same | App | ✅ [F43] |
| `POST portal_/…/tenant-folder-consumption-breakdown` | Folder tree with server-side subtree totals, `isDeletedFolder` | same | App | ✅ `aggregateByOwnership` no-op here |
| `POST portal_/…/tenant-process-consumption-breakdown` | Per-process `runs`, per-service units, `subProcesses` | same | App | ✅ `aggregateByOwnership=false` = by execution; **page by `totalCount`** [F39, F42] |
| `POST portal_/…/organization-dashboard`, `portal_/api/license/management/…` | Org dashboard, consumables | — | ❌ portal session only |
| `license_/api/account/{orgId}/tenantAllocations` | Tenant allocations | — | ❌ 403 for App; use GetLicense / the summary route |

Licensing pages in the portal need org admin, **License Administrator** (org) or **License Viewer**
(org or tenant) [S8]. A User-token call with `PM.License.Read` from a License Viewer is ❓.

### 4.4 Identity, audit, authorization (`{baseUrl}/{org}/…`)

| Endpoint | Purpose | Scope | Who | Status, gotchas |
|---|---|---|---|---|
| `GET identity_/api/User/{userId}` | `isActive`, `lastLoginTime`, `groupIDs` | `PM.User.Read` | App; User (own record ✅, others need admin) | ✅ `groupIDs` = direct local groups only [F13] |
| `GET identity_/api/Group/{orgId}` / `…/{groupId}` | Groups; members | `PM.Group.Read` | App; User = org admin (403 otherwise ❓) | ✅ nested Entra members not expanded |
| `POST identity_/api/Group/{orgId}/{groupId}/CheckMembers` (body: ≤100 ids) | Direct membership test | `PM.Group.Read` | App/Admin | ✅ direct only |
| `orgaudit_/api/Query/…` | Org audit (sign-ins) | `PM.Audit.Read` | App | ⚠ 403 for the CLI token (no PM.Audit); CLI: `uip admin audit` |
| `POST {orgId}/pdp_/api/geteffectiveaccess` | Effective access | — | ❌ 403 for App; no external-app scope [F32] |
| `GET {orgId}/pap_/api/userroleassignments?scope=/tenant/{tid}` | Platform role assignments (Tenant Administrator) | a PM.* app token worked; exact scope undocumented | App | ⚠ [F32] |
| `organization_/api/organization/{orgId}/tenants` | Tenant list (id → name) | PM scope | App | ✅ |

### 4.5 Data Fabric (`{baseUrl}/{org}/{tenant}/datafabric_/api`)

| Endpoint | Purpose | Scope | Who | Status, gotchas |
|---|---|---|---|---|
| `POST EntityService/{entity}/query` | Filtered read, paged | `DataFabric.Data.Read` | App/User (Data Fabric roles apply) | ✅ ≤1,000 per call; rows under `value` |
| `POST EntityService/{entity}/insert` · `update/{id}` · batch insert/update/delete | Writes | `DataFabric.Data.Write` | App (collector); User only with narrow roles | ✅ duplicate key → 400 (2627) [F24] |
| Files API (`uip df files …`, SDK file calls) | FILE fields | Data scopes | App/User | ✅ record writes strip FILE values silently |
| Schema read | Entity metadata | `DataFabric.Schema.Read` | User | ✅ |

Limits: 5,000 calls/min per tenant; daily quota per Data Fabric unit [S6, S16].

---

## 5. Raw REST rules

When no CLI command or SDK call covers the need:

1. **Send a `User-Agent` header.** Without it a scripted call got a 403 HTML page. [F29]
2. **Send the folder header** for folder-scoped resources; prefer `X-UIPATH-FolderKey`.
3. **Use the `api.*` host** for browser calls (CORS); the portal host rejects preflights. [F16]
4. **Retry 429/503 with `Retry-After`,** and transient network errors with backoff; don't retry 400/403.
5. **Page everything** (`$top/$skip` with `$count=true`, or the API's `take/skip` + `totalCount`);
   test "full page, then short page".
6. **Never print tokens or secrets;** helper scripts log status codes and counts only, and delete
   their temp files.
7. **Test a new endpoint with the identity that will call it in production** (throwaway app-scope
   app for backend calls; the PKCE app on localhost for user calls), and check its documented scope
   first.
