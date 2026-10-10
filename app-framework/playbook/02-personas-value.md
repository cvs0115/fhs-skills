# 02 · Personas and value

**Goal:** a short Persona Sheet that every page is reviewed against: who uses the app, the
question each one brings, what they would find concerning, and the words we use.
**Owner:** Coordinator · **Approver:** the user

These are UI/product personas, for page design. A separate pattern uses named personas as
parallel red-team reviewers for a decision or diff (investor, operator, SRE, etc.) — see
[session-2026-09-28.md rule 15](../lessons/session-2026-09-28.md). Don't conflate the two: this
file's personas are who the app is built for; that rule's personas are who checks a change.

## When to run / skip

- **Run** for a new app, and whenever a new audience appears.
- **Re-run the review part** (step 6) before planning every new page.
- **Skip** for back-end-only work with no reader, or a tweak that adds no new figure.

## Inputs

- Discovery outputs: users, audience, success metrics, tone rule (K2, K3, K12).
- The reference product's value props (K10), if any.

## Steps

1. **Draft the persona list** with one line each and their headline question. A good default set:

   | Persona | Their question |
   |---|---|
   | Specialist / analyst | "Is it sized right and used well?" |
   | Business owner | "Is it delivering, and growing?" |
   | Production support | "Is anything broken or quiet?" |
   | Finance | "Who uses what share, and what do we bill?" |

   Ask the user to confirm or edit (V1).
2. **Draft the top 3 jobs per persona** (V2) and **what each would find concerning** (V3): e.g.
   at capacity, failing, idle, overspend, trend turning.
3. **Mark each concern with data availability:** have / approximate / needs collection. Don't
   promise what the data can't support.
4. **Write value stories** (V7): "As <persona>, I can <do> so that <outcome>." Tie each to real
   data. Label estimates as estimates. Pick the top 3; they seed the P0 list and the demo script.
5. **Settle the words** (V4, V9, V10): framing, banned words, verdict labels, official names, a
   fixed sort order. Write them in the Persona Sheet's vocabulary section.
6. **Set the review habit.** Before building any page, ask per persona: "what would <persona>
   find concerning at this level?" List concerns with data availability, ask which to adopt and
   how to show them (icon signals, a sortable table, KPI tiles), then plan.
7. **Decide the persona UI** (V5): a persona switch, separate views, or one view.
8. **Decide the next action per concern** (V8): drill down, open the source system, export.
9. **Put the persona table at the top of the Board**, so every agent reads it before planning.
10. **Log and close** with a phase summary.

## Questions to ask

Bank: [questions/02-personas-value.md](../questions/02-personas-value.md). Must-asks:
**V1, V2, V3, V4, V5**. Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- Persona Sheet: personas, questions, jobs, concerns with data availability, value stories,
  vocabulary, sort order ([templates/persona-sheet.md](../templates/persona-sheet.md)).
- Persona table at the top of the Board ([templates/board.md](../templates/board.md)).
- Decision Log entries.
- Later, for gaps: one Decision Brief per gap ([templates/decision-brief.md](../templates/decision-brief.md)).

## Agent roles involved

- [Coordinator](../agents/coordinator.md): drafts, asks, owns the sheet. On any GUI change it
  acts as the domain specialist without being asked.
- [Researcher](../agents/researcher.md): checks which concerns the data can support.
- [Docs Writer](../agents/docs-writer.md): later turns value stories into demo tours.

## Gate / definition of done

- [ ] V1–V5 answered and logged.
- [ ] Every persona has a question, 3 jobs and a list of concerns.
- [ ] Every concern is marked have / approximate / needs collection.
- [ ] Top 3 value stories chosen.
- [ ] Vocabulary and sort order written down.
- [ ] Persona table is on the Board.

## Rules and anti-patterns

- **Answer first, figures second.** Why: an early overview failed because it showed raw numbers
  without saying whether things were over- or under-used. Give a verdict ("Room to grow: 12
  free"). Lesson: r1 §3.
- **Review every page per persona before building.** Why: most pages answered "what's happening"
  but not "what do I do, and who do I talk to?" Lesson: r1 §3 (gap review).
- **Use the domain's language and the user's framing.** Why: wording that works against the
  business sinks adoption. Keep a vocabulary list and put it where Builders and demo writers see
  it. Lesson: r1 §1.8.
- **Keep one fixed sort order and the official names.** Why: inconsistent order and names across
  pages cause trust and support problems. Lesson: r1 §1.8.
- **Value stories use real data only; estimates are labelled.** Why: an unlabelled estimate is
  read as fact. Lesson: r1 §3 (value stories).
- **Benchmark honestly.** Why: say plainly when your data can't support a reference product's
  value prop yet, instead of faking it. Lesson: r1 §3.
- **Start with proto-personas, then validate.** Why: cheap to start, but they need real users to
  stay honest. Practice: https://www.nngroup.com/articles/persona-types/
- **Anti-pattern: a gap with no decision path.** Write one Decision Brief per gap (source data,
  options, recommendation, effort, open questions). Lesson: r1 §3.
