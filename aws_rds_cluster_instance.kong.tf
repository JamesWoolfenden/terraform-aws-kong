resource "aws_rds_cluster_instance" "kong" {
  count = var.enable_aurora ? var.db_instance_count : 0

  identifier              = format("%s-%s-%s", var.service, var.environment, count.index)
  cluster_identifier      = aws_rds_cluster.kong[0].id
  engine                  = "aurora-postgresql"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  monitoring_interval     = 60
  db_subnet_group_name    = var.db_subnets
  db_parameter_group_name = format("%s-%s", var.service, var.environment)

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}
