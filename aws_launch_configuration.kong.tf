resource "aws_launch_configuration" "kong" {
  name_prefix          = format("%s-%s-", var.service, var.environment)
  image_id             = var.ec2_ami[data.aws_region.current.name]
  instance_type        = var.ec2_instance_type
  iam_instance_profile = aws_iam_instance_profile.kong.name
  key_name             = var.ec2_key_name

  security_groups = [
    data.aws_security_group.default.id,
    aws_security_group.kong.id,
  ]

  associate_public_ip_address = false
  enable_monitoring           = true
  placement_tenancy           = "default"
  user_data                   = data.template_cloudinit_config.cloud-init.rendered

  root_block_device {
    encrypted   = true
    volume_size = var.ec2_root_volume_size
    volume_type = var.ec2_root_volume_type
  }

  lifecycle {
    create_before_destroy = true
  }
}
