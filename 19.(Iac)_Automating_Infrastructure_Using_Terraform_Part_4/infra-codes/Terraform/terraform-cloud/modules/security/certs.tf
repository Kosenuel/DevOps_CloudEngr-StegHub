# Create ACM Certificate
# The wild card in the domain name is to register the cert to all the subdomains under the domain name specified in the variable.tf or terraform.tfvars file.
resource "aws_acm_certificate" "project_cert" {
    domain_name = format("*.%s", var.domain_name)
    validation_method = "DNS"
    key_algorithm = "RSA_2048"

    tags = merge(
        var.tags,
        {
            Name = format("%s-project-cert", var.domain_name)
        }
    )

    lifecycle {
        create_before_destroy = true
    }
    depends_on   = [aws_route53_zone.project_zone]
}

# Call in the hosted zone
# "aws_route53_zone" "project_zone" {
#     name = var.domain_name
#     private_zone = false
# }

# Create a public hosted zone
resource "aws_route53_zone" "project_zone" {
    name = var.domain_name
    comment = "Public hosted zone managed by Terraform - Kosenuel"
}

# Create the DNS record for the ACM certificate
resource "aws_route53_record" "project_cert_validation" {
    for_each = {
        for record in aws_acm_certificate.project_cert.domain_validation_options : record.domain_name => {
            name    = record.resource_record_name
            record  = record.resource_record_value
            type    = record.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = aws_route53_zone.project_zone.zone_id
    depends_on      = [aws_acm_certificate.project_cert, aws_route53_zone.project_zone]
}

# Validate the ACM certificate through DNS validation method
resource "aws_acm_certificate_validation" "project_cert" {
    certificate_arn         = aws_acm_certificate.project_cert.arn 
    validation_record_fqdns = [for record in aws_route53_record.project_cert_validation : record.fqdn]
    depends_on              = [aws_route53_record.project_cert_validation]
}

# Create Records for tooling
resource "aws_route53_record" "tooling" {
    zone_id = aws_route53_zone.project_zone.zone_id
    name    = format("tooling.%s", var.domain_name)
    type    = "A"

    alias {
        name                    = var.ext-alb-dns_name
        zone_id                 = var.ext-alb-zone_id 
        evaluate_target_health  = true
    }
}

# Create Records for Wordpress
resource "aws_route53_record" "wordpress" {
    zone_id = aws_route53_zone.project_zone.zone_id
    name    = format("wordpress.%s", var.domain_name)
    type    = "A"

    alias {
        name                    = var.ext-alb-dns_name
        zone_id                 = var.ext-alb-zone_id 
        evaluate_target_health  = true
    }
}

