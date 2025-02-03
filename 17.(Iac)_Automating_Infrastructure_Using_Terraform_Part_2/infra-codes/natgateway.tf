# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP", var.tags["Environment"])
    }
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public[*].id, 0)
  depends_on    = [aws_internet_gateway.igw] # Ensure this is a list

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s", var.tags["Environment"], "NAT-Gateway")
    }
  )
}
