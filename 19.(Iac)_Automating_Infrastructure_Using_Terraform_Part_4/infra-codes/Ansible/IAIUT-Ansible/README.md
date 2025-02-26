# Ansible Deployment Project

This repository contains Ansible playbooks and roles to provision and configure remote machines in AWS. It supports deploying multiple services, including:
- **Nginx-based web servers**
- **A custom tooling application**
- **A WordPress site with database and EFS mounting**

## Requirements

- **Ansible 2.9+**
- **AWS Account** with running instances tagged as:
  - `ACS_bastion`
  - `ACS_nginx`
  - `ACS_tooling`
  - `ACS_wordpress`
- **Configured AWS profile** ([inventory/aws_ec2.yml](inventory/aws_ec2.yml))
- **SSH key & permissions** (see [ansible.cfg](ansible.cfg))

## Usage

### 1. Configure Inventory
Modify [inventory/aws_ec2.yml](inventory/aws_ec2.yml) to match your AWS settings and tags.

### 2. Review Variables
Each role has default variables in `defaults/main.yml`:
- **Nginx:** [roles/nginx/defaults/main.yml](roles/nginx/defaults/main.yml)
- **Tooling:** [roles/tooling/defaults/main.yml](roles/tooling/defaults/main.yml)
- **WordPress:** [roles/wordpress/defaults/main.yml](roles/wordpress/defaults/main.yml)

### 3. Run the Playbook
Execute the main playbook to deploy all roles:
```sh
ansible-playbook playbooks/site.yml
```

This targets AWS EC2 hosts based on tags (`tag_ACS_nginx`, `tag_ACS_tooling`, `tag_ACS_wordpress`).

---

## Repository Structure
```bash
├── ansible.cfg           # Ansible configuration file
├── inventory/            # Inventory files for AWS EC2
│   └── aws_ec2.yml       # AWS dynamic inventory
├── playbooks/            # Playbooks for deployment
│   └── site.yml          # Main playbook
├── roles/                # Ansible roles
│   ├── nginx/            # Nginx installation & config
│   │   ├── defaults/     # Default variables
│   │   ├── handlers/     # Event handlers
│   │   ├── tasks/        # Playbook tasks
│   │   ├── templates/    # Config templates (e.g., nginx.conf.j2)
│   │   └── vars/         # Variable overrides
│   ├── tooling/          # Tooling application setup
│   ├── wordpress/        # WordPress installation & config
├── static-assignments/   # Additional static files
```

## Role Overview

### **Nginx Role**
- Installs and configures Nginx with a health check endpoint and reverse proxy settings.
- See [roles/nginx/README.md](roles/nginx/README.md) for details.

### **Tooling Role**
- Sets up a web application environment (Apache/PHP, Amazon EFS, repository cloning, and database provisioning).
- More details in [roles/tooling/README.md](roles/tooling/README.md).

### **WordPress Role**
- Deploys WordPress, mounts an EFS share, installs required packages, and configures `wp-config.php`.
- See [roles/wordpress/README.md](roles/wordpress/README.md).

---

## License
This project is licensed under the **MIT License**. See the `LICENSE` files in each role directory for details.

## Contributing
Feel free to fork this repository and submit pull requests. Follow the code style and guidelines in each role’s `README.md`.

**Thanks!** 
*For issues, open a GitHub ticket or contact [kosenuel@gmail.com](mailto:kosenuel@gmail.com).*

---
---

