#!/bin/bash

read -p "Server Or Client [s/c]: " machine_type
if [ "$machine_type" = "s" ]; then
    sudo cp tftp_configuration /etc/xinetd.d/tftp
    sudo mkdir -p /var/lib/tftpboot
    sudo chmod -R 777 /var/lib/tftpboot
    sudo systemctl restart xinetd
    sudo systemctl enable xinetd
    sudo systemctl status xinetd >> file.txt
    head -n 10 file.txt
elif [ "$machine_type" = "c" ]; then
    read -p "Enter Server IP Address" ip_addr
    tftpd $ip_addr
    put tftp_file.txt
else
    echo "Enter A Valid Input"
