# terraform {
#   backend "s3" {
#     bucket         = "kosenuel-prod-tf-state-bucket"
#     key            = "global/s3/terraform.tfstate"
#     region         = "eu-west-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = "true"
#   }
# } 

terraform {
  backend "remote" {
    organization = "kosenuel-org"

    workspaces {
      name = "github-terraform-cloud"
    }
  }
}