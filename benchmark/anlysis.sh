#!/bin/bash

num=`cat geshi|wc -l`
for((i=1;i<=$num;i++))
do
	geshi=`sed -n ''$i'p' geshi`
	filename=`sed -n ''$i'p' filename`
	echo $geshi >> $filename.csv
	for j in `ls *.txt`
	do
		line=`cat -n $j|grep "$geshi"|awk '{print $1}'`
		if [ $line ];then
			dataline=$(($line + 2))
			echo `sed -n ''$dataline'p' $j` >> $filename.csv
		else
			echo " " >> $filename.csv
		fi
	done
	echo " " >> $filename.csv
done
