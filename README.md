## Data-quality-tools
These are system  and database scripts that check resource links and data base integrity.

### Resource Data Quality Check Script

This is a post harvest automated QC tool

Script: DataQuality.sh
Checks by header

Checks each active resource in the ckan_default database- resource, resource_group table by using the curl header.

CURL Timeout - 5 seconds 

Writes to the ngds_resource_quality table results of the lookup, saves status, returned_location, and length

Command line with log:  

nohup /usr/sbin/DataQuality.sh >> /var/log/dq.log 2>&1 &

###Help 
DataQuality - performs a check on resource links in the NGDS CKAN Database   
              This uses the curl header option to check the status of links  
             and saves the results in a database table ngds_resource_qualty.  

Synopsis:  DataQuality -l --limit [#]  -o --offset [#] -w -p  
    -l,--limit    Set the maximum number of resource links to be checked  
    -o,--offset   Set the starting record of resource link to be checked  
    -w,--webservice        Check WMS and WFS records  
    -p,--primaryresource   Check primary dataset resource record"  

### SQL Tools

#### Clear Harvest
Occasionally the Clear Button in the HArvest Admin stops functioning, usually caused by some tables getting to large, or when database maintenance has not been performed on affected tables. Clear harvest SQl allows you to perform steps individually.

### Duplicate Datasets

Duplicated data can take a several forms.  During the harvest process, there are conditions that allow duplicate data to be saved.  Checcks are made for duplicate GUIDS in the harvest, in the package (as found in package_extra)

### Resource Link Quality Reports

Detailed and summary reports for the DataQuality check (resource links)


