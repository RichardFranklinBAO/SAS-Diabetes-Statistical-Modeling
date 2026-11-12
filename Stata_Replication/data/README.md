# Data and permission

This public Stata directory does not contain original observations.

Public run_synthetic.do reuses the existing synthetic diabetes CSV in the sibling BIOS509_SAS_Diabetes_Research_Project/data directory.

Only for users authorized to access the original class data: locally put a file named project2025_full_data.csv in this data folder, with id,race,wtkg,gluc,hba1c columns; then run run_local_original.do. Do not commit the original CSV or any private log / observation-level diagnostics. Existing root .gitignore excludes data/*full_data*.csv.
