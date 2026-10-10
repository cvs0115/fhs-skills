# 04 · Research spikes

**Goal:** every data source, API, scope and platform limit the design depends on is validated
**live or against its docs** before architecture starts. Each assumption ends as *verified* or
*a named risk*.
**Owner:** Researcher (read-only) · **Coordinator** decides · **Approver:** the user for any
first write or new identity

## When to run / skip

- **Run** before [05 Architecture and data](05-architecture-data.md) for a new app, and for any
  feature that uses a new endpoint, field, scope or platform capability.
- **Run again** whenever docs and live behavior disagree.
- **Skip** when the feature uses only sources already verified in `docs/architecture.md`.

## Inputs

- PRD: the metrics and figures each P0 needs, freshness (Q3), scale (Q5).
- `docs/architecture.md` and memory: what is already known. Read them first.
- The platform's API spec (per-operation scopes), any user-supplied reference or recorded trace (HAR).

## Steps

1. **List every claim the design rests on:** "endpoint X returns field Y", "scope Z allows W",
   "jobs may run N minutes", "history is kept for M days".
2. **Check what is already written** (architecture doc, memory, Decision Log). Don't re-ask.
3. **Get a safe test identity** (S10): a throwaway app-identity client with no access beyond what
   the test needs. Record it in the Platform Inventory; delete it after.
4. **Test as the identity that will really run the code.** A delegated user token only for the
   web app's own sign-in path.
5. **Validate read-only.** For each claim, call the endpoint, and record the request, the status
   and a trimmed sample response. Never a first write without the user's OK.
6. **Page to the end.** Read the total count and request pages until a short page. Note the page
   size and the total.
7. **Look for alternatives.** For each need, name any other endpoint, scope, flag or source that
   could serve it better (cheaper, keeps history, exposes the id).
8. **Check each endpoint's own documented scope** in the spec before concluding a failure is a
   role or permission problem.
9. **Measure limits:** rate limits and 429 behavior, calls per run, job runtime limits, payload or
   asset size limits, how long history is kept, what happens to deleted or renamed items.
10. **When docs and live disagree, stop.** Write both claims, list confounds (the test principal's
    real permissions, the per-operation scope, stale apps or credentials), and ask the user.
11. **Write findings to a file** (`docs/research/<topic>.md`) and return the path. Move durable
    facts into `docs/architecture.md` in the same turn.
12. **Clean up:** delete throwaway apps and test data; update the Platform Inventory.
13. **Coordinator marks each claim** verified / risk on the Board and asks the must-asks.

## Questions to ask

Bank: [questions/04-data-architecture.md](../questions/04-data-architecture.md). Must-asks:
**D1, D2, D3, D4, D5**. This phase produces the evidence for **D1** (sources per metric) and
informs D2, D4 and D5; D7 (limits) and D8 (backfill) are measured here. Ask **S10** from
[05-integration-security.md](../questions/05-integration-security.md) before the first live call.
Rules: [00-etiquette.md](../questions/00-etiquette.md) (rule 4: ground every question in evidence).

## Artifacts produced

- Research notes per topic, with requests, statuses, samples and sources (`docs/research/`).
- Updated `docs/architecture.md` (facts) and Platform Inventory (any test identity, created and
  deleted) ([templates/platform-inventory.md](../templates/platform-inventory.md)).
- A Decision Brief where a choice between sources is needed
  ([templates/decision-brief.md](../templates/decision-brief.md)).
- Board: risks and open questions.

## Agent roles involved

- [Researcher](../agents/researcher.md): runs the checks, read-only, with sources; 1 agent per
  topic, 2–4 in parallel for comparisons.
- [Coordinator](../agents/coordinator.md): creates or deletes test identities (after the user's
  OK), writes the architecture doc, asks the questions.

## Gate / definition of done

- [ ] Every design claim is verified (with evidence) or on the Board as a named risk.
- [ ] Every metric in the PRD has a validated source, with alternatives noted (D1).
- [ ] Paging, rate limits and job runtime limits are measured, not assumed.
- [ ] Docs/live conflicts are resolved by the user, not by the agent.
- [ ] Throwaway identities are deleted and recorded.
- [ ] Facts are in `docs/architecture.md`.

## Rules and anti-patterns

- **Validate every data or API claim live, and look for alternatives.** Why: the first endpoint
  tried was wrong or incomplete again and again. Lesson: r1 §1.4.
- **When docs and live conflict, ask; don't declare.** Why: one flawed live test "disproved" a
  documented permission; it took two rounds of wrong conclusions to find that the endpoint needed
  its own narrow scope. Lesson: r1 §1.5.
- **Check each endpoint's own scope.** Why: a broad scope doesn't cover every operation, and a
  missing scope looks like a role problem. Some internal APIs never accept app tokens.
  Lesson: r1 §4 (check each endpoint's own scope).
- **Test with the real runtime identity.** Why: a browser user token succeeded at things the
  app identity couldn't, which led to a dead-end investigation. Lesson: r1 §1.13.
- **Always page.** Why: a client sent one request and never read the total, silently cutting
  results at 200. Lesson: r1 §4 (always page).
- **Don't design on a guess.** Why: twice an options menu was built on a wrong reading; the real
  answer was a flag on an endpoint already in use. Ask for a reference first. Lesson: r1 §1.6.
- **Delete throwaway apps right away.** Why: stale test registrations caused a long "persistent
  403" hunt and were found days later. Lesson: r1 §1.12.
- **Delegate with a clear objective, output format, sources and boundaries; write to files.** Why:
  vague delegation duplicates work and floods the main context. Practice:
  https://www.anthropic.com/engineering/multi-agent-research-system
- **Spikes carry evidence.** Why: "tested integration-first against real services" beats mocked
  assumptions. Practice: https://github.com/github/spec-kit/blob/main/spec-driven.md
- **Anti-pattern: generalizing a bug before checking current source.** Confirm it against the
  code that runs today ("it was only in one mode"). Lesson: r1 §6.
