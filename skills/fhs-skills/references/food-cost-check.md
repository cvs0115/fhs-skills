# Weekly food cost check (turn on once the tracker says inventory is live)

Run Monday for the week ending Sunday. Working folder = the store's Dropbox week folder.

## Reports the owner downloads (R365, the week just ended)
- Actual vs Theoretical (by item), COGS / inventory summary (opening, purchases, closing),
  sales summary, AP invoice list (with line detail if possible), waste log.

## What to check and report
| Severity | Check |
|---|---|
| High | Food cost % up 2+ points vs the 4-week average |
| High | Top 10 AvT items by $ gap (explain likely cause: mapping, units, portioning, waste, theft) |
| High | Count oddities: item missing from count, count off by ~10x (unit error), negative usage |
| High | Toast menu items with sales but no recipe mapping |
| Medium | Invoice price up 5%+ vs last purchase of the same item |
| Medium | Invoices in the period not yet entered/approved in R365 |
| Medium | Waste $ over the store's usual |
| Info | Prime cost % = (COGS + labor incl. payroll taxes estimate) / sales, using the payroll run |

## Output
- `<store>_<weekstart>_<weekend>_food_cost.html` (show with SendUserFile, display=render)
- Append findings to `<prefix>_concerns.md` in the same week folder.
- Flag; never change counts, recipes or invoices without the owner's yes.

(Script support can be added later, like payroll.py, once we see the real report formats.)
