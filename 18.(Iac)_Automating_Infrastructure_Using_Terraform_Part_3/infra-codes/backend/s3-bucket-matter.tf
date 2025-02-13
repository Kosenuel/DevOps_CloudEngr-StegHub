# AWS S3 Buket for storing Terraform state 
resource "aws_s3_bucket" "terraform_state" {
    bucket          = "kosenuel-prod-tf-state-bucket"
    force_destroy   = "true"

    tags = merge(
        var.tags,
        {
            Name = "Terraform State Bucket"
        }
    )
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "state_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    
    versioning_configuration {
        status = "Enabled"
    }
}

# Let us Enforce server-side encryption for the S3 bucket resource by:
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}


