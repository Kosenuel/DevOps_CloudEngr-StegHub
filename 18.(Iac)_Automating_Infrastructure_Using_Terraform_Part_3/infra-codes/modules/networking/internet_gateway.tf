resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s", aws_vpc.main.tags["Name"], "IGW")
    }
  )
}