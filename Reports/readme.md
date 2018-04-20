
This is an activity log of data checks performed for the FY 18 2nd quarter.

# Data Quality Processing

These data quality tools were executed and analyzed after a complete reharvest of all NGDS harvest sources from in March and early April of 2018.

April 11, 2018 - Initial Data Quality - executed check on static link (pdf, csv, txt, images, etc -- excluding map servers) resource records were process - total of 69466 resource links identified.  Of those initially 4800 were either returning errors or not responding.  
April 12, 2018 - Approximately 8000 reccords from osti.gov, which responded with redirect repsonse (301, 302 normally a good response) were in fact errors. The errors were corrected by script in NGDS (meaning that the source metadata is still in error). 1600 errors remain.

April 12, 2018 - The error code 405 records (Method Not Allowed) and unresponsive records were reprocessed with a longer timeout and more detailed test.  In the 405 records, 1660 responded with a good status, 850 records are identified as bad, they are SMU records with a denied access. Of the 1540 unresponsive records, 400 were shown to be active (typically large PDF that take some time to down load) and 1100 are errors

April 13, 2018 - FTP errors were identified - 517 unresponsive links.  

April 17, 2018 - Map Server Link - There are a total of 2029 map service links, mainly WMS and WFS. Of those 1895 are functioning correctly, with 138 either entirely down or missing layers or feature sets.

Some of the datasets can be programmatically corrected.  These corrections must be reapplied after each harvest. There are a number of  obsolete that will be deleted, and there are several thousand that will require manual update. 

April 20 - Data duplication checks verified that no duplicate GUIDS were uploaded, but that approximate 9500 records (from different sources) have duplicate titles.

