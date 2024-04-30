# Create NAT Gateway
resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT1"
  }
}
resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "NAT2"
  }
}
