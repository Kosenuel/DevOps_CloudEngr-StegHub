variable "tags" {
    description = "Tags to be assigned to resources"
    type        = map(string)
}

variable "rds_user" {
    description = "The RDS user username"
    type        = string
}

variable "rds_password" {
    description = "The RDS user password"
    type        = string
}

variable "kms-key_arn" {
    description = "The KMS key"
    type        = string
}

variable "private_subnets" {
    description = "A list of private subnets"
    type        = list(object({
        id = string
    }))
}

variable "datalayer-sg_id" {
    description = "ID of the datalayer security group"
    type        = string
}
