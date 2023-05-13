resource "aws_vpc" "wordpress_vpc" {

  cidr_block = var.vpc_cidr_block

  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = {
    Name        = "${local.project}-vpc"
    Environment = local.env[0]
  }
}