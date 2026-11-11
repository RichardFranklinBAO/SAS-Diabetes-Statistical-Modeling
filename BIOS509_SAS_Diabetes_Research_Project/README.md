# BIOS 509 — Diabetes Glucose Modeling with SAS

**Emory University · BIOS 509**  
**Original report and project:** Xian Wu and Conglin Bao

## Research questions

1. Does glucose vary by group? One-way ANOVA, Scheffé post-hoc comparisons, prespecified contrast, residual and influence diagnostics.
2. Are weight and HbA1c associated with glucose above 150 mg/dL? Compare three nested logistic models with group-specific intercepts and interactions.

## Simplified structure

```text
BIOS509_SAS_Diabetes_Research_Project/
├── README.md
├── code/
│   └── BIOS509_Diabetes_Analysis_Final.sas
├── data/
│   ├── synthetic_diabetes_demo.csv
│   └── DATA_DICTIONARY.md
└── outputs/
    ├── BIOS509_Final_Course_Report_Wu_Bao.pdf
    └── README.md
```

## Run

1. Open [the single final SAS program](code/BIOS509_Diabetes_Analysis_Final.sas) in SAS Studio, SAS 9.4 or SAS Viya (SAS/STAT required).
2. Set `PROJECT_DIR` near the top to the absolute path of this project folder **as seen by the SAS server**. Do not include a trailing slash.
3. Run the entire program. It reads [the included synthetic CSV](data/synthetic_diabetes_demo.csv) and is configured to generate `outputs/BIOS509_Synthetic_SAS_Results.pdf`. This generated PDF has not been included, because SAS runtime has not been verified here.
4. For authorized analyses of original data, change `INPUT_CSV` locally to an approved file location. Do not upload restricted course records.

## Skills

`PROC IMPORT`, `PROC FREQ`, `PROC MEANS`, `PROC TABULATE`, `PROC GLM`, `PROC UNIVARIATE`, `PROC REG`, `PROC LOGISTIC`, `PROC SQL`, SAS ODS reporting, diagnostics, model comparison and documentation.

## Final report and provenance

The original 26-page jointly authored coursework report is in [outputs/](outputs/BIOS509_Final_Course_Report_Wu_Bao.pdf). **Its PDF still needs manual upload to GitHub**; it is included in the downloadable ZIP.

The initial course source contained ANOVA, regression diagnostics and parts of the logistic analysis but did not contain every logistic specification described in the report. This is a **later consolidated portfolio script**, including reconstructed material drawn from the report; it is not an untouched version of the 2025 submission. Only synthetic observations are distributed. They do **not** reproduce the original report's statistical results.

**Verification:** CSV structure/row count and corresponding model specifications have been independently checked; full SAS execution has not occurred here. The report is preserved as originally provided and its figures/results have not been silently revised. Public posting of course material should follow the relevant course/institution policy. This is a course exercise, not clinical guidance.
