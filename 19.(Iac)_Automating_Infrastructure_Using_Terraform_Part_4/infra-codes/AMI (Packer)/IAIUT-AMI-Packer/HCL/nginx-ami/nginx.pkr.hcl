# Packer HCL Configuration
# Create a local variable to generate a timestamp for unique AMI naming
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") # Remove special characters from the timestamp
}

# Define the Amazon EBS builder configuration
source "amazon-ebs" "terraform-nginx-prj-19" {
  ami_name      = "terraform-nginx-prj-19-${local.timestamp}" # Unique AMI name with timestamp
  instance_type = "t2.micro"                                  # Instance type to use for building the AMI
  region        = var.region                                  # AWS region to build the AMI in
  source_ami    = var.source_ami
  ssh_username  = "ec2-user" # Default SSH username for RHEL-based AMIs

  # Add tags to the AMI for better identification
  tags = merge(
    var.tags,
    {
      Name = "terraform-nginx-prj-19"
    }
  )
}

# Define the build process
build {
  sources = ["source.amazon-ebs.terraform-nginx-prj-19"] # Use the defined source block

  # Provision the instance
  provisioner "shell" {
    script = "nginx.sh" # Path to the shell script for installing and configuring Nginx
    environment_vars = [
      "BASTION_PUBLIC_KEY=${var.bastion_public_key}"
    ]
  }
}