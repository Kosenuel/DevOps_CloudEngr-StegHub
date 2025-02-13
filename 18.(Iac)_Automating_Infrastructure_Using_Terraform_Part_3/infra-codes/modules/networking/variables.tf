variable "tags" {
    description = "Tags used to categorize resources"
    type        = map(string)
}

variable "preferred_number_of_private_subnets" {
    description = "As the name implies"
    type        = number
}

variable "preferred_number_of_public_subnets" {
    description = "As the name implies"
    type        = number
}

variable "vpc_cidr" {
    description = "The Cidr network block for the vpc"
    type        = string
}

variable "enable_dns_support" {
    description = "Do you want the vpc to support dns operations?"
    type        = string
}

variable "enable_dns_hostnames" {
    description = "Do you want the vpc to support dns hostnames operations?"
    type        = string
}