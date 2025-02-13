
# Output the Bastion Host's Public IP for easy access
output "bastion_public_ip" {
    value   = aws_instance.bastion-host.public_ip
}

# Output the Test Server's Public IP for easy access
output "test-serv_public_ip" {
    value   = aws_instance.test-serv.public_ip
}