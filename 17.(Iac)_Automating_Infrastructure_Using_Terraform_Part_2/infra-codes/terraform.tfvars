region                              = "eu-west-2"
vpc_cidr                            = "172.16.0.0/16"
enable_dns_support                  = "true"
enable_dns_hostnames                = "true"
preferred_number_of_public_subnets  = 2
preferred_number_of_private_subnets = 4
tags = {
  Environment = "production"
  Owner       = "Emmanuel@kosenuel.com"
  Terraform   = "true"
  Project     = "PBL"
}
domain_name   = "kosenuel.ip-ddns.com"
ami_id        = "ami-0aa938b5c246ef111"
key_name      = "Bukasiation's-SSH-Key"
instance_type = "t3.small"
db_user       = "kosenuel"
db_password   = "devopsacts"
rds_user      = "admin"
rds_password  = "devopsacts"


