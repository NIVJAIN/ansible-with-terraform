data "aws_route53_zone" "ecs_domain" {
  name         = var.domain_name
  private_zone = false
}

data "aws_acm_certificate" "ecs_domain_certificate" {
  domain      = "*.${var.domain_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_route53_record" "ecs_load_balancer_record" {
  for_each = var.hosts2
  name    = "${each.key}.${var.domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.ecs_domain.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
  }
}



# resource "aws_route53_record" "ecs_load_balancer_record" {
#   count = length(values(var.services_map))
#   /* name    = "${local.domain_host_name}.${local.domain_name}" */
#   name    = "${element(keys(var.services_map), count.index)}.${local.domain_name}"
#   type    = "A"
#   zone_id = data.aws_route53_zone.ecs_domain.zone_id

#   alias {
#     evaluate_target_health = false
#     name                   = aws_alb.alb.dns_name
#     zone_id                = aws_alb.alb.zone_id
#   }
# }