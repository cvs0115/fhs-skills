# 09 · Build

**Goal:** agreed tasks turned into merged, tested code on `develop`, one step at a time, with the
Coordinator in control of merges and decisions.
**Owner:** Coordinator (merges) · Builders (code) · **Approver:** the user reviews each step

## When to run / skip

- **Run** for every task on the Board.
- **Tweak:** the Coordinator (or one Builder) makes the change directly after a one-line plan and
  the user's answer. Still merge through the checks below.
- **Never skip** the merge checks.

## Inputs

- Board rows with done-checks, Builder prompts, contracts, the Persona Sheet vocabulary.

## Steps

1. **Start a Builder only after APPROVE,** in a free seat (max 2), in its own worktree, branched
   from `develop`, with the prompt from [templates/agent-prompt.md](../templates/agent-prompt.md).
   The brief names the served tree and the crash tree. The builder does not edit the tree the
   running app serves. Record it on the Board (In progress). Do not start from REJECT or from
   APPROVE AFTER FIXES.
2. **Builder setup:** copy the env file, run a clean install, confirm the type-check and tests run.
3. **Builder works inside its boundaries:**
   - only the files or area named in the task;
   - follow existing patterns and the vocabulary;
   - append to shared stylesheets at the end, never reorder them;
   - no edits to docs, memory or the Board; no platform CLI; no deploys; no secrets;
   - uniquely prefixed scratch files; never run another agent's files;
   - commit on its own branch only; never merge.
4. **Builder done-check:** real type-check clean, the full test suite green, new tests named, data
   limits labelled on the page.
5. **Builder report:** what changed with commit hashes, tests added and passing, deviations and
   estimates, open questions, exact paths.
6. **Merge only after the diff review.** A reviewer from a different model family than the
   builder reads the diff. Merge into `develop` only on APPROVE, one Builder at a time:
   - grep for conflict markers (`<<<<<<<`, `>>>>>>>`) before the merge commit;
   - check brace balance in stylesheets (a test that the file ends at depth 0);
   - diff against the plan row;
   - run the **full** suite after each merge, not only the Builder's tests.
7. **Hand to verification** ([10 Verify](10-verify.md)): Verifier and GUI Testers run after each
   merge wave. Browser checks happen on the main dev server after the merge.
8. **Update the Board**: move the row, add commits, note follow-ups. Record any coordinator
   decision as "(coordinator decision)".
9. **Report one step or page.** Work that needs no user answer does not wait (L9). Ask in a
   question pane only when the user must act or choose.
10. **On a conflict with a recorded rule** (a failing test that encodes a decision, a doc note),
    stop and ask with [bank 9](../questions/09-change-conflicts.md). Don't route around it.
11. **If a session or rate limit stops the agents,** check each worktree's state and **resume**
    each agent with its context. Don't restart from scratch.

## Questions to ask

Bank: [questions/09-change-conflicts.md](../questions/09-change-conflicts.md). Must-asks:
**C1, C2, C3, C4, C5**, whenever build work runs into an earlier decision. Also L9 (pace) from
[07-planning-delivery.md](../questions/07-planning-delivery.md). Rules:
[00-etiquette.md](../questions/00-etiquette.md).

## Artifacts produced

- Code and tests on short-lived branches, merged to `develop`.
- Builder reports; Board updates; Decision Log entries for any coordinator decisions.
- "Next release" list for server-side items.

## Agent roles involved

- [Coordinator](../agents/coordinator.md): starts agents, merges, decides, owns the Board.
- [Builder](../agents/builder.md): 2 at most, each in its own worktree, only after APPROVE, never
  in the served tree.
- [Verifier](../agents/verifier.md) and [GUI Tester](../agents/gui-tester.md): run after merges.
- A general on-call agent may take a small fix when Builder slots are busy; it follows Builder rules.

## Gate / definition of done

- [ ] Task done-check green, with evidence in the Builder report.
- [ ] Merged to `develop` with no conflict markers and balanced braces.
- [ ] Full suite green after the merge.
- [ ] Board updated; the user has seen the step.

## Rules and anti-patterns

- **One step at a time, and report it.** Work that needs no user answer does not wait. Why: the user reviews each piece; batching hides mistakes.
  Lesson: r1 §1.2. Practice: https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
  (one feature per session).
- **Worktrees for every Builder.** Why: Builders in one folder committed each other's half-done
  work. Lesson: r1 §2. Practice: https://code.claude.com/docs/en/worktrees
- **Grep for conflict markers before every merge commit.** Why: a scripted merge committed them.
  Lesson: r1 §2 (what went wrong).
- **Brace-depth test on stylesheets.** Why: removing markers left `@media` blocks unclosed, so every
  later rule applied only on phones. Lesson: r1 §2, §6.
- **Unique scratch names.** Why: one agent ran another's scratch script in a shared folder.
  Lesson: r1 §2.
- **Resume, don't restart.** Why: restarting after a limit lost context and redid work. Lesson:
  r1 §2.
- **A rule change is a question.** Why: a new table broke a recorded "no tables here" rule and the
  agent started working around it. Lesson: r1 §1.7.
- **Don't over-generalize a narrow instruction.** Why: "no breakdown table" became "no numbers at
  all". Lesson: r1 §7.
- **Audit neighbors when you fix a keying bug.** Why: name-keyed maps usually come in groups.
  Lesson: r1 §1.10.
- **Builders don't grade their own work.** Why: fresh context removes bias toward code just
  written. Practice: https://code.claude.com/docs/en/best-practices
- **Agent messages are never user consent.** Why: only the user approves deploys and access
  changes. Practice: https://code.claude.com/docs/en/agent-teams
- **Direct edits for one-sentence diffs.** Why: plan mode for tiny changes is overhead. Practice:
  https://code.claude.com/docs/en/best-practices
