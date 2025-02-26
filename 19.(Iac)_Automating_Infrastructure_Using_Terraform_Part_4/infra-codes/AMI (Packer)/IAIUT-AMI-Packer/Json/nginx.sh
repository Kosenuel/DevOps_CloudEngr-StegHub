#!/bin/bash
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm 
sudo yum install -y mysql wget vim telnet htop git python3 net-tools 
sudo systemctl start chronyd
sudo systemctl enable chronyd

# selinux config
sudo setsebool -P httpd_can_network_connect=1
sudo setsebool -P httpd_can_network_connect_db=1
sudo setsebool -P httpd_execmem=1
sudo setsebool -P httpd_use_nfs=1


# installing self signed certificate
sudo mkdir /etc/ssl/private

sudo chmod 700 /etc/ssl/private

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ACS.key -out /etc/ssl/certs/ACS.crt \
-subj "/C=UK/ST=London/L=London/O=steghub.com/OU=devops/CN=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048


