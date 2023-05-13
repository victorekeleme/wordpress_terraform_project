resource "aws_lb" "wordpress_alb" {
  name               = "${local.project}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  tags = {
    Name        = "${local.project}-alb"
    Environment = local.env[0]
  }

}

resource "aws_security_group" "wordpress_alb_sg" {
  name   = "${local.project}-alb-sg"
  vpc_id = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.alb_ingress_ports
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
    Name        = "${local.project}-alb-sg"
    Environment = local.env[0]
  }
}

resource "aws_lb_target_group" "wordpress_instance_tg" {
  name        = "${local.project}-tg"
  port        = var.application_server_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.wordpress_vpc.id
  stickiness {
    type = "lb_cookie"
    cookie_name = "lb_cookie"
    cookie_duration = 900
    enabled = true
  }

  health_check {
    path                = "/"
    port                = var.application_server_port
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
    interval            = 30
    timeout             = 20
  }
}

resource "aws_lb_listener" "wordpress_alb_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_instance_tg.arn
  }
}


resource "aws_lb_target_group" "monitoring_instance_tg" {
  name        = "${local.project}-monitoring-tg"
  port        = var.monitoring_server_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.wordpress_vpc.id

  health_check {
    path                = "/"
    port                = var.monitoring_server_port
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
    interval            = 30
    timeout             = 20
  }
}

resource "aws_lb_listener" "monitoring_alb_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "9090"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monitoring_instance_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "monitoring_tg_ath" {
  target_group_arn = aws_lb_target_group.monitoring_instance_tg.arn
  target_id        = aws_instance.monitoring_instance.id
  port             = var.monitoring_server_port
}