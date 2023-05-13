resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = "${local.project}-asg"
  launch_configuration      = aws_launch_configuration.wordpress_lc.id
  vpc_zone_identifier       = [for subnet in aws_subnet.private_subnet : subnet.id]
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  force_delete              = true
  health_check_type         = "EC2"
  health_check_grace_period = 300

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "${local.project}-asg"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "wordpress_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  lb_target_group_arn    = aws_lb_target_group.wordpress_instance_tg.arn
}