# SAS Statistical Research Portfolio | BIOS 509

**Emory University · BIOS 509 · SAS/STAT**  
**Original group project and final report:** Conglin Bao and Xian Wu

A course-based statistical research project investigating glucose levels and associated predictors, presented with **one consolidated SAS analysis script**, a clearly labeled synthetic demonstration dataset, and the **original 26-page final report**.

## Explore the research

| Item | Direct link | Contents |
| --- | --- | --- |
| **Final research report (PDF)** | **[View the 26-page report](BIOS509_SAS_Diabetes_Research_Project/outputs/Conglin_Bao_SAS_Diabetes_Statistical_Analysis.pdf)** | Research questions, methods, ANOVA, logistic regression, statistical tables, diagnostics, discussion |
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
- Technical reporting: a jointly authored 26-page course report with tables, figures and interpretation

## Provenance and reproducibility

The original patient-level course dataset is excluded. The synthetic dataset is for demonstrating program structure, so its numerical results will not match the original course report.

See the [project guide](BIOS509_SAS_Diabetes_Research_Project/README.md) for run instructions and limitations.
