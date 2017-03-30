#/bin/bash
#set -x
HTTPPROXY=$http_proxy
export http_proxy=""
if [[ -z $@ ]]
then
	echo geef telnummer
	read nummer
else
	nummer=$@
fi
nummer=$(echo $nummer | sed -e 's![- ]!!g' -e 's![a-z]!!g' )
if (( ${#nummer} == 10 ))
then
	echo calling $nummer
wget --spider "http://sip/ps/call.php?dest=${nummer}&&shortname=impulse&extension=263&CalleridName=Calling%20${nummer}%20:" > /dev/null 2>&1
else 
	echo "nummer $nummer bevat geen 10 cijfers"
fi
export http_proxy=$HTTPPROXY
