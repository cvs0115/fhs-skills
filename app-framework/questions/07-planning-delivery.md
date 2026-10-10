# Bank 7 · Planning and delivery (L)

Used in: [00 Setup](../playbook/00-setup.md) (L3–L5), [08 Plan and tasks](../playbook/08-plan-tasks.md)
(L1, L2, L6–L9) and [11 Release](../playbook/11-release.md) (L3, L4, L11–L13).
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (L1–L5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| L1 ★ | What is the phasing: which slice ships first, end to end? | A thin vertical slice proves data, auth and deploy early. | Data + one landing page end to end, then page by page **(Rec)** · Backend first · UI on demo data first | always |
| L2 ★ | What is the definition of done for a piece of work? | One bar for every agent and every turn. | Real type-check + tests + browser sweep at 3 widths + persona review + docs and Board updated **(Rec)** · Lighter for a POC | always |
| L3 ★ | What is the release flow: branches, tags, and how a deploy is verified? | It stops shipping the wrong build and makes rollback possible. | main = deployed (tag v<version>), develop = integration; verify by the served build's content hash **(Rec)** · Trunk-based | always |
| L4 ★ | What needs the user's explicit OK (push, deploy, uninstall, scope change)? | Destructive and access-widening steps are gated (etiquette rule 5). | Each push, deploy, uninstall or scope change needs an OK, with a commit list and a secret scan **(Rec)** | always |
| L5 ★ | How is work tracked (Board columns, where it lives), and how often is it updated? | A shared Board keeps parallel agents and the user in sync. | Board in the repo docs (WIP · Next · Waiting on the user · Completed), updated with every request **(Rec)** · External tracker | always |
| L6 | What can run in parallel, and how many Builders? | Too many Builders cause merge conflicts. | Coordinator + at most 2–3 Builders in worktrees + a Verifier + read-only Researchers **(Rec)** · Single agent | if there are 2 or more independent pieces |
| L7 | Does each Builder get its own git worktree and branch, and how do they merge? | Isolation stops agents clobbering each other. | A worktree per Builder, merged to develop by the Coordinator after checks **(Rec)** · Shared tree | if L6 has more than one Builder |
| L8 | What is the test strategy per layer? | It catches the right bugs at the right cost. | A real build-mode type-check (not a no-op), domain unit tests, integration against dev, browser sweeps **(Rec)** | always (quick) |
| L9 | How many pages or steps per turn before stopping for questions? | It paces the review with the user. | One page or roadmap step per turn, then stop **(Rec)** · Batch several | always (quick) |
| L10 | Does frontend-only work need a deploy, or is the local dev server enough? | It avoids needless deploys. | Local dev server for UI-only work, a real deploy for backend and platform changes **(Rec)** | if there is a web UI |
| L11 | What is checked before every deploy (live version, config values, credentials)? | A deploy can overwrite live config. | Capture the live version and config before; restore them and test the credential after **(Rec)** | if deploys can overwrite config |
| L12 | What is the handoff package and log (what is copied, when, the change log)? | The handoff must reflect only shipped state. | Sync the handoff folder only after a verified deploy, and update its log **(Rec)** | if K11 is a handoff |
| L13 | Which versioning scheme? | It ties tags, packages and the change log together. | Date-based or SemVer, bumped from the **live** version **(Rec)** | always (quick) |

**Close the bank:** set up the Board ([templates/board.md](../templates/board.md)) and the Release
Checklist ([templates/release-checklist.md](../templates/release-checklist.md)) to match the answers.
