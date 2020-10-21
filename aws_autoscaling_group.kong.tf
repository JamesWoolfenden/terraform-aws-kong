
resource "aws_autoscaling_group" "kong" {
  name                = format("%s-%s", var.service, var.environment)
  vpc_zone_identifier = data.aws_subnet_ids.private.ids

  launch_configuration = aws_launch_configuration.kong.name

  desired_capacity          = var.asg_desired_capacity
  force_delete              = false
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = "ELB"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size

  target_group_arns = compact(
    concat(
      aws_lb_target_group.external.*.arn,
      aws_lb_target_group.internal.*.arn,
      aws_lb_target_group.admin.*.arn,
      aws_lb_target_group.manager.*.arn,
      aws_lb_target_group.portal-gui.*.arn,
      aws_lb_target_group.portal.*.arn
    )
  )

  tag {
    key                 = "Name"
    value               = format("%s-%s", var.service, var.environment)
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Description"
    value               = var.description
    propagate_at_launch = true
  }
  tag {
    key                 = "Service"
    value               = var.service
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_db_instance.kong,
    aws_rds_cluster.kong
  ]
}
