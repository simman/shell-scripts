#!/bin/bash

line1=2

for i in `cat filenameNum.txt`
do
	filename=$(sed -n ''$line1'p' result.txt)
	begin=$(($line1 + 2))
	end=$(($i - 2))
	line1=$i
	sed -n ''$begin','$end'p' result.txt > $filename
done

filename=$(sed -n ''$line1'p' result.txt)
begin=$(($line1 + 2))
end=$(cat result.txt|wc -l)
sed -n ''$begin','$end'p' result.txt > $filename
