# In this file, I try to define all the variables that I will use in the packer template file.

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "DevOps Team"
  }
}

variable "source_ami" {
  type    = string
  default = "ami-0f9535ac605dc21d5" # Bro, remember to replace with the latest RHEL AMI ID
}

variable "bastion_public_key" {
  type    = string
}
