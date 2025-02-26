# Packer AWS AMI Builder for Project 19

This project automates the creation of custom AWS AMIs using Packer. It includes configurations for:
- **WordPress** (`terraform-web-prj-19`)
- **NGINX** (`terraform-nginx-prj-19`)
- **Bastion Host** (`terraform-bastion-prj-19`)

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Getting Started](#getting-started)
4. [Configuration Details](#configuration-details)
5. [Building AMIs](#building-amis)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)
8. [FAQs](#faqs)
9. [References](#references)

---

## Prerequisites
1. **AWS Account**: With IAM credentials (Access Key + Secret Key).
2. **Packer**: [Install Packer](https://developer.hashicorp.com/packer/downloads).
3. **AWS CLI**: [Install and configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
4. **SSH Key Pair**: Create one in your AWS region (e.g., `my-keypair.pem`) or leave packer to use default.

---

## Project Structure
```bash
.
├── README.md
├── variables.pkr.hcl          # Shared variables (region, etc.)
├── web.pkr.hcl                # WordPress AMI configuration
├── nginx.pkr.hcl              # NGINX AMI configuration
├── bastion.pkr.hcl            # Bastion Host AMI configuration
├── scripts/
│   ├── web.sh                 # WordPress setup script
│   ├── nginx.sh               # NGINX setup script
│   └── bastion.sh             # Bastion Host setup script
└── outputs/                   # (Auto-generated) Packer logs/AMIs
```

---

## Getting Started
### 1. Clone the Repository

```bash
git clone https://github.com/kosenuel/terraform-cloud.git
cd terraform-cloud/AMI\ \(Packer\)/
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key, Secret Key, and default region (e.g., `eu-west-2`)
```

### 3. Update AMI IDs
Replace placeholder AMI IDs (e.g., `ami-0123456789abcdef0`) in the HCL files with valid base AMIs for your region:
- **RHEL AMI** (for WordPress/Bastion):
  ```bash
  aws ec2 describe-images --owners (put in your account number here: '033221328123') --filters "Name=name,Values=RHEL-*" --query 'Images[*].[ImageId,Name]' --output table --region eu-west-2
  ```
- **Ubuntu AMI** (for NGINX):
  ```bash
  aws ec2 describe-images --owners (put in your account number here: '033221328123') --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" --query 'Images[*].[ImageId,Name]' --output table --region eu-west-2
  ```

---

## Configuration Details
### HCL vs. JSON
- **HCL (Recommended)**: Human-readable with comments and variables (e.g., `web.pkr.hcl`).
- **JSON (Legacy)**: Is not human reading friendly, and can easily become cryptic when troubeshooting complex stuff. 

### Key Files
1. **`variables.pkr.hcl`**: Shared variables (region, tags).
2. **`web.pkr.hcl`/`nginx.pkr.hcl`/`bastion.pkr.hcl`**: Image-specific configurations.
3. **`scripts/*.sh`**: Provisioning scripts (install packages, configure services).

---

## Building AMIs
### Build All AMIs
In our case this is how we built the ami's using packer:

- First, we cd into the `bastion-image` folder and run:
```bash
packer build bastion.pkr.hcl
```
after we have built this image successfully, we would notice that The file `output/Ansible_key.pub` has a new value, this is gotten from the ssh-key pair generation that occured when building the bastion, and this public key is to be applied to the `variable.pkvar.hcl` file by running:

```bash
cd ../ # This is to ensure that you are in the `HCL` directory.

./apply_pub_key_2_var.sh

cat variables.pkrvar.hcl # to view and verify that the content was actually modified
```
That script would help you automatically apply the public key just generated.
Now you can continue with the process by building other images. We can achive this by running:

```bash
# Now build all images by going into each image dir and initializing (by running `packer init .`)
packer build -var-file=variables.pkvar.hcl .

```

In details:

```bash
# Initialize Packer plugins (first time only)
packer init .

# Build Bastion Host AMI
cd bastion-image/
packer build bastion.pkr.hcl -var-file=variables.pkrvar.hcl

# Build Web AMI
cd web-servers-image/
packer build web.pkr.hcl -var-file=variables.pkrvar.hcl

# Build NGINX AMI
cd nginx-ami/
packer build nginx.pkr.hcl -var-file=variables.pkrvar.hcl

# Build Ubuntu Host AMI
cd ubuntu-ami/
packer build ubuntu.pkr.hcl -var-file=variables.pkrvar.hcl
```

### Build Options
- **Override Variables**:
  ```bash
  packer build -var 'region=us-east-1' web.pkr.hcl
  ```
- **Debug Mode**:
  ```bash
  PACKER_LOG=1 packer build web.pkr.hcl
  ```
OR
```
export PACKER_LOG=1
export PACKER_LOG_PATH=packer-debug.log
```


---

## Best Practices
1. **Version Control**: Track changes to HCL files and scripts using tools like github.
2. **Use Variables**: Avoid hardcoding values (e.g., AMI IDs, regions).
3. **Tagging**: Add AWS tags for cost tracking and organization.
4. **Test Scripts**: Validate `*.sh` scripts locally before building AMIs.
5. **Security**: Use `ansible-vault` or AWS Secrets Manager for sensitive data.

---

## Troubleshooting
| Issue | Solution |
|-------|----------|
| **Permission denied** | Ensure your IAM user has `EC2FullAccess` permissions. |
| **AMI not found** | Verify the base AMI ID and region compatibility. |
| **SSH connection failed** | Check the `ssh_username` (e.g., `ec2-user` for RHEL). |
| **Script errors** | Run scripts manually on a test instance. |

---

## FAQs
### Q: Why use HCL instead of JSON?
- **HCL** supports comments, variables, and is easier to read. JSON is legacy.

### Q: How do I share AMIs across AWS accounts?
Use `aws ec2 modify-image-attribute` after building the AMI.

### Q: What if my script fails mid-build?
Packer will halt and destroy the temporary instance. Fix the script and retry.

---

## References
1. [Packer Official Documentation](https://developer.hashicorp.com/packer)
2. [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
3. [Sample Provisioning Scripts](https://github.com/orgs/community/discussions/26139)

---

**Thanks!** 
*For issues, open a GitHub ticket or contact [kosenuel@gmail.com](mailto:kosenuel@gmail.com).*
