sudo awk '$1~/^Pss/ { sum+=$2 } 
END {print sum/1024" MB\t"sum/1024^2" GB" }' /proc/${1}/smaps
