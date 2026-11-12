# SAS–Stata Cross-Software Results and Statistical Audit

**Basis:** Original 2025 jointly authored BIOS 509 SAS report; independently implemented Stata version (2026) successfully executed using the **same 487-row course dataset** on macOS Stata on **November 2026**. This page reports **aggregate results from the private original-data run, not the synthetic demo**. No original observations are published.

## Matched results

| Metric | Original SAS report | Stata (same original data) | Interpretation |
| --- | ---: | ---: | --- |
| Analyzed N | 487 | 487 | Exact |
| High glucose (gluc > 150) N | 204 | 204 | Exact; 204/487 = 41.89% |
| Group ANOVA F(3,483) | 7.11 | 7.1074541 | Matches display precision |
| Planned contrast (1,−1,−1,1) | −18.62 | −18.6207996 | Matches display precision |
| Model B race joint Wald χ²(3) | 14.8641 | 14.864086 | Matches display precision |
| Model C wtkg main effect Wald χ²(1) | 3.6865 | 3.6865424 | Matches display precision |
| Model C HbA1c main effect Wald χ²(1) | 24.7005 | 24.700513 | Matches display precision |
| Model C race joint Wald χ²(3) | 2.1992 | 2.1992458 | Matches display precision |
| Model C wtkg × race joint Wald χ²(3) | 0.8764 | 0.87641752 | Matches display precision |
| Model C HbA1c × race joint Wald χ²(3) | 2.7154 | 2.7154157 | Matches display precision |
| Model C −2log L | 424.705 | 424.7051 | Matches display precision |

## What the apparent disagreements mean

**Wald vs LR:** SAS report values 14.8641 and 0.8764 correspond to joint **Wald** statistics (Model B race block and Model C wtkg × race block), *not* nested-model likelihood-ratio tests. Correct actual nested LR statistics on the same 487 records are:

| LR comparison | χ² | df | p |
| --- | ---: | ---: | ---: |
| Model A to B | 16.137332 | 3 | 0.00106278 |
| Model B to C | 4.0339426 | 6 | 0.6720829 |

Model A includes wtkg + hba1c; Model B adds the three race indicators (Pacific Islander reference); Model C adds six race interaction slopes. Model C uses Asian reference for its reported main-effect Wald tests: changing base categories does not change likelihood.

**Scheffé:** SAS report pairwise p-values align with **unadjusted** pairwise t-tests although labeled Scheffé. For Black vs White the unadjusted p ≈ 0.00987 and properly Scheffé-adjusted p ≈ 0.08312. Stata produces and labels both.

**Contrast:** SAS report uses (1,−1,−1,1) and produces −18.6208. Equal-group average coefficients (0.5,−0.5,−0.5,0.5) produce −9.3104. They differ by a factor of two with identical t-statistics.

**Remaining limitations:** Small Model A coefficient discrepancies versus the printed report were not forced to match; SAS prose mentions 490 records read vs 487 analyzed. Native Stata Shapiro–Wilk results differ slightly from SAS implementation. The originally published SAS individual-influence plots have not been proven numerically identical to the Stata diagnostics. These discrepancies should be disclosed, not hidden.

## Data access and execution scope

The original individual-level course dataset, private local Stata logs, and original-data figures are **not redistributed**. [Selected aggregate metrics](results/verified_aggregate_results.csv) are published for inspection; the public [synthetic runner](run_synthetic.do) is for execution demonstration and does not reproduce these original-data numbers. The newly packaged public runner has not yet been separately tested in a real Stata environment.
