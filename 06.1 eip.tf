resource "aws_eip" "nat_gw_eip" {
  vpc = true
}