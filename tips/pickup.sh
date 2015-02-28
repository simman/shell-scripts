#!/bin/bash


for i in `cat -n sources | grep "[0-9]、"|awk '{print $1}'`
do
	num=$(($i + 1))
	sed -n ''$i'p' sources >> chines
	sed -n ''$num'p' sources >> english
done
