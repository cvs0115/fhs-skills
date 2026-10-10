---
name: tech-stack-agent
description: "fhs-skills = owner's Firehouse skill library; the fhs-skills skill is the front door (stack explainer, routing, setup playbooks); shared home in Dropbox holds config + setup tracker"
metadata:
  node_type: memory
  type: project
  originSessionId: 7ea7fc92-25d9-44aa-9b05-8ac214be32bf
  modified: 2026-10-10T03:19:47.121Z
---

Library decided 10/9/26: all Firehouse skills are named `fhs-*`, kept as plain skills in `C:\Users\mayur\.claude\skills\` (no plugin for now).
- `fhs-skills` = front door (was `fhs-tech-stack`, created 10/8/26): explain the stack, route payroll, setup playbooks (R365 inventory first), weekly food cost.
- `fhs-payroll-adp` = payroll (see [[payroll-skill]]).
- Planned, built only when the work starts: `fhs-food-cost`, `fhs-r365-setup`, `fhs-store-migration` (878 NCR → Toast/R365). Owner chose not to create empty starters.
- Shared home: `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\fhs-skills\` → `config.json` (one config for every fhs skill) and `state\setup-tracker.md` (backup only since 10/9/26).
- 10/9/26: work and build plans tracked as artifacts with db = source of truth, updated by Claude sessions (owner's "channels" = other Claude sessions). Hub https://claude.ai/artifact/3sTTMm7cFeFZxPT3Kcgnqc + one plan page per project (R365 inventory https://claude.ai/artifact/NuVtNa2Gdtv7fcboRgF9WK). Details in fhs-skills `references/artifacts.md`.

- 10/9/26: moving to server dev-lxc-1 (SSH alias, Ubuntu, UTC clock). Master = git repo `/root/fhs-skills` (local git, no GitHub); `/root/.claude/skills/fhs-*` symlink into it. Windows copies are a mirror; Windows has no git. Server can't see Dropbox yet → payroll stays on Windows. ntfy is self-hosted on a different server of the owner's (URL/topic pending). Owner OK'd scheduled Toast/R365 report emails for hands-off runs. Plan: https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG

**Why:** owner wants one Firehouse library with consistent naming, backed-up shared settings, and setup that follows the recommended design (R365 = back office, Toast feeds it, weekly Sunday count, all menu items mapped, electronic invoices).
**How to apply:** new fhs skills read the shared config and never duplicate store facts; add them to the fhs-skills library table. Owner asked to plan and ask questions before coding/finalizing changes.

Related: [[payroll-skill]], [[payroll-rules]], [[login-urls]]
