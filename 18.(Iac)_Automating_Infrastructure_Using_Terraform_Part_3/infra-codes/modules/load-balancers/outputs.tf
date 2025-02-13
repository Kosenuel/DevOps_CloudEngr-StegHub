output "ext-alb-dns_name" {
    value = aws_lb.ext-alb.dns_name
}

output "int-alb-dns_name" {
    value = aws_lb.int-alb.dns_name
}

output "nginx-tgt_arn" {
    value = aws_lb_target_group.nginx-tgt.arn
}

output "wordpress-tgt_arn" {
    value = aws_lb_target_group.wordpress-tgt.arn
}

output "tooling-tgt_arn" {
    value = aws_lb_target_group.tooling-tgt.arn
}

output "ext-alb-zone_id" {
    value = aws_lb.ext-alb.zone_id
}
