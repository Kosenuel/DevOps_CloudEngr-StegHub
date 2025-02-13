variable "sg_rules" {
    description         = "Map of security group rules"
     type = map(list(object({
        description              = string
        from_port                = number
        to_port                  = number
        protocol                 = string
        cidr_blocks              = optional(list(string))
        source_security_group_id = optional(string)
    })))
}

variable "tags" {
    description = "Tags to be assigned to resources"
    type        = map(string)
}

variable "domain_name" {
    description = "This is the domain name that would be used in the ACM cetificate"
    type        = string
}

variable "ext-alb-dns_name" {
    description = "DNS name of the external application load balancer"
    type        = string
}

variable "ext-alb-zone_id" {
    description = "Zone ID of the external application load balancer"
    type        = string
}

variable "vpc_id" {
    description = "ID of the VPC where the security groups would be created in"
    type        = string
}
