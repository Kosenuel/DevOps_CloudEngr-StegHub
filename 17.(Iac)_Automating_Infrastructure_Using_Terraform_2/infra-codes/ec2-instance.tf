# Create an EC2 instance for the Bastion Host
resource "aws_instance" "bastion-host" {
    ami                 = "ami-091f18e98bc129c4e"
    instance_type            = "t2.micro"
    subnet_id           = aws_subnet.public[0].id
    security_groups     = [aws_security_group.bastion-sg.id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "Bastion-Host"
        }
    )
    depends_on          = [aws_security_group.bastion-sg]
}

# Output the Bastion Host's Public IP for easy access
output "bastion_public_ip" {
    value   = aws_instance.bastion-host.public_ip
}


# Create an EC2 instance for the Testing purposes
resource "aws_instance" "test-serv" {
    ami                 = var.ami_id
    instance_type            = "t3.medium"
    subnet_id           = aws_subnet.public[0].id
    security_groups     = [aws_security_group.bastion-sg.id, aws_security_group.webserver-sg.id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "Test-Server"
        }
    )
    depends_on          = [aws_security_group.bastion-sg]
    # user_data = base64encode(data.template_file.tooling_userdata.rendered)
    user_data = base64encode(local.tooling_userdata)
}

# Output the Bastion Host's Public IP for easy access
output "test-serv_public_ip" {
    value   = aws_instance.test-serv.public_ip
}