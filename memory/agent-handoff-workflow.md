---
name: agent-handoff-workflow
description: "Owner drives cursor agents (Grok builder/tester/ops, GPT reviewer); Claude only writes plans and md hand-off files, never builds or runs ops"
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
- Agent roster:
  - Ops: grok-4.7-high as root, no --force, so the owner approves each command.
  - Builder and Tester: grok-4.7-high as user `fhsbuild` in /srv/fhs-build clones.
  - Reviewer: gpt-5.6-sol-high through scripts/review.sh.
- The GPT reviewer runs inside cursor. It exists only so the writer's model family never reviews its own work.

Related: [[tech-stack-agent]]
