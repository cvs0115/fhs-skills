# GUI Tester

Drives the running app in a real browser with Playwright and reports what a user would see: broken
functions, layout faults, wrong numbers, persona gaps. Script skeleton and checklist:
`templates/gui-test-script.md`.

## Purpose

- **Tester 1 (functions):** core journeys, drill-downs, filters, role checks, empty/error/stale states.
- **Tester 2 (layout):** a full sweep at every target width plus rechecks of earlier findings.
- Both give a verdict after each merge wave: **SHIP** / **NO-SHIP**.
- Before a demo: a backup screenshot pack at the presentation width.

## When to spawn

- After a merge wave lands on `develop` and the main dev server runs it (not in a Builder worktree:
  worktree dev servers usually can't complete sign-in).
- Keep 1–2 running while Builders work, rerunning after each merge wave.
- Before every release and before every demo.

## Inputs it needs

- The dev server URL; the pages (every landing page plus one detail page per entity type) and journeys.
- The widths: the product's targets (for example 1280 / 900 / 420 px), or only the presentation
  width for a demo check.
- Acceptance criteria for the rows in the wave, and the open findings to recheck.
- Persona and mode switch values, demo/preview vs live mode, and the roles to test (a lower role
  sees no admin controls and gets admin actions refused).
- Its own profile directory, its scratch prefix and the results path.

## Tooling

- **Playwright driving the real Chrome** (`channel: 'chrome'`), so sign-in and rendering match what
  users get.
- Either `@playwright/test` in the repo, or `playwright-core` from the npx cache when you don't want
  a dependency.
- A Playwright MCP server is an option for interactive poking, but it can disconnect mid-run.
  **Scripted Playwright is the reliable fallback** and the default for sweeps.

## Sign-in

- **One persistent profile per tester:** `chromium.launchPersistentContext('<PROFILE_DIR>/tester-<n>')`.
  Two testers never share a profile, and each profile runs one context at a time.
- **Sign in once in a headed window:** the user signs in, or the tester clicks the SSO button
  ("Continue with <IDENTITY_PROVIDER>") and picks the user's account. **Never type a password.**
  **Stop on any password or MFA prompt** and ask the user to complete it in the headed window.
- Then run **headless with the same profile.**
- If the app keeps tokens in sessionStorage, each run starts signed out of the app: click the app's
  own Sign in button again (the identity provider session in the profile makes it one click).
- Prefer demo/preview mode with real-shaped fixtures where it needs no sign-in at all.

## What to measure (DOM checks, per page × width × mode)

- Confirm `window.innerWidth` equals the intended width before measuring.
- `document.documentElement.scrollWidth <= innerWidth` (no sideways scroll).
- Text clipped (`scrollWidth > clientWidth`) outside tables, with no `title` to reveal it.
- A lone card on the last row of a grid.
- Numbers wrapping mid-value (a figure's element taller than one line).
- `NaN`, `undefined`, `Infinity` or `null` in visible text.
- A sticky header or fixed bottom nav covering content.
- Wide tables scroll inside their panel, not the page.
- Console errors and failed requests.
- Functional checks (Tester 1): links open the right detail by id, landing and detail figures agree,
  empty/loading/error/stale states are plain with a next step, "as of" stamps present, wording follows
  `docs/personas.md`, demo mode is badged, focus visible, targets at least 24×24 px.

## Hard rules

- **Read-only on live data.** Never click save, refresh-now, approve, delete, reset or any other
  write action, unless the prompt allows that control by name on that environment.
- **SSO only, never type passwords, stop on MFA** (see Sign-in).
- **Own profile only;** one context at a time per profile.
- **Never change code, docs or the Board.** Write only scripts, results and screenshots under your prefix.
- **Unique scratch prefix** (`tester<n>-<wave>`). Screenshots are named `<prefix>-<page>-<width>.png`.
  Never run or edit another agent's scripts.
- **Evidence for every finding:** page, width, mode/persona, repro steps, expected vs actual, screenshot.
- **Don't copy real personal data** into findings beyond what a finding needs.

## Prompt template

```text
You are GUI Tester <N> for <APP_NAME> (<FOCUS: functions | layout sweep + rechecks | demo pack>).
You have no access to the prior conversation. Use templates/gui-test-script.md as your script skeleton.

App: <DEV_URL> (develop at <COMMIT>). Modes: <demo/preview | live | both>.
Tooling: scripted Playwright with channel 'chrome' (<@playwright/test in repo | playwright-core via npx>).
Profile: <PROFILE_DIR>/tester-<N> only, one context at a time. First run headed: <user signs in |
click "Continue with <IDENTITY_PROVIDER>" and pick <ACCOUNT_LABEL>>. Never type a password. On a
password or MFA prompt, stop and report. Then run headless with the same profile; click the app's
Sign in button again if the session is in sessionStorage.

Cover: every landing page + one detail page per type: <PAGES>. Journeys: <JOURNEYS>.
Widths: <1280, 900, 420> (confirm innerWidth). Persona/mode switch values: <VALUES>. Roles: <ROLES>.
Acceptance criteria: <CRITERIA or path>. Recheck: <FINDING IDS or path>.

Read-only on live: never click <WRITE_CONTROLS>. Scratch prefix tester<N>-<WAVE>; screenshots
<prefix>-<page>-<width>.png; results JSON at <RESULTS_PATH>. Don't edit code, docs or the Board;
never run other agents' scripts. Report in the format below.
```

## Report format

```text
Verdict: SHIP | NO-SHIP (wave <WAVE>, develop at <COMMIT>, modes <MODES>)
Matrix (pass/fail):
| Area / page | 1280 | 900 | 420 |
Bugs (P0 first):
| ID | P0/P1/P2 | Page | Width | Mode/Persona | Repro steps | Expected | Actual | Likely file | Screenshot |
Rechecks: | ID | Before (screenshot) | After (screenshot) | Fixed? |
Console errors: <count + first lines, or "none">
Not covered: <what and why> · Blockers: <sign-in prompt, server down, ... or "none">
Results file: <RESULTS_PATH> · Screenshots: <folder>
```

Priority key for bugs: **P0** blocks the release or demo · **P1** should be fixed before ship if
cheap · **P2** after.
