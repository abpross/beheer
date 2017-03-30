ps  -ef | grep frmweb | grep -v grep| while read name id rest
do 
sudo awk '$1~/^Pss/ { sum+=$2 } 
END {printf "%.2f MB\t%.2f GB\n",sum/1024,sum/1024^2 }' /proc/${id}/smaps
done | awk '{ sum+=$1 } { print $1,$2,$3,$4}
END{ printf "\nMemory use frmweb AVG = %.2f MB TOT = %.2f GB\n\n", sum/NR, sum/1024}'
