# <APP_NAME> · Decision Log

Append only. One entry per answered question or batch, written the same turn. The Coordinator owns
this file.

**Rules**
- IDs are sequential (`D-001`, `D-002`, …) and never reused. Dates are absolute (YYYY-MM-DD).
- `Bank/Q` points at the question id in `questions/` (K3, D2, …), or "ad hoc".
- `Status` is one of **Active** · **Superseded** · **Reverted** · **Exception (scoped)**.
- Defaults taken without asking go under **Assumptions**, so the user can challenge them later.
- Decisions the Coordinator made in a delegated window say "Chosen by: Coordinator (delegated)".
- A rule change never deletes the old entry: mark it `Superseded by D-mmm (date)`, strike through
  the old decision text, and add the new entry with `Supersedes D-nnn` and the reason.
- Hard-to-reverse architecture choices also get an ADR (`docs/adr/`); link it here.

## Entry format

```markdown
### D-012 · 2026-01-15 · Refresh model
- Bank/Q: D2 (Data architecture)
- Decision: One nightly collector (01:00) feeds all pages; admin-only "Refresh now".
- Options offered: Nightly + manual (Recommended) · Live per page · Hybrid
- Chosen by: user (chat) · Status: Active
- Reason: API rate limits; freshness under 26 h is enough for every persona (Q3).
- Consequences: UI never calls source APIs; diagnostics page shows the last run.
- Supersedes: — · Superseded by: —
- Assumptions (defaults taken, not asked): D7 measure limits live.
- Links: ADR-0003, Board row <ROW_ID>
```

## Example of a superseded rule

```markdown
### D-020 · 2026-01-20 · Tables on the landing page
- Bank/Q: C1 (Change / rule conflicts)
- Decision: ~~No tables on the landing page; tiles and charts only.~~
- Status: Superseded by D-031 (2026-02-03)

### D-031 · 2026-02-03 · Tables on the landing page
- Bank/Q: C1, C2
- Decision: One sortable "needs attention" table is allowed on the landing page.
- Options offered: Allow one table (Recommended) · Keep the rule, move the table to a detail page
- Chosen by: user (chat) · Status: Active
- Reason (C4): support needs a sortable list at first glance.
- Consequences: the layout test that forbids tables now allows exactly one; retrofit none.
- Supersedes: D-020
```

## Log

<!-- New entries below, oldest first. -->
