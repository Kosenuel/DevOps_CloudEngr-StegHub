variable "region" {
    description = "AWS region"
    type        = string
    default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "Cidr block for the VPC"
  default     = "172.16.0.0/16"
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  default     = "true"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  default     = "true"
}

variable "preferred_number_of_public_subnets" {
  description = "Preferred number of public subnets"
  default     = null
}
variable "preferred_number_of_private_subnets" {
  description = "Preferred number of private subnets"
  default     = null
}

variable "sg_rules" {
  description = "Map of security group rules"
  type = map(list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  })))
  default = {}
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

variable "instance_type" {
  description = "The instance type to use for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for the EC2 instances"
  type        = string
}

variable "db_user" {
  description = "The DB user"
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

