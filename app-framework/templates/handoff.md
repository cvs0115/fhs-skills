# <APP_NAME> · Handoff

For the team that runs the app after us. Describes **shipped state only**: what is on `main`, tagged
and deployed. Sync this folder from `main` right after a verified deploy, never from `develop`.

- **Current release:** v<VERSION> · deployed <YYYY-MM-DD> · served content hash `<HASH>`
- **Environment:** <ENV_NAME> · **Location / URL:** <location>
- **Support owner:** <team or role> · **Fallback:** <role> · **Report problems:** <channel or link>

## What it does

- <2–4 bullets in the personas' language>

## Install from scratch

1. Prerequisites: <platform access, roles needed to install, tools>
2. Create identities: <names, kinds, exact scopes> (see the Platform Inventory)
3. Create groups and roles: <groups-only model, one role per group per level>
4. Upload and deploy the release unit: <steps>
5. Enter secrets: <names only; where they go>
6. Create resources that can't be tracked in the release: <schedules, triggers, with their inputs>
7. Run the smoke test: <job or page, and the evidence to look for in its logs>

## Operating it

- **Schedule:** <what runs when; how long it takes; time budget>
- **Data freshness:** <"as of" stamp; freshness target>
- **Diagnostics page:** <where; what each status means>
- **Alerts:** <what alerts, to whom>

## Runbooks

| Situation | Steps |
|---|---|
| Rotate a secret | <steps; how to prove it works: run a job and read its logs> |
| Rerun or backfill a job | <steps> |
| Redeploy / upgrade | <steps; capture config first; restore after> |
| Restore data | <steps> |

## Known gotchas

- <e.g. deploys reset config values; capture and restore them>
- <e.g. a Successful job status doesn't prove the work ran; read the logs>

## Known issues deferred

| Issue | Impact | Workaround | Tracked in |
|---|---|---|---|
| <issue> | <impact> | <workaround> | <Board row> |

## Change log

Newest first. Every release and every live platform change.

| Date | Version | Change | Why |
|---|---|---|---|
| <YYYY-MM-DD> | v<VERSION> | <what changed> | <reason> |
