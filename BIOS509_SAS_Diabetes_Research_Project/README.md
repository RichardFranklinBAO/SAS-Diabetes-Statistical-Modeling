# BIOS 509 — Diabetes Glucose Modeling with SAS

**Original course project and report:** Conglin Bao and Xian Wu · Emory University

**[Read the original final report (PDF, 26 pages)](outputs/SAS_Diabetes_Statistical_Analysis.pdf)**

## Research questions

1. Do mean glucose levels differ across four groups? Evaluate using one-way ANOVA, Scheffé post-hoc comparisons, a prespecified contrast, and residual/influence diagnostics.
2. How are body weight and HbA1c associated with glucose above 150 mg/dL? Compare nested logistic regressions with group-level intercept effects and slope interactions.

## Repository structure

```text
BIOS509_SAS_Diabetes_Research_Project/
├── README.md
├── code/
│   └── BIOS509_Diabetes_Analysis_Final.sas
├── data/
│   ├── synthetic_diabetes_demo.csv
│   └── DATA_DICTIONARY.md
└── outputs/
    ├── SAS_Diabetes_Statistical_Analysis.pdf
    └── README.md
```

## Research materials

- **[Final course report](outputs/SAS_Diabetes_Statistical_Analysis.pdf)** — actual group report including model specifications, results, and diagnostics.
- **[One final SAS program](code/BIOS509_Diabetes_Analysis_Final.sas)** — organized program with statistical procedures.
- **[Synthetic example dataset](data/synthetic_diabetes_demo.csv)** — 487 simulated records, intended to illustrate the workflow, not reproduce course estimates.
- **[Data dictionary](data/DATA_DICTIONARY.md)** — inputs, variable descriptions, and safe-sharing notes.
- **[Outputs guide](outputs/README.md)** — which PDF is archived and which output remains unverified.

## SAS methods represented

| Area | SAS procedures / analysis |
| --- | --- |
| Data import and checks | `PROC IMPORT`, `PROC CONTENTS`, `PROC FREQ`, `PROC MEANS` |
| Summary tables | `PROC TABULATE` |
| ANOVA and group contrasts | `PROC GLM`, Scheffé adjusted comparisons, `ESTIMATE` |
| Residual and normality checks | `PROC UNIVARIATE`, histogram, QQ plot |
| Influence diagnostics | `PROC REG`, regression residuals, leverage, Cook's D, DFFITS |
| Binary outcomes | `PROC LOGISTIC`, three nested specifications and group interactions |
| Model comparisons | Fit statistics, `PROC SQL` extraction, likelihood-ratio calculations |
| Presentation | SAS ODS configured to produce an analysis PDF; original technical report linked above |

## Run the consolidated SAS script

1. Open [`code/BIOS509_Diabetes_Analysis_Final.sas`](code/BIOS509_Diabetes_Analysis_Final.sas) in **SAS Studio, SAS 9.4 or SAS Viya**, with SAS/STAT available.
2. Edit `PROJECT_DIR` at the top so it points to the absolute directory containing `code/`, `data/`, and `outputs/`, as seen by the SAS execution server. Avoid a trailing slash.
3. Run the program. It reads `data/synthetic_diabetes_demo.csv` and is configured to write `outputs/BIOS509_Synthetic_SAS_Results.pdf`.
4. Examine the SAS log and procedure output for errors. 
5. If separately authorized to analyze the original course dataset, point `INPUT_CSV` to its **local approved location**. Never commit individual-level patient data.

## Research provenance and limitations

- The course report was jointly authored by **Conglin Bao and Xian Wu**. Its findings and numerical results concern the **original 487-record course dataset**, which is not uploaded.
- The accompanying synthetic CSV is unrelated to the original patient records and **cannot reproduce** numerical findings in the final report.
- The report is preserved as provided, including any original inconsistencies; no results are silently rewritten. This observational classroom exercise is not clinical guidance.
