# fhs-skills

Claude skills and scripts for CMVK Food Services' Firehouse Subs stores (122 Cary 1, 878 Camden Square).
This repo on dev-lxc-1 is the master copy. Edit here, commit, then refresh the Windows mirror.

| Folder | What's in it |
|---|---|
| `skills/` | The fhs skills. `/root/.claude/skills/fhs-*` link here so server sessions load them. |
| `shared/` | `config.json` (one config for every fhs skill) and `state/setup-tracker.md` (backup of the hub) |
| `artifacts/` | Page sources for the hub and plan artifacts (the data lives in each artifact's database) |
| `scripts/` | Server-side helpers (notify, sync, scheduled runs) |
| `inbox/` | Reports that arrive by email or upload. Not in git. |
| `memory/` | Claude's memory notes for this project (the live copy since 2026-10-10, via `autoMemoryDirectory` in `.claude/settings.local.json`) |
| `build/` | Shortcut (gitignored) to `/srv/fhs-build`: builder clones and agent reports. The builder user can't reach `/root`, so the real folder stays outside |
| `CLAUDE.md` | How skills get built and changed: spec → research → plan → cross-model review → build → verify |
| `docs/` | Specs, research notes, plans, task files for coding agents (docs/prompts/), test plans for tester agents (docs/tests/), and review verdicts (forms in docs/templates/) |
| `app-framework/` | App Framework v2: playbook, question banks, agent roles, templates and lessons for building apps with Claude Code. Copied from `/root/trader-mayne/app-framework-v2` on 2026-10-10. |

Status and plans: FHS Skills Hub https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc

Rules:
- No passwords, tokens or bank details in git. Secrets go in `.env` (see `.env.example`), which the owner fills in.
- Payroll still runs from the Windows PC until the server can see Dropbox (server move plan, phase 7).
