# 01 · Discovery

**Goal:** agree the problem, the users, what success looks like, the deadline and what is out of
scope, before any design work.
**Owner:** Coordinator · **Approver:** the user (or the named decider, K9)

## When to run / skip

- **Run** for a new app, or a vague idea ("we should show X somehow").
- **Skip** for a bug, a tweak, or a feature whose problem and users are already in the PRD. Start
  at [03 Requirements](03-requirements.md) or [09 Build](09-build.md) instead.

## Inputs

- The user's first description of the app.
- Any existing docs, a reference product (K10), earlier decisions.
- `docs/architecture.md` and memory, read **first**, so you don't re-ask known facts.

## Steps

1. **Read everything already written** (docs, memory, repo, the Decision Log). List what is already
   known as assumptions.
2. **Draft a one-line problem statement** and a "today without the app" baseline. Offer it for
   correction (K1) instead of asking an open question.
3. **Ask the 5 must-asks** (K1–K5) in batches of 1–4, recommended option first.
4. **Ask the conditional ones** only when their trigger holds: K6 stack, K7 budget, K9 decider,
   K11 handoff target, K12 sensitive framing.
5. **If a reference product exists (K10), review it before asking more.** List its value props.
   Mark each: we can match it / approximate it / can't yet (no data).
6. **Write JTBD statements** for the main users: "When <situation>, I want to <motivation>, so I
   can <outcome>." Label them hypotheses until checked with real users.
7. **Record the tone rule early** if the data is about people, cost or utilization (K12). Start
   the vocabulary list here; [02 Personas and value](02-personas-value.md) finishes it.
8. **Write the non-goals.** Every parked item goes on the Board as Planned (P2), with its reason.
9. **Log every answer** in the Decision Log in the same turn.
10. **Close the phase** with a summary: decisions (D-IDs), defaults taken, open questions. Ask
    "Anything wrong here?"

## Questions to ask

Bank: [questions/01-kickoff.md](../questions/01-kickoff.md). Must-asks: **K1, K2, K3, K4, K5**.
Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- PRD, first sections only: problem, baseline, users, success metrics, non-goals
  ([templates/prd.md](../templates/prd.md)).
- Decision Log entries ([templates/decision-log.md](../templates/decision-log.md)).
- Board rows: the deadline or demo milestone, parked non-goals
  ([templates/board.md](../templates/board.md)).
- Optional: a reference-product value-prop list in `docs/architecture.md` or the PRD.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): asks, drafts, logs.
- [Researcher](../agents/researcher.md): optional, read-only. Reviews the reference product or
  public docs and writes findings to a file.

## Gate / definition of done

- [ ] K1–K5 answered and logged.
- [ ] One-line problem statement and baseline agreed.
- [ ] 1–3 success metrics named, each measurable.
- [ ] Non-goals written and parked on the Board.
- [ ] Deadline or demo date on the Board, with what must work by then.
- [ ] The user confirmed the phase summary.

## Rules and anti-patterns

- **Plan and ask before building, every time.** Why: the user wants to steer choices, not review
  surprises; jumping straight to edits was corrected three times. Lesson: r1 §1.1.
  Practice: https://code.claude.com/docs/en/best-practices (explore, plan, then implement).
- **Read before you ask.** Why: re-asking for facts already given wastes the user's time and
  erodes trust ("I've sent this multiple times"). Lesson: r1 §1.3.
- **Offer a draft to correct, not an empty question.** Why: correcting a draft is faster and
  surfaces hidden assumptions. Practice: https://code.claude.com/docs/en/best-practices (interview,
  then spec).
- **Write non-goals.** Why: they are what keeps agents in scope. Practice:
  https://www.industrialempathy.com/posts/design-docs-at-google/
- **Frame with jobs, not demographics.** Why: jobs anchor features to motives. Practice:
  https://hbr.org/2016/09/know-your-customers-jobs-to-be-done
- **Label early personas and jobs as hypotheses.** Why: proto-personas are cheap but can become
  an echo chamber. Practice: https://www.nngroup.com/articles/persona-types/
- **Benchmark a reference product before asking about features.** Why: it gives a value floor and
  better questions. Lesson: r1 §3 (benchmark against a reference app).
- **Set the framing rule now.** Why: hostile wording ("reclaim", "under-used") worked against the
  business and had to be rewritten across pages. Lesson: r1 §1.8.
- **Anti-pattern: designing on a guessed meaning of the request.** If the request is unclear and
  nothing grounds it, ask for an example. Lesson: r1 §1.6.
