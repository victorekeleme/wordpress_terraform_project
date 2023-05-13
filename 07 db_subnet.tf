resource "aws_subnet" "db_subnet" {
  cidr_block        = var.sub_cidr_block.database[count.index]
  vpc_id            = aws_vpc.wordpress_vpc.id
  availability_zone = var.avail_zone[count.index]
  count             = 2

  tags = {
    Name        = "${local.project}-db_sub-${count.index}"
    Environment = local.env[0]
  }

}

resource "aws_route_table" "db_subnet_rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name        = "${local.project}-db_sub_rtb"
    Environment = local.env[0]
  }
}

resource "aws_route_table_association" "db_subnet_rtb_asc" {
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_subnet_rtb.id
  count          = length(aws_subnet.db_subnet[*].id)
}