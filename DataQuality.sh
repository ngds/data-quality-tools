#!/bin/bash

# NGDS Resource Link Data Quality Check v2
# Retrieve 405 - method not allowed  
# Author: G Hudman 11/16/2015

echo "NGDS Resource Links Data Source Quality Check--------------------------  `date`"

SCRIPTHOME="/var/lib/pgsql"
cd $SCRIPTHOME

shopt -s extglob
if [ "$1" == "-h" ]
then
       echo "      NGDS Resource DataQuality Help  "
       echo "              Performs a check on resource links in the NGDS CKAN Database "
       echo "              This script uses the curl header option to check the status of links"
       echo "              and saves the results in the database table ngds_resource_qualty."
       echo ""
       echo "      Synopsis:  DataQuality -l --limit [#]  -o --offset [#] -w -p -d [datetime]"
       echo "     -l,--limit             Set the maximum number of resource links to be checked"
       echo "     -o,--offset            Set the starting record of resource link to be checked"
       echo "     -w,--webservice        Check WMS and WFS records"
       echo "     -p,--primaryresource   Check primary dataset resource records"
       echo "     -d [datetime]          Check records that have a metadata date time"
       exit
fi

LIMIT="ALL"
OFFSET=0
DTYPE="ps"
DATESTART=""

while [[ $# > 1 ]]
do
key="$1"
echo "Start $key"
case $key in
    -l|--limit)
      LIMIT="$2"
      echo " Set limit $key $LIMIT"
      shift # past argument
      ;;
    -o|--offset)
      OFFSET="$2"
      echo " Set offset $key $OFFSET"
      shift # past argument
      ;;
    -w|--webservice)
      DTYPE="ws"
      shift # past argument
      ;;
    -d|--datetime)
      DATESTART="$2"
      shift # past argument
      ;;
    --default)
    DEFAULT=YES
    ;;
    *)
     # unknown option
    ;;
esac
shift # past argument or value
done
  echo "the $DTYPE"
  if [ "$DTYPE" == "ps" ];
  then
      SQSTR="select package_id, r.id as resource_id, url from resource r, resource_group g "
      SQSTR="$SQSTR where r.resource_group_id = g.id and r.state = 'active' and "
      SQSTR="$SQSTR r.url not like '%WFS%' AND r.url not like '%WMS%' and "
      SQSTR="$SQSTR (package_id,r.id) in (select package_id, resource_id from ngds_resource_quality where http_status = '405')"
      SQSTR="$SQSTR order by r.id limit $LIMIT offset $OFFSET" 
      echo "SQL Query: $SQSTR"  
  fi

  if [ "$DTYPE" == "ws" ];
  then
     SQSTR="select package_id, r.id as resource_id, url from resource r, resource_group g "
     SQSTR="$SQSTR where r.resource_group_id = g.id and r.state = 'active' and "
     SQSTR="$SQSTR (r.url like '%WFS%' AND r.url like '%WMS%') and "
     SQSTR="$SQSTR (package_id,r.id) in (select package_id, resource_id from ngds_resource_quality where http_status = '405')"
     SQSTR="$SQSTR order by r.id limit $LIMIT offset $OFFSET" 
  fi

  echo ' Start SQL' 
  psql -U postgres -d {{db}} --quiet --no-align --field-separator ' ' -t -c "$SQSTR" {{pw}} |
  while  read -a SVRDATA ;do

      while IFS=':' read key value; do
       # trim whitespace in "value"
       value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}

       case "$key" in
       Content-Length) CLEN="$value"
       ;;
       Location) LOC="$value"
       ;;
       HTTP*) read PROTO STATUS MSG <<< "$key{$value:+:$value}"
       ;;
       Last-Modified) LMD="$value"
       esac
       done < <(curl -m 5 -sI ${SVRDATA[2]})
       uuid=$(uuidgen)
       echo "pid: ${SVRDATA[0]} url: ${SVRDATA[2]} Status: $uuid $PROTO $STATUS $LOC $CLEN"
     
       if [ "$STATUS" == "405" ];
       then
          # 405 error is Method not allowed so got get the whole resource and keep the header
	  curl -D $SCRIPTHOME/temp_hdr.txt ${SVRDATA[2]} > /dev/null
	  #echo "HHTP 405  "
          #cat $SCRIPTHOME/temp_hdr.txt
	  while IFS=':' read key value; do
        	value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}
        	case "$key" in
            	Content-Length) CLEN="$value"
                ;;
            	Location) LOC="$value"
                ;;
            	HTTP*) read PROTO STATUS MSG <<< "$key{$value:+:$value}"
                ;;
            	Last-Modified) LMD="$value"
         	esac
       	  done < <(cat $SCRIPTHOME/temp_hdr.txt)
          echo "HTTP 405 Recovered for pid: ${SVRDATA[0]} url: ${SVRDATA[2]} Status: $uuid $PROTO $STATUS $LOC $CLEN"
       fi
       DATELEN=${#LMD}
       echo "Last Modified - $LMD $DATELEN"
       if [ "$DATELEN" -ge 5 ];
       then
           MDSTR="to_timestamp('$LMD','dy, DD Mon YYYY HH24:MI:SS TZ')"
       else
           MDSTR="null"
       fi
 
       INSTR="insert into ngds_resource_quality (id,package_id,resource_id,orig_url,validation_date, "
       INSTR="$INSTR http_status, http_location, http_content_length, http_last_modified) values "
       INSTR="$INSTR ('$uuid','${SVRDATA[0]}','${SVRDATA[1]}','${SVRDATA[2]}',CURRENT_TIMESTAMP,'$STATUS','$LOC',$CLEN,$MDSTR);"
       psql -U postgres -d {{db}} -c "$INSTR"
	
   LOC=""
   CLEN=0
   LMD=""
   STATUS="None"

done