output "private_subnets" {
    value = aws_subnet.private
}

output "public_subnets" {
    value = aws_subnet.public

}

output "vpc_id" {
    value = aws_vpc.main.id
}
