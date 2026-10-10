# Research · framework-setup · cursor-agent as the cross-model reviewer

2026-10-10 · Read-only checks on dev-lxc-1.

| Claim | Check | Result |
|---|---|---|
| cursor-agent is installed | `command -v cursor-agent` | `/root/.local/bin/cursor-agent`, version 2026.10.01-e373342 |
| It is signed in | `cursor-agent status` | logged in as the owner's account |
| Non-Claude models available | `cursor-agent models` | gpt-5.6-sol-high/xhigh, gpt-5.3-codex*, gpt-5.2, gemini-3.7-flash-high, grok-4.5/4.7, composer-2.5 (also Claude models, which review.sh refuses) |
| It can run read-only | `cursor-agent --help` | `--mode plan`: "read-only/planning (analyze, propose plans, no edits)"; `-p` prints for scripts |
| End-to-end run works | `scripts/review.sh --diff feat/framework-setup` | ~95 s, wrote a filled review form; r1 verdict APPROVE AFTER FIXES with 3 valid majors (no plan, framework prompts assume `develop`/`docs/board.md`, wrong command in CLAUDE.md) |
| It edits nothing | `git status` in the worktree after each run | only the review file the script itself writes |

Also found: Copilot CLI is installed under the VS Code server (`.../copilotCli/copilot`). Unused; fallback if cursor-agent is down.
Default model: `gpt-5.6-sol-high`. Override per run with `REVIEW_MODEL` (Claude names refused, exit 2).
