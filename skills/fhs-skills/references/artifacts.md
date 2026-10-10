# Tracking artifacts: the hub and plan pages (source of truth)

Decided 2026-10-09: the owner tracks fhs-skills work and build plans as artifacts. **Their databases
are the source of truth.** Claude sessions update them with the `ArtifactData` tool (load it with
ToolSearch `select:ArtifactData`). The Dropbox `state/setup-tracker.md` is a backup copy: refresh it
after updating the hub, never the other way round.

Only the owner (and anyone they make an Editor) can write; viewers only read.
Always pass `if_version` from your last read on writes to existing docs. If a write fails because
the version changed, re-read and redo it, never overwrite another session's change.

## FHS Skills Hub: https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc
Page source: `C:\Users\mayur\OneDrive\Documents\agent-payroll\fhs-hub.html` (republish only for layout changes; data goes in the db).

| Collection / doc | Fields |
|---|---|
| `skills/<skill-name>` | name, role, status (`live` / `planned`), order |
| `projects/<slug>` | title, store, status, step (now), next, waitingOn, planUrl, order, updatedAt (YYYY-MM-DD), updatedBy ("Claude - <job>") |
| `questions/<qN>` | text, project, status (`open` / `answered`), answer, order |
| `log/<YYYY-MM>` | entries: [{at, kind (`decision` / `built` / `status` / `fix`), text, project}] - one doc per month, append to its array |

Project status values: `not started`, `in progress`, `waiting on owner`, `blocked`, `done`.

## Build plan pages (one per project, made when the project starts)
| Project | URL | Page source |
|---|---|---|
| R365 inventory & food cost (122) | https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK | `agent-payroll\fhs-plan-r365-inventory.html` |

Plan page db:
| Collection / doc | Fields |
|---|---|
| `plan/meta` | title, store, goal, status, updatedAt, updatedBy |
| `phases/p<N>` | order, title, goal, status, steps: [{text, done}], check ("done when"), result, updatedAt |
| `notes/<YYYY-MM>` | entries: [{at, kind, text}] |

**New plan page:** copy `fhs-plan-r365-inventory.html` to `fhs-plan-<slug>.html` (flat in the
agent-payroll root - subfolders vanish there), change only the default title/store text and keep the
hub link, publish it with `capabilities: {"db": {"rules": [{"path": "", "read": "view", "write": "admin"}]}}`,
seed `plan/meta` + `phases` from the playbook, add the row above, and set `planUrl` on the hub project.

## What every session does
- **Start:** read the hub `projects` and `questions` (and the plan page's `phases` if working on one).
- **When a step finishes:** tick it in the plan's `phases` doc, set the phase `result` when it passes
  its check, update the hub project's `step` / `next` / `status` / `waitingOn` / `updatedAt`.
- **Owner answers a question:** set it `answered` with the answer; add new questions as they come up.
- **Decision made:** append to the hub `log/<month>` (and the plan's `notes/<month>` if it's about that plan).
- **Payroll runs:** append one `log` entry (store, period, "approved in ADP" or what's open). Payroll
  issues stay in the week folder's concerns.md.
- **End:** refresh the Dropbox setup-tracker.md backup from the hub.
