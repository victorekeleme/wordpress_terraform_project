resource "aws_nat_gateway" "wordpress_natgw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name        = "${local.project}-natgw"
    Environment = local.env[0]
  }

  depends_on = [aws_internet_gateway.wordpress_igw]
}