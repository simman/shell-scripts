#!/bin/bash

for i in `ls fio*`
do
	lines=$(cat $i|wc -l)
	lines=$(($lines + 2))
	for((j=1;j<7;j++))
	do
		max[j]=`cat $i |awk '{print $'$j'}'|sort -nr|sed -n '1p'`
		min[j]=`cat $i |awk '{print $'$j'}'|sed '/^$/d'|sort -n|sed -n '1p'`
		sum[j]=0
		#echo ${max[j]} ${min[j]}
	done
	for((j=1;j<$lines;j++))
	do
		for((k=1;k<7;k++))
		do
			num=`sed -n ''$j'p' $i |awk '{print $'$k'}'`
			if [ $num ]; then
				#sum[k]=$((${sum[k]} + $num))
				sum[k]=`echo ${sum[k]}+$num |bc`
				#echo ${sum[k]}
			else
				if [ ! ${avg[k]} ];then
					line=$(($j - 1))
					#echo $line
					#echo ${sum[k]}
					avg[k]=`echo "scale=4;${sum[k]}/$line"|bc`
					#echo ${avg[k]}
				fi
			fi
		done
	done
	echo "***************************************************************" >> result.txt
	echo $i read_date: >> result.txt
	echo "***************************************************************" >> result.txt
	echo ${max[1]},${min[1]},${avg[1]},${max[2]},${min[2]},${avg[2]},${max[3]},${min[3]},${avg[3]} >> result.txt
	echo "***************************************************************" >> result.txt
	echo $i read_write: >> result.txt
	echo "***************************************************************" >> result.txt
	echo ${max[4]},${min[4]},${avg[4]},${max[5]},${min[5]},${avg[5]},${max[6]},${min[6]},${avg[6]} >> result.txt
	echo "***************************************************************" >> result.txt
	echo " " >> result.txt
	echo " " >> result.txt
	echo " " >> result.txt
	echo " " >> result.txt
	unset avg max min sum
done
