/*
  BIOS 509 | PUBLIC SYNTHETIC-DATA SAS ANALYSIS DEMONSTRATION
  Original course project authors: Xian Wu and Conglin Bao
  This is a LATER RECONSTRUCTION guided by the course report; it is NOT
  represented as the complete original coursework source.
  Input is strictly synthetic; never use this script to publish clinical data.

  1) Upload the entire BIOS509_SAS_Diabetes_Research_Project folder to a
     filesystem accessible to your SAS server (SAS Studio users: server path).
  2) Set PROJECT_DIR to its absolute path, WITHOUT a trailing slash.
  3) Run this program. Synthetic SAS results will be written under outputs/.
*/

%let PROJECT_DIR=/YOUR/ABSOLUTE/PATH/BIOS509_SAS_Diabetes_Research_Project;
%let INPUT_CSV=&PROJECT_DIR./data/synthetic_diabetes_demo.csv;
%let OUTPUT_PDF=&PROJECT_DIR./outputs/BIOS509_Synthetic_Demo_SAS_Output.pdf;

/* Fail clearly rather than silently generating an empty analysis. */
%macro preflight;
  %if not %sysfunc(fileexist(%superq(INPUT_CSV))) %then %do;
    %put ERROR: Synthetic CSV not found at &INPUT_CSV.;
    %put ERROR: Edit PROJECT_DIR in code/run_synthetic_demo.sas.;
    %abort cancel;
  %end;
%mend;
%preflight;

proc import datafile="&INPUT_CSV" out=work.diabetes dbms=csv replace;
  guessingrows=max; getnames=yes;
run;

data work.diabetes;
  set work.diabetes;
  high_glucose = (gluc > 150);
run;

title "BIOS 509 — synthetic teaching-data SAS demonstration (NOT course results)";
ods graphics on;
ods pdf file="&OUTPUT_PDF" style=journal;

/* 1. Quality checks and descriptive statistics */
proc contents data=work.diabetes; run;
proc freq data=work.diabetes; tables race high_glucose race*high_glucose; run;
proc means data=work.diabetes n mean std min max; var gluc wtkg hba1c; run;
proc sort data=work.diabetes; by race; run;
proc means data=work.diabetes n mean std min max; by race; var gluc wtkg hba1c; run;

/* 2. One-way ANOVA and a prespecified group contrast */
proc glm data=work.diabetes plots=diagnostics;
  class race;
  model gluc = race;
  means race / scheffe;
  /* Contrast: average(groups 1 & 4) vs average(groups 2 & 3). */
  estimate 'Mean groups 1+4 minus 2+3' race 0.5 -0.5 -0.5 0.5;
run; quit;

/* Normality tests by group — exploratory diagnostics. */
proc univariate data=work.diabetes normal;
  by race;
  var gluc;
  histogram gluc / normal;
run;

/* 3. High glucose modeling, as described in the final course report. */
/* Model A: pooled effects */
proc logistic data=work.diabetes;
  model high_glucose(event='1') = wtkg hba1c;
  title2 'Model A: pooled logistic regression';
run;

/* Model B: group-specific intercepts, same slopes */
proc logistic data=work.diabetes;
  class race (ref='3') / param=ref;
  model high_glucose(event='1') = wtkg hba1c race / influence;
  title2 'Model B: group intercepts and pooled slopes';
run;

/* Model C: slope interactions by race */
proc logistic data=work.diabetes;
  class race (ref='3') / param=ref;
  model high_glucose(event='1') = wtkg hba1c race
                               wtkg*race hba1c*race;
  title2 'Model C: group-by-predictor interactions';
run;

/* Model comparison: SAS fit tables show -2 Log L for each nested model.
   Likelihood ratio test is computed from differences between successive
   -2 Log L statistics, using the corresponding change in model degrees
   of freedom (A->B 3 df; B->C 6 df). Do not assume the course report
   and synthetic demo necessarily agree. */

/* 4. Optional logistic models by group for diagnostics */
%macro logistic_group(group_id);
proc logistic data=work.diabetes;
  where race=&group_id;
  model high_glucose(event='1')=wtkg hba1c / influence;
  title2 "Within-group logistic model: race=&group_id";
run;
%mend;
%logistic_group(1);
%logistic_group(2);
%logistic_group(3);
%logistic_group(4);

ods pdf close;
ods graphics off;
title;
%put NOTE: Synthetic SAS report expected at &OUTPUT_PDF.;
