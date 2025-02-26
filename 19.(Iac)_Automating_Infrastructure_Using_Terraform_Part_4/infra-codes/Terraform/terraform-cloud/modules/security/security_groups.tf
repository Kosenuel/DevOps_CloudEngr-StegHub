# Create Kms key
resource "aws_kms_key" "project-kms" {
    description     = "KMS key for EFS"
    key_usage       = "ENCRYPT_DECRYPT"
}

##############################################
#              SECURITY GROUPS               #
##############################################

# Security group for external ALB
resource "aws_security_group" "ext-alb-sg"{
    name            = "ext-alb-sg"
    vpc_id          = var.vpc_id
    description     = "Allow HTTP/HTTPS/SSH inbound traffic"
    
    dynamic "ingress" {
        for_each = var.sg_rules["ext-alb-sg"]
        content {
            description = ingress.value.description
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
    
    egress {
        description = "Allow all traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name = "ext-alb-sg"
        }
    )

}

# Security group for Bastion Host
resource "aws_security_group" "bastion-sg"{
    name            = "bastion-sg"
    vpc_id          = var.vpc_id
    description     = "Security group for Bastion Host"

    dynamic "ingress" {
        for_each = var.sg_rules["bastion-sg"]
        content {
            description = ingress.value.description
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }

    egress {
        description = "Allow all traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name = "bastion-sg"
        }
    )

}

# Security group for Nginx EC2 instances
resource "aws_security_group" "nginx-sg"{
    name            = "nginx-sg"
    vpc_id          = var.vpc_id

    egress {
        description = "Allow all traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name = "nginx-sg"
        }
    )
}

# Security group for Internal ALB 
resource "aws_security_group" "int-alb-sg"{
    name              = "int-alb-sg"
    vpc_id            = var.vpc_id

    egress {
        from_port     = 0
        to_port       = 0
        protocol      = "-1"
        cidr_blocks   = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name = "int-alb-sg"
        }
    )
}

# Security group for Webserver EC2 instances
resource "aws_security_group" "webserver-sg"{
    name               = "webserver-sg"
    vpc_id             = var.vpc_id

    egress {
        description    = "Allow all traffic"
        from_port      = 0
        to_port        = 0
        protocol       = "-1"
        cidr_blocks    = ["0.0.0.0/0"]
    }
}

# Security group for Data Layer
resource "aws_security_group" "datalayer-sg" {
    name                = "datalayer-sg"
    vpc_id              = var.vpc_id

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name        = "datalayer-sg"
        }
    )
}

# Security group for other compute resources
resource "aws_security_group" "compute-sg" {
    name = "compute-sg"
    vpc_id = var.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.tags,
        {
            Name = "compute-sg"
        }
    )
}



##############################################
#          SECURITY GROUP RULES              #
##############################################
# Security group rules for other Compute resources
resource "aws_security_group_rule" "inbound-bastion-ssh-compute" {
    description = "Allow Bastion Server to connect to other Compute resources via ssh"
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.compute-sg.id
}

resource "aws_security_group_rule" "inbound-artifactory-comms-compute" {
    description = "Allow Clients from the internet to access compute resources via artifactory port"
    type = "ingress"
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.compute-sg.id
}

resource "aws_security_group_rule" "inbound-jenkins-comms-compute" {
    description = "Allow Clients from the internet communicate with compute resources via the Jenkins default port"
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.compute-sg.id
}

# Security group rules for Nginx EC2 instances
resource "aws_security_group_rule" "inbound-nginx-https" {
    description       = "Allow Https traffic from external Alb security group"
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    source_security_group_id = aws_security_group.ext-alb-sg.id # Allow Https traffic from external ALB security group
    security_group_id = aws_security_group.nginx-sg.id
}

resource "aws_security_group_rule" "inbound-nginx-http" {
    description       = "Allow Http traffic from external Alb security group"
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    source_security_group_id = aws_security_group.ext-alb-sg.id # Allow Http traffic from external ALB security group
    security_group_id = aws_security_group.nginx-sg.id
}

resource "aws_security_group_rule" "inbound-bastion-ssh" {
    description       = "Allow SSH traffic from Bastion Host"
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow traffic from Bastion Host security group 
    security_group_id = aws_security_group.nginx-sg.id
}

# Security group rules for Internal ALB
resource "aws_security_group_rule" "inbound-ialb-https"{
    description        = "Allow HTTPS traffic from nginx security group"
    type               = "ingress"
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    source_security_group_id = aws_security_group.nginx-sg.id # Allow traffic from Nginx security group 
    security_group_id  = aws_security_group.int-alb-sg.id
}

resource "aws_security_group_rule" "inbound-ialb-http"{
    description        = "Allow Http traffic from nginx security group"
    type               = "ingress"
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    source_security_group_id = aws_security_group.nginx-sg.id # Allow traffic from Nginx security group 
    security_group_id  = aws_security_group.int-alb-sg.id
}

# Security group rules for Webserver EC2 instances
resource "aws_security_group_rule" "inbound-web-https" {
    description        = "Allow HTTPS traffic from Internal ALB" 
    type               = "ingress"
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    source_security_group_id = aws_security_group.int-alb-sg.id # Allow traffic from Internal ALB security group 
    security_group_id  = aws_security_group.webserver-sg.id
}

resource "aws_security_group_rule" "inbound-web-http" {
    description        = "Allow HTTP traffic from bastion Security group for testing purposes" 
    type               = "ingress"
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow Http traffic from Bastion security group 
    security_group_id  = aws_security_group.webserver-sg.id
}

resource "aws_security_group_rule" "inbound-web-http-intAlb" {
    description        = "Allow HTTP traffic from Internal application load balancer Security group" 
    type               = "ingress"
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    source_security_group_id = aws_security_group.int-alb-sg.id # Allow Http traffic from Internal Alb security group 
    security_group_id  = aws_security_group.webserver-sg.id
}

resource "aws_security_group_rule" "inbound-web-ssh" {
    description        = "Allow SSH traffic from Bastion Host"
    type               = "ingress"
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow ssh traffic from Bastion Host security group
    security_group_id  = aws_security_group.webserver-sg.id
}

# Security Group Rules for Data Layer Security Group
resource "aws_security_group_rule" "inbound-nfs-port" {
    description          = "Allow NFS traffic from Webserver" 
    type                 = "ingress"
    from_port            = 2049
    to_port              = 2049
    protocol             = "tcp"
    source_security_group_id = aws_security_group.webserver-sg.id # Allow nfs traffic from webserver security group 
    security_group_id    = aws_security_group.datalayer-sg.id
}

resource "aws_security_group_rule" "inbound-mysql-bastion" {
    description          = "Allow MySQL traffic from Bastion Host"
    type                 = "ingress"
    from_port            = 3306
    to_port              = 3306
    protocol             = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow traffic from Bastion Host security group
    security_group_id    = aws_security_group.datalayer-sg.id
}

resource "aws_security_group_rule" "inbound-mysql-webserver" {
    description          = "Allow MySQL traffic from Webserver"
    type                 = "ingress"
    from_port            = 3306
    to_port              = 3306
    protocol             = "tcp"
    source_security_group_id = aws_security_group.webserver-sg.id # Allow traffic from Webserver security group 
    security_group_id    = aws_security_group.datalayer-sg.id
}
 