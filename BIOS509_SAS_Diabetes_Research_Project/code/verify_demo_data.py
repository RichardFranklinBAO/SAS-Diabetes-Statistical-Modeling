#!/usr/bin/env python3
"""Validate public demo CSV and produce a clear, non-SAS provenance-labeled summary."""
from collections import Counter, defaultdict
from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data/synthetic_diabetes_demo.csv"
SUMMARY = ROOT / "outputs/synthetic_demo_summary.csv"

def verify():
    with DATA.open(newline="",encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    assert len(rows)==487, f"Expected 487 synthetic rows; found {len(rows)}"
    assert list(rows[0])==["id","race","wtkg","gluc","hba1c"]
    ids=set(); groups=defaultdict(list)
    for r in rows:
        i=int(r['id']); race=int(r['race']); w=float(r['wtkg']); g=float(r['gluc']); h=float(r['hba1c'])
        assert i not in ids;ids.add(i)
        assert race in (1,2,3,4) and 0<w<200 and 0<g<400 and 4<=h<=12
        groups[race].append(g)
    assert [len(groups[k]) for k in range(1,5)]==[120,135,107,125]
    SUMMARY.parent.mkdir(parents=True,exist_ok=True)
    with SUMMARY.open('w',newline='',encoding='utf-8') as f:
        wr=csv.writer(f)
        wr.writerow(['source','race','n','mean_glucose','high_glucose_n'])
        for race in range(1,5):
            g=groups[race]
            wr.writerow(['synthetic_python_validation',race,len(g),f'{sum(g)/len(g):.3f}',sum(x>150 for x in g)])
    print(f'PASS: synthetic records={len(rows)}, group counts={[len(groups[k]) for k in range(1,5)]}')
    print(f'Summary (Python, not SAS): {SUMMARY}')

if __name__=='__main__':
    verify()
