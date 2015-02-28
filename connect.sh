#!/bin/zsh

function show()
{
	hosts=$(grep -e "Host [a-zA-Z1-9].*" /Users/`whoami`/.ssh/config|awk '{print $2}')
	hostnames=$(grep "HostName " /Users/`whoami`/.ssh/config|awk '{print $2}')
	index=1
	for i in `echo $hosts`; do
		hostname=`echo $hostnames|sed -n "$index"p`
		printf "%-5s %-15s %-30s\n" $index $i $hostname
		let index++
	done
}

function init()
{
	if [ ! -d /Users/`whoami`/.ssh ]; then
		echo "create .ssh directory"
		mkdir /Users/`whoami`/.ssh
		echo "done"
	else
		echo ".ssh directory already exist"
	fi
	if [ ! -e /Users/`whoami`/.ssh/config ]; then
		echo "create .ssh/config file"
		touch /Users/`whoami`/.ssh/config
		echo "done"
	else
		echo ".ssh/config file already exist"
	fi
	if [ ! -e /Users/`whoami`/.ssh/id_rsa.pub ]; then
		echo "create .ssh/id_rsa.pub file"
		ssh-keygen -t rsa -f /Users/`whoami`/.ssh/id_rsa -N '' > /dev/null
		echo "done"
	else
		echo ".ssh/id_rsa.pub file already exist"
	fi
}

function login()
{
	var=$(echo $1 | bc 2>/dev/null)
	if [ "$var" = "$1"  ]; then
		host=$(grep -e "Host [a-zA-Z1-9].*" /Users/`whoami`/.ssh/config|awk '{print $2}'|sed -n "$var"p)
		ssh $host
	else
		ssh $1
	fi
}

function add()
{	
	if [ $# = 4 ]; then
		/usr/local/bin/ssh-copy-id -i /Users/`whoami`/.ssh/id_rsa.pub $4@$3
	elif [ $# = 5 ]; then
		/usr/local/bin/ssh-copy-id -i /Users/`whoami`/.ssh/id_rsa.pub -p $5 $4@$3
	fi
	echo "Host $2" >> /Users/`whoami`/.ssh/config
	echo "HostName $3" >> /Users/`whoami`/.ssh/config
	echo "User $4" >> /Users/`whoami`/.ssh/config
	if [ $# = 5 ]; then
		echo "Port $5" >> /Users/`whoami`/.ssh/config
	fi
	echo "" >> /Users/`whoami`/.ssh/config
	echo "add done"
}

if [ $# = 0 ]; then
	show
elif [ $# = 1 ]; then
	if [ $1 = "init" ]; then
		init
	else
		login $1
	fi
elif [ $# = 4 ] || [ $# = 5 ]; then
	if [ $1 = "add" ]; then
		add $@
	fi
fi







