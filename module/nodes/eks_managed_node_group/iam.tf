resource "aws_iam_role" "node_role" {
  name        = "${upper(var.cluster_name == null ? "EKS" : var.cluster_name)}_MANAGED_NODE_GROUP_ROLE"
  path        = "/"
  description = "Managed Node group IAM role for ${var.cluster_name == null ? "EKS" : var.cluster_name}"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = local.tags
}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each = { for k, v in merge(
    {
      AmazonEKSWorkerNodePolicy          = "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy"
      AmazonEC2ContainerRegistryReadOnly = "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly"
    },
    local.ipv4_cni_policy,
    local.ipv6_cni_policy
  ) : k => v }

  policy_arn = each.value
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v }

  policy_arn = each.value
  role       = aws_iam_role.node_role.name
}
