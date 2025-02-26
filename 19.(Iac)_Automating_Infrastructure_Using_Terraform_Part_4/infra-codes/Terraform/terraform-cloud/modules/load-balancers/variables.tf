variable "tags" {
    description = "Tags used to categorize resources"
    type = map(string)
}

variable "domain_name" {
    description = "Domain name for the project"
    type        = string
}

variable "ext-alb-sg_id" {
    description = "External application load balancer security group ID"
    type        = string
}

variable "int-alb-sg_id" {
    description = "Internal application load balancer security group ID"
    type        = string
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

variable "cert_arn" {
    description = "Resource name for the Certificate in ACM"
    type        = string
}

variable "vpc_id" {
    description = "ID of the Virtual Private Network in which the load balancers will reside in"
    type        = string
}