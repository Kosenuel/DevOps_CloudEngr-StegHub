
# Terraform Infrastructure as Code (IaC) for Project 19

This project provisions cloud infrastructure on AWS for Project 19 using Terraform. It includes modules for **networking**, **security**, **compute**, **storage**, and **load balancing**, with remote state management via Terraform Cloud. Designed for modularity and collaboration.

[![Terraform Version](https://img.shields.io/badge/terraform-≥1.10.5-844FBA?logo=terraform)](https://terraform.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![AWS Provider](https://img.shields.io/badge/AWS-Provider-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

---

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Modules](#modules)
- [State Management](#state-management)
- [Usage](#usage)
- [Variables](#variables)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Features
- **Networking**: VPC, Public/Private Subnets, NAT/Internet Gateways
- **Security**: IAM Roles, Security Groups, TLS Certificates (ACM)
- **Compute**: Auto Scaling Groups, EC2 Instances (WordPress, Nginx, Bastion)
- **Storage**: RDS (MySQL), EFS File System
- **Load Balancing**: Application Load Balancers (ALBs), Target Groups
- **Remote State**: Terraform Cloud backend with state locking

---

## Prerequisites
1. **Terraform CLI** ([Install ≥v1.10.5](https://developer.hashicorp.com/terraform/downloads))
2. **AWS Account** with IAM credentials:
   ```bash
   # Configure AWS CLI (if not using instance profiles)
   aws configure
   ```
3. **Terraform Cloud Account** (for remote state)


## Project Structure
```bash
Terraform/
├── backend/                  
│   ├── dynamo.tf            # DynamoDB table for state locking
│   ├── s3-bucket-matter.tf  # S3 Bucket with encryption & versioning for remote state
│   ├── variable.tf
├── modules/
│   ├── compute/             # Compute resources & ASG configurations
│   │   ├── launch-templates.tf
│   │   ├── asg-wordpress-tooling.tf
│   │   ├── infra-instances.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking/          # VPC, subnets, NAT & Internet Gateway
│   │   ├── vpc.tf
│   │   ├── subnets.tf
│   │   ├── natgateway.tf
│   │   ├── internet_gateway.tf
│   │   ├── route_tables.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/            # Security groups, IAM roles/policies, certificates
│   │   ├── security_groups.tf
│   │   ├── roles-and-policy.tf
│   │   ├── certs.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── load-balancers/      # ALBs and target groups
│   │   ├── loadbalancers.tf
│   │   ├── target-groups.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage/             # RDS, EFS, and related outputs
│       ├── rds.tf
│       ├── efs.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf                  # Calls modules and sets up provider configuration [Terraform/main.tf](Terraform/main.tf)
├── variables.tf             # Global variable definitions [Terraform/variables.tf](Terraform/variables.tf)
├── terraform.auto.tfvars    # Variable values for the environment [Terraform/terraform.auto.tfvars](Terraform/terraform.auto.tfvars)
├── backend.tf               # Terraform backend configuration ([Terraform/backend.tf](Terraform/backend.tf))
└── terraform.tfstate.backup # Local backup of the Terraform state
```

---

## Getting Started
### 1. Clone the Repository
```bash
git clone https://github.com/your-org/terraform-project-19.git
cd terraform-project-19
```

### 2. Configure Terraform Cloud
1. Create a `terraform-cloud.auto.tfvars` file:
   ```hcl
   # terraform-cloud.auto.tfvars
   all the values you want to set for your terraform configs goes in here bro/sis
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```

### 3. Customize Variables
Update `terraform.auto.tfvars` with your AWS settings:
```hcl
# Example variables
region           = "eu-west-2"
vpc_cidr         = "10.0.0.0/16"
environment      = "prod"
rds_instance_class = "db.t3.micro"
```

### 4. Deploy Infrastructure
```bash
terraform plan  # Review changes
terraform apply # Deploy (type "yes" to confirm)
```

---

## Modules
| Module          | Description                          | Key Files |
|-----------------|--------------------------------------|-----------|
| **Networking**  | VPC, Subnets, NAT/Internet Gateways | `vpc.tf`, `subnets.tf` |
| **Security**    | IAM Roles, Security Groups, ACM     | `security_groups.tf`, `roles-and-policy.tf` |
| **Compute**     | EC2 Instances, Auto Scaling Groups  | `launch-templates.tf`, `asg-wordpress-tooling.tf` |
| **Storage**     | RDS, EFS                            | `rds.tf`, `efs.tf` |
| **Load Balancers** | ALBs, Listeners, Target Groups   | `loadbalancers.tf`, `target-groups.tf` |

---

## State Management
- **Remote Backend**: State is stored in Terraform Cloud (configured in `backend.tf`).
- **State Locking**: Enabled via Terraform Cloud to prevent concurrent modifications.
- **Local Backups**: A `terraform.tfstate.backup` is created for recovery.

To switch backends (e.g., S3):
```hcl
# backend.tf (Alternative S3 Backend)
terraform {
  backend "s3" {
    bucket         = "your-tf-state-bucket"
    key            = "project-19/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock"
  }
}
```

---

## Usage
### Common Commands
| Command | Description |
|---------|-------------|
| `terraform validate` | Validate configuration syntax |
| `terraform fmt` | Format code to canonical style |
| `terraform plan -out=tfplan` | Save plan to `tfplan` |
| `terraform apply tfplan` | Apply a saved plan |
| `terraform destroy` | Destroy all resources |

### Workspace Management
```bash
# Create a workspace for dev/staging
terraform workspace new dev
terraform workspace select dev
```

---

## Variables
### Key Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `region` | AWS region | `eu-west-2` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `environment` | Deployment environment | `prod` |

Override variables via:
1. `terraform.auto.tfvars` (auto-loaded)
2. Command line: `terraform apply -var="region=us-east-1"`

---

## Troubleshooting
| Issue | Solution |
|-------|----------|
| **Authentication Errors** | Verify AWS credentials in `~/.aws/credentials` |
| **State Locking Failed** | Manually unlock state in Terraform Cloud UI |
| **Module Not Found** | Run `terraform init` to refresh modules |
| **RDS Creation Failed** | Check subnets and security group rules |

---

## Contributing
1. Fork the repository.
2. Create a feature branch: `git checkout -b feat/new-module`.
3. Commit changes: `git commit -m "Add new module"`.
4. Push to the branch: `git push origin feat/new-module`.
5. Open a Pull Request.

---

## License
This project is licensed under the [MIT License](LICENSE).  
*For questions, contact [kosenuel@gmail.com](mailto:kosenuel@gmail.com).*

---
