output "database_name" {
  value = aws_db_instance.wordpress_db.db_name
}

output "database_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}

output "database_user" {
  value = aws_db_instance.wordpress_db.username
}

output "load_balancer_dns" {
  value = aws_lb.wordpress_alb.dns_name
}

output "baiston_host_public_ip" {
  value = aws_instance.baiston_host.public_ip
}


