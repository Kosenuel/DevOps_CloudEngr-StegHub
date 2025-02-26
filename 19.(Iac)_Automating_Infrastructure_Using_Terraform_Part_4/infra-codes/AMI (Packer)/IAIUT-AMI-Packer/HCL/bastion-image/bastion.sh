#!/bin/bash
# Create the .ssh directory and set proper permissions
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

# Generate the SSH key pair if it doesn't already exist
if [ ! -f /home/ec2-user/.ssh/Ansible_key ]; then
    ssh-keygen -t rsa -b 4096 -f /home/ec2-user/.ssh/Ansible_key -N ""
fi
# export the ansible public key so that other images can add it to their authorized_keys file
export BASTION_PUBLIC_KEY=$(cat /home/ec2-user/.ssh/Ansible_key.pub)

sudo subscription-manager config --rhsm.manage_repos=0 || true
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm 
sudo yum install -y mysql-server wget vim telnet htop git python3 python3-pip net-tools zip
sudo systemctl start chronyd
sudo systemctl enable chronyd


#installing java 11
sudo yum install -y java-11-openjdk-devel
sudo echo "export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))" >> ~/.bash_profile
sudo echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bash_profile
sudo echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> ~/.bash_profile
source ~/.bash_profile

# clone the Ansible repo
git clone https://github.com/Kosenuel/IAIUT-Ansible.git #you can change it to your own ansible repo if you wish


# install botocore, ansible and awscli
sudo python3 -m pip install boto
sudo python3 -m pip install boto3
sudo python3 -m pip install PyMySQL
sudo python3 -m pip install mysql-connector-python
sudo python3 -m pip install --upgrade setuptools
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install psycopg2==2.7.5 --ignore-installed
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo yum install ansible -y
sudo yum install -y policycoreutils-python-utils
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.general
ansible-galaxy collection install community.mysql
ansible-galaxy collection install community.postgresql
echo "the ansible public key is $BASTION_PUBLIC_KEY"

