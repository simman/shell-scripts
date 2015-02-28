#!/bin/bash

for i in `ls benchmark.log.*`
do
	Unixbench=`sed -n '4p' $i|awk -F":" '{print $2}'`
	MEMORY=`sed -n '6p' $i|awk '{print $3}'`
	INTEGER=`sed -n '7p' $i|awk '{print $4}'`
	FLOATING=`sed -n '8p' $i|awk '{print $3}'`
	pi=`sed -n '13p' $i`
	echo $Unixbench,$MEMORY,$INTEGER,$FLOATING,$pi >> result.csv
done
