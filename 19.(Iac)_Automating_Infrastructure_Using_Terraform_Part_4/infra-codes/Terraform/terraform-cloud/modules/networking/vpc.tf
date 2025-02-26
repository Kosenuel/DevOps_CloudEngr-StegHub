# Get list of availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.tags,
    {
      Name = "Production-VPC."
    }
  )
}

