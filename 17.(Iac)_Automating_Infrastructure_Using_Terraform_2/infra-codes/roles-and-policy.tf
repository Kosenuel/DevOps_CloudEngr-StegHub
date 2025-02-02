# Create a resource role
resource  "aws_iam_role" "ec2_instance_role"{
    name = "ec2_instance_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action      = "sts:AssumeRole"
                Effect      = "Allow"
                Sid         = ""
                Principal   = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = merge(
        var.tags,
        {
            Name = "aws assume role"
        }
    )
}

# Create an IAM Policy
resource "aws_iam_policy" "ec2_policy" {
    name                    = "ec2_instance_policy"
    description             = "This is a policy to grant access to all ec2 resource(s)" 
    policy                  = jsonencode({
        Version             = "2012-10-17"
        Statement           =[
            {
                Action      = [
                    "ec2:Describe*"
                ]
                Effect      = "Allow"
                Resource    = "*"
            }
        ]
    })

    tags = merge(
        var.tags,
        {
            Name    = "aws assume policy"
        }
    )
}

# Create KMS decrypt policy
resource "aws_iam_role_policy" "efs_kms_decrypt" {
    name = "AllowEFSToDecryptKMSKey"
    role = aws_iam_role.ec2_instance_role.name
    
    policy = jsonencode({
        Version          = "2012-10-17"
        Statement        = [
            {
                Action   = "kms:Decrypt"
                Effect   = "Allow"
                Resource = aws_kms_key.project-kms.arn
            }
        ]
    })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ec2-attach-policy" {
    role             = aws_iam_role.ec2_instance_role.name
    policy_arn       = aws_iam_policy.ec2_policy.arn
}

# Create Instance Profile
resource "aws_iam_instance_profile" "ip" {
    name              = "aws_iam_instance_profile_test"
    role              = aws_iam_role.ec2_instance_role.name
}

