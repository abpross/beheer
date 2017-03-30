#!/bin/bash
#set -x
CONFDIR=/etc/httpd/virtualhosts/conf
AUTHDIR=/etc/httpd/virtualhosts/conf.d
function update_robots {
	SITE=$1
	AUTHFILE=${SITE}.auth
	CONFFILE=${SITE}.conf
	if [[ ! -f ${CONFDIR}/${CONFFILE} ]]
	then
		return
	fi
	HTMPATH=$(awk '/DocumentRoot/ {docr=$2};END {print docr }' ${CONFDIR}/${CONFFILE})
	HTMPATH=${HTMPATH%/}
	ROBOT=${HTMPATH}/robots.txt
	ROBOTNEW=${ROBOT}.new
	grep "^Disallow: /" ${ROBOT} > ${HTMPATH}/robots.txt.new
	for i in php mysql pHpMy squirrel
	do
		echo "Disallow: /${i}*" >> ${HTMPATH}/robots.txt.new
	done
	grep "<Directory" ${AUTHDIR}/${AUTHFILE} | sed -e 's!^<Directory '${HTMPATH}'!Disallow: !g' -e 's!>$!!g' >> ${ROBOTNEW}
	echo "User-Agent: *" > ${ROBOT}
	sort -u ${ROBOTNEW} >> ${ROBOT}
	rm ${ROBOTNEW}
}
ls /etc/httpd/virtualhosts/conf.d/ | while read SITE
do
	SITE=${SITE%.auth}
	update_robots ${SITE}
done
