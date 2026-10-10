# UiPath development practices

The day-to-day loops for building a UiPath app: what to run locally, what needs a real upload, and
the traps in each. Companion to [`uipath-framework.md`](uipath-framework.md) (architecture, RBAC,
release) and [`uipath-cli-sdk-api.md`](uipath-cli-sdk-api.md) (commands and endpoints). Each item:
**rule**, then why, then how to check. Evidence keys resolve in
[`research/r4-uipath.md`](../research/r4-uipath.md).

1. [Coded Web App dev loop](#1-coded-web-app-dev-loop)
2. [Backend coded workflow (C#) dev loop](#2-backend-coded-workflow-c-dev-loop)
3. [Studio Web vs local](#3-studio-web-vs-local)
4. [Assets and configuration](#4-assets-and-configuration)
5. [Testing](#5-testing)
6. [Access during development](#6-access-during-development)

---

## 1. Coded Web App dev loop

| Rule | Why | Check |
|---|---|---|
| **Classify the change first:** frontend-only → verify on `localhost:5173` against the real tenant; anything touching the backend workflow, Data Fabric schema, triggers, assets or scopes → a real upload + deploy | The backend only runs inside Orchestrator; a local run proves nothing about it. A round trip for a CSS change wastes a deploy | The plan row says "localhost" or "upload" |
| **Register the dev origin as a redirect URI** (`http://localhost:5173` and `…/`) on the PKCE app; compute `redirectUri` from `window.location` | The SDK may send either form; a baked redirect sent the deployed app back to localhost | Sign-in works on both localhost and the hosted URL |
| **Keep `.env` for localhost only;** read deployed config from the injected meta tags (`uipath:scope`, `uipath:folder-key`) | `VITE_*` is baked at build; a stale folder id looked like an auth failure after a redeploy [HO] | Rebuild not needed after a move to a new folder |
| **`npm run build` before every upload and overlay the fresh `dist/`** | Studio Web keeps `dist/` as committed files and serves them; it doesn't rebuild from `src/` [F18] | Re-download: `dist/index.html` script hash = local |
| **Never mix lineages:** an app inside a solution (AppV2) ships only via `uip solution …`; standalone `uip codedapp …` only for apps outside any solution | A standalone registration for the same path didn't own the live URL; forcing it would duplicate the app | `uip codedapp validate --path-name <path>` |
| **Type-check with `tsc -b`**, not `tsc --noEmit` | A solution-style root tsconfig (`files: []` + references) makes `--noEmit` check zero files; a real type error hid for a session | `npm run build` (`tsc -b && vite build`) is the gate |
| **`base: './'` in Vite; import assets through the bundler; `getAppBase()` for runtime URLs** | The app mounts under a sub-path; `/`-rooted paths 404 after deploy [S-skill] | Load a deep link on the hosted app |
| **Add every new SDK call's scope to `uipath.json` and the PKCE app** | Missing scopes fail on first call with 401/403 | Hosted app loads without 403s in the console |

---

## 2. Backend coded workflow (C#) dev loop

| Rule | Why | Check |
|---|---|---|
| **Keep domain logic in plain C# and test it locally with `dotnet test`** (domain + integration tests against fakes), outside Studio | Only the `Execute` shell needs Orchestrator; policies, parsers, roll-ups, retry and time budgets are testable locally | Suite green before every upload |
| **The `Execute(...)` signature is the job's argument contract;** add arguments at the end with defaults, and parse optional ones defensively | Omitted optional arguments arrive as `null`, not the C# default [F21] | `uip or packages entry-points` after deploy; test with a missing argument |
| **Don't overlay `.codedworkflows/`, `.local/`, `.objects/`, `project.json`, `project.uiproj`** | They are generated or Studio Web-owned and differ per environment | `diff -rq` only on your source folders |
| **Check the live version before bumping `project.json`** | Studio Web derives the next version from the local file; it collided with versions pushed another way | `uip solution deploy list` / packages versions |
| **Log levels mean something:** item failure → Warn, step failure for all items → Error and fault the job; refusals → Warn with the reason in the output | Errors logged at Info hid a run where every tenant failed; jobs end "Successful" after a refusal [CW #4] | Read `uip or jobs logs <key> --level Warning` after test runs |
| **Budget to ~13 minutes on serverless; slice work; save progress; chain** | Jobs are killed at ~15 min [S2] | A test run with a large backlog ends on its own before the limit |
| **Retry the credential read (2/4/8 s) and start jobs sequentially** | `GetRobotCredential` "Asset Operation Timeout", worse with concurrent starts [F23] | No early faults in 50 consecutive runs |
| **Batch work in one job** (JSON list inputs, bounded parallelism inside) rather than many small jobs | Each job costs start latency, Robot Units and a credential read | Job count per page load = 0 or 1 |
| **Separate tokens per feature** (main, asset write, job history, identity) | A missing grant then fails one mode, not all [F6] | Remove a scope in a test app: only that mode fails |
| **Keep tokens, secrets and response bodies out of exceptions and logs** | Logs are readable by anyone with Logs.View | Grep logs for `Bearer`, `secret` |

---

## 3. Studio Web vs local

| Rule | Why | Check |
|---|---|---|
| **The repo is the source of truth; Studio Web is a deploy target.** Always download fresh before overlaying | Studio Web reverted to an old pre-rename version once; the local `.uipx` SolutionId had also drifted from the live one [F26, mem] | Downloaded project names, assets and a recent code marker match expectations |
| **Re-download after every upload and diff** | Proves the upload holds your sources and bundle | `diff -rq` clean; bundle hash matches |
| **Know the two tabs:** `uip solution upload` lands in the **Cloud workspace** tab; the Local tab is a separate registration the CLI can't address | Otherwise you edit or deploy a copy nobody uploaded | Open the designer URL from the upload result |
| **Run `uip solution resources refresh` before upload** (no path argument) | Stale bindings ship otherwise | Resources list matches `bindings_v2.json` |
| **Never hand-edit `resources/solution_folder/` or `.uipx`;** use `uip solution projects add/remove` | Manual edits desync and fail silently; a regenerated resource once lost its package link | `.uipx` and `resources/solution_folder/` agree |
| **Clean imports:** `projects import` copies `node_modules`, `.env`, caches, `.uipath/` verbatim | Secrets and junk get uploaded | Check the tree before upload |
| **Sync the `uipath.json` scope line** (the only line you take from the repo's copy) | It becomes the deployed app's sign-in scope [F17] | `grep scope` in the downloaded file after upload |

---

## 4. Assets and configuration

| Rule | Why | Check |
|---|---|---|
| **App-specific settings go in a Data Fabric configuration entity; assets hold deployment-level values** (credential, snapshot pointers) | Assets reset on deploy and have size limits; settings need history and roles | Settings survive a deploy |
| **Capture asset values before an upload; restore after the deploy** | A deploy reset text assets to `{}` [F27] | Values compared after restore |
| **Keep the credential asset tracked; re-enter its secret after a deploy if needed; test with a job** | Untracking deleted it on upgrade; deploys can wipe the secret; it can't be read back [F28] | Test job logs show a token was acquired |
| **Create new assets in your personal workspace, import them as solution resources, upload; the user deploys** | Keeps the solution the owner of the resource | `resources list` shows it |
| **A credential asset gets a placeholder password in the solution;** the real secret is entered in the target tenant only | Secrets never enter the repo, config, memory or logs | Secret scan before push |

---

## 5. Testing

Generic browser testing is in [`playbook/10-verify.md`](../playbook/10-verify.md),
[`agents/gui-tester.md`](../agents/gui-tester.md) and
[`templates/gui-test-script.md`](../templates/gui-test-script.md). UiPath-specific points:

- **Preview/demo mode with real-shaped fixtures** (`?demo`, `?preview=…`, `?as=viewer`), so the GUI
  and role variants test without tenant data. Fixtures may only use fields the backend really
  produces.
- **Sign-in through the UiPath login page** with the tenant's IdP button and the agreed test
  account; never type passwords; a persistent profile per tester; the SDK token is in
  sessionStorage, so every run clicks Sign in.
- **Layout/CSS tests** run in the unit suite (stylesheet brace depth, media-query rules), since
  jsdom has no layout.
- **Testers never click actions that start backend jobs or write data on a live tenant** without
  an approved plan; use preview mode.
- **Before testing a deploy, verify the served bundle hash** (else you test old code).

---

## 6. Access during development

| Rule | Why | Check |
|---|---|---|
| **Test backend API questions with a throwaway app-scope external app** (only the scopes under test, zero roles confirmed first), then delete it | A delegated token carries the human's access and misleads [F8] | `external-apps list` shows only the two permanent apps afterwards |
| **Look up each endpoint's scope in the tenant OpenAPI spec before blaming RBAC** | Two wrong "needs a role" rounds came from the wrong scope [F4] | The failing call's operationId description |
| **Test roles with a real Viewer account**, not the developer's | A direct Folder Administrator role masked three broken group grants [RG] | Viewer is refused an admin action; Admin passes through the group |
| **After a group membership change, sign out and in** (or wait up to 1 h) | Membership applies at next login or within an hour [S9] | `GetAllRolesForUser` shows the role via the group |
| **Ask before any first write, scope widening, new app, delete or uninstall** | Outward-facing and hard to undo | The decision log has the user's OK |
| **Record every live platform change in the inventory the same turn** | The handoff must reproduce the setup | Inventory change log line with date and verification |
