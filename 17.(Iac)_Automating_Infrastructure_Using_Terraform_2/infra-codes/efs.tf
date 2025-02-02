# Create EFS File System
resource "aws_efs_file_system" "project-efs" {
    encrypted    = true
    kms_key_id   = aws_kms_key.project-kms.arn

    tags = merge(
        var.tags,
        {
            Name = "project-efs"
        }
    )
}

# Create Mount Targets in Private Subnets
resource "aws_efs_mount_target" "private-1" {
    file_system_id  = aws_efs_file_system.project-efs.id
    subnet_id       = aws_subnet.private[0].id
    security_groups = [aws_security_group.datalayer-sg.id]
}

resource "aws_efs_mount_target" "private-2" {
    file_system_id  = aws_efs_file_system.project-efs.id
    subnet_id       = aws_subnet.private[1].id
    security_groups = [aws_security_group.datalayer-sg.id]
}

# Create Access Points for the EFS
resource "aws_efs_access_point" "wordpress" {
    file_system_id  = aws_efs_file_system.project-efs.id

    posix_user {
        gid = 0
        uid = 0
    }

    root_directory {
        path = "/wordpress"
        creation_info {
            owner_gid = 0
            owner_uid = 0
            permissions = "755"
        }
    }

    tags = merge(
        var.tags,
        {
            Name = "wordpress-ap"
        }
    )
}

resource "aws_efs_access_point" "tooling" {
    file_system_id  = aws_efs_file_system.project-efs.id

    posix_user {
        gid = 0
        uid = 0
    }

    root_directory {
        path = "/tooling"
        creation_info {
            owner_gid = 0
            owner_uid = 0
            permissions = "755"
        }
    }

    tags = merge(
        var.tags,
        {
            Name = "tooling-ap"
        }
    )
}