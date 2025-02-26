output "rds_endpoint" {
    value = aws_db_instance.project-rds.endpoint
}

output "efs_id" {
    value = aws_efs_file_system.project-efs.id
}

output "wordpress_ap" {
    value = aws_efs_access_point.wordpress.id
}

output "tooling_ap" {
    value = aws_efs_access_point.tooling.id
}