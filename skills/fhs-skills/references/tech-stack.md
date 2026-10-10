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
