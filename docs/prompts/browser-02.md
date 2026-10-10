# Agent task · browser-02 · build

> **For the coding agent (Composer 2.5 via `agent`), as `fhsbuild`.** This file is your whole assignment. Read it top to bottom, then do it.
> Approved plan: `docs/plans/browser-02.md` (read it; if this file and the plan disagree, stop and report it).
> Hand-off: start `sudo -u fhsbuild -H /srv/fhs-build/.local/bin/agent --model composer-2.5 --force --workspace /srv/fhs-build/browser-02`
> and tell it "Do the task in docs/prompts/browser-02.md".

## Context

fhs-skills is a repo of Claude skills for a Firehouse Subs owner's back office (Toast, Restaurant365, ADP). The server needs one browser
the owner can watch and sign in to through an SSH tunnel, and that root-run agents drive through Playwright MCP. You write the files
that install and run it: unit files, an install/uninstall/status/lock script set, a firewall rule, pinned npm files, tests, a runbook,
and two small doc edits. **You install nothing and run nothing as root.** After a code review, an Ops agent runs your `install.sh`.

Facts to build from (from `docs/research/browser-stack.md`, on `main`):
- `@playwright/mcp@0.0.83`, with `playwright` and `playwright-core` at `1.64.0-alpha-1790635538000`. The bin is `cli.js`.
- Chrome for Testing `155.0.8059.12`, Playwright revision `1247`. Pass `--browser chromium --sandbox` (this build adds `--no-sandbox` unless `--sandbox`).
- `--shared-browser-context` shares one browser and one context between HTTP clients. `--host 127.0.0.1 --port 8931` serves `/mcp`
  (streamable) and `/sse`. `--user-data-dir` is the persistent profile.
- When `DISPLAY` is unset on Linux, the MCP runs headless. Set `DISPLAY=:99`.
- systemd 255 runs in an unprivileged LXC. `/usr/bin/node` is v20.20.2. `xvfb`, `xauth` and `mcookie` are installed; `x11vnc`, `novnc` and `websockify` are not.
- x11vnc: `-listen 127.0.0.1 -no6` (it listens on IPv6 by default). Don't use `-localhost`. websockify: `127.0.0.1:6080 127.0.0.1:5900` (not `novnc_proxy`).

## Where you work

- Workspace `/srv/fhs-build/browser-02`, your own clone. First: `git checkout -b feat/browser-02`.
- You run as `fhsbuild` (no sudo, no `/root`). You may run `npm install --package-lock-only` inside `scripts/browser/` to create the lock file.

## Read first

1. `CLAUDE.md` 2. `docs/plans/browser-02.md` (sections Design, Files the builder may edit, Live systems touched, Done-check)
3. `docs/research/browser-stack.md` sections 1, 2, 4, 5, 7 4. `docs/specs/browser.md`

## Steps

1. **Units** in `scripts/browser/units/`: `fhs-browser-xvfb.service`, `fhs-browser-x11vnc.service`, `fhs-browser-novnc.service`,
   `fhs-browser-mcp.service`, exactly as in the plan's Design (start from research section 7, add `-auth /var/lib/fhs-browser/Xauthority`
   to Xvfb and x11vnc, and `XAUTHORITY` plus `PLAYWRIGHT_BROWSERS_PATH=/opt/fhs-browser/ms-playwright` to mcp). Plus
   `fhs-browser-firewall.service` (`Type=oneshot`, `RemainAfterExit=yes`, `ExecStart=/usr/sbin/nft -f /opt/fhs-browser/firewall.nft`,
   `ExecStop=/usr/sbin/nft delete table inet fhs_browser`, `Before=` the four others, `WantedBy=multi-user.target`). The four others get
   `Requires=`/`After=fhs-browser-firewall.service`.
2. **`scripts/browser/firewall.nft`:** `table inet fhs_browser` with an `output` chain (`type filter hook output priority 0;`) that rejects
   `oif "lo" tcp dport { 5900, 6080, 8931 } meta skuid != { 0, "fhs-browser" }` with `reject with tcp reset`. Start the file with
   `table inet fhs_browser { }` and `delete table inet fhs_browser`, so reloading it is idempotent.
3. **`scripts/browser/package.json` + `package-lock.json`:** `"private": true`, the dependency `"@playwright/mcp": "0.0.83"` (exact). Generate the
   lock with `npm install --package-lock-only`. Check that the lock resolves `playwright-core` to `1.64.0-alpha-1790635538000`.
4. **`scripts/browser/install.sh`** (bash, `set -euo pipefail`, root-only except `--dry-run`): the plan's 7 root steps, in order, each one
   printed as `STEP n: <what>` before it runs. Idempotent: skip what's already done, and say so. Details:
   - Read `FHS_VNC_PASSWORD` from `${FHS_ENV:-/root/fhs-skills/.env}`. Exit 3 with a clear message if it's empty. Never echo it.
   - Write `vnc-pass` (0600) and the Xauthority cookie (`xauth -f ... add :99 . $(mcookie)`, 0600), both owned by `fhs-browser`.
   - `/opt/fhs-browser`: root-owned 0755. `npm ci --omit=dev` with the copied `package.json`/`package-lock.json`. Chrome:
     `PLAYWRIGHT_BROWSERS_PATH=/opt/fhs-browser/ms-playwright /usr/bin/node /opt/fhs-browser/node_modules/playwright-core/cli.js install chromium`.
   - Copy the units to `/etc/systemd/system/` and `firewall.nft` to `/opt/fhs-browser/`. `systemctl daemon-reload`.
     `systemctl enable --now fhs-browser-firewall fhs-browser-xvfb fhs-browser-x11vnc fhs-browser-novnc fhs-browser-mcp`.
   - MCP for root: `claude mcp add --transport http --scope user fhs-browser http://127.0.0.1:8931/mcp` (skip if `claude mcp get fhs-browser`
     already shows it). Merge `"fhs-browser": {"url": "http://127.0.0.1:8931/mcp"}` into `/root/.cursor/mcp.json` with python3 json, keeping
     every other key, and create the file if it's missing.
   - Finish with `sha256sum` of every installed file (units, `firewall.nft`, `package.json`, `package-lock.json`).
   - `--dry-run` prints all steps without doing any, and works as non-root. `--source <dir>` sets where the files are copied from (default: the
     script's own repo checkout).
5. **`scripts/browser/uninstall.sh`:** the reverse, as in the plan, with `--reset-profile` and `--purge-packages` (both off by default). `--dry-run` works as non-root.
6. **`scripts/browser/status.sh`:** the plan's checks. Read-only. Works as root; as non-root it prints what it can and marks the rest "needs root".
7. **`scripts/browser/lock.sh take <name> | release | show`:** writes `/run/fhs-browser-lock` (holder name and time). `take` exits 4 if someone else
   holds it. Root only. Advisory: the header comment says so.
8. **`scripts/tests/test_browser.sh`:** as in the plan. It must pass as fhsbuild with no root and no network. For `systemd-analyze verify`, if it
   can't resolve `User=fhs-browser` or the missing binaries, verify a temp copy with those lines stubbed, and say which lines were stubbed.
9. **`docs/runbooks/browser.md`:** for the owner, in plain words: connect (the exact tunnel command and URL), the VNC password (where it's set),
   signing in, MFA, restart, profile reset (signs out of everything), rollback, and what "advisory lock" means.
10. **`CLAUDE.md`:** add a "Browser" section (6 lines max), with the rules from the plan's Design ("Coexisting" and "One driver at a time").
11. **`skills/fhs-skills/references/tech-stack.md`:** add one row/line under Systems about the server browser and the runbook path. Nothing else.

## You may edit only

`scripts/browser/**` (new), `scripts/tests/test_browser.sh` (new), `docs/runbooks/browser.md` (new), `CLAUDE.md` (the Browser section only),
`skills/fhs-skills/references/tech-stack.md` (one line only).

## You must not

- Run `install.sh` or `uninstall.sh` without `--dry-run`. Install packages, use sudo, start services or listeners, run a browser.
- Edit any other file (including `skills/fhs-payroll-adp/**`, `shared/**`, `.env*`, `docs/plans|prompts|tests|reviews/**`, `scripts/build.sh`,
  `scripts/review.sh`, `scripts/lib/**`). Push, merge, or change git config.
- Use `0.0.0.0`, `--no-sandbox`, `-localhost`, `novnc_proxy` or `@latest` anywhere.

## Tests (run every one, record the real output)

1. `bash scripts/tests/test_browser.sh; echo exit=$?` → all PASS, `exit=0`
2. `bash scripts/browser/install.sh --dry-run` → `STEP 1` … `STEP 7` in order, nothing executed
3. `bash scripts/tests/test_framework.sh; echo exit=$?` → still all PASS (nothing in it changed)
4. `grep -rnE '0\.0\.0\.0|--no-sandbox|-localhost|novnc_proxy|@latest' scripts/browser/` → no output
5. `git diff --name-only main...HEAD` → only allowed files; `git diff --check main...HEAD` and `git status --short` → no output

## When done

1. Commit on `feat/browser-02` with the one-shot author (`git -c user.name="Surati" -c user.email="chirag.surati.78@gmail.com" commit ...`), the
   message ending with `Co-Authored-By: Composer 2.5 (cursor agent)` as the last line.
2. Write `/srv/fhs-build/reports/browser-02.md`:

```text
Task: browser-02 · Branch: feat/browser-02 · Commits: <hashes>
Files changed: <list>
Tests: <n>/5 passed. For each: command, trimmed output, pass/fail
Stubbed lines in systemd-analyze verify (if any): <list>
Deviations or open issues: <list or none>
```

If a step can't be done exactly as written, stop, write the reason in the report, and don't work around it.
