---
name: agent-handoff-workflow
description: "Owner drives cursor agents (Composer 2.5 builder/tester/ops, Cursor Grok 4.6 research+review); Claude only writes plans and md hand-off files, never builds or runs ops"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8f560437-8b43-4b8a-87cc-7b5a62b0447d
  modified: 2026-10-10T04:14:18.498Z
---

The owner runs every build, test and root/ops step through cursor-agent sessions they start themselves. Claude writes each step as a self-contained `.md` file the owner hands over ("Do the task in docs/prompts/<x>.md", "Run the test plan in docs/tests/<x>.md"). Claude doesn't write code, run builds or do root ops. The master order is in `docs/RUNBOOK.md` in /root/fhs-skills.

**Why:** the owner said on 2026-10-10: "you as claude will plan... passed to the other agents to build and then test via the other agents like grok", "there should be an md that i can pass to the coding sub agents", "plan all the steps and i will pass to cursor agents". They don't paste prompts. They pass files.

**How to apply:**
- Every plan comes with a task file (`docs/prompts/`) and a test plan (`docs/tests/`, run by a fresh Grok session; browser tests via Playwright on the server or Chrome on the Windows PC).
- Agent roster: see CLAUDE.md "Roles" (owner decision 2026-10-10: included Cursor models only). Composer 2.5 builds, tests and runs ops; Cursor Grok 4.6 High researches; Cursor Grok 4.6 Extra High reviews Claude's plans and Composer's code; Composer 2.5 reviews Grok's research. The reviewer is never the writer's family.

Related: [[tech-stack-agent]]

**Update 2026-10-11 (token savings, owner chose all three):** Claude writes a one-page brief and Cursor Grok High drafts the plan, task file and test plan (Composer reviews those). Minor review fixes go back to the writer's model; Claude handles only majors, REJECTs and 3rd rounds. Claude now starts the agents headless in the background and reads only verdict lines and report `## Summary` sections. Rules: CLAUDE.md "Roles" and "Token budget".
