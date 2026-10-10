# 03 · Requirements

**Goal:** a lean, one-page PRD: prioritized features, testable acceptance criteria, freshness,
environments, scale and a definition of done. It says *what* and *why*, never *how*.
**Owner:** Coordinator · **Approver:** the user

## When to run / skip

- **Run** for a new app or a new feature (a clear feature starts here).
- **Light version** for a bug: write a short bug-assess note instead (symptom, expected, cause
  hypothesis, check that proves the fix). Then go to [09 Build](09-build.md).
- **Skip** for a tweak you could describe in one sentence.

## Inputs

- Discovery outputs (problem, users, metrics, non-goals).
- Persona Sheet (value stories, concerns).

## Steps

1. **Draft the feature list from the value stories** (V7), tagged P0 / P1 / P2:
   - **P0** blocks the release or the demo.
   - **P1** improves it; ships if ready.
   - **P2** after.
   Ask the user to reorder (Q1). Keep P0 to about 60% of the effort you have.
2. **Write user stories** that pass INVEST: independent, negotiable, valuable, estimable, small,
   testable.
3. **Write 2–4 acceptance criteria per P0** (Q2), in one of two forms:
   - **EARS** for system behavior: "When <event>, the <system> shall <response>." Also *While*
     (state), *Where* (feature), *If … then* (unwanted behavior).
   - **Gherkin** for user flows: Given / When / Then.
4. **Mark every unknown `[NEEDS CLARIFICATION: …]`.** Don't guess. Resolve them with the user
   before the phase closes.
5. **Pin the freshness per page** (Q3). It is the biggest architecture driver.
6. **Pin environments** (Q4) and **scale** (Q5) as orders of magnitude.
7. **Ask the quick non-functional ones:** browsers and devices (Q8), exports (Q9). Ask
   performance, availability, locale, compliance, demo-only and flags only when triggered.
8. **Separate demo-only from real** (Q12). Demo data sits behind an explicit flag.
9. **Write the definition of done** (or link L2 if it's already agreed).
10. **Add the rollback idea**: how you would turn the feature off or undo it.
11. **Run a clarify pass**: re-read the PRD as the Builder would. Any sentence that allows two
    implementations becomes a question.
12. **Log and close.** Put each P0/P1 on the Board, tagged with its requirement ID.

## Questions to ask

Bank: [questions/03-requirements.md](../questions/03-requirements.md). Must-asks:
**Q1, Q2, Q3, Q4, Q5**. Rules: [00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- PRD: problem, goals, non-goals, users, success and guardrail metrics, scope with P0/P1/P2,
  stories with acceptance criteria, freshness, environments, scale, open questions, rollback
  ([templates/prd.md](../templates/prd.md)).
- Board rows per requirement ID ([templates/board.md](../templates/board.md)).
- Decision Log entries.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): drafts, asks, owns the PRD.
- [Verifier](../agents/verifier.md): optional fresh-context read of the PRD: "can every criterion
  become a test?"

## Gate / definition of done

- [ ] Q1–Q5 answered and logged.
- [ ] Every P0 has 2–4 testable criteria (EARS or Gherkin).
- [ ] No `[NEEDS CLARIFICATION]` markers left.
- [ ] Non-goals and rollback written.
- [ ] Definition of done agreed.
- [ ] The PRD fits on about one page (links out for detail).

## Rules and anti-patterns

- **Spec says what and why; the plan says how.** Why: the user can check intent without reading
  tech choices. Practice: https://github.com/github/spec-kit/blob/main/spec-driven.md
- **Mark unknowns instead of guessing.** Why: the agent surfaces doubt instead of making a
  plausible guess that becomes code. Practice: https://github.com/github/spec-kit/blob/main/spec-driven.md
- **EARS or Gherkin criteria.** Why: each criterion turns straight into a test. Practice:
  https://alistairmavin.com/ears/ · https://cucumber.io/docs/gherkin/reference/
- **Stories meet INVEST.** Why: small, testable units are what agents do well. Practice:
  https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/
- **MoSCoW for scope, RICE to rank the backlog.** Why: Musts at ~60% of effort protect the date;
  RICE makes trade-offs explicit. Practice:
  https://www.agilebusiness.org/dsdm-project-framework/moscow-prioritisation.html ·
  https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/
- **Right-size the spec.** Why: full spec tooling turned one small bug into 4 stories and 16
  criteria. Use a bug-assess note for bugs. Practice:
  https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
- **A definition of done, not a gate-keeping "ready" checklist.** Why: agents need explicit stop
  criteria; a rigid readiness gate slows flow. Practice: https://scrumguides.org/scrum-guide.html
- **Decide freshness early.** Why: the data rule (live reads, then cheap live calls, then snapshot
  only) took several rounds to settle and caused rework each time. Lesson: r1 §4 (one scheduled
  sync).
- **Anti-pattern: demo-only requirements leaking into production.** Put them behind a flag and
  name them in the PRD. Lesson: r1 §1.9.
