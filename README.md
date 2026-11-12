# SAS Statistical Research Portfolio | BIOS 509

**Emory University · BIOS 509 · SAS/STAT**  
**Original group project and final report:** Conglin Bao and Xian Wu

A course-based statistical research project investigating glucose levels and associated predictors, presented with **one consolidated SAS analysis script**, a clearly labeled synthetic demonstration dataset, and the **28-page reformatted course report**.

## Independent Stata replication (2026)

Following the original BIOS 509 course project, **I independently reimplemented the statistical workflow in Stata 19** and verified key results against the SAS report using the same 487-record course dataset in a private local analysis. This Stata replication is a **subsequent individual project**; the original jointly authored SAS materials remain unchanged.

| Stata resource | Description |
| --- | --- |
| **[Replication guide](Stata_Replication/README.md)** | Code structure, data policy, and run instructions |
| [Stata analysis source](Stata_Replication/code/01_BIOS509_Stata_Analysis.do) | ANOVA, contrasts, Scheffé tests, logistic models, diagnostics, Wald/LR tests, and output export |
| [Public synthetic-data runner](Stata_Replication/run_synthetic.do) | Reuses the repository's existing synthetic CSV |
| **[SAS–Stata replication results](Stata_Replication/RESULTS_COMPARISON.md)** | Original-data results comparison and technical notes |
| [Aggregate validation results (CSV)](Stata_Replication/results/verified_aggregate_results.csv) | Selected statistical results from the local original-data run |

**Successful SAS–Stata replication (November 13, 2026):** Using the same 487-observation course dataset and equivalent statistical models and tests, the independent Stata implementation **reproduced the original SAS report's key numerical results to the reported precision**. Examples include ANOVA F = 7.1075 (SAS: 7.11), planned contrast = −18.6208 (SAS: −18.62), Model B joint Wald χ² = 14.8641, and Model C weight-by-group joint Wald χ² = 0.8764. Full results, including test definitions and remaining software/reporting differences, are available in the [replication comparison](Stata_Replication/RESULTS_COMPARISON.md).

**Reproducibility scope:** Original individual-level data, private run logs, and original-data diagnostic plots are excluded. Public synthetic-data results will not equal the original report's numbers. The original course report and SAS code have not been rewritten.

## Explore the research

| Item | Direct link | Contents |
| --- | --- | --- |
| **Final research report (PDF)** | **[View the 28-page report](BIOS509_SAS_Diabetes_Research_Project/outputs/SAS_Diabetes_Statistical_Analysis.pdf)** | Research questions, methods, ANOVA, logistic regression, statistical tables, diagnostics, discussion |
| Final SAS code | [BIOS509_Diabetes_Analysis_Final.sas](BIOS509_SAS_Diabetes_Research_Project/code/BIOS509_Diabetes_Analysis_Final.sas) | Integrated analysis program, including additions reconstructed after the course submission |
| Synthetic demonstration data | [synthetic_diabetes_demo.csv](BIOS509_SAS_Diabetes_Research_Project/data/synthetic_diabetes_demo.csv) | 487 simulated observations; **not** the original participant dataset |
| Project guide | [Project README](BIOS509_SAS_Diabetes_Research_Project/README.md) | Methodology, directory map, execution instructions, reproducibility limits |
| Data dictionary | [DATA_DICTIONARY.md](BIOS509_SAS_Diabetes_Research_Project/data/DATA_DICTIONARY.md) | Variable definitions and sharing caveats |
| Research outputs | [outputs/](BIOS509_SAS_Diabetes_Research_Project/outputs/) | Final report and status of synthetic SAS output |

## SAS skills demonstrated

- Data import, variable validation and descriptive statistics: `PROC IMPORT`, `PROC FREQ`, `PROC MEANS`, `PROC TABULATE`
- Group comparisons: one-way ANOVA, Scheffé-adjusted comparisons, planned contrasts (`PROC GLM`)
- Diagnostics: residual distributions, Shapiro–Wilk checks and regression influence analysis (`PROC UNIVARIATE`, `PROC REG`)
- Binary outcome modeling: nested logistic regression, interaction specifications, likelihood-ratio comparisons and influence analysis (`PROC LOGISTIC`, `PROC SQL`)
- Technical reporting: a jointly authored 28-page reformatted course report with tables, figures and interpretation

## Provenance and reproducibility

The original patient-level course dataset is excluded. The synthetic dataset is for demonstrating program structure, so its numerical results will not match the original course report.

The linked 28-page PDF preserves the research content and findings of the original jointly authored coursework report but has a redesigned cover, page numbering, and removal of a redundant heading. It is a presentation-formatted version, not a byte-for-byte copy of the originally submitted file.

See the [project guide](BIOS509_SAS_Diabetes_Research_Project/README.md) for run instructions and limitations.
