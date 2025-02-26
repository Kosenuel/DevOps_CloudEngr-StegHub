#!/bin/bash

# Installing necessary packages
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum install -y mysql wget vim telnet htop git python3 python3-pip net-tools 
sudo systemctl start chronyd
sudo systemctl enable chronyd
sudo yum module reset php -y
sudo yum module enable php:remi-7.4 -y


# Take care of the instance not connecting via ssh
# Install and start sshd
sudo yum install -y openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd

# selinux config
sudo setsebool -P httpd_can_network_connect=1
sudo setsebool -P httpd_can_network_connect_db=1
sudo setsebool -P httpd_execmem=1
sudo setsebool -P httpd_use_nfs=1

# installing efs-utils
sudo git clone https://github.com/aws/efs-utils /efs-utils/
cd /efs-utils
sudo yum install -y nfs-utils stunnel make rpm-build cargo openssl-devel rust wget policycoreutils-python-utils
sudo make rpm
sudo yum install -y  ./build/amazon-efs-utils*rpm
# sudo rpm -i -v /tmp/efs-utils/build/amazon-efs-utils*rpm

#installing java 11
sudo yum install -y java-11-openjdk-devel
sudo echo "export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))" >> ~/.bash_profile
sudo echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bash_profile
sudo echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> ~/.bash_profile
source ~/.bash_profile


#installing self signed certificate for apache
sudo yum install -y mod_ssl

sudo openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/ACS.key -x509 -days 365 -out /etc/pki/tls/certs/ACS.crt \
-subj "/C=UK/ST=London/L=London/O=kosenuel.com/OU=devops/CN=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"


sudo sed -i 's/localhost.crt/ACS.crt/g'  /etc/httpd/conf.d/ssl.conf

sudo sed -i 's/localhost.key/ACS.key/g'  /etc/httpd/conf.d/ssl.conf

# Create .ssh directory and set permissions (if it is not already created)
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

# Append the passed public key to the authorized_keys
echo "$BASTION_PUBLIC_KEY" >> /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
echo "Bastion public key added to authorized_keys, the key is: $BASTION_PUBLIC_KEY"