# Create EFS File System
resource "aws_efs_file_system" "project-efs" {
    encrypted    = true
    kms_key_id   = var.kms-key_arn

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
    subnet_id       = var.private_subnets[0].id
    security_groups = [var.datalayer-sg_id]
}

resource "aws_efs_mount_target" "private-2" {
    file_system_id  = aws_efs_file_system.project-efs.id
    subnet_id       = var.private_subnets[1].id
    security_groups = [var.datalayer-sg_id]
}

resource "aws_efs_mount_target" "private-3" {
    file_system_id  = aws_efs_file_system.project-efs.id
    subnet_id       = var.private_subnets[2].id
    security_groups = [var.datalayer-sg_id]
}

# Create Access Point - wordpress
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

# Create Access Point - tooling
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