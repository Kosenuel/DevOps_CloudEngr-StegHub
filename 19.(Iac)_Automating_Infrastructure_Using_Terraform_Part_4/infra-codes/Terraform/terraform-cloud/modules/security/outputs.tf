output "iam-instance-profile_name" {
    value = aws_iam_instance_profile.ip.name
}

output "compute-sg_id" {
    value = aws_security_group.compute-sg.id
}

output "ext-alb-sg_id" {
    value = aws_security_group.ext-alb-sg.id
}

output "int-alb-sg_id" {
    value = aws_security_group.int-alb-sg.id
}

output "bastion-sg_id" {
    value = aws_security_group.bastion-sg.id
}

output "nginx-sg_id" {
    value = aws_security_group.nginx-sg.id
}

output "webserver-sg_id" {
    value = aws_security_group.webserver-sg.id
}

output "datalayer-sg_id" {
    value = aws_security_group.datalayer-sg.id
}

output "cert" {
    value = aws_acm_certificate.project_cert
}

output "cert_arn" {
    value = aws_acm_certificate.project_cert.arn
}

output "kms-key_arn" {
    value = aws_kms_key.project-kms.arn
}
