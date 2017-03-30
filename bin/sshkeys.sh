#!/bin/bash
set -o pipefail
PRM=$1
[[ -z ${PRM} ]] && PRM="start"
case $PRM in 
	start)
		for sleutel in id_rsa.apross id_rsa.quins 
		do
			if ! /usr/bin/ssh-add -l | grep "${sleutel}" >/dev/null 2>&1
			then
				/usr/bin/ssh-add ~/.ssh/${sleutel}
			fi
		done;;
	stop)
		/usr/bin/ssh-add -D;;
esac
