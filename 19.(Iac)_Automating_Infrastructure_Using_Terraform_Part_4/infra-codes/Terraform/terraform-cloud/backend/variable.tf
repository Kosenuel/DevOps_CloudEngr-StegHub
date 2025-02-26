variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "Emmanuel Okose"
    Terraform   = "true"
    Project     = "PBL"
  }
}