# Bank 5 · Integration, access and security (S)

Used in: [06 Security and access](../playbook/06-security-access.md). S10 is also asked before
any live check in [04 Research spikes](../playbook/04-research-spikes.md).
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (S1–S5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| S1 ★ | What is the auth model: user-delegated sign-in for the UI, an app or service identity for background jobs? | It decides the token flow and what each caller can see. | UI uses user sign-in (OAuth PKCE), the collector uses an app identity (client credentials) **(Rec)** · All app · All user | always |
| S2 ★ | Which exact scopes does each identity need (least privilege, checked against each endpoint's documented scope)? | Broad scopes widen access. A missing scope looks like a role problem. | A per-endpoint minimum scope list for review **(Rec)** · Broad admin scope | always |
| S3 ★ | Which roles and groups get access? Confirm the model: groups only, one role per group per level, no shared roles. | It stops privilege sprawl and keeps access auditable. | Local groups hold the roles, directory groups nested inside them **(Rec)** · Direct user grants | always |
| S4 ★ | Where do secrets live, who rotates them, and what happens to them on a deploy? | Leaked or overwritten secrets are the top ops incident. | The platform's credential store, tracked in the release, user re-enters after each deploy **(Rec)** · Env or secret manager | always |
| S5 ★ | Where do writes happen, and who may write? | Least-privilege writes and the single writer (D3). | Collector identity only, with admin-only config edits **(Rec)** · Any signed-in user | always |
| S6 | How many external apps or identities may exist in total? May we add new ones? | App sprawl creates untracked access. | Keep the existing ones and only add scopes; delete throwaway test apps **(Rec)** · A new app per feature | if a new identity seems needed |
| S7 | What are the tenant or org boundaries? May one deployment read several tenants? | Cross-tenant reads widen access. | One org, several tenants, read by the collector only **(Rec)** · Single tenant · Multi-org | if there are multi-tenant sources |
| S8 | What must be audited (config changes, refresh triggers, access logs)? | It is needed for support and compliance. | Log admin actions with user and time **(Rec)** · Platform audit only | if there are write or admin actions |
| S9 | Quick STRIDE pass: spoofing, tampering, repudiation, information disclosure, denial of service, elevation of privilege. Any concerns beyond the defaults? | A cheap early threat model catches design flaws. | Coordinator drafts one line per letter, user confirms **(Rec)** · Full threat model | always (quick) |
| S10 | For testing APIs, may we use a throwaway app-identity client (deleted afterwards)? | It avoids testing with personal delegated tokens. | Yes: throwaway app, then delete it and record it **(Rec)** · Use the existing app | before any live API validation |
| S11 | Where is each platform change recorded (apps, scopes, assets, roles, data entities)? | An inventory prevents orphaned access. | Platform Inventory + Handoff log, same turn **(Rec)** | always (quick) |
| S12 | Is data egress allowed (exports, email, third-party services)? | An export is data sharing. | Exports only for authorized roles, no third parties **(Rec)** · Unrestricted | if Q9 or notifications are in scope |
| S13 | Are there network constraints (IP allow-lists, CORS, redirect URIs)? | They cause deploy-day surprises. | Register the redirect URIs for every environment up front **(Rec)** · None | if there is a web app with OAuth |

**Close the bank:** record identities, scopes, roles and groups in the Platform Inventory
([templates/platform-inventory.md](../templates/platform-inventory.md)) and the access model in an ADR.
