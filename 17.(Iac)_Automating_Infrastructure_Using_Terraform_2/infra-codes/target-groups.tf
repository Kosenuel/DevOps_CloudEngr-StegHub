# Nginx Target Group
resource "aws_lb_target_group" "nginx-tgt" {
    name                = "nginx-tgt"
    port                = 80
    protocol            = "HTTP"
    vpc_id              = aws_vpc.main.id
    target_type         = "instance"

    health_check {
        interval        = 10
        path            = "/healthz"
        healthy_threshold = 2
        unhealthy_threshold = 7
        timeout         = 5
    }

    tags = merge(
        var.tags,
        {
            Name = "nginx-tgt"
        }
    )
}

# Wordpress Target Group
resource "aws_lb_target_group" "wordpress-tgt" {
    name                = "wordpress-tgt"
    port                = 80
    protocol            = "HTTP"
    vpc_id              = aws_vpc.main.id
    target_type         = "instance"

    health_check {
        interval        = 10
        path            = "/healthz"
        healthy_threshold = 2
        unhealthy_threshold = 7
        timeout         = 5
    }

    tags = merge(
        var.tags,
        {
            Name = "wordpress-tgt"
        }
    )
}

# Tooling Target Group
resource "aws_lb_target_group" "tooling-tgt" {
    name                = "tooling-tgt"
    port                = 80
    protocol            = "HTTP"
    vpc_id              = aws_vpc.main.id
    target_type         = "instance"

    health_check {
        interval        = 10
        path            = "/healthz"
        healthy_threshold = 2
        unhealthy_threshold = 7
        timeout         = 5
    }

    tags = merge(
        var.tags,
        {
            Name = "tooling-tgt"
        }
    )
}

