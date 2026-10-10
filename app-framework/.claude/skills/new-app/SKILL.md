---
name: new-app
description: Start a new app with the framework. Walks the phases, asks the must-ask questions in batches of 1-4 (recommended option first), creates docs/board.md, docs/decisions.md, docs/prd.md and docs/personas.md from templates, and proposes the agent split. Use when the user says "new app", "start a project", or runs /new-app.
disable-model-invocation: true
---

# /new-app

You are the Coordinator starting a new app. Plan and ask before you create anything beyond the four
starter docs. Follow `questions/00-etiquette.md` throughout.

## Ground rules for this skill

- Ask with AskUserQuestion, 1–4 questions per batch, all on one topic. 2–4 mutually exclusive
  options each, the recommended option first labelled "(Recommended)" with a one-line reason, and
  "Other" when the list may not cover it.
- Before each batch, read what already exists (repo, docs, memory, anything the user pasted). Skip a
  question the material already answers and state it as an assumption instead.
- Log every answer the same turn in `docs/decisions.md` (format in `templates/decision-log.md`):
  sequential `D-nnn`, absolute date, bank id (K1, V3…), options offered, chosen by, reason.
  Defaults taken without asking go in as **Assumptions**.
- If an answer conflicts with an earlier one, use `questions/09-change-conflicts.md`. Don't override.
- Stop at the end of each step below and wait for the user before the next one.
- Create nothing outward-facing (remote repo, cloud resources, identities, scopes). Those are later
  phases and each needs an explicit OK.

## Step 0 · Right-size

Ask one question: what is being started?

- New app, vague idea → run every step below. **(Recommended when there is no PRD yet)**
- New app, clear feature list → steps 1, 3 briefly, then 2, 4, 5, 6.
- Small addition to an existing app → don't use this skill; plan it as a normal request.

## Platform add-ons

After kick-off, if the app runs on a platform with an add-on in `platforms/`, load it and ask its must-ask questions alongside the core banks:

- **UiPath:** read `platforms/uipath-framework.md` (start with the Top 20), `platforms/uipath-development-practices.md` and `platforms/uipath-cli-sdk-api.md`; ask the ★ questions in `questions/platform-uipath.md` (U1, U2, U8, U12, U21) during Step 4. Preflight read-only: `uip --version`, `uip tools list --output json`, `uip login status --output json`; the user runs `! uip login` themselves. Load UiPath skills in the order given in §16 of the add-on.

## Step 1 · Kick-off (`questions/01-kickoff.md`, `playbook/01-discovery.md`)

- Batch A: K1, K2, K3 (problem, users and audience, success metrics).
- Batch B: K4, K5 (+ K8 quick) (deadline or demo, out of scope, one-off vs product).
- Ask the conditional ones (K6, K7, K9–K12) only when their "Ask when" holds.
- Then create the starter docs (see "Files to create") and fill the PRD's problem, users, metrics
  and non-goals from the answers. Mark unknowns `[NEEDS CLARIFICATION]`.
- Close with a short summary (decisions, assumptions, open questions) and one confirm question.

## Step 2 · Personas and value (`questions/02-personas-value.md`, `playbook/02-personas-value.md`)

- Batch A: V1, V2 (personas, top jobs). Offer a drafted list for the user to correct.
- Batch B: V3, V4, V5 (what's concerning, tone and wording, persona switch or not).
- Fill `docs/personas.md`: one card per persona, their question, top jobs, concerns with data
  availability (have / approximate / needs collection), vocabulary and verdict labels.

## Step 3 · Requirements (`questions/03-requirements.md`, `playbook/03-requirements.md`)

- Batch A: Q1, Q2 (feature list with P0/P1/P2, acceptance criteria for each P0). Draft them first.
- Batch B: Q3, Q4, Q5 (data freshness, environments, scale).
- Update `docs/prd.md` (features, acceptance criteria, environments, scale) and put each feature on
  the Board under **Next** with its priority.

## Step 4 · Data and access (`questions/04-data-architecture.md`, `questions/05-integration-security.md`)

- Before asking D1, list the candidate data sources. If they are not validated, propose Researcher
  spikes (`agents/researcher.md`) instead of asking the user to guess. Don't offer options built on
  an unverified capability.
- Batch A: D1, D2, D3 (sources, refresh model, single writer).
- Batch B: D4, D5 (stable ids, retention).
- Batch C: S1, S2, S3 (identities, scopes per endpoint, groups and roles).
- Batch D: S4, S5 (secrets, who writes).
- Record hard-to-reverse choices as ADRs (`templates/adr.md` → `docs/adr/NNNN-title.md`).

## Step 5 · UI and delivery (`questions/06-gui.md`, `questions/07-planning-delivery.md`, `questions/08-operations.md`)

- Batch A: G1, G2, G3 (page inventory, key numbers per page, drill-downs).
- Batch B: G4, G5 (demo mode, widths and accessibility).
- Batch C: L1, L2, L3 (first slice, definition of done, release flow).
- Batch D: L4, L5 (what needs an OK, how work is tracked).
- Batch E: O1, O2, O3 (+ O4, O5 if there is a scheduled job) (support owner, failure alerts,
  diagnostics page, time budget, retries).

## Step 6 · Propose the agent split (`playbook/08-plan-tasks.md`, `agents/`)

Propose, don't start. Show a table and ask one confirm question:

| Role | Count | First task | Files it owns |
|---|---|---|---|
| Coordinator | 1 (this session) | Board, docs, merges | `docs/`, merges into develop |
| Researcher | 1–2 | validate each unverified source from Step 4 | none (reports) |
| Builder | 1 first, up to 2–3 once contracts exist | the first vertical slice from L1 | the slice's files |
| GUI Tester | 1–2 after the first merge | journeys + 3-width sweep | findings file |
| Verifier | 1 per merge wave | outcome checks | none (reports) |
| Docs Writer / Release Manager | when needed | demo script / first release | its one doc / checklist |

- Parallel Builders only on disjoint files; fix shared contracts (a JSON example per record) first.
- After the user confirms: add the rows to the Board from `templates/board.md` (two builder seats, queue of five), and offer to
  copy `CLAUDE.md`, `.claude/agents/`, `.claude/settings.example.json` and `hooks/` into the repo
  (see `playbook/00-setup.md`). Fill the `CLAUDE.md` placeholders from the answers. Standard layout:
  app code under `app/`, docs under `docs/`, and `handoff/` plus `archive/` in `.gitignore`.

## Files to create (Step 1, if they don't exist)

| Create | From | First content |
|---|---|---|
| `docs/board.md` | `templates/board.md` | empty WIP; kick-off follow-ups under Next; open questions under Waiting on the user |
| `docs/decisions.md` | `templates/decision-log.md` | D-001 onward from this session's answers |
| `docs/prd.md` | `templates/prd.md` | problem, users, metrics, non-goals from Step 1 |
| `docs/personas.md` | `templates/persona-sheet.md` | placeholder cards, filled in Step 2 |
| `docs/completed-work.md` | (empty) | heading only; the Board's Completed one-liners link here |

Replace `<APP_NAME>` and dates. Never overwrite an existing file: if one exists, read it and add to it.

## End of each step: report

```text
Step <n> done. Decisions: D-nnn … · Assumptions: … · Open: …
Files: <paths changed>
Next step: <n+1> — ready when you are.
```
