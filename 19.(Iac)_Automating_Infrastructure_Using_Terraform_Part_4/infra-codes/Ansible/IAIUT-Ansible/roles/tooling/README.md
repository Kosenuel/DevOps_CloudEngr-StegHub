# Ansible Role for Tooling

This Ansible role automates the provisioning of a web application environment, including the installation and configuration of necessary components such as Apache, PHP, Amazon EFS (Elastic File System), and MySQL. 

## Role Variables

The following variables can be defined in `defaults/main.yml` or overridden in `vars/main.yml`:

- `db_host`: The hostname or IP address of the database server.
- `db_user`: The username for the database.
- `db_pass`: The password for the database user.
- `app_db_name`: The name of the application database.
- `app_db_user`: The database user for the application.
- `app_db_pass`: The password for the application database user.
- `efs_mount`: The mount point for the EFS.
- `repo_url`: The URL of the application repository.

## Dependencies

This role does not have any dependencies on other roles.

## Example Playbook

```yaml
- hosts: webservers
  roles:
    - tooling
```

## License

This project is licensed under the MIT License.

## Author Information

This role was created in 15 Feb 2025 by Emmanuel Okose.