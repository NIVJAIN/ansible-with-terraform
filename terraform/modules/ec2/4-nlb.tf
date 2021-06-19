resource "aws_lb" "nlb_load_balancer" {
#   name                              = "test-network-lb" #can also be obtained from the variable nlb_config
  # name = lookup(var.nlb_config,"name")
name = "${var.project_name}-NLB"
  load_balancer_type                = "network"
  # subnet_mapping {
  #   # subnet_id     = lookup(var.nlb_config,"subnet")
  #   subnet_id     = [var.public_subnets]
  #   # allocation_id = aws_eip.eip_nlb.id
  # }
  subnets     = var.public_subnets
  # tags = {
  #   Environment = lookup(var.nlb_config,"environment")
  # }
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.nlb_load_balancer.arn
  for_each = var.forwarding_config
      port                = each.key
      protocol            = each.value
      default_action {
        target_group_arn = "${aws_lb_target_group.tg[each.key].arn}"
        type             = "forward"
      }
}
resource "aws_lb_target_group" "tg" {
  for_each = var.forwarding_config
    #this give error of 32 characters long # name = "${lookup(var.nlb_config, "environment")}-tg-${lookup(var.tg_config, "name")}-${each.key}"
    name = "${var.project_name}-${each.key}"
    # name                  = "${lookup(var.tg_config, "name")}-${each.key}"
    port                  = each.key
    protocol              = each.value
  # vpc_id                  = lookup(var.tg_config, "tg_vpc_id")
  vpc_id = var.vpc_id
  target_type             = lookup(var.tg_config, "target_type")
  deregistration_delay    = 90
health_check {
    interval            = 30
    port                = each.value != "TCP_UDP" ? each.key : 80
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Environment = "test"
  }
}
resource "aws_lb_target_group_attachment" "tga1" {
  for_each = var.forwarding_config
    target_group_arn  = "${aws_lb_target_group.tg[each.key].arn}"
    port              = each.key
  # target_id           = lookup(var.tg_config,"target_id1")
  target_id = aws_instance.nginx.id
}

resource "aws_route53_record" "nlb_loadbalancer" {
  name    = "${var.domain_host_name}.${var.domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.ecs_domain.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.nlb_load_balancer.dns_name
    zone_id                = aws_lb.nlb_load_balancer.zone_id
  }
}

data "aws_network_interface" "example_lb" {
  for_each = toset(var.public_subnets)

  filter {
    name   = "description"
    values = ["ELB ${aws_lb.nlb_load_balancer.arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}