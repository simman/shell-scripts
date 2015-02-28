#!/bin/bash

url=`pbpaste`
base="/tmp"
wget -O $base/file $url
id=`cat $base/file | grep -E -o 'song_id=[0-9]+'| grep -E -o '[0-9]+'|head -n 1`
url="http://ting.baidu.com/data/music/links?songIds=$id&rate=320"
wget -O $base/file2 $url
link=`cat $base/file2 |grep -E -o 'zhangmenshiting.+=[0-9a-z]+","show'|sed -E "s/show//g"|sed -E 's/["|,|\\]//g'`
echo "http://$link" | pbcopy