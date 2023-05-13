resource "aws_instance" "baiston_host" {
  depends_on                  = [aws_db_instance.wordpress_db, aws_efs_file_system.wordpress_efs, aws_efs_mount_target.wordpress_efs_mt]
  ami                         = data.aws_ami.wordpress_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet[0].id
  security_groups             = [aws_security_group.baiston_sg.id]
  availability_zone           = var.avail_zone[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
  count                       = 1

  tags = {
    Name        = "${local.project}-baiston-host"
    Environment = local.env[0]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "baiston_sg" {
  name   = "${local.project}-baiston-sg"
  vpc_id = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.baiston_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project}-baiston-sg"
    Environment = local.env[0]
  }

}



