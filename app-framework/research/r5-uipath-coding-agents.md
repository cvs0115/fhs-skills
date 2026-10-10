# R5: Building UiPath apps and automations with AI coding agents

Research date: **2026-09-26**. Every web source was seen on this date. Where a source gives a publication date, it is
shown. Local findings come from the machine this framework is built on: `uip` CLI **1.202.1**, `@uipath/skills`
**1.202.2** (27 skills plus 1 agent), with read-only help commands only (no login, no changes). Source keys ([U1] and
so on) are listed in full at the end. Local evidence is tagged **[L-*]**.

Scope: how a small team (1–3 humans plus Claude Code sub-agents) should build UiPath Coded Web Apps, RPA/coded
workflows, coded agents and solutions with coding agents. This report feeds `platforms/uipath-framework.md` and the
`/new-app` skill.

---

## 0. The ten findings that matter most

1. **UiPath now ships a first-party "coding agents" stack: `uip` CLI + UiPath skills + your coding agent.** It went to
   public preview on 2026-07-08. Troubleshooting went GA on 2026-07-15 and RPA on 2026-07-31. Platform operations went GA
   in August 2026. Many individual skills are still Preview or In-development. [U1][U2][U3][L-README]
2. **Skills, not MCP, are UiPath's main AI path.** `uip mcp serve` exposes a single `run_command` tool, which is an
   authenticated shell with "no destructive safeguards". The docs describe it as a fallback for MCP clients that are not
   on the supported list. [U4][U5][L-mcp]
3. **"Use the CLI. Don't roll your own REST."** The platform and solution skills both say this. Hand-rolled calls miss
   the folder header (`X-UIPATH-OrganizationUnitId`), the OData filter shape, pagination, retry, and the
   `Result/Code/Data` envelope. A high-severity skills bug (#334) was fixed for exactly this: agents were reading
   `~/.uipath/.auth` and calling `curl`. [L-platform][L-solution][U12]
4. **The agent must never run `uip login` itself.** Interactive login blocks on a browser callback that the user cannot
   see. `--no-browser` does not change that. The user runs `! uip login` and the agent then checks
   `uip login status --output json`. [L-platform]
5. **The CLI contract is built for agents.** The default output is JSON with a `Result` / `Code` / `Data` envelope.
   `Result` values are stable within a MAJOR version, and the exit codes are 0–4 plus 130. `--output-filter` takes
   JMESPath. `Data` fields can change in MINOR releases. A green outer `Result` does **not** mean the workflow passed:
   `uip rpa run` puts the real verdict in `Data.errors` plus `Data.output`. [U9][L-help][L-rpa]
6. **Version drift is a real and common failure.** Host and tools must share MAJOR.MINOR (`uip tools update`). Skills
   must match the CLI (`uip skills update`). Skills once called `uip flow` or `uip case` when the real commands were
   `uip maestro flow` and `uip maestro case` (#333, #337). The CLI and Studio IPC protocols also went out of sync and
   hung silently (#261). [U6][U9][U13][U14]
7. **For identity, use a dedicated least-privilege account, attended mode, and approval before any live change.** The
   agent acts as whoever is logged in. UiPath recommends an External App or tokenized identity with minimal scopes, and
   keeping secrets out of prompts, files and git. [U2][U7][U8]
8. **Coded apps inside a solution ship through `uip solution`, not `uip codedapp`.** Running `codedapp pack`, `publish`
   or `deploy` on an app that is registered in a solution double-registers it and bypasses the deploy config. Standalone
   apps use the `codedapp` path and must set `base: './'`, and deploy needs a non-interactive `--folder-key`. [L-coded-apps][L-solution][U16]
9. **Rate limits and quotas catch agents that poll.** `GET /odata/Jobs` and `GET /odata/QueueItems` allow
   100 requests/min for non-automation callers. Each `…/Export` allows 100 requests/day per tenant. `GET /odata/Jobs(<id>)`
   is not limited. The skills were patched so agents poll with `jobs get` instead of `jobs list`. [U17][U18]
10. **Context files, discovery agent and review gates come built in.** `uipath-project-discovery-agent` writes
    `.claude/rules/project-context.md` (for Claude Code) and `AGENTS.md` (for Autopilot and other agents). It runs at
    most once per session and has a staleness check. `uipath-review` is a read-only auditor, and `uipath-troubleshoot`
    enforces evidence-only diagnosis with an approval gate before any fix. [L-discovery][L-review][L-troubleshoot]

---

## 1. UiPath's own tooling for coding agents

### 1.1 The `uip` CLI (local: 1.202.1)

- **Shape.** A host (`@uipath/cli`) handles auth, sessions, config and the tool lifecycle. Everything else is a separately
  versioned **tool** on npm that installs on first use. The Azure DevOps and Jenkins integrations are wrappers around it. [U9][U10]
- **Top-level commands (local `uip --help --output json`):** `login`, `logout`, `config`, `feedback`, `skills`, `mcp`,
  `user`, `solution`, `agent` (low-code), `codedagent`, `codedapp`, `is`, `or`, `rpa`, `api-workflow`, `maestro`,
  `docsai`, `traces`, `admin`, `df`, `insights`, `platform`, `ixp`, `tools`, `update`. [L-help]
- **Installed tools (local `uip tools list --output json`):** 16 tools, all `Status: ok`. solution, agent, codedagent,
  codedapp (1.202.2), is, or, rpa, api-workflow, maestro (1.202.2), docsai, traces, admin, df, insights, platform and
  ixp are at 1.202.x. This is the drift check to run on a laptop and on CI. [L-tools][U14]
- **Global options:** `--output <table|json|yaml|plain>` (default json), `--output-filter <JMESPath on Data>`,
  `--log-level`, `--log-file`, `--profile <name>`. [L-help]
- **Envelope and exit codes.** `Result` ∈ {Success, Failure, ConfigError, AuthenticationError, ValidationError,
  TimeoutError} and is stable across versions. `Code` is stable within MAJOR. `Data` may gain fields in MINOR releases
  and, rarely, rename them. The envelope goes to stdout; logs and progress go to stderr. Exit codes are 0/1/2/3/4 (4 =
  timeout) plus 130 for cancel. [U9]
- **Auth flows.** Interactive OAuth2 (`uip login`). External App client credentials (`--client-id`/`--client-secret`,
  with secrets read as `env.VAR`). Federated OIDC (`--client-assertion`). An env-var token
  (`UIPATH_CLI_AUTH_TOKEN`). Robot credentials (`UIPATH_CLI_ENFORCE_ROBOT_AUTH=true`). Named `--profile` sessions sit
  side by side under `~/.uipath/profiles`. `uip login which` explains which session is used, and `uip login refresh`
  rotates the token before it expires. [U10][U11]
- **`uip docsai`** searches UiPath docs from the terminal. The troubleshoot skill uses it as an allowed evidence
  source. [L-help][L-troubleshoot]

### 1.2 UiPath skills (local: `C:\Users\<user>\.uipath\.skills\skills\`, 27 skills)

- **Distribution.** `uip skills install` finds every coding agent on the machine and installs **all** skills into each
  one (you cannot pick individual skills). Claude Code gets them as a plugin (the `uipath:` prefix) and is
  **global-only**: `--local --agent claude` fails. Ten agents are supported: Claude Code, Cursor, GitHub Copilot, Codex,
  OpenCode, UiPath Autopilot, Kiro, Windsurf, Antigravity CLI and Devin. `uip skills update` also removes skills that
  UiPath has dropped. UiPath advises against a manual `claude plugin install`, because then updates are manual. [U6][U15][L-README]
- **Plugin extras.** SessionStart hooks (a permission-allowlist nudge, session env, telemetry) and PostToolUse
  telemetry. There is also a `/uipath:install-permissions` command, because Claude Code plugins **cannot ship
  permission rules**. Its "Full — with safety rails" variant puts `debug`, `upload`, `publish`, `pack` and `login` in
  `ask`, so they prompt even under `bypassPermissions`. [L-hooks][L-perms]
- **Telemetry.** UiPath states that file contents, stdout/stderr and transcripts never leave the machine. Identity
  data in telemetry is not anonymous. [U7]
- **Status** (from local `assets/skill-status.json`, 1.202.2):

| Status | Skills |
|---|---|
| Stable | admin, agents, automationhub, feedback, human-in-the-loop, ixp, planner, platform, rpa, solution, tasks, troubleshoot |
| Preview | aops, automation-discovery, **coded-apps**, functions, governance, insights, process-mining, **review**, test |
| In-development | api-workflow, connector-builder, maestro-bpmn, maestro-case, maestro-flow, mcp-servers |

- **What each skill covers and when to load it.** These are the ones relevant to app development. All of them depend
  on `uip login status` passing first.

| Skill | Covers | Load when | Hard rules worth copying |
|---|---|---|---|
| `uipath-platform` | auth, Orchestrator (folders, assets, queues, buckets, jobs, triggers), IS, Data Fabric (`uip df`), LLM Gateway BYO, guardrails BYOG, traces, licensing | **before writing any code that calls a UiPath API** | CLI first; REST only after searching `references/uip-commands.md`. Never run interactive login. Pass `--profile` on every call |
| `uipath-coded-apps` | Coded Web and Action Apps, `@uipath/uipath-typescript`, push/pull to Studio Web, pack/publish/deploy, PKCE, Insights dashboards | scaffold, build or deploy a coded app, or SDK use inside one | identify the app type first; build before pack/push; never handle tokens; `api.uipath.com` base URL; `base: './'`; non-interactive `--folder-key`; inspect DF schema first; **every list call returns one page, so loop the cursor**; read the installed `.d.ts`, never guess signatures |
| `uipath-solution` | `.uipx` lifecycle: init, projects add/import, resources refresh, pack, publish, deploy run, activate, upgrade, upload | any `.uipx` or multi-project work | probe `uip solution init --help` once per session (rename fallback); always `--output json`; never hand-edit `resources/solution_folder/`; `resources refresh` before pack/upload; **verify the artifact after every mutation because exit codes lie**; one package with a per-environment `--config-file` |
| `uipath-rpa` | `.xaml` and `.cs` coded workflows, UIA, Object Repository, run/debug, test cases | any `.xaml`/`.cs`, or `project.json` with UiPath dependencies | `uip rpa init` only, with explicit `--target-framework` and `--expression-language`; `validate` per file then `build` per project; warnings do not block delivery; run verdict = `Data.errors` empty **and** `Data.output == "Session ended"`; never hand-write selectors |
| `uipath-agents` | low-code (`agent.json`) and coded (LangGraph, LlamaIndex, OpenAI Agents) agents: scaffold, eval, deploy, guardrails, memory | any agent lifecycle step | `uip codedagent new` for greenfield, never hand-author; `bindings.json` is always generated from SDK calls |
| `uipath-functions` | deterministic Python/TS functions (`uip function`), including Coded App backends | rule logic, transforms, HTTP backends | no LLM loop; use agents for that |
| `uipath-troubleshoot` | root cause across all products | "why did X fail", or a pasted error | guides before commands; raw output saved to `.local/investigations/raw/`; runtime evidence required; **approval gate and no self-edit** |
| `uipath-review` | read-only audit of RPA, agents, flows, BPMN, coded apps, solutions | pre-release review | read-only; validate and build first; route fixes to the owning skill |
| `uipath-planner` | PDD → SDD → multi-skill task list | PDD/SDD, or a multi-project build | a PDD always goes here first |
| `uipath-admin` | Identity (external apps, scopes, PATs), roles, audit | scopes, apps, access-denied | all audit goes through `uip admin audit` |
| `uipath-mcp-servers` | AgentHub MCP servers (`uip agenthub mcp`) | exposing UiPath resources as MCP tools | a folder is required on every call; personal workspace needs `--folder-key` |
| `uipath-aops` | StudioAdmin source control and CI/CD pipelines | "set up CI/CD" through UiPath pipelines | replaces the retired `uip sc`/`uip cicd` |
| `uipath-insights` | job metrics, failures, alerts (read-only) | health/KPI questions | no job start/stop |

### 1.3 Project context: discovery agent, `AGENTS.md`, `.claude/rules/project-context.md`

- `uipath-project-discovery-agent` (a Sonnet sub-agent shipped inside `uipath-rpa`) finds the project through an
  explicit path, then an open Studio instance, then the current directory, and it needs a `project.json` with UiPath
  dependencies. It **skips** empty or freshly scaffolded projects. It writes `.claude/rules/project-context.md` (Claude
  Code) **and** `AGENTS.md` (Autopilot and other agents) and returns the document, with a
  `<!-- discovery-metadata: cs=N xaml=N deps=N -->` header. [L-discovery]
- **Staleness rule:** re-discover when any of the counts (cs, xaml, deps) has changed by 60–70% or more. Otherwise
  reuse the file. Run discovery **at most once per session**. [L-rpa-env]
- `uipath-review` reads the root `AGENTS.md` as a PDD/requirements source. [L-review]
- It targets RPA projects (`project.json`), so a Coded Web App with no `.xaml`/`.cs` gets no context file from it.
  The framework has to supply its own context for app repos. [L-discovery] (inference)

### 1.4 MCP

- **`uip mcp serve`** runs over stdio and has one tool, `run_command` (a command string without `uip`). It lists every
  installed subcommand except `mcp` and `help`. It reads the stored session; if there is none, you get
  `AuthenticationError`. There are no destructive safeguards, so "treat it as an authenticated shell". Setup:
  `claude mcp add uipath -- uip mcp serve`. [U5][L-mcp]
- **UiPath-hosted MCP servers (Orchestrator/AgentHub).** Four server types (UiPath, Coded, Command, Remote) expose
  RPA, agents, API workflows, Maestro processes and IS activities *as tools for agents*. They are folder-scoped. Coded
  MCP servers are built with `uipath-python` and register themselves (they need `UIPATH_FOLDER_PATH`). This is for
  *runtime* agents to use UiPath, not for a coding agent to build apps. [U19][U20][L-mcp-servers]
- **Community Orchestrator MCP servers** exist on GitHub. They are not first-party and fall outside the "use the CLI"
  rule. [U21]
- **Claude Code side:** MCP tools are named `mcp__<server>__<tool>` and need explicit permission. For CLI-first work,
  plain Bash `uip …` calls with an allowlist are simpler to audit than a single catch-all `run_command`. [A1][U5]

### 1.5 SDKs

| SDK | Use | Key facts |
|---|---|---|
| `@uipath/uipath-typescript` (Coded Web/Action Apps) | browser apps on `<org>.uipath.host/<app>` | Node 20+ / npm 8+; `uipath.json` holds a non-confidential `clientId`, scopes and `redirectUri` (local dev only); the `@uipath/coded-apps-dev` bundler plugin injects meta tags in dev; at runtime construct the SDK **without arguments** (it reads the platform meta tags); `getAppBase()` for the router; Automation Cloud only. [U16][U22] |
| C# coded workflows (Studio) | `.cs` workflows and tests alongside XAML | data objects passed as arguments need an empty constructor; nested-class variables can't be used from low-code; `Parallel.ForEach` for speed. [U23] |
| `uipath-python` (+ `uipath-langchain`, LlamaIndex, OpenAI Agents, ADK, PydanticAI…) | coded agents, coded functions, coded MCP servers | `uipath new` / `init` (generates `entry-points.json` and `bindings.json`) / `run` / `debug` / `eval` / `pack` / `publish` / `invoke`; `@traced` on steps, never on the entry point; Python 3.11–3.13. [U24][U25][U26] |

Python SDK (you host it) vs coded agents (UiPath hosts it) vs Studio Web: it is the same Python either way; the
difference is who operates it. Moving code *into* Studio Web usually means a rebuild. [U27] (2026-09-15)

### 1.6 Studio Web and Autopilot

- **Autopilot is now a coding agent in Studio** (GA on 2026-08-12 in Studio STS S199+; full set in 26.10 LTS). A VS
  Code extension is in public preview and Studio Web support is "coming soon". It uses the **same skills and CLI**, and
  its usage is limited by per-user monthly quotas. [U28]
- Autopilot for Agents (Agent Builder chat) is in Preview. A low-code agent can be cloned as a coded Python project. [U29]
- **Studio Web and coded apps:** code is edited locally only and `push` uploads the source plus an optional
  `bindings_v2.json`. Studio Web shows the source read-only. `pull` restores the last pushed source. Studio Web "owns
  the project's identity, versioning, and publish lifecycle" for solution-native apps. Studio Web accepts **solutions
  only**, so a bare project is not visible there (`uip solution upload`). [U30][L-rpa]

---

## 2. Recommended workflows

### 2.1 Setup (one time per machine)
`npm i -g @uipath/cli` → `uip skills install` (use `--agent claude`) → the user runs `uip login` (or
`--profile dev`) → `/uipath:install-permissions` (Full with rails, project `settings.local.json`) → after any CLI
upgrade run `uip tools update` **and** `uip skills update`. [U2][U6][L-perms]

### 2.2 Ask for outcomes, not commands
"Ask for outcomes ('deploy this Solution to production'), not specific commands. The agent will chain pack → publish →
deploy run." When the agent gets stuck, it should run `uip <cmd> --help --output json` and read the result. [U2]
The troubleshoot skill is stricter: during a diagnosis, only commands that appear in its guides are allowed, with no
`--help` exploration. [L-troubleshoot]

### 2.3 Solution lifecycle (the deploy unit)
`init / projects add|import` → `resources refresh` → (optional `restore`) → `pack` → `publish` → `deploy run`
(auto-activates; use `--skip-activate` + `activate` for control) → `deploy upgrade` for later releases. Use
`uip solution upload` only for Studio Web debugging; it cannot be deployed. To promote across environments, use the
same package with `uip login tenant set` and `--config-file` for each environment. [L-solution]

### 2.4 CI/CD (UiPath recipe)
Node 22+, a pinned `@uipath/cli@x.y.z`, pre-installed tools (`uip tools install @uipath/orchestrator-tool
@uipath/solution-tool`), an npm cache keyed on the CLI version, and an **External App** login with
`--client-id env.UIPATH_CLIENT_ID --client-secret env.UIPATH_CLIENT_SECRET`. Setting the environment variables alone
does **not** log you in. Pass an explicit `--version` (default is 1.0.0), e.g. from the run number. Recipes exist for
GitHub Actions, Azure Pipelines, Jenkins and GitLab, and there is a sample repo. [U31][U32][U33]
For a headless coded-app publish, use `--scope "OR.Default Apps.Read Apps.Write"`; the two scope sets don't cover
each other. [L-coded-apps]

### 2.5 Local testing
- **RPA/coded workflows:** `uip rpa validate --file-path` per file, then `uip rpa build` for the project, then
  `uip rpa run` with `--output-filter` to capture `Data.errors`/`Data.output`. Don't `| tail` the raw output, because
  that drops the verdict fields. [L-rpa]
- **Coded agents:** `uipath run <entry> '<json>'`, `uipath eval` (eval sets), `uipath debug`. [U24]
- **Coded apps:** `npm run build` and `tsc -b` locally with the dev plugin. Deploy is done when the CLI reports
  success; **don't poll the URL**, because activation lags by minutes. [L-coded-apps][U16]

### 2.6 Jobs, logs, traces from the agent
Use `uip or jobs …` (start, get, logs), `uip traces` (spans, feedback) and `uip insights` (aggregates). Poll with
`jobs get <key>` (not rate limited), not repeated `jobs list`. Spend the `--export` quotas carefully. [L-platform][U18]

### 2.7 Debugging
Hand off to `uipath-troubleshoot`: anchor on the exact job, folder and time window; save raw CLI output; match
playbooks; require at least one runtime datum; get **approval before any fix**. Source fixes go to the owning skill;
cloud-state fixes are recommendation-only. [L-troubleshoot] (GA 2026-07-15 [U3])

### 2.8 Guardrails for the coding agent
- The user runs `uip login`; the agent only checks `uip login status`. [L-platform]
- Never read, print or pass tokens from `~/.uipath/.auth`. [L-coded-apps][U12]
- Deploy commands must never go interactive (folder picker); pass keys explicitly. [L-coded-apps]
- Enforce approval at the CLI/permission layer (`ask` rules), not only in prose. Skill text can be ignored by a model. [U34][L-perms]
- Build or edit requests stop at the local build; don't deploy unless asked (skills PR #3275). [U35]

---

## 3. Agentic automation on UiPath (what a coding agent should know)

- **Agents:** low-code (`agent.json`, Agent Builder in Studio Web) or coded (Python). They deploy as Orchestrator
  packages under normal governance. Coded agents can call assets, buckets, Context Grounding, Data Service and jobs
  through the SDK. [U25][U26]
- **Maestro** orchestrates agents, robots, APIs and people (BPMN, case management, and **Maestro Flow**, a
  developer-first layer announced 2026-08-19 and in public preview). It passes JSON in and out of agents and puts
  policy, audit and HITL at the orchestration layer. [U36][U37]
- **AI Trust Layer:** the **LLM Gateway** is the single entry point for all LLM traffic. It adds policies, audit logs,
  traces, PII masking, BYO-LLM and guardrails. **Context Grounding** is tenant-scoped RAG over managed indexes, and it
  runs through the gateway. In CLI terms: `uip` covers BYO LLM configs, BYO guardrail configs and context grounding under
  `uipath-platform`. [U38][U39][L-platform]
- **Governance:** AOps policies can block or enforce Agent Builder and AI Trust Layer features, and ToolUsePolicy
  controls agent→tool calls (`uipath-governance`). [L-skills]
- **For app work:** a Coded Web App normally *reads* agent, job and Maestro state through the TS SDK. It does not host
  an LLM itself. When logic is deterministic, prefer a coded function (`uip function`) over an agent. [L-functions] (inference)

---

## 4. Gaps and pitfalls practitioners report

| Area | Pitfall | Source |
|---|---|---|
| Auth | Agent runs `uip login` and hangs; `--no-browser` URL copy/paste is truncated; the callback port (8104) stays held for up to 5 min | [L-platform] |
| Auth | Skill told agents to `curl` with the cached token (fixed, #334/#401) | [U12] |
| Auth / scopes | Client-credentials publish needs `OR.Default` **and** `Apps.Read Apps.Write`; granular OR scopes don't replace `OR.Default` | [L-coded-apps] |
| Scopes | A 403 on `external-apps create/update` doesn't go away on retry; stop, diagnose, reuse an existing app | [U35] |
| CI auth | Env vars without `--client-id env.X` do nothing; tokens can expire in long pipelines | [U31] |
| Deploy | `codedapp deploy --folder-key` rejects valid keys on large accounts (incomplete folder list); use the `UIPATH_FOLDER_KEY` env fallback; **don't retry in a loop** | [U35] |
| Deploy | Blank page or URL-name errors after deploy: missing `base: './'`, router base, or absolute asset paths; worked only in the personal workspace | [U40][U16] |
| Packaging | Coded app in a solution also deployed via `codedapp` → registered twice, deploy config bypassed | [L-coded-apps] |
| Packaging | Hand-edited `resources/solution_folder/` goes out of sync with `.uipx`; a stale bindings ship without `resources refresh` | [L-solution] |
| Verification | Exit codes and the outer `Result` "lie"; verify files and status afterwards | [L-solution][L-rpa] |
| Version drift | Skills called commands that don't exist (`uip flow`, `uip case`) | [U13] |
| Version drift | CLI↔Studio IPC mismatch: `get-errors` hangs, `run-file` throws | [U14] |
| Version drift | Host/tool MAJOR.MINOR mismatch; fix with `uip tools update --name` | [U9][U41] |
| Rate limits | Jobs/QueueItems lists are rate limited; Export allows 100/day per tenant; agents polling `jobs list` burn the quota | [U17][U18] |
| SDK | `getAll()` returns one server-capped page (`NonPaginatedResponse`); reading `.items.length` is a bug | [L-coded-apps] |
| SDK | Guessed method signatures; the fix is to read the installed `.d.ts` | [L-coded-apps] |
| Studio Web | Accepts solutions only; a pushed coded app is read-only there; push/pull conflict behaviour is not documented | [L-rpa][U30] |
| XAML | Text edits break XAML structure (namespaces, IdRef); the community asked for a CoreWF-aware editing tool and activity metadata | [U42] |
| Maturity | Umbrella GA ≠ each skill GA; coded-apps and review are still Preview | [U34][L-README] |
| Governance | "Approval theater": an approval with no concrete diff or target gives false comfort; logs sent to the model can expose data | [U34] |
| Docs gaps | Coded agents docs don't cover LLM Gateway or grounding limits; Studio Web push/pull conflicts undocumented; the CLI versioning page moved (old URL 404s) | [U25][U30] (seen) |

---

## 5. Best practices for a small team (imperative, why, source)

1. **Install with `uip skills install`, and after every CLI bump run `uip tools update && uip skills update`.**
   Skills, host and tools drift, and old skills call commands that no longer exist. [U6][U13][U41]
2. **Record `uip --version` and `uip tools list --output json` in the repo's platform inventory, and pin the CLI version on CI.**
   This makes drift between laptop and CI visible. [U14][U31]
3. **Let only the human run `uip login`; the agent runs `uip login status --output json`.**
   The browser callback cannot be completed from the agent's shell. [L-platform]
4. **Use a named `--profile` per environment and pass it on every call.**
   A missing profile does not fall back to another one, so there is no silent cross-tenant mistake. [L-platform][U11]
5. **Use a dedicated least-privilege identity for agent work, and an External App or OIDC for CI.**
   The agent acts as whoever is logged in. [U7][U31]
6. **Call `uip` with `--output json` (and `--output-filter`); never hand-roll REST while a command exists.**
   The CLI handles folder headers, pagination, retry and the envelope. [L-platform][L-solution]
7. **Judge success by `Data` and by reading the artifact back, not by exit code or `Result`.**
   Pack, deploy and run can report "Success" and still be broken. [L-solution][L-rpa]
8. **Install `/uipath:install-permissions` with the safety rails; keep `publish`, `deploy`, `upload`, `login` and `debug` on `ask`.**
   Only settings and hooks actually enforce anything; skill prose doesn't. [L-perms][U34]
9. **Ship through the solution (`uip solution pack → publish → deploy run/upgrade`) with an explicit `--version`.**
   It gives one versioned unit that promotes across tenants with config files. [L-solution][U31]
10. **Run `uip solution resources refresh` before pack/upload, and never hand-edit `resources/solution_folder/`.**
    Stale bindings ship silently. [L-solution]
11. **In coded apps, read the installed `.d.ts` before using any SDK method, and loop the cursor on every list.**
    Guessed signatures and single-page reads are the most common SDK bugs. [L-coded-apps]
12. **Set `base: './'`, use `getAppBase()` for the router, and import assets through the bundler.**
    Otherwise you get a blank page or 404s under the app sub-path. [U16][U40]
13. **Deploy non-interactively with an exact folder key (resolved with `--all --name` and an exact match); never retry-loop a folder-key rejection.**
    The picker hangs in agent shells, and the pre-check can reject valid keys. [L-coded-apps][U35]
14. **Poll jobs with `jobs get <key>`, not `jobs list`; budget `--export` calls.**
    Rate limits allow 100/min for lists and 100/day for exports. [U17][U18]
15. **Send "why did X fail" to `uipath-troubleshoot` and let it propose; the human approves the fix.**
    It only accepts evidence and forbids self-edits. [L-troubleshoot]
16. **Run `uipath-review` (read-only) before each release, alongside `rpa validate/build` or `tsc -b`/tests.**
    The reviewer is separate from the builder. [L-review]
17. **Let the discovery agent write `project-context.md`/`AGENTS.md` for RPA projects; keep your own context for app repos.**
    It gives cheap, fresh context and skips non-RPA or empty projects. [L-discovery]
18. **Keep secrets in a secret store or CI secrets and pass them as `env.VAR`; never in prompts, files or git.**
    The docs say so explicitly, and it keeps secrets out of shell history. [U7][U11]
19. **Check a skill's status (Stable/Preview/In-dev) before relying on it for a release step.**
    Maturity varies from skill to skill. [L-README][U34]
20. **When the agent is unsure of a command, have it read `uip <cmd> --help --output json` or `uip docsai`; don't let it guess flags.**
    The help output is the source of truth. [U2][L-help]

---

## 6. Recommendations for the framework's UiPath add-on

### 6.1 Add to `platforms/uipath-framework.md`

1. **"Toolchain" section:** the CLI, skills plugin and tools model; the drift check commands; the rule that CLI, tools
   and skills are upgraded together; and a table of skill status copied from `skill-status.json` with a "last checked"
   date.
2. **"Identity for agents" section:** human `uip login --profile <env>`; the agent checks status only; a dedicated
   least-privilege identity; External App or OIDC for CI; the scope rule for headless coded-app publish
   (`OR.Default Apps.Read Apps.Write`); `env.VAR` secrets. Link it to the framework's existing "only two external apps"
   and "each endpoint needs its own scope" lessons.
3. **"CLI contract" section:** the envelope, exit codes, "verify the artifact, not the exit code", `--output-filter`
   recipes, and the `rpa run` verdict rule.
4. **"Deploy paths" decision table:** a standalone coded app uses `codedapp pack/publish/deploy`; an in-solution
   (AppV2) app uses `uip solution …` only; `upload` is for Studio Web debugging only; `deploy upgrade` is for existing
   deployments. Add the pre-deploy checklist (`base: './'`, router base, bundler assets, folder key) and the "deploy
   done = CLI success; verify by the served content hash, not the URL or version" rule (from r1).
5. **"API budgets" section:** Jobs and QueueItems list limits, export quotas, and polling with `jobs get`.
6. **"Permissions" section:** the `/uipath:install-permissions` Full variant; the framework's own PreToolUse hook to
   block `uip login` from the agent and `cat ~/.uipath/.auth`/`curl …uipath.com` (defence in depth for #334-style
   behaviour).
7. **"Troubleshoot and review" section:** when to hand off to `uipath-troubleshoot` and `uipath-review`, and their
   approval and no-self-edit gates, which match the framework's "verifier ≠ builder" principle.
8. **"Known pitfalls" table:** section 4 of this report, kept as a living list with dates.

### 6.2 Add to the `/new-app` skill (UiPath branch)

1. **Preflight (read-only, automatic):** `uip --version`; `uip tools list --output json` (all `ok` on the same
   MAJOR.MINOR); check the skills plugin is present (`uipath:` skills listed); `uip login status --profile <env>
   --output json`. If not logged in, **ask the user to run `! uip login --profile <env>`**. Record the results in
   `docs/platform-inventory.md`.
2. **Question batch (U* bank):** app type (Coded Web App / Action App / RPA / coded agent / function); standalone vs
   in-solution (recommend **in-solution** when a collector process or other projects will ship with it); target folder
   and routing name; user identity (PKCE, non-confidential client) vs app identity (External App); scopes per
   endpoint; environments and profiles.
3. **Skill load order** (tell the agent explicitly):
   `uipath-platform` (auth and API rules, always first) → `uipath-planner` (only when there is a PDD/SDD or several
   projects) → the artifact skill (`uipath-coded-apps` | `uipath-rpa` | `uipath-agents` | `uipath-functions`) →
   `uipath-solution` (pack/publish/deploy) → `uipath-review` (pre-release, read-only) → `uipath-troubleshoot` (on
   failure only). Load `uipath-admin` only for external apps, scopes or roles.
4. **Scaffold only with the CLI:** `uip solution init` → `uip codedapp init` inside the solution (or `uip rpa init
   --target-framework … --expression-language …`, `uip codedagent new`). Never hand-write `project.json`, `.uipx`,
   `pyproject.toml` or `resources/`.
5. **Context:** for RPA projects, spawn `uipath:uipath-project-discovery-agent` once, after the first authored
   workflow exists. For app repos, have `/new-app` write `.claude/rules/project-context.md` itself (stack, SDK version,
   folder, scopes, deploy path) so both conventions are present. Add a pointer in `AGENTS.md` for non-Claude agents and
   Autopilot.
6. **Permissions:** offer `/uipath:install-permissions` (Full, `settings.local.json`) and install the framework's
   PreToolUse guard hook.
7. **MCP:** **don't add `uip mcp serve` by default.** Skills and Bash plus an allowlist cover it, and `run_command` is an
   unguarded authenticated shell. Offer it only for MCP-only clients, and then gate it with `ask`. AgentHub MCP servers
   are a *runtime* design choice for agent projects, not a dev tool.
8. **Gates in the generated plan:** the build gate (`tsc -b` + tests, or `rpa validate/build`), the review gate
   (`uipath-review`), the deploy gate (explicit user OK, dry `--help` probe, explicit `--version`, `--folder-key`), and
   the post-deploy gate (read back the deployment status plus content hash; no URL polling).
9. **CI template:** copy the UiPath GitHub Actions recipe shape (pinned CLI, pre-installed tools, cache, External App,
   `--version` from the run number). Leave it disabled until the user provides the External App.

---

## Sources

Web (all seen 2026-09-26):

- [U1] UiPath for Coding Agents, Overview. https://docs.uipath.com/coding-agents/standalone/latest/user-guide/overview
- [U2] UiPath CLI, Using UiPath CLI with Coding Agents. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/coding-agents
- [U3] UiPath for Coding Agents, release notes July 2026 (2026-07-08, 07-15, 07-31). https://docs.uipath.com/coding-agents/standalone/latest/release-notes/july-2026
- [U4] UiPath for Coding Agents (developer page). https://www.uipath.com/developers/coding-agents
- [U5] UiPath CLI, `uip mcp`. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/uip-mcp
- [U6] UiPath CLI, Skills (concepts) and `uip skills`. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/concepts-skills ; https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/uip-skills
- [U7] UiPath for Coding Agents, Governance and trust. https://docs.uipath.com/coding-agents/standalone/latest/user-guide/governance-and-trust
- [U8] UiPath for Coding Agents, Choosing your agent. https://docs.uipath.com/coding-agents/standalone/latest/user-guide/choosing-your-agent
- [U9] UiPath CLI, Versioning and stability. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/versioning
- [U10] UiPath CLI, About UiPath CLI. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/about-uipath-cli
- [U11] UiPath CLI, `uip login`. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/uip-login
- [U12] UiPath/skills issue #334, coded-apps skill bypasses `uip` with curl (2026-04-22). https://github.com/UiPath/skills/issues/334
- [U13] UiPath/skills issues #333 and #337, wrong command names (2026-04-22). https://github.com/UiPath/skills/issues/333 ; https://github.com/UiPath/skills/issues/337
- [U14] UiPath/skills issue #261, CLI and Studio IPC mismatch (2026-04-16). https://github.com/UiPath/skills/issues/261
- [U15] UiPath/skills README. https://github.com/UiPath/skills/blob/main/README.md
- [U16] UiPath TypeScript SDK, Coded Apps getting started. https://uipath.github.io/uipath-typescript/coded-apps/getting-started/
- [U17] Orchestrator API guide, Rate limits and large data fields. https://docs.uipath.com/orchestrator/automation-cloud/latest/api-guide/rate-limits
- [U18] UiPath/skills PR #3485, Orchestrator API limits reference. https://github.com/UiPath/skills/pull/3485
- [U19] Orchestrator, About MCP Servers / MCP Server types. https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/about-mcp-servers ; https://docs.uipath.com/orchestrator/automation-cloud/latest/user-guide/mcp-server-types
- [U20] uipath-python, Coded MCP Servers quick start. https://uipath.github.io/uipath-python/mcp/quick_start/
- [U21] Community Orchestrator MCP servers (not first-party). https://github.com/MrAk47Anand007/uipath-orchestrator-mcp
- [U22] UiPath/uipath-typescript repo. https://github.com/UiPath/uipath-typescript
- [U23] Studio, Coded automations best practices. https://docs.uipath.com/studio/standalone/latest/user-guide/coded-automations-best-practices
- [U24] uipath-python, Python Coded Agents. https://uipath.github.io/uipath-python/core/agents/
- [U25] Agents, About coded agents. https://docs.uipath.com/agents/automation-cloud/latest/user-guide/about-coded-agents
- [U26] UiPath/uipath-langchain-python. https://github.com/UiPath/uipath-langchain-python
- [U27] UiPath blog, Python SDK vs Coded Agents vs Studio Web (2026-09-15). https://www.uipath.com/blog/product-and-updates/python-sdk-vs-coded-agents-vs-studio-web
- [U28] UiPath Forum, Autopilot is now a coding agent in Studio, GA (2026-08-12). https://forum.uipath.com/t/autopilot-is-now-a-coding-agent-in-studio-generally-available/5768853
- [U29] Agents, About Autopilot for Agents. https://docs.uipath.com/agents/automation-cloud/latest/user-guide/about-autopilot-for-agents
- [U30] Studio Web, Coded Apps in Studio Web. https://docs.uipath.com/studio-web/automation-cloud/latest/user-guide/coded-apps-in-studio-web
- [U31] UiPath CLI, How-to: deploy to Orchestrator from CI. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/howto-deploy-from-ci
- [U32] UiPath CLI, CI/CD recipe: GitHub Actions. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/recipes-github-actions
- [U33] UiPath-Product/UiPath-CI-CD-YAML-Sample. https://github.com/UiPath-Product/UiPath-CI-CD-YAML-Sample
- [U34] SandBase blog, UiPath for Coding Agents: An Operator's Guide (2026-08-20). https://blog.sandbase.ai/uipath-for-coding-agents-enterprise-automation-2026/
- [U35] UiPath/skills PR #3275, deploy folder-key pre-check, 403 stop rule, build-only (merged 2026-09-15). https://github.com/UiPath/skills/pull/3275
- [U36] Maestro, Using agents in Maestro. https://docs.uipath.com/maestro/automation-suite/2.2510/user-guide/using-agents-in-maestro
- [U37] ADTmag, UiPath targets coding-agent orchestration with Maestro Flow (2026-08-20; page returned 403 on fetch, summary from search result). https://adtmag.com/articles/2026/08/20/uipath-targets-coding-agent-orchestration-with-maestro-flow.aspx
- [U38] Automation Cloud, About AI Trust Layer. https://docs.uipath.com/automation-cloud/automation-cloud/latest/admin-guide/about-ai-trust-layer
- [U39] Automation Cloud, About Context Grounding. https://docs.uipath.com/automation-cloud/automation-cloud/latest/admin-guide/about-context-grounding
- [U40] UiPath Forum, Blocker to deploy Coded App developed using Coding Agents (2026-05-21 to 06-01). https://forum.uipath.com/t/blocker-to-deploy-coded-app-developed-using-coding-agnets/5747721
- [U41] UiPath CLI, Managing tools and skills. https://docs.uipath.com/uipath-cli/standalone/latest/user-guide/managing-tools-and-skills
- [U42] UiPath Forum, Two feature requests for the UiPath Skills repo (2026-03-26). https://forum.uipath.com/t/two-feature-requests-for-the-uipath-skills-repo-looking-for-community-input/5732963
- [U43] UiPath Forum, UiPath for Coding Agents with Claude Code, full tutorial (2026-08-24). https://forum.uipath.com/t/uipath-for-coding-agents-build-anything-with-claude-code-full-tutorial/5771942
- [A1] Claude Code Docs, Connect Claude Code to tools via MCP. https://code.claude.com/docs/en/mcp

Local (read-only, 2026-09-26):

- [L-help] `uip --help --output json` (CLI 1.202.1). [L-tools] `uip tools list --output json`. [L-mcp] `uip mcp --help`, `uip mcp serve --help`.
- [L-README] `~/.uipath/.skills/README.md` + `assets/skill-status.json` (`@uipath/skills` 1.202.2). [L-hooks] `hooks/hooks.json`. [L-perms] `commands/install-permissions.md`.
- [L-platform] `skills/uipath-platform/SKILL.md`. [L-solution] `skills/uipath-solution/SKILL.md`. [L-coded-apps] `skills/uipath-coded-apps/SKILL.md`. [L-rpa] `skills/uipath-rpa/SKILL.md`. [L-rpa-env] `skills/uipath-rpa/references/environment-setup.md` § Project Context Discovery. [L-discovery] `skills/uipath-rpa/agents/uipath-project-discovery-agent.md`. [L-troubleshoot] `skills/uipath-troubleshoot/SKILL.md`. [L-review] `skills/uipath-review/SKILL.md`. [L-mcp-servers] `skills/uipath-mcp-servers/SKILL.md`. [L-functions] `skills/uipath-functions/SKILL.md`. [L-skills] skill descriptions (governance, admin, aops).
