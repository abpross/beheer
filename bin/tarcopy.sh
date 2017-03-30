#!/bin/bash
#set -x
echo $#
if [[ $# != 3 ]]
then
	echo tarcopy.sh name destip destpath
	exit
fi
NAME=$1
IP=$2
DEST=$3
sudo tar -cpf - $NAME |  pv -s `du -sb ${NAME}` | ssh ${IP} "sudo tar -C ${DEST} -xpf - "
