#!/bin/bash
# Log Counts
echo "NGDS Traffic Statistics log ----------------------------------"
echo "`date` ------------------------------------------------"

STARTIME="0"
SLINE=`head -1  /var/log/httpd/ckan.custom.log`

while  read -a SVRDATA ;do
  STARTIME=`echo "${SVRDATA[3]} ${SVRDATA[4]}"`
done < <(echo ${SLINE})

ELINE=`tail -1  /var/log/httpd/ckan.custom.log `
while  read -a SVRDATA ;do
  ENDTIME=`echo "${SVRDATA[3]} ${SVRDATA[4]}"`
done < <(echo ${ELINE})

TOTAL=`cat /var/log/httpd/ckan.custom.log | wc -l`
echo "Total Hits ${TOTAL}"

BOT=`cat  /var/log/httpd/ckan.custom.log | grep Bot | wc -l`
echo "TOTAL web crawler and bot traffic - ${BOT}"

LT=`cat  /var/log/httpd/ckan.custom.log | grep 10.208 | wc -l`
echo "Local traffic ${LT}"

GBT=`cat /var/log/httpd/ckan.custom.log | grep Googlebot | wc -l`
echo "Crawler - Google ${GBT}"

AHT=`cat  /var/log/httpd/ckan.custom.log | grep ahref | wc -l`
echo "Crawler - ahref  ${AHT}"

BNGT=`cat  /var/log/httpd/ckan.custom.log | grep bing | wc -l`
echo "Crawler - bing  ${BNGT}"

WMET=`cat  /var/log/httpd/ckan.custom.log | grep webmeup | wc -l`
echo "Crawler - webmeupcrawler ${WMET}"

MOCT=`cat  /var/log/httpd/ckan.custom.log | grep opensite | wc -l`
echo "Crawler - Mozilla opensite ${MOCT}"

SRT=`cat  /var/log/httpd/ckan.custom.log | grep semrush | wc -l`
echo "Crawler - Semrush  ${SRT}"

YT=`cat  /var/log/httpd/ckan.custom.log | grep yandex | wc -l`
echo "Crawler - Yandex  ${YT}"

MJT1=`cat  /var/log/httpd/ckan.custom.log | grep MJ12bot | wc -l`
MJT2=`cat  /var/log/httpd/ckan.custom.log | grep mj12bot | wc -l`
echo "Crawler - MJ12bot ${MJT1} ${MJT2}"

VT=`cat  /var/log/httpd/ckan.custom.log | grep -v semrush | grep -v ahrefs | grep -v MauiBot | grep -v Googlebot | grep -v bing | grep -v opensite | grep -v webmeup |  grep -v MJ12bot | grep -v mj12bot | grep -v yandex | grep -v ltx71 | grep -v robots.txt | grep -v 10.208  | wc -l`
echo "Valid traffic - ${VT}"

VDR=`cat  /var/log/httpd/ckan.custom.log | grep -v semrush | grep -v ahrefs | grep -v MauiBot | grep -v Googlebot | grep -v bing | grep -v opensite | grep -v webmeup |  grep -v MJ12bot | grep -v mj12bot | grep -v yandex | grep -v ltx71 | grep -v robots.txt | grep -v 10.208 | grep dataset | wc -l`
echo "Valid Dataset Requests - ${VDR}"

# Count the unique IPs on valid traffic 
# first clear the counter
echo "" > /var/log/httpd/tmp.log

cat  /var/log/httpd/ckan.custom.log | grep -v semrush | grep -v ahrefs | grep -v MauiBot | grep -v Googlebot | grep -v bing | grep -v opensite | grep -v webmeup |  grep -v MJ12bot | grep -v mj12bot | grep -v yandex | grep -v ltx71 | grep -v robots.txt | grep dataset | 
while  read -a SVRDATA ;do
  ## echo "IP: ${SVRDATA[0]}  Timestamp: ${SVRDATA[3]} ${SVRDATA[4]} Status ${SVRDATA[8]}"
  echo "${SVRDATA[0]}" >> /var/log/httpd/tmp.log
done

unv=`sort /var/log/httpd/tmp.log | uniq -c | wc -l`
echo "Unique Visitors ${unv}"

uuid=$(uuidgen)

# echo "LOG TIMES - ${STARTIME} ${ENDTIME}"
sudo -su postgres psql -U postgres -d ckan_default -c "insert into ngds_traffic_statistics (id,log_start,log_last,total_hits,crawler_hits,local_hits, valid_hits, valid_datasets, unique_ip, track_date) values ('$uuid','${STARTIME}','${ENDTIME}','${TOTAL}','${BOT}','${LT}','${VT}','${VDR}','${unv}',CURRENT_TIMESTAMP);"

