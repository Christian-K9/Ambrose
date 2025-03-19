import subprocess
import sys

#Services:
#   ftp - vsftpd
#   tftp - tftpd-hpa
#   sftp - sshd
#   telnet - telnetd, and inetutils-telnetd
#   dns - bind9
#   ntp - chronyd


#Install Package On Server

def install_package(package, installer):
    try:
        subprocess.check_call(["sudo", installer, "install", "-y", package])
    except subprocess.CalledProcessError as e:
        print("Error Installing: " + package)
def check_service_status(service_name, attempt):
    result = subprocess.run(["systemctl", "is-active", service_name],
                            capture_output = True, text = True)
    if result.stdout.strip() == 'active':
        print(service_name + " Is Running")
    else:
        print(service_name + " Is Not Running")
        if attempt < 3:
            print("Attempting To Try Again")
            install_package(service_name, attempt)
        else:
            print()
            print(service_name + " Could Not Be Installed")
            print("Check Configuration Files")

    #Declare Machine
machines = {"debian": "apt", "ubuntu": "apt",
            "centOS": "yum", "fedora": "yum"}
installer = None
while installer == None:
    print("Linux_Machines")
    for i in machines:
        print("     " + i)
    machine = input("What Machine Are You Using? ")
    for i in machines :
        if i == machine:
            installer = machines[i] 
    if installer == None:
        print("Must Be A Valid Machine Name")

    #Declare Server
servers = {"ftp": ["vsftpd"], "tftp" : ["tftpd-hpa"], 
           "sftp": ["sshd"], "telnet": ["telnetd", "inetutils-telnetd"],
            "dns (Secondary)": ["bind9", "bind9-utils"], "ntp": ["chronyd"]}
server_type = None
while server_type == None:
    print("Servers")
    for i in servers:
        print("     " + i)
    server = input("What Server Are You Using? ")
    for i in servers:
        if i == server:
            server_type = servers[i] 
    if server_type == None:
        print("Must Be A Valid Server Name")
for i in server_type:
        print("Installing " + i)
        #install_package(i, installer)

#Configure Package
#Start/Enable Services
#Test Capability
#Summarization