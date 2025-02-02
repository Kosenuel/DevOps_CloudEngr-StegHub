# Create Kms key
resource "aws_kms_key" "project-kms" {
    description     = "KMS key for EFS"
    key_usage       = "ENCRYPT_DECRYPT"
}

# Security group for external ALB
resource "aws_security_group" "ext-alb-sg"{
    name            = "ext-alb-sg"
    vpc_id          = aws_vpc.main.id
    description     = "Allow HTTP/HTTPS/SSH inbound traffic"

    ingress {
        description = "HTTP from the internet"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS from the internet"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH from the internet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
    vpc_id          = aws_vpc.main.id
    description     = "Security group for Bastion Host Secure Shell (SSH) access"

    ingress {
        description = "Allow SSH from the internet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTP traffic from the internet"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
    vpc_id          = aws_vpc.main.id

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

# Security group rules for Nginx EC2 instances
resource "aws_security_group_rule" "inbound-nginx-https" {
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    source_security_group_id = aws_security_group.ext-alb-sg.id # Allow traffic from external ALB security group
    security_group_id = aws_security_group.nginx-sg.id
}

resource "aws_security_group_rule" "inbound-bastion-ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow traffic from Bastion Host security group 
    security_group_id = aws_security_group.nginx-sg.id
}

# Security group for Internal ALB 
resource "aws_security_group" "int-alb-sg"{
    name              = "int-alb-sg"
    vpc_id            = aws_vpc.main.id

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

# Security group rules for Internal ALB
resource "aws_security_group_rule" "inbound-ialb-https"{
    type               = "ingress"
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    source_security_group_id = aws_security_group.nginx-sg.id # Allow traffic from Nginx security group 
    security_group_id  = aws_security_group.int-alb-sg.id
}

# Security group for Webserver EC2 instances
resource "aws_security_group" "webserver-sg"{
    name               = "webserver-sg"
    vpc_id             = aws_vpc.main.id

    egress {
        description    = "Allow all traffic"
        from_port      = 0
        to_port        = 0
        protocol       = "-1"
        cidr_blocks    = ["0.0.0.0/0"]
    }
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
    description        = "Allow HTTP traffic from bastion Security group for testing purposes" 
    type               = "ingress"
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    source_security_group_id = aws_security_group.int-alb-sg.id # Allow Http traffic from Bastion security group 
    security_group_id  = aws_security_group.webserver-sg.id
}

resource "aws_security_group_rule" "inbound-web-ssh" {
    description        = "Allow SSH traffic from Bastion Host"
    type               = "ingress"
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id # Allow traffic from Bastion Host security group
    security_group_id  = aws_security_group.webserver-sg.id
}

# Security group for Data Layer
resource "aws_security_group" "datalayer-sg" {
    name                = "datalayer-sg"
    vpc_id              = aws_vpc.main.id

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

# Security group rules for Data Layer
resource "aws_security_group_rule" "inbound-nfs-port" {
    description          = "Allow NFS traffic from Webserver" 
    type                 = "ingress"
    from_port            = 2049
    to_port              = 2049
    protocol             = "tcp"
    source_security_group_id = aws_security_group.webserver-sg.id # Allow traffic from webserver security group 
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
 
