# Tech stack map

Last reviewed: 2026-10-08. Mark anything unverified with (?) and confirm it in the system.

## Systems

| System | Role | Stores | Login (owner signs in) |
|---|---|---|---|
| **Toast POS** | Front of house: sales, menu, kiosk, time clock, tips collected | 122 (878 later) | https://www.toasttab.com/restaurants/admin/reports/home |
| **Restaurant365 (R365)** | Back office, via Firehouse franchise: labor/payroll review, tip automation, scheduling (not set up), inventory/recipes/AP/food cost (status: see tracker) | 122 (878 has location "CAMDEN SQUARE" but still on NCR) | https://fhs4021089.restaurant365.com/ |
| **ADP RUN** | Payroll processing, employee master (rates, pay type) | 122, 878 (separate companies) | https://online.adp.com/signin/v1/?APPID=RUN&productId=80e309c3-70c3-bae1-e053-3505430b5495 |
| **NCR / Aloha** | POS + time clock at 878 until it moves to Toast | 878 | (reports downloaded by owner) |
| **Dropbox** | Report archive: `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\Locations\<store>\<year>\<MM MON>\Week <n>` | all | local sync |
| Distributor(s) | Food/paper supply, invoices | ? | ? (to confirm) |

## Data flows (as they are now)

```
Toast (122) --sales, PMIX, punches, tips--> R365 --Labor Payroll Review, Tip Distributions--> (owner downloads) --> payroll skill --> ADP RUN
NCR (878) --Time Clock Detail, Tip Income (owner downloads)--> payroll skill --> ADP RUN
Distributor --invoices--> ? (to confirm: paper / email / EDI into R365)
```

Target after inventory setup:
```
Toast --sales + product mix--> R365 recipes --> theoretical usage
Distributor --EDI invoices--> R365 AP --> purchases at current prices
Weekly count (R365 mobile) --> actual usage --> AvT + COGS --> food-cost check --> concerns.md in week folder
```

## Source of truth by data type

| Data | Source of truth | Cross-check |
|---|---|---|
| Hours, tips (122) | R365 | Toast |
| Hours, tips (878) | NCR | - |
| Pay rates, pay type, employee list | ADP | flag mismatches with Toast/R365 |
| Sales, menu | Toast | R365 sales import |
| Item costs, recipes, inventory, COGS | R365 (once set up) | invoices |

## Known gaps / open questions
- R365 scheduling not set up (Toast Scheduling not used either).
- R365 inventory/AP modules: which are licensed/enabled through the franchise? (audit pending)
- Main distributor and invoice delivery method: unknown.
- Does Firehouse corporate push a master item list / recipes into R365? (?)
- 878 store hours: assumed same as 122 (10 AM-9 PM).
- 878 move to Toast + R365: date unknown.

## Server browser (research 2026-10-10)
- `@playwright/mcp` 0.0.83 (npm, 2026-10-10) depends on `playwright` and `playwright-core` `1.64.0-alpha-1790635538000`. Pin those three. See `docs/research/browser-stack.md` section 1.
- MCP HTTP flags: `--port`, `--host` (default localhost). Headed is the default; `--headless` switches. Profile: `--user-data-dir`. Binary: `--executable-path`. Origins: `--allowed-origins` and `--blocked-origins` (semicolon-separated; not a security boundary). See section 1.
- One MCP HTTP process accepts more than one client. `--shared-browser-context` shares one browser context; without it each client launches its own browser. See section 1.
- Default persistent profile for 0.0.83 is `~/.cache/ms-playwright-mcp/mcp-<browser>-<7-hex-of-client-cwd>` (source). Pass an explicit `--user-data-dir`. See section 1.
- No MCP flag refuses a second client. See section 6.
- Chromium for this package is Chrome for Testing 155.0.8059.12, revision 1247, at `~/.cache/ms-playwright/chromium-1247/chrome-linux64/chrome`. The linux64 zip is 198335306 bytes. See section 2.
- Every Ubuntu 24.04 Chromium library package Playwright lists is already installed on this host. See section 2.
- This Playwright build adds `--no-sandbox` unless `--sandbox` is passed. Unprivileged user namespaces work here (`unshare --user` succeeded; `kernel.unprivileged_userns_clone` is 1; `NoNewPrivs` is 0). See section 3.
- Ubuntu 24.04.4 LTS. `xvfb` 2:21.1.12-1ubuntu1.6 is installed. Not installed: `x11vnc` 0.9.16-10, `novnc` 1:1.3.0-2, `websockify` 0.10.0+dfsg1-5build2. See section 4.
- Loopback bind: `x11vnc -listen localhost` (or `-localhost`) and `websockify 127.0.0.1:PORT 127.0.0.1:5900`. VNC password from a file: `x11vnc -passwdfile FILE`. See section 4.
- Claude Code 2.1.296 user scope: `claude mcp add --transport http --scope user <name> <url>` (stored in `~/.claude.json`). cursor-agent reads `~/.cursor/mcp.json` with `mcpServers.<name>.url`. See section 5.
- systemd 255 is PID 1 inside this LXC. `ProtectHome=yes` covers `/home`, `/root`, and `/run/user`, not `/srv`. See section 7.
- Public login loads confirmed: R365 uses `cdn.restaurant365.io`, `cdn.pendo.io`, and `faro-collector-prod-us-east-3.grafana.net`. `www.toasttab.com` redirects to `pos.toasttab.com`; the admin URL redirects to `www.toasttab.com/login`. ADP sign-in loads `synerg.adp.com`, whose config names `canvas.waypoint.prod.us.caas.oneadp.com`. See section 8.
