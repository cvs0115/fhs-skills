---
name: cursor-plan-mode
description: "Use cursor agent's read-only plan/ask mode for any read-only agent task (cheaper tokens); owner preference 2026-10-10"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1f700f6a-2df9-4ab1-ba8a-36dc0f212ae8
  modified: 2026-10-10T15:35:40.347Z
---

When a Cursor `agent` task is read-only (reviews, pre-checks, analysis, "list the problems", quick questions), launch it with `--mode plan` (or `--mode ask` for Q&A) instead of normal/--force mode. Builders, testers, researchers and Ops still need normal mode because they run commands or write files.

**Why:** the owner said on 2026-10-10: "planning tags make sense when required for those cursor model... keep that in mind since they use less tokens". Plan mode is also safer because it can't edit anything.

**How to apply:**
- `review.sh` already runs `--mode plan`.
- New read-only helper runs go through `agent -p --mode plan --model <included model>`.
- Before using bracket overrides like `[effort=low]` on Cursor Grok or Composer, verify that the model accepts them.

Related: [[agent-handoff-workflow]]
