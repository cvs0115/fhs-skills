# Bank 9 · Change and rule conflicts (C)

Use this bank in any phase when new input contradicts an earlier decision, rule, memory note,
doc or a test that encodes a decision. Don't override quietly. Quote both sides.
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (C1–C5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| C1 ★ | "On <date> we decided X (D-nnn). This new request implies Y. Which applies?" | It makes the conflict visible and puts the choice with the user. | Keep X, treat Y as an exception **(Rec when Y is one-off)** · Replace X with Y · Both, scoped | always, on conflict |
| C2 ★ | Is the change for this item only, or a new standing rule? | It stops one-off exceptions becoming rules, and the reverse. | This item only **(Rec)** · New standing rule | always, on conflict |
| C3 ★ | What happens to work already built under the old rule (retrofit now, later, or leave it)? | Rule changes create hidden debt. | Put the retrofit on the Board as Planned **(Rec)** · Retrofit now · Leave it | if built work is affected |
| C4 ★ | What changed to prompt this (new information, a stakeholder, a failed assumption)? | The reason is recorded with the decision and helps with future conflicts. | Free text **(Rec)** | always, on conflict |
| C5 ★ | Does this change widen access, delete data or alter a deployed system? | That triggers the destructive/access gate (etiquette rule 5). | Needs an explicit OK before acting **(Rec)** | always, on conflict |
| C6 | Which docs, memory notes, tests and agent instructions must change to match? | Stale rules in docs get re-applied by other agents. | Coordinator lists them and updates them in the same turn **(Rec)** | if C2 = new rule |
| C7 | Does this conflict with a vendor or platform constraint, not just a preference? | Some "rules" are hard limits; those need evidence, not a vote. | Verify against the docs or live, then ask **(Rec)** | if it touches platform behavior |

## Recording a rule change

- Keep the old decision. Mark it `Superseded by D-mmm (date)`.
- Add the new decision with `Supersedes D-nnn` and the reason from C4.
- Never delete the old one. Where the rule is quoted in a doc, strike the old text through and put
  the new text beside it, dated, so the history stays visible.
- If a test encodes the old rule, change the test in the same commit as the rule, and name the D-ID
  in the commit message.

## Typical triggers

- A failing test or a doc note that records a past decision (e.g. "no tables on the overview page").
- A new request that implies a wider or narrower scope than an earlier instruction. Don't
  over-generalize a narrow instruction ("no breakdown table" is not "no numbers at all").
- A live test that seems to contradict the docs. That is a C7 question, not a verdict.
