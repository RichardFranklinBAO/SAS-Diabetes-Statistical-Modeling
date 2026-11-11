# Diabetes Glucose Modeling in SAS — BIOS 509

Original course project by **Xian Wu and Conglin Bao** | Emory University

## Research questions

1. Do average fasting blood-glucose levels differ across four groups? Use one-way ANOVA, Scheffé multiple comparisons, a planned contrast, and residual diagnostics.
2. Are weight and HbA1c associated with high blood glucose (threshold >150 mg/dL), and do intercepts or slopes differ among groups? Use nested logistic models, likelihood-ratio tests, and influence diagnostics.

The 26-page original report analyzes **487** patients for a BIOS 509 class assignment. The full original report is preserved under [`outputs/BIOS509_Final_Course_Report_Wu_Bao.pdf`](outputs/BIOS509_Final_Course_Report_Wu_Bao.pdf).

## Skills demonstrated

| Research task | SAS tools | Evidence |
| --- | --- | --- |
| Data loading and validation | `PROC IMPORT`, `PROC CONTENTS`, `PROC FREQ`, `PROC MEANS` | `code/` |
| Group-level inference | `PROC GLM`, `ESTIMATE`, Scheffé contrasts | Report §4.1 and appendix |
| Distribution checking | `PROC UNIVARIATE`, plots, Shapiro–Wilk | Report appendix |
| Predictive modeling | `PROC LOGISTIC`, interaction specifications | Report §4.2 |
| Model comparison | Nested-model log-likelihood comparison | Report §4.2 |
| Diagnostics | Influence diagnostics, fitted values, residuals | Report figures and appendices |
| Reporting | Technical write-up, output figures, interpretation | Final report |

## Repository structure

```text
BIOS509_SAS_Diabetes_Research_Project/
├── code/
│   ├── original_coursework.sas          # original provided SAS source
│   ├── run_synthetic_demo.sas          # later reconstruction for public synthetic demo
│   ├── generate_synthetic_data.py     # reproducible synthetic CSV generator
│   └── verify_demo_data.py            # no-SAS data integrity checks
├── data/
│   ├── synthetic_diabetes_demo.csv     # simulated observations, not patients
│   └── DATA_DICTIONARY.md
└── outputs/
    ├── BIOS509_Final_Course_Report_Wu_Bao.pdf   # original group report
    ├── synthetic_demo_summary.csv      # Python-generated sample overview, not SAS results
    └── README.md
```

## How to run the public SAS demonstration

1. Download the repository, then open `code/run_synthetic_demo.sas` in SAS Studio or another SAS 9.4/Viya-compatible session.
2. Change **one** configuration variable at the top: `PROJECT_DIR`, to the absolute path of this `BIOS509_SAS_Diabetes_Research_Project` folder **as seen by SAS**. For SAS Studio, upload the folder to a location accessible to the SAS server.
3. Run the program. It reads `data/synthetic_diabetes_demo.csv` and writes a PDF of **synthetic-data** procedure output to `outputs/BIOS509_Synthetic_Demo_SAS_Output.pdf`.
4. For a no-SAS integrity check, run `python3 code/verify_demo_data.py`. To regenerate the synthetic dataset, run `python3 code/generate_synthetic_data.py`.

SAS software is required for the SAS program; **it is not bundled**. The original file has a historic Emory SAS Studio path and is included for transparency, not as a turnkey script.

## Results and interpretation

The **original course report** contains full analyses and visual exhibits, including ANOVA (reported F=7.11, p=0.0001), Scheffé comparisons, three logistic specifications, and influence checks. **These values are sourced from the original written report, not regenerated here.** The synthetic demo is a methodological demonstration and should not be compared numerically with the report.

## Reproducibility and limitations

- `original_coursework.sas` is the original supplied script. It does **not** contain every final nested logistic regression from the written report. `run_synthetic_demo.sas` is a *new, independently reconstructed* executable workflow guided by that report; it is not presented as original authorship of previously missing code.
- A SAS executable is unavailable in this packaging environment, so the reconstructed SAS script is **not claimed to have been executed**. The synthetic CSV generator and integrity checks have been run and validated using Python.
- The original dataset contains row-level health measurements and has **not** been added to GitHub. The repository is designed to remain safe if made public. Public availability of the course report should be confirmed against course/institution sharing rules before changing repository visibility.
- The original report has some numerical/textual inconsistencies; the archived PDF is not silently revised. For example, an OR of 12.37 is a >12-fold odds multiplier, not a 20% increase.
- This class assignment is cross-sectional, observational and not intended to establish causality or clinical screening recommendations.

## Academic attribution

**Original course project and report:** Xian Wu and Conglin Bao. **Portfolio packaging and reconstructed demo:** prepared subsequently for transparent technical presentation.
