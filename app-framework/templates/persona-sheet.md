# <APP_NAME> · Personas and vocabulary

Read before planning any page. Every page is reviewed as each persona: "what would <persona> find
concerning at this level?" Mark proto-personas as **hypotheses** until real users confirm them.

These personas are the **domain** group for the red-team pattern in
[session-2026-09-28.md rule 15](../lessons/session-2026-09-28.md): who the app is for, used for
app-behavior/risk questions. That rule's **technical** group (backend/frontend/security
specialist) is generic and app-specific info is *not* added here — it needs no template entry.

## Persona table

| Persona | Their question | Primary? | How technical |
|---|---|---|---|
| <Specialist / analyst> | "<Is it sized right and used well?>" | yes | expert |
| <Business owner> | "<Is it delivering, and growing?>" | | low |
| <Production support> | "<Is anything broken or quiet?>" | | high |
| <Finance> | "<Who uses what share, and what do we bill?>" | | medium |

## Persona cards (one per persona)

### <PERSONA>

- **Status:** hypothesis | confirmed with <n> users on <YYYY-MM-DD>
- **Job to be done:** When <situation>, I want to <motivation>, so I can <outcome>.
- **Top jobs / questions (V2):**
  1. <job>
  2. <job>
  3. <job>
- **What they find concerning (V3):**

  | Concern | Signal on the page | Data availability |
  |---|---|---|
  | <e.g. at capacity> | <verdict tile / icon / sorted table> | have · approximate · needs collection |

- **What they do next (V8):** <drill down, open the source system, export, notify>
- **Must not see (V11):** <admin actions, other groups' data, or "nothing restricted">
- **Value stories (V7):** As <persona>, I can <do> so that <outcome>.
- **Demo tour:** <tour id>, at most 8 steps, at most 2 sentences per step.

## Page × persona review

| Page | <Persona 1> | <Persona 2> | <Persona 3> | <Persona 4> |
|---|---|---|---|---|
| <page> | <headline / verdict they see first> | | | |

## Vocabulary and framing (V4, V9, V10)

- **Framing rule:** <e.g. growth framing: "room to grow", never cost-cutting words>
- **Verdict labels:** <e.g. At capacity · Room to grow · Ready for new work>
- **Banned words → use instead:**

  | Don't write | Write |
  |---|---|
  | <word> | <word> |

- **Official names:** <vendor or domain names exactly as the source spells them; short form in
  tables, full form in headings>
- **Fixed sort order:** <e.g. most to least costly type; severity high → low>
- **Numbers:** answer first, figures second ("Room to grow: 12 free"). Estimates are labelled.
  Shortfalls are shown as "<n> needed".
- **Help text:** every metric has a plain-language tooltip (V12).
