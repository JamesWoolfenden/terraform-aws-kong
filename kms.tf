resource "aws_kms_key" "kong" {
  description = format("%s-%s", var.service, var.environment)

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
  enable_key_rotation = true
}

resource "aws_kms_alias" "kong" {
  name          = format("alias/%s-%s", var.service, var.environment)
  target_key_id = aws_kms_key.kong.key_id
}
