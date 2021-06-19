resource "aws_alb" "alb" {
  depends_on         = [aws_security_group.alb]
  name               = format("%s-%s", local.name, "alb")
  subnets            = local.public_subnets
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  internal           = false
  idle_timeout       = 80 #default is 60 
  tags = {
    Name = "terraform-ansible-alb-tf"
  }
  #   access_logs {    
  #     bucket = "${var.s3_bucket}"    
  #     prefix = "ELB-logs"  
  #   }
}

resource "aws_alb_target_group" "alb_target_group" {
  count     = "${length(keys(var.services_map))}"
  name      = "${element(keys(var.services_map), count.index)}-Dev"
  port      = "${element(values(var.services_map), count.index)}"
  protocol  = "HTTP"
  vpc_id    = local.vpc_id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.id}"
  
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.ecs_domain_certificate.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.0.arn}"
    type             = "forward"
  }
}


resource "aws_alb_listener_rule" "alb_listener_rabbitmq" {
  depends_on   = [aws_alb.alb]
  count         = "${length(values(var.services_map))}"
  listener_arn = aws_alb_listener.alb_listener.arn

  action {
    /* target_group_arn = aws_alb_target_group.rabbitmq_alb_target_group.arn */
    target_group_arn = "${element(aws_alb_target_group.alb_target_group.*.arn, count.index)}"
    type             = "forward"
  }
  condition {
    host_header {
    /* field = "host-header" */
      /* values = ["${lower(local.ecs_service_name)}.${data.terraform_remote_state.platform.outputs.ecs_domain_name}"] */
      /* values = ["${each.value.tags.Name}.${local.domain_name}"] */
      # values = ["${lower(local.ecs_service_name)}.vama-dsl.com"]
      #  values = ["${element(values(var.services_map), count.index)}.${var.domain}"]
      values = ["${element(keys(var.services_map), count.index)}.${local.domain_name}"]
    }
  }
}

resource "aws_lb_listener" "redirect-http-https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

/* 
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.nginx.id
  port             = 8080
} */

resource "aws_alb_target_group_attachment" "test" {
  count         = "${length(values(var.services_map))}"
  target_group_arn = "${element(aws_alb_target_group.alb_target_group.*.arn, count.index)}"
  /* target_id        = "${element(var.instance_list, count.index)}"  only for multiple instaces*/
  target_id        = aws_instance.nginx.id
  port             = "${element(values(var.services_map), count.index)}"
}

output "aws_alb" {
  value = aws_alb.alb.dns_name
}