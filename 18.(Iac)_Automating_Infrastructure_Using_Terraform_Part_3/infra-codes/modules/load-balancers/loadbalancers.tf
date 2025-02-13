# Create External Application Load Balancer
resource "aws_lb" "ext-alb" {
    name               = "ext-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.ext-alb-sg_id]
    subnets            = [for subnet in var.public_subnets : subnet.id]

    tags = merge(
        var.tags,
        {
            Name = "ext-alb"
        }
    ) 
}

# Create External ALB Listener
resource "aws_lb_listener" "ext-alb-listener" {
    load_balancer_arn   = aws_lb.ext-alb.arn
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = var.cert_arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.nginx-tgt.arn
    }
    # depends_on            = [module.security]
}


# Create Internal Application Load Balancer
resource "aws_lb" "int-alb" {
    name                 = "int-alb"
    internal             = true
    load_balancer_type   = "application"
    security_groups      = [var.int-alb-sg_id]
    subnets              = [
        var.private_subnets[0].id,
        var.private_subnets[1].id,
        var.private_subnets[2].id
    ]

    tags = merge(
        var.tags,
        {
            Name = "int-alb"
        }
    )
}

# Create Internal ALB Listener
resource "aws_lb_listener" "int-alb-listener" {
    load_balancer_arn   = aws_lb.int-alb.arn
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = var.cert_arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.wordpress-tgt.arn
    }
}

# Load Balancer Rules
## Listener Rule for tooling
resource "aws_lb_listener_rule" "tooling-listener" {
    listener_arn = aws_lb_listener.int-alb-listener.arn
    priority     = 99

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tooling-tgt.arn
    }

    condition {
        host_header {
            values = [format("tooling.%s", var.domain_name)]
        }
    }
}
