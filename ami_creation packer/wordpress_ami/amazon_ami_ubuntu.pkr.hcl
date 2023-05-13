source "amazon-ebs" "aws_ubuntu" {
  region        = "us-east-2"
  instance_type = "t2.micro"
  ami_name      = "wordpress_ami_{{timestamp}}"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  ssh_username = "ubuntu"
}