# Dynamodb for state locking of the terraform file
resource "aws_dynamodb_table" "terraform_locks" {
    name            = "terraform-locks"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }

    tags = merge(
        var.tags,
        {
            Name = "TerraformLocksTable"
        }
    )
}