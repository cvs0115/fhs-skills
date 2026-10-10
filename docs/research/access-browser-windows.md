# Research · access · Browser and Windows reach from dev-lxc-1

2026-10-10 · Read-only checks on the server.

## Found

| Check | Result |
|---|---|
| Browsers installed | none (`chromium`, `google-chrome`, `firefox` not found; no `~/.cache/ms-playwright`) |
| Display tools | `xvfb-run` present; `node` and `npx` present |
| MCP servers, Claude Code | none (`~/.claude.json` has no `mcpServers` at any level) |
| MCP servers, cursor-agent | none (`cursor-agent mcp list`: no `~/.cursor/mcp.json`) |
| Claude in Chrome | skill listed, but its tools aren't connected in server sessions (the extension talks to a local Claude on the PC) |
| Server → Windows PC | no link: no SSH host entries for the PC, Dropbox not synced on the server |
| Windows PC → server | exists: the owner reaches dev-lxc-1 by an SSH alias (memory note, 2026-10-09) |
| Windows tooling | no git on Windows (memory note); Windows `C:\Users\mayur\.claude\skills\fhs-*` is the payroll mirror |
| cursor-agent models | Grok 4.7 (low…xhigh), Grok 4.6, Grok 4.5, GPT-5.6 Sol/Terra/Luna, Codex 5.3, Gemini 3.x, and Claude models |
| cursor-agent options | `-p` print, `--mode plan|ask` (read-only), `--force` (runs commands), `--sandbox enabled|disabled`, `--workspace`, `-w/--worktree` |

## Owner decisions (2026-10-10)

- Builders: cursor-agent on **grok-4.7-high**. Plans by Claude, reviews by GPT-5.6 Sol.
- Browser: **a browser on the server that the owner can see**, which Claude and cursor-agents drive.
- Windows: **an agent on the Windows PC** for Windows-only steps. No server → PC link.

## Unverified, to settle in each plan's research step `(?)`

- Playwright MCP: one shared browser for two clients over HTTP (`--port`), persistent profile flag,
  and headed mode on an Xvfb display. Check against the package's `--help` at install time.
- Chromium inside an LXC container: whether its sandbox needs `--no-sandbox` or an LXC nesting setting.
- What `cursor-agent --sandbox enabled` restricts on Linux (file writes outside the workspace? network?).
- cursor-agent on Windows: installer, sign-in, and whether `--sandbox` exists there.
- Whether Toast, R365 and ADP accept a login from the server's IP without extra verification (MFA or new-device prompts).
- R365 and Toast API or report-email options that would avoid the browser for some data.
