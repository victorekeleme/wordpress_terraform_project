data "aws_availability_zones" "all_azs" {}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["amazon"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ami" "wordpress_ami" {
  most_recent = true
  owners      = ["524360703326"] # Canonical
  filter {
    name   = "name"
    values = ["wordpress_ami_*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "prometheus_ami" {
  most_recent = true
  owners      = ["524360703326"] # Canonical
  filter {
    name   = "name"
    values = ["prometheus_ami_*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}