#!/bin/bash

base="/home/diseng/weibo/article"
bash $base/article.sh http://news.dbanotes.net/ Comments
bash $base/article.sh https://news.ycombinator.com/ comments
article1=`tac $base/records|sed -n '1p'`
article2=`tac $base/records|sed -n '2p'`

/home/diseng/weibo/weiboNodivide -t @diseng_Teng,you may have interest in them:$article1 , $article2

#echo $article1 $article2
