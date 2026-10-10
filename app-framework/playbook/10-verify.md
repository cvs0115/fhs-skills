# 10 · Verify

**Goal:** an independent check, by agents who didn't write the code, that the merged work meets
the PRD and the definition of done: real type-check, full suite, layout, persona × page, and
spec ↔ code convergence. Evidence, not assertions.
**Owner:** Verifier · GUI Testers · **Approver:** the user (SHIP / NO-SHIP)

## When to run / skip

- **Run** after every merge wave, and before every release.
- **Light version** for a tweak: type-check, the full suite, and one screenshot at the changed width.
- **Never skip** the real type-check and the full suite.

## Inputs

- The merged `develop` branch, the diff, the Board row and its done-check.
- PRD acceptance criteria, Persona Sheet, page plans, contracts.

The cross-model review of the builder diff happens **before** merge
([09 Build](09-build.md)). This phase runs **after** merge. The Verifier and the GUI testers are
not a substitute for that other model family.

## Steps

1. **Real type-check.** Use the command the real build uses (build mode, fresh). Confirm it covers
   files (a count above zero). A no-op check is a failure.
2. **Full test suite** for every layer (frontend, backend, domain). Record the gate line, e.g.
   "types clean · unit 412/412 · integration 38/38".
3. **Static checks:** lint, conflict-marker grep, stylesheet brace depth 0, secret scan.
4. **Layout tests without a browser** where the test runner has no layout engine: the stylesheet
   ends at depth 0, key responsive rules sit inside the right media block, grids fit their item
   counts.
5. **Scripted browser sweeps at three widths** (~420 / 900 / 1280 px), on demo and live data, with
   Playwright (see the section below). Look for sideways scroll, clipped names, wrapped titles, cut
   tooltips. Grade findings High or Low.
6. **Persona × page matrix:** every page under every persona value, plus role checks (a viewer
   sees no admin controls and gets its refresh refused by the server).
7. **Rules encoded as tests pass:** demo-data audit, tour length caps, "no raw data stored", fetch
   call counts, paging ("full page, then short page").
8. **Adversarial review:** a fresh agent sees only the diff and the criteria. Flag only gaps that
   affect correctness or requirements. No gold-plating.
9. **Converge:** check the code against the PRD criteria and the task list until they match.
   List any criterion without a test.
10. **Security pass** on changed areas: OWASP Top 10, access checks, no secrets in logs or errors.
11. **Report** with evidence: commands run and their output, screenshots, findings by severity, a
    SHIP / NO-SHIP verdict. Write large outputs to files and return paths.
12. **Fix in batches, recheck.** Findings go back to Builders as Board rows. Testers recheck.
13. **A failing test that encodes a decision** is a question for the user (bank 9), not a test to
    delete.

## Scripted browser testing with Playwright

The GUI Tester role is in [agents/gui-tester.md](../agents/gui-tester.md); the script skeleton is
[templates/gui-test-script.md](../templates/gui-test-script.md).

| Topic | Rule |
|---|---|
| Tooling | Real Chrome (`channel: 'chrome'`) with `@playwright/test` or `playwright-core`. A Playwright MCP server is optional; it can disconnect, so a scripted run is the fallback. |
| Sign-in | One persistent browser profile per GUI Tester. The **user** signs in with SSO once in a headed window; the tester then runs headless on that profile. Never type a password; stop on any password or MFA prompt and ask. |
| DOM checks | No sideways scroll · clipped text · a lone card on its own grid row · numbers wrapping mid-value · `NaN` / `undefined` on screen · sticky or fixed bars covering content · tables scrolling inside their panel instead of the page · console errors. |
| Widths | The target widths (~420 / 900 / 1280 px), or only the presentation width for a demo check. |
| Coverage | Personas × pages, in demo mode and in live mode. |
| Safety | Read-only on live data: no writes, no destructive buttons, no admin refresh unless the user asks. |
| Output | A pass/fail matrix (page × width × persona × mode), ranked bugs (High / Low) and a SHIP / NO-SHIP verdict. For demos, also a backup screenshot pack. |

**Pair it with CSS and layout unit tests** (stylesheet brace depth 0, key rules present inside the
right media block, grids fit their item counts). They catch merge damage before the browser does,
and run on every merge in seconds.

## Questions to ask

Bank: [questions/07-planning-delivery.md](../questions/07-planning-delivery.md). Must-asks:
**L1, L2, L3, L4, L5**. Here, **L2** (definition of done) is the bar and **L8** (test strategy)
the method. When a test encodes an old rule, use
[09-change-conflicts.md](../questions/09-change-conflicts.md) (**C1–C5**).

## Artifacts produced

- Verification report per merge wave: gate line, findings, verdict (in `docs/verify/` or on the
  Board row).
- Screenshots at three widths; persona × page results.
- New Board rows for findings; feature-list items flipped to `passes: true` by the Verifier only.

## Agent roles involved

- [Verifier](../agents/verifier.md): type-check, suite, static checks, adversarial review,
  converge. Read-only plus test runs.
- [GUI Tester](../agents/gui-tester.md): 1–2, running while Builders work. Tester 1 core functions;
  Tester 2 layout sweep and bug rechecks. Each with its own persistent browser profile. Sign in only
  with the SSO button and the user's account; never type a password; on a password or MFA prompt,
  stop and ask the user to sign in in a headed window.
- [Coordinator](../agents/coordinator.md): turns findings into Board rows.

## Gate / definition of done

- [ ] Real type-check clean, with files checked > 0.
- [ ] Full suite green; gate line recorded.
- [ ] No High layout findings at any of the three widths.
- [ ] Persona × page matrix and role checks pass.
- [ ] Every P0 criterion has a passing test (converged).
- [ ] The diff had a cross-model APPROVE before the merge. This phase does not replace that review.
- [ ] Verifier and GUI Testers say SHIP / GO, with evidence.

## Rules and anti-patterns

- **The agent that built it never grades it.** A different model family reviews the diff before
  merge. The Verifier and GUI testers run after merge and do not replace that review. Why: fresh
  context catches the plausible but wrong. Practice: https://code.claude.com/docs/en/best-practices
- **Use a real type-check.** Why: in a solution-style config, a no-emit check covered zero files
  and hid a real type error through several "clean" rounds. Lesson: r1 §6.
- **Run the full suite on every merge.** Why: a Builder's own tests miss cross-area breakage.
  Lesson: r1 §6.
- **Three widths, demo and live.** Why: most layout bugs appear at mid widths or with long real
  names. Lesson: r1 §6. Practice: https://tailwindcss.com/docs/responsive-design
- **Timing guards under load.** Why: a 1.5 s guard flaked under the full parallel suite. Measure
  CPU time where you can, take the minimum of two runs, set the guard at ~3× solo time. Lesson: r1 §6.
- **Encode rules in tests.** Why: a rule in prose drifts; a test fails loudly. Lesson: r1 §6.
- **One tester, one browser profile.** Why: two testers on one profile clashed. Lesson: r1 §2.
- **Mostly integration tests, a few E2E journeys.** Why: best confidence per effort. Practice:
  https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications ·
  https://martinfowler.com/articles/practical-test-pyramid.html
- **Role-based locators, isolated tests.** Why: resilient tests that agents can debug. Practice:
  https://playwright.dev/docs/best-practices
- **Screenshot baselines in one environment only.** Why: rendering differs by OS. Practice:
  https://playwright.dev/docs/test-snapshots
- **Review only for correctness and requirements.** Why: chasing every finding leads to
  over-engineering. Practice: https://code.claude.com/docs/en/best-practices
- **Evals from real failures** for agent-facing features. Why: 20–50 real cases beat synthetic
  ones. Practice: https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- **Anti-pattern: "it passed" without evidence.** Every verdict names the commands and output.
  Lesson: r1 §5.1.
