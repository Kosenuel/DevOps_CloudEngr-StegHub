terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
    region = "eu-west-2"
}

terraform { 
  cloud { 
    
    organization = "kosenuel-org" 

    workspaces { 
      name = "s3-webapp-workspace" 
    } 
  } 
}

module "webapp-terraform" {
    source  = "app.terraform.io/kosenuel-org/webapp-terraform/s3"
    version = "1.0.0"
    
    prefix      = "kosenuel"
    name        = "webapp"
    region      = "eu-west-2"
}