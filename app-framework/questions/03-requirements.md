# Bank 3 · Requirements (Q)

Used in: [03 Requirements](../playbook/03-requirements.md).
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (Q1–Q5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| Q1 ★ | Confirm the feature list and priority: P0 (must be in v1), P1 (next), P2 (later). | It is the backbone of the phasing and the Board. | Coordinator drafts from V7, user reorders **(Rec)** · User supplies | always |
| Q2 ★ | What are the acceptance criteria for each P0 (Given/When/Then or EARS, testable)? | They define done and feed the tests and browser sweeps. | Draft 2–4 per P0 for the user to confirm **(Rec)** · User writes them | always |
| Q3 ★ | How fresh must the data be on each page (live, hourly, nightly)? | It is the single biggest driver of architecture and API cost. | Nightly snapshot plus a manual admin refresh **(Rec)** · Hourly · Live | always |
| Q4 ★ | Which environments exist, and where does each stage deploy (dev, test, prod)? | It stops deploys to the wrong environment and sets the promotion steps. | Dev only now, prod via handoff **(Rec)** · Dev → Test → Prod · Single environment | always |
| Q5 ★ | What is the expected scale (users, tenants or orgs, records per day, history length)? | It sizes storage, paging and query design. | Orders of magnitude **(Rec)** · Unknown, so measure live first | always |
| Q6 | What are the page-load and performance targets? | They set budgets for queries and bundle size. | Landing under 3 s, drill-down under 2 s on a warm cache **(Rec)** · Best effort | if there is large data or a slow API |
| Q7 | What availability is expected (business hours vs 24×7), and what downtime is acceptable? | It decides monitoring depth and the retry and fallback design. | Business-hours best effort **(Rec)** · 24×7 with an SLO · None | if production-bound |
| Q8 | Which browsers and devices must be supported? | It sets the test matrix and the responsive widths. | Current evergreen desktop browsers, desktop first, usable on a phone **(Rec)** · Mobile first · Specific list | always (quick) |
| Q9 | Are there export or reporting needs (CSV, PDF, scheduled email)? | They are easy to forget and change the data shape. | CSV export of every table **(Rec)** · PDF · None | always (quick) |
| Q10 | Is there a localization, time-zone or currency requirement? | Dates and period boundaries break quietly. | Show the user's local time, store UTC **(Rec)** · Fixed org time zone · Multi-language | if users are in several regions |
| Q11 | Are there compliance or regulatory constraints (e.g. health data, SOC 2, GDPR, data residency)? | They can veto storage locations or kinds of data. | None beyond org policy **(Rec)** · Named regime | if there is customer data or a regulated industry |
| Q12 | Which requirements are "demo only" and which are "real"? | It stops demo shortcuts from leaking into production. | Demo data behind an explicit flag **(Rec)** · No demo mode | if K4 has a demo |
| Q13 | Is there a feature-flag or gradual-rollout need? | Flags let unfinished features ship dark. | No flags, ship when done **(Rec)** · Flags per feature | if several features run in parallel |

**Close the bank:** write the PRD ([templates/prd.md](../templates/prd.md)), with every P0 carrying
testable criteria and no `[NEEDS CLARIFICATION]` markers left.
