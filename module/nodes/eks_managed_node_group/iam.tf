resource "aws_iam_role" "node_role" {
  name        = "${upper(var.cluster_name == null ? "EKS" : var.cluster_name)}_MANAGED_NODE_GROUP_ROLE"
  path        = "/"
  description = "Managed Node group IAM role for ${var.cluster_name == null ? "EKS" : var.cluster_name}"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = local.tags
}
