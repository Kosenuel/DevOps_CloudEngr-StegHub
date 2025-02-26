# Packer HCL Configuration
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "terraform-ubuntu-prj-19" {
  ami_name      = "terraform-ubuntu-prj-19-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"
  tags = merge(
    var.tags,
    {
      Name = "terraform-ubuntu-prj-19"
    }
  )
}

build {
  sources = ["source.amazon-ebs.terraform-ubuntu-prj-19"]

  provisioner "shell" {
    script = "ubuntu.sh"
    environment_vars = [
      "BASTION_PUBLIC_KEY=${var.bastion_public_key}"
    ]
  }

}