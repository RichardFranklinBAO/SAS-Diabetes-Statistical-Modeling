* Execute from Stata_Replication directory; PRIVATE APPROVED DATA ONLY.
* Place authorized original CSV locally at data/project2025_full_data.csv.
* Never commit the original CSV or resulting private data logs.
version 16.0
global BIOS509_INPUT "data/project2025_full_data.csv"
global BIOS509_LABEL "original_private"
capture confirm file "$BIOS509_INPUT"
if _rc {
    display as error "Private original file absent. Use run_synthetic.do instead."
    exit 601
}
do "code/01_BIOS509_Stata_Analysis.do"
