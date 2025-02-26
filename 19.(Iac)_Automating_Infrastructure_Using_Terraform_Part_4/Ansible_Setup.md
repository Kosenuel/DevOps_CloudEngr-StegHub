
# Ansible Control Node Setup Guide

In this guide, we will both outline and explore the steps to prepare an Ansible control node for managing our infrastructure and deploying roles (in our case; WordPress, Tooling, and Nginx) with AWS integration.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Install Ansible](#install-ansible)
- [Install Python Dependencies](#install-python-dependencies)
- [Install Ansible Galaxy Collections](#install-ansible-galaxy-collections)
- [AWS CLI Setup](#aws-cli-setup)
- [Ansible Configuration](#ansible-configuration)
- [Test Your Setup](#test-your-setup)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Prerequisites
- Linux/Unix system (Ubuntu/Debian recommended)
- Python 3.8 or newer
- sudo privileges
- SSH key pair configured

## Install Ansible
```bash
# Update package index
sudo apt update && sudo apt upgrade -y

# Install Python and pip
sudo apt install -y python3 python3-pip python3-venv

# Install Ansible with pip
python3 -m pip install --user ansible

# Verify installation
ansible --version
```

## Install Python Dependencies
```bash
# Install required Python packages
python3 -m pip install --user \
  mysqlclient \
  psycopg2-binary \
  boto3 \
  botocore

# For Ubuntu systems, install system packages:
sudo apt install -y \
  python3-dev \
  libssl-dev \
  libffi-dev \
  libmysqlclient-dev \
  libpq-dev
```

## Install Ansible Galaxy Collections
```bash
# Install AWS collection
ansible-galaxy collection install amazon.aws

# Install community general collection
ansible-galaxy collection install community.general

# Install MySQL collection
ansible-galaxy collection install community.mysql

# Install PostgreSQL collection
ansible-galaxy collection install community.postgresql

# Install posix collection
ansible-galaxy collection install ansible.posix
```

## AWS CLI Setup
```bash
# Install AWS CLI
python3 -m pip install --user awscli

# Configure AWS credentials
aws configure

# Supply your AWS login credentials (your secret keys, and IDs)

# Verify AWS connectivity
aws sts get-caller-identity
```

## Ansible Configuration
Create `ansible.cfg` in your project directory:
```ini
[defaults]
callbacks_enabled = profile_tasks
log_path = ~/ansible.log
host_key_checking = False
roles_path = /home/ec2-user/PBL-project-19/Ansible/roles
ansible_python_interpreter = python3
private_key_file = /home/ec2-user/.ssh/Ansible_key
inventory = /home/ec2-user/PBL-project-19/Ansible/inventory/aws_ec2.yml


[inventory]
enable_plugins = host_list, script, auto, yaml, ini, toml

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o ControlPath=/tmp/ansible-ssh-%h-%p-%r -o ServerAliveInternal=60 -o ServerAliveCountMax=60 -o ForwardAgent=yes

```

Example inventory file (in our case we gave the inventory file this name: `aws_ec2.yml`):
```yml
plugin: amazon.aws.aws_ec2
aws_profile: default

regions:
  - "eu-west-2"

strict: False

keyed_groups:
  - key: tags 
    prefix: tag 

filters: 
  tag:Name:
    - ACS_bastion
    - ACS_nginx 
    - ACS_tooling
    - ACS_wordpress 
  instance-state-name: running

hostnames:
  - private-ip-address
  - tag:Name
  - dns-name
  - ip-address

compose:
  ansible_host: private-ip-address
  ansible_user: ec2-user

```

## Test Your Setup
1. Test local connectivity:
```bash
ansible localhost -m ping
```

2. Test AWS connectivity (create a `test_aws.yml`):
```yaml
---
- name: Test AWS Connectivity
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Get EC2 instances
      amazon.aws.ec2_instance_info:
        region: us-east-1
      register: ec2_info

    - name: Display instances
      debug:
        var: ec2_info.instances
```

Run with:
```bash
ansible-playbook test_aws.yml
```

## Best Practices
1. Use Python virtual environments:
```bash
python3 -m venv ansible-env
source ansible-env/bin/activate
```

2. Maintain a `requirements.txt` file:
```
ansible>=7.0.0
boto3>=1.28.0
botocore>=1.31.0
mysqlclient>=2.1.1
psycopg2-binary>=2.9.6
awscli>=1.29.0
```

3. Use version control for your playbooks and roles:
```bash
git init
git add .
git commit -m "Initial Ansible configuration"
```

4. Secure sensitive data with Ansible Vault:
```bash
ansible-vault create secrets.yml
```

## Troubleshooting
Common Issues:
1. **Permission Denied Errors**
   - Verify SSH key permissions: `chmod 600 ~/.ssh/id_rsa`
   - Ensure proper sudo privileges on managed nodes

2. **Python Path Issues**
   - Set `ansible_python_interpreter` in inventory for managed nodes
   - Example: `ansible_python_interpreter=/usr/bin/python3`

3. **AWS Credential Issues**
   - Verify credentials in `~/.aws/credentials`
   - Check environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

4. **Missing Dependencies**
   - Reinstall requirements: `pip install -r requirements.txt`
   - Update Galaxy collections: `ansible-galaxy collection install -r requirements.yml`
