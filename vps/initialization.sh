#!/bin/bash

if [ $USER != 'root' ]; then
	echo "Sorry, you need to run this as root"
	exit
fi

read -p "input the new password for root:" password
echo root:$password | chpasswd
echo "Success : changed the password for root"

read -p "input the group name you want to add:" group
addgroup $group
echo "Success : added the group $group"

read -p "input the username you want to add:" username
useradd -d /home/$username -s /bin/bash -m $username
echo "Success : added the user $username"

read -p "input the password for $username:" subpassword
echo $username:$subpassword | chpasswd
echo "Success : setted the password for $username"

usermod -a -G $group $username
echo "Success : added $username to group $group"

read -p "$username use sudo need password ? [y|n]" option1
if [ "$option1" = "y" ]; then
	echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers
else
	echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi
echo "Success : added $username to /etc/sudoers"

read -p "Do you want to change time to Shanghai/China ? [y|n]" option3
if [ "$option3" = "y" ]; then
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	echo "Success : changed time to Shanghai/China"
else
	echo "Skip time setting"
fi

read -p "Do you hava file named id_rsa.pub in you local machine ? [y|n]" option2
if [ "$option2" = "y" ]; then
	read -p "input you public key(the contents in id_rsa.pub):" publicKey
	mkdir /home/$username/.ssh/
	touch /home/$username/.ssh/authorized_keys
	chown -R $username:$username /home/$username/.ssh/
	echo $publicKey > /home/$username/.ssh/authorized_keys
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bakup
	read -p "input the ssh port you want to use:" port
	sed -i -r -e "s/#?Port/Port $port#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?Protocol/Protocol 2#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?PermitRootLogin/PermitRootLogin no#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?PermitEmptyPasswords/PermitEmptyPasswords no#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?PasswordAuthentication/PasswordAuthentication no#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?RSAAuthentication/RSAAuthentication yes#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?PubkeyAuthentication/PubkeyAuthentication yes#/g" /etc/ssh/sshd_config
	sed -i -r -e "s/#?AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config
	echo "UseDNS no" >> /etc/ssh/sshd_config
	echo "AllowUsers $username" >> /etc/ssh/sshd_config
	chmod 600 /home/$username/.ssh/authorized_keys && chmod 700 /home/$username/.ssh/
	echo "Success : configed sshd"
	echo ""
	service ssh restart
	echo "Success : restarted ssh"
	echo "now you can connect to your VPS without password like this:"
	echo "ssh -p port usernam@remote-host"
 else
	echo "Skip sshd setting"
fi



