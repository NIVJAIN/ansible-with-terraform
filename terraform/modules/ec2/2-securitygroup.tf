## Security Group for ELB
resource "aws_security_group" "alb" {
  name   = "${var.project_name}-ALB-SG"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx" {
  depends_on = [aws_security_group.alb]
  name   = "${var.project_name}-EC2-SG"
  vpc_id     = var.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # cidr_blocks = ["116.86.133.133/32"]
    cidr_blocks = var.client_laptops_ip
  }
   ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    # security_groups = [aws_security_group.alb.id]
    cidr_blocks = formatlist("%s/32", [for eni in data.aws_network_interface.example_lb : eni.private_ip])
  }
  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    # cidr_blocks = ["116.86.133.133/32"]
    cidr_blocks = var.client_laptops_ip
  }
  ingress {
    from_port       = 15672
    to_port         = 15672
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    # cidr_blocks     = ["116.86.133.133/32"]
    cidr_blocks = var.client_laptops_ip
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
    ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
    ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.client_laptops_ip
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    # security_groups = ["sg-021bf7f871be99f3e", "sg-05057e074f565c0fa", "sg-0cc362e87c48e58ce"]
    security_groups = var.jump_host_security_group
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["10.196.250.8/32"]
    cidr_blocks = var.jump_hosts_ip
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

