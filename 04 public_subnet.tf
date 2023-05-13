resource "aws_subnet" "public_subnet" {
  cidr_block        = var.sub_cidr_block.public[count.index]
  vpc_id            = aws_vpc.wordpress_vpc.id
  availability_zone = var.avail_zone[count.index]
  count             = 2

  tags = {
    Name        = "${local.project}-pub_sub-${count.index}"
    Environment = local.env[0]
  }

}

resource "aws_route_table" "public_subnet_rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }
  tags = {
    Name        = "${local.project}-pub_sub_rtb"
    Environment = local.env[0]
  }
}

resource "aws_route_table_association" "public_subnet_rtb_asc" {
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_rtb.id
  count          = length(aws_subnet.public_subnet[*].id)
}