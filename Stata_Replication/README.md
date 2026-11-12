# BIOS 509 — Independent Stata Replication (2026)

**Independently reimplemented in Stata by Conglin Bao.** The original BIOS 509 SAS course report (2025) was jointly authored by Conglin Bao and Xian Wu. This is a subsequent individual cross-software replication, **not** part of the original course submission.

## What is implemented

Data import and QA; descriptive statistics; one-way ANOVA; true Scheffé-adjusted and unadjusted pairwise comparisons; planned contrasts; residual and influence checks; nested logistic regressions A/B/C; correctly distinguished Wald and LR hypothesis tests; adjusted group probabilities; ROC curve; and machine-readable metrics export. **Stata 16+; no third-party packages.**

## Run the public synthetic example

Download or clone this entire repository. In the Stata **Command** window, navigate to this Stata_Replication directory (replace the placeholder with your actual location):

~~~stata
cd "/path/to/SAS-Diabetes-Statistical-Modeling/Stata_Replication"
do "run_synthetic.do"
~~~

The script reads the **unchanged existing synthetic CSV** in the sibling BIOS509_SAS_Diabetes_Research_Project/data directory, and writes five PNG plots, a Stata log and metrics CSV/DTA into results/. The synthetic dataset contains 487 simulated observations but is not the original course dataset; **its numerical results must not be compared to the original SAS report**.

## Private original-data run (only if authorized)

The underlying analytical specification was run in a real macOS Stata environment on **November 13, 2026** using the original 487-row dataset; its log reached ANALYSIS FINISHED and produced 53 metrics. Its aggregate-only statistics and discrepancies are documented in [RESULTS_COMPARISON.md](RESULTS_COMPARISON.md).

For separately approved local data access, place your own permitted CSV at Stata_Replication/data/project2025_full_data.csv and run the following from Stata_Replication:

~~~stata
do "run_local_original.do"
~~~

The local CSV requires the columns id,race,wtkg,gluc,hba1c. **Do not upload this individual-level data, private logs, or original-data diagnostic plots.** Public users without the private dataset can inspect the code and execute the synthetic demonstration, but cannot reproduce the original-data numeric results. The newly reorganized public synthetic runner has not yet been separately tested in a live Stata installation.

## Files

| Path | Purpose |
| --- | --- |
| [code/01_BIOS509_Stata_Analysis.do](code/01_BIOS509_Stata_Analysis.do) | Main Stata code with same statistical specification as private v2 validation |
| [run_synthetic.do](run_synthetic.do) | Public demonstration; existing synthetic data |
| [run_local_original.do](run_local_original.do) | Optional local/private workflow |
| [RESULTS_COMPARISON.md](RESULTS_COMPARISON.md) | SAS vs Stata audit including limitations |
| [results/verified_aggregate_results.csv](results/verified_aggregate_results.csv) | Selected aggregate results, original course data (not synthetic) |
| [results/README.md](results/README.md) | Generated output conventions |
| [data/README.md](data/README.md) | Data privacy and provenance |

The original PDF remains [in the original SAS project](../BIOS509_SAS_Diabetes_Research_Project/outputs/SAS_Diabetes_Statistical_Analysis.pdf). The course report is not medical guidance.
