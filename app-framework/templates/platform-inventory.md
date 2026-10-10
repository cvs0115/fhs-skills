# <APP_NAME> · Platform Inventory

Everything that exists on the live platform for this app, read back from the platform with its CLI
or API (not from memory). Update it the same turn as any live change, and copy the change-log line
into the Handoff. No secret values here: names only.

- **Environment:** <ENV_NAME> · **Last read back:** <YYYY-MM-DD> by <Coordinator> with `<CLI_COMMAND>`
- **Naming convention:** `<APP_NAME> - <Type> - <Item>`; code-safe twin `<APP_NAME>_<Type>_<Item>`

## Identities (integration apps, service accounts)

Keep the count fixed (for example one user-delegated app for the UI, one app identity for background
jobs). New capabilities add scopes to these. Scope updates usually replace the whole list: read it
first, send all existing scopes plus the new one.

| Name | Kind (user-delegated / app) | Id | Scopes (exact) | Redirect URIs | Used by | Owner |
|---|---|---|---|---|---|---|
| <name> | app | <id> | <scope list> | — | <job> | <role> |

**Throwaway test identities:** none open. (List any created, with the date deleted.)

## Groups and roles

Groups only; one dedicated role per group at every level; no shared or built-in roles; no direct
user grants. Directory groups are nested inside the local groups.

| Level (org / env / folder / entity) | Group (local) | Group id = identity-provider id? | Role | Role permissions (summary) |
|---|---|---|---|---|
| <level> | <group> | yes (`<id>`) | <role> | <summary> |

**Default grants checked:** <e.g. default "everyone" group on the data store: read-only / none> on <YYYY-MM-DD>

## Config values and secrets (names only)

| Name | Kind (config / secret / credential) | Tracked in the release unit? | Reset by deploy? | Restore step |
|---|---|---|---|---|
| <name> | secret | yes | yes, re-enter after deploy | <runbook link> |

## Data store entities / schemas

| Entity | Purpose | Writer (single) | Readers | Retention | Schema file |
|---|---|---|---|---|---|
| <entity> | <purpose> | <app identity> | <groups> | <tiers> | `<path>` |

## Schedules, triggers and jobs

| Name | Runs | Inputs | Runtime / host | Tracked in release? | Created by |
|---|---|---|---|---|---|
| <name> | <cron / time zone> | <inputs> | <runtime> | no, created by hand | <install step> |

## Deployed release

| Release unit | Version | Deployed | Served content hash | Location / URL |
|---|---|---|---|---|
| <unit> | <VERSION> | <YYYY-MM-DD> | `<HASH>` | <location> |

## Change log

Newest first. One line per live change.

| Date | Change | Why (D-nnn / row) | Read back with | By |
|---|---|---|---|---|
| <YYYY-MM-DD> | <added scope X to identity Y> | <D-nnn> | `<command>` | Coordinator (user OK) |
