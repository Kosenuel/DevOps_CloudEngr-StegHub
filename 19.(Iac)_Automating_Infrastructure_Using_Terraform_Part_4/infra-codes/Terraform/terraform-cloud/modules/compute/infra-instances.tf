# Create instance for Jenkins Server
# resource "aws_instance" "jenkins" {
#     ami = var.ami-jenkins
#     instance_type = "t2.micro"
#     subnet_id = var.compute-subnet
#     security_groups = [var.compute-sg_id]
#     associate_public_ip_address = true
#     key_name = var.key_name

#     tags = merge(
#         var.tags,
#         {
#             Name = "ACS_Jenkins"
#         }
#     )
# }

# # Create instance for Artifactory Server
# resource "aws_instance" "artifactory" {
#     ami = var.ami-jfrog
#     instance_type = "t2.medium"
#     subnet_id = var.compute-subnet
#     security_groups = [var.compute-sg_id]
#     associate_public_ip_address = true
#     key_name = var.key_name

#     tags = merge(
#         var.tags,
#         {
#             Name = "ACS_Artifactory"
#         }
#     )
# }

# # Create instance for SonarQube Server
# resource "aws_instance" "sonarqube" {
#     ami = var.ami-sonar
#     instance_type = "t2.medium"
#     subnet_id = var.compute-subnet
#     security_groups = [var.compute-sg_id]
#     associate_public_ip_address = true
#     key_name = var.key_name

#     tags = merge(
#         var.tags,
#         {
#             Name = "ACS_SonarQube"
#         }
#     )
# }


# Create an EC2 instance for the Bastion Host
resource "aws_instance" "bastion-host" {
    ami                 = var.ami-bastion
    instance_type       = "t3.medium"
    subnet_id           = var.public_subnets[0].id
    security_groups     = [var.bastion-sg_id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "ACS_bastion"
        }
    )
    # depends_on          = [module.security]
}


# Create an EC2 instance for the Testing purposes
resource "aws_instance" "test-serv" {
    ami                 = var.ami-web
    instance_type       = "t2.medium"
    subnet_id           = var.public_subnets[0].id
    security_groups     = [var.bastion-sg_id, var.webserver-sg_id]

    associate_public_ip_address = true
    key_name            = var.key_name
    
    tags = merge(
        var.tags,
        {
            Name        = "ACS_tooling"
            name        = "ACS_Test-Server"
        }
    )
    # depends_on          = [module.security]
    # user_data = base64encode(data.template_file.tooling_userdata.rendered)
    # user_data = base64encode(local.tooling_userdata)
}

