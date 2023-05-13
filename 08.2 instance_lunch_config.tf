resource "aws_launch_configuration" "wordpress_lc" {
  depends_on      = [aws_db_instance.wordpress_db, aws_efs_file_system.wordpress_efs]
  name_prefix     = "${local.project}-lc"
  image_id        = data.aws_ami.wordpress_ami.id
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.wordpress_lc_sg.id]
  key_name        = aws_key_pair.ssh_key.key_name

  user_data = data.template_cloudinit_config.config.rendered


  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "wordpress_lc_sg" {
  name   = "${local.project}-lc-sg"
  vpc_id = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.lc_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sub_cidr_block.public[0]]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project}-lc-sg"
    Environment = local.env[0]
  }
}



