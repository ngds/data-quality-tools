#!/bin/bash
echo "NGDS Resource Links Data Source Quality Check----------------------------------"
echo "`date` ----------------------------------"
shopt -s extglob
cd /var/lib/pgsql
CLEN=0

sudo -su postgres psql -U postgres -d ckan_default --quiet --no-align --field-separator ' ' -t -c "select p.id, r.id as resource_id, replace(replace(r.url, '''','%27'),' ','%20') as url from package_revision p, resource_revision r, resource_group_revision g where p.id=g.package_id and p.revision_id=g.revision_id and r.resource_group_id = g.id and  p.current=true and p.state='active' and r.state = 'active' and r.current=true and (r.url like '%WFS%' OR r.url like '%WMS%' r.url like '%wfs%' OR r.url like '%wfs%') order by r.id" pass |
while  read -a SVRDATA ;do
  echo "pid: ${SVRDATA[0]}  rid: ${SVRDATA[1]} url: ${SVRDATA[2]}"
  
  while IFS=':' read key value; do
  
    value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}

    case "$key" in
        Content-Length) CLEN="$value"
                ;;
        Location) LOC="$value"
                ;;
        HTTP*) read PROTO STATUS MSG <<< "$key{$value:+:$value}"
                ;;
     esac
   done < <(curl -XGET -m 5 -sI ${SVRDATA[2]})
   uuid=$(uuidgen)
   echo "pid: ${SVRDATA[0]}  rid: ${SVRDATA[1]} url: ${SVRDATA[2]} Status $uuid $STATUS LENGTH- $LOC $CLEN"
  
   sudo -su postgres psql -U postgres -d ckan_default -c "insert into ngds_resource_quality (id,package_id,resource_id,orig_url,validation_date, http_status, http_location, http_content_length, http_last_modified) values ('$uuid','${SVRDATA[0]}','${SVRDATA[1]}','${SVRDATA[2]}',CURRENT_TIMESTAMP,'$STATUS','CATALOG-1',$CLEN,null);"
   LOC=""
   CLEN=0
   STATUS="None"
done