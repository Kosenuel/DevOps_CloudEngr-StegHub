#!/bin/bash

# Installing some necessary files
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

sudo openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/ACS.key -x509 -days 365 -out /etc/pki/tls/certs/ACS.crt \
-subj "/C=UK/ST=London/L=London/O=kosenuel.com/OU=devops/CN=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048


# Create .ssh directory and set permissions (if it is not already created)
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

# Append the passed public key to the authorized_keys
echo "$BASTION_PUBLIC_KEY" >> /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
echo "Bastion public key added to authorized_keys, the key is: $BASTION_PUBLIC_KEY"


