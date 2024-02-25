locals {
  cluster_role                     = aws_iam_role.cluster_role.arn
  create_cluster_sg                = var.create_cluster_security_group
  cluster_security_group_id        = local.create_cluster_sg ? aws_security_group.cluster[0].id : var.cluster_security_group_id
  cluster_sg_name                  = upper("SECURITY_GROUP_FOR_${var.cluster_name}")
  enable_cluster_encryption_config = length(var.cluster_encryption_config) > 0
  dns_suffix                       = coalesce(var.cluster_iam_role_dns_suffix, data.aws_partition.current.dns_suffix)
  tags                             = merge({ "Name" = upper(var.cluster_name), "ManagedBy" = "Terraform" }, var.tags)
}