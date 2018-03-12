# data-quality-tools
These are system level scripts that check resource links and data base integrity

### Resource Data Quality Check Script

This is a post harvest automated QC tool

Script: DataQuality.sh
Checks by header

Checks each active resource in the ckan_default database- resource, resource_group table by using the curl header.

CURL Timeout - 5 seconds 

Writes to the ngds_resource_quality table results of the lookup, saves status, returned_location, and length

nohup /usr/sbin/DataQuality.sh >> /var/log/dq.log 2>&1 &

Help 

DataQuality - performs a check on resource links in the NGDS CKAN Database 
*              This uses the curl header option to check the status of links
*              and saves the results in a database table ngds_resource_qualty.

Synopsis:  DataQuality -l --limit [#]  -o --offset [#] -w -p
*    -l,--limit    Set the maximum number of resource links to be checked
*    -o,--offset   Set the starting record of resource link to be checked
*    -w,--webservice        Check WMS and WFS records
*    -p,--primaryresource   Check primary dataset resource record"

