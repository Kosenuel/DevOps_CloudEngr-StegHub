# Get list of availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create SNS topic for all auto scaling groups
resource "aws_sns_topic" "project-sns" {
    name = "Default_CloudWatch_Alarms_Topic"
}

# Create SNS topic subscription for all auto scaling groups 
resource "aws_autoscaling_notification" "project_notifications" {
    group_names = [
        aws_autoscaling_group.wordpress-asg.name,
        aws_autoscaling_group.tooling-asg.name,
        aws_autoscaling_group.nginx-asg.name
    ]
    notifications = [
        "autoscaling:EC2_INSTANCE_LAUNCH",
        "autoscaling:EC2_INSTANCE_TERMINATE",
        "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
        "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
    ]
    topic_arn = aws_sns_topic.project-sns.arn
}

# Random Shuffler
resource "random_shuffle" "az_list" {
    input = data.aws_availability_zones.available.names
}

# Create Wordpress ASG (Auto Scaling Group)
resource "aws_autoscaling_group" "wordpress-asg" {
    name                = "wordpress-asg"
    max_size            = 2
    min_size            = 1
    desired_capacity    = 1
    health_check_grace_period = 915
    health_check_type   = "ELB"
    vpc_zone_identifier = [
        var.private_subnets[1].id, 
        var.private_subnets[2].id,
        var.private_subnets[3].id,
        var.private_subnets[0].id
        ]
    target_group_arns   = [var.wordpress-tgt_arn]

    launch_template {
        id             = aws_launch_template.wordpress-launch-template.id
        version        = "$Latest"
    }

    tag {
        key             = "Name"
        value           = "wordpress-asg"
        propagate_at_launch = true
    }

}

# Create Nginx ASG (Auto Scaling Group)
resource "aws_autoscaling_group" "nginx-asg" {
    name                = "nginx-asg"
    max_size            = 2
    min_size            = 1
    desired_capacity    = 1
    health_check_grace_period = 300
    health_check_type   = "ELB"
    vpc_zone_identifier = [
        var.private_subnets[1].id, 
        var.private_subnets[2].id,
        var.private_subnets[3].id,
        var.private_subnets[0].id
        ]
    target_group_arns   = [var.nginx-tgt_arn]

    launch_template {
        id             = aws_launch_template.nginx-launch-template.id
        version        = "$Latest"
    }

    tag {
        key             = "Name"
        value           = "nginx-asg"
        propagate_at_launch = true
    }

}

# Create Tooling ASG (Auto Scaling Group)
resource "aws_autoscaling_group" "tooling-asg" {
    name                = "tooling-asg"
    max_size            = 2
    min_size            = 1
    desired_capacity    = 1
    health_check_grace_period = 915
    health_check_type   = "ELB"
    vpc_zone_identifier = [
        var.private_subnets[1].id, 
        var.private_subnets[2].id,
        var.private_subnets[3].id,
        var.private_subnets[0].id
        ]
    target_group_arns   = [var.tooling-tgt_arn]

    launch_template {
        id              = aws_launch_template.tooling-launch-template.id
        version         = "$Latest"

    }

    tag {
        key             = "Name"
        value           = "tooling-asg"
        propagate_at_launch = true
    }
}


# Scale Up Policy - WordPress
resource "aws_autoscaling_policy" "wordpress-scale-up" {
    name                    = "wordpress-scale-up"
    scaling_adjustment      = 1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 915
    autoscaling_group_name  = aws_autoscaling_group.wordpress-asg.name
}

# Scale Down Policy - WordPress
resource "aws_autoscaling_policy" "wordpress-scale-down" {
    name                    = "wordpress-scale-down"
    scaling_adjustment      = -1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = aws_autoscaling_group.wordpress-asg.name
}

# CloudWatch Metric Alarm - WordPress Scale Up 
resource "aws_cloudwatch_metric_alarm" "wordpress-cpu-alarm-up" {
    alarm_name              = "wordpress-cpu-alarm-up"
    comparison_operator     = "GreaterThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "60"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.wordpress-asg.name
    }

    alarm_description        = "This metric monitors the CPU utilization of the WordPress ASG"
    alarm_actions            = [aws_autoscaling_policy.wordpress-scale-up.arn]
}

# CloudWatch Metric Alarm - WordPress Scale Down
resource "aws_cloudwatch_metric_alarm" "wordpress-cpu-alarm-down" {
    alarm_name              = "wordpress-cpu-alarm-down"
    comparison_operator     = "LessThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "20"

    dimensions              = {
        AutoScalingGroupName = aws_autoscaling_group.wordpress-asg.name
    }

    alarm_description        = "This metric monitors the CPU utilization of the WordPress ASG to scale down when CPU usage is low"
    alarm_actions            = [aws_autoscaling_policy.wordpress-scale-down.arn]
}

# Scale Up Policy - Tooling
resource "aws_autoscaling_policy" "tooling-scale-up" {
    name                    = "tooling-scale-up"
    scaling_adjustment      = 1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 915
    autoscaling_group_name  = aws_autoscaling_group.tooling-asg.name
}

# Scale Down Policy - Tooling
resource "aws_autoscaling_policy" "tooling-scale-down" {
    name                    = "tooling-scale-down"
    scaling_adjustment      = -1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = aws_autoscaling_group.tooling-asg.name
}

# CloudWatch Metric Alarm - Tooling Scale Up
resource "aws_cloudwatch_metric_alarm" "tooling-cpu-alarm-up" {
    alarm_name              = "tooling-cpu-alarm-up"
    comparison_operator     = "GreaterThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "60"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.tooling-asg.name
    }

    alarm_description        = "This metric monitors the CPU utilization of the Tooling ASG"
    alarm_actions            = [aws_autoscaling_policy.tooling-scale-up.arn]
}

# CloudWatch Metric Alarm - Tooling Scale Down
resource "aws_cloudwatch_metric_alarm" "tooling-cpu-alarm-down" {
    alarm_name              = "tooling-cpu-alarm-down"
    comparison_operator     = "LessThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "20"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.tooling-asg.name
    }

    alarm_description       = "This metric monitors the CPU utilization of the Tooling ASG to scale down when CPU usage is low"
    alarm_actions           = [aws_autoscaling_policy.tooling-scale-down.arn]
}

# Scale Up Policy - Nginx
resource "aws_autoscaling_policy" "nginx-scale-up" {
    name                    = "nginx-scale-up"
    scaling_adjustment      = 1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = aws_autoscaling_group.nginx-asg.name
}

# Scale Down Policy - Nginx
resource "aws_autoscaling_policy" "nginx-scale-down" {
    name                    = "nginx-scale-down"
    scaling_adjustment      = -1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = aws_autoscaling_group.nginx-asg.name
}

# CloudWatch Metric Alarm - Nginx
resource "aws_cloudwatch_metric_alarm" "nginx-cpu-alarm-up" {
    alarm_name              = "nginx-cpu-alarm-up"
    comparison_operator     = "GreaterThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "60"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.nginx-asg.name
    }

    alarm_description        = "This metric monitors the CPU utilization of the Nginx ASG"
    alarm_actions            = [aws_autoscaling_policy.nginx-scale-up.arn]
}

# CloudWatch Metric Alarm - Nginx Scale Down
resource "aws_cloudwatch_metric_alarm" "nginx-cpu-alarm-down" {
    alarm_name              = "nginx-cpu-alarm-down"
    comparison_operator     = "LessThanOrEqualToThreshold"
    evaluation_periods      = 2
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "20"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.nginx-asg.name
    }

    alarm_description       = "This metric monitors the CPU utilization of the Nginx ASG to scale down when CPU usage is low"
    alarm_actions           = [aws_autoscaling_policy.nginx-scale-down.arn]
}