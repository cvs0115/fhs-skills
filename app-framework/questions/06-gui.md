# Bank 6 · GUI and interface (G)

Used in: [07 UI](../playbook/07-ui.md). G2 and G8 are asked again for every page.
Read [00-etiquette.md](00-etiquette.md) first. ★ = must-ask (G1–G5). **(Rec)** = recommended default.

| ID | Question | Why it matters | Options (Rec first) | Ask when |
|---|---|---|---|---|
| G1 ★ | Confirm the navigation and page inventory (landing pages, then detail pages, in build order). | It is the UI build plan, one page per step. | Coordinator drafts a sitemap from V2 **(Rec)** · User supplies | always |
| G2 ★ | What are the 3–5 key numbers or verdicts at the top of each page? | They are the page's reason to exist. Everything else supports them. | Draft per page per persona **(Rec)** · User supplies | always, per page |
| G3 ★ | Which drill-downs and cross-links are needed (landing → detail → source system)? | Dead ends kill analyst value. Links need ids (D4). | Every entity name links to its detail page and to the source system **(Rec)** · Detail only | always |
| G4 ★ | Should there be a demo or preview mode with realistic data, and how is it marked? | It enables demos before live data exists and safe screenshots. | Explicit toggle plus a visible "Demo data" badge, real-shaped (D15) **(Rec)** · None | always |
| G5 ★ | What are the responsive targets and the accessibility level? | Layouts break at mid widths, and accessibility is hard to retrofit. | ~1280 / 900 / 420 px, WCAG 2.2 AA (contrast, keyboard, labels, 24 px targets) **(Rec)** · Desktop only | always |
| G6 | What do the empty, loading, error and stale states say, and do they offer a retry? | They are most of what users see on a bad day. | Skeletons; a plain empty state with the next step; error with retry; an "as of <time>" stamp **(Rec)** | always (quick) |
| G7 | Is there a brand palette? Should category colors stay stable across pages? | Consistency builds trust; shifting colors mislead. | Official brand palette, one color function per category **(Rec)** · Neutral palette | always (quick) |
| G8 | Chart or table for each block, and which chart types? | Too many charts hide the numbers. | Table first, charts only for trends and shares **(Rec)** · Chart-heavy | per page |
| G9 | Which filters persist across pages (time range, scope, category), and are they in the URL? | Shareable, bookmarkable views help support. | Global filters in the URL query string **(Rec)** · Per page only | if there are several filters |
| G10 | Which time ranges are offered by default? | They must match the retention tiers (D5) and business periods. | The business period (e.g. contract term) + 7/30/90 d **(Rec)** · Custom picker | if there are trends |
| G11 | Are admin-only controls (refresh now, config) hidden or disabled for others? | Visible but forbidden controls confuse people. | Hidden for non-admins **(Rec)** · Disabled with a tooltip | if there are admin actions |
| G12 | Do we need a guided tour or help panel for demos and onboarding? | It speeds adoption and makes demos repeatable. | A short tour per persona, matched to the demo script **(Rec)** · None | if K4 has a demo |
| G13 | What must each page tell the user about data freshness and gaps? | Silent staleness is worse than no data. | An "as of" stamp plus a source-status link to the diagnostics page **(Rec)** | always (quick) |
| G14 | Where does the persona switch sit, and how is the choice remembered? | It affects the header on small screens. | Header selector, remembered per browser **(Rec)** · Profile setting | if V5 = switch |

**Close the bank:** the page inventory goes on the Board as one row per page, in build order.
