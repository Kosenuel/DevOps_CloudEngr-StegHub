# NGINX Ansible Role

This role installs and configures NGINX on RedHat and Debian-based systems. It:
- Updates the repository index.
- Installs NGINX.
- Creates a health check file.
- Deploys a full nginx.conf from a Jinja2 template—including a reverse proxy setup for an internal load balancer.
- Ensures the NGINX service is enabled and started.

## Role Variables

The following variables are defined in `defaults/main.yml`:
- `nginx_package`: Package name for NGINX.
- `nginx_service_name`: Service name to control.
- `healthz_path`: Path for the health check file.
- `healthz_content`: Content to write to the health check file.
- `nginx_conf_path`: Path to the main nginx configuration file.
- `internal_alb_dns_name`: DNS name for the internal load balancer (used in proxy_pass).

## Usage

Include the role in your playbook:

```yaml
- hosts: nginx_servers
  become: yes
  roles:
    - nginx