#!/bin/bash

read -p "Server Or Client? [s/c]: " machine_type
if [ "$machine_type" = "s" ]; then
	echo "Attempting To Install ftp Server"
	sudo systemctl start vsftpd
	sudo systemctl enable vsftpd
	sudo systemctl start firewalld
	sudo firewall-cmd --add-service=ftp

	sudo cp /etc/vsftp.conf vsftp_original.conf
	sudo cp vsftp_alternate /etc/vsftp.conf
	sudo systemctl restart vsftpd

	sudo firewall-cmd --add-service=ftp
	sudo firewall-cmd --add-port=30000-31000/tcp
	sudo firewall-cmd --reload

	sudo adduser ftpuser
	mkdir -p /home/ftpuser/ftp
	chmod 750 /home/ftpuser/ftp
	chown ftpuser:ftpuser /home/ftpuser/ftp
elif [ "$machine_type" = "c" ]; then
	read -p "Enter Machine Ip Address" machine_ip
	ftp_user="ftpuser"
	ftp_pass="password"
	local_file = "ftp_file.txt"
	ftp -n $machine_ip <<END_SCRIPT
	quote USER $ftp_user
	quote PASS $ftp_pass
	put $local_file
	bye
END_SCRIPT
else
	echo "Enter Valid Input"
fi
