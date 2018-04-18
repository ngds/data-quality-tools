#!/bin/bash
echo "NGDS Resource Links Data Repair ----------------------------------"
echo "`date` --This script fixes the faulty osti.gov - run April 12 2018 -------"
shopt -s extglob
cd /var/lib/pgsql

sudo -su postgres psql -U postgres -d ckan_default --quiet --no-align --field-separator ' ' -t -c "select id,  replace(replace(url, '/geothermal',''),'/native','') as rt from resource_revision where url like '%osti%' and url like '%geothermal%' and state = 'active' and current=true limit 1" pass |
while  read -a SVRDATA ;do
  echo "resource ID: ${SVRDATA[0]}  url: ${SVRDATA[1]}"
  echo "{\"id\": \"${SVRDATA[0]}\", \"url\": \"${SVRDATA[1]}\" }"
  echo  "Authorization:c5eafeb9-9dcf-46b0-89b7-f2163adab431"
  curl -XPOST "http://search.geothermaldata.org/api/3/action/resource_update" -H "Authorization: c5eafeb9-9dcf-46b0-89b7-f2163adab431" -d "{\"id\": \"${SVRDATA[0]}\", \"url\": \"${SVRDATA[1]}\" }"
  
done

