# R1 — Lessons from the previous project, made generic

> **Origin (for context only):** a licensing/usage dashboard for an enterprise automation platform. It had a
> browser web app (user sign-in, PKCE), a scheduled server-side "collector" job (app identity), and the platform's
> managed data store, built by one user with Claude Code and a team of sub-agents over about two weeks. Everything
> below is written to work for any stack or platform. Platform-specific terms are replaced with generic ones
> ("the platform's group import", "the platform's job runner", "config assets").
>
> **Source keys used in brackets:**
> - `mem:<file>`: the project's auto-memory files (`feedback_*`, `project_*`, `reference_*`)
> - `IS`: implementation-status.md (How we work, Git branching, Access model, Data detail tiers, Demo data rule, Multi-agent approach, Personas, Board)
> - `CW`: completed-work.md
> - `ARCH`: architecture.md
> - `INV`: platform-inventory.md
> - `PGB`: persona-gaps-briefs.md
> - `DEMO`: demo-script.md
> - `ADW`: app-direct-writes-plan.md
> - `HO`: the customer HANDOFF.md
> - `REPO`: the repo CLAUDE.md
> - `git`: the commit log
> - `S`: an incident from the final session, taken from the brief because no transcript was available

---

## 1. Working agreements with the user

Each item gives the rule, then why, then how to apply it.

1. **Plan and ask before you build, every time, even for small UI tweaks.**
   - *Why:* the agent jumped straight into edits and investigation three times, and the user corrected it each time. The user wants to steer choices, not review surprises.
   - *How:* the first reply is a short plan (what changes, what it touches) plus the open choices as structured questions, each with a recommendation. Build only after the answers. One question with 2–3 options is enough for a small ask. Pure "what is this?" questions get a direct answer, then an offer to plan. [mem:feedback_ask_questions_when_asked_to_plan, IS How we work]
2. **One step, or one page, at a time, then stop.**
   - *Why:* the user reviews and questions each finished piece before the next one starts. A big batch at the end hides mistakes.
   - *How:* finish one roadmap step or page, verify it, report it, and wait. Don't chain items in one turn. [mem:feedback_step_by_step_one_page_at_a_time]
3. **Ground yourself in the docs and memory before you ask or design.**
   - *Why:* the user had to re-send API details they had already given ("I've sent this to you multiple times").
   - *How:* read the architecture doc and the memory first. When you discover a new fact live, write it into the architecture doc (or memory) in the same turn, so nobody has to ask for it again. [mem:feedback_check_docs_before_reasking_api]
4. **Validate every data or API claim live, and look for alternatives.**
   - *Why:* the first endpoint or field tried was wrong or incomplete again and again. It took several tries to find the right allocation endpoint, and a paging bug silently cut results at 200.
   - *How:* before you say "the API does or doesn't support X", check memory and docs, test it live (read-only), and name any other endpoint, scope or source that could serve the need better. [mem:feedback_validate_apis_check_alternatives, mem:project_live_historical_data_migration]
5. **When the docs and live behaviour conflict, ask. Don't declare.**
   - *Why:* one live test "disproved" a documented permission, and the test itself was flawed: the endpoint needs its own narrow scope. It took two rounds of wrong conclusions to find that.
   - *How:* name both claims, check for a confound (what the test principal's real permissions were, each endpoint's documented scope in the spec), then ask the user. [mem:feedback_ground_in_docs_ask_about_gaps]
6. **Don't design on a guess.**
   - *Why:* twice, a menu of options was built on a wrong reading of the request. The real answer was a flag on an endpoint already in use.
   - *How:* if no code, doc or recorded traffic (HAR) grounds a capability, ask for a reference ("do you have an example?"). Don't offer invented options. Missing code shows the feature hasn't been built; it doesn't tell you what the request means. [mem:feedback_verify_before_speculating_on_capabilities]
7. **A rule change is a question for the user.**
   - *Why:* a new table broke a recorded "no tables on the Dashboard" rule and its test, and the agent started working around it without asking.
   - *How:* treat a failing test or doc note that encodes a past decision as a question. Name the rule and where it's recorded, give the options, and let the user decide. Record the change beside the old rule, dated, with the old text struck through, so the history stays visible. [mem:feedback_rule_changes_ask, IS]
8. **Use the domain's language and the user's business framing.**
   - *Why:* the user's employer sells the licenses. Wording like "reclaim" or "under-utilized" works against the business.
   - *How:* keep a vocabulary list: "rebalance, then free for new automations", with the verdicts *At capacity / Room to grow / Ready for automations*. Show a shortfall as "licenses needed". Keep a fixed domain sort order (most to least costly type) and the vendor's official names. Put the vocabulary in the playbook, so builders and demo writers follow it too. [mem:feedback_growth_framing_not_reclaim, mem:feedback_robot_types_cost_order_and_names]
9. **Demo data must be real-shaped.**
   - *Why:* "we have to base on data we have access to". A demo-only feature misleads the audience. The demo had per-tenant user pools that can't exist, because user licenses are org-wide, and a "disabled" flag read from the wrong field.
   - *How:* the values may be made up. Every field and signal must be one the real collector produces today, or will produce through a change that ships before the demo. Otherwise remove it or label it "not available yet". Enforce this with a demo-data audit test. [mem:feedback_demo_data_real_shaped, IS Demo data]
10. **Key by id, never by display name.**
    - *Why:* two distinct folders in production had the same name, so name-keyed maps merged or overwrote their data and a child total no longer equalled its parent.
    - *How:* every Map, grouping or drill-down lookup uses the real id (a composite id where needed). Keep the name only as a label ("latest name wins"). Audit the neighbouring code whenever you fix one case. [mem:feedback_always_key_by_id_not_name, git a6f21a7]
11. **Least privilege, groups only, no shared roles.**
    - *Why:* enterprise auditability. Each assignment should read "group X has role Y", and a change to one group must never widen another's access.
    - *How:*
      - one dedicated role per group at every level (folder, tenant, entity), even when the permissions are identical today;
      - never reuse built-in roles or another app's roles;
      - grant to local groups only, and let the customer nest directory (Entra/AD) groups inside them;
      - flag direct user grants as violations;
      - make the roles differ, so the app can tell them apart;
      - the server enforces access and the UI only hides buttons.
      [mem:feedback_rbac_no_shared_roles, IS Access model, ARCH Access groups]
12. **Only N permanent integration apps.**
    - *Why:* stale leftover app registrations caused a long "persistent 403" investigation.
    - *How:* use exactly one user-delegated app and one app-identity app. New capabilities add scopes to these. Throwaway test apps are allowed only if you delete them right after (two debug apps were found days later). Scope updates *replace* the whole list, so read it first and send every existing scope plus the new one. [mem:feedback_two_external_apps_only, INV change log]
13. **Test as the identity that will really run the code.**
    - *Why:* a user token copied from a browser session succeeded at things the real app-identity collector can't, and that led to a dead-end investigation.
    - *How:* use a throwaway app-scope client with its access verified as zero, not a delegated token. Test delegated only for the web app's own sign-in path. [mem:feedback_prefer_app_scope_over_delegated]
14. **One naming convention for every artifact.**
    - *Why:* "so I can go to roles, assets, entities… and know what ties to the app".
    - *How:* name everything `<App> - <Type> - <Item>`, with a code-safe twin `<App>_<Type>_<Item>`. Choose a general app name early, so the app can outgrow its first scope (the name went from unit-specific to license-general). Fold renames into one planned redeploy. [mem:feedback_naming_convention, mem:project_licensing_dashboard_direction]
15. **Record every live platform change in an inventory and in the handoff.**
    - *Why:* a customer install must reproduce the exact setup, and RBAC must stay auditable.
    - *How:* after any live change (apps and scopes, assets, entities, groups, roles, triggers), read the state back with the CLI and update the tracked inventory doc and its copy in the handoff, with ids, scopes and a dated change-log line. The agent runs the CLI itself instead of asking the user to. [mem:feedback_record_platform_changes_in_handoff, INV]
16. **Git: main = deployed, develop = integration, tags.**
    - *Why:* the user noticed undeployed work landing on `main`.
    - *How:*
      - `main` moves only after a verified deploy, and gets the tag `v<version>`;
      - builders branch from `develop`, and the coordinator merges into `develop`;
      - the handoff snapshot syncs from `main`, never from `develop`;
      - never commit to `main` directly.
      [mem:feedback_git_branching, IS Git branching]
17. **Push to the remote only after a commit list, a secret scan and the user's OK.**
    - *Why:* a push is outward-facing and irreversible.
    - *How:* show the commits, scan for secrets and large files, get explicit confirmation, then fast-forward only, never force. [mem:feedback_git_branching]
18. **Keep dev, the shipped snapshot and scratch separate.**
    - *How:* only `development/` is in git. `customer-handoff/` is a gitignored snapshot of the *shipped* state, updated only right after a verified deploy, with its own change log. `archive/` holds scratch and is never committed. [REPO, mem:project_folder_structure]
19. **Put secrets only where they belong.**
    - *How:* a credential lives in the platform's credential store and in process memory. Read the local secret file only after a test fails. Never copy a secret into the repo, config, memory or logs, and scrub tokens and response bodies from exceptions. [mem:feedback_upload_procedure_assets, ARCH Identity and secrets]
20. **Know which changes need a real deploy.**
    - *How:* sort each change first. Server-side work (job, schema, triggers, assets) needs a real push and deploy before it counts as done. Frontend-only work is verified on the local dev server. [mem:feedback_push_to_studio_web_vs_localhost]
21. **Ship the whole release unit, not its pieces.**
    - *How:* use component pushes only for interim checks. The durable deploy is the whole bundle (solution or package), so its parts stay in sync. Check the live version before you bump, because the tool computed the next version from a local file that had drifted. [mem:feedback_push_solution_not_components, mem:feedback_check_version_before_push]
22. **Removing a tracked resource from the release deletes it.**
    - *Why:* a credential was untracked to stop deploys wiping its secret, and the next upgrade deleted it outright.
    - *How:* treat untracking a live resource as a delete. Keep it tracked, and re-enter the secret after the deploy instead. [mem:feedback_keep_credential_tracked]
23. **Config lives in the app's data store; deployment values live in assets.**
    - *How:* put app settings (thresholds, SLAs, owners) in a config entity. Keep assets for deployment-level values. Create new assets in a personal workspace, import them as release resources, and let the user deploy. [mem:feedback_solution_assets_via_workspace]
24. **Track all work on one board.**
    - *How:* see §2. The coordinator updates it on every merge, every agent start or finish, and every user decision. [mem:feedback_track_work_in_implementation_status]

---

## 2. The multi-agent operating model as actually used

**Roles** [IS Multi-agent approach, mem:feedback_multi_agent_approach]

| Role | Owns | Hard rules |
|---|---|---|
| **Coordinator** (main session) | Plans with the user; owns the board, the architecture doc and memory; merges; fixes conflicts; decides; starts agents; runs platform CLI changes (only after the user agrees) | The only one that edits docs and memory, merges, or changes the live platform |
| **Builders** | One agreed page or feature each, in its own **git worktree** branched from `develop`, following the plan row and the existing patterns | Copy the env file and run a clean install. No docs or memory edits, no platform CLI. Append CSS at the end of the stylesheet. Commit on their own branch only and never merge. No browser checks (worktree dev servers can't sign in) |
| **Build manager** | After each merge: a real type-check, all tests, a grep for conflict markers, the diff against the plan row, and a browser check at 3 widths. Gives a verdict | Read-only |
| **GUI testers** (1–2, **always running** while builders work) | Tester 1: core functions. Tester 2: a full layout sweep plus bug rechecks. Both rerun after each merge wave and give a SHIP/NO-SHIP or GO verdict | Each has its **own persistent browser profile** (two testers can't share one). Sign-in: SSO button + the user's account only. Never type a password. On a password or MFA prompt, stop and ask the user to sign in in a headed window |
| **Research / verify agents** | API checks against the docs, deploy verification (job, logs, assets), decision briefs, data audits | No writes anywhere; report with sources |
| **Docs builder / writer** | Demo scripts, briefs, handoff text | Writes only its own target doc |
| **On-call general agent** | Ad-hoc research, a verification, a small fix while builder slots are busy | Builder rules when it writes code; not kept running idle |

- **Agent count:** it started at 2 builders, rose to 5 agents in total, and ended with no fixed cap ("spin up as many agents as you need"). The real constraint: **parallel builders must work on separate files or areas.** [IS]
- **Be proactive:** the coordinator starts agents on its own for agreed or read-only parallel work and records each one on the board. Decisions still go to the user. [IS, mem:feedback_multi_agent_approach]

**The flow:** plan and questions → a plan row on the board → a builder in a worktree → the coordinator merges (conflict-marker grep, brace balance) → the build manager and GUI testers verify → the user reviews on the dev server in parallel → follow-ups. Server-side items go on a "next upload" list. [IS]

**How prompts were written** (the pattern that worked)
- **Context:** the plan row, the relevant rules (personas, vocabulary, demo-data rule, key by id), the files and patterns to follow, and the current branch or commit.
- **Constraints:** which worktree and branch to use; the files it may touch; "don't touch" lists (docs, memory, stylesheet except by appending, other builders' areas); no deploys and no platform CLI; the secrets policy.
- **Done means:** type-check clean, tests green with the new tests named, and data limits labelled on the page.
- **Report format:** what changed with the commit hashes, tests added or passing, any deviations or estimates ("data limits are the builder's call only when labelled and reported"), open questions, and exact paths. [IS lessons]
- **Contracts first when two builders share a feature:** fix a shared contract (a JSON example of each record) before starting, so neither waits. Give page wiring that touches hot files to a single builder, last. [PGB §1 build plan]

**Delegated decision windows** [IS]
- For a set window, the user let the coordinator answer questions itself, reasoning as each persona and as the backend developer.
- Every such decision is marked **(coordinator decision)** in the tracker, so the user can review or reverse it.
- Always excluded: deploys, destructive live changes, and anything that widens access.

**The board** [mem:feedback_track_work_in_implementation_status, IS Board]
- Order: **WIP** (item · owner agent · started · what "done" means) → **Next** (ordered) → **Waiting on the user** → **Completed** (dated one-liners with commits, linking to a separate completed-work log).
- Every line has a priority, and lists are sorted by it: **P0** blocks the release or the demo · **P1** improves it, or ships if ready · **P2** after.
- Finished detail moves out to completed-work, so the board stays short. A "Loose ends carried over" table catches open points buried inside finished rows.
- Builders never edit the board.

**What went wrong, and the fixes**

| Problem | Fix |
|---|---|
| Parallel builders in one folder committed each other's half-done changes | Worktrees are mandatory [IS] |
| A scripted merge committed conflict markers | Grep for `<<<<<<<` before every merge commit [IS, git 686bae1] |
| Removing markers left `@media` blocks unclosed, so every later CSS rule applied only on phones | A brace-depth-0 test on the stylesheet [IS, git aa5ca94, LayoutFit.test] |
| One agent ran another agent's scratch script in the shared scratchpad | Every agent uses uniquely prefixed file names and never runs another agent's files [IS, S7] |
| A session or rate limit stopped every agent at once | Check each worktree's state, then **resume** each agent with its context; don't restart from scratch [IS, S8] |
| Worktree dev servers can't complete SSO | Browser checks happen after the merge, on the main dev server [IS] |
| Two testers on one browser profile clashed | One persistent profile per tester [IS WIP GUI testers] |

---

## 3. Persona practice

- **Define the reader personas early, each with their own question** [IS The personas, mem:feedback_analyst_review_each_page]:

  | Persona | Their question |
  |---|---|
  | Specialist / analyst | "Is it sized right and used well?" |
  | Business owner | "Is it delivering, and growing?" |
  | Production support | "Is anything broken or quiet?" |
  | Finance | "Who uses what share, and what do we bill?" |

  Keep this table at the top of the tracker and read it before planning any page.
- **Review every page per persona before building.** Ask "what would <persona> find concerning at this level?" List the concerns (sizing, waste, trend and risk, chargeback), mark each with its **data availability** (have / approximate / needs collection), ask which ones to adopt and how to show them (icon signals, a sortable table, KPI tiles), then plan and ask again. [mem:feedback_analyst_review_each_page]
- **Take a standing role.** On any GUI change, the agent acts as the domain specialist without being asked: what the figure means, where waste or risk hides, what to act on, and whether the wording would hold up with the owner. [mem:feedback_analyst_review_each_page]
- **Add a persona switch to the page.** An "All" bar plus one card per persona with a headline; sections tagged per persona. The choice is shared across pages and remembered per browser. On phones, a tag line plus columns. [mem:project_robots_persona_review]
- **Answer first, figures second.** Every dashboard gives a direct verdict ("Room to grow: N free"), not raw figures to interpret. An early overview failed because it didn't say over- vs under-utilized. [mem:project_licensing_dashboard_direction, mem:feedback_reference_licenselens_value_props]
- **Benchmark against a reference app.** When a prior or competitor tool exists, review it *before* asking questions, list which of its value props each page delivers, and say plainly when your data can't support one yet. [mem:feedback_reference_licenselens_value_props]
- **Write value stories.** Turn data into decisions: "units spent on failed runs", "room for ~N more runs like X", "next-term sizing (estimate from trend)". Real data only, estimates labelled. [IS WIP value stories, PGB]
- **Run a gap review later.** Most pages answer "what's happening". Fewer answer "what do I do, and who do I talk to?" Plan for owner or cost center, action tracking, digests and renewal planning. Write one decision brief per gap (source data, options with a recommendation, effort, open questions). [IS Persona gaps, PGB]
- **Give each persona its own demo tour.** One tour per persona, plus one for the internal audience, each step opening its page by id. The script matches the in-app tour step for step, computes its figures from the preview data, and has a checklist and an "avoid" list (live mode, destructive buttons, forbidden words). Tests cap tour length (≤8 steps, ≤2 sentences per step). [DEMO, DemoTour.test]

---

## 4. Data architecture lessons

- **One scheduled sync is the single source.** A nightly sync feeds every page. Pages read only the snapshot and show "Data as of …". One admin-only "Refresh snapshot now" runs the same sync; nobody else gets an on-demand refresh. Offer only pre-computed ranges. When someone needs live status, link to the source system's console instead of reading it in the app. The rule took several turns to settle (live reads, then cheap live APIs, then snapshot only). Decide it early. [mem:feedback_prefer_live_cheap_apis, IS Data rule]
- **Store only what you can't read cheaply.** Store history and aggregates the APIs can't give cheaply. Current state that one call answers can be read live, or linked out. **Never store raw events.** Store aggregates only, with a test that no raw fields leak into stored documents. [mem:feedback_prefer_live_cheap_apis, CW R4 2c]
- **Keep tiered retention** [mem:project_tiered_history_retention, IS Data detail tiers]:
  - fine daily data for about 120 days, then weekly to about 6 months, then monthly (13 months rolling, an admin setting);
  - re-read the last few days each night for late data;
  - a week or month freezes a few days after it closes, and months are summed from days, never from weeks, so finance figures stay exact;
  - cap the top-N plus "Other" in the aggregated tiers;
  - charts past the fine window show labelled "Summarized" bars, and day-level signals look only inside it;
  - size each tier from persona needs (support about 60 days daily, business 90 plus the prior 90, finance monthly).
- **Define the retention constants once.** A validation found them in 4 places, off by a day between areas. Use one module (DetailWindow, SummaryWindows, ReReadDays) and add a parity test. [IS validation result, CW tier alignment]
- **Pruning: dry run first, prune only after freezing.** Delete only after that period's summaries are frozen. Run 7 nights of dry run, then go live. Look for risks such as a partly covered month freezing and then a prune deleting the fuller legacy record. [IS tiers, CW]
- **Make the collector the single writer.** Collected data has exactly one writer, the app identity. User writes go through a role-checked job ("ConfigWrite"): the server checks the starting user's role against hard-coded rules and writes a history row. The UI only hides buttons. Revisit this when the store's own RBAC can be the boundary. [IS Access model, ADW]
- **Check the store's default grants before trusting any write path.** A default "Everyone" group had tenant-wide write, so giving the web app a write scope would have let every user write every row. The scope was added and then reverted the same day. [INV, ADW §0]
- **Put config in a data store, not in assets.** Assets have size limits (the snapshot passed 1 MB) and are reset by deploys. The snapshot assets were retired in favour of the data store. [mem:project_tiered_history_retention, IS WIP]
- **Make collectors idempotent and resumable.** Recompute a slice's days; never add to them. Save progress per slice, so a killed job resumes at the next slice. Record a failing tenant and let the others continue. Count an event on its real start day, so one crossing a slice boundary counts once. [CW R4 2c]
- **Respect the job runner's limits: time budgets and chaining.**
  - A 30-minute budget ran into a ~15-minute job limit, and the job was killed mid-tenant. The fix: a deadline that leaves a margin; don't start a slice that the longest slice so far wouldn't finish in time.
  - Process newest data first for every tenant, then older data, and start with the least recently updated tenant.
  - Chain follow-up jobs, with a signed run token so the gate recognises them.
  [CW #5, CW run gate]
- **Batch inside a job; don't start many jobs.** Starting jobs concurrently timed out the platform's credential fetch. Run jobs one at a time, with bounded parallelism *inside* one job (6), batch inputs, and the credential fetched once per job. [ARCH Data flow, mem:project_collector_streamlining_followup]
- **Make failure loud.**
  - A job ended "Successful" while every tenant failed, because errors were logged at Info. Log per-item errors as Warning, log a step that fails for everything as Error, and fault the job at the end.
  - A trigger set to the wrong runtime silently never ran for 12 days. Monitor that the job actually ran, not just that the trigger exists.
  [CW #4, mem:project_unit_consumption_poc_deployment]
- **Parse inputs defensively.** Omitted optional arguments arrived as a literal null, not the compiled default. [ARCH Collector modes]
- **Always page.** A client sent `skip=0` once and never read `totalCount`, which silently cut results at 200. Write tests for "full page, then short page". [mem:project_live_historical_data_migration]
- **Watch values baked in at build time.** Build-time env values (folder id, process name) broke the app after a redeploy to a new location, and it looked like an auth problem. Prefer runtime-injected config such as a meta tag. [HO]
- **Check each endpoint's own scope.** Every endpoint needs its own documented scope. Read the spec per operation before assuming a broad scope covers it or that an error is an RBAC problem. Some portal-internal APIs never accept app tokens. [mem:feedback_ground_in_docs_ask_about_gaps, HO gotchas 5–6]
- **Design each area's storage on its own terms.** A chunked document pattern that suits one area shouldn't be forced onto the others. [mem:project_licensing_dashboard_direction]

---

## 5. Release and verification lessons

**The incidents, generalized**

1. **A "Successful" status doesn't mean the work ran.** A credential test job reported Successful, but an access gate had refused it before the credential was ever used: the gate read only part of the user's roles and missed the group-derived one. **Read the job's logs, and check for evidence of the real effect** (records written, the expected log line). [S1, git e370e11] The same thing happened in reverse when a job was green with every tenant failed. [CW #4]
2. **Import identities by id, then verify that the ids match.** Groups imported by *name* created orphan records whose ids didn't exist in the identity provider, so no member got any role. The fix was to delete them and re-add each by its identity-provider id, then check that platform key = provider id. A one-step import with an assignment returned HTTP 500 and applied nothing; import first, then assign, worked. [S2, INV change log, HO gotchas]
3. **Deploys reset config.** A deploy reset text assets to `{}` and wiped the credential's secret. Capture every value before you upload, and restore it after the deploy (or regenerate it). The secret can't be read back, so only a job proves it works. [S3, mem:feedback_upload_procedure_assets]
4. **Verify by content hash, not by version.** The version went `.73 → .74 → .75` with fresh revision numbers and timestamps, but the served bundle was byte-identical. The release was repackaging a stale, committed `dist/` that the platform doesn't rebuild. Compare the served content-hashed file name (or a checksum or embedded build id) with the fresh local build. [S4, mem:feedback_verify_deploy_by_content_hash, ARCH]
5. **Sign-in scopes can live in a platform-side file** that the overlay never copies. Sync that file on every upload. [mem:project_unit_consumption_poc_deployment]
6. **The release tool derives the next version from a local file,** and it collided with versions pushed another way. Check the live version first. [mem:feedback_check_version_before_push]
7. **Untracking a resource deletes it on the next upgrade.** [mem:feedback_keep_credential_tracked]
8. **Some resources can't be tracked in the release** (a trigger created an unfixable duplicate pair). Create them by hand, list them in the install steps, and record their inputs. [ARCH Scheduled collection, HO]
9. **Re-download after uploading.** Check that the platform's copy wasn't reverted and holds your sources. [ARCH upload procedure]
10. **A stale credential can point at the wrong app.** When a permission fix doesn't take effect, check which app the running credential really belongs to. It can't be read back, so test it. [mem:project_unit_consumption_poc_deployment]

**The release checklist** (generic; adapted from ARCH "Upload and deploy procedure", IS Next 1 and IS Git branching)

*Before*
- [ ] The board shows what the release carries. Everything is merged on `develop`, and the build manager and GUI testers say GO.
- [ ] Real type-check (build mode), all test suites, a conflict-marker grep and brace balance: all clean.
- [ ] Fresh production build from source. Record the content hash of the local bundle.
- [ ] Query the **live** version, and make the new version strictly greater.
- [ ] **Capture live config** (asset values, trigger inputs, role assignments) into the scratchpad. Note the credential's name only.
- [ ] Download the live release definition. Check it wasn't reverted. Overlay the sources, keep platform-owned files, sync the platform-side scope or config lines, and diff everything.

*Deploy*
- [ ] Upload the whole release unit, re-download it, and check the sources and hash.
- [ ] The **user** deploys (agents never do).

*After*
- [ ] Deployment state is Active at the new version, and the **served content hash = the local hash**.
- [ ] Re-enter the secrets. Run a short **test job, and read its logs** for evidence the credential was really used (not just a Successful status).
- [ ] Run one job of each changed mode and check the data it wrote.
- [ ] Restore the captured config, or regenerate it.
- [ ] Check identities: platform group keys = identity-provider ids, and the gate accepts each role (run a Viewer test for refusals).
- [ ] Update the inventory and the handoff change log. Merge `develop` → `main`, tag `v<version>`, push after the commit list, a secret scan and the user's OK. Sync the handoff snapshot from `main`, and archive the old one.
- [ ] The next morning: check the first scheduled run (succeeded, chains passed the gate, prune still in dry run, data as-of updated).

---

## 6. Testing lessons

- **Use a real type-check.** In a solution-style config (empty `files` + `references`), `tsc --noEmit` checks **zero files** and always passes. That hid a real type error through several "clean" rounds and a browser pass. Use the command the real build uses (`tsc -b`, fresh), and check that the check actually covers files. [S5, mem:feedback_use_tsc_build_not_noemit]
- **Run the full suite on every merge,** not only the builder's tests: frontend, backend and the domain suite. The frontend grew to about 1,000 tests, and each merge wave records its gate ("tsc clean, vitest N/N, dotnet N/N"). [CW, IS]
- **Layout tests without a browser.** jsdom has no layout, so the tests read the stylesheet: the stylesheet ends at **brace depth 0**, key responsive rules exist inside the right `@media` block, and grids fit their item counts. The brace test catches bad conflict resolutions. [S6, LayoutFit.test, git aa5ca94]
- **Scripted browser sweeps at 3 widths.** Small, medium and large (about 420 / 900 / 1280, which at 80% zoom are 336 / 720 / 1024 px viewports), on demo and live data. Check for no sideways scroll, clipped names, wrapped titles and cut tooltips. Findings are graded High or Low, fixed in batches, and rechecked. [IS, CW Build manager R5]
- **A persona × page matrix.** Every page under every persona switch value, plus role checks (a Viewer sees no admin controls and gets its refresh refused). [IS Waiting, mem:project_robots_persona_review]
- **Put timing guards under load.** A 1.5 s generation-time test flaked under the full parallel suite and the testers' browsers. Measure the worker's CPU time when you can, take the minimum of two runs, and set the guard at about 3× the solo time. Raise async test timeouts (10–20 s) for heavy UI tests. [git 3b4c9ab, 100adad, 2f382c0]
- **Encode rules in tests.** Demo-data audits (no fields the collector can't produce), tour length caps, "no raw data stored", fetch call counts ("fires only on Refresh"), and paging tests. A test that encodes a decision is a question to the user when it fails (see §1.7). [CW, mem:project_live_historical_data_migration, DemoTour.test]
- **Verify against the current source before generalizing a bug** ("it was only in one mode"). [mem:project_live_historical_data_migration]
- **Scope identity tests correctly:** test with the real app identity (see §1.13), and test live read-only. Ask the user before any first write. [mem:feedback_prefer_app_scope_over_delegated, ADW §6]

---

## 7. Anti-patterns (and the incident behind each)

| Anti-pattern | Incident |
|---|---|
| Building before planning and asking | Straight to edits on a heading reorder; corrected 3 times [mem:feedback_ask_questions_when_asked_to_plan] |
| Chaining several pages or steps in one turn | User asked for one at a time, to review each piece [mem:feedback_step_by_step_one_page_at_a_time] |
| Re-asking for facts already given | "I've sent this multiple times" [mem:feedback_check_docs_before_reasking_api] |
| Declaring the docs wrong after one live test | Endpoint scope misread; 2 rounds of wrong "needs a role" conclusions [mem:feedback_ground_in_docs_ask_about_gaps] |
| An options menu built on a guessed capability | "By execution" was a flag on an existing endpoint [mem:feedback_verify_before_speculating_on_capabilities] |
| Quietly routing around a recorded rule | The no-tables test was being worked around [mem:feedback_rule_changes_ask] |
| Over-generalizing a narrow instruction | "No allocation breakdown" became "no KPIs at all" [mem:project_live_historical_data_migration] |
| Keying maps by display name | Two production folders with the same name merged [mem:feedback_always_key_by_id_not_name] |
| Importing identities by name | Orphan group records; nobody got roles [S2, INV] |
| Trusting a green status | Gate refused the test job; job green with every tenant failed [S1, CW #4] |
| Trusting version numbers for a deploy | Stale `dist/` shipped 3 times [S4, mem:feedback_verify_deploy_by_content_hash] |
| Deploying without capturing config | Assets reset to `{}`, secret wiped [S3, mem:feedback_upload_procedure_assets] |
| Untracking a resource to "protect" it | The upgrade deleted it [mem:feedback_keep_credential_tracked] |
| A type-check that checks nothing | `--noEmit` with project references [S5, mem:feedback_use_tsc_build_not_noemit] |
| Hand-resolving CSS conflicts without checks | Unclosed `@media`; the desktop layout broke [S6, git aa5ca94] |
| Parallel builders in one working tree | Committed each other's half-done work [IS lessons] |
| Running another agent's scratch files | Shared scratchpad collision [S7, IS] |
| Restarting agents after a limit | Lost context and redone work; resume instead [S8, IS] |
| Testing with a delegated token for app-identity questions | Dead-end cross-folder investigation [mem:feedback_prefer_app_scope_over_delegated] |
| Leaving throwaway apps behind, or several permanent apps | Persistent 403 from stale registrations; debug apps found days later [mem:feedback_two_external_apps_only, INV] |
| Replacing a scope list without reading it first | The update replaces the whole list [mem:feedback_two_external_apps_only] |
| Granting a user write scope without checking the store's default grants | "Everyone" had tenant-wide write [INV] |
| Starting many jobs concurrently | Credential-fetch timeouts [ARCH] |
| A time budget longer than the platform's job limit | Job killed mid-tenant [CW #5] |
| Logging errors at Info | Failures invisible in the console [CW #4] |
| A single page request with no paging | Results silently cut at 200 [mem:project_live_historical_data_migration] |
| Config baked in at build time | Stale folder id after a redeploy looked like an auth failure [HO] |
| Demo-only data shapes | Per-tenant user pools that can't exist [mem:feedback_demo_data_real_shaped] |
| Domain-hostile wording | "Reclaim" [mem:feedback_growth_framing_not_reclaim] |
| Direct user grants or shared roles | Direct folder-admin assignment flagged; roles must differ to be told apart [IS Waiting, mem:feedback_rbac_no_shared_roles] |
| Wall-clock timing asserts under parallel load | Flaky generation-time test [git 3b4c9ab] |
| Handoff docs drifting from shipped state | Handoff named a deleted app and the wrong runtime [IS Deferred: handoff concerns] |
