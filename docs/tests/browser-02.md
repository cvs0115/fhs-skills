# Test plan · browser-02

> **For the tester agent (Composer 2.5 via `agent`, a fresh session, not the builder).** Run every case you can, record real evidence,
> and judge each one PASS, FAIL or BLOCKED. Don't fix anything. Hand-off: "Run the test plan in docs/tests/browser-02.md".

## What's being tested

The server browser from `docs/plans/browser-02.md`:
- files that install it safely
- services that listen only on `127.0.0.1` and run as `fhs-browser` with the sandbox on
- the builder user is blocked from it
- the owner sees it through the tunnel
- Claude drives it through MCP
- logins survive (or the runbook says why not)
- the second-client behavior is documented

Builder report: `/srv/fhs-build/reports/browser-02.md`.

## Where you test

| Env | Where | How |
|---|---|---|
| shell | `/srv/fhs-build/browser-02` on `feat/browser-02`, as `fhsbuild` | run commands; edit nothing |
| ops | root on the server, run by the Ops agent after the code-review gate and the owner's yes | Ops pastes the output; you judge it |
| browser-server | the `fhs-browser` MCP, driven by a root Claude session (Claude pastes its tool output and the page title) | read and navigate only |
| browser-windows | fallback only if browser-server isn't up yet: Chrome on the owner's PC | read and navigate only |
| owner | the owner does it and reports | write down exactly what they report |

Browser rules: the owner signs in. Never type a username or password. Never click save, submit, approve, pay, send or delete. If a page asks
for MFA, mark the case BLOCKED (owner).

## Preconditions

- The builder report exists. For ops/browser/owner cases: the code review of `feat/browser-02` is APPROVE, the owner gave the one yes for the
  root step list, and Ops ran `install.sh` from a root worktree of the reviewed branch.

## Pre-merge cases (the merge gate: all must PASS)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | `bash scripts/tests/test_browser.sh; echo exit=$?` | all PASS, `exit=0` | output |
| T2 | shell | `bash scripts/browser/install.sh --dry-run`; `bash scripts/browser/uninstall.sh --dry-run` | `STEP 1`…`STEP 7` in the plan's order; uninstall lists its steps; nothing executed (`systemctl list-units 'fhs-browser*'` is empty) | output |
| T3 | shell | `grep -rnE '0\.0\.0\.0\|--no-sandbox\|-localhost\|novnc_proxy\|@latest' scripts/browser/`; `grep -n '127.0.0.1' scripts/browser/units/*.service` | first: no output; second: the x11vnc, novnc and mcp units each bind 127.0.0.1 | output |
| T4 | shell | `python3 -c "import json;l=json.load(open('scripts/browser/package-lock.json'));p=l['packages'];print(p['node_modules/@playwright/mcp']['version'],p['node_modules/playwright-core']['version'])"` | `0.0.83 1.64.0-alpha-1790635538000` | output |
| T5 | shell | `grep -n 'skuid' scripts/browser/firewall.nft`; `grep -n 'Requires=fhs-browser-firewall' scripts/browser/units/*.service` | the reject rule names ports 5900, 6080, 8931 and allows only uid 0 and fhs-browser; all four service units require the firewall unit | output |
| T6 | shell | `bash scripts/tests/test_framework.sh; echo exit=$?`; `git diff --name-only main...HEAD`; `git diff --check main...HEAD`; `git status --short` | suite all PASS; only the plan's allowed files; no whitespace errors; clean | output |
| T7 | ops | `ss -ltnp \| grep -E ':(5900\|6080\|8931) '` | three listeners, each `127.0.0.1:<port>`, processes owned by fhs-browser (`ps -o user= -p <pid>`) | pasted output |
| T8 | ops | `sudo -u fhsbuild curl -s -m5 -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8931/mcp; echo exit=$?`; `sudo -u fhsbuild env DISPLAY=:99 xdpyinfo; echo exit=$?`; `curl -s -m5 -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8931/mcp` (as root) | fhsbuild: connection refused or reset (non-zero exit, no HTTP code); xdpyinfo fails; root gets an HTTP response | pasted output |
| T9 | ops | `bash scripts/browser/status.sh`; `ps -o user=,args= -C chrome \| head -3`; `journalctl -u fhs-browser-mcp --no-pager \| grep -i 'sandbox'` | units active; effective hardening values printed; chrome runs as fhs-browser with no `--no-sandbox` in its args; no "Chromium sandboxing failed" | pasted output |
| T10 | owner | On the PC: `ssh -L 6080:127.0.0.1:6080 dev-lxc-1`, open `http://localhost:6080/vnc.html`, enter the VNC password | the owner sees the browser window | the owner's report, verbatim |
| T11 | browser-server | A root Claude session: `fhs-browser` → navigate to the Toast login URL from `memory/login-urls.md` → snapshot | the reported page title matches what the owner sees in noVNC (a Cloudflare check page is acceptable and recorded) | tool output + the owner's matching title |
| T12 | owner + browser-server | The owner signs in to R365 in noVNC. Ops: `systemctl restart fhs-browser-mcp`. Claude opens the R365 home page via `fhs-browser` | still signed in, **or** the runbook gained a note, with the cookie-expiry evidence, that R365 needs a sign-in after a restart | tool output; runbook diff if any |
| T13 | browser-server | A second root client (e.g. a Cursor agent session as root, using `fhs-browser`) connects while Claude holds the page | accepted, and it sees the same page (shared context). CLAUDE.md's Browser section states the advisory rule | tool output + `grep -n -A6 '^## Browser' CLAUDE.md` |
| T14 | ops | After T12: `bash scripts/browser/lock.sh take tester; bash scripts/browser/lock.sh take other; echo exit=$?; bash scripts/browser/lock.sh release` | the second take exits 4, naming `tester` as the holder | pasted output |

Mark ops, owner and browser cases BLOCKED (ops / owner) until their output or report is given to you.

## Post-merge verification (not a gate; a failure opens a fix plan)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| P1 | ops | Re-run `install.sh` from `/root/fhs-skills` (main). Compare its printed sha256 list with `sha256sum` of `main`'s `scripts/browser/units/*`, `firewall.nft`, `package*.json` | every hash matches; all five units active | pasted output |
| P2 | browser-server | Repeat T11 | same result | tool output |

## Results

Write `/srv/fhs-build/reports/browser-02-test.md`:

```text
Test plan: browser-02 · Branch: feat/browser-02 at <commit> · Tester: composer-2.5 (fresh session)
| ID | Result | Evidence | Note |
Totals: PASS <n> · FAIL <n> · BLOCKED <n>
Verdict: ALL PASS | FAILURES (list IDs) | BLOCKED (list IDs and what's needed)
```

## You must not

- Edit, commit or delete anything in the repo. Fix failures. Run `install.sh`/`uninstall.sh` without `--dry-run`. Use sudo.
- Type credentials, or click anything that changes data in Toast, R365, ADP or any site.
