# Plan · browser-02 · A browser on the server that the owner can see and agents can drive

2026-10-10. Plan only, not approved. Don't build from it until `docs/reviews/browser-02.md` holds an APPROVE.
The reviewer checks this plan, its task file `docs/prompts/browser-02.md`, and its test plan `docs/tests/browser-02.md` together.
It replaces the draft `docs/plans/browser-01.md` (REJECT in `docs/reviews/browser-01-r1.md`).

- Hub project: `projects/server-move` (server move plan https://claude.ai/artifact/GFkh25pzJTaHWD36dHnWNG). It unblocks `r365-inventory`
  (the F1 store audit in `docs/specs/store-migration.md`) and `cash-and-deposits`.
- Spec: `docs/specs/browser.md`. Research: `docs/research/browser-stack.md` (branch `feat/browser-research-01`. **Prerequisite: that
  branch is merged first**, so the note and the `tech-stack.md` facts are on `main`.)
- Decisions that bind it (hub log 2026-10-10): server browser the owner can see; Claude plans; Composer 2.5 builds, tests and runs ops;
  Cursor Grok 4.6 Extra High reviews (framework-setup-03, **also a prerequisite**). Owner rules: agents never type usernames or passwords,
  never click anything that moves money or submits, one yes per Toast/R365/ADP change (`skills/fhs-skills/SKILL.md`).

## Verdict

Build.

## What changes, in plain words

The server gets one Chrome browser on a virtual screen, run by its own locked-down user. You watch it and sign in through a web page on
your PC, reached over the SSH connection you already use. Claude and the root-run agents drive that same browser through a Playwright
connection. Nothing is reachable from the network, and the builder user (`fhsbuild`) is blocked from it. Logins are kept in a protected
profile.

## How this plan answers the browser-01 review (r1)

| r1 major | Answer here |
|---|---|
| No spec, research after planning | `docs/specs/browser.md` exists. The research note is tested ALL PASS, and its merge is a prerequisite |
| Services run from the feature worktree; no stable path | Every `ExecStart` uses fixed system paths only: `/usr/bin/*`, `/opt/fhs-browser/...`. `install.sh` copies files there. After the merge, Ops re-runs `install.sh` from `main` and checks the installed files match `main` by checksum |
| Chromium as root, maybe `--no-sandbox` | A dedicated system user `fhs-browser` (not root, not `fhsbuild`). `--browser chromium --sandbox`. Unit hardening, with the effective values read back by `systemctl show` |
| The lock can't refuse direct MCP requests | v1 is honest: one shared browser for allowed users (root's agents). **Other local users are refused at the network layer** (an nft rule on loopback by uid). A refusal between root's own agents is **advisory** (a CLAUDE.md rule), and the test checks that reality instead of claiming a lock. A real single-session proxy is a later plan (owner decision below) |
| Minors: pin versions; profile reset wording; Toast/ADP redirects | Pins are in a committed `package-lock.json`. "Profile reset" wording. The done-check observes the real Toast and ADP pages in the browser |

## Design

```
owner PC ──ssh -L 6080:127.0.0.1:6080 dev-lxc-1──▶ websockify 127.0.0.1:6080 ─▶ x11vnc 127.0.0.1:5900 ─▶ Xvfb :99 (no TCP; xauth cookie)
                                                                                                          │
Claude Code (root) ─┐                                                                         Chrome for Testing 155 (headed, --sandbox)
                    ├── MCP http://127.0.0.1:8931/mcp ──▶ Playwright MCP 0.0.83 (--shared-browser-context) ──┘
Cursor agent (root)─┘                                     profile /var/lib/fhs-browser/profile (0700 fhs-browser)
fhsbuild / any other uid ──✗ refused by nft (loopback ports 5900, 6080, 8931; allowed uids: 0 and fhs-browser)
```

- **User:** system user `fhs-browser`, home and state `/var/lib/fhs-browser` (`StateDirectory=fhs-browser`, 0700). No login shell, no sudo.
- **Pinned software:**
  - `@playwright/mcp@0.0.83` with `playwright`/`playwright-core` `1.64.0-alpha-1790635538000`, installed by `npm ci` into `/opt/fhs-browser`
    from the committed `scripts/browser/package.json` + `package-lock.json`.
  - Chrome for Testing `155.0.8059.12` (rev 1247), installed into `/opt/fhs-browser/ms-playwright`.
  - Ubuntu packages `x11vnc 0.9.16-10`, `novnc 1:1.3.0-2`, `websockify 0.10.0+dfsg1-5build2` (`xvfb` and `xauth` are already installed).
- **Units:** four, as in research section 7, all `User=fhs-browser`, `Restart=on-failure`, with `NoNewPrivileges=yes`, `ProtectSystem=strict`,
  `ProtectHome=yes`, `PrivateTmp=yes`, `ReadWritePaths=/var/lib/fhs-browser`; x11vnc and mcp have `JoinsNamespaceOf=fhs-browser-xvfb.service`.
  - `fhs-browser-xvfb`: `ExecStart=/usr/bin/Xvfb :99 -nolisten tcp -auth /var/lib/fhs-browser/Xauthority`
  - `fhs-browser-x11vnc`: `ExecStart=/usr/bin/x11vnc -display :99 -auth /var/lib/fhs-browser/Xauthority -listen 127.0.0.1 -no6 -rfbport 5900 -passwdfile /var/lib/fhs-browser/vnc-pass -forever -shared -norc`
  - `fhs-browser-novnc`: `ExecStart=/usr/bin/websockify --web=/usr/share/novnc 127.0.0.1:6080 127.0.0.1:5900`
  - `fhs-browser-mcp`: `Environment=DISPLAY=:99 XAUTHORITY=/var/lib/fhs-browser/Xauthority PLAYWRIGHT_BROWSERS_PATH=/opt/fhs-browser/ms-playwright PATH=/usr/bin:/bin`,
    `ExecStart=/usr/bin/node /opt/fhs-browser/node_modules/@playwright/mcp/cli.js --browser chromium --sandbox --host 127.0.0.1 --port 8931 --user-data-dir /var/lib/fhs-browser/profile --shared-browser-context`
  - a fifth, oneshot, `fhs-browser-firewall.service` (`Before=` the others, `RemainAfterExit=yes`) loads the nft table from
    `/opt/fhs-browser/firewall.nft`: table `inet fhs_browser`, output hook, `oif lo tcp dport {5900, 6080, 8931} meta skuid != {0, fhs-browser} reject`.
    It's independent of ufw's tables.
- **X access:** `install.sh` creates `/var/lib/fhs-browser/Xauthority` (0600, fhs-browser) with `xauth add :99 . $(mcookie)`. Without the
  cookie, other local users can't open the display.
- **VNC password:** from `FHS_VNC_PASSWORD` in `/root/fhs-skills/.env` (the owner fills it in). `install.sh` writes `vnc-pass` (0600, fhs-browser).
  It refuses to start x11vnc if the value is empty.
- **MCP registration (root only, never `fhsbuild`):**
  - Claude Code: `claude mcp add --transport http --scope user fhs-browser http://127.0.0.1:8931/mcp`, written to `/root/.claude.json`.
  - Cursor agent: `/root/.cursor/mcp.json` gets `"fhs-browser": {"url": "http://127.0.0.1:8931/mcp"}`, merged and never replacing other entries.
- **Coexisting with Cursor's own browser MCP:** the Cursor agent starts its own `@playwright/mcp@latest` and `chrome-devtools-mcp` children
  (research finding, tester T11). Those are separate, per-session, headless, and never see the owner's logins. Ours is named `fhs-browser`.
  Rule (CLAUDE.md "Browser" section): store work in Toast, R365 or ADP uses **only** the `fhs-browser` tools. We don't disable Cursor's built-ins.
- **One driver at a time (advisory):** before using `fhs-browser`, an agent runs `scripts/browser/lock.sh take <name>`. The script is root-run and writes `/run/fhs-browser-lock` (a tmpfs file with the holder name and time). It's advisory and documented as such.

## Where it runs

Server (dev-lxc-1) only. Your Windows desktop only opens `http://localhost:6080/vnc.html` through the SSH tunnel. Nothing gets installed on Windows.

## Files the builder may edit (in its clone)

- `scripts/browser/units/fhs-browser-{xvfb,x11vnc,novnc,mcp,firewall}.service` (new)
- `scripts/browser/firewall.nft` (new)
- `scripts/browser/package.json`, `scripts/browser/package-lock.json` (new; `npm install --package-lock-only` as fhsbuild, pins as above)
- `scripts/browser/install.sh` (new): idempotent, root-only, `--dry-run` prints every step without doing it. Steps: apt-install the three
  pinned packages; create the user; create `/opt/fhs-browser` (root-owned, 0755) and run `npm ci --omit=dev` there; install Chrome rev 1247 into
  `/opt/fhs-browser/ms-playwright`; write the Xauthority cookie and vnc-pass; copy the units to `/etc/systemd/system/` and `firewall.nft` to
  `/opt/fhs-browser/`; `systemctl daemon-reload`; enable and start the units in order; register MCP for root (merging). It prints `sha256sum` of every installed file.
- `scripts/browser/uninstall.sh` (new): stops and disables the units, removes them and the nft table, removes the MCP entries, and removes
  `/opt/fhs-browser`. Keeps `/var/lib/fhs-browser` unless `--reset-profile` is given (that's a profile reset; it signs out of every site).
  Keeps the apt packages unless `--purge-packages`.
- `scripts/browser/status.sh` (new): unit states, effective hardening (`systemctl show -p ProtectSystem,ProtectHome,PrivateTmp,NoNewPrivileges`),
  listeners (`ss -ltnp` for 5900, 6080, 8931), nft table present, lock holder, profile age.
- `scripts/browser/lock.sh` (new), as above.
- `scripts/tests/test_browser.sh` (new): runs as fhsbuild with no root. `bash -n` on every script; `systemd-analyze verify` on each unit file
  (with paths stubbed if needed); `install.sh --dry-run` lists the steps in order; `package-lock.json` pins exactly `@playwright/mcp@0.0.83`;
  no `0.0.0.0`, `--no-sandbox`, `-localhost` or `@latest` anywhere under `scripts/browser/`.
- `docs/runbooks/browser.md` (new): how the owner connects (the tunnel command, the URL, the VNC password), signs in, does a profile reset,
  restarts, what to do on MFA, rollback.
- `CLAUDE.md`: a "Browser" section: use `fhs-browser` only for store sites; take the lock; snapshot before click; never type in password
  fields; owner rules apply.
- `skills/fhs-skills/references/tech-stack.md`: one line under Systems saying the server browser exists and how to reach it.
  **This is a skill file, live on merge.**

## Files the builder must not edit

Everything else, including `skills/fhs-payroll-adp/**` (payroll keeps its Windows browser path; switching it is a separate plan), `shared/**`,
`.env*`, `docs/plans|prompts|tests|reviews/**`, `scripts/build.sh`, `scripts/review.sh`, `scripts/lib/**`.

## Live systems touched (root steps, run by Ops after the code-review gate. The owner gives one yes for this exact list first)

1. `apt-get install -y x11vnc=0.9.16-10 novnc=1:1.3.0-2 websockify=0.10.0+dfsg1-5build2`
2. `useradd --system --home-dir /var/lib/fhs-browser --shell /usr/sbin/nologin fhs-browser`
3. Create `/opt/fhs-browser`, run `npm ci` there, and download Chrome for Testing (~198 MB zip)
4. Write five units to `/etc/systemd/system/`, then enable and start them
5. Add the nft table `inet fhs_browser`
6. Add `fhs-browser` to `/root/.claude.json` (user scope) and `/root/.cursor/mcp.json`
7. The owner fills `FHS_VNC_PASSWORD` in `.env` beforehand

Rollback: `scripts/browser/uninstall.sh` (and `--purge-packages` / `--reset-profile` only on the owner's word).
**Toast, R365, ADP:** only what the owner does when signing in. Agents open login pages and read. They never type credentials.

## Done-check (real outcome)

1. **Shell (Tester):** `bash scripts/tests/test_browser.sh` passes. `install.sh --dry-run` shows the 7 steps.
2. **Listeners (Ops):** `ss -ltnp` shows 5900, 6080 and 8931 bound to `127.0.0.1` only, owned by `fhs-browser` processes.
3. **Isolation (Ops):**
   - `sudo -u fhsbuild curl -s -m5 http://127.0.0.1:8931/mcp` is refused (connection refused or reset).
   - `sudo -u fhsbuild env DISPLAY=:99 xdpyinfo` fails.
   - `ps -o user= -C chrome` shows only `fhs-browser`.
4. **Hardening read-back (Ops):** `status.sh` prints the effective `ProtectSystem`, `ProtectHome`, `PrivateTmp`, `NoNewPrivileges`.
   - The Chrome process command line contains no `--no-sandbox`, and its log has no "Chromium sandboxing failed".
   - If the LXC silently disables a hardening option, that's recorded as a finding (not a failure) in `docs/runbooks/browser.md`.
   - A sandbox failure **is** a failure. It stops the plan and goes back to Claude.
5. **Owner sees it:** the owner runs `ssh -L 6080:127.0.0.1:6080 dev-lxc-1` on the PC, opens `http://localhost:6080/vnc.html`, enters the VNC
   password, and sees the browser.
6. **Claude drives it:** a Claude session (root) calls the `fhs-browser` MCP. It navigates to the Toast login URL (`memory/login-urls.md`) and
   takes a snapshot. The page title it reports matches what the owner sees in noVNC (a Cloudflare check page is an acceptable, recorded result).
7. **Login and restart:** the owner signs in to R365 in noVNC. Then `systemctl restart fhs-browser-mcp`, and the agent opens the R365 home page.
   It's either still signed in, or the runbook records (with the cookie expiry seen in the profile) that R365 uses session-only cookies and
   needs a sign-in after each restart.
8. **Second client, documented reality:** a second root client connects and is **accepted**, and shares the page. The test records that, and
   CLAUDE.md states the advisory rule. A non-root client is refused (check 3).
9. **Post-merge:** Ops re-runs `install.sh` from `main`. The installed files' sha256 match `main`'s, all units are active, and checks 2 and 6 still pass.

## Sequence (no builder-written code runs as root before a code review APPROVE)

1. Prerequisites merged: `browser-research-01`, `framework-setup-03`.
2. Plan review (Cursor Grok Extra High) APPROVE. Commit the plan, task file, test plan and review to `main`.
3. `scripts/build.sh prepare docs/plans/browser-02.md browser-02 --role build`; the Builder (Composer 2.5, `fhsbuild`) builds.
4. A fresh Tester (Composer 2.5) runs the shell cases.
5. Ops collects (`build.sh collect browser-02`).
6. **Code review gate:** `review.sh --diff feat/browser-02` (writer composer → reviewer Cursor Grok Extra High) APPROVE.
7. The owner gives one yes for the root step list above, and fills `FHS_VNC_PASSWORD`.
8. Ops runs `install.sh` from a root worktree of the reviewed branch, then done-checks 2–4. The owner does 5 and 7; Claude does 6 and 8.
9. The Tester records every case to final. **Final review** APPROVE. Merge. Done-check 9.

## Which tree is live

- **Served tree:** `/root/fhs-skills` on `main`. The `tech-stack.md` line and the CLAUDE.md Browser section go live on merge.
- **Running services:** they always run from the installed copies (`/etc/systemd/system`, `/opt/fhs-browser`), never from a worktree.
  Before the merge they're installed from the reviewed branch; after the merge, re-installed from `main` (done-check 9).
- **Crash/restart tree:** systemd restarts the installed units. A reboot starts them from the same installed copies.
- **Windows mirror:** not affected.

## Where the builder works

`/srv/fhs-build/browser-02` (via `build.sh prepare`), branch `feat/browser-02`, user `fhsbuild`, model `composer-2.5`.

## Owner decisions this plan needs

- **One yes** for the root step list (installs, a new system user, units, a firewall table, MCP registration), and set `FHS_VNC_PASSWORD` in `.env`.
- **Lock:** accept an advisory lock between root's own agents for v1 (recommended), or ask for a single-session localhost proxy now (`browser-03`).
- **SSH user for the tunnel:** the nft rule allows uid 0 and `fhs-browser`. If you SSH in as a user other than root, that uid gets added.

## Open `(?)` (carried from the research; each one is settled by a done-check, not assumed)

- Chrome's `--sandbox` under this LXC's seccomp filter plus `NoNewPrivileges=yes` (done-check 4).
- Whether `ProtectSystem`/`ProtectHome`/`PrivateTmp`/`JoinsNamespaceOf` take effect in this container (done-check 4, `systemctl show`).
- Whether R365, Toast and ADP keep logins across a browser restart (done-check 7).
- Toast's login page behind Cloudflare in a real browser (done-check 6).
- Research fix round 3 (the scoped sandbox wording) wasn't merged when this plan was written. This plan passes `--browser chromium --sandbox`
  explicitly, so it doesn't depend on that wording.

## What stays

Payroll's Windows browser path. The owner signs in; no credentials stored by agents. No money or submit clicks. `fhsbuild` can't reach the
browser. Cursor's own built-in browser MCPs are untouched.
