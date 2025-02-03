variable "region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "preferred_number_of_public_subnets" {
  default = null
}
variable "preferred_number_of_private_subnets" {
  default = null
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "I.T. Admin"
    Terraform   = "true"
    Project     = "PBL"
  }
}

variable "domain_name" {
  description = "The domain name to use for the ACM certificate"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances"
  type        = string
}

variable "instance_type"{
  description = "The instance type to use for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for the EC2 instances"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "rds_user" {
  description = "The username for the RDS instance"
  type        = string
}

variable "rds_password" {
  description = "The password for the RDS instance"
  type        = string
}
