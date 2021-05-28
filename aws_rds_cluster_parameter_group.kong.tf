resource "aws_rds_cluster_parameter_group" "kong" {
  count = var.enable_aurora && var.db_instance_count > 0 ? 1 : 0

  name        = format("%s-%s-cluster", var.service, var.environment)
  family      = var.db_family
  description = var.description

  tags = merge(
    {
      "Name"        = format("%s-%s-cluster", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}
