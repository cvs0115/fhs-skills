# Research · recipes-122 · Cary 1 sold items: R365 recipe mapped or not, cost present or $0

2026-10-13. Verify-only F4 from PC captures in `/srv/fhs-build/reports/recipes-122-captures/` (`pages.csv` plus `SAL-*`, `MNU-*`, `RCP-*`, `MAP-*`). No browser was opened. Nothing in Toast or R365 was changed. Week **10/05–10/11/2026** (SAL-03.txt, SAL-02.txt, MAP-01.txt). Restaurant **00122 - Cary 1**. Toast week net **$12,550.25** equals the R365 CARY 1 sum of those seven Completed days (MAP-01.txt).

## Summary for the owner

Cary 1’s week of Oct 5–11 sold 124 Toast item rows (1,294 qty, $12,550.25 net).
72 of those rows have an R365 recipe name; 50 are unmapped; 2 are (?) possible (the name matches only after dropping a leading *).
10 mapped rows use the recipe MI No Recipe Needed; 3 mapped recipes have AvgCost $0.00 (bottled water and soda); no mapped recipe cost is missing ((?)).
Unmapped plus $0-cost rows are 75.12% of week net sales ($9,428.03 of $12,550.25).
The Toast all-levels export has no size or modifier on any row, so each join key is the item name only.
SAL-05 Top Modifiers (591 rows) was not joined.

## Sold items

Source: `SAL-03.csv` (Product mix, all levels). One row per item with qty > 0 or net ≠ 0. Parent/subtotal rows (no Item name) omitted. `SAL-03.csv` `Deferred=true` item rows (13 rows, 91 qty, $144.60: foundation, gift card, 1P delivery) are omitted because they are not in the SAL-03 total line. Size modifier and Modifiers, special requests are empty on every SAL-03 row, so Type is `item` on every row and the join key is `<Item>` only. Duplicate Toast names are separate POS vs kiosk rows. POS code is not in this capture.

| Type | Toast name | POS code | Qty | Net sales | R365 recipe | Recipe cost |
|---|---|---|---|---|---|---|
| item | *HOOK & LADDER | not shown (SAL-03.csv) | 77 | $862.41 | unmapped | n/a |
| item | *FIREHOUSE MEATBALL | not shown (SAL-03.csv) | 44 | $517.83 | unmapped | n/a |
| item | *SWEET & SPICY MEATBALL | not shown (SAL-03.csv) | 1 | $15.79 | unmapped | n/a |
| item | *NEW YORK STEAMER | not shown (SAL-03.csv) | 26 | $339.91 | unmapped | n/a |
| item | *ITALIAN | not shown (SAL-03.csv) | 70 | $813.85 | unmapped | n/a |
| item | *TURKEY BACON RANCH | not shown (SAL-03.csv) | 41 | $495.31 | unmapped | n/a |
| item | *CLUB ON A SUB | not shown (SAL-03.csv) | 61 | $708.18 | unmapped | n/a |
| item | *STEAK & CHEESE MELT | not shown (SAL-03.csv) | 26 | $340.45 | MI No Recipe Needed | $0.00 |
| item | *ENGINEER | not shown (SAL-03.csv) | 16 | $202.77 | unmapped | n/a |
| item | *FIREHOUSE HERO | not shown (SAL-03.csv) | 8 | $117.91 | unmapped | n/a |
| item | *SMOKEHOUSE BEEF & CHEDDAR BRISKET | not shown (SAL-03.csv) | 32 | $454.70 | unmapped | n/a |
| item | *SPICY CAJUN CHICKEN | not shown (SAL-03.csv) | 18 | $245.71 | unmapped | n/a |
| item | *JAMAICAN JERK TURKEY | not shown (SAL-03.csv) | 13 | $147.80 | unmapped | n/a |
| item | *PEPPERONI PIZZA MEATBALL SUB | not shown (SAL-03.csv) | 5 | $57.46 | unmapped | n/a |
| item | *CAPTIANS CLUB SUB | not shown (SAL-03.csv) | 7 | $78.49 | unmapped | n/a |
| item | *CHICKEN N' CHEDDAR RANCHER | not shown (SAL-03.csv) | 14 | $174.87 | MI No Recipe Needed | $0.00 |
| item | *SMOKIN' HONEY CHICKEN MELT | not shown (SAL-03.csv) | 10 | $142.89 | unmapped | n/a |
| item | *SMOKIN' HONEY STEAK MELT | not shown (SAL-03.csv) | 2 | $19.13 | unmapped | n/a |
| item | *THANKSGIVING SUB | not shown (SAL-03.csv) | 44 | $615.64 | (?) possible | n/a |
| item | *SMOKED TURKEY BREAST | not shown (SAL-03.csv) | 21 | $218.91 | unmapped | n/a |
| item | *HONEY HAM | not shown (SAL-03.csv) | 13 | $143.17 | (?) possible | n/a |
| item | *ROAST BEEF | not shown (SAL-03.csv) | 5 | $56.38 | unmapped | n/a |
| item | *PASTRAMI | not shown (SAL-03.csv) | 4 | $48.46 | unmapped | n/a |
| item | *GRILLED CHICKEN BREAST | not shown (SAL-03.csv) | 4 | $46.79 | unmapped | n/a |
| item | *CORNED BEEF | not shown (SAL-03.csv) | 1 | $10.39 | unmapped | n/a |
| item | *TUNA | not shown (SAL-03.csv) | 11 | $121.34 | unmapped | n/a |
| item | *VEGGIE | not shown (SAL-03.csv) | 5 | $49.55 | unmapped | n/a |
| item | RK Hook & Ladder | not shown (SAL-03.csv) | 14 | $98.11 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Firehouse Meatball | not shown (SAL-03.csv) | 3 | $23.97 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK New York Steamer | not shown (SAL-03.csv) | 1 | $5.99 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Italian | not shown (SAL-03.csv) | 6 | $43.94 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Turkey Bacon Ranch | not shown (SAL-03.csv) | 2 | $17.98 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Club On A Sub | not shown (SAL-03.csv) | 6 | $44.94 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Steak & Cheese Melt | not shown (SAL-03.csv) | 3 | $23.97 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Engineer | not shown (SAL-03.csv) | 2 | $14.98 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Firehouse Hero | not shown (SAL-03.csv) | 2 | $14.98 | unmapped | n/a |
| item | RK Chicken n' Cheddar Rancher | not shown (SAL-03.csv) | 2 | $20.53 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Smokin' Honey Chicken Melt | not shown (SAL-03.csv) | 1 | $13.49 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Smoked Turkey Breast | not shown (SAL-03.csv) | 6 | $50.34 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Pastrami | not shown (SAL-03.csv) | 1 | $5.99 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Tuna | not shown (SAL-03.csv) | 1 | $5.99 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Veggie | not shown (SAL-03.csv) | 3 | $17.97 | SM Sub Paper - 1003488 | $0.0611 |
| item | RK Thanksgiving | not shown (SAL-03.csv) | 5 | $45.95 | SM Sub Paper - 1003488 | $0.0611 |
| item | *FIREHOUSE SALAD | not shown (SAL-03.csv) | 1 | $7.49 | Chop Salad Paper - 1022673 | $0.2826 |
| item | *FIREHOUSE SALAD W/TURKEY | not shown (SAL-03.csv) | 2 | $19.18 | Chop Salad Paper - 1022673 | $0.2826 |
| item | *FIREHOUSE SALAD W/GRILLED CHICKEN | not shown (SAL-03.csv) | 1 | $9.59 | Chop Salad Paper - 1022673 | $0.2826 |
| item | *SIDE GRAVY | not shown (SAL-03.csv) | 1 | $1.00 | unmapped | n/a |
| item | *CHIPS | not shown (SAL-03.csv) | 62 | $109.23 | MI ALL CHIPS - 1009037 | $0.7154 |
| item | *EXTRA CHEESY MAC AND CHEESE | not shown (SAL-03.csv) | 6 | $22.58 | MI Extra Cheesy Mac & Cheese - 36115 | $1.911 |
| item | *REGULAR FRENCH FRIES | not shown (SAL-03.csv) | 6 | $17.25 | MI Regular Fries | $0.8764 |
| item | *LRG FRENCH FRIES | not shown (SAL-03.csv) | 2 | $6.67 | MI LG Fries | $1.1277 |
| item | *REGULAR CAJUN FRENCH FRIES | not shown (SAL-03.csv) | 12 | $39.74 | unmapped | n/a |
| item | *LARGE CAJUN FRENCH FRIES | not shown (SAL-03.csv) | 6 | $31.80 | unmapped | n/a |
| item | *PECAN PIE BAR | not shown (SAL-03.csv) | 16 | $50.38 | MI Pecan Pie Bar - 41220 | $1.2457 |
| item | *CHOCOLATE CHIP COOKIE | not shown (SAL-03.csv) | 14 | $18.80 | MI ALL COOKIES | $0.4141 |
| item | *OATMEAL RAISIN COOKIE | not shown (SAL-03.csv) | 3 | $3.01 | MI ALL COOKIES | $0.4141 |
| item | *BROWNIE | not shown (SAL-03.csv) | 12 | $27.27 | MI BROWNIE - 41110 | $0.7215 |
| item | *CUP CHILI | not shown (SAL-03.csv) | 1 | $0.69 | MI Cup Firehouse Chili - 35110 | $1.2414 |
| item | *BOWL CHILI | not shown (SAL-03.csv) | 1 | $5.79 | MI Bowl Firehouse Chili - 35120 | $1.9904 |
| item | *CUP POTATO SOUP | not shown (SAL-03.csv) | 1 | $3.69 | MI Cup Potato Soup - 35310 | $0.8416 |
| item | *BOWL POTATO SOUP | not shown (SAL-03.csv) | 1 | $4.79 | MI Bowl Potato Soup - 35320 | $1.324 |
| item | *3 DESSERT BUNDLE | not shown (SAL-03.csv) | 4 | $13.56 | MI No Recipe Needed | $0.00 |
| item | *KIDS' SMOKED TURKEY BREAST | not shown (SAL-03.csv) | 1 | $5.81 | SM Sub Paper - 1003488 | $0.0611 |
| item | *KIDS' HONEY HAM | not shown (SAL-03.csv) | 3 | $20.17 | SM Sub Paper - 1003488 | $0.0611 |
| item | *KIDS' GRILLED CHEDDAR CHEESE | not shown (SAL-03.csv) | 1 | $6.39 | SM Sub Paper - 1003488 | $0.0611 |
| item | *KIDS' MEATBALL | not shown (SAL-03.csv) | 3 | $17.77 | Kids Meatball Paper | $0.0641 |
| item | *SMALL FOUNTAIN | not shown (SAL-03.csv) | 26 | $76.62 | MI Small Fountain Drink | $0.0375 |
| item | *MEDIUM FOUNTAIN | not shown (SAL-03.csv) | 15 | $39.85 | MI Medium Fountain Drink | $0.1114 |
| item | *LARGE FOUNTAIN | not shown (SAL-03.csv) | 12 | $40.10 | MI Large Fountain Drink | $0.0998 |
| item | *BOTTLED WATER | not shown (SAL-03.csv) | 3 | $9.57 | MI Bottled Water - 80510 | $0.00 |
| item | *BOTTLED SODA | not shown (SAL-03.csv) | 1 | $3.19 | MI Bottled Soda - 80610 | $0.00 |
| item | *DELUXE PLATTER BUNDLE | not shown (SAL-03.csv) | 1 | $126.99 | MI Deluxe Platter Bundle - 430520 | $5.3659 |
| item | Rookie Hook & Ladder | not shown (SAL-03.csv) | 6 | $53.85 | SM Sub Paper - 1003488 | $0.0611 |
| item | Rookie Italian | not shown (SAL-03.csv) | 1 | $10.46 | SM Sub Paper - 1003488 | $0.0611 |
| item | Rookie Chicken n' Cheddar Rancher | not shown (SAL-03.csv) | 1 | $9.99 | SM Sub Paper - 1003488 | $0.0611 |
| item | Rookie Smoked Turkey Breast | not shown (SAL-03.csv) | 1 | $10.46 | SM Sub Paper - 1003488 | $0.0611 |
| item | Thanksgiving Sub | not shown (SAL-03.csv) | 13 | $224.55 | MI No Recipe Needed | $0.00 |
| item | Pecan Pie Bar | not shown (SAL-03.csv) | 3 | $9.92 | MI Pecan Pie Bar - 41220 | $1.2457 |
| item | Smokin' Honey Chicken Melt | not shown (SAL-03.csv) | 5 | $60.18 | unmapped | n/a |
| item | Smokin' Honey Steak & Cheese Melt | not shown (SAL-03.csv) | 1 | $13.35 | unmapped | n/a |
| item | Regular Cajun Fries | not shown (SAL-03.csv) | 4 | $12.69 | unmapped | n/a |
| item | Large Cajun Fries | not shown (SAL-03.csv) | 6 | $29.47 | unmapped | n/a |
| item | Steak & Cheese Melt | not shown (SAL-03.csv) | 10 | $147.88 | MI No Recipe Needed | $0.00 |
| item | Chicken n' Cheddar Rancher | not shown (SAL-03.csv) | 1 | $12.14 | MI No Recipe Needed | $0.00 |
| item | Hook & Ladder | not shown (SAL-03.csv) | 53 | $591.77 | unmapped | n/a |
| item | Italian | not shown (SAL-03.csv) | 58 | $606.64 | unmapped | n/a |
| item | Turkey Bacon Ranch | not shown (SAL-03.csv) | 13 | $200.88 | unmapped | n/a |
| item | Firehouse Meatball | not shown (SAL-03.csv) | 47 | $520.51 | unmapped | n/a |
| item | Club On A Sub | not shown (SAL-03.csv) | 21 | $345.38 | unmapped | n/a |
| item | New York Steamer | not shown (SAL-03.csv) | 8 | $112.62 | unmapped | n/a |
| item | Spicy Cajun Chicken | not shown (SAL-03.csv) | 12 | $174.35 | unmapped | n/a |
| item | Engineer | not shown (SAL-03.csv) | 9 | $102.21 | unmapped | n/a |
| item | Pepperoni Pizza Meatball Sub | not shown (SAL-03.csv) | 4 | $47.61 | unmapped | n/a |
| item | Captains Club Sub | not shown (SAL-03.csv) | 2 | $24.11 | unmapped | n/a |
| item | Smokehouse Beef & Cheddar Brisket | not shown (SAL-03.csv) | 10 | $161.44 | unmapped | n/a |
| item | Sweet & Spicy Meatball | not shown (SAL-03.csv) | 4 | $52.28 | unmapped | n/a |
| item | Jamaican Jerk Turkey | not shown (SAL-03.csv) | 4 | $57.05 | unmapped | n/a |
| item | B. L. T. | not shown (SAL-03.csv) | 2 | $23.17 | unmapped | n/a |
| item | Smoked Turkey Breast | not shown (SAL-03.csv) | 24 | $302.17 | unmapped | n/a |
| item | Honey Ham | not shown (SAL-03.csv) | 2 | $24.45 | MI No Recipe Needed | $0.00 |
| item | Roast Beef | not shown (SAL-03.csv) | 2 | $32.58 | unmapped | n/a |
| item | Veggie | not shown (SAL-03.csv) | 3 | $40.81 | unmapped | n/a |
| item | Tuna | not shown (SAL-03.csv) | 2 | $23.27 | unmapped | n/a |
| item | Hook & Ladder Salad | not shown (SAL-03.csv) | 1 | $11.50 | Chop Salad Paper - 1022673 | $0.2826 |
| item | *REGULAR FRENCH FRIES | not shown (SAL-03.csv) | 4 | $11.64 | MI Regular Fries | $0.8764 |
| item | *LRG FRENCH FRIES | not shown (SAL-03.csv) | 5 | $27.95 | MI LG Fries | $1.1277 |
| item | Regular Cajun Fries | not shown (SAL-03.csv) | 1 | $3.49 | unmapped | n/a |
| item | Extra Cheesy Mac and Cheese | not shown (SAL-03.csv) | 1 | $6.25 | MI Extra Cheesy Mac & Cheese - 36115 | $1.911 |
| item | Pecan Pie Bar | not shown (SAL-03.csv) | 3 | $11.29 | MI Pecan Pie Bar - 41220 | $1.2457 |
| item | Chocolate Chip Cookie | not shown (SAL-03.csv) | 12 | $13.24 | MI ALL COOKIES | $0.4141 |
| item | Brownie | not shown (SAL-03.csv) | 5 | $13.75 | MI BROWNIE - 41110 | $0.7215 |
| item | Oatmeal Raisin Cookie | not shown (SAL-03.csv) | 2 | $3.30 | MI ALL COOKIES | $0.4141 |
| item | Bowl Firehouse Chili | not shown (SAL-03.csv) | 2 | $9.57 | MI Bowl Firehouse Chili - 35120 | $1.9904 |
| item | Cup Potato Soup | not shown (SAL-03.csv) | 3 | $10.32 | MI Cup Potato Soup - 35310 | $0.8416 |
| item | Bowl Potato Soup | not shown (SAL-03.csv) | 2 | $10.54 | MI Bowl Potato Soup - 35320 | $1.324 |
| item | Bowl Chicken Dumpling | not shown (SAL-03.csv) | 1 | $4.68 | MI Bowl Chicken Dumpling | $0.118 |
| item | Chips | not shown (SAL-03.csv) | 36 | $76.62 | MI ALL CHIPS - 1009037 | $0.7154 |
| item | *MED WHITE GARLIC BREAD | not shown (SAL-03.csv) | 3 | $6.61 | MI No Recipe Needed | $0.00 |
| item | Fountain Drink | not shown (SAL-03.csv) | 5 | $17.55 | MI No Recipe Needed | $0.00 |
| item | Bottled Drinks | not shown (SAL-03.csv) | 7 | $17.76 | MI Bottled Soda - 80610 | $0.00 |
| item | Kids Smoked Turkey Combo | not shown (SAL-03.csv) | 1 | $7.59 | SM Sub Paper - 1003488 | $0.0611 |
| item | Kids Honey Ham Combo | not shown (SAL-03.csv) | 1 | $6.59 | SM Sub Paper - 1003488 | $0.0611 |
| item | Kids Grilled Cheddar Cheese Combo | not shown (SAL-03.csv) | 1 | $7.59 | MI Kids Grilled Cheddar Cheese Combo - 50310 | $0.3491 |
| item | Do Not Make | not shown (SAL-03.csv) | 11 | $0.00 | MI No Recipe Needed | $0.00 |

## Totals

| Metric | Value |
|---|---|
| week | 10/05–10/11/2026 |
| rows | 124 |
| unmapped | 50 |
| $0-cost | 3 |
| no recipe needed | 10 |
| (?) possible | 2 |
| table qty / table net sales | 1294 / $12550.25 |
| export qty / export net sales | 1294 / $12,550.25 |
| week net sales | $12,550.25 |
| % of week net sales on unmapped or $0-cost | 75.12% ($9428.03 / $12,550.25) |

Table qty and table net sales match the SAL-03 total line (1,294 qty / $12,550.25). `$0-cost` is mapped rows whose recipe `AvgCost` is `$0.00`, excluding `MI No Recipe Needed`. The `%` does not include `(?) possible` or `no recipe needed`.

## How mapping works

Week **10/05–10/11/2026**. Files: `SAL-03.csv` (row source; product mix all levels), `SAL-02.csv` (item-level, not joined), `SAL-05.csv` (Top Modifiers, 591 rows, modifier name only, no item or size — cross-check, not joined), `MNU-02.csv` (64,693 menu items; Name is the join target), `RCP-02.csv` (2,331 recipes; cost is **`AvgCost`**, not `MNU-02.EstimatedCost` and not `RCP-02.Cost`), `MAP-03.txt` / `MAP-03.png` (Point of sale items). Join is the name-key rule, not POS code (no POS-code column in SAL-03, MNU-02, or RCP-02).

Build the key from SAL-03 `Item, open item`, `Size modifier`, `Modifiers, special requests` as R365 `MNU-02.Name`: `<Item>-<Size>-<Modifier>` when both size and modifier are present, `<Item>-<Modifier>` when there is no size, `<Item>-<Size>` when there is no modifier, `<Item>` when neither is present. Case and spaces as exported; no trim or rewrite. Exact `MNU-02.Name` match only. Then `MNU-02.Recipe` must equal `RCP-02.Name` exactly to take **`AvgCost`**. A key that matches only after case, spaces, punctuation, or order is `(?) possible`, not mapped. No fuzzy match is mapped. This SAL-03 file has size and modifier blank on every row, so every sold-row key is `<Item>`.

Join-rule examples from this capture (5):

1. `<Item>-<Size>-<Modifier>`: `*HOOK & LADDER-Medium-MIXED PEPPERS` (`MNU-02.csv`) exact Name → Recipe `MI MD Mixed Red Green Peppers - 113385`.
2. `<Item>-<Modifier>`: `*HOOK & LADDER SALAD-LITE CUCUMBERS` (`MNU-02.csv`) exact Name → Recipe `MI No Recipe Needed`.
3. `<Item>-<Size>` (confirmed, not (?)): `*HOOK & LADDER-Medium` (`MNU-02.csv`) exact Name → Recipe `MD Sub Paper - 1003489`.
4. `<Item>` (confirmed, not (?)): `RK Club On A Sub` (`SAL-03.csv` and `MNU-02.csv`) exact Name → Recipe `SM Sub Paper - 1003488`, `AvgCost` `$0.0611` (`RCP-02.csv`).
5. `<Item>` unmapped: `*HOOK & LADDER` (`SAL-03.csv`) has no exact `MNU-02.Name`; R365 has size/modifier suffixes on that item, not the item-only key.

Seven sold rows have an exact `MNU-02.Name` but `Recipe` is blank and `RecipeIsAssigned=No` (`RK Firehouse Hero`, `*SIDE GRAVY`, `*REGULAR CAJUN FRENCH FRIES`, `*LARGE CAJUN FRENCH FRIES`, `Regular Cajun Fries` ×2, `Large Cajun Fries`). Those are `unmapped` (no recipe), cost `n/a`. Two `(?) possible` keys (`*THANKSGIVING SUB`, `*HONEY HAM`) match `Thanksgiving Sub` / `Honey Ham` only after dropping `*`.

F4 expected size only (not this check’s sold-row evidence): 2,331 recipes; 64,670 menu items (this file: 64,693); visible Estimated Cost `$0.00`. This capture’s `RCP-02.csv` includes `MI 6in Hook and Ladder Box - 400120`, `AvgCost` `1.1732` (Number `1130252`).

| Q | Answer | Capture |
|---|---|---|
| (a) Where does POS-item → recipe mapping live? | seen: Point of sale items — Sales & forecasting > Menu items > Point of sale items (`MAP-03.txt`). POS Item Name → Menu Item (64,866 POS items). Recipe is on the menu item (`MNU-02.csv` Recipe; `MAP-04.txt` Recipe = MI No Recipe Needed). | MAP-03.txt |
| (b) Is the POS Toast or another POS? What does the menu item say its POS or location is? | seen: Toast restaurant 00122 - Cary 1 (`SAL-02.txt`). Menu item POS or location label: not named (`MAP-04.txt`; `MAP-03.txt` default columns show no POS id/location). | SAL-02.txt, MAP-04.txt, MAP-03.txt |
| (c) Why do menu items show Estimated Cost $0.00 while recipes have a cost? | seen: `MNU-02.csv` EstimatedCost is 0.0000 on all 64,693 rows; `RCP-02.csv` AvgCost has amounts (first row 10 Medium Honey Ham - 406024 AvgCost 7.9950) while `RCP-02.csv` Cost is 0.00. Menu item $0.00 with a recipe AvgCost is not $0-cost. | MNU-02.csv, RCP-02.csv |

## Deviations

The PC agent clicked **+ Create** on R365 Recipes, opened a blank RecipeItemForm (`https://fhs4021089.restaurant365.com/#/form/RecipeItemForm/00000000-0000-0000-0000-000000000000`), typed nothing, and closed it (`RCP-02.txt` line 10). It is not in `pages.csv`. Not a new allowed action.

`RCP-01.txt` line 10 is the same Create / RecipeItemForm note (the Recipes `.txt` was saved twice). `RCP-01.txt` line 3 and `RCP-02.txt` line 3 also name the **+ Create** button (not clicked except the line-10 miss). `MAP-02.txt` line 6 lists **+ Create** as a button seen and not clicked. `pages.csv` has no create/new URL. No other `.txt` open of a Create form was found.
