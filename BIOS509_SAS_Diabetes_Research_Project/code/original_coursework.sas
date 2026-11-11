proc import datafile="/home/u64046818/509HW/project/project2025_full_data.csv"
    out=one
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 1: Assumption Testing and assessing influence H & GAUSS for ANOVA*/


/* Independence - referring to the email */
/* H - partial plots - fanning in and out pattern */
/* Normality - distribution of Residuals for homrate, S-W test */
/* Multicollinarity - VIF 对于one-way fixed effects ANOVA 没要求 - 但是检测提一下应该没关系 */

/* 回归分析（数据集 ONE）：确保 ods graphics on 前提下使用 plots 选项 */
/* ods graphics on; */
/*  */
/* proc reg data=one plots(unpackpanel); */
/*     model gluc = hba1c wtkg  / partial influence vif; */
/*     plot rstudent.*(hba1c wtkg ); */
/*     output out=out1 residual=resid rstudent=jackres cookd=cooks; */
/* run; */
/* ods graphics off; */
/*  */
/* proc print data=out1; */
/*     title "Regression Diagnostics Output for ONE"; */
/* run; */
/*  */
/* proc univariate data=out1 plot normal; */
/*     var jackres; */
/*     title "Normality Test for Jackknife Residuals (ONE)"; */
/* run; */

/* Testing the group seperately */
%macro reg_by_race(race_val);
   ods output outputstatistics=out_&race_val;
   ods graphics on;
   proc reg data=one plots(unpackpanel);
      where race = &race_val;
      model gluc = / partial influence vif; /* 仅截距模型 */
/*       output out=out_&race_val  */
/*              residual=resid  */
/*              rstudent=jackres  */
/*              cookd=cooks  */
/*              dffits=dffits */
/*              h=leverage; */
/*              dfbetas=dfb0; */
      title "Regression for race = &race_val";
   run;
   ods output close;
   
   proc univariate data=out_&race_val plot normal;
      var residual;
      title "Normality Test for Residuals (ONE) for race = &race_val";
   run;
   
   ods graphics off;
%mend reg_by_race;

%macro assessing_influential(race_val, RoT_DFFITs_largeS, RoT_DFBETAs_largeS);

/* 	proc print data=out_&race_val; */
/* 		where leverage > &RoT_leverage; */
/* 		var id leverage; */
/* 		title "Observations with leverage > &RoT_leverage for Race=&race_val"; */
/* 	run; */

	proc print data=out_&race_val;
		where dffits > &RoT_DFFITs_largeS;
		var Observation dffits;
		title "Observations with DFFITS > &RoT_DFFITs_largeS for Race=&race_val";
	run;
	
	proc print data=out_&race_val;
		where DFB_Intercept > &RoT_DFBETAs_largeS;
		var Observation DFB_Intercept;
		title "Observations with DEBETAS > &RoT_DFBETAs_largeS for Race=&race_val";
	run;
	
	proc print data=out_&race_val;
		where dffits > 1;
		var Observation dffits;
		title "Observations with DFFITS > 1 for Race=&race_val";
	run;
	
	proc print data=out_&race_val;
		where DFB_Intercept > 1;
		var Observation DFB_Intercept;
		title "Observations with DEBETAS > 1 for Race=&race_val";
	run;
	
/* 	proc print data=out_&race_val; */
/* 		where cooks > &RoT_cooks; */
/* 		var id cooks; */
/* 		title "Observations with cooks > &RoT_cooks for Race=&race_val"; */
/* 	run; */
	
%mend assessing_influential;


%reg_by_race(1);  /* Caucasian */
%assessing_influential(1, 0.183, 0.183)
%reg_by_race(2);  /* Black */
%assessing_influential(2, 0.172, 0.172)

%reg_by_race(3);  /* Pacific Islander */
%assessing_influential(3, 0.193, 0.193)
%reg_by_race(4);  /* Asian */
%assessing_influential(4, 0.179, 0.179)








/* Step 2: Setup the environment */
data two;
    set one;
    if gluc > 150 then high_glucose = 1;
    else high_glucose = 0;
run;

/* Step 2.1: For logistic regression, for descriptive statistics */
proc freq data=two;
    tables race;
run;

proc freq data=two;
    tables high_glucose;
run;
proc freq data=two;
    tables high_glucose*race / chisq;
run;


proc means data=two mean std min max n;
    var hba1c wtkg;
run;
proc sort data=two;
   by race;
run;
proc means data=two mean std min max n;
	by race;
    var hba1c wtkg;
run;
















/* Step 2.2: For logistic regression, for assessing influence, the professor says that using the two testing is enough.*/




ods graphics on;
%macro logistic_by_race(race_val);
   proc logistic data=two descending;
      where race = &race_val;
      model high_glucose = hba1c wtkg / influence;
      title1 "Some diagnostics for high_glucose = hba1c wtkg for Race=&race_val";
   run;

   /* 第二次 Logistic 分析，带图形选项 */
   proc logistic data=two descending plots(only label)=(leverage);
      where race = &race_val;
      model high_glucose = hba1c wtkg;
      title1 "Relapse vs. age for high_glucose=&race_val (Leverage plots)";
   run;
/*    	ods graphics off; */
%mend logistic_by_race;

/* 依次对所有 race 组运行 */
%logistic_by_race(1);  /* Race=1 */
%logistic_by_race(2);  /* Race=2 */
%logistic_by_race(3);  /* Race=3 */
%logistic_by_race(4);  /* Race=4 */













/* Step 3: descriptive statistics for one-way fixed effect ANOVA - Q1 */
proc means;
	var gluc;
run;

proc sort;
	by race;

proc means;
	var gluc;
	by race;
run;

proc tabulate data=one;
    class race;
    var gluc;
    table 
        race all, 
        gluc * (n mean std var max min) 
        / misstext=' ';
run;


/* Step 4: Q1_1: assess whether the mean blood glucose level (in mg/dL) differs across the four race/ethnicity groups. */
/* Classical method */ 
proc glm data = one;
	class race;
	model gluc = hba1c wtkg race;
run;


/* Referencing cell coding yields the same results as using classical method.*/
/* Dummy variables for reference cell coding. */
/* data two; set one; */
/* 	group1=0; group2=0; group3=0; group4=0; */
/* 	if race=1 then group1=1; */
/* 	if race=2 then group2=1; */
/* 	if race=3 then group3=1; */
/* 	if race=4 then group4=1; */
/* run; */
/*  */
/* proc sort; */ /*这两行加不加都是一样的 */
/* 	by race; */
/*  */
/* proc reg; */
/* 	model gluc = hba1c wtkg race group2 group3 group4; */
/* title1 'One-way ANOVA using regression formulation'; */
/* title2 ' and reference cell coding'; */
/* run; */

/* Conclusion: H0 is rejected at 5% significance level, indicating that the means are different. */








/* Step 4: Q1_2: */
proc glm data = one;
	class race;
	model gluc = hba1c wtkg race;
	means race / cldiff scheffe;
	
	estimate 'last one' race .5 -.5 -.5 .5;
run;


























































