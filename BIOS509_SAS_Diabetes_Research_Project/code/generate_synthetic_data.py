#!/usr/bin/env python3
"""Generate entirely synthetic teaching data; never reads original patient records."""
from pathlib import Path
import csv
import random

OUT = Path(__file__).resolve().parents[1] / "data" / "synthetic_diabetes_demo.csv"

def generate():
    rng = random.Random(5092026)
    groups = [1]*120 + [2]*135 + [3]*107 + [4]*125
    rng.shuffle(groups)
    rows = []
    for index, race in enumerate(groups, 1):
        weight = min(150.0, max(39.0, rng.gauss({1:79,2:87,3:84,4:79}[race], 15.5)))
        hba1c = min(10.9, max(5.5, rng.gauss({1:7.35,2:7.75,3:7.70,4:7.35}[race], 0.70)))
        glucose = round(min(250,max(75, 143 + .42*(weight-82) + 14*(hba1c-7.5) + {1:-3,2:3,3:4,4:-4}[race] + rng.gauss(0,14))))
        rows.append([index, race, f"{weight:.1f}", glucose, f"{hba1c:.1f}"])
    OUT.parent.mkdir(parents=True,exist_ok=True)
    with OUT.open("w",newline="",encoding="utf-8") as f:
        writer=csv.writer(f);writer.writerow(["id","race","wtkg","gluc","hba1c"]);writer.writerows(rows)
    print(f"Generated {len(rows)} synthetic rows at {OUT}")

if __name__ == "__main__":
    generate()
