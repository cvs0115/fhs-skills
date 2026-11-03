---
name: payroll-skill
description: fhs-payroll-adp skill (part of the fhs-skills library) runs biweekly payroll for all stores; shared config + per-period files live in Dropbox
metadata:
  node_type: memory
  type: project
  originSessionId: 7ea7fc92-25d9-44aa-9b05-8ac214be32bf
  modified: 2026-11-03T01:58:11.651Z
---

Skill `fhs-payroll-adp` at `C:\Users\mayur\.claude\skills\fhs-payroll-adp\` (built 10/7/26 as fhs-payroll-r365-adprun, renamed 10/9/26). Covers NCR and Toast/R365 stores via the `pos` setting per store.

- **Shared config for ALL fhs skills** (stores, staff rules, store hours, checks): `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\fhs-skills\config.json` (owner is the only Dropbox user, so salaries are OK there). Scripts read it automatically; override path with env FHS_SKILLS_HOME. The project folder's config.json/payroll.py are the obsolete prototype. The repo copy `/root/fhs-skills/shared/config.json` and this Dropbox copy must stay aligned: change both together (they drifted once, 10/2026, on the kiosk's R365 name).
- Working folder per run = Dropbox week folder `...\CMVK Food Services\Locations\<00122|00878>\<YYYY>\<MM MON>\Week <ISO week of period-end Sunday>`. Owner downloads reports there; extracts, adp_entry.csv, discrepancy report, concerns.md saved there.
- Store 122 = Toast + R365 (R365 source of truth). Store 878 Camden Square = Toast + R365 from 10/21/2026 (config `toast_r365`). NCR support was dropped from the skill 2026-10-31 (owner): 878's 10/19-10/20 days are entered in ADP by hand; the skill extracts 10/21 on only. 878 uses same store hours as 122; Mayuri is the only salaried person in 878's ADP.
- Owner preferences: owner downloads, Claude reads; R365 tips used but independently validated; pause per store; owner always clicks ADP Approve; flag discrepancies with dates/times, don't decide them.

Related: [[tech-stack-agent]], [[payroll-rules]], [[login-urls]]
