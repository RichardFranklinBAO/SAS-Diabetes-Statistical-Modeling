* Execute from Stata_Replication directory (Stata 16+).
* Public synthetic data from the existing SAS project; not original data.
version 16.0
global BIOS509_INPUT "../BIOS509_SAS_Diabetes_Research_Project/data/synthetic_diabetes_demo.csv"
global BIOS509_LABEL "synthetic_demo"
do "code/01_BIOS509_Stata_Analysis.do"
