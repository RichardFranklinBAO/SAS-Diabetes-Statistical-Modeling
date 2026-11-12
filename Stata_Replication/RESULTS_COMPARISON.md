# SAS–Stata Replication: Results Comparison

**Independent Stata replication | November, 2026**

Using the same **487-observation course dataset** and equivalent statistical tests, the Stata implementation successfully reproduced the original SAS report's **key results to the reported precision**.

## Verified results

| Analysis | Original SAS report | Stata replication |
| --- | ---: | ---: |
| Observations analyzed | 487 | 487 |
| Glucose > 150 mg/dL | 204 | 204 |
| One-way ANOVA F | 7.11 | 7.1075 |
| Planned contrast | −18.62 | −18.6208 |
| Model B: race joint Wald χ² | 14.8641 | 14.8641 |
| Model C: weight Wald χ² | 3.6865 | 3.6865 |
| Model C: HbA1c Wald χ² | 24.7005 | 24.7005 |
| Model C: race joint Wald χ² | 2.1992 | 2.1992 |
| Model C: weight × race Wald χ² | 0.8764 | 0.8764 |
| Model C: HbA1c × race Wald χ² | 2.7154 | 2.7154 |

## Notes on comparing the results

- **Contrast scale and reference category matter.** Matching the SAS contrast weights and relevant logistic-model reference category resolves differences in how otherwise equivalent results are displayed.

**Scope:** The table summarizes results confirmed to match at the original report's precision; it does **not** claim that every coefficient or diagnostic output is identical. The original report remains unchanged.

**Reproducibility:** These are aggregated results from the private original-data run, **not** from the synthetic demonstration dataset. Original individual-level course data and private logs are not published. See the [Stata source code](code/01_BIOS509_Stata_Analysis.do), [aggregate results CSV](results/verified_aggregate_results.csv), and [replication instructions](README.md).
