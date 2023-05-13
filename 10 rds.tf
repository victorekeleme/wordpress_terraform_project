resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 10
  db_name                = "${local.project}_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  username               = local.db_credentials.username
  password               = local.db_credentials.password
  parameter_group_name   = aws_db_parameter_group.wordpress_db_para_grp.name
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db_sub_grp.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  skip_final_snapshot    = true

  tags = {
    Name        = "${local.project}-db"
    Environment = local.env[0]
  }
}

resource "aws_db_subnet_group" "wordpress_db_sub_grp" {
  name       = "${local.project}-db-sub-grp"
  subnet_ids = [for subnet in aws_subnet.db_subnet : subnet.id]

  tags = {
    Name        = "${local.project}-db-subnet-group"
    Environment = local.env[0]
  }
}

resource "aws_db_parameter_group" "wordpress_db_para_grp" {
  name        = "${local.project}-db-para-grp"
  family      = "mysql5.7"
  description = "RDS default parameter group"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = {
    Name        = "${local.project}-db-para-grp"
    Environment = local.env[0]
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${local.project}-rds-sg"
  vpc_id = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.rds_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project}-rds-sg"
    Environment = local.env[0]
  }

}