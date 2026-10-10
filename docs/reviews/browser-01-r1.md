# Review · browser-01

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

REJECT. Do not build; prerequisite research and the runtime design need a new plan and review.

## Majors

- This adds new scripts without a spec and puts essential research after planning. `CLAUDE.md` requires spec → research → plan for a new script. The existing research explicitly leaves the shared browser, persistent profile, headed mode, sandboxing, and MCP registration unverified. Complete the spec and research first, update `tech-stack.md` with confirmed facts, then redesign the plan.
- The runtime served tree is unresolved. Done-checks run services from the feature worktree, but the plan never switches their executable paths to a stable post-merge location. Name the exact `ExecStart` paths and include post-merge reload and real-outcome verification.
- Chromium appears intended to run as root and potentially with `--no-sandbox`. Restricting origins does not contain a compromised browser. Run the browser and MCP service as a dedicated unprivileged account with a protected profile and explicit unit hardening.
- `browser-lock.sh` cannot refuse direct MCP requests from another client. The proposed check proves only that the helper reports a lock, not that concurrent browser control is blocked. Enforce locking at the MCP access path or accurately describe it as advisory and revise the acceptance check.

## Minors

- Pin the researched MCP and browser versions instead of leaving `@latest` in the procedure.
- Verify authenticated redirect chains for Toast and ADP as well as R365, or narrow the stated supported outcome.
- Call profile deletion a profile reset, not a clean sign-out.
