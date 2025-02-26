# WordPress Ansible Role

This role installs and configures WordPress on a RHEL-based system. It performs the following:

- Updates the system and installs extra dependencies.
- Installs and mounts an Amazon EFS share.
- Installs Apache, PHP, and required modules.
- Downloads and configures WordPress.
- Sets up the WordPress database on an RDS endpoint.
- Configures an Apache health check endpoint (mainly for the loadbalancer's consumption in checking the health of the machines).

## Requirements

- Amazon EFS and required utilities are available.
- RHEL/CentOS/Amazon Linux environment.
- MySQL client installed on the target. 

## Role Variables

All essential variables can be found in `defaults/main.yml`. Override these as needed.

## Usage

Include the role in your playbook:

```yaml
- hosts: web_servers
  become: yes
  roles:
    - wordpress
```

## Dependencies

This role has no external dependencies but may require the installation of the `amazon-efs-utils` package.