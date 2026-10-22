"""Biweekly payroll prep for ADP RUN from normalized report extracts, with a discrepancy report.

Run from the store's Dropbox week folder (see period.py):
    py <skill>/scripts/payroll.py 122_2026-09-21_2026-10-04

The prefix is <store>_<start>_<end>. Store rules come from the shared fhs-skills config.json in
Dropbox ("defaults" merged with "stores"."<store>"); a config.json in the week folder overrides it.

Input files (pipe-delimited, first line is a header; see references/extract-formats.md):
    <prefix>_hours.txt     Employee|Job|Reg Hours|OT Hours           (required, source of truth)
    <prefix>_shifts.txt    Employee|Job|In|Out|Hours|Tips            (required, drives the checks)
    <prefix>_totals.txt    Key|Value  report grand totals: reg_hours, ot_hours, tips_collected
    <prefix>_tips.txt      Employee|CC Tips   tip payouts from R365 Tip Automation / NCR Tip Income
    <prefix>_crosscheck_hours.txt  Employee|Total Hours  second system's hours (e.g. Toast for an R365 store)

Tips: if _tips.txt exists it is used for ADP, and (when shifts carry tips) the R365 daily rule is
recomputed to validate it. Without _tips.txt the daily rule is used for ADP.

Outputs:
    <prefix>_adp_entry.csv            Employee, Reg, OT, CC Tips, Bonus (ADP grid order) + notes
    <prefix>_discrepancy_report.html  everything that needs a human look before submitting
"""
import csv
import html
import json
import os
import re
import statistics
import sys
from datetime import datetime, timedelta
from pathlib import Path

DATA = Path.cwd()
# Shared settings for all fhs skills (Dropbox). Override with the FHS_SKILLS_HOME environment variable.
FHS_HOME = Path(os.environ.get("FHS_SKILLS_HOME", r"C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\fhs-skills"))
HIGH, MEDIUM, INFO = "High", "Medium", "Info"
TIME_FORMATS = ("%m/%d/%Y %I:%M %p", "%m/%d/%y %I:%M %p")


# ---------- helpers ----------

def num(s):
    s = (s or "").replace("$", "").replace(",", "").strip()
    return float(s) if s else 0.0


def when(s):
    for f in TIME_FORMATS:
        try:
            return datetime.strptime(s.strip(), f)
        except ValueError:
            pass
    raise ValueError(f"Unrecognized date/time: {s!r} (use MM/DD/YYYY H:MM AM)")


def key(name):
    """'Cruz, Ashley', 'AShley Cruz (2847)' and 'Cashier2 Cashier2' -> comparable keys."""
    name = re.sub(r"\(.*?\)|-\s*\d+.*$", "", name)
    return " ".join(sorted(re.findall(r"[a-z0-9]+", name.lower())))


def rows(path):
    if not path.exists():
        return None
    out = []
    for line in path.read_text(encoding="utf-8").splitlines()[1:]:
        if line.strip() and not line.startswith("#"):
            out.append([c.strip() for c in re.split(r"\||\t", line)])
    return out


def load_config(store):
    # A config.json in the working folder wins (for testing); otherwise the shared fhs-skills config.
    path = DATA / "config.json"
    if not path.exists():
        path = FHS_HOME / "config.json"
    raw = json.loads(path.read_text(encoding="utf-8"))
    if store not in raw.get("stores", {}):
        sys.exit(f"Store {store} is not in config.json 'stores' - add it before running.")
    cfg = json.loads(json.dumps(raw.get("defaults", {})))
    for k, v in raw["stores"][store].items():
        if isinstance(v, dict) and isinstance(cfg.get(k), dict):
            cfg[k].update(v)
        else:
            cfg[k] = v
    for k in ("shared_logins", "non_employee_accounts", "exclude_from_payroll",
              "fixed_100_hour_employees", "tip_receiver_jobs"):
        cfg[k + "_keys"] = {key(n) for n in cfg.get(k, [])}
    cfg.setdefault("biweekly_salary", {})
    cfg["salary_by_key"] = {key(n): v for n, v in cfg["biweekly_salary"].items()}
    return cfg


# ---------- loading ----------

def load_hours(path):
    people = {}
    for c in rows(path) or []:
        p = people.setdefault(key(c[0]), {"name": c[0], "jobs": {}})
        reg, ot = num(c[2]), num(c[3])
        j = p["jobs"].setdefault(c[1], [0.0, 0.0])
        j[0] += reg
        j[1] += ot
    return people


def load_shifts(path):
    shifts = []
    for c in rows(path) or []:
        shifts.append({"key": key(c[0]), "name": c[0], "job": c[1], "in": when(c[2]),
                       "out": when(c[3]) if c[3] else None, "hours": num(c[4]),
                       "tips": num(c[5]) if len(c) > 5 else 0.0})
    return shifts


def load_kv(path):
    return {c[0].lower(): num(c[1]) for c in rows(path) or [] if len(c) >= 2}


def load_amounts(path):
    data = rows(path)
    return None if data is None else {key(c[0]): (c[0], num(c[1])) for c in data if len(c) >= 2}


def parse_tip_date(s):
    for fmt in ("%m/%d/%Y", "%m/%d/%y", "%Y-%m-%d"):
        try:
            return datetime.strptime(s.strip(), fmt).date()
        except ValueError:
            pass
    raise ValueError(f"Unrecognized tip date: {s!r} (use M/D/YYYY)")


def load_tip_sources(path):
    data = rows(path)
    if data is None:
        return None
    return [{"date": parse_tip_date(c[0]), "source": c[1], "card_tips": num(c[2]), "contributor": c[3]}
            for c in data if len(c) >= 4]


def load_tip_contributors(path):
    data = rows(path)
    if data is None:
        return None
    return [{"date": parse_tip_date(c[0]), "contributor": c[1], "amount": num(c[2])}
            for c in data if len(c) >= 3]


def tip_contributor_issues(cfg, tips_path, sources_path, contributors_path):
    if cfg.get("pos") != "toast_r365":
        return []
    if not tips_path.exists():
        return []
    sources = load_tip_sources(sources_path)
    contributors = load_tip_contributors(contributors_path)
    if sources is None or contributors is None:
        return [{"severity": MEDIUM, "employee": "(tips)", "issue": "Tip contributor check not run",
                 "detail": "Save _tip_sources.txt and _tip_contributors.txt (see extract-formats.md)"}]
    by_date = {}
    for row in contributors:
        by_date.setdefault(row["date"], set()).add(key(row["contributor"]))
    issues = []
    for row in sources:
        if row["card_tips"] <= 0:
            continue
        names = by_date.get(row["date"])
        if not names or key(row["contributor"]) not in names:
            d = f"{row['date'].month}/{row['date'].day}/{row['date'].year}"
            issues.append({"severity": HIGH, "employee": row["source"], "issue": "Tip source missing from R365 contributors",
                           "detail": f"{d} {row['source']} card tips ${row['card_tips']:.2f} - "
                           f"no {row['contributor']} on that date in R365 Tip Automation contributors"})
    return issues


# ---------- tips ----------

def round_to_total(raw, total):
    """Round to cents so the parts add up exactly to total (largest remainder)."""
    cents = {n: int(v * 100) for n, v in raw.items()}
    short = round(total * 100) - sum(cents.values())
    for n in sorted(raw, key=lambda n: raw[n] * 100 - cents[n], reverse=True)[:max(short, 0)]:
        cents[n] += 1
    return {n: c / 100 for n, c in cents.items()}


def daily_rule_tips(shifts, tips_collected, cfg):
    """Mirror the R365 tip rule: each day's tips split by worked hours among receiver jobs.

    Tips not tied to any shift (kiosk, non-tipped jobs) are split by period hours.
    """
    skip = cfg["shared_logins_keys"] | cfg["exclude_from_payroll_keys"] | cfg["non_employee_accounts_keys"]
    receivers_ok = cfg["tip_receiver_jobs_keys"]
    days = {}
    for s in shifts:
        days.setdefault(s["in"].date(), []).append(s)
    raw, period_hrs = {}, {}
    for day in days.values():
        pool = sum(s["tips"] for s in day)
        recv = [s for s in day if key(s["job"]) in receivers_ok and s["key"] not in skip and s["hours"]]
        hrs = sum(s["hours"] for s in recv)
        for s in recv:
            raw[s["key"]] = raw.get(s["key"], 0) + (pool * s["hours"] / hrs if hrs else 0)
            period_hrs[s["key"]] = period_hrs.get(s["key"], 0) + s["hours"]
    unattributed = round(tips_collected - sum(s["tips"] for s in shifts), 2)
    total_hrs = sum(period_hrs.values())
    for k, h in period_hrs.items():
        raw[k] += unattributed * h / total_hrs
    return round_to_total(raw, tips_collected), unattributed


# ---------- ADP rows ----------

def build_adp_rows(people, tips, cfg):
    skip = cfg["shared_logins_keys"] | cfg["non_employee_accounts_keys"] | cfg["exclude_from_payroll_keys"]
    out = []
    for k, p in sorted(people.items(), key=lambda kv: kv[1]["name"].lower()):
        if k in skip:
            continue
        reg = round(sum(j[0] for j in p["jobs"].values()), 2)
        ot = round(sum(j[1] for j in p["jobs"].values()), 2)
        bonus, note = 0.0, ""
        if k in cfg["fixed_100_hour_employees_keys"]:
            over = round(max(reg + ot - 100, 0), 2)
            salary = cfg["salary_by_key"].get(k)
            bonus = round(over * salary / 100, 2) if over and salary else 0.0
            reg, ot = 80.0, 0.0  # ADP salary line always takes 80 hrs
            note = f"Salary: 80 hrs in ADP; bonus = {over} hrs over 100 x (salary/100)"
        if len(p["jobs"]) > 1:
            note = "One line in ADP (" + ", ".join(f"{j} {h[0] + h[1]:.2f}" for j, h in p["jobs"].items()) + ")"
        out.append({"key": k, "Employee": p["name"], "Regular Hours": f"{reg:.2f}",
                    "Overtime Hours": f"{ot:.2f}", "CC Tips": f"{tips.get(k, 0.0):.2f}",
                    "Bonus": f"{bonus:.2f}" if bonus else "", "Notes": note})
    return out


# ---------- checks ----------

def find_issues(people, shifts, totals, tips_file, rule_tips, crosscheck, cfg):
    c = cfg["checks"]
    issues = []
    add = lambda sev, who, what, detail: issues.append(
        {"severity": sev, "employee": who, "issue": what, "detail": detail})
    fmt = lambda s: f"{s['in']:%a %m/%d %I:%M %p} - " + (f"{s['out']:%I:%M %p}" if s["out"] else "NO CLOCK-OUT")
    shared, excluded = cfg["shared_logins_keys"], cfg["exclude_from_payroll_keys"]
    non_emp = cfg["non_employee_accounts_keys"]
    fixed = cfg["fixed_100_hour_employees_keys"]
    open_t = datetime.strptime(c["store_open"], "%I:%M %p").time()
    close_t = datetime.strptime(c["store_close"], "%I:%M %p").time()
    autos = {datetime.strptime(t, "%I:%M %p").time() for t in c["auto_clockout_times"]}

    # Extraction sanity: did we read every line of the reports?
    reg_sum = sum(j[0] for p in people.values() for j in p["jobs"].values())
    ot_sum = sum(j[1] for p in people.values() for j in p["jobs"].values())
    for label, got, k in (("regular hours", reg_sum, "reg_hours"), ("overtime hours", ot_sum, "ot_hours")):
        if k in totals and abs(totals[k] - got) > 0.05:
            add(HIGH, "(report)", f"Extracted {label} don't match report total",
                f"report {totals[k]:.2f} vs extracted {got:.2f} - re-read the hours report")
    shift_hours = {}
    for s in shifts:
        shift_hours[s["key"]] = shift_hours.get(s["key"], 0) + s["hours"]
    for k, p in people.items():
        total = sum(j[0] + j[1] for j in p["jobs"].values())
        if shifts and abs(shift_hours.get(k, 0) - total) > 0.1 and k not in shared | excluded:
            add(HIGH, p["name"], "Shift detail doesn't add up to hours report",
                f"hours report {total:.2f} vs shifts {shift_hours.get(k, 0):.2f}")

    by_person = {}
    for s in shifts:
        by_person.setdefault(s["key"], []).append(s)
    for k, ss in by_person.items():
        ss.sort(key=lambda s: s["in"])
        name = people.get(k, {"name": ss[0]["name"]})["name"]
        total = sum(s["hours"] for s in ss)
        if k in shared:
            add(HIGH, name, "Shared login has clocked hours",
                f"{len(ss)} shifts, {total:.2f} hrs - do not pay; its tips go to real employees")
            continue
        if k in excluded:
            add(INFO, name, "Excluded from payroll", f"{total:.2f} hrs on the clock, left off per rules")
            continue
        if k in non_emp:
            continue
        if k not in people:
            add(HIGH, name, "Has shifts but missing from hours report", f"{total:.2f} hrs in shift detail")
        typical = statistics.median(s["hours"] for s in ss if s["hours"]) if any(s["hours"] for s in ss) else 0
        for s in ss:
            hrs = s["hours"]
            if s["out"] is None:
                add(HIGH, name, "Missing clock-out", fmt(s))
                continue
            if not hrs and s["out"] > s["in"]:
                add(HIGH, name, "Punch with no hours counted",
                    f"{fmt(s)} ({(s['out'] - s['in']).seconds / 3600:.2f} hrs on the clock, 0 paid) - confirm")
            earliest = datetime.combine(s["in"].date(), open_t) - timedelta(minutes=c["open_buffer_minutes"])
            latest = datetime.combine(s["in"].date(), close_t) + timedelta(minutes=c["close_buffer_minutes"])
            auto = s["out"].time() in autos
            if s["in"] < earliest:
                add(MEDIUM, name, "Clock-in before store hours", f"{fmt(s)} - before {earliest:%I:%M %p}")
            if s["out"] > latest and not auto:
                add(MEDIUM, name, "Clock-out after store hours", f"{fmt(s)} - after {latest:%I:%M %p}")
            if auto:
                add(HIGH, name, "Likely auto clock-out", f"{fmt(s)} ({hrs:.2f} hrs) - confirm real out time")
            elif hrs > c["max_shift_hours"]:
                add(HIGH, name, "Very long shift", f"{fmt(s)} ({hrs:.2f} hrs)")
            elif len(ss) >= 3 and typical and hrs > typical * c["unusual_vs_typical_ratio"] and hrs - typical > 3:
                add(MEDIUM, name, "Shift much longer than usual", f"{fmt(s)} ({hrs:.2f} vs typical {typical:.2f})")
            if 0 < hrs < c["min_shift_hours"]:
                add(MEDIUM, name, "Very short shift", f"{fmt(s)} ({hrs:.2f} hrs) - accidental clock-in?")
        for a, b in zip(ss, ss[1:]):
            if a["out"] and b["in"] < a["out"]:
                add(HIGH, name, "Overlapping shifts", f"{fmt(a)} overlaps {fmt(b)}")

    # Stayed on the clock well after every coworker left (after store close) - e.g. a closer
    # finishing 16 min after the other closer. Shared logins don't count as coworkers.
    alone_min = c.get("alone_after_minutes", 15)
    days = {}
    for s in shifts:
        if s["out"] and s["key"] not in shared | excluded | non_emp:
            days.setdefault(s["in"].date(), []).append(s)
    for day, ds in days.items():
        ds.sort(key=lambda s: s["out"])
        last, prev = ds[-1], [s for s in ds if s["key"] != ds[-1]["key"]]
        close = datetime.combine(day, close_t)
        if prev and last["out"] > close:
            gap = (last["out"] - max(s["out"] for s in prev)).seconds / 60
            if gap >= alone_min:
                add(MEDIUM, people.get(last["key"], {"name": last["name"]})["name"],
                    "Stayed after everyone else left",
                    f"{fmt(last)} - {gap:.0f} min after the last coworker clocked out")

    # Repeated patterns: one summary line with the dates when the same flag hits a person often.
    min_count = c.get("pattern_min_count", 3)
    pattern_types = {"Clock-in before store hours": "early clock-ins",
                     "Clock-out after store hours": "late clock-outs",
                     "Very short shift": "very short shifts", "Likely auto clock-out": "auto clock-outs"}
    seen = {}
    for i in issues:
        if i["issue"] in pattern_types:
            seen.setdefault((i["employee"], i["issue"]), []).append(i["detail"][4:9])
    for (who, what), dates in seen.items():
        if len(dates) >= min_count:
            add(MEDIUM, who, f"Repeated {pattern_types[what]} ({len(dates)}x)",
                f"{', '.join(dates)} - routine? If so, adjust the store's buffer; if not, talk to them")

    for k, p in people.items():
        if k in shared | excluded | non_emp:
            continue
        reg = sum(j[0] for j in p["jobs"].values())
        ot = sum(j[1] for j in p["jobs"].values())
        if k in fixed:
            if reg + ot < 100:
                add(HIGH, p["name"], "Under 100 hrs on fixed 100-hr pay", f"Only {reg + ot:.2f} hrs this period")
        elif ot:
            add(MEDIUM, p["name"], "Overtime", f"{ot:.2f} OT hrs - confirm it's expected")
        if crosscheck is not None:
            other = crosscheck.get(k)
            tol = c.get("crosscheck_tolerance_hours", 0.1)
            if other is None:
                add(HIGH, p["name"], "Missing in cross-check system", f"{reg + ot:.2f} hrs, none in the other system")
            elif abs(other[1] - (reg + ot)) > tol:
                add(HIGH, p["name"], "Hours differ between systems",
                    f"source {reg + ot:.2f} vs cross-check {other[1]:.2f} ({other[1] - reg - ot:+.2f}) - "
                    f"find the missing/extra shift and fix the system that's wrong")
    if crosscheck is not None:
        ignore = shared | excluded | cfg["non_employee_accounts_keys"]
        for k, (n, hrs) in crosscheck.items():
            if k not in people and k not in ignore and hrs:
                add(HIGH, n, "In cross-check system but not source", f"{hrs:.2f} hrs there, none in the hours report")

    if tips_file is not None and rule_tips is not None:
        tol = c.get("tip_validation_tolerance", 1.00)
        for k in set(tips_file) | set(rule_tips):
            got = tips_file.get(k, (None, 0.0))[1]
            exp = rule_tips.get(k, 0.0)
            if abs(got - exp) > tol:
                who = tips_file.get(k, (people.get(k, {}).get("name", k),))[0]
                add(MEDIUM, who, "Tip payout differs from the tip rule",
                    f"payout ${got:.2f} vs rule ${exp:.2f} ({got - exp:+.2f}) - check the manager's approval")
    for k in cfg["shared_logins_keys"]:
        if tips_file and tips_file.get(k, (None, 0))[1]:
            add(HIGH, tips_file[k][0], "Tips paid to a shared login",
                f"${tips_file[k][1]:.2f} - redistribute; remove Cashier-type jobs from the tip rule receivers")

    order = {HIGH: 0, MEDIUM: 1, INFO: 2}
    return sorted(issues, key=lambda i: (order[i["severity"]], i["employee"]))


# ---------- output ----------

def write_csv(path, adp):
    cols = ["Employee", "Regular Hours", "Overtime Hours", "CC Tips", "Bonus", "Notes"]
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction="ignore")
        w.writeheader()
        w.writerows(adp)


def write_report(path, title, issues, adp, stats):
    esc = html.escape
    counts = {s: sum(1 for i in issues if i["severity"] == s) for s in (HIGH, MEDIUM, INFO)}
    cols = ["Employee", "Regular Hours", "Overtime Hours", "CC Tips", "Bonus", "Notes"]
    issue_rows = "\n".join(
        f"<tr><td><span class='pill {i['severity'].lower()}'>{i['severity']}</span></td>"
        f"<td>{esc(i['employee'])}</td><td>{esc(i['issue'])}</td><td>{esc(i['detail'])}</td></tr>"
        for i in issues) or "<tr><td colspan=4>No issues found.</td></tr>"
    adp_rows = "\n".join("<tr>" + "".join(f"<td>{esc(str(r[c]))}</td>" for c in cols) + "</tr>" for r in adp)
    stat_html = "".join(f"<div class='stat'><b>{esc(v)}</b>{esc(k)}</div>" for k, v in stats.items())
    path.write_text(f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Payroll Discrepancy Report</title>
<style>
:root {{ --bg:#fff; --fg:#1d1d1f; --muted:#6b6b70; --line:#e4e4e7; --card:#f7f7f8;
  --high:#c62828; --high-bg:#fdecea; --med:#a15c00; --med-bg:#fff4e0; --info:#1e5aa8; --info-bg:#e8f0fb; }}
@media (prefers-color-scheme: dark) {{ :root {{ --bg:#141416; --fg:#ececf0; --muted:#9a9aa2; --line:#2c2c31;
  --card:#1c1c20; --high:#ff8a80; --high-bg:#3a1a1a; --med:#ffcc80; --med-bg:#3a2a12; --info:#90b8f8; --info-bg:#16243a; }} }}
body {{ background:var(--bg); color:var(--fg); font:14px/1.5 system-ui,-apple-system,"Segoe UI",sans-serif; margin:0; padding:24px 16px; }}
main {{ max-width:1100px; margin:0 auto; }}
h1 {{ font-size:22px; margin:0 0 4px; }} h2 {{ font-size:16px; margin:32px 0 8px; }}
.sub {{ color:var(--muted); margin-bottom:20px; }}
.stats {{ display:flex; gap:12px; flex-wrap:wrap; }}
.stat {{ background:var(--card); border:1px solid var(--line); border-radius:8px; padding:10px 14px; min-width:120px; }}
.stat b {{ display:block; font-size:20px; }}
.wrap {{ overflow-x:auto; border:1px solid var(--line); border-radius:8px; }}
table {{ border-collapse:collapse; width:100%; }}
th, td {{ text-align:left; padding:8px 10px; border-bottom:1px solid var(--line); vertical-align:top; }}
th {{ background:var(--card); font-weight:600; white-space:nowrap; }}
tr:last-child td {{ border-bottom:none; }}
.pill {{ font-size:12px; font-weight:600; padding:2px 8px; border-radius:99px; white-space:nowrap; }}
.high {{ color:var(--high); background:var(--high-bg); }} .medium {{ color:var(--med); background:var(--med-bg); }}
.info {{ color:var(--info); background:var(--info-bg); }}
</style></head><body><main>
<h1>Payroll Discrepancy Report</h1>
<div class="sub">{esc(title)} &middot; generated {datetime.now():%m/%d/%Y %I:%M %p}</div>
<div class="stats">
  <div class="stat"><b class="high" style="background:none">{counts[HIGH]}</b>High - fix before payroll</div>
  <div class="stat"><b class="medium" style="background:none">{counts[MEDIUM]}</b>Medium - review</div>
  <div class="stat"><b class="info" style="background:none">{counts[INFO]}</b>Info</div>
  {stat_html}
</div>
<h2>Issues</h2>
<div class="wrap"><table><tr><th>Severity</th><th>Employee</th><th>Issue</th><th>Detail</th></tr>
{issue_rows}</table></div>
<h2>ADP RUN entry</h2>
<div class="wrap"><table><tr>{"".join(f"<th>{c}</th>" for c in cols)}</tr>
{adp_rows}</table></div>
</main></body></html>""", encoding="utf-8")


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    prefix = sys.argv[1]
    cfg = load_config(prefix.split("_")[0])
    f = lambda suffix: DATA / f"{prefix}_{suffix}.txt"
    if not f("hours").exists():
        sys.exit(f"Missing {f('hours').name} - extract the hours report first (references/extract-formats.md)")

    people = load_hours(f("hours"))
    shifts = load_shifts(f("shifts"))
    totals = load_kv(f("totals"))
    tips_file = load_amounts(f("tips"))
    crosscheck = load_amounts(f("crosscheck_hours"))

    shift_tips = sum(s["tips"] for s in shifts)
    tips_collected = totals.get("tips_collected")
    if tips_collected is None:
        tips_collected = sum(v for _, v in tips_file.values()) if tips_file else shift_tips

    rule_tips, unattributed = (None, 0.0)
    if shifts and shift_tips:
        rule_tips, unattributed = daily_rule_tips(shifts, tips_collected, cfg)
    if tips_file is not None:
        tips = {k: v for k, (_, v) in tips_file.items()}
        tip_source = "tip payout file (R365 / NCR)"
    elif rule_tips is not None:
        tips = rule_tips
        tip_source = f"daily rule (${unattributed:.2f} not tied to a shift, split by period hours)"
    else:
        tips = {}
        tip_source = "NONE - no tips file and no shift tips"

    adp = build_adp_rows(people, tips, cfg)
    issues = find_issues(people, shifts, totals, tips_file, rule_tips, crosscheck, cfg)
    issues.extend(tip_contributor_issues(cfg, f("tips"), f("tip_sources"), f("tip_contributors")))

    paid = round(sum(float(r["CC Tips"]) for r in adp), 2)
    leftover = round(tips_collected - paid, 2)
    if abs(leftover) >= 0.01:
        issues.insert(0, {"severity": HIGH, "employee": "(tips)", "issue": "Tips not fully paid out",
                          "detail": f"collected ${tips_collected:.2f}, ADP ${paid:.2f}, difference ${leftover:+.2f}"})

    total = lambda col: sum(float(r[col] or 0) for r in adp)
    stats = {"Reg hours (ADP)": f"{total('Regular Hours'):.2f}", "OT hours": f"{total('Overtime Hours'):.2f}",
             "CC tips": f"${paid:,.2f}", "Bonus": f"${total('Bonus'):,.2f}"}
    write_csv(DATA / f"{prefix}_adp_entry.csv", adp)
    write_report(DATA / f"{prefix}_discrepancy_report.html", f"{prefix} - {cfg.get('name', '')}", issues, adp, stats)

    print(f"Tips source: {tip_source}")
    print(f"{'Employee':30} {'Reg':>7} {'OT':>6} {'CC Tips':>9} {'Bonus':>8}")
    for r in adp:
        print(f"{r['Employee']:30} {r['Regular Hours']:>7} {r['Overtime Hours']:>6} {r['CC Tips']:>9} {r['Bonus']:>8}")
    print(f"{'TOTAL':30} {total('Regular Hours'):>7.2f} {total('Overtime Hours'):>6.2f} {paid:>9.2f} {total('Bonus'):>8.2f}")
    print(f"\nTips collected ${tips_collected:.2f} | paid ${paid:.2f}")
    print("Issues: " + ", ".join(f"{sum(1 for i in issues if i['severity'] == s)} {s}" for s in (HIGH, MEDIUM, INFO)))
    for i in issues:
        print(f"  [{i['severity']}] {i['employee']}: {i['issue']} - {i['detail']}")
    print(f"\nWrote {prefix}_adp_entry.csv and {prefix}_discrepancy_report.html in {DATA}")


if __name__ == "__main__":
    main()
