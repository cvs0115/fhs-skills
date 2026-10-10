"""Biweekly pay period + Dropbox week folder for a store.

Pay periods are two weeks, Monday-Sunday, anchored on config "pay_period_anchor" (Mon 9/21/2026).
The working folder for a run is <archive_root>/<store 5 digits>/<year>/<MM MON>/Week <ISO week>,
using the period's END date (the last Sunday) - e.g. 122 for 9/21-10/4/2026 ->
...\\Locations\\00122\\2026\\10 OCT\\Week 40.

Usage:
    py period.py 122                  # last completed period as of today, creates the folder
    py period.py 122 2026-10-20       # last completed period as of that date
    py period.py 122 --current        # the period that contains today
"""
import json
import os
import sys
from datetime import date, timedelta
from pathlib import Path

# Shared settings for all fhs skills (Dropbox). Override with the FHS_SKILLS_HOME environment variable.
FHS_HOME = Path(os.environ.get("FHS_SKILLS_HOME", r"C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services\fhs-skills"))
CONFIG = FHS_HOME / "config.json"


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        sys.exit(__doc__)
    store = args[0]
    as_of = date.fromisoformat(args[1]) if len(args) > 1 else date.today()
    cfg = json.loads(CONFIG.read_text(encoding="utf-8"))
    anchor = date.fromisoformat(cfg.get("pay_period_anchor", "2026-09-21"))

    start = anchor + timedelta(days=14 * ((as_of - anchor).days // 14))
    if "--current" not in sys.argv:
        start -= timedelta(days=14)
    end = start + timedelta(days=13)

    folder = (Path(cfg["archive_root"]) / store.zfill(5) / f"{end:%Y}"
              / f"{end:%m} {end:%b}".upper() / f"Week {end.isocalendar()[1]}")
    folder.mkdir(parents=True, exist_ok=True)

    print(f"Store:       {store} ({cfg['stores'].get(store, {}).get('name', 'NOT IN CONFIG')})")
    print(f"Pay period:  {start:%a %m/%d/%Y} - {end:%a %m/%d/%Y}")
    print(f"Toast dates: {start:%m-%d-%Y} to {end:%m-%d-%Y}")
    print(f"Prefix:      {store}_{start:%Y-%m-%d}_{end:%Y-%m-%d}")
    print(f"Folder:      {folder}")


if __name__ == "__main__":
    main()
