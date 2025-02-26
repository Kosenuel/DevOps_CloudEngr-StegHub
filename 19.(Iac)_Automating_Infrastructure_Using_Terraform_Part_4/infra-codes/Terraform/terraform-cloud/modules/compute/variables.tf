variable "tags" {
    description = "This is the tags that helps in categorizing resources etc..."
    type        = map(string)
}

# variable "region" {
#     description = "AWS Region"
#     type        = string
#     default     = "us-west-2"
# }

variable "ami-web" {
    description = "Amazon Machine Image for provisioning the Web Servers (wordpress and tooling)"
    type        = string
}

variable "ami-nginx" {
    description = "Amazon Machine Image for provisioning the Nginx Server"
    type        = string
}

variable "ami-bastion" {
    description = "Amazon Machine Image for provisioning the Bastion Server"
    type        = string
}

variable "ami-jenkins" {
    description = "Amazon Machine Image for provisioning the Jenkins server"
    type        = string
}

variable "ami-jfrog" {
    description = "Amazon Machine Image for provisioning the Artifactory server"
    type        = string
}

variable "ami-sonar" {
    description = "Amazon Machine Image for provisioning the SonarQube server"
    type        = string
}

# variable "images" {
#     description = "Map of region to AMI IDs"
#     type        = map (string)
#     default = {
#         "eu-west-1" = "ami-009f51225716cb42f" #CentOs
#         "eu-west-2" = "ami-0aa938b5c246ef111" #CentOs
#     }
# }

variable "instance_type" {
    description = "The type of instance to create"
    type        = string
}

variable "key_name" {
    description = "The SSH key to use in signing into the vm"
    type        = string
}

variable "domain_name"{
    description = "The domain name to use in the ACM certification"
    type        = string
}

variable "rds_user" {
    description = "The rds user of the rds username"
    type        = string
}

variable "rds_password" {
    description = "The password for the rds password"
    type        = string

}

variable "db_user" {
    description = "Application database username"
    type        = string
}

variable "db_password" {
    description = "Application database user password"
    type        = string
}

variable "wordpress-tgt_arn" {
    description = "WordPress target group aws resource name"
    type        = string
}

variable "nginx-tgt_arn" {
    description = "Nginx target group aws resource name"
    type        = string
}

variable "tooling-tgt_arn" {
    description = "Tooling target group aws resource name"
    type        = string
}

variable "compute-subnet" {
    type = string
    description = "This is the Subnet for the Compute Resources"
}

variable "public_subnets" {
    description = "A list of public subnets"
    type        = list(object({
        id = string
    }))
}

variable "private_subnets" {
    description = "A list of private subnets"
    type        = list(object({
        id = string
    }))
}

variable "compute-sg_id" {
    description = "This is the ID for the compute security group"
    type    = string
}

variable "bastion-sg_id" {
    description = "ID for the bastion security group"
    type        = string
}

variable "webserver-sg_id" {
    description = "ID for the webserver security group"
    type        = string
}

variable "nginx-sg_id" {
    description = "ID for the webserver security group"
    type        = string
}

variable "efs_id" {
    description = "EFS ID for mounting access points"
    type        = string
}

variable "wordpress_ap" {
    description = "WordPress access point"
    type        = string
}

variable "tooling_ap" {
    description = "Tooling access point"
    type        = string
}

variable "rds_endpoint" {
    description = "Endpoint for accessing the rds database"
    type        = string
}

variable "iam-instance-profile_name" {
    description = "The Name for the Instance profile to attach roles to"
    type        = string
}

variable "int-alb-dns_name" {
    description = "DNS name of the internal application load balancer"
    type        = string
}
