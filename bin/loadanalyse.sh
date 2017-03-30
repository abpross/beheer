#!/bin/bash
#set -x
echo "collecting data"
HOST=`hostname`
LOGFILE="/var/tmp/Performance_${HOST}.txt"
DAG=$(date "+%d" | awk '{printf "%d\n", $1 }')
DAG=$(($DAG-1))
if (( $DAG < 10 ))
then
	DAG="0${DAG}"
fi
echo CPU 
echo -e "* CPU Usage of ALL CPUs \n" >  ${LOGFILE}
sar -u -f /var/log/sa/sa${DAG} >> ${LOGFILE} 2>/dev/null
echo -e "\n ------------\n" >> ${LOGFILE}
echo -e "* CPU Usage of Individual CPUs \n" >>  ${LOGFILE}
sar -P ALL -f /var/log/sa/sa${DAG} >> ${LOGFILE} 2>/dev/null
echo -e "\n ------------\n" >> ${LOGFILE}
echo Mem
echo -e "* Memory Free and Used \n"  >>  ${LOGFILE}
sar -r -f /var/log/sa/sa${DAG} >>  ${LOGFILE} 2>/dev/null
echo -e "\n ------------\n" >> ${LOGFILE}
echo IO
echo -e "* IO Activities \n" >>  ${LOGFILE}
echo "* Overall I/O Activities \n" >> ${LOGFILE}
sar -b -f /var/log/sa/sa${DAG} >> ${LOGFILE} 2>/dev/null
echo -e "\n" >> ${LOGFILE}
echo "* Individual Block Device I/O Activities \n" >> ${LOGFILE}
sar -p -d -f /var/log/sa/sa${DAG} >> ${LOGFILE} 2>/dev/null
echo -e "\n" >> ${LOGFILE}
echo -e "\n ------------\n" >> ${LOGFILE}
echo LOAD
echo -e "* Reports run queue and load average \n" >>  ${LOGFILE}
sar -q -f /var/log/sa/sa${DAG} >>  ${LOGFILE} 2>/dev/null
echo -e "\n ------------\n" >> ${LOGFILE}
echo NETWORK
echo -e "* Report network statistics \n" >>  ${LOGFILE}
sar -n DEV -f /var/log/sa/sa${DAG} >> ${LOGFILE} 2>/dev/null
echo -e "\n ------------\n" >> ${LOGFILE}
echo  "Stored data in ${LOGFILE}"
chmod 644 ${LOGFILE}
