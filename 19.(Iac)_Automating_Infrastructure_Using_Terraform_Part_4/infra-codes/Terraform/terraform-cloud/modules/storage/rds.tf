# Create DB Subnet Group
resource "aws_db_subnet_group" "project-rds" {
    name         = "project-rds"
    description  = "Project RDS Subnet Group"
    subnet_ids   = [var.private_subnets[0].id, var.private_subnets[1].id]

    tags = merge(
        var.tags,
        {
            Name = "project-rds"
        }
    )

}

# Create RDS Instance
resource "aws_db_instance" "project-rds" {
    allocated_storage      = 20
    storage_type           = "gp3"
    engine                 = "mysql"
    engine_version         = "8.0.35"
    instance_class         = "db.t3.micro"
    db_name                = "projectdb"
    username               = var.rds_user
    password               = var.rds_password
    parameter_group_name   = "default.mysql8.0"
    db_subnet_group_name   = aws_db_subnet_group.project-rds.name
    skip_final_snapshot    = true
    multi_az               = false
    vpc_security_group_ids = [var.datalayer-sg_id]

    tags = merge(
        var.tags,
        {
            Name = "project-rds"
        }
    )

}
