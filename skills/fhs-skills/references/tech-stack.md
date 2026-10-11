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
| Distributor(s) | Food/paper supply, invoices | 122: Cheney Brothers (2026-10-11 audit); 878 ? | R365 Accounting → Vendors; how invoices arrive (EDI/email/manual) still ? |

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

## Store 122 screen check (2026-10-10, partial, read-only)

Where this overlaps `## Store 122 audit (2026-10-11)` below, the audit is newer and wins.

Seen while signed in. Not a finished audit.

- Inventory counts: `https://fhs4021089.restaurant365.com/react/inventory/inventory`. Three Cary 1 rows. Template name **CARY 1 - FHS Weekly Inventory**. One count dated 10/04/2026 is Approved. One dated 09/28/2026 is In Progress. Column titles for the dollar amounts were not read.
- Purchased items: Inventory → Items, `https://fhs4021089.restaurant365.com/react/inventory/purchase-items`. The grid says **1–250 of 551**. First rows are Firehouse-style names (bag paper, sandwich bags, bagasse bowls, beverages). Avg / Min / Max Cost on those rows show **$0.00**. Units are filled in (Each, Pack, CS). A search for TURKEY showed **MEAT TURKEY - 1001190**, Avg Cost **$3.56**, Min **$3.45**, Max **$3.66**, reporting and inventory unit **LB**. The number on the name looks like a corporate item code. Who owns the list is still unconfirmed. Left menu also shows Invoices, Units of measure, Item categories, Item locations, Storage locations, Vendor items, and Recipes.
- After sign-in the landing page is the Firehouse Subs Operations dashboard.
- Recipes: Inventory → Recipes → Recipes, `https://fhs4021089.restaurant365.com/react/inventory/recipe-items`. View name **Recipes - R365**, no filters. The grid says **1–250 of 2331**. A search for HOOK AND LADDER returned 16 recipes. The first, **MI 6in Hook and Ladder Box - 400120**, was opened read-only and closed with no save prompt. Ingredients: P-Fully Involved Box 6in - 1130237 (1.00 Each), P-Ham 1oz - 1076736 (1.50 Each), P-Turkey 1oz - 1076720 (1.50 Each), P-Provolone 1sli - 1272379 (1.50 Each). Current cost **$1.1858**. The recipe tabs are General, Recipe, U Of M Equivalence, Ingredients, Recipes On, Steps, Location Settings, and Location Costing. No POS field on the recipe. Menu items are at `https://fhs4021089.restaurant365.com/react/inventory/legacy/MenuItems` (not in the left menu that was visible). Filtering Recipe by 400120 shows one linked POS menu item: **400120 - 6" Turkey & Ham**, created 3/26/2026, last modified 7/15/2026 by **R365**, estimated cost **$0.00**. The page does not name the POS (Toast or other). With the Recipe filter cleared, the grid says **1–250 of 64654**. The Recipe filter cannot select a blank recipe. That total is the whole list, not a Cary 1 count.
- Invoices: Inventory → Invoices. The page title is **Invoices**. Unfiltered grid says **1–250 of 269**. For CARY 1 from 08/11/2026 through 10/10/2026 there are **28** invoices. Newest date **10/09/2026**, two Cheney Brothers invoices still In Progress: #9100633686 ($481.67) and #9100633687 ($1,916.30). Also Cheney Brothers #9100612350 on 10/06/2026 ($1,983.60) and #9100594310-CARY on 10/02/2026 ($1,832.25, Approved). Approved invoice **#9100594310-CARY** (10/02/2026, $1,832.25) was opened read-only. It has 36 lines. Missing Items is **No**. Lines show an R365 item, a Cheney item number, and a GL account. Example: PROD CUCUMBERS - 1001207 matched to Cheney 00432381 "CUCUMBERS SUPER 6 COUNT", $16.12. No Created By, Source, EDI, email, or attachment field. The Alerts tab has three Threshold Violation alerts on misc charge lines ($2.50, -$3.70, $10.36), not unmatched items. The screen does not say whether the invoice arrived by EDI, email, or typing. The Cheney item numbers on the lines are the evidence so far.
- Daily sales: search “Daily Sales” opens Daily Sales Summary at `https://fhs4021089.restaurant365.com/react/sales-and-forecasting/daily-sales`. The list has **724** days for CARY 1 and CAMDEN SQUARE. Newest CARY 1 day is **10/09/2026**: net sales **$2,046.26**, **118** guests, over/short **-$208.16**, status In Progress. CARY 1 days from 10/06/2026 on are In Progress. 10/05/2026 and earlier are Completed. The 10/09/2026 CARY 1 day was opened read-only. It does not name Toast. Labor headings include **POS Cash Tips** and **POS Credit Tips**. A payment type **DoorDash Local - CARY 1** is on the comps. Labor hours are **36h 50m** worked against **22h 30m** scheduled. Labor dollars and Labor % are **$0.00**. A login named Cashier2 shows 15h 55m worked with nothing scheduled. Guest count is blank on the day even though the list shows 118. Deposits for that day is one row, Deposit #1, and every amount is **0.00** (cash, coin, check, unpaid cash tips, and each bill count). Total Deposit shows a red X. Expanding Deposits made Save clickable. Save was not pressed, and the list row did not change. Nothing was approved.
- Actual vs Theoretical Analysis opens from search into `https://fhs4021089.restaurant365.com/#/ReportViewer` and shows the error **The 'ToCount' parameter is missing a value.** No numbers and no setup form were on that screen. Related names in search, not opened: Actual vs Theoretical Location Summary, and Above-Store Actual vs Theoretical Analysis. The report was not run.
- Screenshot: `/root/fhs-skills/inbox/purchase-items.png`.

## Known gaps / open questions

Check `## Store 122 audit (2026-10-11)` below and `docs/research/store-audit-122.md` first; some gaps here are answered there.
- R365 scheduling not set up (Toast Scheduling not used either).
- R365 for store 122 already has items (551), recipes (2331, with ingredients), a linked menu item for the 6" Hook and Ladder, Cheney Brothers invoices, weekly inventory counts, and daily sales through 10/09/2026. Still open: whether daily sales are labeled Toast, whether labor imports, waste, and scheduling. Franchise ownership is likely and not fully confirmed.
- Main distributor for recent Cary invoices is Cheney Brothers. Invoices are in R365 (28 for CARY 1 from 08/11/2026 to 10/10/2026). An approved invoice's lines are matched to R365 items and carry Cheney item numbers. The screen does not name EDI, email, or manual entry.
- Does Firehouse corporate push a master item list / recipes into R365? The recipe view is named "Recipes - R365" and the item MEAT TURKEY - 1001190 has a numeric code. Ownership is still unconfirmed.
- 878 store hours: assumed same as 122 (10 AM-9 PM).
- 878 move to Toast + R365: date unknown.

## Server browser (research 2026-10-10)
- `@playwright/mcp` 0.0.83 (npm, 2026-10-10) depends on `playwright` and `playwright-core` `1.64.0-alpha-1790635538000`. Pin those three. See `docs/research/browser-stack.md` section 1.
- MCP HTTP flags: `--port`, `--host` (default localhost). Headed is the default; `--headless` switches. Profile: `--user-data-dir`. Binary: `--executable-path`. Origins: `--allowed-origins` and `--blocked-origins` (semicolon-separated; not a security boundary). See section 1.
- One MCP HTTP process accepts more than one client. For two HTTP clients of that process: neither flag means each client launches its own persistent browser (the second throws when that profile path is locked; two different workspace directories can be two browsers); `--isolated` means one in-memory browser and a new context per client, and `--user-data-dir` is rejected; `--shared-browser-context` means one browser and the first context for every client (same cookies and pages). Both flags together still share one browser, and the context follows `--isolated`. See section 1.
- Default persistent profile for 0.0.83 is `~/.cache/ms-playwright-mcp/mcp-<browser>-<7-hex-of-client-cwd>` (source). Pass an explicit `--user-data-dir`. See section 1.
- No MCP flag refuses a second client. See section 6.
- Chromium for this package is Chrome for Testing 155.0.8059.12, revision 1247, at `~/.cache/ms-playwright/chromium-1247/chrome-linux64/chrome`. The linux64 zip is 198335306 bytes. See section 2.
- Every Ubuntu 24.04 Chromium library package Playwright lists is already installed on this host. See section 2.
- On Linux in this Playwright build, `validateBrowserConfig` (`playwright-core/lib/coreBundle.js` lines 74297–74310) sets channel `chrome` and `chromiumSandbox` true when no `--browser` is passed, so the launch does not add `--no-sandbox`. With `--browser chromium` the channel is `chrome-for-testing` and the launch adds `--no-sandbox`. `--sandbox` sets `chromiumSandbox` true in either case. Unprivileged user namespaces work here (`unshare --user` succeeded; `kernel.unprivileged_userns_clone` is 1; `NoNewPrivs` is 0). See section 3.
- Ubuntu 24.04.4 LTS. `xvfb` 2:21.1.12-1ubuntu1.6 is installed. Not installed: `x11vnc` 0.9.16-10, `novnc` 1:1.3.0-2, `websockify` 0.10.0+dfsg1-5build2. See section 4.
- Loopback bind: `x11vnc -listen 127.0.0.1 -no6` (IPv6 listen is on by default; `-localhost` also allows `::1`) and `websockify 127.0.0.1:PORT 127.0.0.1:5900`. VNC password from a file: `x11vnc -passwdfile FILE`. See sections 4 and 7.
- Claude Code 2.1.296 user scope: `claude mcp add --transport http --scope user <name> <url>` (stored in `~/.claude.json`). cursor-agent reads `~/.cursor/mcp.json` with `mcpServers.<name>.url`. See section 5.
- systemd 255 is PID 1 inside this LXC. `ProtectHome=yes` covers `/home`, `/root`, and `/run/user`, not `/srv`. Four system units (Xvfb, x11vnc, websockify, Playwright MCP), each bound so it does not listen off loopback. See section 7.
- Public login loads confirmed: R365 uses `cdn.restaurant365.io`, `cdn.pendo.io`, and `faro-collector-prod-us-east-3.grafana.net`. `www.toasttab.com` redirects to `pos.toasttab.com`; the admin URL redirects to `www.toasttab.com/login`. ADP sign-in loads `synerg.adp.com`, whose config names `canvas.waypoint.prod.us.caas.oneadp.com`. See section 8.

## Windows agent (research 2026-10-10)
- Cursor's Windows install command is `irm 'https://cursor.com/install?win32=true' | iex`, and the documented command is `agent`. See `docs/research/windows-agent.md` section 1.
- The Cursor CLI reference lists `-p`, `--mode`, `--sandbox`, and `--workspace`, with no Windows exception. See `docs/research/windows-agent.md` section 1.
- Windows OpenSSH reads `%userprofile%\.ssh\config`. Git for Windows should use that client ("Use external OpenSSH", or `core.sshCommand` set to `C:/Windows/System32/OpenSSH/ssh.exe`). See `docs/research/windows-agent.md` section 2.
- The clone command is `git clone dev-lxc-1:/root/fhs-skills` (git's scp-like URL; path from `CLAUDE.md`). Not run from the PC. See `docs/research/windows-agent.md` section 2.
- Unset `receive.denyCurrentBranch` refuses an update of the checked-out branch on a non-bare repo (default `refuse`). Proven on a throwaway repo. See `docs/research/windows-agent.md` section 3.
- The `pre-receive` hook in the research note accepts a fast-forward of `refs/heads/feat/win-[a-z0-9-]+` and refuses `main`, `feat/other`, a force-push, a delete, and `feat/win-Upper_Case`. See `docs/research/windows-agent.md` section 3.
- Git for Windows' installer defaults `core.autocrlf` to `true` (checkout CRLF). See `docs/research/windows-agent.md` section 4.
- `inbox/` is gitignored (`.gitignore` line 2). A report copy is `scp` to `dev-lxc-1:/root/fhs-skills/inbox/` plus a SHA-256 compare of `Get-FileHash` and `sha256sum`. See `docs/research/windows-agent.md` section 5.
- This server has `/usr/bin/sha256sum` (GNU coreutils 9.4). See `docs/research/windows-agent.md` section 5.

## Store 122 audit (2026-10-11)

Confirmed from PC captures 2026-10-11 (CARY 1 / Toast 00122). Details: `docs/research/store-audit-122.md`.

- R365 left rail shows Dashboards, Reports, Accounting, Inventory, Sales & forecasting, Workforce, Task management, Manager log, More (Hire, Payroll, Training), Admin, Marketplace; Operations overview Orders tile is greyed out. See Licensed modules.
- R365 Admin opens for this login (71 users). See Licensed modules.
- Toast Payroll is not licensed (discover page; 38 employees at 00122). Toast Scheduling is not set up (Sling connect error). Tip pooling is an upgrade. Toast Shop purchase is permission-denied. See Licensed modules.
- R365 Inventory → Items: 551 purchase items, units filled, Brand Firehouse Subs, cost method Last Received; many Avg Cost $0.00. See F2.
- Sample CARY 1 costs: MEAT TURKEY - 1001190 $3.56/LB; BREAD LARGE WHITE SUB ROLL $0.58/Roll; last receipt Cheney Brothers #9100594310-CARY on 10/02/2026 (CS - 6/Pack). See F2.
- R365 Vendors: 114 company-wide. CARY 1 invoices and receipts in this audit are Cheney Brothers, Inc. See F2 and F3.
- CARY 1 AP invoices arrive Modified by R365 Import with `-CARY` numbers; Supplyit and NDCP tiles are Disconnected; Documents to process shows no email-capture address. Newest three invoices (10/06 and 10/09 ×2) are Unapproved; 10/02 $1,832.25 is Approved. See F3.
- R365 Recipes: 2,331. Menu Items: 64,670, visible rows mapped to `MI …` recipes, Estimated Cost $0.00, Target Profit % 0.00. See F4.
- Toast Menu manager items Target = Firehouse Subs Group, 435 groups, 1 location; some items tagged Catering (ezCater) and Online ordering partners. See F4.
- CARY 1 storage locations include Unassigned 212, CHEMICAL & JANITORIAL 18, DRY 78, LINE 77, COOLER 40, plus beverage, chips, freezer, register, and others. See F5.
- Count template **CARY 1 - FHS Weekly Inventory**: 207 items, On Demand, GL posting Yes, created by R365 DSS User. Last approved count 10/04/2026, $7,461.73. See F5.
- R365 waste: one log in the last 30 days, WL-000002 on 09/28/2026, $0.92, Approved. Toast food waste this month $0. See F6.
- Actual vs Theoretical Analysis opens with error: The 'ToCount' parameter is missing a value. See F7.
- Actual vs Theoretical Location Summary returns numbers (10/11–10/11): CARY 1 Begin 7,520.46, End 0.00, Theo 4,485.73. See F7.
- P&L comparison Period 10 2026 returns numbers, starts at COGS (no Sales section); CARY 1 Total COGS - PURCHASES −5,266. See F7.
- R365 Bank reconciliations: 0 rows. Daily Sales Total Deposit $0.00 and Over/Short negative on CARY 1 days 10/06–10/10. See F8 and F9.
- Toast payouts for October (as of Oct 10): card $8,917.23, External −$546.63, payout $8,370.60, 10 daily payouts, group Firehouse Subs Management Group. Cash Drawer History starting cash $250.00. See F8.
- R365 Daily Sales for CARY 1 through 10/10/2026 matches Toast weekly net sales to the cent; CARY 1 Labor $ is $0.00. R365 report subscriptions: 0. See F9.
- R365 schedule week of Oct 5 is Unpublished; OT Hours 69.61; 13 Shifts Not Sent to POS. See F10.
- R365 tip rule **Cary1 Tip Rule** runs Daily; week of Oct 5 card tips $411.72. See F11.
- Last POS import 10/11/2026 10:08 AM; next 10/12/2026 10:49 AM. Admin POS Toast tile is Disconnected (employee/job push). See Toast → R365 integration.
- Labor Payroll Review and Tip Automation Distributions Report exist (opened; default 10/11–10/11 empty). Toast time entries exist. R365 labor details: 4,295 rows; some CARY 1 pay rates $0.00. See F12.
- R365 AR customers: 0. Toast Integrations are view-only for this login. See F13.

