region = "eu-west-2"

tags = {
    Owner = "DevOps Team"
    Project = "Terraform-Cloud"
    Environment = "dev"
}

bastion_public_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbu3oTQ+kFdfzl+byd7QKKE+9TcWi+9AOy0/nl7s0AyI10WNkKfOs4eD08vj1trMqx7K7MipWC+ofetCXl3hC9NgXaUNYqMTDnaAkqOspx1wwsDHUxriJ111lp2W7XIC4fVvBfCTmL8nrNTHH72nSQR9nqomx3rIc9K9PBZHDoo2Fcbl1fOSjlLaUSUsX8JX5FPvDBpatb391SCCsauUZ8uUGKtEfvoYfWJzbwAyAHBfIsy7EaP7CkX+/ETSFiP0rFveqKI+4Dem4ZDS4XexXFscHWfQxy8bHF7Npd833LFQcNbajyAzuza1C2T6lGvSPY83WjCkSoo8kmef6/hWUq+htwp+kUMdEZegUpbNlBy5769XcGNpK0CIazM7XVWM4/j7P/R46MnLp60MBesam2YuafI0BYk4GYoORIWIYTtABXBABxCuxRvD/LRYBAmfQLZmKv+Xk9SzhwQce7pfMeSfYL7fNdgbOIzzIxhIQGkC9mQaHeeZll7GdPGejwg4o7d+WlCR5lYGhZ+/NC0Dl9HwFxEwE2Su4JIZd+jjGJImwHUvb1DZ/QnW1zc0O5pIzl1agtdPIouC1h241x6Sy0NL6U5FTncOyGBuUb9R/G1HNMamDxl9Bf0/rNUO2Cjggim5kfI98Hq/D5AD7PPRZZeq9Fg1wOKhCbjKh2eAFWaQ== ec2-user@ip-172-31-21-68.eu-west-2.compute.internal"
source_ami           = "ami-0f9535ac605dc21d5" # Bro, remember to replace with the latest RHEL AMI ID. This is for web instances.
source_ami_ubuntu    = "ami-091f18e98bc129c4e" # Bro, remember to replace with the latest Ubuntu AMI ID
source_ami_bastion   = "ami-0aa938b5c246ef111" # Bro, remember to replace with the latest CentOs AMI ID