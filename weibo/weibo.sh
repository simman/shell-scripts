date=$(date +%Y%m%d)

num=$(($(cat /home/diseng/weibo/weibo.log|wc -l) + 1))
text=$(sed -n ''$num'p' /home/diseng/weibo/english)
weibo=$(echo $text /home/diseng/weibo/images/$date.jpg)
random=`echo $RANDOM%114|bc`
if [ $random -le 0 ];then
	/home/diseng/weibo/weibo -tp $weibo
else 
	friend=`sed -n ''$random'p' /home/diseng/weibo/nameLists`
	/home/diseng/weibo/weibo -tp @$friend Morning , $weibo
fi
echo $weibo >> /home/diseng/weibo/weibo.log
