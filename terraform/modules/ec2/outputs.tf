output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}