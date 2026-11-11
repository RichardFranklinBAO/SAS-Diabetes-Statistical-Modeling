/* ============================================================================
  BIOS 509 | Diabetes Glucose Statistical Analysis | FINAL CONSOLIDATED SCRIPT
  Original 2025 course project and report: Xian Wu and Conglin Bao
  Portfolio edition: consolidates original coursework analysis and additional
  logistic-model specifications reconstructed from the submitted report.

  IMPORTANT PROVENANCE:
    - This is a cleaned, consolidated PORTFOLIO script, not a verbatim copy of
      the SAS program originally submitted for the course.
    - The repository includes SYNTHETIC demo observations only.
    - Historical report results used the restricted original course dataset;
      synthetic observations cannot reproduce those values.
    - Use original data only with proper access/authorization; never upload
      participant records to GitHub.

  TO RUN: Set PROJECT_DIR to absolute folder containing code/, data/, outputs/
  AS SEEN BY YOUR SAS EXECUTION SERVER. No trailing slash. Requires SAS/STAT.
  ============================================================================ */

%let PROJECT_DIR=/CHANGE/TO/BIOS509_SAS_Diabetes_Research_Project;
%let INPUT_CSV=&PROJECT_DIR./data/synthetic_diabetes_demo.csv;
%let RESULT_PDF=&PROJECT_DIR./outputs/BIOS509_Synthetic_SAS_Results.pdf;

%macro check_input;
  %if not %sysfunc(fileexist(%superq(INPUT_CSV))) %then %do;
    %put ERROR: Cannot find &INPUT_CSV.;
    %put ERROR: Set PROJECT_DIR to a directory visible from the SAS server.;
    %abort cancel;
  %end;
%mend check_input;
%check_input;

/* 1. Import, recode and check required variables */
proc import datafile="&INPUT_CSV" out=work.diabetes_raw dbms=csv replace;
  guessingrows=max;
  getnames=yes;
run;

data work.diabetes;
  set work.diabetes_raw;
  if missing(race) or missing(gluc) or missing(wtkg) or missing(hba1c)
     then delete;
  if race not in (1,2,3,4) then delete;
  if wtkg <= 0 or hba1c <= 0 or gluc <= 0 then delete;
  high_glucose = (gluc > 150);
  label high_glucose='Glucose above 150 mg/dL';
run;

ods graphics on;
ods pdf file="&RESULT_PDF" style=journal;
title1 'BIOS 509 SAS statistical analysis';
title2 'Synthetic data demonstration — NOT original course results';

proc contents data=work.diabetes; run;
proc freq data=work.diabetes;
  tables race high_glucose race*high_glucose / missing;
run;
proc means data=work.diabetes n mean std min max;
  var gluc wtkg hba1c;
run;
proc sort data=work.diabetes out=work.by_race;
  by race;
run;
proc means data=work.by_race n mean std min max;
  by race;
  var gluc wtkg hba1c;
run;
proc tabulate data=work.diabetes;
  class race;
  var gluc;
  table race all, gluc*(n mean std var min max);
run;

/* 2. Question 1: ANOVA, Scheffé, and a planned group contrast */
title3 'Q1: One-way ANOVA of glucose across four groups';
proc glm data=work.diabetes;
  class race;
  model gluc = race / solution;
  means race / scheffe cldiff;
  /* mean(groups 1 & 4) minus mean(groups 2 & 3), ordered 1..4 */
  estimate 'Mean groups 1 & 4 minus groups 2 & 3' race 0.5 -0.5 -0.5 0.5;
  output out=work.anova_diagnostics p=pred_gluc r=anova_residual;
run;
quit;

/* Residual diagnostics and Shapiro–Wilk normality checks by group */
proc sort data=work.anova_diagnostics;
  by race;
run;
proc univariate data=work.anova_diagnostics normal;
  by race;
  var anova_residual;
  histogram anova_residual / normal;
  qqplot anova_residual / normal(mu=est sigma=est);
run;

/* Group-wise intercept-only regression influence diagnostics */
%macro group_diagnostics(group_id);
  title3 "Q1: Regression influence diagnostics for race=&group_id";
  proc reg data=work.diabetes;
    where race=&group_id;
    model gluc = / influence;
    output out=work.regdiag_&group_id
      p=fitted_glucose r=residual h=leverage cookd=cooks dffits=dffits;
  run;
  quit;
%mend group_diagnostics;
%group_diagnostics(1);
%group_diagnostics(2);
%group_diagnostics(3);
%group_diagnostics(4);

/* 3. Question 2: nested logistic models */
title3 'Q2: Model A — weight and HbA1c';
ods output FitStatistics=work.fit_a;
proc logistic data=work.diabetes;
  model high_glucose(event='1') = wtkg hba1c / clodds=wald;
run;

title3 'Q2: Model B — group-specific intercepts';
ods output FitStatistics=work.fit_b;
proc logistic data=work.diabetes;
  class race (ref='3') / param=ref;
  model high_glucose(event='1') = wtkg hba1c race / clodds=wald influence;
run;

title3 'Q2: Model C — interactions with race';
ods output FitStatistics=work.fit_c;
proc logistic data=work.diabetes;
  class race (ref='3') / param=ref;
  model high_glucose(event='1') = wtkg hba1c race
                                     wtkg*race hba1c*race / clodds=wald;
run;

/* A->B adds 3 class indicators; B->C adds 6 interaction coefficients.
   Extract -2 Log L values from SAS/STAT PROC LOGISTIC FitStatistics table. */
%let dev_a=;
%let dev_b=;
%let dev_c=;
proc sql noprint;
  select InterceptAndCovariates into :dev_a trimmed
    from work.fit_a where Criterion='-2 Log L';
  select InterceptAndCovariates into :dev_b trimmed
    from work.fit_b where Criterion='-2 Log L';
  select InterceptAndCovariates into :dev_c trimmed
    from work.fit_c where Criterion='-2 Log L';
quit;

%macro lrt_table;
  %if %length(%superq(dev_a)) > 0 and
      %length(%superq(dev_b)) > 0 and
      %length(%superq(dev_c)) > 0 %then %do;
    data work.nested_lrt;
      length model_comparison $12;
      model_comparison='A vs B'; df=3;
      lr_stat=&dev_a - &dev_b;
      p_value=1-probchi(max(lr_stat,0),df);
      output;
      model_comparison='B vs C'; df=6;
      lr_stat=&dev_b - &dev_c;
      p_value=1-probchi(max(lr_stat,0),df);
      output;
    run;
    title3 'Q2: Nested logistic model likelihood-ratio tests';
    proc print data=work.nested_lrt noobs label;
      var model_comparison df lr_stat p_value;
      format lr_stat 10.4 p_value pvalue6.4;
      label model_comparison='Model comparison'
            lr_stat='Likelihood ratio chi-square'
            p_value='p-value';
    run;
  %end;
  %else %do;
    %put WARNING: Missing PROC LOGISTIC FitStatistics; inspect SAS log.;
  %end;
%mend lrt_table;
%lrt_table;

/* 4. By-group logistic influence checks as in original coursework */
%macro group_logistic(group_id);
  title3 "Q2: Logistic influence diagnostics for race=&group_id";
  proc logistic data=work.diabetes;
    where race=&group_id;
    model high_glucose(event='1') = wtkg hba1c / influence;
  run;
%mend group_logistic;
%group_logistic(1);
%group_logistic(2);
%group_logistic(3);
%group_logistic(4);

title;
ods pdf close;
ods graphics off;
%put NOTE: SAS analysis PDF written to &RESULT_PDF.;
%put NOTE: Public dataset is synthetic, not the original report dataset.;
