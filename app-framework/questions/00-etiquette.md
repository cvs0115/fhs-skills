# Question etiquette and the Decision Log

The Coordinator uses the banks in this folder to plan **before** building. Each bank is a
checklist, not a script. Ask only what the docs, code, Board and Decision Log don't already answer.

| Bank | File | Used in phase |
|---|---|---|
| 1 · Kick-off and goals (K) | [01-kickoff.md](01-kickoff.md) | [01 Discovery](../playbook/01-discovery.md) |
| 2 · Personas and value (V) | [02-personas-value.md](02-personas-value.md) | [02 Personas and value](../playbook/02-personas-value.md) |
| 3 · Requirements (Q) | [03-requirements.md](03-requirements.md) | [03 Requirements](../playbook/03-requirements.md) |
| 4 · Data architecture (D) | [04-data-architecture.md](04-data-architecture.md) | [04 Research spikes](../playbook/04-research-spikes.md), [05 Architecture and data](../playbook/05-architecture-data.md) |
| 5 · Integration and security (S) | [05-integration-security.md](05-integration-security.md) | [06 Security and access](../playbook/06-security-access.md) |
| 6 · GUI (G) | [06-gui.md](06-gui.md) | [07 UI](../playbook/07-ui.md) |
| 7 · Planning and delivery (L) | [07-planning-delivery.md](07-planning-delivery.md) | [00 Setup](../playbook/00-setup.md), [08 Plan and tasks](../playbook/08-plan-tasks.md), [11 Release](../playbook/11-release.md) |
| 8 · Operations (O) | [08-operations.md](08-operations.md) | [12 Operate and handoff](../playbook/12-operate-handoff.md) |
| 9 · Change and rule conflicts (C) | [09-change-conflicts.md](09-change-conflicts.md) | Any phase, whenever new input contradicts a recorded decision |

## How to read the tables

- **★ = must-ask.** Each bank has exactly 5. Ask them before the phase counts as planned.
- **Options:** the first option, marked **(Rec)**, is the recommended default and is offered
  first. Add "Other" when the list might not cover the answer.
- **Ask when:** `always`, or the condition that triggers the question. If the condition doesn't
  hold, skip the question and log the default as an assumption.
- **IDs are stable** (K1, V3, D4 …) so decisions can point back to them ("answers K3").
- **Question IDs vs decision IDs:** a question ID has no hyphen (`D4` = data question 4). A
  decision ID has one (`D-012` = decision 12 in the Decision Log).

## The 10 etiquette rules

1. **Batch 1–4 questions**, all on one topic. Wait for the answers, record them, then send the
   next batch. Never send a wall of 20.
   **Question pane (beside the batch).** When the user must act or choose, the request is a
   question pane: a select, recommendation first and marked, worded so they can answer without
   the chat. A paragraph is not the request. Do not assume they read the chat. The Board is the
   plan, not a place to ask. Review closes gaps in a plan; those gaps are not questions for the
   user. Work that does not need them keeps moving the same turn.
2. **Recommended option first**, labelled `(Recommended)`, with a one-line reason. Give 2–4
   mutually exclusive options. Add "Other" when it fits.
3. **Don't ask what is already written down.** Read the docs, code, Board, Decision Log, memory
   and API references first. If they answer it, *state* it as an assumption ("I'm assuming X,
   per docs/architecture.md") instead of asking.
4. **Ground every question in evidence.** Don't build a menu on a guessed capability. Validate
   the API live or against its docs first. If you can't, the first question is "Can you give me
   a reference, an example or a recorded trace (HAR) for X?"
5. **Always ask before destructive or access-widening actions:** deletes, uninstalls, overwrites,
   force-push, schema drops, new scopes or roles, new external apps, publishing outside dev,
   sharing data. An earlier general "go ahead" doesn't cover them. Ask each time and name the
   blast radius.
6. **A pure "what is X?" question gets a direct answer.** No question batch. Offer to plan after.
7. **Record every answer** in the Decision Log in the same turn, with the date, the bank ID and
   who answered.
8. **A conflict is a question, not an override.** If an answer contradicts an earlier decision,
   switch to [bank 9](09-change-conflicts.md). Never silently apply the newer answer.
9. **Order within a phase:** must-asks first, then the questions whose answers change the most
   downstream work, then nice-to-haves. Stop when the rest can safely take their defaults.
10. **Close each phase** with a short summary: decisions, defaults taken as assumptions, open
    questions. Ask for one confirmation ("Anything wrong here?").

## Delegated decision windows

The user may let the Coordinator answer questions itself for a set window (for example "decide
the UI details for the rest of today, reasoning as each persona").

- Mark every such entry `Chosen by: Coordinator (delegated)` so the user can review or reverse it.
- Never delegated: deploys, destructive live changes, anything that widens access (rule 5).

## Decision Log format

One entry per answered question or batch. It lives in the project docs (see
[templates/decision-log.md](../templates/decision-log.md)). Append only.

```markdown
### D-012 · 2026-09-26 · Refresh model
- Bank/Q: D2 (Data architecture)
- Decision: One nightly collector (01:00) feeds all pages; admin-only "Refresh now".
- Options offered: Nightly+manual (Recommended) · Live per page · Hybrid
- Chosen by: user (chat) · Status: Active
- Reason: API rate limits; freshness under 26 h is enough for all personas (Q3).
- Consequences: UI never calls source APIs; diagnostics page shows last run.
- Supersedes: — · Superseded by: —
- Assumptions (defaults taken, not asked): D7 measure limits live.
```

Rules:

- The date is absolute (YYYY-MM-DD). IDs are sequential and never reused.
- `Status` is one of: Active · Superseded · Reverted · Exception (scoped).
- Defaults taken without asking are logged as **Assumptions**, so the user can challenge them later.
- The phase summary (rule 10) lists the D-IDs it covers.
- **Changing a decision:** never delete or edit the old entry's text. Mark it
  `Superseded by D-mmm (date)`. The new entry says `Supersedes D-nnn` and gives the reason (C4).
  Where a rule is also quoted in another doc, strike the old text through and add the new text
  beside it, dated.

## Sources behind the banks

INVEST and Given/When/Then acceptance criteria (Agile Alliance) · MoSCoW (DSDM) · ISO/IEC 25010
quality characteristics · Google SRE book (SLOs, error budgets, alert on symptoms) · OWASP ASVS and
the OWASP Threat Modeling Cheat Sheet (STRIDE) · WCAG 2.2 AA · Twelve-Factor App (config, secrets,
dev/prod parity) · Nygard ADRs · SemVer · Keep a Changelog.
