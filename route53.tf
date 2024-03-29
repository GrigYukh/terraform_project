# Создание Route53

resource "aws_route53_record" "gryukhanyan" {
  zone_id = "Z10299161M47DBD68JOWT"
  name    = "gryukhanyan"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.grig_alb.dns_name]
}