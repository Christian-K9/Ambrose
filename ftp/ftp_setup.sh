#!/bin/bash
read -p "Enter FTP server IP: " ftp_server

ftp_user="ftpuser"
ftp_pass="password"
local_file=$((pwd)/"ftp_file.txt")
remote_dir="upload"

ftp -n $ftp_server <<END_SCRIPT
quote USER $ftp_user
quote PASS $ftp_pass
cd $remote_dir
put $(basename $local_file)
bye
END_SCRIPT

echo "Upload finished!"

