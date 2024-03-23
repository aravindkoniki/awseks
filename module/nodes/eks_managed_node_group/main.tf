resource "aws_eks_node_group" "node_group" {
  count = var.create ? 1 : 0

  # Required
  cluster_name  = var.cluster_name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = var.enable_efa_support ? data.aws_subnets.efa[0].ids : var.subnet_ids

  scaling_config {
    min_size     = var.min_size
    max_size     = var.max_size
    desired_size = var.desired_size
  }

  # Optional
  node_group_name        = var.name
  node_group_name_prefix = "${var.name == "" ? "eks" : var.name}-"

  # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
  ami_type        = var.ami_id != "" ? null : var.ami_type
  release_version = var.ami_id != "" ? null : var.use_latest_ami_release_version ? local.latest_ami_release_version : var.ami_release_version
  version         = var.ami_id != "" ? null : var.cluster_version

  capacity_type        = var.capacity_type
  disk_size            = var.use_custom_launch_template ? null : var.disk_size # if using a custom LT, set disk size on custom LT or else it will error here
  force_update_version = var.force_update_version
  instance_types       = var.instance_types
  labels               = var.labels

  dynamic "launch_template" {
    for_each = var.use_custom_launch_template ? [1] : []

    content {
      id      = local.launch_template_id
      version = local.launch_template_version
    }
  }

  dynamic "remote_access" {
    for_each = length(var.remote_access) > 0 ? [var.remote_access] : []

    content {
      ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
      source_security_group_ids = try(remote_access.value.source_security_group_ids, [])
    }
  }

  dynamic "taint" {
    for_each = var.taints

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = length(var.update_config) > 0 ? [var.update_config] : []

    content {
      max_unavailable_percentage = try(update_config.value.max_unavailable_percentage, null)
      max_unavailable            = try(update_config.value.max_unavailable, null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = merge(local.tags, { Name = var.name })
}

# Placement Group
resource "aws_placement_group" "placement_group" {
  count    = var.create && (var.enable_efa_support || var.create_placement_group) ? 1 : 0
  name     = "${var.cluster_name}-${var.name}"
  strategy = var.placement_group_strategy
  tags     = local.tags
}

# Autoscaling Group Schedule
resource "aws_autoscaling_schedule" "autoscaling" {
  for_each               = { for k, v in var.schedules : k => v if var.create && var.create_schedule }
  scheduled_action_name  = each.key
  autoscaling_group_name = aws_eks_node_group.node_group[0].resources[0].autoscaling_groups[0].name
  min_size               = try(each.value.min_size, null)
  max_size               = try(each.value.max_size, null)
  desired_capacity       = try(each.value.desired_size, null)
  start_time             = try(each.value.start_time, null)
  end_time               = try(each.value.end_time, null)
  time_zone              = try(each.value.time_zone, null)

  # [Minute] [Hour] [Day_of_Month] [Month_of_Year] [Day_of_Week]
  # Cron examples: https://crontab.guru/examples.html
  recurrence = try(each.value.recurrence, null)
}
