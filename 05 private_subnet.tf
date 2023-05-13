resource "aws_subnet" "private_subnet" {
  cidr_block        = var.sub_cidr_block.private[count.index]
  vpc_id            = aws_vpc.wordpress_vpc.id
  availability_zone = var.avail_zone[count.index]
  count             = 2

  tags = {
    Name        = "${local.project}-priv_sub-${count.index}"
    Environment = local.env[0]
  }

}

resource "aws_route_table" "private_subnet_rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wordpress_natgw.id
  }

  tags = {
    Name        = "${local.project}-priv_sub_rtb"
    Environment = local.env[0]
  }
}

resource "aws_route_table_association" "private_subnet_rtb_asc" {
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_rtb.id
  count          = length(aws_subnet.private_subnet[*].id)
}