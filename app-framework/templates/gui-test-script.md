# GUI test script: skeleton and checklist

For GUI Testers (`agents/gui-tester.md`). Copy the script into your scratch folder as
`<PREFIX>-sweep.mjs`, fill the `<PLACEHOLDERS>`, adapt the selectors to the app. Never run another
tester's copy.

## Before you run

- [ ] Tooling: `@playwright/test` is in the repo, **or** use `playwright-core` from the npx cache
      (`npx -y playwright-core --version` once, then import it from that cache path, or
      `npm i --no-save playwright-core` in your scratch folder). Real Chrome must be installed.
- [ ] Your own profile directory `<PROFILE_DIR>/tester-<N>`. Nobody else uses it. One context at a
      time per profile.
- [ ] First run **headed** (`HEADED=1`): the user signs in, or you click "Continue with
      `<IDENTITY_PROVIDER>`" and pick `<ACCOUNT_LABEL>`. Never type a password. On a password or MFA
      prompt: stop, report, and ask the user to finish sign-in in that window.
- [ ] Later runs **headless** with the same profile. If the app keeps its session in sessionStorage,
      the script clicks the app's Sign in button on each run.
- [ ] Widths: the product's targets (for example 1280 / 900 / 420) or only the presentation width for
      a demo check. The script confirms `innerWidth` for each.
- [ ] Coverage list: every landing page + one detail page per entity type; every persona/mode switch
      value; demo/preview mode (real-shaped fixtures, no sign-in if possible) and live mode.
- [ ] Write controls to never click on live: `<SAVE / REFRESH / APPROVE / DELETE ...>`.

## The script (minimal skeleton)

```js
// <PREFIX>-sweep.mjs  — run: node <PREFIX>-sweep.mjs   (HEADED=1 for the first, signed-in run)
import { chromium } from 'playwright-core'; // or: import { chromium } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

const BASE = process.env.APP_URL ?? '<DEV_URL>';
const PROFILE = process.env.PROFILE_DIR ?? '<PROFILE_DIR>/tester-<N>';
const PREFIX = '<PREFIX>';                        // e.g. tester2-wave3
const OUT = process.env.OUT_DIR ?? '<SCRATCH_DIR>/' + PREFIX;
const HEADED = process.env.HEADED === '1';
const WIDTHS = [1280, 900, 420];                  // or [<PRESENTATION_WIDTH>] for a demo check
const MODES = ['demo', 'live'];                   // adapt: how the app switches mode, see setMode()
const PAGES = [                                   // every landing page + one detail page per type
  { id: 'home', path: '/' },
  { id: '<landing>', path: '/<landing>' },
  { id: '<detail>', path: '/<landing>/<STABLE_ID>' },
];

fs.mkdirSync(OUT, { recursive: true });

const ctx = await chromium.launchPersistentContext(PROFILE, {
  channel: 'chrome',
  headless: !HEADED,
  viewport: { width: WIDTHS[0], height: 900 },
});
const page = ctx.pages()[0] ?? (await ctx.newPage());

const consoleErrors = [];
page.on('console', (m) => { if (m.type() === 'error') consoleErrors.push({ url: page.url(), text: m.text() }); });
page.on('pageerror', (e) => consoleErrors.push({ url: page.url(), text: String(e) }));
page.on('requestfailed', (r) => consoleErrors.push({ url: page.url(), text: 'request failed: ' + r.url() }));

async function stopIfPasswordOrMfa() {
  const pw = await page.locator('input[type="password"], input[autocomplete="one-time-code"]').count();
  if (pw > 0) throw new Error('STOP: password or MFA prompt. Ask the user to sign in in a headed window.');
}

async function ensureSignedIn() {
  await page.goto(BASE, { waitUntil: 'networkidle' });
  const signIn = page.getByRole('button', { name: /sign in/i });   // the APP's own button
  if (await signIn.isVisible().catch(() => false)) {
    await signIn.click();
    await page.waitForLoadState('networkidle');
    await stopIfPasswordOrMfa();
    const sso = page.getByRole('button', { name: /continue with <IDENTITY_PROVIDER>/i });
    if (await sso.isVisible().catch(() => false)) await sso.click();   // SSO only, never type passwords
    await stopIfPasswordOrMfa();
    await page.waitForURL((u) => u.origin === new URL(BASE).origin, { timeout: 60_000 });
  }
}

async function setMode(mode) {
  // Adapt: a query flag, a toggle, or a separate URL. Demo/preview mode should need no sign-in.
  await page.goto(BASE + (mode === 'demo' ? '/?demo=1' : '/'), { waitUntil: 'networkidle' });
  if (mode === 'live') await ensureSignedIn();
}

// Runs in the page. Returns measurements only, never page data beyond short labels.
function measure() {
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const doc = document.documentElement;
  const isVisible = (el) => {
    const r = el.getBoundingClientRect(); const s = getComputedStyle(el);
    return r.width > 0 && r.height > 0 && s.visibility !== 'hidden' && s.display !== 'none';
  };
  const label = (el) => {
    const cls = typeof el.className === 'string' && el.className.trim() ? '.' + el.className.trim().split(/\s+/).slice(0, 2).join('.') : '';
    return (el.id ? '#' + el.id : el.tagName.toLowerCase() + cls) + ' "' + (el.textContent || '').trim().slice(0, 30) + '"';
  };
  const all = [...document.body.querySelectorAll('*')].filter(isVisible);
  const leaves = all.filter((el) => el.children.length === 0 && (el.textContent || '').trim());

  // 1. Sideways scroll.
  const sideScroll = doc.scrollWidth > vw;

  // 2. Clipped text outside tables with no title to reveal it.
  const clipped = leaves
    .filter((el) => !el.closest('table') && el.scrollWidth > el.clientWidth + 1 && !el.closest('[title]'))
    .map(label);

  // 3. A lone card on the last row of a grid.
  const loneCards = [];
  for (const g of all.filter((el) => getComputedStyle(el).display === 'grid')) {
    const kids = [...g.children].filter(isVisible);
    if (kids.length < 3) continue;
    const tops = kids.map((k) => Math.round(k.getBoundingClientRect().top));
    const rows = [...new Set(tops)];
    const perRow = (t) => tops.filter((x) => x === t).length;
    if (rows.length > 1 && perRow(rows[0]) > 1 && perRow(rows[rows.length - 1]) === 1) loneCards.push(label(g));
  }

  // 4. Numbers wrapping mid-value.
  const numberLike = /^[-+]?[^\d\s]{0,2}\d[\d.,\s]*[%kKMB]?$/;
  const wrappedNumbers = leaves
    .filter((el) => numberLike.test(el.textContent.trim()))
    .filter((el) => {
      const s = getComputedStyle(el);
      const lh = parseFloat(s.lineHeight) || parseFloat(s.fontSize) * 1.2;
      return el.getBoundingClientRect().height > lh * 1.5;
    })
    .map(label);

  // 5. NaN / undefined / Infinity / null in visible text.
  const badTokens = [...new Set(document.body.innerText.match(/\b(NaN|undefined|Infinity|null)\b/g) || [])];

  // 6. Sticky header / fixed bottom nav covering content (adapt the selectors).
  const main = document.querySelector('main, [role="main"]');
  const header = document.querySelector('header');
  const bottomNav = [...all].find((el) => getComputedStyle(el).position === 'fixed' && el.getBoundingClientRect().bottom >= vh - 1 && el.getBoundingClientRect().height < vh / 3);
  const covered = [];
  if (main && header && ['fixed', 'sticky'].includes(getComputedStyle(header).position)) {
    if (main.getBoundingClientRect().top + window.scrollY < header.getBoundingClientRect().bottom - 1) covered.push('header overlaps top of main');
  }
  if (main && bottomNav) {
    const pad = parseFloat(getComputedStyle(main).paddingBottom) + parseFloat(getComputedStyle(document.body).paddingBottom);
    if (pad < bottomNav.getBoundingClientRect().height) covered.push('bottom nav can cover the end of main');
  }

  // 7. Wide tables must scroll inside their panel, not the page.
  const tablesEscaping = [...document.querySelectorAll('table')].filter(isVisible).filter((t) => {
    if (t.getBoundingClientRect().right <= vw) return false;
    for (let a = t.parentElement; a && a !== document.body; a = a.parentElement) {
      if (['auto', 'scroll'].includes(getComputedStyle(a).overflowX)) return false;
    }
    return true;
  }).map(label);

  return { innerWidth: vw, scrollWidth: doc.scrollWidth, sideScroll, clipped, loneCards, wrappedNumbers, badTokens, covered, tablesEscaping };
}

const results = [];
for (const mode of MODES) {
  await setMode(mode);
  for (const width of WIDTHS) {
    await page.setViewportSize({ width, height: 900 });
    for (const p of PAGES) {
      const errorsBefore = consoleErrors.length;
      await page.goto(BASE + p.path, { waitUntil: 'networkidle' });
      await stopIfPasswordOrMfa();
      const m = await page.evaluate(measure);
      if (m.innerWidth !== width) m.widthMismatch = `asked ${width}, got ${m.innerWidth}`;
      const shot = path.join(OUT, `${PREFIX}-${mode}-${p.id}-${width}.png`);
      await page.screenshot({ path: shot, fullPage: true });
      const fail = m.sideScroll || m.clipped.length || m.loneCards.length || m.wrappedNumbers.length ||
        m.badTokens.length || m.covered.length || m.tablesEscaping.length || m.widthMismatch ||
        consoleErrors.length > errorsBefore;
      results.push({ mode, page: p.id, width, pass: !fail, ...m, consoleErrors: consoleErrors.slice(errorsBefore), screenshot: shot });
    }
  }
}

fs.writeFileSync(path.join(OUT, `${PREFIX}-results.json`), JSON.stringify(results, null, 2));
console.log(`${results.filter((r) => r.pass).length}/${results.length} passed. Results: ${OUT}/${PREFIX}-results.json`);
await ctx.close();
```

Notes on the skeleton:
- It only reads. It never clicks write controls. Functional journeys (Tester 1) are extra steps you
  add per journey, using role-based locators (`getByRole`) and web-first assertions.
- The checks are heuristics. Treat each hit as a lead: look at the screenshot before filing a bug.
- Keep the results JSON; the next wave's recheck compares against it (before/after).

## Checklist per wave

- [ ] `innerWidth` confirmed for every width (no `widthMismatch` in results).
- [ ] Every landing page + one detail page per type, in every mode and persona value.
- [ ] Matrix filled: area × width, pass/fail.
- [ ] Each failing result looked at in its screenshot; false positives dropped with a reason.
- [ ] Bugs ranked P0/P1/P2 with repro steps and a likely file (component or stylesheet).
- [ ] Rechecks of earlier findings with before/after screenshots.
- [ ] Console errors listed (first lines only, no tokens or personal data).
- [ ] No write control clicked on live. Only your own profile and prefix used.
- [ ] Verdict: SHIP / NO-SHIP.

## Backup screenshot pack for demos

For when the live demo can't load (network, sign-in, data outage).

- [ ] Run at the **presentation width only**, in demo/preview mode (real-shaped data), plus live if
      the demo shows live data.
- [ ] One full-page screenshot per demo step, in tour order: `<PREFIX>-demo-<NN>-<page>-<width>.png`.
- [ ] Every shot passes the DOM checks above (no `NaN`, no clipping, no sideways scroll).
- [ ] Each persona tour's pages included; "Demo data" badge visible where it should be.
- [ ] No real personal data in any shot. No admin or destructive controls in focus.
- [ ] Pack saved in one folder the presenter can open offline; the list of files handed to the
      Coordinator with the demo script step each one belongs to.
