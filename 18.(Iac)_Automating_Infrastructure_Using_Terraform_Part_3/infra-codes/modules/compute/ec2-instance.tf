# Create an EC2 instance for the Bastion Host
resource "aws_instance" "bastion-host" {
    ami                 = "ami-091f18e98bc129c4e"
    instance_type       = "t2.micro"
    subnet_id           = var.public_subnets[0].id
    security_groups     = [var.bastion-sg_id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "Bastion-Host"
        }
    )
    # depends_on          = [module.security]
}


# Create an EC2 instance for the Testing purposes
resource "aws_instance" "test-serv" {
    ami                 = lookup(var.images, var.region, "ami-0aa938b5c246ef111")
    instance_type       = "t3.medium"
    subnet_id           = var.public_subnets[0].id
    security_groups     = [var.bastion-sg_id, var.webserver-sg_id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "Test-Server"
        }
    )
    # depends_on          = [module.security]
    # user_data = base64encode(data.template_file.tooling_userdata.rendered)
    user_data = base64encode(local.tooling_userdata)
}

