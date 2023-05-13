resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name        = "${local.project}-igw"
    Environment = local.env[0]
  }
}