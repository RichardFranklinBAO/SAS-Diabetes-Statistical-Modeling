/* BIOS 509: independent SAS-to-Stata replication, 2026.
   Stata >= 16; public runner uses synthetic demo data.
   Original patient-level dataset and logs are not distributed.
   Both correctly labeled Wald and LR tests are reported.
*/
version 16.0
clear all
set more off
set linesize 140
if "$BIOS509_INPUT" == "" {
    display as error "Use run_synthetic.do or run_local_original.do"
    exit 198
}
if "$BIOS509_LABEL" == "" {
    display as error "Missing BIOS509_LABEL"
    exit 198
}
local mode "$BIOS509_LABEL"
local infile "$BIOS509_INPUT"
capture mkdir "results"
capture log close _all
log using "results/BIOS509_`mode'.log", text replace
display as text "=== BIOS509 STATA ANALYSIS: `mode' ==="
display as text "Input: `infile'"
import delimited using "`infile'", varnames(1) clear
foreach v in id race wtkg gluc hba1c {
    confirm numeric variable `v'
    assert !missing(`v')
}
isid id
count
local total_n=r(N)
assert `total_n' == 487
assert inlist(race,1,2,3,4)
assert wtkg > 0 & gluc > 0 & hba1c > 0
label define race_labels 1 "White" 2 "Black" 3 "Pacific Islander" 4 "Asian"
label values race race_labels
generate byte high_glucose=gluc>150
label variable high_glucose "Glucose strictly above 150 mg/dL"
count if high_glucose==1
local high_n=r(N)
tempname ph
postfile `ph' str55 metric double value using "results/BIOS509_`mode'_metrics.dta", replace
post `ph' ("total_N") (`total_n')
post `ph' ("glucose_gt_150_N") (`high_n')
post `ph' ("glucose_gt_150_pct") (100*`high_n'/`total_n')

* S1. Descriptive statistics and QC.
display as text "=== S1: DESCRIPTIVES ==="
codebook id race wtkg gluc hba1c high_glucose
tabulate race high_glucose, row
summarize gluc wtkg hba1c, detail
tabstat gluc wtkg hba1c, by(race) statistics(n mean sd min max) columns(statistics)
forvalues g=1/4 {
    quietly count if race==`g'
    local ng=r(N)
    quietly summarize gluc if race==`g'
    local avg=r(mean)
    local sd=r(sd)
    post `ph' ("group`g'_N") (`ng')
    post `ph' ("group`g'_glucose_mean") (`avg')
    post `ph' ("group`g'_glucose_sd") (`sd')
}
graph box gluc, over(race) title("Glucose by group") ytitle("Glucose (mg/dL)")
graph export "results/01_glucose_by_group_`mode'.png", replace width(1600)

* S2. ANOVA, separate unadjusted and true Scheffe comparisons.
display as text "=== S2: ANOVA / SCHEFFE / CONTRAST ==="
anova gluc race
post `ph' ("anova_F") (e(F))
post `ph' ("anova_df_model") (e(df_m))
post `ph' ("anova_df_residual") (e(df_r))
post `ph' ("anova_p") (Ftail(e(df_m),e(df_r),e(F)))
display as text "=== S2A: SAS-table UNADJUSTED pairwise p-values ==="
pwcompare race, effects mcompare(noadjust)
display as text "=== S2B: ACTUAL Scheffe-adjusted pairwise p-values ==="
pwcompare race, effects mcompare(scheffe)
regress gluc ibn.race, noconstant
display as text "=== S2C: SAS original-scale contrast ==="
lincom 1*1.race - 1*2.race - 1*3.race + 1*4.race
post `ph' ("contrast_sas_sum") (r(estimate))
post `ph' ("contrast_sas_se") (r(se))
post `ph' ("contrast_sas_t") (r(estimate)/r(se))
post `ph' ("contrast_sas_p") (r(p))
display as text "=== S2D: group-average contrast ==="
lincom 0.5*1.race - 0.5*2.race - 0.5*3.race + 0.5*4.race
post `ph' ("contrast_equal_group_means") (r(estimate))
post `ph' ("contrast_se") (r(se))
post `ph' ("contrast_t") (r(estimate)/r(se))
regress gluc ib3.race
predict double anova_fitted if e(sample), xb
predict double anova_residual if e(sample), residuals
predict double anova_leverage if e(sample), hat
predict double anova_cooksd if e(sample), cooksd
predict double anova_dfits if e(sample), dfits
summarize anova_residual anova_cooksd anova_dfits, detail
rvfplot, yline(0) title("ANOVA residuals vs fitted")
graph export "results/02_anova_residuals_`mode'.png", replace width(1600)
qnorm anova_residual, title("ANOVA residual Q-Q")
graph export "results/03_anova_qq_`mode'.png", replace width(1600)
forvalues g=1/4 {
    display as text "Shapiro-Wilk normality group `g'"
    swilk anova_residual if race==`g'
}
display as text "NOTE: Native Stata and SAS Shapiro-Wilk may differ numerically."

* S3. Logistic models A, B, C; honest Wald vs LR differentiation.
display as text "=== S3: NESTED LOGISTIC MODELS ==="
logit high_glucose c.wtkg c.hba1c
estimates store Model_A
local ll_a=e(ll)
post `ph' ("model_A_ll") (`ll_a')
post `ph' ("model_A_or_wtkg") (exp(_b[wtkg]))
post `ph' ("model_A_or_hba1c") (exp(_b[hba1c]))
estat ic

* Model B race reference = Pacific Islander.
logit high_glucose c.wtkg c.hba1c ib3.race
estimates store Model_B
local ll_b=e(ll)
post `ph' ("model_B_ll") (`ll_b')
post `ph' ("model_B_or_race2_vs_race3") (exp(_b[2.race]))
estat ic
display as text "=== S3A: true A-to-B LR test ==="
lrtest Model_A Model_B
post `ph' ("lr_A_to_B_chi2") (r(chi2))
post `ph' ("lr_A_to_B_df") (r(df))
post `ph' ("lr_A_to_B_p") (r(p))
estimates restore Model_B
display as text "=== S3B: SAS Model B race joint WALD (not LR) ==="
test (1.race=0) (2.race=0) (4.race=0)
post `ph' ("model_B_wald_race_chi2") (r(chi2))
post `ph' ("model_B_wald_race_df") (r(df))
post `ph' ("model_B_wald_race_p") (r(p))

* Model C race reference = Asian, aligning reported SAS main-effect Wald.
logit high_glucose ib4.race##c.wtkg ib4.race##c.hba1c
estimates store Model_C
local ll_c=e(ll)
post `ph' ("model_C_ll") (`ll_c')
estat ic
display as text "=== S3C: true B-to-C LR test (6 df) ==="
lrtest Model_B Model_C
post `ph' ("lr_B_to_C_chi2") (r(chi2))
post `ph' ("lr_B_to_C_df") (r(df))
post `ph' ("lr_B_to_C_p") (r(p))
estimates restore Model_C
display as text "=== S3D: SAS Model C type-3 Wald tests ==="
test wtkg
post `ph' ("model_C_wald_wtkg_chi2") (r(chi2))
post `ph' ("model_C_wald_wtkg_p") (r(p))
test hba1c
post `ph' ("model_C_wald_hba1c_chi2") (r(chi2))
post `ph' ("model_C_wald_hba1c_p") (r(p))
test (1.race=0) (2.race=0) (3.race=0)
post `ph' ("model_C_wald_race_chi2") (r(chi2))
post `ph' ("model_C_wald_race_p") (r(p))
test (1.race#c.wtkg=0) (2.race#c.wtkg=0) (3.race#c.wtkg=0)
post `ph' ("model_C_wald_wtkg_race_chi2") (r(chi2))
post `ph' ("model_C_wald_wtkg_race_df") (r(df))
post `ph' ("model_C_wald_wtkg_race_p") (r(p))
test (1.race#c.hba1c=0) (2.race#c.hba1c=0) (3.race#c.hba1c=0)
post `ph' ("model_C_wald_hba1c_race_chi2") (r(chi2))
post `ph' ("model_C_wald_hba1c_race_df") (r(df))
post `ph' ("model_C_wald_hba1c_race_p") (r(p))

* S4. Model B postestimation diagnostics and ROC.
estimates restore Model_B
display as text "=== S4: MODEL B PREDICTIONS / ROC ==="
logit, or
margins race
marginsplot, title("Adjusted probability of high glucose") ytitle("Pr(gluc >150)")
graph export "results/04_modelB_adjusted_probs_`mode'.png", replace width(1600)
predict double modelB_pr if e(sample), pr
generate double modelB_pearson=(high_glucose-modelB_pr)/sqrt(modelB_pr*(1-modelB_pr)) if e(sample)
summarize modelB_pr modelB_pearson, detail
lroc, title("Model B ROC")
graph export "results/05_modelB_ROC_`mode'.png", replace width(1600)

* S5. Machine-readable metric output.
display as text "=== S5: METRICS EXPORT ==="
postclose `ph'
preserve
use "results/BIOS509_`mode'_metrics.dta", clear
sort metric
list, noobs abbreviate(30)
export delimited using "results/BIOS509_`mode'_metrics.csv", replace
restore
estimates table Model_A Model_B Model_C, b(%9.4f) se(%9.4f) stats(N ll)
display as result "ANALYSIS FINISHED. Review results log and metrics CSV."
log close
