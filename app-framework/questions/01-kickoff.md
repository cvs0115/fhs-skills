# Bank 1 · Kick-off and goals (K)

Used in: [01 Discovery](../playbook/01-discovery.md). Also asked by `/new-app`.
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (K1–K5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| K1 ★ | What problem are we solving, and what happens today without the app? | It anchors scope. Without the "today" baseline you can't show value. | Free text; offer a one-line problem statement for them to correct **(Rec)** | always |
| K2 ★ | Who are the primary users, and who is the audience for demos or sign-off? | Users drive the design. The audience drives the demo story. They are often different people. | Internal ops or analysts **(Rec)** · Customer end users · Execs or buyers · Mixed | always |
| K3 ★ | How will we know it worked? Name 1–3 success metrics. | It makes "done" measurable and shapes what data we need. | Time saved per task **(Rec)** · Decision quality or visibility · Cost avoided · Adoption count | always |
| K4 ★ | Is there a hard deadline or demo date, and what must work by then? | It sets the phasing and whether demo or preview data is needed. | Demo milestone, then iterate **(Rec)** · Fixed go-live date · No deadline | always |
| K5 ★ | What is explicitly out of scope for this version? | It stops scope creep. Parked items go on the Board as Planned. | List now, park on the Board **(Rec)** · Decide per feature later | always |
| K6 | What platform and tech constraints apply (required stack, hosting, existing environment or org)? | Stops us designing for a platform we can't deploy to. | Use the existing platform and environment **(Rec)** · New environment · Undecided | unless the docs state it |
| K7 | What is the budget or cost ceiling (licenses, API calls, compute)? | It limits polling frequency, storage and paid services. | Stay within existing licenses **(Rec)** · Small new spend OK · Defined budget | if paid services or heavy API use are likely |
| K8 | Is this a one-off, a proof of concept, or a long-lived product? | It sets how much to invest in ops, tests and handoff. | POC that can grow into a product **(Rec)** · Throwaway demo · Production product | always (quick) |
| K9 | Who decides priorities and signs off, and who else must be consulted? | One decider avoids conflicting instructions. | The user decides alone **(Rec)** · Named stakeholder group | if more than one stakeholder is mentioned |
| K10 | Is there an existing tool or reference product to match or beat? | It gives a value benchmark and a feature floor. | Name the reference and list its value props **(Rec)** · None | always (quick) |
| K11 | What is the handoff target: who runs it after us, and where is it delivered? | It shapes docs, packaging and folder layout from day one. | Customer team via a handoff folder **(Rec)** · The user's own team · Us | if customer-facing or long-lived |
| K12 | Is anything politically sensitive about the framing or the data (e.g. cost cutting vs growth)? | Wording can sink adoption. It sets the tone rule early. | Growth or opportunity framing **(Rec)** · Neutral and factual · Cost or savings framing | if the data is about people, cost or utilization |

**Close the bank:** write the answers into the PRD's problem, users, metrics and non-goals
sections ([templates/prd.md](../templates/prd.md)) and log them in the Decision Log.
