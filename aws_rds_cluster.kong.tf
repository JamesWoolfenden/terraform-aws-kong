resource "aws_rds_cluster" "kong" {
  # checkov:skip=CKV2_AWS_8: ADD REASON
  # checkov:skip=CKV_AWS_128
  # checkov:skip=CKV_AWS_139
  # checkov:skip=CKV_AWS_162
  count = var.enable_aurora && var.db_instance_count > 0 ? 1 : 0

  cluster_identifier = format("%s-%s", var.service, var.environment)
  engine             = "aurora-postgresql"
  engine_version     = var.db_engine_version
  engine_mode        = var.db_engine_mode
  master_username    = var.db_username
  master_password    = random_string.master_password.result
  storage_encrypted  = true

  backup_retention_period         = var.db_backup_retention_period
  db_subnet_group_name            = var.db_subnets
  db_cluster_parameter_group_name = format("%s-%s-cluster", var.service, var.environment)

  vpc_security_group_ids = [aws_security_group.postgresql.id]

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
