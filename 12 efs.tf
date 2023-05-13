resource "aws_efs_file_system" "wordpress_efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name        = "${local.project}-efs"
    Environment = local.env[0]
  }
}

resource "aws_efs_mount_target" "wordpress_efs_mt" {
  count           = length(aws_subnet.private_subnet[*].id)
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.private_subnet[count.index].id
  security_groups = [aws_security_group.wordpress_efs_sg.id]

}

resource "aws_security_group" "wordpress_efs_sg" {
  name   = "${local.project}-efs-sg"
  vpc_id = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.efs_ingress_ports
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
    Name        = "${local.project}-efs-sg"
    Environment = local.env[0]
  }

}
