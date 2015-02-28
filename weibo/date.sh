#!/bin/bash
cd images/$2
date=$1
for i in `ls`
do
	mv $i $date.jpg
	date=$(($date + 1))
done

mv * ../
