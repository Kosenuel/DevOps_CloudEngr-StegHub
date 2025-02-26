provider "aws" {
  region = var.region
}

module "networking" {
  source                              = "./modules/networking"
  tags                                = var.tags
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  vpc_cidr                            = var.vpc_cidr
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_dns_support                  = var.enable_dns_support
}

module "security" {
  source           = "./modules/security"
  tags             = var.tags
  domain_name      = var.domain_name
  sg_rules         = var.sg_rules
  ext-alb-dns_name = module.load_balancers.ext-alb-dns_name
  ext-alb-zone_id  = module.load_balancers.ext-alb-zone_id
  vpc_id           = module.networking.vpc_id
}

module "load_balancers" {
  source          = "./modules/load-balancers"
  tags            = var.tags
  domain_name     = var.domain_name
  ext-alb-sg_id   = module.security.ext-alb-sg_id
  int-alb-sg_id   = module.security.int-alb-sg_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  cert_arn        = module.security.cert_arn
  vpc_id          = module.networking.vpc_id
}

module "storage" {
  source          = "./modules/storage"
  tags            = var.tags
  rds_user        = var.rds_user
  rds_password    = var.rds_password
  kms-key_arn     = module.security.kms-key_arn
  private_subnets = module.networking.private_subnets
  datalayer-sg_id = module.security.datalayer-sg_id
}

module "compute" {
  source                    = "./modules/compute"
  tags                      = var.tags
  ami-web                   = var.ami-web
  ami-bastion               = var.ami-bastion
  ami-nginx                 = var.ami-nginx
  ami-sonar                 = var.ami-sonar
  ami-jenkins               = var.ami-bastion
  ami-jfrog                 = var.ami-bastion
  instance_type             = var.instance_type
  key_name                  = var.key_name
  domain_name               = var.domain_name
  rds_user                  = var.rds_user
  rds_password              = var.rds_password
  db_user                   = var.db_user
  db_password               = var.db_password
  wordpress-tgt_arn         = module.load_balancers.wordpress-tgt_arn
  nginx-tgt_arn             = module.load_balancers.nginx-tgt_arn
  tooling-tgt_arn           = module.load_balancers.tooling-tgt_arn
  public_subnets            = module.networking.public_subnets
  private_subnets           = module.networking.private_subnets
  compute-subnet            = module.networking.public_subnets[0].id
  bastion-sg_id             = module.security.bastion-sg_id
  webserver-sg_id           = module.security.webserver-sg_id
  nginx-sg_id               = module.security.nginx-sg_id
  compute-sg_id             = module.security.compute-sg_id
  efs_id                    = module.storage.efs_id
  wordpress_ap              = module.storage.wordpress_ap
  tooling_ap                = module.storage.tooling_ap
  rds_endpoint              = module.storage.rds_endpoint
  iam-instance-profile_name = module.security.iam-instance-profile_name
  int-alb-dns_name          = module.load_balancers.int-alb-dns_name
}