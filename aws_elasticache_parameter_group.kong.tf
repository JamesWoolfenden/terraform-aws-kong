resource "aws_elasticache_parameter_group" "kong" {
  name   = format("%s-%s", var.service, var.environment)
  family = var.redis_family

  description = var.description
}
