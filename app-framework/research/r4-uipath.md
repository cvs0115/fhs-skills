# R4 — UiPath platform: source notes

Evidence behind [`platforms/uipath-framework.md`](../platforms/uipath-framework.md),
[`uipath-cli-sdk-api.md`](../platforms/uipath-cli-sdk-api.md),
[`uipath-development-practices.md`](../platforms/uipath-development-practices.md) and
[`questions/platform-uipath.md`](../questions/platform-uipath.md). Written 2026-09-26.

> **Origin (context only):** a licensing/usage dashboard on UiPath Automation Cloud: a Coded Web App
> (React, `@uipath/uipath-typescript`, PKCE), a C# coded-workflow backend ("collector") running on
> serverless robots with an app-scope external app, Data Fabric entities and Orchestrator assets as
> stores, shipped as one Studio Web solution. Built over about two weeks by one user with Claude
> Code and sub-agents. All org, tenant, folder, app and principal names, ids, keys, emails and
> secrets from the project are removed here.

## Source keys

**Project sources** (local, not published):

| Key | Source |
|---|---|
| `mem:<file>` | The project's Claude Code auto-memory (`feedback_*`, `project_*`, `reference_*`) |
| `ARCH` | `docs/architecture.md` (data flow, collector modes, identity and secrets, naming, access groups, upload and deploy procedure, SDK) |
| `IS` | `docs/implementation-status.md` (Access model, Data detail tiers, Demo data rule) |
| `CW` | `docs/completed-work.md` (new-deployment issue log, asset-timeout study, deploy log) |
| `INV` | `docs/platform-inventory.md` (live inventory and change log, read back with `uip`) |
| `ADW` | `docs/app-direct-writes-plan.md` (read-only research: app-direct Data Fabric writes vs collector; CORS preflights; scope catalog; DF docs) |
| `HO` | The customer handoff `HANDOFF.md` ("Platform gotchas", "Known data gaps", deployment checklist addendum) |
| `RG` | Read-only research "Run-gate role gap" (2026-09-26): orphan DirectoryGroup records |
| `AC` | Read-only research "Can the web app tell whether the user is an org or tenant admin?" (2026-09-26) |
| `CODE` | The app's `src/uipath.ts`, `src/config.ts`, `src/services/{accessLevel,refreshCollector,robotData}.ts`; the collector's `CollectorWorkflow.cs`, `Application/CollectorRunGate.cs`, `Application/ConfigWriteService.cs`, `Domain/CollectorRunAccess.cs`, `Domain/ConfigWrite.cs`, `Domain/CollectorDefaults.cs`, `Infrastructure/*.cs` |
| `SOL` | The solution's scaffolded `CLAUDE.md`/`AGENTS.md` (uip CLI 1.198.0) |
| `r1` | [`research/r1-project-lessons.md`](r1-project-lessons.md) |
| `r5` | [`research/r5-uipath-coding-agents.md`](r5-uipath-coding-agents.md) (separate researcher; source of framework §16 and its `[Un]`/`[L-*]` keys) |
| `CLI` | `uip … --help` output checked on 2026-09-26 (`or jobs logs`, `or jobs start`, `or users import`, `or users list-in-folder`, `or roles update`, `or triggers create/update`, `solution download`, `solution resources refresh`, `admin scopes`) |

**UiPath skills** (installed locally under `~/.uipath/.skills/skills/`, read 2026-09-26):

| Key | Skill file |
|---|---|
| `S-skill platform` | `uipath-platform/SKILL.md` (CLI-first rule, auth, `uip login` must be run by the user) |
| `S-skill DF Rule n` | `uipath-platform/references/data-fabric/data-fabric.md` Critical Rules (4 names/reserved fields, 6 FILE stripping, 12b UI-broken types, 21 MULTILINE_MAX) |
| `S-skill solution` | `uipath-solution/SKILL.md` (never hand-edit `resources/solution_folder/`, refresh before pack/upload, AppV2 vs standalone, upload = Cloud workspace tab) |
| `S-skill coded-apps` | `uipath-coded-apps/SKILL.md` (api.* base URL, `base: './'`, `getAppBase()`, scopes from `uipath.json`, one page per list call, never `initialize()` in Action Apps, read `.d.ts`) |
| `S-skill pagination` | `uipath-coded-apps/references/sdk/pagination.md` |
| `S-skill SDK DF` | `uipath-coded-apps/references/sdk/data-fabric.md` (audit fields not writable) |
| `S-skill oauth` | `uipath-coded-apps/references/oauth-client-setup.md` (update replaces redirect list; register with and without trailing slash) |

**UiPath docs** (docs.uipath.com, retrieved 2026-09-26):

| Key | Page | What we took from it |
|---|---|---|
| S1 | [Accessing UiPath resources using external applications](https://docs.uipath.com/automation-cloud/automation-cloud/latest/api-guide/accessing-uipath-resources-using-external-applications) | User vs application scope; confidential (client credentials / auth code) vs non-confidential (PKCE); "the grant type you use determines if the resource is called under user scope or under application scope"; `OR.Default` fine-grained model; token endpoint form-urlencoded; requests beyond the granted scope fail |
| S2 | [Automation Cloud Robots – Serverless](https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/automation-cloud-robots-serverless) and [FAQ](https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/frequently-asked-questions-cloud-robots-serverless) | Each serverless job is limited to 15 minutes and is terminated at the limit |
| S3 | [Orchestrator API rate limits](https://docs.uipath.com/orchestrator/automation-cloud/latest/api-guide/rate-limits) | GET `/odata/Jobs` and `/odata/QueueItems`: 100 req/min/tenant non-automation, 1,000 automation; `GET /odata/Jobs(<id>)` not limited; 429 with `Retry-After`; `X-RateLimit-Remaining`; OutputData 51,200 chars; `$top` max 100 on the limited queries |
| S4 | [Permissions per endpoint](https://docs.uipath.com/orchestrator/automation-cloud/latest/api-guide/permissions-per-endpoint) | Documented permission per endpoint (describes the user-token model; see F5) |
| S5 | [Data Fabric – Managing access](https://docs.uipath.com/data-service/automation-cloud/latest/user-guide/managing-access) | System roles Administrator / Designer / Data Writer / Data Reader; "organization users can read data" via Everyone = Data Reader; entity-level, field-level (custom roles only) and record-level (RecordOwner) access |
| S6 | [Data Fabric – Enabling the service](https://docs.uipath.com/data-service/automation-cloud/latest/user-guide/enabling-the-data-service) | 5,000 API calls per minute regardless of units |
| S7 | [Data Fabric API – Query entity records](https://docs.uipath.com/data-service/automation-cloud/latest/api-guide/query-entity-endpoint) | Up to 1,000 records per query |
| S8 | [About licensing roles](https://docs.uipath.com/automation-cloud/automation-cloud/latest/admin-guide/about-licensing-roles) | License Viewer (org or tenant): read-only licensing pages; License Administrator (org): same licensing capabilities as an Org Admin |
| S9 | [Accounts and groups](https://docs.uipath.com/orchestrator/standalone/2021.10/user-guide/accounts-and-groups) (the cloud page [Managing accounts and groups](https://docs.uipath.com/automation-cloud/docs/managing-accounts-and-groups) links the same behavior) | Group membership changes apply at next login, or within one hour for an active session (`GroupMembershipCacheExpireHours`) |
| S10 | [Orchestrator – Folders](https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/folders) | Access to a folder grants access to its subfolders; roles inherited from a parent can't be removed in a subfolder |
| S11 | [Apps – Permission management](https://docs.uipath.com/apps/automation-cloud/latest/user-guide/permission-management), [Running a deployed app from a folder](https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/running-a-deployed-app-from-a-folder) | Apps.View on the folder runs and views a deployed app |
| S12 | [Solutions – Deploying a solution](https://docs.uipath.com/solutions-management/automation-cloud/latest/user-guide/deploying-a-solution), [Changing the solution version](https://docs.uipath.com/solutions-management/automation-cloud/latest/user-guide/upgrading-or-downgrading-a-solution) | Link to existing assets/buckets/queues/webhooks at deploy; change version keeps configured values "by default" (our deploys still reset asset values: F27) |
| S13 | [Get Credential activity](https://docs.uipath.com/activities/other/latest/workflow/get-robot-credential) | Credential asset read by name; CacheStrategy; per-robot credentials return only the username |
| S14 | [Platform Management scopes and permissions](https://docs.uipath.com/automation-cloud/automation-cloud/latest/api-guide/platform-management-scopes-and-permissions) | Token validated against resource scopes, then user permissions per endpoint (Read for GET, Write for POST/PUT/DELETE) |
| S15 | [Data Fabric – API access](https://docs.uipath.com/data-service/automation-cloud/latest/user-guide/api-access) | Data Fabric scopes are user scopes dependent on the user's permissions |
| S16 | [Data Fabric – License allocation](https://docs.uipath.com/data-service/automation-cloud/latest/user-guide/license-allocation) | Storage, attachments and a daily API-call quota per Data Fabric unit |
| S17 | [Robot units calculation example](https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/robot-units-calculus-example) | Serverless consumption in Robot Units per minute by machine size |
| S18 | [Coded Apps in Studio Web](https://docs.uipath.com/studio-web/automation-cloud/latest/user-guide/coded-apps-in-studio-web), [Building and deploying coded apps](https://docs.uipath.com/apps/automation-cloud/latest/user-guide-ca/building-and-deploying-coded-apps) | `uip codedapp push` uploads the locally built app into the Studio Web project; solution-native publish and deploy |
| S19 | [UiPath TypeScript SDK](https://uipath.github.io/uipath-typescript/getting-started/) | Create `UiPath`, `await initialize()`, construct services |

---

## Findings (F-ids)

Each: what we observed · how it was proved · source. "Unverified" is stated where it applies.

### Backend-as-API pattern

- **F1** The web app starts one backend job per privileged read or trusted write and reads the
  output argument; small runs measured 0–2 s queue, 3–40 s run (median ~18 s). Live job timings over
  7 days. [ADW, ARCH, CODE refreshCollector.ts]
- **F2** The backend's run gate classifies the starter from the job's own record (CreatorUser,
  StartingScheduleId, StartingTriggerId) and checks the user's roles on the app folder; chained runs
  carry an HMAC marker keyed with the backend's secret, valid ~60 min, counted only when the
  creator isn't a signed-in user; a failed read faults the job; refusals end Successful with
  `{ok:false, reason, code:'forbidden'}`. [CODE CollectorRunGate.cs, CollectorRunAccess.cs]
- **F3** A viewer's user token can't read Licensing (403 at the gateway without PM.License),
  Identity (org admin) or audit; in Orchestrator it reaches only tenants and folders the user is
  assigned to. Live with the CLI user token; licensing roles per S8. [ADW §1]

### Identities and scopes

- **F4** Each Orchestrator resource needs its own scope; the tenant OpenAPI spec
  (`orchestrator_/openapi/public.json`, each operation's `description`) states it. Two wrong
  "needs a role" conclusions came from testing with `OR.Execution` only. Live. [mem:reference_orchestrator_api_endpoints, mem:feedback_ground_in_docs_ask_about_gaps]
- **F5** With the right scopes and zero role assignments (checked via check-access first),
  Releases/Folders/Users/Jobs returned 200 for an app-scope token; the "permissions per endpoint"
  column (S4) didn't apply to app-scope callers. Live. [same]
- **F6** A client-credentials token request fails with HTTP 400 if any requested scope isn't
  granted; `OR.Execution` does not satisfy `OR.Execution.Read`. Live incident (every tenant 400).
  [mem:reference_orchestrator_api_endpoints, CW issue #3]
- **F10** The running credential asset pointed at a stale external app with the wrong scopes;
  Orchestrator never returns a credential's username/secret (masked in `get` and
  `get-asset-value`), so only a test job proves it. Live incident. [mem:project_unit_consumption_poc_deployment]
- **F12** Decoded user tokens carry `sub`, org id, name/email and IdP claims but no admin, role or
  group claim; `userinfo` returns the same. Live. [AC]
- **F16** CORS preflights from the hosted app origin to the `api.*` host returned 204 with
  `Access-Control-Allow-Origin: *` for Data Fabric, `license_`, `lease_`, `portal_` consumption
  routes, `identity_`, `orgaudit_` and Orchestrator; the portal host returned 405 (license-summary)
  and 403 (portal routes). This supersedes an earlier "Licensing has no CORS" note. Live. [ADW]
- **F17** The deployed web app's OAuth scope comes from Studio Web's copy of `uipath.json`,
  injected as the `uipath:scope` meta tag; an overlay that keeps Studio Web's `uipath.json` shipped
  an app without `OR.Assets.Read`. Live incident. [mem:project_unit_consumption_poc_deployment, CW issue #1]
- **F29** Scripted raw REST calls without a `User-Agent` header received a 403 HTML page; with one,
  the same token worked. Live. [RG]
- **F30** `uip admin scopes list`: `DataFabric.Data.Write`, `PM.License.Read`, `PM.User.Read`,
  `PM.Group.Read`, `PM.Audit.Read`, `OR.License.Read`, `OR.Settings.Read` are Type 2 (user and
  application). Live. [ADW]

### RBAC and Identity

- **F9** Three groups imported by name existed in Orchestrator as DirectoryGroup records whose
  Keys didn't exist in Identity (`identity_/api/Group/{org}/{key}` → 404); Identity membership and
  folder assignments looked right, but no member received the roles. Fixed by deleting the records
  and re-adding each by Identity id with `AssignDomainUser`; new Key = Identity id.
  `uip or users import --directory-id` returned HTTP 500. Live, user-approved. [RG, INV change log]
- **F11** `GetAllRolesForUser(username=…)?type=User` returns direct and group-derived roles
  (`Users[].Type=DirectoryGroup, IsInherited=true`); `type` is the principal kind (User, Group,
  Machine, Robot, ExternalApplication), `DirectoryGroup` → 400. Live. [RG]
- **F13** Identity `User.groupIDs`, group members and `CheckMembers` reflect direct local
  membership only: `CheckMembers` on the Administrators group for 100 users who aren't direct
  members returned 0, though the group contains Entra groups; docs say Entra membership is
  evaluated via Graph when needed. Nested-Entra resolution by Orchestrator at login is **unverified**
  (no nested member existed). [AC, RG]
- **F14** `AppVersions.View` can't be put in a folder role (tenant permission); `EntityRecords.*`
  / `EntitySchema.*` are folder permissions, so tenant-level entities can't be governed by
  Orchestrator roles. Live, role editor. [ARCH access groups]
- **F15** A role PUT with a new Name returned 200 and changed nothing. Live. [ARCH]
- **F31** `GetCurrentPermissions` without a folder header returned tenant admin permissions for
  every user in a tenant where a broad default group held Orchestrator Administrator;
  `GetCurrentUserExtended.RolesList` shows only direct roles. Live. [AC]
- **F32** PDP `pdp_/api/geteffectiveaccess`: 200 with the CLI first-party token, 403 with an app
  token, and no external-app scope exists for it; PAP `pap_/api/userroleassignments` returned 200
  with an app token holding PM.Group.Read + PM.User.Read (exact scope undocumented). Live,
  throwaway app deleted after. [AC]
- **F33** `GET identity_/api/Group/{orgId}` with an org admin's user token: 200. The 403 for a
  non-admin and the result for an Entra-only admin are **unverified**. Live. [AC]
- Folder Administrator masking: the developer's direct Folder Administrator role on the app folder
  passed every check while all group grants were broken. Live. [RG, INV "To review"]

### Orchestrator data

- **F7** Per-folder Jobs reads returned 429 under bursts; `Retry-After` honored; 150 ms spacing
  still 429'd, 400 ms held; a 90-day count for 234–313-folder tenants took ~75–85 s. Live. Docs S3
  give 100 req/min/tenant for non-automation GET Jobs. [mem:reference_robot_license_apis, mem:project_process_status_jobs_fallback]
- **F8** Releases and Jobs 400 "A folder is required for this action" without a folder header; the
  GUID URL form `/{orgId}/{tenantId}/orchestrator_/…` did not bypass it for an app token; a HAR
  showing a cross-folder call reflected the human's own folder access. Live. [mem:reference_orchestrator_api_endpoints]
- **F19** Licensing `processKey` = Orchestrator Release.Key; Licensing `folderKey` = folder Key
  (GUID) while Robots data uses the numeric Id; Processes/Releases return uppercase GUIDs, Jobs and
  Licensing lowercase. Live. [mem:reference_api_catalog]
- **F34** `Job.ProcessType` and the embedded Release survive a Release delete/rename; Releases has
  only current state and exposes `IsProcessDeleted`; ~16% of historical process rows were
  unresolvable through Releases. Live. [mem:reference_orchestrator_api_endpoints]
- **F35** `Settings/GetLicense` (`OR.Settings.Read`): per robot type Allowed = tenant allocation,
  Used = in use; `GetMachineSessionRuntimes` (`OR.Robots.Read`), `LicensesRuntime`
  (`OR.License.Read`), `/odata/Machines` are tenant-wide. Live across 12 tenants, throwaway app.
  [mem:reference_robot_license_apis]
- **F36** `GetMachinesForFolder` returns every tenant machine with `IsAssignedToFolder` /
  `IsInherited` (2 of 239 assigned); `GetUsersForFolder(includeInherited=true)` returns users,
  groups and robot accounts with `UserEntity.Type`; `GetRuntimesForFolder` one row per runtime type.
  Live. [same]
- **F37** `api/stats/GetLicenseStats` → 403 "You are not authorized" for app tokens at every range;
  `api/FoldersNavigation/GetFolderContext` → 403 for app tokens regardless of scope. Live.
  [mem:reference_robot_license_apis, mem:project_unit_consumption_poc_deployment]
- **F38** One org-level app token reached every tenant's Orchestrator by tenant name; one user
  token worked across tenants only where the user was assigned. Live. [mem:reference_robot_license_apis, ADW]
- **F39** A process breakdown call with a fixed `skip=0` silently truncated tenants with more than
  200 processes; fixed by paging on `totalCount` with a "full page then short page" test. Live
  incident. SDK: `getAll()` returns one server-capped page. [mem:project_live_historical_data_migration, S-skill pagination]

### Licensing and Insights

- **F40** `portal_/api/consumption-dashboard/tenant-dashboard-summary-by-tenant` returned the real
  per-tenant `allocated` figure for a zero-permission app token (PM.License.Read, OR.License.Read);
  `organization-dashboard` 403'd with the same token (portal session only). An earlier
  "permanently unreachable" conclusion generalized from three 403s. Live, 3×. [mem:reference_licensing_api_endpoints]
- **F41** `consumption-summary` with `includeAllocation` returns only an org-wide allocation. Docs +
  live CLI. [same]
- **F42** `tenant-process-consumption-breakdown`: `aggregateByOwnership=false` = flat per-execution
  rows, `true` nests `subProcesses`; the flag is byte-identical no-op on the folder breakdown; no
  owner field in either. HAR diff. [same, mem:feedback_verify_before_speculating_on_capabilities]
- **F43** `tenant-consumption-breakdown` returns a per-day `distribution[]` for any range (up to
  ~2,500 days in one response), optionally scoped by `folderKeys`; folder-scoped sums matched the
  tenant-wide call. Live HARs + app token. [mem:reference_licensing_api_endpoints]
- **F44** Licensing date-range bodies are UTC Unix seconds; paths need `/{organizationName}/`;
  `consumption-by-folder` takes `tenantId` in the body, not the path. Live. [mem:reference_api_catalog, HO]
- **F45** Licensing endpoints with the CLI user token returned 403 "This API endpoint is not
  authorized" at the gateway (no PM.License scope). Whether an external-app user token with
  PM.License.Read works for a License Viewer is **unverified**. [ADW]
- **F46** Insights has built-in Robot Licenses and Machines dashboards but no documented API or
  embedding; the only programmatic route is Real-Time Data Export. `insights_/api` with an app
  token is **unverified**. [mem:reference_robot_license_apis]
- **F47** Two consumables shown in the portal licensing page are absent from `license-summary`.
  Live. [HO known data gaps]

### Data Fabric

- **F24** Duplicate unique-key insert → HTTP 400 "Value uniqueness violation … Error Number: 2627",
  not 409; a MULTILINE_TEXT value of 10,000 chars returned in full from a query; rows under
  lowercase `value` with `totalRecordCount`; empty fields omitted; descriptions ≤ 512 chars. Live.
  [mem:reference_robot_license_apis]
- **F25** An entity display-name update returned HTTP 500 because the stored description held a
  corrupted character; re-sending the description fixed it. Entity names are immutable. Live.
  [mem:project_unit_consumption_poc_deployment]
- "Everyone" held Data Writer + Data Reader tenant-wide in one tenant (docs default: Data Reader,
  S5); adding `DataFabric.Data.Write` to the web app would have let every user write every entity;
  reverted the same day. Live. [INV]
- Server-set `CreatedBy` / `UpdatedBy` / `RecordOwner` principal ids and `CreateTime` /
  `UpdateTime` on collector rows; not writable. Live rows + SDK docs. [ADW, S-skill SDK DF]
- `addFields` entries need `name`, not `fieldName`; `UpdatedBy` is reserved. Live. [INV]
- `uip df` has no access-management commands; entity roles are set in the Data Fabric UI. [ARCH]

### Jobs, triggers, deploys

- **F20** A time trigger on the Unattended runtime in a folder without a connected unattended robot
  created no jobs for ~12 days and nothing reported it; switching to Serverless fixed it.
  `triggers update` has no input-arguments option (recreate); `triggers create` derives the folder
  from `--release-key`; the Windows time-zone id was required though the CLI help says IANA. Live.
  [mem:project_unit_consumption_poc_deployment, ARCH, CLI]
- **F21** Omitted optional entry-point arguments bind as literal `null` because the deployed schema
  marks every argument required. Live. [ARCH collector modes]
- **F22** Serverless jobs were killed at ~15 min ("reached the time limit"); seven user runs faulted
  at the limit in a week. Live + S2. [CW issue #5, ADW]
- **F23** 16 of 500 serverless jobs (3.2%) faulted 2–4 s after start inside `GetRobotCredential`
  ("Asset Operation Timeout"); concurrent starts made it worse; an immediate retry succeeded; a
  2/4/8 s retry was adopted. Live. [CW asset-timeout, CODE AssetRetry.cs]
- **F26** The Studio Web solution was found reverted to an old pre-rename version; the upload was
  rebuilt from the last good download plus current code; an upload keeps a restorable snapshot.
  Live. [CW deploys 2026-09-25]
- **F27** Deploys reset both text snapshot assets to `{}` and, on several deploys, overwrote the
  credential asset (modified seconds after the deployment; every job failed "Token acquisition
  failed with HTTP 400" until the secret was re-entered); one deploy did not. Live. [mem:project_unit_consumption_poc_deployment, CW]
- **F28** Untracking the credential asset from the solution made the next upgrade delete it. Live
  incident. [mem:feedback_keep_credential_tracked]
- **F18** The Coded App's package version went up three times with fresh revision numbers while the
  served bundle stayed byte-identical: Studio Web packages the committed `dist/` and doesn't build
  from `src/`. A standalone `codedapp` lineage for the same path didn't own the live URL
  (`uip codedapp validate --path-name`). Live. [mem:feedback_verify_deploy_by_content_hash, mem:project_unit_consumption_poc_deployment]
- `uip solution resources add --source remote --kind Trigger` created a duplicate process + package
  resource pair that `remove` and `edit` couldn't clean. Live. [mem:project_unit_consumption_poc_deployment, HO]
- `.uipx` `Projects[].Id` is the DesignId; the Studio Web project id for `codedapp push/pull` is
  in `upload`'s `Data.Response.Projects[].Id`. Live. [HO]
- `uip solution pack` defaults the package name to the local folder (pass `-n`); `deploy upgrade`
  targets the newest published version. Live. [mem:project_unit_consumption_poc_deployment]
- `uip or assets update --name` on a credential asset → 400 "user name cannot be null". Live. [same]

### CLI facts checked against `--help` (2026-09-26) [CLI]

- `uip or jobs logs <job-key>`: options `--level`, `--limit`, `--offset`, `--export`; no
  `--folder-key` (folder inferred from the job key).
- `uip or jobs start <process-key>`: `--input-arguments <json>` (auto-offloads to InputFile above
  10K chars), `--input-file <path>` (uploads a file as the job's InputFile), `--wait-for-completion`,
  `--timeout`.
- `uip or users import`: `--username` or `--directory-id`, `--type`, optional `--folder-key` /
  `--folder-path` with `--role-keys`; `--directory-id` imports are documented as idempotent.
- `uip or users list-in-folder --include-inherited`.
- `uip or roles update <key> --add-permissions … --remove-permissions …`.
- `uip or triggers create`: `--runtime-type`, `--time-zone` (help: IANA), folder from `--release-key`.
- `uip solution download <id> -d <dir> --extract`; `uip solution resources refresh` takes
  `--solution-folder`, no positional path.
- `uip admin scopes list`.

---

## Items still unverified (don't build on them without a test)

1. Orchestrator resolves an Entra group nested in a local group into folder roles at login
   (expected; test with one nested member).
2. `identity_/api/Group/{orgId}` returns 403 to a non-admin user token and 200 to an Entra-only
   org admin.
3. A Licensing API call with an external-app **user** token works for a License Viewer.
4. The `insights_/api` endpoints accept app-scope tokens.
5. `ProcessSchedules` with a raw app token (the CLI with a user login worked).
6. What principal id a PKCE user write records in Data Fabric `UpdatedBy`.
7. Whether Data Fabric field RBAC and record-owner levels combine as needed (Create on the
   entity, no Edit on a status field).
8. That Licensing `runs` equals the Orchestrator job count for the same release.
