resource "aws_db_instance" "kong" {
  # checkov:skip=CKV_AWS_129: ADD REASON
  # checkov:skip=CKV_AWS_118: ADD REASON
  # checkov:skip=CKV_AWS_161:THIRD PARTY
  count      = local.enable_rds ? 1 : 0
  identifier = format("%s-%s", var.service, var.environment)


  engine            = "postgres"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage_size
  storage_type      = "gp2"

  backup_retention_period = var.db_backup_retention_period
  db_subnet_group_name    = var.db_subnets
  multi_az                = true
  parameter_group_name    = format("%s-%s", var.service, var.environment)
  storage_encrypted       = true

  username = "root"
  password = random_string.master_password.result

  vpc_security_group_ids = [aws_security_group.postgresql.id]

  skip_final_snapshot       = var.db_final_snapshot_identifier == "" ? true : false
  final_snapshot_identifier = var.db_final_snapshot_identifier == "" ? null : var.db_final_snapshot_identifier

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
  depends_on = [aws_db_parameter_group.kong]
}
