#!/bin/bash

base="/home/diseng/weibo/article"
url=$1
wget -O $base/file $url
grep $2 $base/file > $base/articles
sed -i "s/|/\n/g" $base/articles
grep -o "[0-9]* points" $base/articles | sort -unr > $base/sort
for((i=1;i<31;i++))
do
	point=`sed -n ''$i'p' $base/sort`
	pointnum=`grep "$point" $base/articles|wc -l`
	if [ $pointnum -eq 1 ];then
		title=`grep "$point" $base/articles|grep -Po '<td class="title">.+?</td>'|grep -Po '<a.+?</a>'|grep -Po '>.+?<'|sed 's/[>|<]//g'`
 		check=`grep "$title" $base/records|wc -l`
		if [ $check -eq 0 ];then
                	articleurl=`grep "$point" $base/articles|grep -Po '<td class="title">.+?</td>'|grep -Po 'href=".+?"'|grep -Po '".+"'|sed 's/"//g'`
               		echo $title $articleurl >> $base/records
                	break
                fi
        else
		for((j=1;j<=$pointnum;j++))
		do
			title=`grep "$point" $base/articles|sed -n ''$j'p'|grep -Po '<td class="title">.+?</td>'|grep -Po '<a.+?</a>'|grep -Po '>.+?<'|sed 's/[>|<]//g'`
	                check=`grep "$title" $base/records|wc -l`
        	        if [ $check -eq 0 ];then
                	        articleurl=`grep "$point" $base/articles|sed -n ''$j'p'|grep -Po '<td class="title">.+?</td>'|grep -Po 'href=".+?"'|grep -Po '".+"'|sed 's/"//g'`
                		echo $title $articleurl >> $base/records
				break 2
                	fi
		done		
	fi
done
